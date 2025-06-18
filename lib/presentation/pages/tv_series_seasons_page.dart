import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/season_card.dart';

class TvSeriesSeasonsPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-seasons';

  final int tvId;
  final String tvTitle;
  final int numberOfSeasons;

  const TvSeriesSeasonsPage({
    Key? key,
    required this.tvId,
    required this.tvTitle,
    required this.numberOfSeasons,
  }) : super(key: key);

  @override
  _TvSeriesSeasonsPageState createState() => _TvSeriesSeasonsPageState();
}

class _TvSeriesSeasonsPageState extends State<TvSeriesSeasonsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Load all seasons
      for (int i = 1; i <= widget.numberOfSeasons; i++) {
        if (!context.read<TvSeriesDetailNotifier>().seasonDetails.containsKey(i)) {
          context.read<TvSeriesDetailNotifier>().fetchSeasonDetail(widget.tvId, i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.tvTitle} - Seasons'),
      ),
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, data, child) {
          if (data.seasonDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.seasonDetailState == RequestState.Error) {
            return Center(
              child: Text(data.seasonDetailMessage),
            );
          }

          final seasons = List.generate(
            widget.numberOfSeasons,
            (index) => index + 1,
          )..sort((a, b) => b.compareTo(a)); // Show latest seasons first

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              final seasonNumber = seasons[index];
              final season = data.seasonDetails[seasonNumber];
              
              if (season == null) {
                return const ListTile(
                  title: Text('Loading season...'),
                  leading: CircularProgressIndicator(),
                );
              }

              return SeasonCard(
                season: season,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SeasonDetailPage.ROUTE_NAME,
                    arguments: {
                      'tvId': widget.tvId,
                      'tvTitle': widget.tvTitle,
                      'seasonNumber': seasonNumber,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
