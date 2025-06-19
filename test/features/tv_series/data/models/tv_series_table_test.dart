import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_table.dart';

void main() {
  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    title: 'Test Series',
    name: 'Test Series',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genreIds: [18, 10765],
    originalName: 'Test Series Original',
    originalLanguage: 'en',
    popularity: 100.0,
    voteCount: 1000,
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  final tTvSeriesEntity = TvSeries(
    id: 1,
    title: 'Test Series',
    name: 'Test Series',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.5,
    firstAirDate: '2023-01-01',
    genreIds: [18, 10765],
    originalName: 'Test Series Original',
    originalLanguage: 'en',
    popularity: 100.0,
    voteCount: 1000,
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  final tTvSeriesMap = {
    'id': 1,
    'title': 'Test Series',
    'name': 'Test Series',
    'overview': 'Overview',
    'posterPath': '/poster.jpg',
    'backdropPath': '/backdrop.jpg',
    'voteAverage': 8.5,
    'firstAirDate': '2023-01-01',
    'genreIds': '[18,10765]',
    'originalName': 'Test Series Original',
    'originalLanguage': 'en',
    'popularity': 100.0,
    'voteCount': 1000,
    'numberOfEpisodes': 10,
    'numberOfSeasons': 2,
  };

  group('TvSeriesTable', () {
    test('should be a subclass of TvSeriesTable', () {
      final result = tTvSeriesTable.toEntity();
      expect(result, isA<TvSeries>());
    });

    test('empty constructor should return empty TvSeriesTable', () {
      final result = TvSeriesTable.empty();
      expect(result.id, 0);
      expect(result.title, '');
      expect(result.name, '');
      expect(result.overview, '');
      expect(result.posterPath, '');
      expect(result.backdropPath, '');
      expect(result.voteAverage, 0.0);
      expect(result.firstAirDate, '');
      expect(result.genreIds, isEmpty);
      expect(result.originalName, '');
      expect(result.originalLanguage, 'en');
      expect(result.popularity, 0.0);
      expect(result.voteCount, 0);
      expect(result.numberOfEpisodes, 0);
      expect(result.numberOfSeasons, 0);
    });

    test('should return a valid model from JSON', () {
      // act
      final result = TvSeriesTable.fromMap(tTvSeriesMap);
      // assert
      expect(result.id, tTvSeriesTable.id);
      expect(result.title, tTvSeriesTable.title);
      expect(result.name, tTvSeriesTable.name);
      expect(result.overview, tTvSeriesTable.overview);
      expect(result.posterPath, tTvSeriesTable.posterPath);
      expect(result.backdropPath, tTvSeriesTable.backdropPath);
      expect(result.voteAverage, tTvSeriesTable.voteAverage);
      expect(result.firstAirDate, tTvSeriesTable.firstAirDate);
      expect(result.genreIds, tTvSeriesTable.genreIds);
      expect(result.originalName, tTvSeriesTable.originalName);
      expect(result.originalLanguage, tTvSeriesTable.originalLanguage);
      expect(result.popularity, tTvSeriesTable.popularity);
      expect(result.voteCount, tTvSeriesTable.voteCount);
      expect(result.numberOfEpisodes, tTvSeriesTable.numberOfEpisodes);
      expect(result.numberOfSeasons, tTvSeriesTable.numberOfSeasons);
    });

    test('should return a JSON map containing proper data', () {
      // act
      final result = tTvSeriesTable.toJson();
      // assert
      final expectedMap = {
        'id': 1,
        'title': 'Test Series',
        'name': 'Test Series',
        'overview': 'Overview',
        'posterPath': '/poster.jpg',
        'backdropPath': '/backdrop.jpg',
        'voteAverage': 8.5,
        'firstAirDate': '2023-01-01',
        'genreIds': '[18,10765]',
        'originalName': 'Test Series Original',
        'originalLanguage': 'en',
        'popularity': 100.0,
        'voteCount': 1000,
        'numberOfEpisodes': 10,
        'numberOfSeasons': 2,
      };
      expect(result, expectedMap);
    });

    test('should return a TvSeries entity', () {
      // act
      final result = tTvSeriesTable.toEntity();
      // assert
      expect(result.id, tTvSeriesEntity.id);
      expect(result.title, tTvSeriesEntity.title);
      expect(result.name, tTvSeriesEntity.name);
      expect(result.overview, tTvSeriesEntity.overview);
      expect(result.posterPath, tTvSeriesEntity.posterPath);
      expect(result.backdropPath, tTvSeriesEntity.backdropPath);
      expect(result.voteAverage, tTvSeriesEntity.voteAverage);
      expect(result.firstAirDate, tTvSeriesEntity.firstAirDate);
      expect(result.genreIds, tTvSeriesEntity.genreIds);
      expect(result.originalName, tTvSeriesEntity.originalName);
      expect(result.originalLanguage, tTvSeriesEntity.originalLanguage);
      expect(result.popularity, tTvSeriesEntity.popularity);
      expect(result.voteCount, tTvSeriesEntity.voteCount);
      expect(result.numberOfEpisodes, tTvSeriesEntity.numberOfEpisodes);
      expect(result.numberOfSeasons, tTvSeriesEntity.numberOfSeasons);
    });

    test('should create a TvSeriesTable from entity', () {
      // act
      final result = TvSeriesTable.fromEntity(tTvSeriesEntity);
      // assert
      expect(result.id, tTvSeriesTable.id);
      expect(result.title, tTvSeriesTable.title);
      expect(result.name, tTvSeriesTable.name);
      expect(result.overview, tTvSeriesTable.overview);
      expect(result.posterPath, tTvSeriesTable.posterPath);
      expect(result.backdropPath, tTvSeriesTable.backdropPath);
      expect(result.voteAverage, tTvSeriesTable.voteAverage);
      expect(result.firstAirDate, tTvSeriesTable.firstAirDate);
      expect(result.genreIds, tTvSeriesTable.genreIds);
      expect(result.originalName, tTvSeriesTable.originalName);
      expect(result.originalLanguage, tTvSeriesTable.originalLanguage);
      expect(result.popularity, tTvSeriesTable.popularity);
      expect(result.voteCount, tTvSeriesTable.voteCount);
      expect(result.numberOfEpisodes, tTvSeriesTable.numberOfEpisodes);
      expect(result.numberOfSeasons, tTvSeriesTable.numberOfSeasons);
    });

    test('should handle null or empty values in fromMap', () {
      // arrange
      final emptyMap = <String, dynamic>{};
      // act
      final result = TvSeriesTable.fromMap(emptyMap);
      // assert
      expect(result.id, 0);
      expect(result.title, '');
      expect(result.name, '');
      expect(result.overview, '');
      expect(result.posterPath, '');
      expect(result.backdropPath, '');
      expect(result.voteAverage, 0.0);
      expect(result.firstAirDate, '');
      expect(result.genreIds, isEmpty);
      expect(result.originalName, '');
      expect(result.originalLanguage, 'en'); // Default value
      expect(result.popularity, 0.0);
      expect(result.voteCount, 0);
      expect(result.numberOfEpisodes, 0);
      expect(result.numberOfSeasons, 0);
    });
  });
}