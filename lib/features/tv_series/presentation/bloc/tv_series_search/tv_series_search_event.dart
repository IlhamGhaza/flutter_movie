part of 'tv_series_search_bloc.dart';

abstract class TVSeriesSearchEvent extends Equatable {
  const TVSeriesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends TVSeriesSearchEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
