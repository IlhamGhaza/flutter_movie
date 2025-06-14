import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import '../../mocks/mock_tv_series_repository.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = TvSeries(
    id: 1,
    title: 'Test Title',
    overview: 'Test Overview',
    posterPath: '/test_poster.jpg',
    voteAverage: 8.0,
    genreIds: [1, 2, 3],
    firstAirDate: '2023-01-01',
    popularity: 8.0,
    voteCount: 100,
    backdropPath: '/test_backdrop.jpg',
    originalLanguage: 'en',
    originalName: 'Test Original Name',
    name: 'Test Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );

  test('should save tv series to watchlist', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlist(tTvSeries))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(tTvSeries);
    // assert
    expect(result, const Right('Added to Watchlist'));
  });
}
