import 'package:flutter_test/flutter_test.dart';

// Simple class to represent TV series detail for testing
class TvSeriesDetail {
  final int id;
  final String name;
  
  const TvSeriesDetail({
    required this.id,
    required this.name,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvSeriesDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

// Test events
abstract class TVSeriesDetailEvent {
  const TVSeriesDetailEvent();
  List<Object> get props => [];
}

class FetchTVSeriesDetail extends TVSeriesDetailEvent {
  final int id;
  const FetchTVSeriesDetail(this.id);
  
  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TVSeriesDetailEvent {
  final TvSeriesDetail tvSeries;
  const AddToWatchlist(this.tvSeries);
  
  @override
  List<Object> get props => [tvSeries];
}

class RemoveFromWatchlist extends TVSeriesDetailEvent {
  final TvSeriesDetail tvSeries;
  const RemoveFromWatchlist(this.tvSeries);
  
  @override
  List<Object> get props => [tvSeries];
}

class LoadWatchlistStatus extends TVSeriesDetailEvent {
  final int id;
  const LoadWatchlistStatus(this.id);
  
  @override
  List<Object> get props => [id];
}

class FetchSeasonDetail extends TVSeriesDetailEvent {
  final int tvSeriesId;
  final int seasonNumber;
  
  const FetchSeasonDetail({
    required this.tvSeriesId,
    required this.seasonNumber,
  });
  
  @override
  List<Object> get props => [tvSeriesId, seasonNumber];
}

class ClearWatchlistMessage extends TVSeriesDetailEvent {
  const ClearWatchlistMessage();
}

void main() {
  group('TVSeriesDetailEvent', () {
    group('FetchTVSeriesDetail', () {
      const tId = 1;
      const event = FetchTVSeriesDetail(tId);

      test('should have correct props', () {
        // assert
        expect(event.props, [tId]);
      });

      test('should be equal when same id', () {
        // arrange
        const event2 = FetchTVSeriesDetail(tId);
        
        // assert
        expect(event, event2);
        expect(event.props, event2.props);
        expect(event.hashCode, event2.hashCode);
      });
    });

    group('AddToWatchlist', () {
      const tTvSeries = TvSeriesDetail(
        id: 1,
        name: 'Test TV Series',
      );
      const event = AddToWatchlist(tTvSeries);

      test('should have correct props', () {
        // assert
        expect(event.props, [tTvSeries]);
      });

      test('should be equal when same tv series', () {
        // arrange
        const event2 = AddToWatchlist(tTvSeries);
        
        // assert
        expect(event, event2);
        expect(event.props, event2.props);
        expect(event.hashCode, event2.hashCode);
      });
    });

    group('RemoveFromWatchlist', () {
      const tTvSeries = TvSeriesDetail(
        id: 1,
        name: 'Test TV Series',
      );
      const event = RemoveFromWatchlist(tTvSeries);

      test('should have correct props', () {
        // assert
        expect(event.props, [tTvSeries]);
      });

      test('should be equal when same tv series', () {
        // arrange
        const event2 = RemoveFromWatchlist(tTvSeries);
        
        // assert
        expect(event, event2);
        expect(event.props, event2.props);
        expect(event.hashCode, event2.hashCode);
      });
    });

    group('LoadWatchlistStatus', () {
      const tId = 1;
      const event = LoadWatchlistStatus(tId);

      test('should have correct props', () {
        // assert
        expect(event.props, [tId]);
      });

      test('should be equal when same id', () {
        // arrange
        const event2 = LoadWatchlistStatus(tId);
        
        // assert
        expect(event, event2);
        expect(event.props, event2.props);
        expect(event.hashCode, event2.hashCode);
      });
    });

    group('FetchSeasonDetail', () {
      const tTvSeriesId = 1;
      const tSeasonNumber = 1;
      const event = FetchSeasonDetail(
        tvSeriesId: tTvSeriesId,
        seasonNumber: tSeasonNumber,
      );

      test('should have correct props', () {
        // assert
        expect(event.props, [tTvSeriesId, tSeasonNumber]);
      });

      test('should be equal when same parameters', () {
        // arrange
        const event2 = FetchSeasonDetail(
          tvSeriesId: tTvSeriesId,
          seasonNumber: tSeasonNumber,
        );
        
        // assert
        expect(event, event2);
        expect(event.props, event2.props);
        expect(event.hashCode, event2.hashCode);
      });
    });

    group('ClearWatchlistMessage', () {
      test('should have empty props', () {
        // arrange
        const event = ClearWatchlistMessage();
        
        // assert
        expect(event.props, []);
      });
    });
  });
}