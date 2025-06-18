import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? stillPath;
  final double voteAverage;
  final int? voteCount;
  final String? airDate;
  final int episodeNumber;
  final int? seasonNumber;
  final int? runtime;

  const Episode({
    required this.id,
    required this.name,
    required this.overview,
    this.stillPath,
    this.voteAverage = 0.0,
    this.voteCount,
    this.airDate,
    required this.episodeNumber,
    this.seasonNumber,
    this.runtime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        stillPath,
        voteAverage,
        voteCount,
        airDate,
        episodeNumber,
        seasonNumber,
        runtime,
      ];
}
