import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating_bar;

import '../../../../common/constants.dart';
import '../../../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../../domain/entities/season_detail.dart'; // Import SeasonDetail
import '../bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'tv_series_seasons_page.dart'; // Import TvSeriesSeasonsPage

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
      final bloc = context.read<TVSeriesDetailBloc>();
      bloc.add(FetchTVSeriesDetail(widget.id));
      bloc.add(LoadWatchlistStatus(widget.id));
      // Fetch first season details by default
      if (widget.id > 0) {
        bloc.add(FetchSeasonDetail(tvSeriesId: widget.id, seasonNumber: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TVSeriesDetailBloc, TVSeriesDetailState>(
        listener: (context, state) {
          if (state.watchlistMessage.isNotEmpty) {
            // Logic to distinguish success (SnackBar) vs error (Dialog) for watchlist messages
            // Assuming success messages are "Added to Watchlist" or "Removed from Watchlist"
            // and other messages are errors.
            // TODO: Use constants for these messages
            if (state.watchlistMessage == 'Added to Watchlist' ||
                state.watchlistMessage == 'Removed from Watchlist') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.watchlistMessage)),
              );
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(state.watchlistMessage),
                    );
                  });
            }
            context.read<TVSeriesDetailBloc>().add(ClearWatchlistMessage());
          }
        },
        builder: (context, state) {
          if (state.tvSeriesDetailRequestState == RequestState.Loading &&
              state.tvSeriesDetail == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.tvSeriesDetailRequestState == RequestState.Error) {
            return Center(
              child: Text(state.tvSeriesDetailMessage),
            );
          } else if (state.tvSeriesDetail != null) {
            return SafeArea(
              child: DetailContent(
                state.tvSeriesDetail!,
                state.recommendations,
                state.isAddedToWatchlist,
                currentSeasonDetail: state.currentSeasonDetail,
                seasonDetailRequestState: state.seasonDetailRequestState,
                seasonDetailMessage: state.seasonDetailMessage,
                recommendationsRequestState: state.recommendationsRequestState,
                recommendationsMessage: state.recommendationsMessage,
              ),
            );
          }
          return const Center(
            child: Text('TV Series Not Found'),
          );
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final SeasonDetail? currentSeasonDetail;
  final RequestState seasonDetailRequestState;
  final String seasonDetailMessage;
  final RequestState recommendationsRequestState;
  final String recommendationsMessage;

  const DetailContent(
    this.tvSeries,
    this.recommendations,
    this.isAddedToWatchlist, {
    Key? key,
    this.currentSeasonDetail,
    required this.seasonDetailRequestState,
    required this.seasonDetailMessage,
    required this.recommendationsRequestState,
    required this.recommendationsMessage,
  }) : super(key: key);

  // TODO: Define these constants properly, e.g., in the BLoC or a common constants file
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  String _showGenres(List<dynamic> genres) {
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
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
                                    onPressed: () {
                                      if (!isAddedToWatchlist) {
                                        context
                                            .read<TVSeriesDetailBloc>()
                                            .add(AddToWatchlist(tvSeries));
                                      } else {
                                        context
                                            .read<TVSeriesDetailBloc>()
                                            .add(RemoveFromWatchlist(tvSeries));
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
                                style: kBodyText.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // Display season card using passed state
                              if (seasonDetailRequestState ==
                                  RequestState.Loading)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (seasonDetailRequestState ==
                                  RequestState.Error)
                                Center(
                                  child: Text(
                                    seasonDetailMessage,
                                    style: kBodyText,
                                  ),
                                )
                              else if (currentSeasonDetail != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Season ${currentSeasonDetail!.seasonNumber}',
                                      style: kHeading6,
                                    ),
                                    const SizedBox(height: 8),
                                    // TODO: Replace with your SeasonCard widget if you have one
                                    // For now, just displaying some info
                                    // SeasonCard(
                                    //   season: currentSeasonDetail!,
                                    //   onTap: () {
                                    //     // Handle season tap, e.g., navigate to season detail page
                                    //   },
                                    // ),
                                    Text('Name: ${currentSeasonDetail!.name}'),
                                    Text(
                                        'Episodes: ${currentSeasonDetail!.episodeCount}'),
                                    const SizedBox(height: 8),
                                    if (tvSeries.numberOfSeasons > 1)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            TvSeriesSeasonsPage.ROUTE_NAME,
                                            arguments: {
                                              'id': tvSeries.id,
                                              'title': tvSeries.name,
                                              'seasons':
                                                  tvSeries.numberOfSeasons,
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
                                )
                              else
                                const SizedBox.shrink(),
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
                                    } else if (index == starValue.floor() &&
                                        starValue % 1 != 0) {
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
                              'Overview', // This seems like a duplicate "Overview" section
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview, // Duplicate overview text
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            // Display recommendations using passed state
                            if (recommendationsRequestState ==
                                RequestState.Loading)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (recommendationsRequestState ==
                                RequestState.Error)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  recommendationsMessage,
                                  style: kBodyText,
                                ),
                              )
                            else if (recommendations.isEmpty &&
                                recommendationsRequestState ==
                                    RequestState.Loaded)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'No recommendations available',
                                  style: kBodyText,
                                ),
                              )
                            else if (recommendations.isNotEmpty)
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recommendations.length,
                                  itemBuilder: (context, index) {
                                    final tvRecommendation =
                                        recommendations[index];
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            TvSeriesDetailPage.ROUTE_NAME,
                                            arguments: tvRecommendation.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            width: 120,
                                            fit: BoxFit.cover,
                                            imageUrl: tvRecommendation
                                                        .posterPath !=
                                                    null
                                                ? 'https://image.tmdb.org/t/p/w500${tvRecommendation.posterPath}'
                                                : tvRecommendation
                                                            .backdropPath !=
                                                    null
                                                ? 'https://image.tmdb.org/t/p/w500${tvRecommendation.backdropPath}'
                                                    : '',
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 120,
                                              height: 180,
                                              color: Colors.grey[800],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
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
                              )
                            else
                              const SizedBox.shrink(),
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
          ),
        ),
      ],
    );
  }
}
