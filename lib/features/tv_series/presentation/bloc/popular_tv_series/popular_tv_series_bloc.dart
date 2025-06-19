import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/common/state_enum.dart';

// Events
abstract class PopularTvSeriesEvent extends Equatable {
  const PopularTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvSeries extends PopularTvSeriesEvent {}

// State
class PopularTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  const PopularTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  PopularTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return PopularTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, tvSeries, message];
}

// BLoC
class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc({required this.getPopularTvSeries}) 
      : super(PopularTvSeriesState()) {
    on<FetchPopularTvSeries>(_onFetchPopularTvSeries);
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeries event,
    Emitter<PopularTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getPopularTvSeries.execute();
    
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
