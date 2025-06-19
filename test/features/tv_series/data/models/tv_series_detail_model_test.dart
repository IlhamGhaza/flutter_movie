import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_detail_model.dart';

void main() {
  const tTvSeriesDetailModel = TvSeriesDetailModel(
    id: 1,
    name: 'Test TV Series',
    originalName: 'Test Original Name',
    overview: 'Test Overview',
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
    voteAverage: 8.5,
    voteCount: 100,
    firstAirDate: '2023-01-01',
    episodeRunTime: [45, 50],
    genres: [
      GenreModel(id: 1, name: 'Drama'),
      GenreModel(id: 2, name: 'Thriller'),
    ],
    originCountry: ['US'],
    originalLanguage: 'en',
    popularity: 85.5,
    status: 'Returning Series',
    tagline: 'Test Tagline',
    type: 'Scripted',
    adult: false,
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  const tTvSeriesDetailJson = {
    'id': 1,
    'name': 'Test TV Series',
    'original_name': 'Test Original Name',
    'overview': 'Test Overview',
    'poster_path': '/test_poster.jpg',
    'backdrop_path': '/test_backdrop.jpg',
    'vote_average': 8.5,
    'vote_count': 100,
    'first_air_date': '2023-01-01',
    'episode_run_time': [45, 50],
    'genres': [
      {'id': 1, 'name': 'Drama'},
      {'id': 2, 'name': 'Thriller'},
    ],
    'origin_country': ['US'],
    'original_language': 'en',
    'popularity': 85.5,
    'status': 'Returning Series',
    'tagline': 'Test Tagline',
    'type': 'Scripted',
    'adult': false,
    'number_of_episodes': 10,
    'number_of_seasons': 2,
  };

  group('TvSeriesDetailModel', () {
    test('should be a subclass of Equatable', () {
      expect(tTvSeriesDetailModel, isA<Equatable>());
    });

    test('props should contain all properties', () {
      // Arrange
      const model = tTvSeriesDetailModel;
      
      // Act & Assert
      expect(
        model.props,
        containsAll([
          model.adult,
          model.backdropPath,
          model.episodeRunTime,
          model.firstAirDate,
          model.genres,
          model.id,
          model.name,
          model.originalName,
          model.overview,
          model.posterPath,
          model.voteAverage,
          model.voteCount,
          model.originCountry,
          model.originalLanguage,
          model.popularity,
          model.status,
          model.tagline,
          model.type,
        ]),
      );
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'id': null,
        'name': null,
        'original_name': null,
        'overview': null,
        'poster_path': null,
        'backdrop_path': null,
        'vote_average': null,
        'vote_count': null,
        'first_air_date': null,
        'episode_run_time': null,
        'genres': null,
        'origin_country': null,
        'original_language': null,
        'popularity': null,
        'status': null,
        'tagline': null,
        'type': null,
        'adult': null,
        'number_of_episodes': null,
        'number_of_seasons': null,
      };

      // Act
      final result = TvSeriesDetailModel.fromJson(json);

      // Assert
      expect(result.id, 0);
      expect(result.name, '');
      expect(result.originalName, '');
      expect(result.overview, '');
      expect(result.posterPath, null);
      expect(result.backdropPath, null);
      expect(result.voteAverage, 0.0);
      expect(result.voteCount, 0);
      expect(result.firstAirDate, '');
      expect(result.episodeRunTime, isEmpty);
      expect(result.genres, isEmpty);
      expect(result.originCountry, isEmpty);
      expect(result.originalLanguage, 'en'); // Default value
      expect(result.popularity, 0.0);
      expect(result.status, '');
      expect(result.tagline, '');
      expect(result.type, '');
      expect(result.adult, false);
      expect(result.numberOfEpisodes, 0);
      expect(result.numberOfSeasons, 0);
    });

    test('should handle empty factory constructor', () {
      // Act
      final emptyModel = TvSeriesDetailModel.empty();

      // Assert
      expect(emptyModel.id, 0);
      expect(emptyModel.name, '');
      expect(emptyModel.originalName, '');
      expect(emptyModel.overview, '');
      expect(emptyModel.posterPath, '');
      expect(emptyModel.voteAverage, 0.0);
      expect(emptyModel.episodeRunTime, isEmpty);
      expect(emptyModel.genres, isEmpty);
      expect(emptyModel.originCountry, isEmpty);
      expect(emptyModel.numberOfEpisodes, 0);
    });

    test('should return a valid model from JSON', () {
      // Act
      final result = TvSeriesDetailModel.fromJson(tTvSeriesDetailJson);

      // Assert
      expect(result, isA<TvSeriesDetailModel>());
      expect(result.id, equals(1));
      expect(result.name, equals('Test TV Series'));
      expect(result.originalName, equals('Test Original Name'));
      expect(result.overview, equals('Test Overview'));
      expect(result.posterPath, equals('/test_poster.jpg'));
      expect(result.voteAverage, equals(8.5));
      expect(result.voteCount, equals(100));
      expect(result.firstAirDate, equals('2023-01-01'));
      expect(result.episodeRunTime, equals([45, 50]));
      expect(result.genres.length, equals(2));
      expect(result.genres[0].name, equals('Drama'));
      expect(result.originCountry, equals(['US']));
      expect(result.originalLanguage, equals('en'));
      expect(result.popularity, equals(85.5));
      expect(result.status, equals('Returning Series'));
      expect(result.tagline, equals('Test Tagline'));
      expect(result.type, equals('Scripted'));
      expect(result.adult, equals(false));
      expect(result.numberOfEpisodes, equals(10));
      expect(result.numberOfSeasons, equals(2));
    });

    test('should return a JSON map containing proper data', () {
      // Act
      final result = tTvSeriesDetailModel.toJson();

      // Assert
      final expectedMap = {
        'adult': false,
        'backdrop_path': '/test_backdrop.jpg',
        'episode_run_time': [45, 50],
        'first_air_date': '2023-01-01',
        'genres': [
          {'id': 1, 'name': 'Drama'},
          {'id': 2, 'name': 'Thriller'},
        ],
        'id': 1,
        'name': 'Test TV Series',
        'original_name': 'Test Original Name',
        'overview': 'Test Overview',
        'poster_path': '/test_poster.jpg',
        'vote_average': 8.5,
        'vote_count': 100,
        'origin_country': ['US'],
        'original_language': 'en',
        'popularity': 85.5,
        'status': 'Returning Series',
        'tagline': 'Test Tagline',
        'type': 'Scripted',
      };
      expect(result, equals(expectedMap));
    });

    test('should convert to entity', () {
      // Act
      final result = tTvSeriesDetailModel.toEntity();

      // Assert
      expect(result, isA<TvSeriesDetail>());
      expect(result.id, equals(1));
      expect(result.name, equals('Test TV Series'));
      expect(result.genres.length, equals(2));
      expect(result.genres[0].name, equals('Drama'));
    });

    test('should handle empty or null values in JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = TvSeriesDetailModel.fromJson(json);

      // Assert
      expect(result, isA<TvSeriesDetailModel>());
      expect(result.id, equals(0));
      expect(result.name, isEmpty);
      expect(result.genres, isEmpty);
      expect(result.episodeRunTime, isEmpty);
      expect(result.originCountry, isEmpty);
    });
  });

  group('TvSeriesDetailResponse', () {
    test('should create response with error', () {
      // Arrange
      const errorMessage = 'Error message';

      // Act
      final response = TvSeriesDetailResponse.withError(errorMessage);

      // Assert
      expect(response.error, equals(errorMessage));
      expect(response.tvSeriesDetail, isA<TvSeriesDetailModel>());
      expect(response.tvSeriesDetail.id, 0); // Should use empty model
    });

    test('should have const constructor', () {
      // Arrange
      const response = TvSeriesDetailResponse(
        tvSeriesDetail: tTvSeriesDetailModel,
        error: '',
      );

      // Assert
      expect(response.tvSeriesDetail, tTvSeriesDetailModel);
      expect(response.error, '');
    });

    test('should create response from JSON', () {
      // Act
      final response = TvSeriesDetailResponse.fromJson(tTvSeriesDetailJson);

      // Assert
      expect(response.error, isEmpty);
      expect(response.tvSeriesDetail, isA<TvSeriesDetailModel>());
      expect(response.tvSeriesDetail.id, equals(1));
    });
  });

  group('GenreModel', () {
    test('should create genre model from JSON', () {
      // Arrange
      final json = {'id': 1, 'name': 'Drama'};

      // Act
      final result = GenreModel.fromJson(json);

      // Assert
      expect(result, isA<GenreModel>());
      expect(result.id, equals(1));
      expect(result.name, equals('Drama'));
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {'id': null, 'name': null};

      // Act
      final result = GenreModel.fromJson(json);

      // Assert
      expect(result.id, 0);
      expect(result.name, '');
    });

    test('should handle string id in JSON', () {
      // Arrange
      final json = {'id': '123', 'name': 'Drama'};

      // Act
      final result = GenreModel.fromJson(json);

      // Assert
      expect(result.id, 123);
      expect(result.name, 'Drama');
    });

    test('props should contain id and name', () {
      // Arrange
      const model = GenreModel(id: 1, name: 'Drama');
      
      // Act & Assert
      expect(model.props, [1, 'Drama']);
    });

    test('should convert to entity', () {
      // Arrange
      const model = GenreModel(id: 1, name: 'Drama');

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, isA<Genre>());
      expect(entity.id, equals(1));
      expect(entity.name, equals('Drama'));
    });
  });
}