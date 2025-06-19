import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';

class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;
  final String? releaseDate;

  const MovieTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    this.voteAverage,
    this.releaseDate,
  });

  factory MovieTable.fromEntity(MovieDetail movie) => MovieTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
        releaseDate: movie.releaseDate,
      );

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        voteAverage: map['voteAverage']?.toDouble(),
        releaseDate: map['releaseDate'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'voteAverage': voteAverage,
        'releaseDate': releaseDate,
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        overview,
        voteAverage,
        releaseDate,
      ];
}
