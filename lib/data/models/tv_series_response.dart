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
    tvSeriesList: List<TvSeriesModel>.from(
      json['results'].map((x) => TvSeriesModel.fromJson(x)),
    ),
    page: json['page'],
    totalPages: json['total_pages'],
    totalResults: json['total_results'],
  );

  Map<String, dynamic> toJson() => {
    'results': List<dynamic>.from(tvSeriesList.map((x) => x.toJson())),
    'page': page,
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}
