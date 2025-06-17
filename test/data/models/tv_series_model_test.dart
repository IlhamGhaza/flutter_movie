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

    test('should have correct string representation', () {
      // Act
      final result = tTvSeriesDetailModel.toString();
      
      // Assert
      expect(result, contains('TvSeriesDetailModel'));
      expect(result, contains('Test Series'));
      expect(result, contains('1'));
    });

    test('should handle non-integer episode run time values', () {
      // Arrange
      final jsonWithNonIntRunTime = Map<String, dynamic>.from(tTvSeriesDetailJson)
        ..['episode_run_time'] = ['45', 60, null, 'invalid'];
      
      // Act
      final result = TvSeriesDetailModel.fromJson(jsonWithNonIntRunTime);
      
      // Assert
      expect(result.episodeRunTime, equals([0, 60, 0, 0]));
    });

    test('should handle null genres list', () {
      // Arrange
      final jsonWithNullGenres = Map<String, dynamic>.from(tTvSeriesDetailJson)
        ..['genres'] = null;
      
      // Act
      final result = TvSeriesDetailModel.fromJson(jsonWithNullGenres);
      
      // Assert
      expect(result.genres, isEmpty);
    });

    test('should handle empty genres list', () {
      // Arrange
      final jsonWithEmptyGenres = Map<String, dynamic>.from(tTvSeriesDetailJson)
        ..['genres'] = [];
      
      // Act
      final result = TvSeriesDetailModel.fromJson(jsonWithEmptyGenres);
      
      // Assert
      expect(result.genres, isEmpty);
    });

    test('should handle null origin country list', () {
      // Arrange
      final jsonWithNullOriginCountry = Map<String, dynamic>.from(tTvSeriesDetailJson)
        ..['origin_country'] = null;
      
      // Act
      final result = TvSeriesDetailModel.fromJson(jsonWithNullOriginCountry);
      
      // Assert
      expect(result.originCountry, isEmpty);
    });

    test('should handle non-string origin country values', () {
      // Arrange
      final jsonWithNonStringOriginCountry = Map<String, dynamic>.from(tTvSeriesDetailJson)
        ..['origin_country'] = [1, 'US', null, 3.14];
      
      // Act
      final result = TvSeriesDetailModel.fromJson(jsonWithNonStringOriginCountry);
      
      // Assert
      expect(result.originCountry, equals(['1', 'US', 'null', '3.14']));
    });

    test('should return a valid model from JSON', () {
      // Arrange
      final Map<String, dynamic> jsonMap =
          Map<String, dynamic>.from(tTvSeriesDetailJson);

      // Act
      final result = TvSeriesDetailModel.fromJson(jsonMap);

      // Assert
      expect(result, tTvSeriesDetailModel);
    });

    test('should handle null values in fromJson', () {
      // Arrange
      final jsonWithNulls = {
        'adult': null,
        'backdrop_path': null,
        'episode_run_time': null,
        'first_air_date': null,
        'genres': null,
        'id': 1,
        'name': null,
        'original_name': null,
        'overview': null,
        'poster_path': null,
        'vote_average': null,
        'vote_count': null,
        'origin_country': null,
        'original_language': null,
        'popularity': null,
        'status': null,
        'tagline': null,
        'type': null,
        'number_of_episodes': null,
        'number_of_seasons': null,
      };

      // Act
      final result = TvSeriesDetailModel.fromJson(jsonWithNulls);

      // Assert
      expect(result.id, equals(1));
      expect(result.adult, isFalse);
      expect(result.backdropPath, isNull);
      expect(result.episodeRunTime, isEmpty);
      expect(result.firstAirDate, isEmpty);
      expect(result.genres, isEmpty);
      expect(result.name, isEmpty);
      expect(result.originalName, isEmpty);
      expect(result.overview, isEmpty);
      expect(result.posterPath, isNull);
      expect(result.voteAverage, equals(0.0));
      expect(result.voteCount, equals(0));
      expect(result.originCountry, isEmpty);
      expect(result.originalLanguage, equals('en'));
      expect(result.popularity, equals(0.0));
      expect(result.status, isEmpty);
      expect(result.tagline, isEmpty);
      expect(result.type, isEmpty);
      expect(result.numberOfEpisodes, equals(0));
      expect(result.numberOfSeasons, equals(0));
    });

    test('should handle empty JSON object', () {
      // Act
      final result = TvSeriesDetailModel.fromJson({});

      // Assert
      expect(result.id, equals(0));
      expect(result.adult, isFalse);
      expect(result.backdropPath, isNull);
      expect(result.episodeRunTime, isEmpty);
      expect(result.firstAirDate, isEmpty);
      expect(result.genres, isEmpty);
      expect(result.name, isEmpty);
      expect(result.originalName, isEmpty);
      expect(result.overview, isEmpty);
      expect(result.posterPath, isNull);
      expect(result.voteAverage, equals(0.0));
      expect(result.voteCount, equals(0));
      expect(result.originCountry, isEmpty);
      expect(result.originalLanguage, equals('en'));
      expect(result.popularity, equals(0.0));
      expect(result.status, isEmpty);
      expect(result.tagline, isEmpty);
      expect(result.type, isEmpty);
      expect(result.numberOfEpisodes, equals(0));
      expect(result.numberOfSeasons, equals(0));
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

    test('should handle null values in toJson', () {
      // Arrange
      final modelWithNulls = TvSeriesDetailModel(
        adult: false,
        backdropPath: null,
        episodeRunTime: [],
        firstAirDate: '',
        genres: [],
        id: 0,
        name: '',
        originalName: '',
        overview: '',
        posterPath: null,
        voteAverage: 0,
        voteCount: 0,
        originCountry: [],
        originalLanguage: '',
        popularity: 0,
        status: '',
        tagline: '',
        type: '',
        numberOfEpisodes: 0,
        numberOfSeasons: 0,
      );
      
      // Act
      final result = modelWithNulls.toJson();
      
      // Assert
      expect(result['backdrop_path'], isNull);
      expect(result['poster_path'], isNull);
      expect(result['episode_run_time'], isList);
      expect(result['genres'], isList);
      expect(result['origin_country'], isList);
    });

    test('should return correct props', () {
      // Arrange
      final props = tTvSeriesDetailModel.props;

      // Assert
      expect(props, [
        false, // adult
        '/path.jpg', // backdropPath
        [45], // episodeRunTime
        '2020-01-01', // firstAirDate
        [
          GenreModel(id: 1, name: 'Drama'),
          GenreModel(id: 2, name: 'Action'),
        ], // genres
        1, // id
        'Test Series', // name
        'Test Series Original', // originalName
        'Test overview', // overview
        '/poster.jpg', // posterPath
        8.5, // voteAverage
        1000, // voteCount
        ['US'], // originCountry
        'en', // originalLanguage
        100.0, // popularity
        'Returning Series', // status
        'Test tagline', // tagline
        'Scripted', // type
      ]);
    });

    test('should return correct string representation', () {
      // Act
      final result = tTvSeriesDetailModel.toString();

      // Assert
      expect(
        result,
        contains('TvSeriesDetailModel'),
      );
    });

    test('should return a TvSeriesDetail entity', () {
      // Act
      final result = tTvSeriesDetailModel.toEntity();

      // Assert
      expect(result, tTvSeriesDetailEntity);
      expect(result.id, equals(tTvSeriesDetailEntity.id));
      expect(result.name, equals(tTvSeriesDetailEntity.name));
      expect(result.overview, equals(tTvSeriesDetailEntity.overview));
      expect(result.posterPath, equals(tTvSeriesDetailEntity.posterPath));
      expect(result.voteAverage, equals(tTvSeriesDetailEntity.voteAverage));
      expect(result.voteCount, equals(tTvSeriesDetailEntity.voteCount));
      expect(result.genres.length, equals(tTvSeriesDetailEntity.genres.length));
      expect(result.firstAirDate, equals(tTvSeriesDetailEntity.firstAirDate));
    });

    test('empty() should return a model with default values', () {
      // Act
      final result = TvSeriesDetailModel.empty();

      // Assert
      expect(result.id, equals(0));
      expect(result.adult, isFalse);
      expect(result.backdropPath, isEmpty);
      expect(result.episodeRunTime, isEmpty);
      expect(result.firstAirDate, isEmpty);
      expect(result.genres, isEmpty);
      expect(result.name, isEmpty);
      expect(result.originalName, isEmpty);
      expect(result.overview, isEmpty);
      expect(result.posterPath, isEmpty);
      expect(result.voteAverage, equals(0.0));
      expect(result.voteCount, equals(0));
      expect(result.originCountry, isEmpty);
      expect(result.originalLanguage, isEmpty);
      expect(result.popularity, equals(0.0));
      expect(result.status, isEmpty);
      expect(result.tagline, isEmpty);
      expect(result.type, isEmpty);
      expect(result.numberOfEpisodes, equals(0));
      expect(result.numberOfSeasons, equals(0));
    });
  });

  group('TvSeriesDetailResponse', () {
    test('should return a valid response from JSON', () {
      // Arrange
      final Map<String, dynamic> jsonMap =
          Map<String, dynamic>.from(tTvSeriesDetailJson);

      // Act
      final result = TvSeriesDetailResponse.fromJson(jsonMap);

      // Assert
      expect(result.tvSeriesDetail, tTvSeriesDetailModel);
      expect(result.error, '');
    });

    test('should have correct string representation', () {
      // Arrange
      final response = TvSeriesDetailResponse(
        tvSeriesDetail: tTvSeriesDetailModel,
        error: 'test-error',
      );
      
      // Act
      final result = response.toString();
      
      // Assert
      expect(result, contains('TvSeriesDetailResponse'));
    });

    test('should handle empty JSON object', () {
      // Arrange
      final emptyJson = <String, dynamic>{};

      // Act
      final result = TvSeriesDetailResponse.fromJson(emptyJson);

      // Assert
      expect(result.tvSeriesDetail, isA<TvSeriesDetailModel>());
      expect(result.error, '');
      expect(result.tvSeriesDetail.id, equals(0));
    });

    test('should handle JSON with null values', () {
      // Arrange
      final jsonWithNulls = {
        'adult': null,
        'backdrop_path': null,
        'episode_run_time': null,
        'first_air_date': null,
        'genres': null,
        'id': 1,
        'name': null,
        'original_name': null,
        'overview': null,
        'poster_path': null,
        'vote_average': null,
        'vote_count': null,
        'origin_country': null,
        'original_language': null,
        'popularity': null,
        'status': null,
        'tagline': null,
        'type': null,
        'number_of_episodes': null,
        'number_of_seasons': null,
      };

      // Act
      final result = TvSeriesDetailResponse.fromJson(jsonWithNulls);

      // Assert
      expect(result.tvSeriesDetail.id, equals(1));
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
      expect(result.tvSeriesDetail.id, equals(0)); // Default empty model
    });

    test('should have const constructor', () {
      // Arrange
      final response = TvSeriesDetailResponse(
        tvSeriesDetail: TvSeriesDetailModel.empty(),
        error: '', 
      );

      // Assert
      expect(response.error, '');
      expect(response.tvSeriesDetail, isA<TvSeriesDetailModel>());
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

    test('should handle JSON with string id', () {
      // Arrange
      final jsonMap = {'id': '123', 'name': 'Drama'};
      
      // Act
      final result = GenreModel.fromJson(jsonMap);
      
      // Assert
      expect(result, GenreModel(id: 123, name: 'Drama'));
    });
    
    test('should handle JSON with double id', () {
      // Arrange
      final jsonMap = {'id': 1.5, 'name': 'Drama'};
      
      // Act
      final result = GenreModel.fromJson(jsonMap);
      
      // Assert
      expect(result, GenreModel(id: 1, name: 'Drama'));
    });

    test('should handle null values in fromJson', () {
      // Arrange
      final jsonWithNulls = {'id': null, 'name': null};

      // Act
      final result = GenreModel.fromJson(jsonWithNulls);

      // Assert
      expect(result, GenreModel(id: 0, name: ''));
    });

    test('should handle empty JSON object', () {
      // Act
      final result = GenreModel.fromJson({});

      // Assert
      expect(result, GenreModel(id: 0, name: ''));
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
      expect(result.id, equals(1));
      expect(result.name, equals('Drama'));
    });

    test('props should contain correct values', () {
      // Arrange
      const genreModel = GenreModel(id: 1, name: 'Drama');

      // Act
      final props = genreModel.props;

      // Assert
      expect(props, [1, 'Drama']);
    });

    test('should have correct string representation', () {
      // Arrange
      const genreModel = GenreModel(id: 1, name: 'Drama');

      // Act
      final result = genreModel.toString();

      // Assert
      expect(result, contains('GenreModel'));
    });

    test('should be equatable', () {
      // Arrange
      final genre1 = GenreModel(id: 1, name: 'Drama');
      final genre2 = GenreModel(id: 1, name: 'Drama');
      final genre3 = GenreModel(id: 2, name: 'Action');

      // Assert
      expect(genre1 == genre2, isTrue);
      expect(genre1 == genre3, isFalse);
    });
  });
}
