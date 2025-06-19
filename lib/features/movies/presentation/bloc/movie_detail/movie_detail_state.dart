part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final bool isAddedToWatchlist;

  const MovieDetailLoaded(this.movie, {this.isAddedToWatchlist = false});

  @override
  List<Object> get props => [movie, isAddedToWatchlist];

  MovieDetailLoaded copyWith({MovieDetail? movie, bool? isAddedToWatchlist}) {
    return MovieDetailLoaded(
      movie ?? this.movie,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }
}

class MovieRecommendationError extends MovieDetailState {
  final String message;

  const MovieRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailWithRecommendations extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;

  const MovieDetailWithRecommendations({
    required this.movie,
    required this.recommendations,
    this.isAddedToWatchlist = false,
  });

  @override
  List<Object> get props => [movie, recommendations, isAddedToWatchlist];

  MovieDetailWithRecommendations copyWith({MovieDetail? movie, List<Movie>? recommendations, bool? isAddedToWatchlist}) {
    return MovieDetailWithRecommendations(
      movie: movie ?? this.movie,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }
}

class WatchlistStatusLoaded extends MovieDetailState {
  final bool isAddedToWatchlist;

  const WatchlistStatusLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchlistSuccess extends MovieDetailState {
  final String message;

  const WatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistError extends MovieDetailState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
