part of 'tv_series_detail_bloc.dart';

class TVSeriesDetailState extends Equatable {
  final RequestState tvSeriesDetailRequestState;
  final TvSeriesDetail? tvSeriesDetail;
  final String tvSeriesDetailMessage;

  final RequestState recommendationsRequestState;
  final List<TvSeries> recommendations;
  final String recommendationsMessage;

  final bool isAddedToWatchlist;
  final String watchlistMessage;

  final RequestState seasonDetailRequestState;
  final SeasonDetail? currentSeasonDetail;
  final String seasonDetailMessage;

  const TVSeriesDetailState({
    this.tvSeriesDetailRequestState = RequestState.Empty,
    this.tvSeriesDetail,
    this.tvSeriesDetailMessage = '',
    this.recommendationsRequestState = RequestState.Empty,
    this.recommendations = const [],
    this.recommendationsMessage = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.seasonDetailRequestState = RequestState.Empty,
    this.currentSeasonDetail,
    this.seasonDetailMessage = '',
  });

  TVSeriesDetailState copyWith({
    RequestState? tvSeriesDetailRequestState,
    TvSeriesDetail? tvSeriesDetail,
    String? tvSeriesDetailMessage,
    RequestState? recommendationsRequestState,
    List<TvSeries>? recommendations,
    String? recommendationsMessage,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    RequestState? seasonDetailRequestState,
    SeasonDetail? currentSeasonDetail,
    String? seasonDetailMessage,
    bool clearWatchlistMessage = false,
  }) {
    return TVSeriesDetailState(
      tvSeriesDetailRequestState: tvSeriesDetailRequestState ?? this.tvSeriesDetailRequestState,
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesDetailMessage: tvSeriesDetailMessage ?? this.tvSeriesDetailMessage,
      recommendationsRequestState: recommendationsRequestState ?? this.recommendationsRequestState,
      recommendations: recommendations ?? this.recommendations,
      recommendationsMessage: recommendationsMessage ?? this.recommendationsMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: clearWatchlistMessage ? '' : (watchlistMessage ?? this.watchlistMessage),
      seasonDetailRequestState: seasonDetailRequestState ?? this.seasonDetailRequestState,
      currentSeasonDetail: currentSeasonDetail ?? this.currentSeasonDetail,
      seasonDetailMessage: seasonDetailMessage ?? this.seasonDetailMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesDetailRequestState,
        tvSeriesDetail,
        tvSeriesDetailMessage,
        recommendationsRequestState,
        recommendations,
        recommendationsMessage,
        isAddedToWatchlist,
        watchlistMessage,
        seasonDetailRequestState,
        currentSeasonDetail,
        seasonDetailMessage,
      ];
}
