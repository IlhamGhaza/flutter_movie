import 'package:dio/dio.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_model.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_response.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_detail_model.dart';
import 'package:ditonton/features/tv_series/data/models/season_detail_model.dart';

class TVSeriesRemoteDataSource {
  final Dio client;

  TVSeriesRemoteDataSource({required this.client});

  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    try {
      final result = await client.get('/tv/on_the_air');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get now playing TV series');
    } catch (e) {
      throw ServerException('Failed to get now playing TV series');
    }
  }

  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    try {
      final result = await client.get('/tv/popular');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get popular TV series');
    } catch (e) {
      throw ServerException('Failed to get popular TV series');
    }
  }

  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    try {
      final result = await client.get('/tv/top_rated');
      return TvSeriesResponse.fromJson(result.data).tvSeriesList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get top rated TV series');
    } catch (e) {
      throw ServerException('Failed to get top rated TV series');
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

  Future<SeasonDetailModel> getSeasonDetail(int tvId, int seasonNumber) async {
    try {
      print('Fetching season detail for TV ID: $tvId, Season: $seasonNumber');
      final result = await client.get(
        '/tv/$tvId/season/$seasonNumber',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      
      if (result.statusCode == 200) {
        return SeasonDetailModel.fromJson(result.data);
      } else {
        print('API Error: ${result.statusCode} - ${result.statusMessage}');
        print('Response data: ${result.data}');
        throw ServerException('Failed to load season details. Status: ${result.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      print('Error response: ${e.response?.data}');
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw ServerException('Unexpected error: $e');
    }
  }
}
