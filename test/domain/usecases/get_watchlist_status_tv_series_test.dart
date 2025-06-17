import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTvSeriesRepository extends Mock implements TvSeriesRepository {
  @override
  Future<bool> isAddedToWatchlist(int id) async =>
      super.noSuchMethod(
        Invocation.method(#isAddedToWatchlist, [id]),
        returnValue: Future.value(false),
        returnValueForMissingStub: Future.value(false),
      ) as Future<bool>;
}

void main() {
  late GetWatchListStatusTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchListStatusTvSeries(mockTvSeriesRepository);
  });

  const tId = 1;
  const tDifferentId = 2;

  group('GetWatchListStatusTvSeries', () {
    test('should get watchlist status (true) from the repository', () async {
      // arrange
      when(mockTvSeriesRepository.isAddedToWatchlist(tId))
          .thenAnswer((_) async => true);
      
      // act
      final result = await usecase.execute(tId);
      
      // assert
      expect(result, true);
      verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });

    test('should get watchlist status (false) when tv series is not in watchlist', 
      () async {
        // arrange
        when(mockTvSeriesRepository.isAddedToWatchlist(tId))
            .thenAnswer((_) async => false);
        
        // act
        final result = await usecase.execute(tId);
        
        // assert
        expect(result, false);
        verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
        verifyNoMoreInteractions(mockTvSeriesRepository);
      });

    test('should call repository with correct id', () async {
      // arrange
      when(mockTvSeriesRepository.isAddedToWatchlist(tId))
          .thenAnswer((_) async => true);
      
      // act
      await usecase.execute(tId);
      
      // assert
      verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });

    test('should verify the interaction with repository', () async {
      // arrange
      when(mockTvSeriesRepository.isAddedToWatchlist(tId))
          .thenAnswer((_) async => true);
      
      // act
      final result = await usecase.execute(tId);
      
      // assert
      expect(result, true);
      verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });

    test('should throw exception when repository throws an error', () async {
      // arrange
      when(mockTvSeriesRepository.isAddedToWatchlist(tId))
          .thenThrow(Exception('Database Error'));
      
      // act & assert
      expect(
        () => usecase.execute(tId),
        throwsA(isA<Exception>()),
      );
      verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });

    test('should handle different IDs correctly', () async {
      // arrange
      when(mockTvSeriesRepository.isAddedToWatchlist(tDifferentId))
          .thenAnswer((_) async => true);
      
      // act
      final result = await usecase.execute(tDifferentId);
      
      // assert
      expect(result, true);
      verify(mockTvSeriesRepository.isAddedToWatchlist(tDifferentId));
      verifyNoMoreInteractions(mockTvSeriesRepository);
    });
  });
}
