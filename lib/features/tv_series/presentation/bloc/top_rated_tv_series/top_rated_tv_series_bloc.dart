import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/common/state_enum.dart';

// Events
abstract class TopRatedTvSeriesEvent extends Equatable {
  const TopRatedTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTvSeries extends TopRatedTvSeriesEvent {}

// State
class TopRatedTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  const TopRatedTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  TopRatedTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return TopRatedTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, tvSeries, message];
}

// BLoC
class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc({required this.getTopRatedTvSeries}) 
      : super(TopRatedTvSeriesState()) {
    on<FetchTopRatedTvSeries>(_onFetchTopRatedTvSeries);
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeries event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getTopRatedTvSeries.execute();
    
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        state: RequestState.Loaded,
        tvSeries: tvSeries,
      )),
    );
  }
}
