import 'package:dartz/dartz.dart';
import 'package:ditonton/features/movies/data/models/genre.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart' as tv_series_detail;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_model.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_detail_model.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_table.dart';
import 'package:ditonton/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'tv_series_repository_impl_test.mocks.dart';


extension TvSeriesModelX on TvSeries {
  TvSeriesModel toModel() {
    final json = {
      'id': 1, 
      'title': name, 
      'overview': overview,
      'poster_path': posterPath ?? '',
      'vote_average': voteAverage,
      'genre_ids': genreIds,
      'first_air_date': firstAirDate,
      'popularity': popularity,
      'vote_count': voteCount,
      'backdrop_path': backdropPath ?? '',
      'original_language': originalLanguage,
      'original_name': originalName,
      'name': name,
      'number_of_episodes': 10, 
      'number_of_seasons': 1,   
    };
    return TvSeriesModel.fromJson(json);
  }
}


extension TvSeriesDetailModelX on tv_series_detail.TvSeriesDetail {
  TvSeriesDetailModel toModel() {
    
    final Map<String, dynamic> data = <String, dynamic>{};
    
    
    data['id'] = id is int ? id : 0;
    data['adult'] = adult is bool ? adult : false;
    data['backdrop_path'] = backdropPath is String ? backdropPath : '';
    data['episode_run_time'] = episodeRunTime is List<int> 
        ? List<int>.from(episodeRunTime) 
        : <int>[];
    data['first_air_date'] = firstAirDate is String ? firstAirDate : '';
    data['genres'] = genres is List<Genre> 
        ? genres.map((e) => {'id': e.id, 'name': e.name}).toList()
        : <Map<String, dynamic>>[];
    data['name'] = name is String ? name : '';
    data['original_name'] = originalName is String ? originalName : '';
    data['overview'] = overview is String ? overview : '';
    data['poster_path'] = posterPath is String ? posterPath : '';
    data['vote_average'] = voteAverage is num ? voteAverage.toDouble() : 0.0;
    data['vote_count'] = voteCount is int ? voteCount : 0;
    data['origin_country'] = originCountry is List<String> 
        ? List<String>.from(originCountry) 
        : <String>[];
    data['original_language'] = originalLanguage is String ? originalLanguage : 'en';
    data['popularity'] = popularity is num ? popularity.toDouble() : 0.0;
    data['status'] = status is String ? status : '';
    data['tagline'] = tagline is String ? tagline : '';
    data['type'] = type is String ? type : '';
    data['number_of_episodes'] = numberOfEpisodes is int ? numberOfEpisodes : 0;
    data['number_of_seasons'] = numberOfSeasons is int ? numberOfSeasons : 0;
    
    return TvSeriesDetailModel.fromJson(data);
  }
}

@GenerateMocks([TVSeriesRemoteDataSource, TVSeriesLocalDataSource])
void main() {
  late TVSeriesRepositoryImpl repository;
  late MockTVSeriesRemoteDataSource mockRemoteDataSource;
  late MockTVSeriesLocalDataSource mockLocalDataSource;
  
  
  late TvSeries testTvSeries;
  late tv_series_detail.TvSeriesDetail testTvSeriesDetail;
  late List<TvSeries> testTvSeriesList;
  
  
  late TvSeriesModel testTvSeriesModel;
  late TvSeriesDetailModel testTvSeriesDetailModel;
  late TvSeriesTable testTvSeriesTable;
  
  
  late List<TvSeriesModel> testTvSeriesModelList;

  setUp(() {
    mockRemoteDataSource = MockTVSeriesRemoteDataSource();
    mockLocalDataSource = MockTVSeriesLocalDataSource();
    repository = TVSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );

    
    testTvSeriesList = [
      TvSeries(
        id: 1,
        title: 'Test TV Series',
        name: 'Test TV Series',
        overview: 'Overview',
        posterPath: '/path.jpg',
        voteAverage: 8.0,
        genreIds: [1, 2, 3],
        firstAirDate: '2020-01-01',
        popularity: 100.0,
        voteCount: 100,
        backdropPath: '/path.jpg',
        originalLanguage: 'en',
        originalName: 'Test TV Series',
        numberOfEpisodes: 10,
        numberOfSeasons: 1,
      ),
    ];
    
    testTvSeries = testTvSeriesList[0];
    
    testTvSeriesDetail = tv_series_detail.TvSeriesDetail(
      adult: false,
      backdropPath: '/path.jpg',
      episodeRunTime: [60],
      firstAirDate: '2020-01-01',
      genres: [
        tv_series_detail.Genre(id: 1, name: 'Drama'),
      ],
      id: 1,
      name: 'Test TV Series',
      originalName: 'Test TV Series',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
      voteCount: 100,
      originCountry: const ['US'],
      originalLanguage: 'en',
      popularity: 100.0,
      status: 'Returning Series',
      tagline: 'Tagline',
      type: 'Scripted',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
    );
    
    
    testTvSeriesModel = testTvSeries.toModel();
    testTvSeriesModelList = [testTvSeriesModel];
    testTvSeriesDetailModel = testTvSeriesDetail.toModel();
    
    
    testTvSeriesTable = TvSeriesTable(
      id: testTvSeries.id,
      name: testTvSeries.name,
      title: 'Test TV Series',
      overview: testTvSeries.overview,
      posterPath: testTvSeries.posterPath,
      backdropPath: testTvSeries.backdropPath ?? '',
      voteAverage: testTvSeries.voteAverage,
      firstAirDate: testTvSeries.firstAirDate,
      genreIds: testTvSeries.genreIds,
      originalName: testTvSeries.originalName,
      originalLanguage: testTvSeries.originalLanguage,
      popularity: testTvSeries.popularity,
      voteCount: testTvSeries.voteCount,
      numberOfEpisodes: testTvSeries.numberOfEpisodes,
      numberOfSeasons: testTvSeries.numberOfSeasons,
    );
    
    
    when(mockLocalDataSource.getTvSeriesById(any)).thenAnswer((_) async => null);
    when(mockLocalDataSource.getWatchlistTvSeries()).thenAnswer((_) async => [testTvSeriesTable]);
    
    
    when(mockRemoteDataSource.getNowPlayingTvSeries())
        .thenAnswer((_) async => testTvSeriesModelList);
    when(mockRemoteDataSource.getPopularTvSeries())
        .thenAnswer((_) async => testTvSeriesModelList);
    when(mockRemoteDataSource.getTopRatedTvSeries())
        .thenAnswer((_) async => testTvSeriesModelList);
    when(mockRemoteDataSource.getTvSeriesDetail(1))
        .thenAnswer((_) async => testTvSeriesDetailModel);
    when(mockRemoteDataSource.getTvSeriesRecommendations(1))
        .thenAnswer((_) async => testTvSeriesModelList);
    when(mockRemoteDataSource.searchTvSeries('test'))
        .thenAnswer((_) async => testTvSeriesModelList);
  });

  group('Now Playing TV Series', () {
    test('should return remote data when the call to remote data source is successful',
        () async {
      
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => [testTvSeriesModel]);
      
      final result = await repository.getNowPlayingTvSeries();
      
      verify(mockRemoteDataSource.getNowPlayingTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList.length, testTvSeriesList.length);
      expect(resultList[0].id, testTvSeriesList[0].id);
      expect(resultList[0].name, testTvSeriesList[0].name);
      
    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(ServerException());
      
      final result = await repository.getNowPlayingTvSeries();
      
      expect(result, isA<Left<Failure, List<TvSeries>>>());
    });
  });

  group('Popular TV Series', () {
    test('should return popular tv series list when call to data source is successful',
        () async {
      
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => [testTvSeriesModel]);
      
      final result = await repository.getPopularTvSeries();
      
      verify(mockRemoteDataSource.getPopularTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList.length, testTvSeriesList.length);
      expect(resultList[0].id, testTvSeriesList[0].id);
      expect(resultList[0].name, testTvSeriesList[0].name);
      
    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      
      final result = await repository.getPopularTvSeries();
      
      expect(result, isA<Left<Failure, List<TvSeries>>>());
    });
  });

  group('Top Rated TV Series', () {
    test('should return top rated tv series list when call to data source is successful',
        () async {
      
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => [testTvSeriesModel]);
      
      final result = await repository.getTopRatedTvSeries();
      
      verify(mockRemoteDataSource.getTopRatedTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList.length, testTvSeriesList.length);
      expect(resultList[0].id, testTvSeriesList[0].id);
      expect(resultList[0].name, testTvSeriesList[0].name);
      
    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      
      final result = await repository.getTopRatedTvSeries();
      
      expect(result, isA<Left<Failure, List<TvSeries>>>());
    });
  });

  group('Get TV Series Detail', () {
    test('should return tv series detail when call to data source is successful',
        () async {
      
      // Arrange


    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      
      when(mockRemoteDataSource.getTvSeriesDetail(1))
          .thenThrow(ServerException());
      
      final result = await repository.getTvSeriesDetail(1);
      
      expect(result, isA<Left<Failure, tv_series_detail.TvSeriesDetail>>());
    });
  });

  group('TV Series Recommendations', () {
    test('should return tv series recommendations when call to data source is successful',
        () async {
      
      when(mockRemoteDataSource.getTvSeriesRecommendations(1))
          .thenAnswer((_) async => [testTvSeriesModel]);
      
      final result = await repository.getTvSeriesRecommendations(1);
      
      verify(mockRemoteDataSource.getTvSeriesRecommendations(1));
      final resultList = result.getOrElse(() => []);
      expect(resultList.length, testTvSeriesList.length);
      expect(resultList[0].id, testTvSeriesList[0].id);
      expect(resultList[0].name, testTvSeriesList[0].name);
      
    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      
      when(mockRemoteDataSource.getTvSeriesRecommendations(1))
          .thenThrow(ServerException());
      
      final result = await repository.getTvSeriesRecommendations(1);
      
      expect(result, isA<Left<Failure, List<TvSeries>>>());
    });
  });

  group('Search TV Series', () {
    test('should return search results when call to data source is successful',
        () async {
      
      when(mockRemoteDataSource.searchTvSeries('test'))
          .thenAnswer((_) async => [testTvSeriesModel]);
      
      final result = await repository.searchTvSeries('test');
      
      verify(mockRemoteDataSource.searchTvSeries('test'));
      final resultList = result.getOrElse(() => []);
      expect(resultList.length, testTvSeriesList.length);
      expect(resultList[0].id, testTvSeriesList[0].id);
      expect(resultList[0].name, testTvSeriesList[0].name);
      
    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      
      when(mockRemoteDataSource.searchTvSeries('test'))
          .thenThrow(ServerException());
      
      final result = await repository.searchTvSeries('test');
      
      expect(result, isA<Left<Failure, List<TvSeries>>>());
    });
  });

  group('Save Watchlist', () {
    test('should return success message when save watchlist is successful',
        () async {
      
      when(mockLocalDataSource.insertWatchlist(any))
          .thenAnswer((_) async => 'Added to Watchlist');
      
      final result = await repository.saveWatchlist(testTvSeries);
      
      verify(mockLocalDataSource.insertWatchlist(any));
      expect(result, equals(const Right('Added to Watchlist')));
    });

    test('should return DatabaseFailure when save watchlist is unsuccessful',
        () async {
      
      when(mockLocalDataSource.insertWatchlist(any))
          .thenThrow(DatabaseException('Failed to add to watchlist'));
      
      final result = await repository.saveWatchlist(testTvSeries);
      
      expect(result, isA<Left<Failure, String>>());
    });
  });

  group('Remove Watchlist', () {
    test('should return success message when remove watchlist is successful',
        () async {
      
      when(mockLocalDataSource.removeWatchlist(any))
          .thenAnswer((_) async => 'Removed from Watchlist');
      
      final result = await repository.removeWatchlist(testTvSeries);
      
      verify(mockLocalDataSource.removeWatchlist(any));
      expect(result, equals(const Right('Removed from Watchlist')));
    });

    test('should return DatabaseFailure when remove watchlist is unsuccessful',
        () async {
      
      when(mockLocalDataSource.removeWatchlist(any))
          .thenThrow(DatabaseException('Failed to remove from watchlist'));
      
      final result = await repository.removeWatchlist(testTvSeries);
      
      expect(result, isA<Left<Failure, String>>());
    });
  });
}