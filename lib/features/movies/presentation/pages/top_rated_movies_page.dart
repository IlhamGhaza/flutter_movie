import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list/movie_list_bloc.dart';
import '../widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieListBloc>().add(FetchTopRatedMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state.topRatedMoviesState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.topRatedMoviesState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.topRatedMovies[index];
                  return MovieCard(movie);
                },
                itemCount: state.topRatedMovies.length,
              );
            } else if (state.topRatedMoviesState == RequestState.error) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text('No data available'),
            );
          },
        ),
      ),
    );
  }
}
