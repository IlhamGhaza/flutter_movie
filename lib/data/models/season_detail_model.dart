import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/episode.dart' as episode_entity;
import 'package:ditonton/domain/entities/season_detail.dart';

class SeasonDetailResponse {
  final SeasonDetailModel seasonDetail;
  final String error;

  const SeasonDetailResponse({
    required this.seasonDetail,
    required this.error,
  });

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        seasonDetail: SeasonDetailModel.fromJson(json),
        error: "",
      );

  factory SeasonDetailResponse.withError(String error) => SeasonDetailResponse(
        seasonDetail: SeasonDetailModel.empty(),
        error: error,
      );

  SeasonDetail toEntity() {
    final seasonNumber = seasonDetail.seasonNumber;
    return SeasonDetail(
      id: seasonDetail.id,
      name: seasonDetail.name,
      overview: seasonDetail.overview,
      posterPath: seasonDetail.posterPath,
      seasonNumber: seasonNumber,
      airDate: seasonDetail.airDate,
      episodeCount: seasonDetail.episodeCount,
      episodes: seasonDetail.episodes
          .map((episode) => episode_entity.Episode(
                id: episode.id,
                name: episode.name,
                overview: episode.overview,
                stillPath: episode.stillPath,
                episodeNumber: episode.episodeNumber,
                airDate: episode.airDate,
                runtime: episode.runtime,
                voteAverage: episode.voteAverage ?? 0.0,
                voteCount: episode.voteCount,
                seasonNumber: seasonNumber,
              ))
          .toList(),
    );
  }
}

class SeasonDetailModel extends Equatable {
  final String? airDate;
  final List<EpisodeModel> episodes;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;

  const SeasonDetailModel({
    required this.airDate,
    required this.episodes,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
  });

  factory SeasonDetailModel.empty() => const SeasonDetailModel(
        airDate: '',
        episodes: [],
        id: 0,
        name: '',
        overview: '',
        posterPath: '',
        seasonNumber: 0,
        episodeCount: 0,
      );

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse integers from dynamic values
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return SeasonDetailModel(
      airDate: json['air_date']?.toString() ?? '',
      episodes: List<EpisodeModel>.from(
        (json['episodes'] as List<dynamic>?)?.map(
              (x) => EpisodeModel.fromJson(x as Map<String, dynamic>),
            ) ??
            [],
      ),
      id: parseInt(json['_id'] ?? json['id']), // Try both _id and id fields
      name: json['name']?.toString() ?? '',
      overview: json['overview']?.toString() ?? '',
      posterPath: json['poster_path']?.toString(),
      seasonNumber: parseInt(json['season_number']),
      episodeCount: json['episodes'] is List ? (json['episodes'] as List).length : 0,
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        episodes,
        id,
        name,
        overview,
        posterPath,
        seasonNumber,
        episodeCount,
      ];

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episodes': episodes.map((e) => e.toJson()).toList(),
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'season_number': seasonNumber,
        'episode_count': episodeCount,
        '_id': id,
      };

  SeasonDetail toEntity() {
    // Create a copy of each episode with the correct season number
    final episodeEntities = episodes.map((episode) {
      return episode_entity.Episode(
        id: episode.id,
        name: episode.name,
        overview: episode.overview,
        stillPath: episode.stillPath,
        episodeNumber: episode.episodeNumber,
        airDate: episode.airDate,
        runtime: episode.runtime,
        voteAverage: episode.voteAverage ?? 0.0,
        voteCount: episode.voteCount,
        seasonNumber: seasonNumber, // Set the season number from the parent
      );
    }).toList();

    return SeasonDetail(
      airDate: airDate,
      episodes: episodeEntities,
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
      episodeCount: episodeCount,
    );
  }
}

class EpisodeModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? stillPath;
  final int episodeNumber;
  final String? airDate;
  final int? runtime;
  final double? voteAverage;
  final int? voteCount;

  const EpisodeModel({
    required this.id,
    required this.name,
    required this.overview,
    this.stillPath,
    required this.episodeNumber,
    this.airDate,
    this.runtime,
    this.voteAverage,
    this.voteCount,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse integers from dynamic values
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Helper function to safely parse doubles from dynamic values
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return EpisodeModel(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? 'Episode ${parseInt(json['episode_number'])}',
      overview: json['overview']?.toString() ?? '',
      stillPath: json['still_path']?.toString(),
      episodeNumber: parseInt(json['episode_number']),
      airDate: json['air_date']?.toString(),
      runtime: json['runtime'] != null ? parseInt(json['runtime']) : null,
      voteAverage: json['vote_average'] != null ? parseDouble(json['vote_average']) : null,
      voteCount: json['vote_count'] != null ? parseInt(json['vote_count']) : null,
    );
  }

  episode_entity.Episode toEntity() {
    return episode_entity.Episode(
      id: id,
      name: name,
      overview: overview,
      stillPath: stillPath,
      episodeNumber: episodeNumber,
      airDate: airDate,
      runtime: runtime,
      voteAverage: voteAverage ?? 0.0,
      voteCount: voteCount,
      seasonNumber: null, // This will be set by the parent SeasonDetail
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'still_path': stillPath,
        'episode_number': episodeNumber,
        'air_date': airDate,
        'runtime': runtime,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        stillPath,
        episodeNumber,
        airDate,
        runtime,
        voteAverage,
        voteCount,
      ];
}
