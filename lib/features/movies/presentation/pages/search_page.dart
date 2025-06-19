import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants.dart';
import '../bloc/movie_search/movie_search_bloc.dart';
import '../bloc/movie_search/watchlist_movie_event.dart';
import '../bloc/movie_search/watchlist_movie_state.dart';
import '../widgets/movie_card_list.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<MovieSearchBloc>().add(OnMovieQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state is MovieSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MovieSearchHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is MovieSearchError) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Text(
                        state.message,
                        style: kBodyText,
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text('Search for movies'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
