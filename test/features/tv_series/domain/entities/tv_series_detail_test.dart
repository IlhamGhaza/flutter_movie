import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenre = Genre(id: 1, name: 'Action');
  const tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [45],
    firstAirDate: '2022-01-01',
    genres: [tGenre],
    id: 1,
    name: 'Test TV Series',
    originalName: 'Test TV Series',
    overview: 'Overview',
    posterPath: 'posterPath', 
    voteAverage: 8.5,
    voteCount: 100,
    originCountry: ['US'],
    originalLanguage: 'en',
    popularity: 100.0,
    status: 'Returning Series',
    tagline: 'A test tagline',
    type: 'Scripted',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
  );

  group('Genre', () {
    test('should have correct properties', () {
      expect(tGenre.id, 1);
      expect(tGenre.name, 'Action');
    });

    test('should be equal when properties are the same', () {
      const genre1 = Genre(id: 1, name: 'Action');
      expect(tGenre, genre1);
    });

    test('should not be equal when properties are different', () {
      const differentGenre = Genre(id: 2, name: 'Drama');
      expect(tGenre, isNot(equals(differentGenre)));
    });
  });

  group('TvSeriesDetail', () {
    test('should have correct properties', () {
      expect(tTvSeriesDetail.adult, false);
      expect(tTvSeriesDetail.backdropPath, 'backdropPath');
      expect(tTvSeriesDetail.episodeRunTime, [45]);
      expect(tTvSeriesDetail.firstAirDate, '2022-01-01');
      expect(tTvSeriesDetail.genres, [tGenre]);
      expect(tTvSeriesDetail.id, 1);
      expect(tTvSeriesDetail.name, 'Test TV Series');
      expect(tTvSeriesDetail.originalName, 'Test TV Series');
      expect(tTvSeriesDetail.overview, 'Overview');
      expect(tTvSeriesDetail.posterPath, 'posterPath');
      expect(tTvSeriesDetail.voteAverage, 8.5);
      expect(tTvSeriesDetail.voteCount, 100);
      expect(tTvSeriesDetail.originCountry, ['US']);
      expect(tTvSeriesDetail.originalLanguage, 'en');
      expect(tTvSeriesDetail.popularity, 100.0);
      expect(tTvSeriesDetail.status, 'Returning Series');
      expect(tTvSeriesDetail.tagline, 'A test tagline');
      expect(tTvSeriesDetail.type, 'Scripted');
      expect(tTvSeriesDetail.numberOfEpisodes, 10);
      expect(tTvSeriesDetail.numberOfSeasons, 1);
    });

    test('should be equal when properties are the same', () {
      const tvSeriesDetail2 = TvSeriesDetail(
        adult: false,
        backdropPath: 'backdropPath',
        episodeRunTime: [45],
        firstAirDate: '2022-01-01',
        genres: [tGenre],
        id: 1,
        name: 'Test TV Series',
        originalName: 'Test TV Series',
        overview: 'Overview',
        posterPath: 'posterPath',
        voteAverage: 8.5,
        voteCount: 100,
        originCountry: ['US'],
        originalLanguage: 'en',
        popularity: 100.0,
        status: 'Returning Series',
        tagline: 'A test tagline',
        type: 'Scripted',
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
      );
      expect(tTvSeriesDetail, tvSeriesDetail2);
    });

    test('should not be equal when properties are different', () {
      const differentTvSeries = TvSeriesDetail(
        adult: true,
        backdropPath: 'different',
        episodeRunTime: [60],
        firstAirDate: '2023-01-01',
        genres: [tGenre],
        id: 2,
        name: 'Different',
        originalName: 'Different',
        overview: 'Different',
        posterPath: 'different',
        voteAverage: 9.0,
        voteCount: 200,
        originCountry: ['UK'],
        originalLanguage: 'es',
        popularity: 200.0,
        status: 'Ended',
        tagline: 'Different',
        type: 'Reality',
        numberOfEpisodes: 20,
        numberOfSeasons: 2,
      );
      expect(tTvSeriesDetail, isNot(equals(differentTvSeries)));
    });

    test('should have correct string representation', () {
      const expectedString =
          'TvSeriesDetail(adult: false, backdropPath: backdropPath, episodeRunTime: [45], firstAirDate: 2022-01-01, genres: [Genre(1, Action)], id: 1, name: Test TV Series, originalName: Test TV Series, overview: Overview, posterPath: posterPath, voteAverage: 8.5, voteCount: 100, originCountry: [US], originalLanguage: en, popularity: 100.0, status: Returning Series, tagline: A test tagline, type: Scripted, numberOfEpisodes: 10, numberOfSeasons: 1)';
      expect(tTvSeriesDetail.toString(), expectedString);
    });
  });
}