import 'package:dio/dio.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';

class TVSeriesRemoteDataSource {
  final Dio client;

  TVSeriesRemoteDataSource({required this.client});

  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    try {
      final result = await client.get('https://api.themoviedb.org/3/tv/on_the_air');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    try {
      final result = await client.get('https://api.themoviedb.org/3/tv/popular');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    try {
      final result = await client.get('https://api.themoviedb.org/3/tv/top_rated');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    try {
      final result = await client.get('https://api.themoviedb.org/3/tv/$id/recommendations');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<TvSeriesModel> getTvSeriesDetail(int id) async {
    try {
      final result = await client.get('https://api.themoviedb.org/3/tv/$id');
      return TvSeriesModel.fromJson(result.data);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    try {
      final result = await client.get('https://api.themoviedb.org/3/search/tv',
          queryParameters: {'query': query});
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }
}
