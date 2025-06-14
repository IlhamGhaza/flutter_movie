import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart' show TvSeriesDetail, Genre;

class TvSeriesDetailResponse {
  final TvSeriesDetailModel tvSeriesDetail;
  final String error;

  const TvSeriesDetailResponse({
    required this.tvSeriesDetail,
    required this.error,
  });

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) => TvSeriesDetailResponse(
    tvSeriesDetail: TvSeriesDetailModel.fromJson(json),
    error: "",
  );

  factory TvSeriesDetailResponse.withError(String error) => TvSeriesDetailResponse(
    tvSeriesDetail: TvSeriesDetailModel.empty(),
    error: error,
  );
}

class TvSeriesDetailModel extends Equatable {
  final bool adult;
  final String? backdropPath;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres; // This will be converted to List<Genre> in toEntity()
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

  const TvSeriesDetailModel({
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

  factory TvSeriesDetailModel.empty() => const TvSeriesDetailModel(
        adult: false,
        backdropPath: '',
        episodeRunTime: [],
        firstAirDate: '',
        genres: [],
        id: 0,
        name: '',
        originalName: '',
        overview: '',
        posterPath: '',
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

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) => TvSeriesDetailModel(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        episodeRunTime: List<int>.from((json["episode_run_time"] as List<dynamic>?)?.map((x) => x as int) ?? []),
        firstAirDate: json["first_air_date"] ?? '',
        genres: List<GenreModel>.from(
            (json["genres"] as List<dynamic>?)?.map((x) => GenreModel.fromJson(x)) ?? []),
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        originalName: json["original_name"] ?? '',
        overview: json["overview"] ?? '',
        posterPath: json["poster_path"],
        voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
        originCountry: List<String>.from((json["origin_country"] as List<dynamic>?)?.map((x) => x.toString()) ?? []),
        originalLanguage: json["original_language"] ?? 'en',
        popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
        status: json["status"] ?? '',
        tagline: json["tagline"] ?? '',
        type: json["type"] ?? '',
        numberOfEpisodes: json["number_of_episodes"] ?? 0,
        numberOfSeasons: json["number_of_seasons"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'episode_run_time': episodeRunTime,
        'first_air_date': firstAirDate,
        'genres': genres.map((x) => x.toJson()).toList(),
        'id': id,
        'name': name,
        'original_name': originalName,
        'overview': overview,
        'poster_path': posterPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'origin_country': List<dynamic>.from(originCountry.map((x) => x)),
        'original_language': originalLanguage,
        'popularity': popularity,
        'status': status,
        'tagline': tagline,
        'type': type,
      };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      adult: adult,
      backdropPath: backdropPath,
      episodeRunTime: episodeRunTime,
      firstAirDate: firstAirDate,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      name: name,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      popularity: popularity,
      status: status,
      tagline: tagline,
      type: type,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
    );
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
      ];
}

class GenreModel extends Equatable {
  final int id;
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Genre toEntity() {
    return Genre(
      id: id,
      name: name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
