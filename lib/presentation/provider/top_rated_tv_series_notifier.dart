import 'package:flutter/foundation.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';

class TopRatedTvSeriesNotifier extends ChangeNotifier {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesNotifier({required this.getTopRatedTvSeries});

  RequestState _state = RequestState.Empty;
  String _message = '';
  List<TvSeries> _tvSeries = [];

  String get message => _message;

  RequestState get topRatedState => _state;

  List<TvSeries> get topRatedTvSeries => _tvSeries;

  Future<void> fetchTopRatedTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _tvSeries = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
