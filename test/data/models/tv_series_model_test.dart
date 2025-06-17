import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart' as tv_series_entity;

void main() {
  final tTvSeriesDetailModel = TvSeriesDetailModel(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [45],
    firstAirDate: '2020-01-01',
    genres: [
      GenreModel(id: 1, name: 'Drama'),
      GenreModel(id: 2, name: 'Action'),
    ],
    id: 1,
    name: 'Test Series',
    originalName: 'Test Series Original',
    overview: 'Test overview',
    posterPath: '/poster.jpg',
    voteAverage: 8.5,
    voteCount: 1000,
    originCountry: ['US'],
    originalLanguage: 'en',
    popularity: 100.0,
    status: 'Returning Series',
    tagline: 'Test tagline',
    type: 'Scripted',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  final tTvSeriesDetailEntity = tv_series_entity.TvSeriesDetail(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [45],
    firstAirDate: '2020-01-01',
    genres: [
      const tv_series_entity.Genre(id: 1, name: 'Drama'),
      const tv_series_entity.Genre(id: 2, name: 'Action'),
    ],
    id: 1,
    name: 'Test Series',
    originalName: 'Test Series Original',
    overview: 'Test overview',
    posterPath: '/poster.jpg',
    voteAverage: 8.5,
    voteCount: 1000,
    originCountry: ['US'],
    originalLanguage: 'en',
    popularity: 100.0,
    status: 'Returning Series',
    tagline: 'Test tagline',
    type: 'Scripted',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  final tTvSeriesDetailJson = {
    'adult': false,
    'backdrop_path': '/path.jpg',
    'episode_run_time': [45],
    'first_air_date': '2020-01-01',
    'genres': [
      {'id': 1, 'name': 'Drama'},
      {'id': 2, 'name': 'Action'},
    ],
    'id': 1,
    'name': 'Test Series',
    'original_name': 'Test Series Original',
    'overview': 'Test overview',
    'poster_path': '/poster.jpg',
    'vote_average': 8.5,
    'vote_count': 1000,
    'origin_country': ['US'],
    'original_language': 'en',
    'popularity': 100.0,
    'status': 'Returning Series',
    'tagline': 'Test tagline',
    'type': 'Scripted',
    'number_of_episodes': 10,
    'number_of_seasons': 2,
  };

  group('TvSeriesDetailModel', () {
    test('should be a subclass of Equatable', () {
      expect(tTvSeriesDetailModel.props.isNotEmpty, true);
    });

    test('should return a valid model from JSON', () {
      // Arrange
      final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(tTvSeriesDetailJson);
      
      // Act
      final result = TvSeriesDetailModel.fromJson(jsonMap);
      
      // Assert
      expect(result, tTvSeriesDetailModel);
    });

    test('should return a JSON map containing proper data', () {
      // Act
      final result = tTvSeriesDetailModel.toJson();
      
      // Assert
      final expectedMap = {
        'adult': false,
        'backdrop_path': '/path.jpg',
        'episode_run_time': [45],
        'first_air_date': '2020-01-01',
        'genres': [
          {'id': 1, 'name': 'Drama'},
          {'id': 2, 'name': 'Action'},
        ],
        'id': 1,
        'name': 'Test Series',
        'original_name': 'Test Series Original',
        'overview': 'Test overview',
        'poster_path': '/poster.jpg',
        'vote_average': 8.5,
        'vote_count': 1000,
        'origin_country': ['US'],
        'original_language': 'en',
        'popularity': 100.0,
        'status': 'Returning Series',
        'tagline': 'Test tagline',
        'type': 'Scripted',
      };
      
      expect(result, expectedMap);
    });

    test('should return a TvSeriesDetail entity', () {
      // Act
      final result = tTvSeriesDetailModel.toEntity();
      
      // Assert
      expect(result, tTvSeriesDetailEntity);
    });
  });

  group('TvSeriesDetailResponse', () {
    test('should return a valid response from JSON', () {
      // Arrange
      final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(tTvSeriesDetailJson);
      
      // Act
      final result = TvSeriesDetailResponse.fromJson(jsonMap);
      
      // Assert
      expect(result.tvSeriesDetail, tTvSeriesDetailModel);
      expect(result.error, '');
    });

    test('should return error response', () {
      // Arrange
      const errorMessage = 'Error message';
      
      // Act
      final result = TvSeriesDetailResponse.withError(errorMessage);
      
      // Assert
      expect(result.tvSeriesDetail, isA<TvSeriesDetailModel>());
      expect(result.error, errorMessage);
    });
  });

  group('GenreModel', () {
    test('should return a valid model from JSON', () {
      // Arrange
      final jsonMap = {'id': 1, 'name': 'Drama'};
      
      // Act
      final result = GenreModel.fromJson(jsonMap);
      
      // Assert
      expect(result, GenreModel(id: 1, name: 'Drama'));
    });

    test('should return a JSON map containing proper data', () {
      // Arrange
      final genre = GenreModel(id: 1, name: 'Drama');
      
      // Act
      final result = genre.toJson();
      
      // Assert
      expect(result, {'id': 1, 'name': 'Drama'});
    });

    test('should return a Genre entity', () {
      // Arrange
      final genreModel = GenreModel(id: 1, name: 'Drama');
      
      // Act
      final result = genreModel.toEntity();
      
      // Assert
      expect(result, isA<tv_series_entity.Genre>());
    });
  });
}