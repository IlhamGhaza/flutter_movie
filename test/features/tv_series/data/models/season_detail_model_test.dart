import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/features/tv_series/data/models/season_detail_model.dart';

void main() {
  const tSeasonDetailModel = SeasonDetailModel(
    airDate: '2023-01-01',
    episodes: [
      EpisodeModel(
        id: 1,
        name: 'Pilot',
        overview: 'First episode',
        stillPath: '/path.jpg',
        episodeNumber: 1,
        airDate: '2023-01-01',
        runtime: 60,
        voteAverage: 8.5,
        voteCount: 100,
      ),
    ],
    id: 123,
    name: 'Season 1',
    overview: 'First season',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodeCount: 10,
  );

  const tSeasonDetailResponse = SeasonDetailResponse(
    seasonDetail: tSeasonDetailModel,
    error: '',
  );

  final tSeasonDetailJson = {
    '_id': 123,
    'air_date': '2023-01-01',
    'episodes': [
      {
        'id': 1,
        'name': 'Pilot',
        'overview': 'First episode',
        'still_path': '/path.jpg',
        'episode_number': 1,
        'air_date': '2023-01-01',
        'runtime': 60,
        'vote_average': 8.5,
        'vote_count': 100,
      },
    ],
    'name': 'Season 1',
    'overview': 'First season',
    'poster_path': '/poster.jpg',
    'season_number': 1,
  };

  group('SeasonDetailModel', () {
    test('should be a subclass of Equatable', () {
      expect(tSeasonDetailModel.props, isNotNull);
    });

    test('should create a valid model from JSON', () {
      // Act
      final result = SeasonDetailModel.fromJson(tSeasonDetailJson);
      
      // Assert
      expect(result.id, equals(123));
      expect(result.name, equals('Season 1'));
      expect(result.episodes.length, equals(1));
      expect(result.episodes[0].name, equals('Pilot'));
    });

    test('should handle missing fields in JSON', () {
      // Arrange
      final json = {'name': 'Season 1'};
      
      // Act
      final result = SeasonDetailModel.fromJson(json);
      
      // Assert
      expect(result.id, equals(0));
      expect(result.name, equals('Season 1'));
      expect(result.episodes, isEmpty);
    });

    test('should convert to JSON', () {
      // Act
      final result = tSeasonDetailModel.toJson();
      
      // Assert
      expect(result['id'], equals(123));
      expect(result['name'], equals('Season 1'));
      expect(result['episodes'], isList);
      expect((result['episodes'] as List).first['name'], equals('Pilot'));
    });

    test('should create empty model', () {
      // Act
      final result = SeasonDetailModel.empty();
      
      // Assert
      expect(result.id, equals(0));
      expect(result.name, isEmpty);
      expect(result.episodes, isEmpty);
    });

    test('should convert to entity', () {
      // Act
      final entity = tSeasonDetailModel.toEntity();
      
      // Assert
      expect(entity.id, equals(123));
      expect(entity.name, equals('Season 1'));
      expect(entity.episodes.length, equals(1));
      expect(entity.episodes.first.name, equals('Pilot'));
    });
  });

  group('SeasonDetailResponse', () {
    test('should create response from JSON', () {
      // Act
      final result = SeasonDetailResponse.fromJson(tSeasonDetailJson);
      
      // Assert
      expect(result.seasonDetail.id, equals(123));
      expect(result.error, isEmpty);
    });

    test('should create response with error', () {
      // Arrange
      const errorMessage = 'Error message';
      
      // Act
      final result = SeasonDetailResponse.withError(errorMessage);
      
      // Assert
      expect(result.seasonDetail.id, equals(0));
      expect(result.error, equals(errorMessage));
    });

    test('should convert to entity', () {
      // Act
      final entity = tSeasonDetailResponse.toEntity();
      
      // Assert
      expect(entity.id, equals(123));
      expect(entity.name, equals('Season 1'));
      expect(entity.episodes.length, equals(1));
      expect(entity.episodes.first.name, equals('Pilot'));
    });
  });

  group('EpisodeModel', () {
    const tEpisode = EpisodeModel(
      id: 1,
      name: 'Pilot',
      overview: 'First episode',
      stillPath: '/path.jpg',
      episodeNumber: 1,
      airDate: '2023-01-01',
      runtime: 60,
      voteAverage: 8.5,
      voteCount: 100,
    );

    final tEpisodeJson = {
      'id': 1,
      'name': 'Pilot',
      'overview': 'First episode',
      'still_path': '/path.jpg',
      'episode_number': 1,
      'air_date': '2023-01-01',
      'runtime': 60,
      'vote_average': 8.5,
      'vote_count': 100,
    };

    test('should be a subclass of Equatable', () {
      expect(tEpisode.props, isNotNull);
    });

    test('should create a valid model from JSON', () {
      // Act
      final result = EpisodeModel.fromJson(tEpisodeJson);
      
      // Assert
      expect(result.id, equals(1));
      expect(result.name, equals('Pilot'));
      expect(result.stillPath, equals('/path.jpg'));
    });

    test('should handle missing fields in JSON', () {
      // Arrange
      final json = {'name': 'Pilot'};
      
      // Act
      final result = EpisodeModel.fromJson(json);
      
      // Assert
      expect(result.id, equals(0));
      expect(result.name, equals('Pilot'));
      expect(result.stillPath, isNull);
    });

    test('should convert to JSON', () {
      // Act
      final result = tEpisode.toJson();
      
      // Assert
      expect(result['id'], equals(1));
      expect(result['name'], equals('Pilot'));
      expect(result['still_path'], equals('/path.jpg'));
    });
  });
}