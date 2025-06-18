import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/episode.dart' as episode_entity;
import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final episode_entity.Episode episode;
  final bool isExpanded;
  final VoidCallback? onTap;

  const EpisodeCard({
    Key? key,
    required this.episode,
    this.isExpanded = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      // Add debug prints to track episode data
      // developer.log(
      //     'Building EpisodeCard for episode: ${episode.episodeNumber}',
      //     name: 'EpisodeCard');

      // Safely get episode details with fallbacks
      final episodeNumber = episode.episodeNumber;
      final episodeName =
          episode.name.isNotEmpty ? episode.name : 'Episode $episodeNumber';

      if (episodeNumber == 0) {
        // developer.log('Warning: Episode number is 0 for episode: ${episode.id}',
        //     name: 'EpisodeCard');
      }

      return _buildEpisodeCard(context, episodeNumber, episodeName);
    } catch (e, stackTrace) {
      developer.log('Error building EpisodeCard: $e',
          name: 'EpisodeCard', error: e, stackTrace: stackTrace);
      return _buildErrorCard(e.toString());
    }
  }

  Widget _buildEpisodeCard(
    BuildContext context,
    int episodeNumber,
    String episodeName,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with episode number and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Episode number
                  _buildEpisodeNumber(episodeNumber),
                  const SizedBox(width: 12),
                  // Episode title and air date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          episodeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (episode.airDate?.isNotEmpty == true)
                          _buildAirDate(episode.airDate!),
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  if (onTap != null) _buildExpandIcon(),
                ],
              ),
              // Expanded content
              if (isExpanded) ..._buildExpandedContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeNumber(int number) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kMikadoYellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: kMikadoYellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAirDate(String airDate) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        'Aired: ${airDate.split(' ').first}',
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    return Icon(
      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      color: Colors.grey[600],
    );
  }

  List<Widget> _buildExpandedContent() {
    return [
      const SizedBox(height: 8),
      const Divider(height: 1, thickness: 1),
      const SizedBox(height: 8),
      if (episode.stillPath?.isNotEmpty == true) ...[
        _buildStillImage(),
        const SizedBox(height: 12),
      ],
      if (episode.overview.isNotEmpty) ...[
        _buildOverview(),
        const SizedBox(height: 12),
      ],
      _buildEpisodeInfo(),
    ];
  }

  Widget _buildStillImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w500${episode.stillPath}',
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
        placeholder: (context, url) => Container(
          height: 200,
          color: Colors.grey[900],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: Colors.grey[800],
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Text(
      episode.overview,
      style: const TextStyle(fontSize: 14, height: 1.4),
    );
  }

  Widget _buildEpisodeInfo() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (episode.runtime != null)
          _buildInfoRow(
            icon: Icons.timer_outlined,
            text: '${episode.runtime} min',
          ),
        if (episode.voteAverage > 0)
          _buildInfoRow(
            icon: Icons.star,
            text: episode.voteAverage.toStringAsFixed(1),
            iconColor: kMikadoYellow,
          ),
        if (episode.voteCount != null && episode.voteCount! > 0)
          _buildInfoRow(
            icon: Icons.people,
            text: '${episode.voteCount} votes',
          ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: Colors.red[900]?.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error loading episode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to retry',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        error,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.refresh, color: Colors.white70, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
