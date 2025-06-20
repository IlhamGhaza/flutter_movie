import 'package:dartz/dartz.dart';
import '../entities/tv_series.dart';
import '../entities/tv_series_detail.dart';
import '../entities/season_detail.dart';
import '../../../../common/failure.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(TvSeries tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvSeries tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
  
  /// Get detailed information about a specific season of a TV series.
  /// 
  /// [tvId] The ID of the TV series
  /// [seasonNumber] The season number
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(int tvId, int seasonNumber);
}
