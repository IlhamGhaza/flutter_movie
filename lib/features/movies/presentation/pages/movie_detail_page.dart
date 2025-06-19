import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../common/constants.dart';
import '../../data/models/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // FetchMovieDetail will also load initial watchlist status
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<MovieDetailBloc, MovieDetailState>(
            listener: (context, state) {
              if (state is WatchlistSuccess) {
                // Show success message with colored background
                final snackBar = SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // The BLoC now re-emits MovieDetailLoaded or MovieDetailWithRecommendations
                // with the updated watchlist status, so no need to dispatch LoadWatchlistStatus here.
              } else if (state is WatchlistError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is MovieDetailLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MovieDetailWithRecommendations) {
                return SafeArea(
                  child: DetailContent(
                    state.movie,
                    state.recommendations,
                    state.isAddedToWatchlist,
                  ),
                );
              } else if (state is MovieDetailLoaded) {
                return SafeArea(
                  child: DetailContent(
                    state.movie,
                    [], // No recommendations in this state
                    state.isAddedToWatchlist,
                  ),
                );
              } else if (state is MovieDetailError) {
                return Center(child: Text(state.message));
              }

              // Default return for any other states
              return Container();
            },
          ),
          // Back button
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.movie, this.recommendations, this.isAddedWatchlist,
      {Key? key})
      : super(key: key);

  // Helper method to create a chip for genres and runtime
  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Background image with gradient overlay
        Stack(
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              width: screenWidth,
              height: screenWidth * 0.6,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error, size: 40),
            ),
            // Gradient overlay
            Container(
              width: screenWidth,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: screenWidth * 0.5),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie title and watchlist button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isAddedWatchlist
                                  ? Colors.green
                                  : Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () async {
                                  final bloc = context.read<MovieDetailBloc>();
                                  if (!isAddedWatchlist) {
                                    bloc.add(AddWatchlist(movie));
                                  } else {
                                    // Show confirmation dialog before removing
                                    final shouldRemove = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: kRichBlack,
                                        title: Text(
                                          'Remove from Watchlist',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          'Are you sure you want to remove "${movie.title}" from your watchlist?',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(
                                              'CANCEL',
                                              style: TextStyle(
                                                  color: Colors.grey[400]),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.red[900],
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              'REMOVE',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldRemove == true) {
                                      bloc.add(RemoveFromWatchlist(movie));
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isAddedWatchlist
                                            ? Icons.check
                                            : Icons.add,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isAddedWatchlist
                                            ? 'In Watchlist'
                                            : 'Add to Watchlist',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Genres and runtime
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (_showGenres(movie.genres).isNotEmpty)
                            _buildInfoChip(_showGenres(movie.genres)),
                          if (movie.runtime > 0)
                            _buildInfoChip(_showDuration(movie.runtime)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: movie.voteAverage / 2,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: kMikadoYellow,
                            ),
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${movie.voteAverage.toStringAsFixed(1)}/10',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Overview
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty
                            ? movie.overview
                            : 'No overview available.',
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Recommendations
                      if (recommendations.isNotEmpty) ...[
                        Text(
                          'You Might Also Like',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final movie = recommendations[index];
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Movie poster
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            MovieDetailPage.ROUTE_NAME,
                                            arguments: movie.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.grey[800],
                                              child: const Icon(Icons.movie,
                                                  size: 40),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Movie title
                                    Text(
                                      movie.title ?? 'No Title',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((e) => e.name).join(', ');
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
