import 'package:flutter/foundation.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_now_playing_tv_series.dart';
import '../../domain/usecases/get_popular_tv_series.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvSeriesListNotifier({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState _popularState = RequestState.Empty;
  RequestState _topRatedState = RequestState.Empty;

  String _message = '';

  List<TvSeries> _nowPlayingTvSeries = [];
  List<TvSeries> _popularTvSeries = [];
  List<TvSeries> _topRatedTvSeries = [];

  String get message => _message;

  RequestState get nowPlayingState => _nowPlayingState;
  RequestState get popularState => _popularState;
  RequestState get topRatedState => _topRatedState;

  List<TvSeries> get nowPlayingTvSeries => _nowPlayingTvSeries;
  List<TvSeries> get popularTvSeries => _popularTvSeries;
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  Future<void> fetchNowPlayingTvSeries() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTvSeries = tvSeries;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _popularState = RequestState.Loaded;
        _popularTvSeries = tvSeries;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _topRatedState = RequestState.Loaded;
        _topRatedTvSeries = tvSeries;
        notifyListeners();
      },
    );
  }
}
