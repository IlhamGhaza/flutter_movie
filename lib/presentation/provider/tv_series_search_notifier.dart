import 'package:flutter/foundation.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/search_tv_series.dart';

class TvSeriesSearchNotifier extends ChangeNotifier {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchNotifier({required this.searchTvSeries});

  RequestState _state = RequestState.Empty;
  String _message = '';
  List<TvSeries> _searchResult = [];

  String get message => _message;

  RequestState get state => _state;

  List<TvSeries> get searchResult => _searchResult;

  Future<void> searchTvSeriesByQuery(String query) async {
    if (query.isEmpty) {
      _searchResult = [];
      _message = '';
      _state = RequestState.Empty;
      notifyListeners();
      return;
    }

    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _searchResult = [];
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
