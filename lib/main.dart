import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/features/movies/presentation/pages/about_page.dart';
import 'package:ditonton/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/pages/home_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/season_detail_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_search_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_seasons_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:ditonton/injection.dart' as di;

import 'core/ssl/certificate_pinner.dart';
import 'features/movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await CertificatePinner.initialize();

  try {
    // Initialize dependency injection
    await di.init();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Set up Crashlytics
    FlutterError.onError = (errorDetails) {
      // Log Flutter errors to Crashlytics
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // You can also log the error to console for debugging
      debugPrint(
          'Flutter error caught by Crashlytics: ${errorDetails.exception}');
    };

    // Optional: Set Crashlytics to handle uncaught errors
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Optional: Set user identifier (if you have user authentication)
    // FirebaseCrashlytics.instance.setUserIdentifier('user_id_here');

    runApp(MyApp());
  } catch (error, stackTrace) {
    // Catch any initialization errors
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Error during app initialization',
      fatal: true,
    );
    // Re-throw to show error UI
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesListBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesSearchBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HomeTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case TvSeriesSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TvSeriesSearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case TvSeriesSeasonsPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => TvSeriesSeasonsPage(
                  tvId: args['id'],
                  tvTitle: args['title'],
                  numberOfSeasons: args['seasons'],
                ),
                settings: settings,
              );
            case SeasonDetailPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => SeasonDetailPage(
                  tvId: args['tvId'],
                  tvTitle: args['tvTitle'],
                  seasonNumber: args['seasonNumber'],
                ),
                settings: settings,
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
