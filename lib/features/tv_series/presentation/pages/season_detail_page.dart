import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/episode_card.dart';
import 'package:ditonton/injection.dart' as di;

class SeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/season-detail';

  final int tvId;
  final String tvTitle;
  final int seasonNumber;

  const SeasonDetailPage({
    Key? key,
    required this.tvId,
    required this.tvTitle,
    required this.seasonNumber,
  }) : super(key: key);

  @override
  _SeasonDetailPageState createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  late final SeasonDetailBloc _seasonDetailBloc;

  @override
  void initState() {
    super.initState();
    _seasonDetailBloc = di.locator<SeasonDetailBloc>();
    Future.microtask(() {
      _seasonDetailBloc.add(
        FetchSeasonDetail(
          tvId: widget.tvId,
          seasonNumber: widget.seasonNumber,
        ),
      );
    });
  }

  @override
  void dispose() {
    // Don't dispose the bloc here as it's managed by the DI container
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _seasonDetailBloc,
      child: Scaffold(
        appBar: AppBar(
        title: Text('${widget.tvTitle} - Season ${widget.seasonNumber}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.state == RequestState.Error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message.isNotEmpty
                      ? state.message
                      : 'Failed to load season details',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final season = state.seasonDetails[widget.seasonNumber];
          if (season == null) {
            return const Center(
              child: Text('Season not found'),
            );
          }
          return CustomScrollView(
            slivers: [
              // SliverAppBar(
              //   expandedHeight: 100,
              //   pinned: true,
              //   flexibleSpace: FlexibleSpaceBar(
              //     title: Text(
              //       '${widget.tvTitle} - ${(season.name != null && season.name!.isNotEmpty) ? season.name! : 'Season ${widget.seasonNumber}'}',
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //     centerTitle: true,
              //     background: Container(
              //       color: Theme.of(context).primaryColor,
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (season.airDate?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Aired: ${season.airDate!.split(' ')[0]}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      if (season.overview.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Overview',
                          style: kHeading6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          season.overview,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Episodes (${season.episodes.length})',
                          style: kHeading6,
                        ),
                      ),
                      if (season.episodes.isEmpty)
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.tv_off_rounded,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Episodes Available',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Check back later for updates',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: season.episodes.length,
                          padding: const EdgeInsets.only(bottom: 24.0),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            try {
                              // Validate episodes list and index bounds
                              if (season.episodes.isEmpty || 
                                  index < 0 || 
                                  index >= season.episodes.length) {
                                return const SizedBox.shrink();
                              }

                              final episode = season.episodes[index];
                              
                              // Skip if episode is invalid (id is non-nullable so no need to check for null)
                              if (episode.id <= 0) {
                                return const SizedBox.shrink();
                              }

                              try {
                                return EpisodeCard(
                                  key: ValueKey('episode_${episode.id}_$index'),
                                  episode: episode,
                                );
                              } catch (e, stackTrace) {
                                debugPrint('Error creating EpisodeCard at index $index: $e');
                                debugPrintStack(stackTrace: stackTrace);
                                return const SizedBox.shrink();
                              }
                            } catch (e) {
                              debugPrint(
                                  'Error building episode at index $index: $e');
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        ),
      ),
    );
  }
}
