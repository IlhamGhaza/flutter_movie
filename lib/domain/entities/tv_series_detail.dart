import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class TvSeriesDetail extends Equatable {
  final bool adult;
  final String? backdropPath;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<Genre> genres;
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final List<String> originCountry;
  final String originalLanguage;
  final double popularity;
  final String status;
  final String tagline;
  final String type;
  final int numberOfEpisodes;
  final int numberOfSeasons;

  const TvSeriesDetail({
    required this.adult,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.originCountry,
    required this.originalLanguage,
    required this.popularity,
    required this.status,
    required this.tagline,
    required this.type,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  @override
  String toString() {
    return 'TvSeriesDetail(adult: $adult, backdropPath: $backdropPath, episodeRunTime: $episodeRunTime, firstAirDate: $firstAirDate, genres: $genres, id: $id, name: $name, originalName: $originalName, overview: $overview, posterPath: $posterPath, voteAverage: $voteAverage, voteCount: $voteCount, originCountry: $originCountry, originalLanguage: $originalLanguage, popularity: $popularity, status: $status, tagline: $tagline, type: $type, numberOfEpisodes: $numberOfEpisodes, numberOfSeasons: $numberOfSeasons)';
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        id,
        name,
        originalName,
        overview,
        posterPath,
        voteAverage,
        voteCount,
        originCountry,
        originalLanguage,
        popularity,
        status,
        tagline,
        type,
        numberOfEpisodes,
        numberOfSeasons,
      ];
}
