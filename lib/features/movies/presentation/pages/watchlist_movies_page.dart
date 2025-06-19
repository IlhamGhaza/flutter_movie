import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils.dart';
import '../bloc/watchlist_movie/watchlist_movie_bloc.dart';
import '../bloc/watchlist_movie/watchlist_movie_event.dart';
import '../bloc/watchlist_movie/watchlist_movie_state.dart';
import '../widgets/movie_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie);
              },
              itemCount: state.movies.length,
            );
          } else if (state is WatchlistMovieError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
