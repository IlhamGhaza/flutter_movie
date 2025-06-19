import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/common/state_enum.dart';

// Events
abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {}

class AddTvSeriesToWatchlist extends WatchlistTvSeriesEvent {
  final dynamic tvSeries;

  const AddTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlist extends WatchlistTvSeriesEvent {
  final dynamic tvSeries;

  const RemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class LoadWatchlistStatus extends WatchlistTvSeriesEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

// States
class WatchlistTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> watchlistTvSeries;
  final String message;
  final bool isAddedToWatchlist;

  const WatchlistTvSeriesState({
    this.state = RequestState.Empty,
    this.watchlistTvSeries = const [],
    this.message = '',
    this.isAddedToWatchlist = false,
  });

  WatchlistTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? watchlistTvSeries,
    String? message,
    bool? isAddedToWatchlist,
  }) {
    return WatchlistTvSeriesState(
      state: state ?? this.state,
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object> get props => [state, watchlistTvSeries, message, isAddedToWatchlist];
}

// BLoC
class WatchlistTvSeriesBloc extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final GetWatchListStatusTvSeries getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const WatchlistTvSeriesState()) {
    on<FetchWatchlistTvSeries>(_onFetchWatchlistTvSeries);
    on<AddTvSeriesToWatchlist>(_onAddTvSeriesToWatchlist);
    on<RemoveTvSeriesFromWatchlist>(_onRemoveTvSeriesFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchWatchlistTvSeries(
    FetchWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getWatchlistTvSeries.execute();
    
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        state: RequestState.Loaded,
        watchlistTvSeries: tvSeries,
      )),
    );
  }

  Future<void> _onAddTvSeriesToWatchlist(
    AddTvSeriesToWatchlist event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    late final Either<Failure, String> result;
    
    if (event.tvSeries is TvSeries) {
      result = await saveWatchlist.execute(event.tvSeries as TvSeries);
    } else if (event.tvSeries is TvSeriesDetail) {
      result = await saveWatchlist.execute(
        TvSeries.watchlist(
          id: event.tvSeries.id,
          overview: event.tvSeries.overview,
          posterPath: event.tvSeries.posterPath,
          name: event.tvSeries.name,
          firstAirDate: event.tvSeries.firstAirDate,
        ),
      );
    } else {
      throw ArgumentError('Unsupported type: ${event.tvSeries.runtimeType}');
    }

    await result.fold(
      (failure) async {
        emit(state.copyWith(message: failure.message));
      },
      (message) async {
        emit(state.copyWith(message: message));
        add(FetchWatchlistTvSeries());
      },
    );
  }

  Future<void> _onRemoveTvSeriesFromWatchlist(
    RemoveTvSeriesFromWatchlist event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    late final Either<Failure, String> result;
    
    if (event.tvSeries is TvSeries) {
      result = await removeWatchlist.execute(event.tvSeries as TvSeries);
    } else if (event.tvSeries is TvSeriesDetail) {
      result = await removeWatchlist.execute(
        TvSeries.watchlist(
          id: event.tvSeries.id,
          overview: event.tvSeries.overview,
          posterPath: event.tvSeries.posterPath,
          name: event.tvSeries.name,
          firstAirDate: event.tvSeries.firstAirDate,
        ),
      );
    } else {
      throw ArgumentError('Unsupported type: ${event.tvSeries.runtimeType}');
    }

    await result.fold(
      (failure) async {
        emit(state.copyWith(message: failure.message));
      },
      (message) async {
        emit(state.copyWith(message: message));
        add(FetchWatchlistTvSeries());
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
