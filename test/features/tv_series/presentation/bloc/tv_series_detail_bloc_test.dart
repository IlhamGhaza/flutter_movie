import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/features/tv_series/domain/entities/episode.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_season_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
  GetTvSeriesSeasonDetail,
])
void main() {
  late TVSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;
  late MockGetTvSeriesSeasonDetail mockGetTvSeriesSeasonDetail;

  const tId = 1;
  const tSeasonNumber = 1;
  final tTvSeriesDetail = testTvSeriesDetail;
  final tTvSeries = testTvSeriesList[0];

  final tTvSeriesList = <TvSeries>[tTvSeries];
  final tSeasonDetail = SeasonDetail(
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
    episodeCount: 1,
    airDate: '2020-01-01',
    episodes: [
      Episode(
        id: 1,
        name: 'Episode 1',
        overview: 'Overview',
        stillPath: '/path.jpg',
        episodeNumber: 1,
        voteAverage: 8.0,
        voteCount: 100,
        airDate: '2020-01-01',
      ),
    ],
  );

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    mockGetTvSeriesSeasonDetail = MockGetTvSeriesSeasonDetail();

    tvSeriesDetailBloc = TVSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatus: mockGetWatchListStatusTvSeries,
      saveWatchlist: mockSaveWatchlistTvSeries,
      removeWatchlist: mockRemoveWatchlistTvSeries,
      getTvSeriesSeasonDetail: mockGetTvSeriesSeasonDetail,
    );
  });

  test('initial state should be empty', () {
    expect(tvSeriesDetailBloc.state, const TVSeriesDetailState());
  });

  group('FetchTVSeriesDetail', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        // Setup mocks
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        when(mockGetWatchListStatusTvSeries.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTVSeriesDetail(tId)),
      verify: (_) {
        // Verify all mocks were called
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
      expect: () => [
        // Loading state
        const TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loading,
          recommendationsRequestState: RequestState.Empty,
        ),
        // Loaded with TV series detail
        TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsRequestState: RequestState.Loading,
          recommendations: const [],
        ),
        // Final state with recommendations
        TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsRequestState: RequestState.Loaded,
          recommendations: tTvSeriesList,
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Error] when get tv series detail fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loading,
        ),
        const TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Error,
          tvSeriesDetailMessage: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verifyNever(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });

  group('AddToWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update watchlist status when added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(any))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        TVSeriesDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(any));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should show error message when add to watchlist fails',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(any))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed to add')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TVSeriesDetailState(
          watchlistMessage: 'Failed to add',
        ),
      ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update watchlist status when removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(any))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        const TVSeriesDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(any));
      },
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update isAddedToWatchlist when status is loaded',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(tId))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TVSeriesDetailState(isAddedToWatchlist: true),
      ],
    );
  });

  group('FetchSeasonDetail', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Loaded] when season detail is fetched successfully',
      build: () {
        when(mockGetTvSeriesSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => Right(tSeasonDetail));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchSeasonDetail(
        tvSeriesId: tId,
        seasonNumber: tSeasonNumber,
      )),
      expect: () => [
        const TVSeriesDetailState(
          seasonDetailRequestState: RequestState.Loading,
        ),
        TVSeriesDetailState(
          seasonDetailRequestState: RequestState.Loaded,
          currentSeasonDetail: tSeasonDetail,
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Error] when fetching season detail fails',
      build: () {
        when(mockGetTvSeriesSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchSeasonDetail(
        tvSeriesId: tId,
        seasonNumber: tSeasonNumber,
      )),
      expect: () => [
        const TVSeriesDetailState(
          seasonDetailRequestState: RequestState.Loading,
        ),
        const TVSeriesDetailState(
          seasonDetailRequestState: RequestState.Error,
          seasonDetailMessage: 'Server Error',
        ),
      ],
    );
  });

  group('ClearWatchlistMessage', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should clear watchlist message',
      seed: () => TVSeriesDetailState(
        watchlistMessage: 'Some message',
      ),
      build: () => tvSeriesDetailBloc,
      act: (bloc) => bloc.add(ClearWatchlistMessage()),
      expect: () => [
        TVSeriesDetailState(
          watchlistMessage: '',
        ),
      ],
    );
  });
}
