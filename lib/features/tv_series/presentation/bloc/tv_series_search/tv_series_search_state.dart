part of 'tv_series_search_bloc.dart';

abstract class TVSeriesSearchState extends Equatable {
  const TVSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TVSeriesSearchInitial extends TVSeriesSearchState {}

class TVSeriesSearchLoading extends TVSeriesSearchState {}

class TVSeriesSearchError extends TVSeriesSearchState {
  final String message;

  const TVSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class TVSeriesSearchHasData extends TVSeriesSearchState {
  final List<TvSeries> result;

  const TVSeriesSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
