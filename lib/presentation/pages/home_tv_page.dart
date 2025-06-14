import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../widgets/tv_series_card_list.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'popular_tv_series_page.dart';
import 'top_rated_tv_series_page.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({Key? key}) : super(key: key);

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvSeriesListNotifier>(context, listen: false)
          .fetchNowPlayingTvSeries();
      Provider.of<TvSeriesListNotifier>(context, listen: false)
          .fetchPopularTvSeries();
      Provider.of<TvSeriesListNotifier>(context, listen: false)
          .fetchTopRatedTvSeries();
    });
  }

  Widget _buildSubHeading({
    required String title,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kHeading6,
          ),
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text('See More'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            Consumer<TvSeriesListNotifier>(
              builder: (context, data, child) {
                if (data.nowPlayingState == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.nowPlayingState == RequestState.Loaded) {
                  return TvSeriesCardList(tvSeries: data.nowPlayingTvSeries);
                } else {
                  return Text(data.message);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(
                context,
                PopularTvSeriesPage.ROUTE_NAME,
              ),
            ),
            Consumer<TvSeriesListNotifier>(
              builder: (context, data, child) {
                if (data.popularState == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.popularState == RequestState.Loaded) {
                  return TvSeriesCardList(tvSeries: data.popularTvSeries);
                } else {
                  return Text(data.message);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(
                context,
                TopRatedTvSeriesPage.ROUTE_NAME,
              ),
            ),
            Consumer<TvSeriesListNotifier>(
              builder: (context, data, child) {
                if (data.topRatedState == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.topRatedState == RequestState.Loaded) {
                  return TvSeriesCardList(tvSeries: data.topRatedTvSeries);
                } else {
                  return Text(data.message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
