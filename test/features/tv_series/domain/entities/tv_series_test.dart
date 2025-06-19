import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeries = TvSeries(
    id: 1,
    title: 'Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 8.5,
    genreIds: const [18, 10759],
    firstAirDate: '2022-01-01',
    popularity: 100.0,
    voteCount: 1000,
    backdropPath: '/backdrop.jpg',
    originalLanguage: 'en',
    originalName: 'Original Name',
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  group('TvSeries', () {
    test('should be a subclass of TvSeries entity', () {
      expect(tTvSeries, isA<TvSeries>());
    });

    test('should have correct properties', () {
      expect(tTvSeries.id, equals(1));
      expect(tTvSeries.title, equals('Title'));
      expect(tTvSeries.overview, equals('Overview'));
      expect(tTvSeries.posterPath, equals('/path.jpg'));
      expect(tTvSeries.voteAverage, equals(8.5));
      expect(tTvSeries.genreIds, equals([18, 10759]));
      expect(tTvSeries.firstAirDate, equals('2022-01-01'));
      expect(tTvSeries.popularity, equals(100.0));
      expect(tTvSeries.voteCount, equals(1000));
      expect(tTvSeries.backdropPath, equals('/backdrop.jpg'));
      expect(tTvSeries.originalLanguage, equals('en'));
      expect(tTvSeries.originalName, equals('Original Name'));
      expect(tTvSeries.name, equals('Name'));
      expect(tTvSeries.numberOfEpisodes, equals(10));
      expect(tTvSeries.numberOfSeasons, equals(2));
    });

    test('should return true when objects are equal', () {
      final tTvSeries2 = TvSeries(
        id: 1,
        title: 'Title',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.5,
        genreIds: const [18, 10759],
        firstAirDate: '2022-01-01',
        popularity: 100.0,
        voteCount: 1000,
        backdropPath: '/backdrop.jpg',
        originalLanguage: 'en',
        originalName: 'Original Name',
        name: 'Name',
        numberOfEpisodes: 10,
        numberOfSeasons: 2,
      );

      print('tTvSeries: $tTvSeries');
      print('tTvSeries2: $tTvSeries2');
      print('tTvSeries.hashCode: ${tTvSeries.hashCode}');
      print('tTvSeries2.hashCode: ${tTvSeries2.hashCode}');

      print('\nProperty comparisons:');
      print(
          'id: ${tTvSeries.id} == ${tTvSeries2.id} -> ${tTvSeries.id == tTvSeries2.id}');
      print(
          'title: ${tTvSeries.title} == ${tTvSeries2.title} -> ${tTvSeries.title == tTvSeries2.title}');
      print(
          'overview: ${tTvSeries.overview} == ${tTvSeries2.overview} -> ${tTvSeries.overview == tTvSeries2.overview}');
      print(
          'posterPath: ${tTvSeries.posterPath} == ${tTvSeries2.posterPath} -> ${tTvSeries.posterPath == tTvSeries2.posterPath}');
      print(
          'voteAverage: ${tTvSeries.voteAverage} == ${tTvSeries2.voteAverage} -> ${tTvSeries.voteAverage == tTvSeries2.voteAverage}');
      print(
          'genreIds: ${tTvSeries.genreIds} == ${tTvSeries2.genreIds} -> ${tTvSeries.genreIds == tTvSeries2.genreIds}');
      print(
          'firstAirDate: ${tTvSeries.firstAirDate} == ${tTvSeries2.firstAirDate} -> ${tTvSeries.firstAirDate == tTvSeries2.firstAirDate}');
      print(
          'popularity: ${tTvSeries.popularity} == ${tTvSeries2.popularity} -> ${tTvSeries.popularity == tTvSeries2.popularity}');
      print(
          'voteCount: ${tTvSeries.voteCount} == ${tTvSeries2.voteCount} -> ${tTvSeries.voteCount == tTvSeries2.voteCount}');
      print(
          'backdropPath: ${tTvSeries.backdropPath} == ${tTvSeries2.backdropPath} -> ${tTvSeries.backdropPath == tTvSeries2.backdropPath}');
      print(
          'originalLanguage: ${tTvSeries.originalLanguage} == ${tTvSeries2.originalLanguage} -> ${tTvSeries.originalLanguage == tTvSeries2.originalLanguage}');
      print(
          'originalName: ${tTvSeries.originalName} == ${tTvSeries2.originalName} -> ${tTvSeries.originalName == tTvSeries2.originalName}');
      print(
          'name: ${tTvSeries.name} == ${tTvSeries2.name} -> ${tTvSeries.name == tTvSeries2.name}');
      print(
          'numberOfEpisodes: ${tTvSeries.numberOfEpisodes} == ${tTvSeries2.numberOfEpisodes} -> ${tTvSeries.numberOfEpisodes == tTvSeries2.numberOfEpisodes}');
      print(
          'numberOfSeasons: ${tTvSeries.numberOfSeasons} == ${tTvSeries2.numberOfSeasons} -> ${tTvSeries.numberOfSeasons == tTvSeries2.numberOfSeasons}');

      print('\nEquality check: ${tTvSeries == tTvSeries2}');
      print('Hash codes: ${tTvSeries.hashCode} vs ${tTvSeries2.hashCode}');

      expect(tTvSeries == tTvSeries2, isTrue,
          reason: 'Objects with same property values should be equal');
    });

    test('should return false when objects are not equal', () {
      final tTvSeries2 = TvSeries(
        id: 2,
        title: 'Title',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.5,
        genreIds: [18, 10759],
        firstAirDate: '2022-01-01',
        popularity: 100.0,
        voteCount: 1000,
        backdropPath: '/backdrop.jpg',
        originalLanguage: 'en',
        originalName: 'Original Name',
        name: 'Name',
        numberOfEpisodes: 10,
        numberOfSeasons: 2,
      );

      expect(tTvSeries == tTvSeries2, isFalse);
    });

    test('should return correct hash code', () {
      final result = tTvSeries.hashCode;

      expect(result, isA<int>());
    });

    test('should return true when comparing with same instance', () {
      expect(tTvSeries == tTvSeries, isTrue);
    });

    test('should return false when comparing with different type', () {
      expect(tTvSeries == Object(), isFalse);
    });
  });
}
