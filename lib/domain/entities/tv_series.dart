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
}
