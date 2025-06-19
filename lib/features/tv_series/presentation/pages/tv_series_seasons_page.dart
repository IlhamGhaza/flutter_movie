import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

import '../../../../common/state_enum.dart';
import '../bloc/season_detail/season_detail_bloc.dart';
import 'season_detail_page.dart';
import '../widgets/season_card.dart';

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
  late final SeasonDetailBloc _seasonDetailBloc;

  @override
  void initState() {
    super.initState();
    _seasonDetailBloc = di.locator<SeasonDetailBloc>();
    // Initialize the bloc with the initial events
    for (int i = 1; i <= widget.numberOfSeasons; i++) {
      _seasonDetailBloc.add(FetchSeasonDetail(tvId: widget.tvId, seasonNumber: i));
    }
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
          title: Text('${widget.tvTitle} - Seasons'),
        ),
        body: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
          builder: (context, state) {
            if (state.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == RequestState.Error) {
              return Center(
                child: Text(state.message),
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
                final season = state.seasonDetails[seasonNumber];
                
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
      ),
    );
  }
}
