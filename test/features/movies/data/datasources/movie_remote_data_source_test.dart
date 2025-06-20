import 'dart:convert';

import 'package:ditonton/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton/features/movies/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import '../../../../json_reader.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  mockResponse(String jsonString, int statusCode) => Future.value(
        Response<dynamic>(
          statusCode: statusCode,
          data: json.decode(jsonString),
          requestOptions: RequestOptions(path: ''),
        ),
      );

  setUp(() {
    mockDio = MockDio();
    dataSource = MovieRemoteDataSourceImpl(client: mockDio);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/now_playing.json')))
        .movieList;

    test('should return list of Movie Model when the response is successful',
        () async {
      // arrange
      when(mockDio.get('/movie/now_playing')).thenAnswer(
          (_) => mockResponse(readJson('dummy_data/now_playing.json'), 200));
      // act
      final result = await dataSource.getNowPlayingMovies();
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw a ServerException when the response fails', () async {
      // arrange
      when(mockDio.get('/movie/now_playing')).thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.getNowPlayingMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Movies', () {
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson('dummy_data/popular.json')))
            .movieList;

    test('should return list of movies when response is success', () async {
      // arrange
      when(mockDio.get('/movie/popular')).thenAnswer(
          (_) => mockResponse(readJson('dummy_data/popular.json'), 200));
      // act
      final result = await dataSource.getPopularMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw a ServerException when the response fails', () async {
      // arrange
      when(mockDio.get('/movie/popular')).thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.getPopularMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated.json')))
        .movieList;

    test('should return list of movies when response is successful', () async {
      // arrange
      when(mockDio.get('/movie/top_rated')).thenAnswer(
          (_) => mockResponse(readJson('dummy_data/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockDio.get('/movie/top_rated')).thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.getTopRatedMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Movie Detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return movie detail when the response is successful', () async {
      // arrange
      when(mockDio.get('/movie/$tId')).thenAnswer(
          (_) => mockResponse(readJson('dummy_data/movie_detail.json'), 200));
      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw Server Exception when the response fails', () async {
      // arrange
      when(mockDio.get('/movie/$tId')).thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.getMovieDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Movie Recommendations', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_recommendations.json')))
        .movieList;
    final tId = 1;

    test('should return list of Movie Model when the response is successful',
        () async {
      // arrange
      when(mockDio.get('/movie/$tId/recommendations')).thenAnswer(
          (_) => mockResponse(
              readJson('dummy_data/movie_recommendations.json'), 200));
      // act
      final result = await dataSource.getMovieRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response fails', () async {
      // arrange
      when(mockDio.get('/movie/$tId/recommendations')).thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.getMovieRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .movieList;
    const tQuery = 'Spiderman';

    test('should return list of movies when response is successful', () async {
      // arrange
      when(mockDio.get(
        '/search/movie',
        queryParameters: {'query': tQuery},
      )).thenAnswer((_) => mockResponse(
          readJson('dummy_data/search_spiderman_movie.json'), 200));
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response fails', () async {
      // arrange
      when(mockDio.get(
        '/search/movie',
        queryParameters: {'query': tQuery},
      )).thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.searchMovies(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('error handling', () {
    test('should handle generic error in getNowPlayingMovies', () async {
      // arrange
      when(mockDio.get('/movie/now_playing')).thenThrow(Exception('Test error'));
      // act & assert
      expect(
        () => dataSource.getNowPlayingMovies(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle generic error in getPopularMovies', () async {
      // arrange
      when(mockDio.get('/movie/popular')).thenThrow(Exception('Test error'));
      // act & assert
      expect(
        () => dataSource.getPopularMovies(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle generic error in getTopRatedMovies', () async {
      // arrange
      when(mockDio.get('/movie/top_rated')).thenThrow(Exception('Test error'));
      // act & assert
      expect(
        () => dataSource.getTopRatedMovies(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle generic error in getMovieDetail', () async {
      // arrange
      when(mockDio.get('/movie/1')).thenThrow(Exception('Test error'));
      // act & assert
      expect(
        () => dataSource.getMovieDetail(1),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle generic error in getMovieRecommendations', () async {
      // arrange
      when(mockDio.get('/movie/1/recommendations')).thenThrow(Exception('Test error'));
      // act & assert
      expect(
        () => dataSource.getMovieRecommendations(1),
        throwsA(isA<ServerException>()),
      );
    });
  });
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .movieList;
    const tQuery = 'Spiderman';

    test('should return list of movies when response is successful', () async {
      // arrange
      when(mockDio.get('/search/movie', queryParameters: {'query': tQuery}))
          .thenAnswer((_) => mockResponse(
              readJson('dummy_data/search_spiderman_movie.json'), 200));
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response fails', () async {
      // arrange
      when(mockDio.get('/search/movie', queryParameters: {'query': tQuery}))
          .thenThrow(
        DioException(
          response: Response<dynamic>(
            statusCode: 404,
            data: {'status_message': 'Not Found'},
            requestOptions: RequestOptions(path: ''),
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );
      // act
      final call = dataSource.searchMovies(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  }

