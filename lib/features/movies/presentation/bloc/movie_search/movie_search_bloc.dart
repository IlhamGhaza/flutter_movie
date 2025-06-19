import 'package:bloc/bloc.dart';
import '../../../domain/usecases/search_movies.dart';
import 'watchlist_movie_event.dart';
import 'watchlist_movie_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchInitial()) {
    on<OnMovieQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
    OnMovieQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(MovieSearchInitial());
      return;
    }

    emit(MovieSearchLoading());

    final result = await searchMovies.execute(query);

    result.fold(
      (failure) => emit(MovieSearchError(failure.message)),
      (data) => emit(MovieSearchHasData(data)),
    );
  }
}



