import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/search_tv_series.dart';
import '../../../domain/entities/tv_series.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TVSeriesSearchBloc extends Bloc<TVSeriesSearchEvent, TVSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TVSeriesSearchBloc({required this.searchTvSeries})
      : super(TVSeriesSearchInitial()) {
    on<OnQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<TVSeriesSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(TVSeriesSearchInitial());
      return;
    }

    emit(TVSeriesSearchLoading());

    final result = await searchTvSeries.execute(query);

    result.fold(
      (failure) => emit(TVSeriesSearchError(failure.message)),
      (data) => emit(TVSeriesSearchHasData(data)),
    );
  }
}
