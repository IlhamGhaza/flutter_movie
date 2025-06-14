import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/state_enum.dart';
import '../widgets/tv_series_card.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular_tv_series';

  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  _PopularTvSeriesPageState createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularTvSeriesNotifier>(context, listen: false)
            .fetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.popularState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.popularState == RequestState.Error) {
              return Center(
                child: Text(data.message),
              );
            } else if (data.popularTvSeries.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvSeriesCard(data.popularTvSeries[index]);
                },
                itemCount: data.popularTvSeries.length,
              );
            }
          },
        ),
      ),
    );
  }
}
