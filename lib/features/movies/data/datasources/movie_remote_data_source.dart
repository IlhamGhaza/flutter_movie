import 'package:ditonton/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton/features/movies/data/models/movie_model.dart';
import 'package:ditonton/features/movies/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:dio/dio.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final response = await client.get('/movie/now_playing');
      return MovieResponse.fromJson(response.data).movieList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get now playing movies');
    } catch (e) {
      throw ServerException('Failed to get now playing movies');
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    try {
      final response = await client.get('/movie/$id');
      return MovieDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get movie detail');
    } catch (e) {
      throw ServerException('Failed to get movie detail');
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    try {
      final response = await client.get('/movie/$id/recommendations');
      return MovieResponse.fromJson(response.data).movieList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get movie recommendations');
    } catch (e) {
      throw ServerException('Failed to get movie recommendations');
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await client.get('/movie/popular');
      return MovieResponse.fromJson(response.data).movieList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get popular movies');
    } catch (e) {
      throw ServerException('Failed to get popular movies');
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response = await client.get('/movie/top_rated');
      return MovieResponse.fromJson(response.data).movieList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to get top rated movies');
    } catch (e) {
      throw ServerException('Failed to get top rated movies');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await client.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      return MovieResponse.fromJson(response.data).movieList;
    } on DioException catch (e) {
      throw ServerException(e.response?.data['status_message'] ?? e.message ?? 'Failed to search movies');
    } catch (e) {
      throw ServerException('Failed to search movies');
    }
  }
}
