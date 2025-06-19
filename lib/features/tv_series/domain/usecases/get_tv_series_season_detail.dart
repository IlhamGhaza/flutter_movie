import 'package:dartz/dartz.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetTvSeriesSeasonDetail {
  final TvSeriesRepository repository;

  GetTvSeriesSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int tvId, int seasonNumber) {
    return repository.getSeasonDetail(tvId, seasonNumber);
  }
}
