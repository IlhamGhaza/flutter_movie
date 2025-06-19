import 'tv_series_model.dart';

class TvSeriesResponse {
  final List<TvSeriesModel> tvSeriesList;
  final int page;
  final int totalPages;
  final int totalResults;

  TvSeriesResponse({
    required this.tvSeriesList,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) => TvSeriesResponse(
    tvSeriesList: json['results'] == null 
        ? <TvSeriesModel>[] 
        : List<TvSeriesModel>.from(
            (json['results'] as List)
                .map((x) => TvSeriesModel.fromJson(x))
                .where((tvSeries) => tvSeries.id != 0),
          ),
    page: json['page'] ?? 1,
    totalPages: json['total_pages'] ?? 1,
    totalResults: json['total_results'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'results': List<dynamic>.from(tvSeriesList.map((x) => x.toJson())),
    'page': page,
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}
