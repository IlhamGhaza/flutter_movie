import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/state_enum.dart';
import '../widgets/tv_series_card.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top_rated_tv_series';

  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  _TopRatedTvSeriesPageState createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTvSeriesNotifier>(context, listen: false)
            .fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.topRatedState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.topRatedState == RequestState.Error) {
              return Center(
                child: Text(data.message),
              );
            } else if (data.topRatedTvSeries.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvSeriesCard(data.topRatedTvSeries[index]);
                },
                itemCount: data.topRatedTvSeries.length,
              );
            }
          },
        ),
      ),
    );
  }
}
