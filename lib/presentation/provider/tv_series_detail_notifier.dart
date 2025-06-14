import 'package:flutter/foundation.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_recommendations.dart';
import '../../domain/usecases/remove_watchlist_tv_series.dart';
import '../../domain/usecases/save_watchlist_tv_series.dart';
import '../../data/datasources/tv_series_local_data_source.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;
  final TVSeriesLocalDataSource localDataSource;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required GetTvSeriesRecommendations getTvSeriesRecommendations,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.localDataSource,
  }) : _getTvSeriesRecommendations = getTvSeriesRecommendations;

  RequestState _detailState = RequestState.Empty;
  RequestState _recommendationsState = RequestState.Empty;

  String _message = '';
  String _recommendationsMessage = '';

  TvSeries? _tvSeriesDetail;
  List<TvSeries> _recommendations = [];

  String get message => _message;
  String get recommendationsMessage => _recommendationsMessage;

  RequestState get detailState => _detailState;
  RequestState get recommendationsState => _recommendationsState;

  TvSeries? get tvSeriesDetail => _tvSeriesDetail;
  List<TvSeries> get recommendations => _recommendations;

  Future<void> fetchTvSeriesDetail(int id) async {
    _detailState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationsResult = await _getTvSeriesRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _detailState = RequestState.Error;
        _message = failure.message;
        _tvSeriesDetail = null;
      },
      (tvSeries) {
        _detailState = RequestState.Loaded;
        _message = '';
        _tvSeriesDetail = tvSeries;
      },
    );

    recommendationsResult.fold(
      (failure) {
        _recommendationsState = RequestState.Error;
        _recommendationsMessage = failure.message;
        _recommendations = [];
      },
      (tvSeries) {
        _recommendationsState = RequestState.Loaded;
        _recommendationsMessage = '';
        _recommendations = tvSeries;
      },
    );

    notifyListeners();
  }

  Future<void> addTvSeriesToWatchlist() async {
    if (_tvSeriesDetail != null) {
      final result = await saveWatchlist.execute(_tvSeriesDetail!);
      await result.fold(
        (failure) async {
          _message = failure.message;
          notifyListeners();
        },
        (message) async {
          _message = message;
          notifyListeners();
        },
      );
    }
  }

  Future<void> removeTvSeriesFromWatchlist() async {
    if (_tvSeriesDetail != null) {
      final result = await removeWatchlist.execute(_tvSeriesDetail!);
      await result.fold(
        (failure) async {
          _message = failure.message;
          notifyListeners();
        },
        (message) async {
          _message = message;
          notifyListeners();
        },
      );
    }
  }

  Future<void> getTvSeriesRecommendations(int id) async {
    _recommendationsState = RequestState.Loading;
    notifyListeners();

    final result = await _getTvSeriesRecommendations.execute(id);
    result.fold(
      (failure) {
        _recommendationsState = RequestState.Error;
        _recommendationsMessage = failure.message;
        _recommendations = [];
        notifyListeners();
      },
      (recommendations) {
        _recommendationsState = RequestState.Loaded;
        _recommendationsMessage = '';
        _recommendations = recommendations;
        notifyListeners();
      },
    );
  }

  Future<bool> isAddedToWatchlist(int id) async {
    if (_tvSeriesDetail != null) {
      return await localDataSource.isAddedToWatchlist(id);
    }
    return false;
  }
}
