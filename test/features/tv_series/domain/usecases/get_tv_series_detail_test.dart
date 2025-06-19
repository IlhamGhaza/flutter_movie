import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'get_tv_series_detail_test.mocks.dart';

@GenerateMocks([TvSeriesRepository])
void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  final tId = 1;
  final tTvSeriesDetail = testTvSeriesDetail;

  test('should get tv series detail from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => Right(tTvSeriesDetail));
    
    // act
    final result = await usecase.execute(tId);
    
    // assert
    expect(result, equals(Right(tTvSeriesDetail)));
    verify(mockTvSeriesRepository.getTvSeriesDetail(tId));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });

  test('should return ServerFailure when repository call is unsuccessful', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    
    // act
    final result = await usecase.execute(tId);
    
    // assert
    expect(result, equals(Left(ServerFailure('Server Failure'))));
    verify(mockTvSeriesRepository.getTvSeriesDetail(tId));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });

  test('should return ConnectionFailure when device is offline', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => Left(ConnectionFailure('Failed to connect to the network')));
    
    // act
    final result = await usecase.execute(tId);
    
    // assert
    expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    verify(mockTvSeriesRepository.getTvSeriesDetail(tId));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
} 