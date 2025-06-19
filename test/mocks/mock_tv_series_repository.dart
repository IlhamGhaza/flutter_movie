import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';

class MockTvSeriesRepository extends Mock implements TvSeriesRepository {
  // Mock implementation for getNowPlayingTvSeries
  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() async {
    return Right<Failure, List<TvSeries>>(<TvSeries>[]);
  }

  // Mock implementation for getPopularTvSeries
  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    return Right<Failure, List<TvSeries>>(<TvSeries>[]);
  }

  // Mock implementation for getTopRatedTvSeries
  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    return Right<Failure, List<TvSeries>>(<TvSeries>[]);
  }

  // Mock implementation for getTvSeriesDetail
  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    return Right<Failure, TvSeriesDetail>(
      TvSeriesDetail(
        id: 1,
        name: 'Test TV Series',
        overview: 'Test Overview',
        posterPath: '/test_poster.jpg',
        voteAverage: 8.5,
        firstAirDate: '2022-01-01',
        genres: [],
        originalName: 'Test TV Series',
        originalLanguage: 'en',
        popularity: 100.0,
        voteCount: 100,
        adult: false,
        backdropPath: '/test_backdrop.jpg',
        episodeRunTime: [60],
        originCountry: ['US'],
        status: 'Returning Series',
        tagline: 'Test Tagline',
        type: 'Scripted',
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
      ),
    );
  }

  // Mock implementation for getTvSeriesRecommendations
  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id) async {
    return Right<Failure, List<TvSeries>>(<TvSeries>[]);
  }

  // Mock implementation for searchTvSeries
  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    return Right<Failure, List<TvSeries>>(<TvSeries>[]);
  }

  // Mock implementation for saveWatchlist
  @override
  Future<Either<Failure, String>> saveWatchlist(TvSeries tvSeries) async {
    return Right<Failure, String>('Added to watchlist');
  }

  // Mock implementation for removeWatchlist
  @override
  Future<Either<Failure, String>> removeWatchlist(TvSeries tvSeries) async {
    return Right<Failure, String>('Removed from watchlist');
  }

  // Mock implementation for isAddedToWatchlist
  @override
  Future<bool> isAddedToWatchlist(int id) async {
    return false;
  }

  // Mock implementation for getWatchlistTvSeries
  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    return Right<Failure, List<TvSeries>>(<TvSeries>[]);
  }
}
