import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> routes = [];
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routes.add(route);
  }
}

void main() {
  final testMovie = Movie(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  testWidgets('should show movie card with all elements', (WidgetTester tester) async {
    // Arrange
    final widget = _makeTestableWidget(MovieCard(testMovie));
    
    // Act
    await tester.pumpWidget(widget);
    await tester.pump();

    // Assert
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.text(testMovie.title!), findsOneWidget);
    expect(find.text(testMovie.overview!), findsOneWidget);
  });

  testWidgets('should navigate to movie detail when tapped', (WidgetTester tester) async {
    // Arrange
    final navigatorObserver = TestNavigatorObserver();
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(testMovie),
        ),
        navigatorObservers: [navigatorObserver],
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.ROUTE_NAME) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Movie Detail')),
                body: const Center(child: Text('Movie Detail Screen')),
              ),
              settings: settings,
            );
          }
          return null;
        },
      ),
    );

    // Act
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Movie Detail Screen'), findsOneWidget);
    expect(navigatorObserver.routes.last.settings.name, equals(MovieDetailPage.ROUTE_NAME));
  });

  testWidgets('should show loading indicator when image is loading', (WidgetTester tester) async {
    // Arrange
    final widget = _makeTestableWidget(MovieCard(testMovie));
    
    // Act
    await tester.pumpWidget(widget);
    
    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error icon when image fails to load', (WidgetTester tester) async {
    // Arrange
    final widget = _makeTestableWidget(MovieCard(testMovie));
    
    // Act
    await tester.pumpWidget(widget);
    
    // Simulate image load error
    final errorImage = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    final errorWidget = errorImage.errorWidget;
    
    // Assert
    expect(errorWidget, isNotNull);
    
    // Verify error widget shows error icon
    final element = tester.element(find.byType(MovieCard));
    final errorBuilder = errorWidget!(element, 'http://test.com', Exception('Failed to load image'));
    expect(errorBuilder, isA<Icon>());
    expect((errorBuilder as Icon).icon, Icons.error);
  });
}