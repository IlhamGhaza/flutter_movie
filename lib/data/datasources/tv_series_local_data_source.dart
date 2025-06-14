import 'dart:async';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import '../datasources/db/database_helper.dart';

class TVSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVSeriesLocalDataSource({required this.databaseHelper});

  /// Insert a TV series to watchlist
  /// 
  /// Throws [DatabaseException] if insert operation fails
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertTvSeriesWatchlist(tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException('Failed to add to watchlist: $e');
    }
  }

  /// Remove a TV series from watchlist
  /// 
  /// Throws [DatabaseException] if delete operation fails
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeTvSeriesWatchlist(tvSeries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException('Failed to remove from watchlist: $e');
    }
  }

  /// Check if a TV series is added to watchlist
  /// 
  /// Returns `true` if the TV series exists in watchlist, `false` otherwise
  /// Throws [DatabaseException] if query operation fails
  Future<bool> isAddedToWatchlist(int id) async {
    try {
      final result = await databaseHelper.getTvSeriesById(id);
      return result != null;
    } catch (e) {
      throw DatabaseException('Failed to check watchlist status: $e');
    }
  }

  /// Get all TV series in watchlist
  /// 
  /// Returns a list of [TvSeriesTable] from watchlist
  /// Throws [DatabaseException] if query operation fails
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    try {
      final result = await databaseHelper.getWatchlistTvSeries();
      return result.map((data) => TvSeriesTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get watchlist: $e');
    }
  }
  
  /// Get a TV series by id from watchlist
  /// 
  /// Returns [TvSeriesTable] if found, `null` otherwise
  /// Throws [DatabaseException] if query operation fails
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    try {
      final result = await databaseHelper.getTvSeriesById(id);
      return result != null ? TvSeriesTable.fromMap(result) : null;
    } catch (e) {
      throw DatabaseException('Failed to get TV series: $e');
    }
  }
}
