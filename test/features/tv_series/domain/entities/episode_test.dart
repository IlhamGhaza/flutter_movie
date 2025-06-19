import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/features/tv_series/domain/entities/episode.dart';

void main() {
  const tEpisode = Episode(
    id: 1,
    name: 'Test Episode',
    overview: 'Test Overview',
    stillPath: '/test.jpg',
    voteAverage: 8.5,
    voteCount: 100,
    airDate: '2023-01-01',
    episodeNumber: 1,
    seasonNumber: 1,
    runtime: 45,
  );

  group('Episode', () {
    test('should be a subclass of Equatable', () {
      expect(tEpisode, isA<Episode>());
    });

    test('should have correct properties', () {
      expect(tEpisode.id, 1);
      expect(tEpisode.name, 'Test Episode');
      expect(tEpisode.overview, 'Test Overview');
      expect(tEpisode.stillPath, '/test.jpg');
      expect(tEpisode.voteAverage, 8.5);
      expect(tEpisode.voteCount, 100);
      expect(tEpisode.airDate, '2023-01-01');
      expect(tEpisode.episodeNumber, 1);
      expect(tEpisode.seasonNumber, 1);
      expect(tEpisode.runtime, 45);
    });

    test('should support optional parameters with default values', () {
      const episode = Episode(
        id: 1,
        name: 'Test',
        overview: 'Test',
        episodeNumber: 1,
      );
      
      expect(episode.voteAverage, 0.0);
      expect(episode.stillPath, null);
      expect(episode.voteCount, null);
      expect(episode.airDate, null);
      expect(episode.seasonNumber, null);
      expect(episode.runtime, null);
    });

    test('should return correct props', () {
      expect(
        tEpisode.props,
        [
          1, // id
          'Test Episode', // name
          'Test Overview', // overview
          '/test.jpg', // stillPath
          8.5, // voteAverage
          100, // voteCount
          '2023-01-01', // airDate
          1, // episodeNumber
          1, // seasonNumber
          45, // runtime
        ],
      );
    });

    test('should be equal when properties are the same', () {
      final episode1 = const Episode(
        id: 1,
        name: 'Test',
        overview: 'Test',
        episodeNumber: 1,
      );
      
      final episode2 = const Episode(
        id: 1,
        name: 'Test',
        overview: 'Test',
        episodeNumber: 1,
      );
      
      expect(episode1, episode2);
      expect(episode1.props, episode2.props);
    });

    test('should not be equal when properties are different', () {
      final episode1 = const Episode(
        id: 1,
        name: 'Test',
        overview: 'Test',
        episodeNumber: 1,
      );
      
      final episode2 = const Episode(
        id: 2,
        name: 'Different',
        overview: 'Different',
        episodeNumber: 2,
      );
      
      expect(episode1, isNot(episode2));
      expect(episode1.props, isNot(episode2.props));
    });
  });
}