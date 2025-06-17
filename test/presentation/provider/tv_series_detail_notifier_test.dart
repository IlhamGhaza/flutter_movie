import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_detail_notifier_test.mocks.dart';

extension TvSeriesDetailX on TvSeriesDetail {
  TvSeries toTvSeries() {
    int safeId;
    try {
      if (id is int) {
        safeId = id as int;
      } else {
        safeId = 0;
      }
    } catch (e) {
      safeId = 0;
    }

    return TvSeries(
      id: safeId,
      title: name,
      name: name,
      overview: overview,
      posterPath: posterPath ?? '',
      voteAverage: voteAverage,
      genreIds: genres.map((e) => e.id).toList(),
      firstAirDate: firstAirDate,
      popularity: popularity,
      voteCount: voteCount,
      backdropPath: backdropPath ?? '',
      originalLanguage: originalLanguage,
      originalName: originalName,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
    );
  }
}

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
  GetWatchListStatusTvSeries,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;
  late MockGetWatchListStatusTvSeries mockGetWatchlistStatus;
  late TvSeriesDetail testTvSeriesDetail;
  late List<TvSeries> testRecommendations;
  final testId = 1;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    mockGetWatchlistStatus = MockGetWatchListStatusTvSeries();

    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchListStatus: mockGetWatchlistStatus,
    );

    testTvSeriesDetail = TvSeriesDetail(
      id: 1,
      name: 'Test TV Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      backdropPath: '/test.jpg',
      voteAverage: 8.0,
      firstAirDate: '2023-01-01',
      genres: [
        const Genre(id: 1, name: 'Drama'),
      ],
      numberOfSeasons: 1,
      numberOfEpisodes: 10,
      originalName: 'Test TV Series',
      adult: false,
      episodeRunTime: const [60],
      originCountry: const ['US'],
      originalLanguage: 'en',
      popularity: 100.0,
      status: 'Returning Series',
      tagline: 'Test Tagline',
      type: 'Scripted',
      voteCount: 100,
    );

    testRecommendations = [
      TvSeries(
        id: 1,
        title: 'Test TV Series',
        name: 'Test TV Series',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        genreIds: [1, 2, 3],
        firstAirDate: '2023-01-01',
        popularity: 100.0,
        voteCount: 100,
        backdropPath: '/test.jpg',
        originalLanguage: 'en',
        originalName: 'Test TV Series',
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
      ),
    ];
  });

  group('Fetch TV Series Detail', () {
    test('should get data from the usecase when fetchTvSeriesDetail is called',
        () async {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testRecommendations));
      when(mockGetWatchlistStatus.execute(testId))
          .thenAnswer((_) async => false);

      await provider.fetchTvSeriesDetail(testId);

      verify(mockGetTvSeriesDetail.execute(testId));
      verify(mockGetTvSeriesRecommendations.execute(testId));
      verify(mockGetWatchlistStatus.execute(testId));
    });

    test('should update state to loaded when fetchTvSeriesDetail succeeds',
        () async {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testRecommendations));
      when(mockGetWatchlistStatus.execute(testId))
          .thenAnswer((_) async => false);

      await provider.fetchTvSeriesDetail(testId);

      expect(provider.detailState, RequestState.Loaded);
      expect(provider.recommendationsState, RequestState.Loaded);
      expect(provider.tvSeriesDetail, testTvSeriesDetail);
      expect(provider.recommendations, testRecommendations);
      expect(provider.isAddedToWatchlist, false);
      expect(provider.message, '');
      expect(provider.recommendationsMessage, '');
    });

    test('should update state to error when fetchTvSeriesDetail fails',
        () async {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testRecommendations));

      await provider.fetchTvSeriesDetail(testId);

      expect(provider.detailState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(provider.tvSeriesDetail, null);
    });

    test(
        'should update recommendations state to error when fetch recommendations fails',
        () async {
      when(mockGetTvSeriesDetail.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetWatchlistStatus.execute(testId))
          .thenAnswer((_) async => false);

      await provider.fetchTvSeriesDetail(testId);

      expect(provider.recommendationsState, RequestState.Error);
      expect(provider.recommendationsMessage, 'Server Failure');
      expect(provider.recommendations, []);
    });
  });

  group('Watchlist', () {

    test('should update watchlist status when load watchlist status', () async {
      when(mockGetWatchlistStatus.execute(testId))
          .thenAnswer((_) async => true);

      await provider.loadWatchlistStatus(testId);

      verify(mockGetWatchlistStatus.execute(testId));
      expect(provider.isAddedToWatchlist, true);
    });
  });
}
