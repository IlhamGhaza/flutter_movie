import 'package:flutter/foundation.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_recommendations.dart';
import '../../domain/usecases/remove_watchlist_tv_series.dart';
import '../../domain/usecases/save_watchlist_tv_series.dart';
import '../../domain/usecases/get_watchlist_status_tv_series.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;
  final GetWatchListStatusTvSeries getWatchListStatus;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required GetTvSeriesRecommendations getTvSeriesRecommendations,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchListStatus,
  }) : _getTvSeriesRecommendations = getTvSeriesRecommendations;

  RequestState _detailState = RequestState.Empty;
  RequestState _recommendationsState = RequestState.Empty;
  String _message = '';
  String _recommendationsMessage = '';
  String _watchlistMessage = '';
  bool _isAddedToWatchlist = false;

  TvSeriesDetail? _tvSeriesDetail;
  List<TvSeries> _recommendations = [];

  String get message => _message;
  String get recommendationsMessage => _recommendationsMessage;
  String get watchlistMessage => _watchlistMessage;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  RequestState get detailState => _detailState;
  RequestState get recommendationsState => _recommendationsState;

  TvSeriesDetail? get tvSeriesDetail => _tvSeriesDetail;
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
      (tvSeriesDetail) {
        _detailState = RequestState.Loaded;
        _message = '';
        _tvSeriesDetail = tvSeriesDetail;
        // Load watchlist status after successfully fetching details
        loadWatchlistStatus(id);
      },
    );

    recommendationsResult.fold(
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

  Future<void> addWatchlist(TvSeriesDetail tvSeries) async {
    try {
      final tvSeriesToSave = TvSeries(
        id: tvSeries.id,
        name: tvSeries.name,
        title: tvSeries.name, // Use name as title for backward compatibility
        overview: tvSeries.overview,
        posterPath: tvSeries.posterPath ?? '',
        backdropPath: tvSeries.backdropPath ?? '',
        voteAverage: tvSeries.voteAverage,
        firstAirDate: tvSeries.firstAirDate,
        genreIds: tvSeries.genres.map((genre) => genre.id).toList(),
        originalName: tvSeries.originalName,
        originalLanguage: tvSeries.originalLanguage,
        popularity: tvSeries.popularity,
        voteCount: tvSeries.voteCount,
        numberOfEpisodes: tvSeries.numberOfEpisodes,
        numberOfSeasons: tvSeries.numberOfSeasons,
      );

      final result = await saveWatchlist.execute(tvSeriesToSave);
      result.fold(
        (failure) {
          _watchlistMessage = failure.message;
        },
        (successMessage) {
          _watchlistMessage = successMessage;
          _isAddedToWatchlist = true;
        },
      );
    } catch (e) {
      _watchlistMessage = 'Failed to add to watchlist';
    } finally {
      notifyListeners();
    }
  }

  Future<void> removeFromWatchlist(TvSeriesDetail tvSeries) async {
    try {
      final tvSeriesToRemove = TvSeries(
        id: tvSeries.id,
        name: tvSeries.name,
        title: tvSeries.name, // Use name as title for backward compatibility
        overview: tvSeries.overview,
        posterPath: tvSeries.posterPath ?? '',
        backdropPath: tvSeries.backdropPath ?? '',
        voteAverage: tvSeries.voteAverage,
        firstAirDate: tvSeries.firstAirDate,
        genreIds: tvSeries.genres.map((genre) => genre.id).toList(),
        originalName: tvSeries.originalName,
        originalLanguage: tvSeries.originalLanguage,
        popularity: tvSeries.popularity,
        voteCount: tvSeries.voteCount,
        numberOfEpisodes: tvSeries.numberOfEpisodes,
        numberOfSeasons: tvSeries.numberOfSeasons,
      );

      final result = await removeWatchlist.execute(tvSeriesToRemove);
      result.fold(
        (failure) {
          _watchlistMessage = failure.message;
        },
        (successMessage) {
          _watchlistMessage = successMessage;
          _isAddedToWatchlist = false;
        },
      );
    } catch (e) {
      _watchlistMessage = 'Failed to remove from watchlist';
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadWatchlistStatus(int id) async {
    try {
      final result = await getWatchListStatus.execute(id);
      _isAddedToWatchlist = result;
    } catch (e) {
      _isAddedToWatchlist = false;
    }
    notifyListeners();
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
}
