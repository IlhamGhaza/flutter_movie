import '../../domain/entities/tv_series.dart';

class TvSeriesTable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String firstAirDate;
  final String name;

  TvSeriesTable({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.firstAirDate,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'posterPath': posterPath,
    'backdropPath': backdropPath,
    'voteAverage': voteAverage,
    'firstAirDate': firstAirDate,
    'name': name,
  };

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) {
    return TvSeriesTable(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['posterPath'],
      backdropPath: map['backdropPath'],
      voteAverage: map['voteAverage'],
      firstAirDate: map['firstAirDate'],
      name: map['name'],
    );
  }

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      genreIds: [],
      firstAirDate: firstAirDate,
      popularity: 0,
      voteCount: 0,
      backdropPath: backdropPath,
      originalLanguage: '',
      originalName: name,
      name: name,
      numberOfEpisodes: 0,
      numberOfSeasons: 0,
    );
  }

  factory TvSeriesTable.fromEntity(TvSeries tvSeries) {
    return TvSeriesTable(
      id: tvSeries.id,
      title: tvSeries.title,
      overview: tvSeries.overview,
      posterPath: tvSeries.posterPath,
      backdropPath: tvSeries.backdropPath,
      voteAverage: tvSeries.voteAverage,
      firstAirDate: tvSeries.firstAirDate,
      name: tvSeries.name,
    );
  }
}
