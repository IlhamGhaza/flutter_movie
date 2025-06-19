import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list/movie_list_bloc.dart';
import '../widgets/movie_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieListBloc>().add(FetchPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state.popularMoviesState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.popularMoviesState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.popularMovies[index];
                  return MovieCard(movie);
                },
                itemCount: state.popularMovies.length,
              );
            } else if (state.popularMoviesState == RequestState.error) {
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
