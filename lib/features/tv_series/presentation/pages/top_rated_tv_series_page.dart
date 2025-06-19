import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/state_enum.dart';
import '../widgets/tv_series_card.dart';
import '../bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';

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
        context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == RequestState.Error) {
              return Center(
                child: Text(state.message),
              );
            } else if (state.tvSeries.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvSeriesCard(state.tvSeries[index]);
                },
                itemCount: state.tvSeries.length,
              );
            }
          },
        ),
      ),
    );
  }
}
