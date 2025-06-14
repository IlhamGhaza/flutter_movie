import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class MockTvSeriesRepository extends Mock implements TvSeriesRepository {
  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() {
    return super.noSuchMethod(
      Invocation.method(#getNowPlayingTvSeries, []),
      returnValue: Future.value(Right(<TvSeries>[])),
    );
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() {
    return super.noSuchMethod(
      Invocation.method(#getPopularTvSeries, []),
      returnValue: Future.value(Right(<TvSeries>[])),
    );
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() {
    return super.noSuchMethod(
      Invocation.method(#getTopRatedTvSeries, []),
      returnValue: Future.value(Right(<TvSeries>[])),
    );
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id) {
    return super.noSuchMethod(
      Invocation.method(#getTvSeriesRecommendations, [id]),
      returnValue: Future.value(Right(<TvSeries>[])),
    );
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) {
    return super.noSuchMethod(
      Invocation.method(#searchTvSeries, [query]),
      returnValue: Future.value(Right(<TvSeries>[])),
    );
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvSeries tvSeries) {
    return super.noSuchMethod(
      Invocation.method(#saveWatchlist, [tvSeries]),
      returnValue: Future.value(const Right('Added to Watchlist')),
    );
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvSeries tvSeries) {
    return super.noSuchMethod(
      Invocation.method(#removeWatchlist, [tvSeries]),
      returnValue: Future.value(const Right('Removed from Watchlist')),
    );
  }

  @override
  Future<bool> isAddedToWatchlist(int id) {
    return super.noSuchMethod(
      Invocation.method(#isAddedToWatchlist, [id]),
      returnValue: Future.value(false),
    );
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() {
    return super.noSuchMethod(
      Invocation.method(#getWatchlistTvSeries, []),
      returnValue: Future.value(Right(<TvSeries>[])),
    );
  }
}
