import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/season_detail.dart';

class SeasonCard extends StatelessWidget {
  final SeasonDetail season;
  final Function()? onTap;

  const SeasonCard({
    Key? key,
    required this.season,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely get the season name or provide a default
    final seasonName = season.name.isNotEmpty ? season.name : 'Season ${season.seasonNumber}';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Season poster with name and air date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Season poster
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  child: season.posterPath?.isNotEmpty == true
                      ? CachedNetworkImage(
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${season.posterPath}',
                          placeholder: (context, url) => Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.tv_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 150,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.tv_rounded,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
                // Season info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seasonName,
                          style: kHeading6,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (season.airDate?.isNotEmpty == true)
                          Text(
                            'Aired: ${season.airDate!.split(' ')[0]}',
                            style: kBodyText.copyWith(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${season.episodeCount} Episode${season.episodeCount != 1 ? 's' : ''}',
                          style: kBodyText.copyWith(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Season overview
            if (season.overview.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  season.overview,
                  style: kBodyText.copyWith(fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
