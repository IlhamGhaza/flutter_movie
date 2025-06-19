import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

// Movie List Events
class FetchNowPlayingMovies extends MovieEvent {}

class FetchPopularMovies extends MovieEvent {}

class FetchTopRatedMovies extends MovieEvent {}

// Movie Detail Events
class FetchMovieDetail extends MovieEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchMovieRecommendations extends MovieEvent {
  final int id;

  const FetchMovieRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}

// Watchlist Events
class FetchWatchlistStatus extends MovieEvent {
  final int id;

  const FetchWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class AddWatchlist extends MovieEvent {
  final dynamic movie;

  const AddWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveFromWatchlist extends MovieEvent {
  final dynamic movie;

  const RemoveFromWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class FetchWatchlistMovies extends MovieEvent {}
