import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_table.dart';
import 'package:ditonton/core/utils/database_helper.dart';
import '../../../../dummy_data/dummy_objects.dart';

final tTvSeriesTable = TvSeriesTable.fromEntity(testTvSeries);
final tTvSeriesMap = {
  'id': 1,
  'name': 'Test TV Series',
  'posterPath': '/test.jpg',
  'overview': 'Test overview',
  'type': 'tv',
};
final tTvSeriesTableList = [tTvSeriesTable];
final tTvSeriesMapList = [tTvSeriesMap];

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<int> insertTvSeriesWatchlist(TvSeriesTable tvSeries) =>
      super.noSuchMethod(
        Invocation.method(#insertTvSeriesWatchlist, [tvSeries]),
        returnValue: Future.value(1),
        returnValueForMissingStub: Future.value(1),
      ) as Future<int>;

  @override
  Future<int> removeTvSeriesWatchlist(TvSeriesTable tvSeries) =>
      super.noSuchMethod(
        Invocation.method(#removeTvSeriesWatchlist, [tvSeries]),
        returnValue: Future.value(1),
        returnValueForMissingStub: Future.value(1),
      ) as Future<int>;

  @override
  Future<Map<String, dynamic>?> getTvSeriesById(int id) =>
      super.noSuchMethod(
        Invocation.method(#getTvSeriesById, [id]),
        returnValue: Future.value(tTvSeriesMap),
        returnValueForMissingStub: Future.value(tTvSeriesMap),
      ) as Future<Map<String, dynamic>?>;

  @override
  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() =>
      super.noSuchMethod(
        Invocation.method(#getWatchlistTvSeries, []),
        returnValue: Future.value(tTvSeriesMapList),
        returnValueForMissingStub: Future.value(tTvSeriesMapList),
      ) as Future<List<Map<String, dynamic>>>;
}

void main() {
  late TVSeriesLocalDataSource dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVSeriesLocalDataSource(databaseHelper: mockDatabaseHelper);
  });

  group('insert watchlist', () {
    test('should return success message when insert to database is successful',
        () async {
      // arrange
      final tTvSeriesTable = TvSeriesTable.fromEntity(testTvSeries);
      // No need to stub here as we've set up the mock in the class

      // act
      final result = await dataSource.insertWatchlist(tTvSeriesTable);

      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is unsuccessful',
        () async {
      // arrange
      final tTvSeriesTable = TvSeriesTable.fromEntity(testTvSeries);
      when(mockDatabaseHelper.insertTvSeriesWatchlist(tTvSeriesTable))
          .thenThrow(Exception('Database Error'));

      // act
      final call = dataSource.insertWatchlist(tTvSeriesTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is successful',
        () async {
      // arrange
      final tTvSeriesTable = TvSeriesTable.fromEntity(testTvSeries);
      // No need to stub here as we've set up the mock in the class

      // act
      final result = await dataSource.removeWatchlist(tTvSeriesTable);

      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is unsuccessful',
        () async {
      // arrange
      final tTvSeriesTable = TvSeriesTable.fromEntity(testTvSeries);
      when(mockDatabaseHelper.removeTvSeriesWatchlist(tTvSeriesTable))
          .thenThrow(Exception('Database Error'));

      // act
      final call = dataSource.removeWatchlist(tTvSeriesTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get watchlist status', () {
    test('should return true when data is found in database', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(1))
          .thenAnswer((_) async => {'id': 1, 'name': 'Test'});

      // act
      final result = await dataSource.isAddedToWatchlist(1);

      // assert
      expect(result, true);
    });

    test('should return false when data is not found in database', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(1)).thenAnswer((_) async => null);

      // act
      final result = await dataSource.isAddedToWatchlist(1);

      // assert
      expect(result, false);
    });

    test('should throw DatabaseException when database throws an exception',
        () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(1))
          .thenThrow(Exception('Database Error'));

      // act
      final call = dataSource.isAddedToWatchlist(1);


      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get watchlist TV series', () {
    test('should return list of TvSeriesTable when data is available',
        () async {
      // arrange
      final testTvSeriesMap = {
        'id': 1,
        'name': 'Test',
        'posterPath': '/path.jpg',
        'overview': 'Overview',
      };
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesMap]);

      // act
      final result = await dataSource.getWatchlistTvSeries();

      // assert
      expect(result, isA<List<TvSeriesTable>>());
      expect(result[0].id, testTvSeriesMap['id']);
      expect(result[0].name, testTvSeriesMap['name']);
      expect(result[0].posterPath, testTvSeriesMap['posterPath']);
      expect(result[0].overview, testTvSeriesMap['overview']);
    });

    test('should throw DatabaseException when database throws an exception',
        () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenThrow(Exception('Database Error'));

      // act
      final call = dataSource.getWatchlistTvSeries();

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get TV series by id', () {
    test('should return TvSeriesTable when data is found', () async {
      // arrange
      // Using the same data that's set up in the mock database helper
      final testTvSeriesMap = {
        'id': 1,
        'name': 'Test TV Series',
        'posterPath': '/test.jpg',
        'overview': 'Test overview',
        'type': 'tv',
      };

      // act
      final result = await dataSource.getTvSeriesById(1);

      // assert
      expect(result?.id, testTvSeriesMap['id']);
      expect(result?.name, testTvSeriesMap['name']);
      expect(result?.posterPath, testTvSeriesMap['posterPath']);
      expect(result?.overview, testTvSeriesMap['overview']);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(1)).thenAnswer((_) async => null);

      // act
      final result = await dataSource.getTvSeriesById(1);

      // assert
      expect(result, null);
    });

    test('should throw DatabaseException when database throws an exception',
        () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(1))
          .thenThrow(Exception('Database Error'));

      // act
      final call = dataSource.getTvSeriesById(1);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });
}