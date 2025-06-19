import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_model.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_response.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    id: 1,
    title: 'Test TV Series',
    overview: 'Test Overview',
    posterPath: '/path.jpg',
    voteAverage: 8.5,
    genreIds: [1, 2, 3],
    firstAirDate: '2020-01-01',
    popularity: 100.0,
    voteCount: 1000,
    backdropPath: '/path.jpg',
    originalLanguage: 'en',
    originalName: 'Test TV Series Original',
    name: 'Test TV Series',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  final tTvSeriesResponse = TvSeriesResponse(
    tvSeriesList: [tTvSeriesModel],
    page: 1,
    totalPages: 10,
    totalResults: 100,
  );

  final tTvSeriesResponseJson = {
    'results': [
      {
        'id': 1,
        'name': 'Test TV Series',
        'overview': 'Test Overview',
        'poster_path': '/path.jpg',
        'vote_average': 8.5,
        'genre_ids': [1, 2, 3],
        'first_air_date': '2020-01-01',
        'popularity': 100.0,
        'vote_count': 1000,
        'backdrop_path': '/path.jpg',
        'original_language': 'en',
        'original_name': 'Test TV Series Original',
        'number_of_episodes': 10,
        'number_of_seasons': 2,
      }
    ],
    'page': 1,
    'total_pages': 10,
    'total_results': 100,
  };

  test('should be a subclass of TvSeriesResponse', () {
    expect(tTvSeriesResponse, isA<TvSeriesResponse>());
  });

  test('should return a valid model from JSON', () {
    // arrange
    final Map<String, dynamic> jsonMap = tTvSeriesResponseJson;
    
    // act
    final result = TvSeriesResponse.fromJson(jsonMap);
    
    // assert
    expect(result, isA<TvSeriesResponse>());
    expect(result.page, equals(tTvSeriesResponse.page));
    expect(result.totalPages, equals(tTvSeriesResponse.totalPages));
    expect(result.totalResults, equals(tTvSeriesResponse.totalResults));
    expect(result.tvSeriesList.length, equals(1));
    expect(result.tvSeriesList[0].id, equals(tTvSeriesModel.id));
    expect(result.tvSeriesList[0].title, equals(tTvSeriesModel.title));
  });

  test('should return a JSON map containing proper data', () {
    // act
    final result = tTvSeriesResponse.toJson();
    
    // assert
    final expectedMap = tTvSeriesResponseJson;
    expect(result['page'], equals(expectedMap['page']));
    expect(result['total_pages'], equals(expectedMap['total_pages']));
    expect(result['total_results'], equals(expectedMap['total_results']));
    expect((result['results'] as List).length, equals(1));
  });

  test('should return empty list when results is null', () {
    // arrange
    final json = {'results': null, 'page': 1, 'total_pages': 1, 'total_results': 0};
    
    // act
    final result = TvSeriesResponse.fromJson(json);
    
    // assert
    expect(result.tvSeriesList, isEmpty);
  });

  test('should handle empty results list', () {
    // arrange
    final json = {'results': [], 'page': 1, 'total_pages': 0, 'total_results': 0};
    
    // act
    final result = TvSeriesResponse.fromJson(json);
    
    // assert
    expect(result.tvSeriesList, isEmpty);
  });
}