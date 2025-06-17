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

// Extension to convert TvSeriesDetail to TvSeries for testing
extension TvSeriesDetailX on TvSeriesDetail {
  TvSeries toTvSeries() {
    return TvSeries(
      id: this.id,
      title: name,
      overview: overview,
      posterPath: posterPath ?? '',
      voteAverage: voteAverage,
      genreIds: genres.map((genre) => genre.id).toList(),
      firstAirDate: firstAirDate,
      popularity: popularity,
      voteCount: voteCount,
      backdropPath: backdropPath ?? '',
      originalLanguage: originalLanguage,
      originalName: originalName,
      name: name,
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
    test('should add to watchlist when addWatchlist is called', () async {
      when(mockSaveWatchlist.execute(any))
          .thenAnswer((_) async => const Right('Added to Watchlist'));

      await provider.addWatchlist(testTvSeriesDetail);

      verify(mockSaveWatchlist.execute(any));
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(provider.isAddedToWatchlist, true);
    });

    test('should remove from watchlist when removeFromWatchlist is called', () async {
      when(mockRemoveWatchlist.execute(any))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));

      await provider.removeFromWatchlist(testTvSeriesDetail);

      verify(mockRemoveWatchlist.execute(any));
      expect(provider.watchlistMessage, 'Removed from Watchlist');
      expect(provider.isAddedToWatchlist, false);
    });

    test('should handle error when adding to watchlist fails', () async {
      when(mockSaveWatchlist.execute(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to add to watchlist')));

      await provider.addWatchlist(testTvSeriesDetail);

      expect(provider.watchlistMessage, 'Failed to add to watchlist');
      expect(provider.isAddedToWatchlist, false);
    });

    test('should handle error when removing from watchlist fails', () async {
      when(mockRemoveWatchlist.execute(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to remove from watchlist')));

      await provider.removeFromWatchlist(testTvSeriesDetail);

      expect(provider.watchlistMessage, 'Failed to remove from watchlist');
    });

    test('should update watchlist status when loadWatchlistStatus is called', () async {
      when(mockGetWatchlistStatus.execute(testId))
          .thenAnswer((_) async => true);

      await provider.loadWatchlistStatus(testId);

      verify(mockGetWatchlistStatus.execute(testId));
      expect(provider.isAddedToWatchlist, true);
    });

    test('should handle error when loadWatchlistStatus fails', () async {
      when(mockGetWatchlistStatus.execute(testId))
          .thenThrow(Exception('Database error'));

      await provider.loadWatchlistStatus(testId);

      expect(provider.isAddedToWatchlist, false);
    });
  });

  group('getTvSeriesRecommendations', () {
    test('should get recommendations when getTvSeriesRecommendations is called',
        () async {
      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testRecommendations));

      await provider.getTvSeriesRecommendations(testId);

      verify(mockGetTvSeriesRecommendations.execute(testId));
      expect(provider.recommendationsState, RequestState.Loaded);
      expect(provider.recommendations, testRecommendations);
    });

    test('should update state to error when getTvSeriesRecommendations fails',
        () async {
      when(mockGetTvSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      await provider.getTvSeriesRecommendations(testId);

      expect(provider.recommendationsState, RequestState.Error);
      expect(provider.recommendationsMessage, 'Server Error');
      expect(provider.recommendations, []);
    });
  });

  test('should convert TvSeriesDetail to TvSeries correctly', () {
    final tvSeries = testTvSeriesDetail.toTvSeries();
    
    expect(tvSeries.id, testTvSeriesDetail.id);
    expect(tvSeries.title, testTvSeriesDetail.name);
    expect(tvSeries.name, testTvSeriesDetail.name);
    expect(tvSeries.overview, testTvSeriesDetail.overview);
    expect(tvSeries.posterPath, testTvSeriesDetail.posterPath ?? '');
    expect(tvSeries.voteAverage, testTvSeriesDetail.voteAverage);
    expect(tvSeries.genreIds, testTvSeriesDetail.genres.map((e) => e.id).toList());
    expect(tvSeries.firstAirDate, testTvSeriesDetail.firstAirDate);
    expect(tvSeries.popularity, testTvSeriesDetail.popularity);
    expect(tvSeries.voteCount, testTvSeriesDetail.voteCount);
    expect(tvSeries.backdropPath, testTvSeriesDetail.backdropPath ?? '');
    expect(tvSeries.originalLanguage, testTvSeriesDetail.originalLanguage);
    expect(tvSeries.originalName, testTvSeriesDetail.originalName);
    expect(tvSeries.numberOfEpisodes, testTvSeriesDetail.numberOfEpisodes);
    expect(tvSeries.numberOfSeasons, testTvSeriesDetail.numberOfSeasons);
  });
}
