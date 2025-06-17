import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import '../../json_reader.dart';

class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #get,
        [path],
        {
          #data: data,
          #queryParameters: queryParameters,
          #options: options,
          #cancelToken: cancelToken,
          #onReceiveProgress: onReceiveProgress,
        },
      ),
      returnValue: Future.value(Response<T>(
        requestOptions: RequestOptions(path: path),
        data: null,
      )),
    ) as Future<Response<T>>;
  }
}

void main() {
  late TVSeriesRemoteDataSource dataSource;
  late DioAdapter dioAdapter;
  late Dio dio;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    dataSource = TVSeriesRemoteDataSource(client: dio);
  });

  group('getNowPlayingTvSeries', () {
    test('should return list of TV series when response code is 200', () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/on_the_air.json'));
      dioAdapter.onGet(
        '/tv/on_the_air',
        (request) => request.reply(200, jsonData),
        queryParameters: <String, dynamic>{},
      );

      // act
      final result = await dataSource.getNowPlayingTvSeries();

      // assert
      expect(result, isA<List<TvSeriesModel>>());
    });

    test('should throw ServerException when response code is 404', () async {
      // arrange
      dioAdapter.onGet(
        '/tv/on_the_air',
        (request) => request.reply(404, null),
        queryParameters: <String, dynamic>{},
      );

      // act & assert
      expect(
        () => dataSource.getNowPlayingTvSeries(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPopularTvSeries', () {
    test('should return list of popular TV series when response code is 200',
        () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/popular_tv_series.json'));
      dioAdapter.onGet(
        '/tv/popular',
        (request) => request.reply(200, jsonData),
        queryParameters: <String, dynamic>{},
      );

      // act
      final result = await dataSource.getPopularTvSeries();

      // assert
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should throw ServerException when response code is 404', () async {
      // arrange
      dioAdapter.onGet(
        '/tv/popular',
        (request) => request.reply(404, null),
        queryParameters: <String, dynamic>{},
      );

      // act & assert
      expect(
        () => dataSource.getPopularTvSeries(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when response is not 200', () async {
      // arrange
      dioAdapter.onGet(
        '/tv/popular',
        (request) => request.reply(500, {'status_message': 'Internal Server Error'}),
        queryParameters: <String, dynamic>{},
      );

      // act & assert
      expect(
        () => dataSource.getPopularTvSeries(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getTopRatedTvSeries', () {
    test('should return list of top rated TV series when response code is 200',
        () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/top_rated_tv_series.json'));
      dioAdapter.onGet(
        '/tv/top_rated',
        (request) => request.reply(200, jsonData),
        queryParameters: <String, dynamic>{},
      );

      // act
      final result = await dataSource.getTopRatedTvSeries();

      // assert
      expect(result, isA<List<TvSeriesModel>>());
    });
  });

  group('getTvSeriesDetail', () {
    const tId = 1;

    test('should return TV series detail when response code is 200', () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/tv_series_detail.json'));
      dioAdapter.onGet(
        '/tv/$tId',
        (request) => request.reply(200, jsonData),
        queryParameters: <String, dynamic>{},
      );

      // act
      final result = await dataSource.getTvSeriesDetail(tId);

      // assert
      expect(result, isA<TvSeriesDetailModel>());
    });
  });

  group('getTvSeriesRecommendations', () {
    const tId = 1;
    test('should return list of TV series recommendations when response code is 200',
        () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/tv_series_recommendations.json'));
      dioAdapter.onGet(
        '/tv/$tId/recommendations',
        (request) => request.reply(200, jsonData),
        queryParameters: <String, dynamic>{},
      );

      // act
      final result = await dataSource.getTvSeriesRecommendations(tId);

      // assert
      expect(result, isA<List<TvSeriesModel>>());
    });
  });

  group('searchTvSeries', () {
    const tQuery = 'Squid Game';

    test('should return list of TV series when response code is 200', () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/search_tv_series.json'));
      dioAdapter.onGet(
        '/search/tv',
        (request) => request.reply(200, jsonData),
        queryParameters: {'query': tQuery},
      );

      // act
      final result = await dataSource.searchTvSeries(tQuery);

      // assert
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should return empty list when no results found', () async {
      // arrange
      final emptyResponse = {
        'page': 1,
        'results': [],
        'total_pages': 1,
        'total_results': 0
      };
      dioAdapter.onGet(
        '/search/tv',
        (request) => request.reply(200, emptyResponse),
        queryParameters: {'query': 'nonexistent'},
      );

      // act
      final result = await dataSource.searchTvSeries('nonexistent');

      // assert
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.isEmpty, isTrue);
    });

    test('should throw ServerException when response code is 404', () async {
      // arrange
      dioAdapter.onGet(
        '/search/tv',
        (request) => request.reply(404, null),
        queryParameters: {'query': tQuery},
      );

      // act & assert
      expect(
        () => dataSource.searchTvSeries(tQuery),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('error handling', () {
    test('should handle DioError', () async {
      // arrange
      final mockDio = MockDio();
      when(mockDio.get<Map<String, dynamic>>(
        '/tv/on_the_air',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) => Future.error(DioException(
        requestOptions: RequestOptions(path: '/tv/on_the_air'),
        error: 'Connection error',
        type: DioExceptionType.connectionError,
      )));
      
      final testDataSource = TVSeriesRemoteDataSource(client: mockDio);

      // act & assert
      expect(
        () => testDataSource.getNowPlayingTvSeries(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}