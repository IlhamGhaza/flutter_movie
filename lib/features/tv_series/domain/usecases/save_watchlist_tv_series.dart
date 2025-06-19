import 'package:dartz/dartz.dart';
import '../../../../common/failure.dart';
import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class SaveWatchlistTvSeries {
  final TvSeriesRepository repository;

  SaveWatchlistTvSeries(this.repository);

  Future<Either<Failure, String>> execute(TvSeries tvSeries) {
    return repository.saveWatchlist(tvSeries);
  }
}
