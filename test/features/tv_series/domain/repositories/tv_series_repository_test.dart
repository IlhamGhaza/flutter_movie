import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/common/failure.dart';

// Generate mocks
@GenerateMocks([TvSeriesRepository])
import 'tv_series_repository_test.mocks.dart';

// Test data
const String serverFailureMessage = 'Server Failure';
const String connectionFailureMessage = 'Failed to connect to the network';
const String databaseFailureMessage = 'Database Failure';

// Helper function to create a ServerFailure
ServerFailure serverFailure() => ServerFailure(serverFailureMessage);

// Helper function to create a ConnectionFailure
ConnectionFailure connectionFailure() => ConnectionFailure(connectionFailureMessage);

// Helper function to create a DatabaseFailure
DatabaseFailure databaseFailure() => DatabaseFailure(databaseFailureMessage);

// Test data 
final tTvSeries = TvSeries(
  id: 1,
  title: 'Test TV Series',
  overview: 'Test Overview',
  posterPath: '/path.jpg',
  voteAverage: 8.0,
  genreIds: [1, 2, 3],
  firstAirDate: '2022-01-01',
  popularity: 8.5,
  voteCount: 100,
  backdropPath: '/path.jpg',
  originalLanguage: 'en',
  originalName: 'Test TV Series',
  name: 'Test TV Series',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
);

final tTvSeriesList = <TvSeries>[tTvSeries];

final tTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/path.jpg',
  episodeRunTime: [45],
  firstAirDate: '2022-01-01',
  genres: [],
  id: 1,
  name: 'Test TV Series',
  originalName: 'Test TV Series',
  overview: 'Test Overview',
  posterPath: '/path.jpg',
  voteAverage: 8.0,
  voteCount: 100,
  originCountry: ['US'],
  originalLanguage: 'en',
  popularity: 8.5,
  status: 'Returning Series',
  tagline: 'Test Tagline',
  type: 'Scripted',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
);

void main() {
  late MockTvSeriesRepository mockTvSeriesRepository;

  // Helper functions to set up error cases with proper types
  void setUpListErrorCase(Function() whenCall, Failure error) {
    when(whenCall()).thenAnswer((_) async => Left<Failure, List<TvSeries>>(error));
  }

  void setUpDetailErrorCase(Function() whenCall, Failure error) {
    when(whenCall()).thenAnswer((_) async => Left<Failure, TvSeriesDetail>(error));
  }

  void setUpStringErrorCase(Function() whenCall, Failure error) {
    when(whenCall()).thenAnswer((_) async => Left<Failure, String>(error));
  }

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    
    // Setup default return values for all methods (success cases)
    when(mockTvSeriesRepository.getNowPlayingTvSeries())
        .thenAnswer((_) async => Right<Failure, List<TvSeries>>(tTvSeriesList));
    when(mockTvSeriesRepository.getPopularTvSeries())
        .thenAnswer((_) async => Right<Failure, List<TvSeries>>(tTvSeriesList));
    when(mockTvSeriesRepository.getTopRatedTvSeries())
        .thenAnswer((_) async => Right<Failure, List<TvSeries>>(tTvSeriesList));
    when(mockTvSeriesRepository.getTvSeriesDetail(any))
        .thenAnswer((_) async => Right<Failure, TvSeriesDetail>(tTvSeriesDetail));
    when(mockTvSeriesRepository.getTvSeriesRecommendations(any))
        .thenAnswer((_) async => Right<Failure, List<TvSeries>>(tTvSeriesList));
    when(mockTvSeriesRepository.searchTvSeries(any))
        .thenAnswer((_) async => Right<Failure, List<TvSeries>>(tTvSeriesList));
    when(mockTvSeriesRepository.saveWatchlist(any))
        .thenAnswer((_) async => const Right<Failure, String>('Added to Watchlist'));
    when(mockTvSeriesRepository.removeWatchlist(any))
        .thenAnswer((_) async => const Right<Failure, String>('Removed from Watchlist'));
    when(mockTvSeriesRepository.isAddedToWatchlist(any))
        .thenAnswer((_) async => true);
    when(mockTvSeriesRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right<Failure, List<TvSeries>>(tTvSeriesList));
  });


  group('TvSeriesRepository Tests', () {
    group('getNowPlayingTvSeries', () {
      test('should return list of TV series when success', () async {
        // act
        final result = await mockTvSeriesRepository.getNowPlayingTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getNowPlayingTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test('should return server failure when server error occurs', () async {
        // arrange
        setUpListErrorCase(
          () => mockTvSeriesRepository.getNowPlayingTvSeries(),
          serverFailure(),
        );
        
        // act
        final result = await mockTvSeriesRepository.getNowPlayingTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getNowPlayingTvSeries());
        expect(result, Left(serverFailure()));
      });
    });

    group('getPopularTvSeries', () {
      test('should return list of popular TV series when success', () async {
        // act
        final result = await mockTvSeriesRepository.getPopularTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getPopularTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test('should return empty list when no data available', () async {
        // arrange
        when(mockTvSeriesRepository.getPopularTvSeries())
            .thenAnswer((_) async => Right<Failure, List<TvSeries>>([]));
        
        // act
        final result = await mockTvSeriesRepository.getPopularTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getPopularTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, isEmpty);
      });
    });

    group('getTopRatedTvSeries', () {
      test('should return list of top rated TV series when success', () async {
        // act
        final result = await mockTvSeriesRepository.getTopRatedTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getTopRatedTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test('should return connection failure when no internet', () async {
        // arrange
        setUpListErrorCase(
          () => mockTvSeriesRepository.getTopRatedTvSeries(),
          connectionFailure(),
        );
        
        // act
        final result = await mockTvSeriesRepository.getTopRatedTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getTopRatedTvSeries());
        expect(result, Left(connectionFailure()));
      });
    });

    group('getTvSeriesDetail', () {
      const tId = 1;
      
      test('should return tv series detail when success', () async {
        // act
        final result = await mockTvSeriesRepository.getTvSeriesDetail(tId);
        
        // assert
        verify(mockTvSeriesRepository.getTvSeriesDetail(tId));
        final detail = result.getOrElse(() => throw Exception('Not found'));
        expect(detail, tTvSeriesDetail);
      });

      test('should return error when id is invalid', () async {
        // arrange
        const invalidId = -1;
        setUpDetailErrorCase(
          () => mockTvSeriesRepository.getTvSeriesDetail(invalidId),
          serverFailure(),
        );
        
        // act
        final result = await mockTvSeriesRepository.getTvSeriesDetail(invalidId);
        
        // assert
        verify(mockTvSeriesRepository.getTvSeriesDetail(invalidId));
        expect(result.isLeft(), isTrue);
      });
    });

    group('getTvSeriesRecommendations', () {
      const tId = 1;
      
      test('should return list of recommendations when success', () async {
        // act
        final result = await mockTvSeriesRepository.getTvSeriesRecommendations(tId);
        
        // assert
        verify(mockTvSeriesRepository.getTvSeriesRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test('should return empty list when no recommendations', () async {
        // arrange
        when(mockTvSeriesRepository.getTvSeriesRecommendations(tId))
            .thenAnswer((_) async => Right<Failure, List<TvSeries>>([]));
        
        // act
        final result = await mockTvSeriesRepository.getTvSeriesRecommendations(tId);
        
        // assert
        verify(mockTvSeriesRepository.getTvSeriesRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, isEmpty);
      });
    });

    group('searchTvSeries', () {
      const tQuery = 'test';
      
      test('should return search results when success', () async {
        // act
        final result = await mockTvSeriesRepository.searchTvSeries(tQuery);
        
        // assert
        verify(mockTvSeriesRepository.searchTvSeries(tQuery));
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test('should return empty list when no results found', () async {
        // arrange
        when(mockTvSeriesRepository.searchTvSeries(tQuery))
            .thenAnswer((_) async => Right<Failure, List<TvSeries>>([]));
        
        // act
        final result = await mockTvSeriesRepository.searchTvSeries(tQuery);
        
        // assert
        verify(mockTvSeriesRepository.searchTvSeries(tQuery));
        final resultList = result.getOrElse(() => []);
        expect(resultList, isEmpty);
      });
    });

    group('saveWatchlist', () {
      test('should return success message when data is saved', () async {
        // act
        final result = await mockTvSeriesRepository.saveWatchlist(tTvSeries);
        
        // assert
        verify(mockTvSeriesRepository.saveWatchlist(tTvSeries));
        final message = result.getOrElse(() => '');
        expect(message, 'Added to Watchlist');
      });

      test('should return error when save fails', () async {
        // arrange
        setUpStringErrorCase(
          () => mockTvSeriesRepository.saveWatchlist(tTvSeries),
          databaseFailure(),
        );
        
        // act
        final result = await mockTvSeriesRepository.saveWatchlist(tTvSeries);
        
        // assert
        verify(mockTvSeriesRepository.saveWatchlist(tTvSeries));
        expect(result, Left(databaseFailure()));
      });
    });

    group('removeWatchlist', () {
      test('should return success message when data is removed', () async {
        // act
        final result = await mockTvSeriesRepository.removeWatchlist(tTvSeries);
        
        // assert
        verify(mockTvSeriesRepository.removeWatchlist(tTvSeries));
        final message = result.getOrElse(() => '');
        expect(message, 'Removed from Watchlist');
      });

      test('should return error when remove fails', () async {
        // arrange
        setUpStringErrorCase(
          () => mockTvSeriesRepository.removeWatchlist(tTvSeries),
          databaseFailure(),
        );
        
        // act
        final result = await mockTvSeriesRepository.removeWatchlist(tTvSeries);
        
        // assert
        verify(mockTvSeriesRepository.removeWatchlist(tTvSeries));
        expect(result, Left(databaseFailure()));
      });
    });

    group('isAddedToWatchlist', () {
      const tId = 1;
      
      test('should return true when tv series is in watchlist', () async {
        // arrange
        when(mockTvSeriesRepository.isAddedToWatchlist(tId))
            .thenAnswer((_) async => true);
        
        // act
        final result = await mockTvSeriesRepository.isAddedToWatchlist(tId);
        
        // assert
        verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
        expect(result, isTrue);
      });

      test('should return false when tv series is not in watchlist', () async {
        // arrange
        when(mockTvSeriesRepository.isAddedToWatchlist(tId))
            .thenAnswer((_) async => false);
        
        // act
        final result = await mockTvSeriesRepository.isAddedToWatchlist(tId);
        
        // assert
        verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
        expect(result, isFalse);
      });
    });

    group('getWatchlistTvSeries', () {
      test('should return list of watchlist tv series when success', () async {
        // act
        final result = await mockTvSeriesRepository.getWatchlistTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getWatchlistTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test('should return empty list when watchlist is empty', () async {
        // arrange
        when(mockTvSeriesRepository.getWatchlistTvSeries())
            .thenAnswer((_) async => Right<Failure, List<TvSeries>>([]));
        
        // act
        final result = await mockTvSeriesRepository.getWatchlistTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getWatchlistTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, isEmpty);
      });

      test('should return error when database error occurs', () async {
        // arrange
        setUpListErrorCase(
          () => mockTvSeriesRepository.getWatchlistTvSeries(),
          databaseFailure(),
        );
        
        // act
        final result = await mockTvSeriesRepository.getWatchlistTvSeries();
        
        // assert
        verify(mockTvSeriesRepository.getWatchlistTvSeries());
        expect(result, Left(databaseFailure()));
      });
    });
  });
}