import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/common/state_enum.dart';

import '../../../domain/usecases/get_tv_series_detail.dart';
import '../../../domain/usecases/get_tv_series_recommendations.dart';
import '../../../domain/usecases/get_watchlist_status_tv_series.dart';
import '../../../domain/usecases/remove_watchlist_tv_series.dart';
import '../../../domain/usecases/save_watchlist_tv_series.dart';
import '../../../domain/usecases/get_tv_series_season_detail.dart';
import '../../../domain/entities/season_detail.dart';
import '../../../domain/entities/tv_series.dart';
import '../../../domain/entities/tv_series_detail.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TVSeriesDetailBloc
    extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;
  final GetTvSeriesSeasonDetail getTvSeriesSeasonDetail;

  TVSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getTvSeriesSeasonDetail,
  }) : super(const TVSeriesDetailState()) {
    on<FetchTVSeriesDetail>(_onFetchTVSeriesDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<FetchSeasonDetail>(_onFetchSeasonDetail);
    on<ClearWatchlistMessage>(_onClearWatchlistMessage);
  }

  Future<void> _onFetchTVSeriesDetail(
    FetchTVSeriesDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(tvSeriesDetailRequestState: RequestState.Loading));

    final detailResult = await getTvSeriesDetail.execute(event.id);

    await detailResult.fold(
      (failure) async => emit(state.copyWith(
        tvSeriesDetailRequestState: RequestState.Error,
        tvSeriesDetailMessage: failure.message,
      )),
      (tvSeriesData) async {
        emit(state.copyWith(
          tvSeriesDetailRequestState: RequestState.Loaded,
          tvSeriesDetail: tvSeriesData,
          recommendationsRequestState: RequestState.Loading,
        ));

        final recommendationResult =
            await getTvSeriesRecommendations.execute(event.id);
        recommendationResult.fold(
          (failure) => emit(state.copyWith(
            recommendationsRequestState: RequestState.Error,
            recommendationsMessage: failure.message,
          )),
          (recommendationsData) => emit(
            state.copyWith(
              recommendationsRequestState: RequestState.Loaded,
              recommendations: recommendationsData,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final tvSeriesEntity = TvSeries.watchlist(
      id: event.tvSeries.id,
      name: event.tvSeries.name,
      posterPath: event.tvSeries.posterPath,
      overview: event.tvSeries.overview,
      firstAirDate: event.tvSeries.firstAirDate,
    );
    final result = await saveWatchlist.execute(tvSeriesEntity);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(state.copyWith(
        isAddedToWatchlist: true,
        watchlistMessage: successMessage,
      )),
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final tvSeriesEntity = TvSeries.watchlist(
      id: event.tvSeries.id,
      name: event.tvSeries.name,
      posterPath: event.tvSeries.posterPath,
      overview: event.tvSeries.overview,
      firstAirDate: event.tvSeries.firstAirDate,
    );
    final result = await removeWatchlist.execute(tvSeriesEntity);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(state.copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: successMessage,
      )),
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onFetchSeasonDetail(
    FetchSeasonDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(seasonDetailRequestState: RequestState.Loading));

    final result = await getTvSeriesSeasonDetail.execute(
      event.tvSeriesId,
      event.seasonNumber,
    );

    result.fold(
      (failure) => emit(state.copyWith(
          seasonDetailRequestState: RequestState.Error,
          seasonDetailMessage: failure.message)),
      (seasonDetail) => emit(state.copyWith(
          seasonDetailRequestState: RequestState.Loaded,
          currentSeasonDetail: seasonDetail)),
    );
  }

  void _onClearWatchlistMessage(
      ClearWatchlistMessage event, Emitter<TVSeriesDetailState> emit) {
    emit(state.copyWith(clearWatchlistMessage: true));
  }
}
