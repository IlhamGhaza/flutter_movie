import 'package:ditonton/domain/entities/tv_series.dart';
import 'dart:convert';

class TvSeriesTable {
  final int id;
  final String title;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String firstAirDate;
  final List<int> genreIds;
  final String originalName;
  final String originalLanguage;
  final double popularity;
  final int voteCount;
  final int numberOfEpisodes;
  final int numberOfSeasons;

  TvSeriesTable({
    required this.id,
    required this.title,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.firstAirDate,
    required this.genreIds,
    required this.originalName,
    required this.originalLanguage,
    required this.popularity,
    required this.voteCount,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  // Add a default constructor with default values for backward compatibility
  factory TvSeriesTable.empty() => TvSeriesTable(
        id: 0,
        title: '',
        name: '',
        overview: '',
        posterPath: '',
        backdropPath: '',
        voteAverage: 0.0,
        firstAirDate: '',
        genreIds: [],
        originalName: '',
        originalLanguage: 'en',
        popularity: 0.0,
        voteCount: 0,
        numberOfEpisodes: 0,
        numberOfSeasons: 0,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'name': name,
    'overview': overview,
    'posterPath': posterPath,
    'backdropPath': backdropPath,
    'voteAverage': voteAverage,
    'firstAirDate': firstAirDate,
    'genreIds': jsonEncode(genreIds),
    'originalName': originalName,
    'originalLanguage': originalLanguage,
    'popularity': popularity,
    'voteCount': voteCount,
    'numberOfEpisodes': numberOfEpisodes,
    'numberOfSeasons': numberOfSeasons,
  };

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) {
    return TvSeriesTable(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      name: map['name'] ?? map['title'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['posterPath'] ?? '',
      backdropPath: map['backdropPath'] ?? '',
      voteAverage: (map['voteAverage'] as num?)?.toDouble() ?? 0.0,
      firstAirDate: map['firstAirDate'] ?? '',
      genreIds: map['genreIds'] != null 
          ? List<int>.from(jsonDecode(map['genreIds'])) 
          : <int>[],
      originalName: map['originalName'] ?? map['name'] ?? '',
      originalLanguage: map['originalLanguage'] ?? 'en',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      voteCount: map['voteCount'] ?? 0,
      numberOfEpisodes: map['numberOfEpisodes'] ?? 0,
      numberOfSeasons: map['numberOfSeasons'] ?? 0,
    );
  }

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      title: title,
      name: name,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      originalName: originalName,
      originalLanguage: originalLanguage,
      popularity: popularity,
      voteCount: voteCount,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
    );
  }

  factory TvSeriesTable.fromEntity(TvSeries tvSeries) {
    return TvSeriesTable(
      id: tvSeries.id,
      title: tvSeries.title,
      name: tvSeries.name,
      overview: tvSeries.overview,
      posterPath: tvSeries.posterPath,
      backdropPath: tvSeries.backdropPath,
      voteAverage: tvSeries.voteAverage,
      firstAirDate: tvSeries.firstAirDate,
      genreIds: tvSeries.genreIds,
      originalName: tvSeries.originalName,
      originalLanguage: tvSeries.originalLanguage,
      popularity: tvSeries.popularity,
      voteCount: tvSeries.voteCount,
      numberOfEpisodes: tvSeries.numberOfEpisodes,
      numberOfSeasons: tvSeries.numberOfSeasons,
    );
  }
}
