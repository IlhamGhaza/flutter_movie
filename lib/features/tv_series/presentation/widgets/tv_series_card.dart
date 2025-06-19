import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../common/constants.dart';
import '../pages/tv_series_detail_page.dart';
import '../../domain/entities/tv_series.dart';

class TvSeriesCard extends StatelessWidget {
  final TvSeries tvSeries;

  const TvSeriesCard(this.tvSeries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            TvSeriesDetailPage.ROUTE_NAME,
            arguments: tvSeries.id,
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvSeries.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tvSeries.firstAirDate,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: tvSeries.posterPath.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
                        width: 80,
                        height: 120, // Added height for consistency
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[800],
                          child: const Icon(Icons.error_outline, color: Colors.white70),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 120, // Added height for consistency
                        color: Colors.grey[800],
                        child: const Icon(Icons.tv_rounded,
                            color: Colors.white70, size: 40),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
