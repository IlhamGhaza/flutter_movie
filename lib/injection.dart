import 'package:ditonton/core/utils/database_helper.dart';
import 'package:ditonton/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/features/movies/domain/usecases/save_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton/features/tv_series/domain/usecases/search_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_season_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_season_detail.dart';
// BLoCs
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/tv_series/domain/usecases/get_watchlist_status_tv_series.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // External dependencies
  locator.registerLazySingleton(() => http.Client());
  
  // Configure Dio client for TMDb API
  locator.registerLazySingleton<Dio>(() {
    final options = BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': '2174d146bb9c0eab47529b2e77d6b526',
        'language': 'en-US'
      },
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
    );
    return Dio(options);
  });
  
  // Initialize and register database helper first
  final databaseHelper = DatabaseHelper();
  locator.registerSingleton<DatabaseHelper>(databaseHelper);

  // Data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: databaseHelper),
  );
  locator.registerLazySingleton<TVSeriesRemoteDataSource>(
    () => TVSeriesRemoteDataSource(client: locator<Dio>()),
  );
  locator.registerLazySingleton<TVSeriesLocalDataSource>(
    () => TVSeriesLocalDataSource(databaseHelper: databaseHelper),
  );

  // Repositories
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator<MovieRemoteDataSource>(),
      localDataSource: locator<MovieLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TVSeriesRepositoryImpl(
      remoteDataSource: locator<TVSeriesRemoteDataSource>(),
      localDataSource: locator<TVSeriesLocalDataSource>(),
    ),
  );

  // Use cases
  // Movie use cases
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator<MovieRepository>()));
  locator.registerLazySingleton(() => GetPopularMovies(locator<MovieRepository>()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator<MovieRepository>()));
  locator.registerLazySingleton(() => GetMovieDetail(locator<MovieRepository>()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator<MovieRepository>()));
  locator.registerLazySingleton(() => SearchMovies(locator<MovieRepository>()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator<MovieRepository>()));
  locator.registerLazySingleton(() => SaveWatchlist(locator<MovieRepository>()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator<MovieRepository>()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator<MovieRepository>()));
  
  // TV Series use cases
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => SearchTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetTvSeriesSeasonDetail(locator<TvSeriesRepository>()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator<TvSeriesRepository>()));

  // BLoCs
  // Movie BLoCs
  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator<GetNowPlayingMovies>(),
      getPopularMovies: locator<GetPopularMovies>(),
      getTopRatedMovies: locator<GetTopRatedMovies>(),
    ),
  );
  
  locator.registerFactory(
    () => WatchlistMovieBloc(
      getWatchlistMovies: locator<GetWatchlistMovies>(),
      getWatchListStatus: locator<GetWatchListStatus>(),
      saveWatchlist: locator<SaveWatchlist>(),
      removeWatchlist: locator<RemoveWatchlist>(),
    ),
  );
  
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator<GetMovieDetail>(),
      getMovieRecommendations: locator<GetMovieRecommendations>(),
      getWatchListStatus: locator<GetWatchListStatus>(),
      saveWatchlist: locator<SaveWatchlist>(),
      removeWatchlist: locator<RemoveWatchlist>(),
    ),
  );
  
  locator.registerFactory(
    () => MovieSearchBloc(
      searchMovies: locator<SearchMovies>(),
    ),
  );
  
  // TV Series BLoCs
  locator.registerFactory(
    () => TVSeriesListBloc(
      getNowPlayingTvSeries: locator<GetNowPlayingTvSeries>(),
      getPopularTvSeries: locator<GetPopularTvSeries>(),
      getTopRatedTvSeries: locator<GetTopRatedTvSeries>(),
    ),
  );
  
  locator.registerFactory(
    () => TVSeriesDetailBloc(
      getTvSeriesDetail: locator<GetTvSeriesDetail>(),
      getTvSeriesRecommendations: locator<GetTvSeriesRecommendations>(),
      getWatchListStatus: locator<GetWatchListStatusTvSeries>(),
      saveWatchlist: locator<SaveWatchlistTvSeries>(),
      removeWatchlist: locator<RemoveWatchlistTvSeries>(),
      getTvSeriesSeasonDetail: locator<GetTvSeriesSeasonDetail>(),
    ),
  );
  
  locator.registerFactory(
    () => TVSeriesSearchBloc(
      searchTvSeries: locator<SearchTvSeries>(),
    ),
  );

  // Popular TV Series BLoC
  locator.registerFactory(
    () => PopularTvSeriesBloc(
      getPopularTvSeries: locator<GetPopularTvSeries>(),
    ),
  );

  // Top Rated TV Series BLoC
  locator.registerFactory(
    () => TopRatedTvSeriesBloc(
      getTopRatedTvSeries: locator<GetTopRatedTvSeries>(),
    ),
  );

  // Watchlist TV Series BLoC
  locator.registerFactory(
    () => WatchlistTvSeriesBloc(
      getWatchlistTvSeries: locator<GetWatchlistTvSeries>(),
      getWatchListStatus: locator<GetWatchListStatusTvSeries>(),
      saveWatchlist: locator<SaveWatchlistTvSeries>(),
      removeWatchlist: locator<RemoveWatchlistTvSeries>(),
    ),
  );

  // Season Detail BLoC
  locator.registerFactory(
    () => SeasonDetailBloc(
      getSeasonDetail: locator<GetSeasonDetail>(),
    ),
  );
}
