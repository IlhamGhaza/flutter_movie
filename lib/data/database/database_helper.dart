import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tv_series_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> _initializeDb() async {
    var path = join(await getDatabasesPath(), 'ditonton_tv_series.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tv_series (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            voteAverage REAL,
            firstAirDate TEXT,
            name TEXT
          )
        ''');
      },
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  Future<void> insertWatchlist(TvSeriesTable tvSeries) async {
    final db = await database;
    await db!.insert('tv_series', tvSeries.toJson());
  }

  Future<void> removeWatchlist(TvSeriesTable tvSeries) async {
    final db = await database;
    await db!.delete(
      'tv_series',
      where: 'id = ?',
      whereArgs: [tvSeries.id],
    );
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      'tv_series',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query('tv_series');
    return results;
  }
}
