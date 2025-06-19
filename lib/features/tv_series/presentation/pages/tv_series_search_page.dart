import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tv_series.dart';
import '../widgets/tv_series_card.dart';
import '../bloc/tv_series_search/tv_series_search_bloc.dart';

class TvSeriesSearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search_tv_series';

  const TvSeriesSearchPage({Key? key}) : super(key: key);

  @override
  _TvSeriesSearchPageState createState() => _TvSeriesSearchPageState();
}

class _TvSeriesSearchPageState extends State<TvSeriesSearchPage> {
  final _searchController = TextEditingController();
  late TVSeriesSearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<TVSeriesSearchBloc>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search TV Series',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            _searchBloc.add(OnQueryChanged(query));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVSeriesSearchBloc, TVSeriesSearchState>(
          builder: (context, state) {
            if (state is TVSeriesSearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TVSeriesSearchError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is TVSeriesSearchHasData) {
              final result = state.result;
              if (result.isEmpty) {
                return const Center(
                  child: Text('TV Series Not Found'),
                );
              }
              return _buildSearchResults(result);
            } else {
              return const Center(
                child: Text('Search for TV series'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> tvSeries) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final tv = tvSeries[index] as TvSeries;
        return TvSeriesCard(tv);
      },
      itemCount: tvSeries.length,
    );
  }
}
