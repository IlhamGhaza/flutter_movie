import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_season_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
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
  final tTvSeries = testTvSeriesList[0];
  final tTvSeriesDetail = testTvSeriesDetail;
  final tRecommendations = <TvSeries>[tTvSeries];
  final tSeasonDetail = SeasonDetail(
    id: 1,
    name: 'Season 1',
    seasonNumber: 1,
    airDate: '2023-01-01',
    overview: 'Overview',
    posterPath: '/path.jpg',
    episodeCount: 10,
    episodes: [],
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

  group('Fetch TV Series Detail', () {
    test('should have initial state', () {
      expect(
        tvSeriesDetailBloc.state,
        const TVSeriesDetailState(),
      );
    });

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tRecommendations));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loading,
        ),
        TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsRequestState: RequestState.Loading,
        ),
        TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsRequestState: RequestState.Loaded,
          recommendations: tRecommendations,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Error] when get detail fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
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
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verifyNever(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Loaded, Error] when get recommendations fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        const TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loading,
        ),
        TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsRequestState: RequestState.Loading,
        ),
        TVSeriesDetailState(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tTvSeriesDetail,
          recommendationsRequestState: RequestState.Error,
          recommendationsMessage: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });

  group('Add To Watchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update watchlist status when added successfully',
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
      verify: (bloc) {
        verify(mockSaveWatchlistTvSeries.execute(any));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update watchlist message when add fails',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(any))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvSeriesDetail)),
      expect: () => [
        TVSeriesDetailState(
          watchlistMessage: 'Failed',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvSeries.execute(any));
      },
    );
  });

  group('Remove From Watchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update watchlist status when removed successfully',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(any))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        TVSeriesDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvSeries.execute(any));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update watchlist message when remove fails',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(any))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
      expect: () => [
        TVSeriesDetailState(
          watchlistMessage: 'Failed',
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvSeries.execute(any));
      },
    );
  });

  group('Load Watchlist Status', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update isAddedToWatchlist when status is true',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(tId))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TVSeriesDetailState(isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTvSeries.execute(tId));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should update isAddedToWatchlist when status is false',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TVSeriesDetailState(isAddedToWatchlist: false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTvSeries.execute(tId));
      },
    );
  });

  group('Fetch Season Detail', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Loaded] when season detail is gotten successfully',
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
      verify: (bloc) {
        verify(mockGetTvSeriesSeasonDetail.execute(tId, tSeasonNumber));
      },
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should emit [Loading, Error] when get season detail fails',
      build: () {
        when(mockGetTvSeriesSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
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
          seasonDetailMessage: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesSeasonDetail.execute(tId, tSeasonNumber));
      },
    );
  });

  group('Clear Watchlist Message', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'should clear watchlist message',
      build: () => tvSeriesDetailBloc,
      seed: () => TVSeriesDetailState(
        watchlistMessage: 'Some message',
      ),
      act: (bloc) => bloc.add(ClearWatchlistMessage()),
      expect: () => [
        const TVSeriesDetailState(
          watchlistMessage: '',
        ),
      ],
    );
  });
}