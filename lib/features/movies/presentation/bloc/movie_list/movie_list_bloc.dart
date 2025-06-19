import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchPopularMovies>(_onFetchPopularMovies);
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingState: RequestState.loading));
    
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        nowPlayingState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        nowPlayingState: RequestState.loaded,
        nowPlayingMovies: movies,
      )),
    );
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(popularMoviesState: RequestState.loading));
    
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        popularMoviesState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        popularMoviesState: RequestState.loaded,
        popularMovies: movies,
      )),
    );
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(topRatedMoviesState: RequestState.loading));
    
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        topRatedMoviesState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        topRatedMoviesState: RequestState.loaded,
        topRatedMovies: movies,
      )),
    );
  }
}
