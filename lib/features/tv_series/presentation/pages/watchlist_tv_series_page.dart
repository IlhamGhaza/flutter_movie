import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../common/constants.dart';
import '../../../../common/state_enum.dart';
import '../bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist_tv_series';

  const WatchlistTvSeriesPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist TV Series'),
      ),
      body: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == RequestState.Loaded) {
            if (state.watchlistTvSeries.isEmpty) {
              return const Center(
                child: Text('No TV series in your watchlist yet!'),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = state.watchlistTvSeries[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        width: 54,
                        height: 80,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    title: Text(
                      tvSeries.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      tvSeries.firstAirDate.isNotEmpty
                          ? tvSeries.firstAirDate
                          : 'No release date',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.check_circle,
                        color: kMikadoYellow,
                      ),
                      onPressed: () {
                        context.read<WatchlistTvSeriesBloc>().add(
                              RemoveTvSeriesFromWatchlist(tvSeries),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from watchlist'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              itemCount: state.watchlistTvSeries.length,
            );
          } else if (state.state == RequestState.Error) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
