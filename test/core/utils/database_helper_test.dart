import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ditonton/core/utils/database_helper.dart';
import 'package:ditonton/features/movies/data/models/movie_table.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_table.dart';

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
    await databaseHelper
        .closeDatabase(); // Closes and nullifies the static _database
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
      final tvSeriesMapFromDb =
          await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
      expect(tvSeriesMapFromDb, isNotNull);
      final tvSeriesFromDb = TvSeriesTable.fromMap(tvSeriesMapFromDb!);

      // Compare individual properties as TvSeriesTable does not override ==
      expect(tvSeriesFromDb.id, testTvSeriesTable.id);
      expect(tvSeriesFromDb.title, testTvSeriesTable.title);
      expect(tvSeriesFromDb.name, testTvSeriesTable.name);
      expect(tvSeriesFromDb.overview, testTvSeriesTable.overview);
      expect(tvSeriesFromDb.posterPath, testTvSeriesTable.posterPath);
      expect(tvSeriesFromDb.backdropPath, testTvSeriesTable.backdropPath);
      expect(tvSeriesFromDb.voteAverage, testTvSeriesTable.voteAverage);
      expect(tvSeriesFromDb.firstAirDate, testTvSeriesTable.firstAirDate);
      expect(tvSeriesFromDb.genreIds, testTvSeriesTable.genreIds);
      expect(tvSeriesFromDb.originalName, testTvSeriesTable.originalName);
      expect(tvSeriesFromDb.originalLanguage, testTvSeriesTable.originalLanguage);
      expect(tvSeriesFromDb.popularity, testTvSeriesTable.popularity);
      expect(tvSeriesFromDb.voteCount, testTvSeriesTable.voteCount);
      expect(tvSeriesFromDb.numberOfEpisodes, testTvSeriesTable.numberOfEpisodes);
      expect(tvSeriesFromDb.numberOfSeasons, testTvSeriesTable.numberOfSeasons);
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
      final tvSeriesFromDb = TvSeriesTable.fromMap(watchlistTvSeries.first);

      // Compare individual properties instead of objects
      expect(tvSeriesFromDb.id, testTvSeriesTable.id);
      expect(tvSeriesFromDb.title, testTvSeriesTable.title);
      expect(tvSeriesFromDb.name, testTvSeriesTable.name);
      expect(tvSeriesFromDb.overview, testTvSeriesTable.overview);
      expect(tvSeriesFromDb.posterPath, testTvSeriesTable.posterPath);
      expect(tvSeriesFromDb.backdropPath, testTvSeriesTable.backdropPath);
      expect(tvSeriesFromDb.voteAverage, testTvSeriesTable.voteAverage);
      expect(tvSeriesFromDb.firstAirDate, testTvSeriesTable.firstAirDate);
      expect(tvSeriesFromDb.genreIds, testTvSeriesTable.genreIds);
      expect(tvSeriesFromDb.originalName, testTvSeriesTable.originalName);
      expect(
          tvSeriesFromDb.originalLanguage, testTvSeriesTable.originalLanguage);
      expect(tvSeriesFromDb.popularity, testTvSeriesTable.popularity);
      expect(tvSeriesFromDb.voteCount, testTvSeriesTable.voteCount);
      expect(
          tvSeriesFromDb.numberOfEpisodes, testTvSeriesTable.numberOfEpisodes);
      expect(tvSeriesFromDb.numberOfSeasons, testTvSeriesTable.numberOfSeasons);
    });
  });

  test('should handle database upgrade', () async {
    // Helper function to delete database file with retries
    Future<void> deleteDatabaseFile(String path) async {
      final file = File(path);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          // If delete fails, try again after a short delay
          await Future.delayed(Duration(milliseconds: 100));
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    }
    
    // Close any existing database connections first
    await databaseHelper.closeDatabase();
    
    // Clean up before creating old version
    await deleteDatabaseFile(testDbPath!);

    // Create an old version of the database
    final oldDb = await databaseFactory.openDatabase(
      testDbPath!,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE movie_watchlist (
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT
            )
          ''');
        },
      ),
    );

    try {
      // Insert test data
      await oldDb.insert(
        'movie_watchlist',
        {
          'id': 1,
          'title': 'Test Movie',
          'overview': 'Test Overview',
          'posterPath': '/test.jpg',
        },
      );
    } finally {
      // Close the old database
      await oldDb.close();
    }

    // Now open with DatabaseHelper which should trigger upgrade
    // Create a new instance for testing upgrade
    final dbHelper = DatabaseHelper();
    // Ensure the database is initialized
    final db = await dbHelper.database;
    expect(db, isNotNull, reason: 'Database should be initialized');

    try {
      // Verify the data is still there after upgrade
      final results = await db!.query('movie_watchlist');
      expect(results, isNotEmpty);
      expect(results.first['title'], 'Test Movie');
      expect(results.first['overview'], 'Test Overview');

      // Verify the schema was upgraded by checking tables
      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      final tableNames = tables.map((t) => t['name'] as String).toList();

      // Check if both required tables exist
      expect(
          tableNames, containsAll([_tblMovieWatchlist, _tblTvSeriesWatchlist]));
    } finally {
      // Clean up
      try {
        await db?.close();
      } catch (e) {
        print('Error closing database: $e');
      }
      try {
        await dbHelper.closeDatabase();
      } catch (e) {
        print('Error closing database helper: $e');
      }
      // Final cleanup
      await deleteDatabaseFile(testDbPath!);
    }
  });
}
