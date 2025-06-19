import 'package:dartz/dartz.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetSeasonDetail {
  final TvSeriesRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute({
    required int tvId,
    required int seasonNumber,
  }) async {
    return await repository.getSeasonDetail(tvId, seasonNumber);
  }
}
