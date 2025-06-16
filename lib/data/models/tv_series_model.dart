import '../../../domain/entities/tv_series.dart';

class TvSeriesModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final List<int> genreIds;
  final String firstAirDate;
  final double popularity;
  final int voteCount;
  final String backdropPath;
  final String originalLanguage;
  final String originalName;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;

  TvSeriesModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genreIds,
    required this.firstAirDate,
    required this.popularity,
    required this.voteCount,
    required this.backdropPath,
    required this.originalLanguage,
    required this.originalName,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
    id: json['id'] ?? 0,
    title: json['name'] ?? json['original_name'] ?? 'No Title',
    overview: json['overview'] ?? 'No overview available',
    posterPath: json['poster_path'] ?? '',
    voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
    genreIds: (json['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? <int>[],
    firstAirDate: json['first_air_date']?.toString() ?? '',
    popularity: (json['popularity'] ?? 0.0).toDouble(),
    voteCount: json['vote_count'] ?? 0,
    backdropPath: json['backdrop_path'] ?? '',
    originalLanguage: json['original_language'] ?? 'en',
    originalName: json['original_name'] ?? '',
    name: json['name'] ?? json['original_name'] ?? 'No Title',
    numberOfEpisodes: json['number_of_episodes']?.toInt() ?? 0,
    numberOfSeasons: json['number_of_seasons']?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'original_name': originalName,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'genre_ids': genreIds,
    'first_air_date': firstAirDate,
    'popularity': popularity,
    'original_language': originalLanguage,
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
  };

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      genreIds: genreIds,
      firstAirDate: firstAirDate,
      popularity: popularity,
      voteCount: voteCount,
      backdropPath: backdropPath,
      originalLanguage: originalLanguage,
      originalName: originalName,
      name: name,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
    );
  }

  factory TvSeriesModel.fromEntity(TvSeries entity) {
    return TvSeriesModel(
      id: entity.id,
      title: entity.title,
      overview: entity.overview,
      posterPath: entity.posterPath,
      voteAverage: entity.voteAverage,
      genreIds: entity.genreIds,
      firstAirDate: entity.firstAirDate,
      popularity: entity.popularity,
      voteCount: entity.voteCount,
      backdropPath: entity.backdropPath,
      originalLanguage: entity.originalLanguage,
      originalName: entity.originalName,
      name: entity.name,
      numberOfEpisodes: entity.numberOfEpisodes,
      numberOfSeasons: entity.numberOfSeasons,
    );
  }
}
