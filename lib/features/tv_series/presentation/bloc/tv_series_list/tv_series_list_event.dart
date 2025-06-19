part of 'tv_series_list_bloc.dart';

abstract class TVSeriesListEvent extends Equatable {
  const TVSeriesListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTVSeries extends TVSeriesListEvent {}

class FetchPopularTVSeries extends TVSeriesListEvent {}

class FetchTopRatedTVSeries extends TVSeriesListEvent {}
