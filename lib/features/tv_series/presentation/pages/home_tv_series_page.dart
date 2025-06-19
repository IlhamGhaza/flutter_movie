import 'package:ditonton/common/constants.dart';
import 'package:ditonton/features/tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_search_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tv_series.dart';
import '../bloc/tv_series_list/tv_series_list_bloc.dart';
import '../widgets/tv_series_card_list.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series';

  const HomeTvSeriesPage({Key? key}) : super(key: key);

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVSeriesListBloc>().add(FetchNowPlayingTVSeries());
      context.read<TVSeriesListBloc>().add(FetchPopularTVSeries());
      context.read<TVSeriesListBloc>().add(FetchTopRatedTVSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TvSeriesSearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'On Air',
                style: kHeading6,
              ),
              BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
                builder: (context, state) {
                  if (state.nowPlayingState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.nowPlayingState == RequestState.Loaded) {
                    return TvSeriesList(state.nowPlayingTVSeries);
                  } else if (state.nowPlayingState == RequestState.Error) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
                builder: (context, state) {
                  if (state.popularTVSeriesState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.popularTVSeriesState == RequestState.Loaded) {
                    return TvSeriesList(state.popularTVSeries);
                  } else if (state.popularTVSeriesState == RequestState.Error) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TVSeriesListBloc, TVSeriesListState>(
                builder: (context, state) {
                  if (state.topRatedTVSeriesState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.topRatedTVSeriesState == RequestState.Loaded) {
                    return TvSeriesList(state.topRatedTVSeries);
                  } else if (state.topRatedTVSeriesState == RequestState.Error) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
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
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TvSeriesCardList(
      tvSeries: tvSeries,
    );
  }
}
