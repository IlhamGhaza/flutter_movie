import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/presentation/widgets/season_card.dart';
import 'package:ditonton/presentation/pages/tv_series_seasons_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating_bar;

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv_series_detail';

  final int id;
  const TvSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = Provider.of<TvSeriesDetailNotifier>(context, listen: false);
      notifier.fetchTvSeriesDetail(widget.id);
      notifier.getTvSeriesRecommendations(widget.id);
      notifier.loadWatchlistStatus(widget.id);
      
      // Fetch first season details by default
      if (widget.id > 0) {
        notifier.fetchSeasonDetail(widget.id, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, data, child) {
          if (data.detailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.detailState == RequestState.Error) {
            return Center(
              child: Text(data.message),
            );
          } else if (data.tvSeriesDetail == null) {
            return const Center(
              child: Text('TV Series Not Found'),
            );
          } else {
            return SafeArea(
              child: DetailContent(
                data.tvSeriesDetail!,
                data.recommendations,
                data.isAddedToWatchlist,
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;

  const DetailContent(this.tvSeries, this.recommendations, this.isAddedToWatchlist, {Key? key})
      : super(key: key);

  String _showGenres(List<Genre> genres) {
    if (genres.isEmpty) return '';
    return genres.map((genre) => genre.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: tvSeries.backdropPath != null
              ? 'https://image.tmdb.org/t/p/w500${tvSeries.backdropPath}'
              : tvSeries.posterPath != null
                  ? 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}'
                  : '',
          width: screenWidth,
          height: screenWidth * 0.6,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[800],
            child: const Icon(Icons.error, color: Colors.white),
          ),
        ),
        // Back Button
        Positioned(
          top: 16,
          left: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        // Content
        Container(
          margin: const EdgeInsets.only(top: 200),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: kHeading5,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                rating_bar.RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24.0,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${tvSeries.voteAverage.toStringAsFixed(1)}/10',
                                  style: kSubtitle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () async {
                                      if (!isAddedToWatchlist) {
                                        await Provider.of<TvSeriesDetailNotifier>(
                                                context,
                                                listen: false)
                                            .addWatchlist(tvSeries);
                                      } else {
                                        await Provider.of<TvSeriesDetailNotifier>(
                                                context,
                                                listen: false)
                                            .removeFromWatchlist(tvSeries);
                                      }

                                      final message =
                                          Provider.of<TvSeriesDetailNotifier>(
                                                  context,
                                                  listen: false)
                                              .watchlistMessage;

                                      if (message ==
                                              TvSeriesDetailNotifier
                                                  .watchlistAddSuccessMessage ||
                                          message ==
                                              TvSeriesDetailNotifier
                                                  .watchlistRemoveSuccessMessage) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(message)));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text(message),
                                              );
                                            });
                                      }
                                    },
                                    icon: Icon(
                                      isAddedToWatchlist
                                          ? Icons.check
                                          : Icons.add,
                                    ),
                                    label: Text(
                                      isAddedToWatchlist
                                          ? 'Added to Watchlist'
                                          : 'Add to Watchlist',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tvSeries.overview,
                              style: kBodyText,
                            ),
                            const SizedBox(height: 16),
                            if (_showGenres(tvSeries.genres).isNotEmpty) ...[
                              Text(
                                'Genres: ${_showGenres(tvSeries.genres)}',
                                style: kBodyText,
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (tvSeries.firstAirDate.isNotEmpty) ...[
                              Text(
                                'First Air Date: ${tvSeries.firstAirDate}',
                                style: kBodyText,
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (tvSeries.numberOfSeasons > 0) ...[
                              Text(
                                'Seasons: ${tvSeries.numberOfSeasons}',
                                style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // Display season cards
                              Consumer<TvSeriesDetailNotifier>(
                                builder: (context, data, child) {
                                  if (data.seasonDetailState == RequestState.Loading) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (data.seasonDetailState == RequestState.Error) {
                                    return Center(
                                      child: Text(
                                        data.seasonDetailMessage,
                                        style: kBodyText,
                                      ),
                                    );
                                  } else if (data.seasonDetails.isNotEmpty) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Season ${data.seasonDetails.values.first.seasonNumber}',
                                          style: kHeading6,
                                        ),
                                        const SizedBox(height: 8),
                                        SeasonCard(
                                          season: data.seasonDetails.values.first,
                                          onTap: () {
                                            // Handle season tap
                                          },
                                        ),
                                        // Add a button to view all seasons
                                        if (tvSeries.numberOfSeasons > 1)
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                TvSeriesSeasonsPage.ROUTE_NAME,
                                                arguments: {
                                                  'id': tvSeries.id,
                                                  'title': tvSeries.name,
                                                  'seasons': tvSeries.numberOfSeasons,
                                                },
                                              );
                                            },
                                            child: Text(
                                              'View All ${tvSeries.numberOfSeasons} Seasons',
                                              style: const TextStyle(
                                                color: kMikadoYellow,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (tvSeries.numberOfEpisodes > 0) ...[
                              Text(
                                'Total Episodes: ${tvSeries.numberOfEpisodes}',
                                style: kBodyText,
                              ),
                              const SizedBox(height: 16),
                            ],
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    final starValue = tvSeries.voteAverage / 2;
                                    if (index < starValue.floor()) {
                                      return const Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                        size: 24,
                                      );
                                    } else if (index == starValue.floor() && starValue % 1 != 0) {
                                      return const Icon(
                                        Icons.star_half,
                                        color: kMikadoYellow,
                                        size: 24,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.star_border,
                                        color: kMikadoYellow,
                                        size: 24,
                                      );
                                    }
                                  }),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  tvSeries.voteAverage.toStringAsFixed(1),
                                  style: kHeading6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            Consumer<TvSeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationsState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (data.recommendationsState ==
                                    RequestState.Error) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      data.recommendationsMessage,
                                      style: kBodyText,
                                    ),
                                  );
                                } else if (data.recommendations.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'No recommendations available',
                                      style: kBodyText,
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 180,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.recommendations.length,
                                      itemBuilder: (context, index) {
                                        final tvSeries = data.recommendations[index];
                                        return Container(
                                          margin: const EdgeInsets.only(right: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.ROUTE_NAME,
                                                arguments: tvSeries.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                width: 120,
                                                fit: BoxFit.cover,
                                                imageUrl: tvSeries.posterPath != null
                                                    ? 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}'
                                                    : tvSeries.backdropPath != null
                                                        ? 'https://image.tmdb.org/t/p/w500${tvSeries.backdropPath}'
                                                        : '',
                                                placeholder: (context, url) => Container(
                                                  width: 120,
                                                  height: 180,
                                                  color: Colors.grey[800],
                                                  child: const Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  width: 120,
                                                  height: 180,
                                                  color: Colors.grey[800],
                                                  child: const Icon(
                                                    Icons.error_outline,
                                                    color: Colors.white54,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            // minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
      ],
    );
  }
}
