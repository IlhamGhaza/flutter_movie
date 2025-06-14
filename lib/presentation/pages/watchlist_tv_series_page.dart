import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';

import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist_tv_series';

  const WatchlistTvSeriesPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
            .fetchWatchlistTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistTvSeriesNotifier>(
      builder: (context, data, child) {
        if (data.state == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.state == RequestState.Error) {
          return Center(
            child: Text(data.message),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tvSeries = data.watchlistTvSeries[index];
              return Consumer<WatchlistTvSeriesNotifier>(
                builder: (context, data, child) {
                  return FutureBuilder<bool>(
                    future: data.isAddedToWatchlist(tvSeries.id),
                    builder: (context, snapshot) {
                      var isAdded = snapshot.data ?? false;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: SizedBox(
                          width: 54,
                          height: 54,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(
                          tvSeries.name,
                          maxLines: 2,
                        ),
                        subtitle: Text(tvSeries.firstAirDate),
                        trailing: IconButton(
                          icon: Icon(
                            isAdded ? Icons.check : Icons.add,
                            color: kMikadoYellow,
                          ),
                          onPressed: () async {
                            if (!isAdded) {
                              await data.addTvSeriesToWatchlist(tvSeries);
                            } else {
                              await data.removeTvSeriesFromWatchlist(tvSeries);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
            itemCount: data.watchlistTvSeries.length,
          );
        }
      },
    );
  }
}
