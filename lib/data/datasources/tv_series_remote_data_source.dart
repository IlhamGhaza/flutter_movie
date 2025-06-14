import 'package:dio/dio.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';

class TVSeriesRemoteDataSource {
  final Dio client;

  TVSeriesRemoteDataSource({required this.client});

  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    try {
      final result = await client.get('/tv/on_the_air');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    try {
      final result = await client.get('/tv/popular');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    try {
      final result = await client.get('/tv/top_rated');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    try {
      final result = await client.get('/tv/$id/recommendations');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    try {
      final result = await client.get('/tv/$id');
      return TvSeriesDetailModel.fromJson(result.data);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    try {
      final result = await client.get(
        '/search/tv',
        queryParameters: {'query': query},
      );
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } catch (e) {
      throw ServerException();
    }
  }
}
