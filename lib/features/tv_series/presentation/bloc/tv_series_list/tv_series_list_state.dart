part of 'tv_series_list_bloc.dart';

class TVSeriesListState extends Equatable {
  final RequestState nowPlayingState;
  final RequestState popularTVSeriesState;
  final RequestState topRatedTVSeriesState;
  final List<TvSeries> nowPlayingTVSeries;
  final List<TvSeries> popularTVSeries;
  final List<TvSeries> topRatedTVSeries;
  final String message;

  const TVSeriesListState({
    this.nowPlayingState = RequestState.Empty,
    this.popularTVSeriesState = RequestState.Empty,
    this.topRatedTVSeriesState = RequestState.Empty,
    this.nowPlayingTVSeries = const <TvSeries>[],
    this.popularTVSeries = const <TvSeries>[],
    this.topRatedTVSeries = const <TvSeries>[],
    this.message = '',
  });

  TVSeriesListState copyWith({
    RequestState? nowPlayingState,
    RequestState? popularTVSeriesState,
    RequestState? topRatedTVSeriesState,
    List<TvSeries>? nowPlayingTVSeries,
    List<TvSeries>? popularTVSeries,
    List<TvSeries>? topRatedTVSeries,
    String? message,
  }) {
    return TVSeriesListState(
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularTVSeriesState: popularTVSeriesState ?? this.popularTVSeriesState,
      topRatedTVSeriesState: topRatedTVSeriesState ?? this.topRatedTVSeriesState,
      nowPlayingTVSeries: nowPlayingTVSeries ?? this.nowPlayingTVSeries,
      popularTVSeries: popularTVSeries ?? this.popularTVSeries,
      topRatedTVSeries: topRatedTVSeries ?? this.topRatedTVSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingState,
        popularTVSeriesState,
        topRatedTVSeriesState,
        nowPlayingTVSeries,
        popularTVSeries,
        topRatedTVSeries,
        message,
      ];
      
  bool get isLoading => nowPlayingState == RequestState.Loading ||
      popularTVSeriesState == RequestState.Loading ||
      topRatedTVSeriesState == RequestState.Loading;
      
  bool get hasError => nowPlayingState == RequestState.Error ||
      popularTVSeriesState == RequestState.Error ||
      topRatedTVSeriesState == RequestState.Error;
      
  String get errorMessage => message;
}
