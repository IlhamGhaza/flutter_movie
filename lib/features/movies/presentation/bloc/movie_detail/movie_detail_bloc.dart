import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../../../common/failure.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailInitial()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    try {
      final watchlistStatus = await getWatchListStatus.execute(event.id);

      final detailResultEither = await getMovieDetail.execute(event.id);

      MovieDetail? movieDetail;
      bool detailFetchSucceeded = false;

      detailResultEither.fold(
        (failure) {
          emit(MovieDetailError(failure.message));
          detailFetchSucceeded = false;
        },
        (movie) {
          movieDetail = movie;
          detailFetchSucceeded = true;
        },
      );

      if (!detailFetchSucceeded || movieDetail == null) {
        return;
      }

      final recommendationResultEither =
          await getMovieRecommendations.execute(event.id);

      recommendationResultEither.fold(
        (recFailure) {
          emit(MovieDetailLoaded(
            movieDetail!,
            isAddedToWatchlist: watchlistStatus,
          ));
        },
        (recommendations) {
          emit(MovieDetailWithRecommendations(
            movie: movieDetail!,
            recommendations: recommendations,
            isAddedToWatchlist: watchlistStatus,
          ));
        },
      );
    } catch (e) {
      if (e is Failure) {
        emit(MovieDetailError(e.message));
      } else {
        emit(MovieDetailError('An unexpected error occurred: ${e.toString()}'));
      }
    }
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    final currentBlocState = state;

    result.fold(
      (failure) => emit(WatchlistError(failure.message)),
      (successMessage) {
        emit(WatchlistSuccess(successMessage));

        if (currentBlocState is MovieDetailWithRecommendations) {
          emit(currentBlocState.copyWith(isAddedToWatchlist: true));
        } else if (currentBlocState is MovieDetailLoaded) {
          emit(currentBlocState.copyWith(isAddedToWatchlist: true));
        }
      },
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    final currentBlocState = state;

    result.fold(
      (failure) => emit(WatchlistError(failure.message)),
      (successMessage) {
        emit(WatchlistSuccess(successMessage));

        if (currentBlocState is MovieDetailWithRecommendations) {
          emit(currentBlocState.copyWith(isAddedToWatchlist: false));
        } else if (currentBlocState is MovieDetailLoaded) {
          emit(currentBlocState.copyWith(isAddedToWatchlist: false));
        }
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);
    final currentBlocState = state;

    if (currentBlocState is MovieDetailWithRecommendations) {
      emit(currentBlocState.copyWith(isAddedToWatchlist: isAdded));
    } else if (currentBlocState is MovieDetailLoaded) {
      emit(currentBlocState.copyWith(isAddedToWatchlist: isAdded));
    }
  }
}
