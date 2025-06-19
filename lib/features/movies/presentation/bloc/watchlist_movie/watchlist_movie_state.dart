import 'package:equatable/equatable.dart';
import 'package:ditonton/features/movies/domain/entities/movie.dart';

import '../../../../../common/state_enum.dart';

class WatchlistMovieState extends Equatable {
  final RequestState watchlistState;
  final List<Movie> watchlistMovies;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const WatchlistMovieState({
    this.watchlistState = RequestState.Empty,
    this.watchlistMovies = const [],
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  WatchlistMovieState copyWith({
    RequestState? watchlistState,
    List<Movie>? watchlistMovies,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return WatchlistMovieState(
      watchlistState: watchlistState ?? this.watchlistState,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
        watchlistState,
        watchlistMovies,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

class WatchlistMovieInitial extends WatchlistMovieState {
  const WatchlistMovieInitial();
}

class WatchlistMovieLoading extends WatchlistMovieState {
  const WatchlistMovieLoading();
}

class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> movies;

  const WatchlistMovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchlistMovieError extends WatchlistMovieState {
  @override
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistStatusLoaded extends WatchlistMovieState {
  @override
  final bool isAddedToWatchlist;

  const WatchlistStatusLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchlistMessage extends WatchlistMovieState {
  @override
  final String message;

  const WatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}
