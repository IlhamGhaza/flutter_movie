import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../domain/entities/tv_series.dart';
import 'tv_series_card.dart';

class TvSeriesCardList extends StatelessWidget {
  final List<TvSeries> tvSeries;
  final bool showWatchlistStatus;

  const TvSeriesCardList({
    Key? key,
    required this.tvSeries,
    this.showWatchlistStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.length,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/tv_series_detail',
                  arguments: tv.id,
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  TvSeriesCard(tv),
                  if (showWatchlistStatus)
                    const Positioned(
                      right: 8,
                      bottom: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: kMikadoYellow,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
