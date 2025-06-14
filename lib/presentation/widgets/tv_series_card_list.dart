import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_series.dart';

class TvSeriesCardList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesCardList({
    Key? key,
    required this.tvSeries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Consumer<WatchlistTvSeriesNotifier>(
            builder: (context, data, child) {
              return FutureBuilder<bool>(
                future: data.isAddedToWatchlist(tvSeries[index].id),
                builder: (context, snapshot) {
                  bool isAdded = snapshot.data ?? false;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/tv_series_detail',
                          arguments: tvSeries[index].id,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          TvSeriesCard(tvSeries[index]),
                          isAdded
                              ? const Icon(
                                  Icons.check_circle,
                                  color: kMikadoYellow,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
