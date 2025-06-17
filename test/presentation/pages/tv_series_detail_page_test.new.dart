import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailNotifier])
void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
    
    // Setup default mock responses
    when(mockNotifier.detailState).thenReturn(RequestState.Empty);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Empty);
    when(mockNotifier.tvSeriesDetail).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendations).thenReturn([testTvSeries]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.message).thenReturn('');
    when(mockNotifier.recommendationsMessage).thenReturn('');
    when(mockNotifier.watchlistMessage).thenReturn('');
  });

  // Helper widget to wrap the page with necessary providers
  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == TvSeriesDetailPage.ROUTE_NAME) {
            final id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => TvSeriesDetailPage(id: id),
              settings: settings,
            );
          }
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Route not found')),
          );
        },
      ),
    );
  }

  testWidgets('Page should display loading when state is loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockNotifier.detailState).thenReturn(RequestState.Loading);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Loading);

    // Act
    await tester.pumpWidget(makeTestableWidget(
      const TvSeriesDetailPage(id: 1),
    ));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(mockNotifier.fetchTvSeriesDetail(1));
    // verify(mockNotifier.fetchTvSeriesRecommendations(1));
  });

  testWidgets('Page should display add to watchlist button when not added',
      (WidgetTester tester) async {
    // Arrange
    when(mockNotifier.detailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesDetail).thenReturn(testTvSeriesDetail);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    // Act
    await tester.pumpWidget(makeTestableWidget(
      const TvSeriesDetailPage(id: 1),
    ));
    await tester.pump();

    // Assert
    expect(find.text('Add to Watchlist'), findsOneWidget);
  });

  testWidgets('Page should show check icon when added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(mockNotifier.detailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesDetail).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendations).thenReturn([testTvSeries]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    // Act
    await tester.pumpWidget(makeTestableWidget(
      const TvSeriesDetailPage(id: 1),
    ));
    await tester.pump();

    // Assert
    expect(find.text('Added to Watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Should show recommendations when loaded',
      (WidgetTester tester) async {
    // Arrange
    when(mockNotifier.detailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesDetail).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendations).thenReturn([testTvSeries]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    // Act
    await tester.pumpWidget(makeTestableWidget(
      const TvSeriesDetailPage(id: 1),
    ));
    await tester.pump();

    // Assert
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('Should show error message when recommendations error',
      (WidgetTester tester) async {
    // Arrange
    when(mockNotifier.detailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Error);
    when(mockNotifier.tvSeriesDetail).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationsMessage).thenReturn('Error message');
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    // Act
    await tester.pumpWidget(makeTestableWidget(
      const TvSeriesDetailPage(id: 1),
    ));
    await tester.pump();

    // Assert
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Should show empty message when no recommendations',
      (WidgetTester tester) async {
    // Arrange
    when(mockNotifier.detailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesDetail).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendations).thenReturn([]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    // Act
    await tester.pumpWidget(makeTestableWidget(
      const TvSeriesDetailPage(id: 1),
    ));
    await tester.pump();

    // Assert
    expect(find.text('No recommendations available'), findsOneWidget);
  });
}
