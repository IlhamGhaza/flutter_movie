import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../common/constants.dart';
import '../widgets/tv_series_card.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .fetchTvSeriesDetail(widget.id);
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .getTvSeriesRecommendations(widget.id);
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
                widget.id,
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeries tvSeries;
  final List<TvSeries> recommendations;
  final int id;

  const DetailContent(this.tvSeries, this.recommendations, this.id, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.backdropPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                            Text(
                              tvSeries.firstAirDate,
                              style: kSubtitle,
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TvSeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationsState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationsState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvSeries = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.ROUTE_NAME,
                                                arguments: tvSeries.id,
                                              );
                                            },
                                            child: TvSeriesCard(tvSeries),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                }
                              },
                            ),
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
            initialChildSize: 0.5,
            minChildSize: 0.25,
            maxChildSize: 1.0,
          ),
        ),
      ],
    );
  }
}
