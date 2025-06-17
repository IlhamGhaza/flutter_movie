import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late WatchlistTvSeriesNotifier provider;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    
    provider = WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
      saveWatchlist: mockSaveWatchlistTvSeries,
      removeWatchlist: mockRemoveWatchlistTvSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTvSeries = testTvSeries;
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('fetchWatchlistTvSeries', () {
    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchWatchlistTvSeries();
      // assert
      expect(provider.state, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should return watchlist tv series when data is gotten successfully',
        () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.fetchWatchlistTvSeries();
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.watchlistTvSeries, tTvSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should handle empty watchlist', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => const Right([]));
      // act
      await provider.fetchWatchlistTvSeries();
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.watchlistTvSeries, []);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      // act
      await provider.fetchWatchlistTvSeries();
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Database Failure');
      expect(listenerCallCount, 2);
    });

    test('should handle different types of failures', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchWatchlistTvSeries();
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('addTvSeriesToWatchlist', () {
    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTvSeries.execute(tTvSeries))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.addTvSeriesToWatchlist(tTvSeries);
      // assert
      verify(mockSaveWatchlistTvSeries.execute(tTvSeries));
      verify(mockGetWatchlistTvSeries.execute());
      expect(provider.message, 'Added to Watchlist');
      expect(listenerCallCount, 2);
    });

    test('should handle error when adding to watchlist fails', () async {
      // arrange
      when(mockSaveWatchlistTvSeries.execute(tTvSeries))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to add')));
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.addTvSeriesToWatchlist(tTvSeries);
      // assert
      verify(mockSaveWatchlistTvSeries.execute(tTvSeries));
      verify(mockGetWatchlistTvSeries.execute());
      expect(provider.message, 'Failed to add');
      expect(listenerCallCount, 2);
    });
  });

  group('removeTvSeriesFromWatchlist', () {
    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTvSeries.execute(tTvSeries))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.removeTvSeriesFromWatchlist(tTvSeries);
      // assert
      verify(mockRemoveWatchlistTvSeries.execute(tTvSeries));
      verify(mockGetWatchlistTvSeries.execute());
      expect(provider.message, 'Removed from Watchlist');
      expect(listenerCallCount, 2);
    });

    test('should handle error when removing from watchlist fails', () async {
      // arrange
      when(mockRemoveWatchlistTvSeries.execute(tTvSeries))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to remove')));
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.removeTvSeriesFromWatchlist(tTvSeries);
      // assert
      verify(mockRemoveWatchlistTvSeries.execute(tTvSeries));
      verify(mockGetWatchlistTvSeries.execute());
      expect(provider.message, 'Failed to remove');
      expect(listenerCallCount, 2);
    });
  });

  group('isAddedToWatchlist', () {
    test('should return true when tv series is in watchlist', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      final result = await provider.isAddedToWatchlist(tTvSeries.id);
      // assert
      expect(result, true);
    });

    test('should return false when tv series is not in watchlist', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right([]));
      // act
      final result = await provider.isAddedToWatchlist(999);
      // assert
      expect(result, false);
    });

    test('should handle error when checking watchlist status', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to check')));
      // act
      final result = await provider.isAddedToWatchlist(tTvSeries.id);
      // assert
      expect(result, false);
    });
    
    test('should return false when tv series id is null', () async {
      // arrange
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      final result = await provider.isAddedToWatchlist(-1); // Using -1 as a non-existent ID
      // assert
      expect(result, false);
    });
  });
}
