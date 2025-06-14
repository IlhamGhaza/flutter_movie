import 'package:flutter/foundation.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';
import '../../domain/usecases/remove_watchlist_tv_series.dart';
import '../../domain/usecases/save_watchlist_tv_series.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  WatchlistTvSeriesNotifier({
    required this.getWatchlistTvSeries,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  RequestState _state = RequestState.Empty;
  String _message = '';
  List<TvSeries> _watchlistTvSeries = [];

  String get message => _message;

  RequestState get state => _state;

  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  Future<void> fetchWatchlistTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistTvSeries = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addTvSeriesToWatchlist(TvSeries tvSeries) async {
    final result = await saveWatchlist.execute(tvSeries);
    await result.fold(
      (failure) async {
        _message = failure.message;
      },
      (successMessage) async {
        _message = successMessage;
      },
    );
    await fetchWatchlistTvSeries();
  }

  Future<void> removeTvSeriesFromWatchlist(TvSeries tvSeries) async {
    final result = await removeWatchlist.execute(tvSeries);
    await result.fold(
      (failure) async {
        _message = failure.message;
      },
      (successMessage) async {
        _message = successMessage;
      },
    );
    await fetchWatchlistTvSeries();
  }

  Future<bool> isAddedToWatchlist(int id) async {
    final result = await getWatchlistTvSeries.execute();
    return result.fold(
      (failure) => false,
      (data) => data.any((tvSeries) => tvSeries.id == id),
    );
  }
}
