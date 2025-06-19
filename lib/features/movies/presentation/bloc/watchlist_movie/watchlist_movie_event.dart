import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie_detail.dart';


abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {
  const FetchWatchlistMovies();
}

class LoadWatchlistStatus extends WatchlistMovieEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  const AddWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFromWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  const RemoveFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
