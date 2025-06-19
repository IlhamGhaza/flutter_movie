part of 'tv_series_detail_bloc.dart';

abstract class TVSeriesDetailEvent extends Equatable {
  const TVSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVSeriesDetail extends TVSeriesDetailEvent {
  final int id;

  const FetchTVSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TVSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveFromWatchlist extends TVSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class LoadWatchlistStatus extends TVSeriesDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class FetchSeasonDetail extends TVSeriesDetailEvent {
  final int tvSeriesId;
  final int seasonNumber;

  const FetchSeasonDetail({
    required this.tvSeriesId,
    required this.seasonNumber,
  });

  @override
  List<Object> get props => [tvSeriesId, seasonNumber];
}

class ClearWatchlistMessage extends TVSeriesDetailEvent {}
