import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../widgets/tv_series_card.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';

class TvSeriesSearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search_tv_series';

  const TvSeriesSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TvSeriesSearchNotifier>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              onChanged: data.searchTvSeriesByQuery,
              decoration: const InputDecoration(
                hintText: 'Search TV Series',
                border: InputBorder.none,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              if (data.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.state == RequestState.Error) {
                return Center(
                  child: Text(data.message),
                );
              } else if (data.searchResult.isEmpty) {
                return const Center(
                  child: Text('TV Series Not Found'),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final tvSeries = data.searchResult[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TvSeriesDetailPage.ROUTE_NAME,
                          arguments: tvSeries.id,
                        );
                      },
                      child: TvSeriesCard(tvSeries),
                    );
                  },
                  itemCount: data.searchResult.length,
                );
              }
            }),
          ),
        );
      },
    );
  }
}
