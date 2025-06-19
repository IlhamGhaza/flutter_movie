class TvSeries {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final List<int> genreIds;
  final String firstAirDate;
  final double popularity;
  final int voteCount;
  final String backdropPath;
  final String originalLanguage;
  final String originalName;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;

  TvSeries({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genreIds,
    required this.firstAirDate,
    required this.popularity,
    required this.voteCount,
    required this.backdropPath,
    required this.originalLanguage,
    required this.originalName,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  factory TvSeries.watchlist({
    required int id,
    required String overview,
    String? posterPath,
    String? name,
    String? firstAirDate,
  }) {
    return TvSeries(
      id: id,
      title: name ?? '',
      overview: overview,
      posterPath: posterPath ?? '',
      voteAverage: 0.0,
      genreIds: [],
      firstAirDate: firstAirDate ?? '',
      popularity: 0.0,
      voteCount: 0,
      backdropPath: '',
      originalLanguage: '',
      originalName: name ?? '',
      name: name ?? '',
      numberOfEpisodes: 0,
      numberOfSeasons: 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TvSeries &&
        other.id == id &&
        other.title == title &&
        other.overview == overview &&
        other.posterPath == posterPath &&
        other.voteAverage == voteAverage &&
        other.genreIds == genreIds &&
        other.firstAirDate == firstAirDate &&
        other.popularity == popularity &&
        other.voteCount == voteCount &&
        other.backdropPath == backdropPath &&
        other.originalLanguage == originalLanguage &&
        other.originalName == originalName &&
        other.name == name &&
        other.numberOfEpisodes == numberOfEpisodes &&
        other.numberOfSeasons == numberOfSeasons;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        overview.hashCode ^
        posterPath.hashCode ^
        voteAverage.hashCode ^
        genreIds.hashCode ^
        firstAirDate.hashCode ^
        popularity.hashCode ^
        voteCount.hashCode ^
        backdropPath.hashCode ^
        originalLanguage.hashCode ^
        originalName.hashCode ^
        name.hashCode ^
        numberOfEpisodes.hashCode ^
        numberOfSeasons.hashCode;
  }

  @override
  String toString() {
    return 'TvSeries{id: $id, title: $title, overview: $overview, posterPath: $posterPath, '
        'voteAverage: $voteAverage, genreIds: $genreIds, firstAirDate: $firstAirDate, '
        'popularity: $popularity, voteCount: $voteCount, backdropPath: $backdropPath, '
        'originalLanguage: $originalLanguage, originalName: $originalName, name: $name, '
        'numberOfEpisodes: $numberOfEpisodes, numberOfSeasons: $numberOfSeasons}';
  }
}
