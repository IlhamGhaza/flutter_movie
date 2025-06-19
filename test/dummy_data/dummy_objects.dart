import 'package:ditonton/features/movies/data/models/genre.dart';
import 'package:ditonton/features/movies/data/models/movie_table.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';
import 'package:ditonton/features/movies/domain/entities/movie_detail.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart' as tv_series_detail;

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

// TV Series Test Data
final testTvSeries = TvSeries(
  id: 1,
  title: 'Test TV Series',
  overview: 'Overview',
  posterPath: '/path.jpg',
  voteAverage: 8.0,
  genreIds: [1, 2],
  firstAirDate: '2020-01-01',
  popularity: 100.0,
  voteCount: 1000,
  backdropPath: '/path.jpg',
  originalLanguage: 'en',
  originalName: 'Test TV Series',
  name: 'Test TV Series',
  numberOfEpisodes: 10,
  numberOfSeasons: 2,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = tv_series_detail.TvSeriesDetail(
  adult: false,
  backdropPath: '/path.jpg',
  episodeRunTime: [45],
  firstAirDate: '2020-01-01',
  genres: [
    const tv_series_detail.Genre(id: 1, name: 'Action'),
    const tv_series_detail.Genre(id: 2, name: 'Drama'),
  ],
  id: 1,
  name: 'Test TV Series',
  originalName: 'Test TV Series',
  overview: 'Overview',
  posterPath: '/path.jpg',
  voteAverage: 8.0,
  voteCount: 1000,
  originCountry: ['US'],
  originalLanguage: 'en',
  popularity: 100.0,
  status: 'Returning Series',
  tagline: 'A great TV series',
  type: 'Scripted',
  numberOfEpisodes: 10,
  numberOfSeasons: 2,
);

// Note: Removed watchlist and table related code as they're not part of the entities we have
