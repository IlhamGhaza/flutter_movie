import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/features/tv_series/domain/entities/episode.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_season_detail.dart';
import 'package:ditonton/common/failure.dart';

// Import the generated mock
import '../../../../helpers/test_helper.mocks.dart';

// Run this command to generate mocks:
// flutter pub run build_runner build --delete-conflicting-outputs

// Helper function to create a SeasonDetail
SeasonDetail get tSeasonDetail => SeasonDetail(
      id: 1,
      name: 'Season 1',
      overview: 'Season 1 Overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
      episodeCount: 10,
      episodes: [
        Episode(
          id: 1,
          name: 'Episode 1',
          overview: 'Overview',
          episodeNumber: 1,
          seasonNumber: 1,
          voteAverage: 8.5,
          voteCount: 100,
        ),
      ],
      airDate: '2023-01-01',
    );

// Helper function to create a ServerFailure
ServerFailure get tFailure => ServerFailure('Server Failure');

void main() {
  late GetTvSeriesSeasonDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  const int tTvId = 1;
  const int tSeasonNumber = 1;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesSeasonDetail(mockTvSeriesRepository);
  });

  group('GetTvSeriesSeasonDetail', () {
    test('should get season detail from the repository', () async {
      // arrange
      when(mockTvSeriesRepository.getSeasonDetail(any, any))
          .thenAnswer((_) async => Right(tSeasonDetail));
      
      // act
      final result = await usecase.execute(tTvId, tSeasonNumber);
      
      // assert
      expect(result, equals(Right(tSeasonDetail)));
      verify(mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });

    test('should return a Failure when getting season detail fails', () async {
      // arrange
      when(mockTvSeriesRepository.getSeasonDetail(any, any))
          .thenAnswer((_) async => Left<Failure, SeasonDetail>(tFailure));
      
      // act
      final result = await usecase.execute(tTvId, tSeasonNumber);
      
      // assert
      expect(result, equals(Left(tFailure)));
      verify(mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });

    test('should pass the correct parameters to the repository', () async {
      // arrange
      when(mockTvSeriesRepository.getSeasonDetail(any, any))
          .thenAnswer((_) async => Right(tSeasonDetail));
      
      // act
      await usecase.execute(tTvId, tSeasonNumber);
      
      // assert
      verify(mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber));
    });

    test('should throw when repository throws an exception', () async {
      // arrange
      when(mockTvSeriesRepository.getSeasonDetail(any, any))
          .thenAnswer((_) async => throw Exception('Database Failure'));
      
      // act & assert
      expect(
        () => usecase.execute(tTvId, tSeasonNumber),
        throwsA(isA<Exception>()),
      );
      
      verify(mockTvSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });
  });
}