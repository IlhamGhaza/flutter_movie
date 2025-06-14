import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import '../../helpers/tv_series_repository_mocks.mocks.dart';

void main() {
  late GetNowPlayingTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetNowPlayingTvSeries(mockTvSeriesRepository);
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

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getNowPlayingTvSeries())
        .thenAnswer((_) async => Right(<TvSeries>[tTvSeries]));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(<TvSeries>[tTvSeries]));
  });
}
