import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/state_enum.dart';
import '../widgets/tv_series_card.dart';
import '../bloc/popular_tv_series/popular_tv_series_bloc.dart';

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
        context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
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
