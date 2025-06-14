import 'dart:async';

import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblMovieWatchlist = 'movie_watchlist';
  static const String _tblTvSeriesWatchlist = 'tv_series_watchlist';

  Future<Database> _initDb() async {
    try {
      final path = await getDatabasesPath();
      final databasePath = '$path/ditonton.db';
      
      print('Initializing database at: $databasePath');
      
      var db = await openDatabase(
        databasePath,
        version: 2, // Incremented version to trigger onUpgrade
        onCreate: _onCreate,
        onOpen: (db) {
          print('Database opened successfully');
        },
        onUpgrade: _onUpgrade,
      );
      
      // Verify tables exist
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'");
      print('Database tables: $tables');
      
      // Check if our tables exist
      final tableNames = tables.map((t) => t['name'] as String).toList();
      if (!tableNames.contains(_tblMovieWatchlist) || 
          !tableNames.contains(_tblTvSeriesWatchlist)) {
        print('Required tables missing, recreating database...');
        await db.close();
        await deleteDatabase(databasePath);
        return _initDb();
      }
      
      return db;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Creating database tables...');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblMovieWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        voteAverage REAL,
        releaseDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblTvSeriesWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        backdropPath TEXT,
        voteAverage REAL,
        firstAirDate TEXT,
        genreIds TEXT,
        originalName TEXT,
        originalLanguage TEXT,
        popularity REAL,
        voteCount INTEGER,
        numberOfEpisodes INTEGER,
        numberOfSeasons INTEGER
      )
    ''');
    
    print('Database tables created successfully');
  }

  Future<int> insertMovieWatchlist(MovieTable movie) async {
    try {
      final db = await database;
      return await db!.insert(
        _tblMovieWatchlist,
        movie.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting movie to watchlist: $e');
      rethrow;
    }
  }

  Future<int> removeMovieWatchlist(int id) async {
    try {
      final db = await database;
      return await db!.delete(
        _tblMovieWatchlist,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error removing movie from watchlist: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    try {
      final db = await database;
      final results = await db!.query(
        _tblMovieWatchlist,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      print('Error getting movie by id: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db!.query(_tblMovieWatchlist);

      return results;
    } catch (e) {
      print('Error getting watchlist movies: $e');
      rethrow;
    }
  }

  Future<int> insertTvSeriesWatchlist(TvSeriesTable tvSeries) async {
    try {
      final db = await database;
      return await db!.insert(
        _tblTvSeriesWatchlist,
        tvSeries.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting TV series to watchlist: $e');
      rethrow;
    }
  }

  Future<int> removeTvSeriesWatchlist(TvSeriesTable tvSeries) async {
    try {
      final db = await database;
      return await db!.delete(
        _tblTvSeriesWatchlist,
        where: 'id = ?',
        whereArgs: [tvSeries.id],
      );
    } catch (e) {
      print('Error removing TV series from watchlist: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    try {
      final db = await database;
      final results = await db!.query(
        _tblTvSeriesWatchlist,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      print('Error getting TV series by id: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db!.query(_tblTvSeriesWatchlist);
      return results;
    } catch (e) {
      print('Error getting watchlist TV series: $e');
      rethrow;
    }
  }
  
  // Handle database version upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        // First, check if the table exists and its current structure
        final columns = await db.rawQuery('PRAGMA table_info($_tblTvSeriesWatchlist)');
        final columnNames = columns.map((col) => col['name'] as String).toList();
        
        // Create new table with updated schema
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${_tblTvSeriesWatchlist}_new (
            id INTEGER PRIMARY KEY,
            title TEXT,
            name TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            voteAverage REAL,
            firstAirDate TEXT,
            genreIds TEXT,
            originalName TEXT,
            originalLanguage TEXT,
            popularity REAL,
            voteCount INTEGER,
            numberOfEpisodes INTEGER,
            numberOfSeasons INTEGER
          )
        ''');
        
        // Copy existing data to new table with proper handling for missing columns
        String selectColumns = 'id, title, ';
        String insertColumns = 'id, title, ';
        
        // Add name column if it exists, otherwise use title as name
        if (columnNames.contains('name')) {
          selectColumns += 'name, ';
          insertColumns += 'name, ';
        } else {
          selectColumns += 'title as name, ';
          insertColumns += 'name, ';
        }
        
        // Add other columns that might exist
        final otherColumns = ['overview', 'posterPath', 'voteAverage', 'firstAirDate'];
        for (var col in otherColumns) {
          if (columnNames.contains(col)) {
            selectColumns += '$col, ';
            insertColumns += '$col, ';
          } else {
            // Provide default values for missing columns
            final defaultValue = col == 'overview' ? "''" : 
                               col == 'voteAverage' ? '0.0' : "''";
            selectColumns += '$defaultValue as $col, ';
            insertColumns += '$col, ';
          }
        }
        
        // Add new columns with default values
        final newColumns = {
          'backdropPath': "''",
          'genreIds': "'[]'",
          'originalName': 'name',
          'originalLanguage': "'en'",
          'popularity': '0.0',
          'voteCount': '0',
          'numberOfEpisodes': '0',
          'numberOfSeasons': '0'
        };
        
        // Remove trailing comma and space
        selectColumns = selectColumns.substring(0, selectColumns.length - 2);
        insertColumns = insertColumns.substring(0, insertColumns.length - 2);
        
        // Add new columns to insert
        newColumns.forEach((col, defaultValue) {
          insertColumns += ', $col';
          if (col == 'originalName' && !columnNames.contains('name')) {
            selectColumns += ', title as $col';  // Use title as originalName if name doesn't exist
          } else {
            selectColumns += ', $defaultValue as $col';
          }
        });
        
        // Perform the data migration
        await db.execute('''
          INSERT INTO ${_tblTvSeriesWatchlist}_new ($insertColumns)
          SELECT $selectColumns
          FROM $_tblTvSeriesWatchlist
        ''');
        
        // Drop old table and rename new one
        await db.execute('DROP TABLE $_tblTvSeriesWatchlist');
        await db.execute('ALTER TABLE ${_tblTvSeriesWatchlist}_new RENAME TO $_tblTvSeriesWatchlist');
        
        print('Successfully upgraded database from version $oldVersion to $newVersion');
      } catch (e) {
        print('Error during database upgrade: $e');
        // If migration fails, drop and recreate the table with the new schema
        await db.execute('DROP TABLE IF EXISTS $_tblTvSeriesWatchlist');
        await _createTvSeriesTable(db);
        print('Recreated TV series table with new schema');
      }
    }
  }
  
  // Helper method to create the TV series table
  Future<void> _createTvSeriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblTvSeriesWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        backdropPath TEXT,
        voteAverage REAL,
        firstAirDate TEXT,
        genreIds TEXT,
        originalName TEXT,
        originalLanguage TEXT,
        popularity REAL,
        voteCount INTEGER,
        numberOfEpisodes INTEGER,
        numberOfSeasons INTEGER
      )
    ''');
  }
}
