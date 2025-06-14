import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MovieDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.Empty;
  RequestState get movieState => _movieState;

  List<Movie> _movieRecommendations = [];
  List<Movie> get movieRecommendations => _movieRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> _fetchMovieRecommendations(int id) async {
    _recommendationState = RequestState.Loading;
    notifyListeners();
    
    final result = await getMovieRecommendations.execute(id);
    result.fold(
      (failure) {
        _recommendationState = RequestState.Error;
        _message = failure.message;
      },
      (movies) {
        _recommendationState = RequestState.Loaded;
        _movieRecommendations = movies;
      },
    );
    notifyListeners();
  }

  Future<void> fetchMovieDetail(int id) async {
    try {
      _movieState = RequestState.Loading;
      notifyListeners();
      
      // Fetch movie detail
      final result = await getMovieDetail.execute(id);
      result.fold(
        (failure) {
          _movieState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
        (movie) async {
          _movie = movie;
          _movieState = RequestState.Loaded;
          
          // Load watchlist status
          await loadWatchlistStatus(movie.id);
          
          // Fetch recommendations
          await _fetchMovieRecommendations(movie.id);
          
          notifyListeners();
        },
      );
    } catch (e) {
      _movieState = RequestState.Error;
      _message = 'Failed to load movie details';
      notifyListeners();
    }
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    try {
      final result = await getWatchListStatus.execute(id);
      _isAddedtoWatchlist = result;
      notifyListeners();
    } catch (e) {
      _message = 'Failed to load watchlist status';
      notifyListeners();
    }
  }
}
