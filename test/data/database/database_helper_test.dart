import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';

const String _tblMovieWatchlist = 'movie_watchlist';
const String _tblTvSeriesWatchlist = 'tv_series_watchlist';

void main() {
  // Initialize FFI for sqflite testing
  setUpAll(() {
    sqfliteFfiInit();
    // Use ffi database factory for tests (uses file system by default on desktop)
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseHelper databaseHelper;
  String? testDbPath;

  setUp(() async {
    final dbsPath = await databaseFactory.getDatabasesPath();
    testDbPath = p.join(dbsPath, 'ditonton.db');

    // Ensure DatabaseHelper's static _database is reset if it was closed by a previous test.
    // This is now handled by calling `databaseHelper.closeDatabase()` in tearDown.
    try {
      // Delete the database file used by DatabaseHelper to ensure a fresh start
      await databaseFactory.deleteDatabase(testDbPath!);
    } catch (_) {
      // Ignore errors if the file doesn't exist or other delete issues
    }

    databaseHelper = DatabaseHelper();
    // Ensure database is initialized
    await databaseHelper.database;
  });

  tearDown(() async {
    await databaseHelper.closeDatabase(); // Closes and nullifies the static _database
    try {
      await databaseFactory.deleteDatabase(testDbPath!);
    } catch (_) {}
  });

  final testMovieTable = MovieTable(
    id: 1,
    title: 'Test Movie',
    posterPath: '/test_poster.jpg',
    overview: 'Test Overview',
    voteAverage: 8.0,
    releaseDate: '2023-01-01',
  );

  final testTvSeriesTable = TvSeriesTable(
    id: 1,
    title: 'Test TV Series Title',
    name: 'Test TV Series Name',
    overview: 'Test Overview',
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genreIds: [1, 2],
    originalName: 'Original Test TV Series Name',
    originalLanguage: 'en',
    popularity: 100.0,
    voteCount: 100,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
  );

  test('should create movie and tv series tables when db is initialized',
      () async {
    final dbInstance = await databaseHelper.database;
    expect(dbInstance, isNotNull);

    final tables = await dbInstance!
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    final tableNames = tables.map((t) => t['name'] as String).toList();

    expect(tableNames, contains(_tblMovieWatchlist));
    expect(tableNames, contains(_tblTvSeriesWatchlist));
  });

  group('Movie Watchlist', () {
    test('should insert and retrieve movie from watchlist', () async {
      await databaseHelper.insertMovieWatchlist(testMovieTable);
      final movieFromDb = await databaseHelper.getMovieById(testMovieTable.id);
      expect(movieFromDb, isNotNull);
      expect(MovieTable.fromMap(movieFromDb!), testMovieTable);
    });

    test('should remove movie from watchlist', () async {
      await databaseHelper.insertMovieWatchlist(testMovieTable);
      await databaseHelper.removeMovieWatchlist(testMovieTable.id);
      final movieFromDb = await databaseHelper.getMovieById(testMovieTable.id);
      expect(movieFromDb, isNull);
    });

    test('should get all watchlist movies', () async {
      await databaseHelper.insertMovieWatchlist(testMovieTable);
      final watchlistMovies = await databaseHelper.getWatchlistMovies();
      expect(watchlistMovies.length, 1);
      expect(MovieTable.fromMap(watchlistMovies.first), testMovieTable);
    });
  });

  group('TV Series Watchlist', () {
    test('should insert and retrieve TV series from watchlist', () async {
      await databaseHelper.insertTvSeriesWatchlist(testTvSeriesTable);
      final tvSeriesFromDb =
          await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
      expect(tvSeriesFromDb, isNotNull);
      expect(TvSeriesTable.fromMap(tvSeriesFromDb!), testTvSeriesTable);
    });

    test('should remove TV series from watchlist', () async {
      await databaseHelper.insertTvSeriesWatchlist(testTvSeriesTable);
      await databaseHelper.removeTvSeriesWatchlist(testTvSeriesTable);
      final tvSeriesFromDb =
          await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
      expect(tvSeriesFromDb, isNull);
    });

    test('should get all watchlist TV series', () async {
      await databaseHelper.insertTvSeriesWatchlist(testTvSeriesTable);
      final watchlistTvSeries = await databaseHelper.getWatchlistTvSeries();
      expect(watchlistTvSeries.length, 1);
      expect(TvSeriesTable.fromMap(watchlistTvSeries.first), testTvSeriesTable);
    });
  });

  test('should handle database upgrade', () async {
    await databaseFactory.deleteDatabase(testDbPath!); // Clean up before creating old version

    // Create an old version of the database
    Database? oldDb = await databaseFactory.openDatabase(
      testDbPath!, // DatabaseHelper will open this specific file
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_tblMovieWatchlist (
              id INTEGER PRIMARY KEY,
              title TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_tblTvSeriesWatchlist (
              id INTEGER PRIMARY KEY,
              title TEXT -- Old schema, missing other fields like 'name', 'overview'
            )
          ''');
        },
      ),
    );
    // Insert data to test migration
    await oldDb.insert(_tblTvSeriesWatchlist, {'id': 1, 'title': 'Old TV Series'});
    await oldDb.close();
    oldDb = null;

    // Now open with DatabaseHelper, which should trigger upgrade because its
    // static _database was nullified by the previous test's tearDown (or is null initially)
    // and the database file on disk is at version 1.
    final dbHelperForUpgrade = DatabaseHelper();
    final upgradedDb = await dbHelperForUpgrade.database;

    expect(upgradedDb, isNotNull, reason: "Upgraded DB should not be null");
    expect(upgradedDb?.isOpen, true, reason: "Upgraded DB should be open.");

    // Verify the schema was upgraded
    final columns =
        await upgradedDb!.rawQuery('PRAGMA table_info($_tblTvSeriesWatchlist)');
    final columnNames = columns.map((col) => col['name'] as String).toList();

    // Check if new columns exist
    expect(columnNames, containsAll(['name', 'overview', 'posterPath', 'backdropPath', 'voteAverage', 'firstAirDate', 'genreIds', 'originalName', 'originalLanguage', 'popularity', 'voteCount', 'numberOfEpisodes', 'numberOfSeasons']),
        reason: "TV Series table schema not upgraded correctly. Columns: $columnNames");

    // Verify data migration
    final migratedData = await upgradedDb.query(_tblTvSeriesWatchlist, where: 'id = ?', whereArgs: [1]);
    expect(migratedData, isNotEmpty, reason: "Migrated data not found for TV Series ID 1");
    expect(migratedData.first['title'], 'Old TV Series');
    expect(migratedData.first['name'], 'Old TV Series', reason: "'name' column not migrated correctly from 'title'");

    await upgradedDb.close();
    // The main tearDown will handle deleting testDbPath and calling databaseHelper.closeDatabase()
    // which nullifies the static _database field.
  });
}
