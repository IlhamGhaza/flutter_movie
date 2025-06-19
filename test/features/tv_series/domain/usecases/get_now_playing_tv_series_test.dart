import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_now_playing_tv_series.dart';
import '../../../../helpers/test_helper.mocks.dart';

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

  group('GetNowPlayingTvSeries', () {
    test('should get list of tv series from the repository', () async {
      // arrange
      final expectedTvSeries = <TvSeries>[tTvSeries];
      when(mockTvSeriesRepository.getNowPlayingTvSeries())
          .thenAnswer((_) async => Right(expectedTvSeries));
      // act
      final result = await usecase.execute();
      // assert
      verify(mockTvSeriesRepository.getNowPlayingTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(expectedTvSeries));
      expect(resultList.length, 1);
    });

    test('should return empty list when repository returns empty list', () async {
      // arrange
      when(mockTvSeriesRepository.getNowPlayingTvSeries())
          .thenAnswer((_) async => const Right([]));
      // act
      final result = await usecase.execute();
      // assert
      verify(mockTvSeriesRepository.getNowPlayingTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, isEmpty);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      when(mockTvSeriesRepository.getNowPlayingTvSeries())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      final result = await usecase.execute();
      // assert
      verify(mockTvSeriesRepository.getNowPlayingTvSeries());
      expect(result, isA<Left>());
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });

    test('should return ConnectionFailure when no internet connection', () async {
      // arrange
      when(mockTvSeriesRepository.getNowPlayingTvSeries())
          .thenAnswer((_) async => Left(ConnectionFailure('No Internet')));
      // act
      final result = await usecase.execute();
      // assert
      verify(mockTvSeriesRepository.getNowPlayingTvSeries());
      expect(result, isA<Left>());
      expect(result.fold((l) => l, (r) => null), isA<ConnectionFailure>());
    });

    test('should verify the use case calls the repository exactly once', () async {
      // arrange
      when(mockTvSeriesRepository.getNowPlayingTvSeries())
          .thenAnswer((_) async => const Right([]));
      // act
      await usecase.execute();
      // assert
      verify(mockTvSeriesRepository.getNowPlayingTvSeries());
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });
  });
}
