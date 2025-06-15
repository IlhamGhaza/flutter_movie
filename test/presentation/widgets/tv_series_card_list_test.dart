import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';

class MockWatchlistTvSeriesNotifier extends Mock implements WatchlistTvSeriesNotifier {
  @override
  Future<bool> isAddedToWatchlist(int id) => super.noSuchMethod(
    Invocation.method(#isAddedToWatchlist, [id]),
    returnValue: Future.value(false),
    returnValueForMissingStub: Future.value(false),
  ) as Future<bool>;
}

void main() {
  final mockTvSeries = [
    TvSeries(
      id: 1,
      title: 'Test TV Series 1',
      overview: 'Overview 1',
      posterPath: '/path1.jpg',
      voteAverage: 8.0,
      genreIds: [1, 2],
      firstAirDate: '2022-01-01',
      popularity: 100.0,
      voteCount: 1000,
      backdropPath: '/path1.jpg',
      originalLanguage: 'en',
      originalName: 'Test TV Series 1',
      name: 'Test TV Series 1',
      numberOfEpisodes: 10,
      numberOfSeasons: 2,
    ),
    TvSeries(
      id: 2,
      title: 'Test TV Series 2',
      overview: 'Overview 2',
      posterPath: '/path2.jpg',
      voteAverage: 8.5,
      genreIds: [3, 4],
      firstAirDate: '2022-02-01',
      popularity: 200.0,
      voteCount: 2000,
      backdropPath: '/path2.jpg',
      originalLanguage: 'en',
      originalName: 'Test TV Series 2',
      name: 'Test TV Series 2',
      numberOfEpisodes: 12,
      numberOfSeasons: 3,
    ),
  ];

  testWidgets('should display list of tv series cards', (tester) async {
    final mockNotifier = MockWatchlistTvSeriesNotifier();
    
    // Setup mock responses for both TV series
    when(mockNotifier.isAddedToWatchlist(1)).thenAnswer((_) => Future.value(false));
    when(mockNotifier.isAddedToWatchlist(2)).thenAnswer((_) => Future.value(false));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WatchlistTvSeriesNotifier>.value(value: mockNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: TvSeriesCardList(tvSeries: mockTvSeries),
          ),
        ),
      ),
    );

    // Verify that the list is displayed
    expect(find.byType(ListView), findsOneWidget);
    
    // Verify that both TV series are displayed
    expect(find.text('Test TV Series 1'), findsOneWidget);
    expect(find.text('Test TV Series 2'), findsOneWidget);
    
    // Verify that the watchlist status is checked for each TV series
    verify(mockNotifier.isAddedToWatchlist(1)).called(1);
    verify(mockNotifier.isAddedToWatchlist(2)).called(1);
  });

  testWidgets('should show watchlist indicator when tv series is in watchlist', (tester) async {
    final mockNotifier = MockWatchlistTvSeriesNotifier();
    
    // Setup mock response for the first TV series
    when(mockNotifier.isAddedToWatchlist(1)).thenAnswer((_) => Future.value(true));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WatchlistTvSeriesNotifier>.value(value: mockNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: TvSeriesCardList(tvSeries: [mockTvSeries[0]]),
          ),
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const Scaffold(body: Center(child: Text('Detail Page'))),
            );
          },
        ),
      ),
    );

    // Wait for the FutureBuilder to complete
    await tester.pump(Duration.zero);
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the watchlist indicator is shown
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('should navigate to detail page when a tv series is tapped', (tester) async {
    final mockNotifier = MockWatchlistTvSeriesNotifier();
    final navigatorKey = GlobalKey<NavigatorState>();
    
    // Setup mock responses for the TV series
    when(mockNotifier.isAddedToWatchlist(1)).thenAnswer((_) => Future.value(false));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WatchlistTvSeriesNotifier>.value(value: mockNotifier),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: TvSeriesCardList(tvSeries: [mockTvSeries[0]]),
          ),
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => Scaffold(
                appBar: AppBar(),
                body: const Center(child: Text('Detail Page')),
              ),
            );
          },
        ),
      ),
    );

    // Wait for the FutureBuilder to complete
    await tester.pump(Duration.zero);
    await tester.pump(const Duration(milliseconds: 500));

    // Tap on the first TV series card
    await tester.tap(find.byType(InkWell).first);
    
    // Wait for navigation to complete
    await tester.pumpAndSettle();

    // Verify that the navigation occurred by checking for the detail page content
    expect(find.text('Detail Page'), findsOneWidget);
  });
}