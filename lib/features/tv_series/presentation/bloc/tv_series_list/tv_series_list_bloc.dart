import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/state_enum.dart';
import '../../../domain/usecases/get_now_playing_tv_series.dart';
import '../../../domain/usecases/get_popular_tv_series.dart';
import '../../../domain/usecases/get_top_rated_tv_series.dart';
import '../../../domain/entities/tv_series.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class TVSeriesListBloc extends Bloc<TVSeriesListEvent, TVSeriesListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TVSeriesListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(TVSeriesListState()) {
    on<FetchNowPlayingTVSeries>(_onFetchNowPlayingTVSeries);
    on<FetchPopularTVSeries>(_onFetchPopularTVSeries);
    on<FetchTopRatedTVSeries>(_onFetchTopRatedTVSeries);
  }

  Future<void> _onFetchNowPlayingTVSeries(
    FetchNowPlayingTVSeries event,
    Emitter<TVSeriesListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading));
    
    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        nowPlayingState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        nowPlayingState: RequestState.Loaded,
        nowPlayingTVSeries: tvSeries,
      )),
    );
  }

  Future<void> _onFetchPopularTVSeries(
    FetchPopularTVSeries event,
    Emitter<TVSeriesListState> emit,
  ) async {
    emit(state.copyWith(popularTVSeriesState: RequestState.Loading));
    
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        popularTVSeriesState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        popularTVSeriesState: RequestState.Loaded,
        popularTVSeries: tvSeries,
      )),
    );
  }

  Future<void> _onFetchTopRatedTVSeries(
    FetchTopRatedTVSeries event,
    Emitter<TVSeriesListState> emit,
  ) async {
    emit(state.copyWith(topRatedTVSeriesState: RequestState.Loading));
    
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        topRatedTVSeriesState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        topRatedTVSeriesState: RequestState.Loaded,
        topRatedTVSeries: tvSeries,
      )),
    );
  }
}
