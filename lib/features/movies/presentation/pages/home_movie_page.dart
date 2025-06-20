import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/features/movies/presentation/pages/about_page.dart';
import 'package:ditonton/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieListBloc>().add(FetchNowPlayingMovies());
      context.read<MovieListBloc>().add(FetchPopularMovies());
      context.read<MovieListBloc>().add(FetchTopRatedMovies());
    });
  }

  Widget _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Ditonton'),
            actions: [
              //debug only
              // IconButton(
              //   icon: Icon(Icons.bug_report),
              //   tooltip: 'Test Crash',
              //   onPressed: () {
              //     // Trigger a test crash
              //     FirebaseCrashlytics.instance.crash();
              //   },
              // ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/circle-g.png'),
                    backgroundColor: Colors.grey.shade900,
                  ),
                  accountName: Text('Ditonton'),
                  accountEmail: Text('ditonton@dicoding.com'),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.movie),
                  title: Text('Movies'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.tv),
                  title: Text('TV Series'),
                  onTap: () {
                    Navigator.pushNamed(context, '/tv-series');
                  },
                ),
                ExpansionTile(
                  leading: Icon(Icons.save_alt),
                  title: Text('Watchlist'),
                  children: [
                    ListTile(
                      leading: Icon(Icons.movie_filter, size: 20),
                      title: Text('Movies Watchlist'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.tv, size: 20),
                      title: Text('TV Series Watchlist'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, WatchlistTvSeriesPage.ROUTE_NAME);
                      },
                    ),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                  },
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubHeading(
                    title: 'Now Playing',
                    onTap: () {},
                  ),
                  if (state.nowPlayingState == RequestState.loading)
                    Center(child: CircularProgressIndicator())
                  else if (state.nowPlayingState == RequestState.loaded)
                    _MovieList(movies: state.nowPlayingMovies)
                  else
                    Text(state.message),
                  
                  _buildSubHeading(
                    title: 'Popular',
                    onTap: () {
                      Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME);
                    },
                  ),
                  if (state.popularMoviesState == RequestState.loading)
                    Center(child: CircularProgressIndicator())
                  else if (state.popularMoviesState == RequestState.loaded)
                    _MovieList(movies: state.popularMovies)
                  else
                    Text(state.message),
                  
                  _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () {
                      Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME);
                    },
                  ),
if (state.topRatedMoviesState == RequestState.loading)
                    Center(child: CircularProgressIndicator())
                  else if (state.topRatedMoviesState == RequestState.loaded)
                    _MovieList(movies: state.topRatedMovies)
                  else
                    Text(state.message),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MovieList extends StatelessWidget {
  final List<Movie> movies;

  const _MovieList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
