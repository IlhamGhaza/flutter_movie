import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';

void main() {
  const tSeasonDetail = SeasonDetail(
    airDate: '2023-01-01',
    episodes: [],
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodeCount: 10,
  );

  const tDifferentSeasonDetail = SeasonDetail(
    airDate: '2023-01-01',
    episodes: [],
    id: 1,
    name: 'Different Name',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodeCount: 10,
  );

  group('SeasonDetail', () {
    test('should be a subclass of Equatable', () {
      expect(tSeasonDetail, isA<Equatable>());
    });

    test('should have correct property values', () {
      // Assert
      expect(tSeasonDetail.airDate, '2023-01-01');
      expect(tSeasonDetail.episodes, []);
      expect(tSeasonDetail.id, 1);
      expect(tSeasonDetail.name, 'Season 1');
      expect(tSeasonDetail.overview, 'Overview');
      expect(tSeasonDetail.posterPath, '/poster.jpg');
      expect(tSeasonDetail.seasonNumber, 1);
      expect(tSeasonDetail.episodeCount, 10);
    });

    group('props', () {
      test('should return correct props', () {
        // Arrange
        final expectedProps = [
          '2023-01-01', // airDate
          [],            // episodes
          1,             // id
          'Season 1',    // name
          'Overview',    // overview
          '/poster.jpg', // posterPath
          1,             // seasonNumber
          10,            // episodeCount
        ];

        // Act
        final props = tSeasonDetail.props;

        // Assert
        expect(props, expectedProps);
      });
    });

    group('equality', () {
      test('should return true when comparing same object', () {
        // Arrange & Act
        final season1 = tSeasonDetail;
        final season2 = tSeasonDetail;

        // Assert
        expect(season1, season2);
        expect(season1.hashCode, season2.hashCode);
      });

      test('should return false when comparing with different object', () {
        // Arrange
        final season1 = tSeasonDetail;
        final season2 = tDifferentSeasonDetail;

        // Assert
        expect(season1, isNot(season2));
        expect(season1.hashCode, isNot(season2.hashCode));
      });
    });

    test('should return correct string representation', () {
      // Arrange
      const expectedString = 'SeasonDetail(2023-01-01, [], 1, Season 1, Overview, /poster.jpg, 1, 10)';

      // Act
      final result = tSeasonDetail.toString();

      // Assert
      expect(result, expectedString);
    });
  });
}