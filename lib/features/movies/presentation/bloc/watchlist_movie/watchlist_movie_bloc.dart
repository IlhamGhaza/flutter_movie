import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/features/movies/domain/usecases/save_watchlist.dart';
import 'watchlist_movie_event.dart';
import 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMovieBloc({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistMovieInitial()) {
    on<FetchWatchlistMovies>(_onFetchWatchlistMovies);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchWatchlistMovies(
    FetchWatchlistMovies event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(WatchlistMovieLoading());

    final result = await getWatchlistMovies.execute();

    result.fold(
      (failure) => emit(WatchlistMovieError(failure.message)),
      (moviesData) => emit(WatchlistMovieLoaded(moviesData)),
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(WatchlistStatusLoaded(result));
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);

    result.fold(
      (failure) => emit(WatchlistMessage(failure.message)),
      (successMessage) => emit(WatchlistMessage(successMessage)),
    );

    add(LoadWatchlistStatus(event.movie.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);

    result.fold(
      (failure) => emit(WatchlistMessage(failure.message)),
      (successMessage) => emit(WatchlistMessage(successMessage)),
    );

    add(LoadWatchlistStatus(event.movie.id));
  }
}
