import 'package:ditonton/features/tv_series/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Action');
  const tGenreJson = {
    'id': 1,
    'name': 'Action',
  };

  group('GenreModel', () {
    test('should be a subclass of Equatable', () {
      expect(tGenreModel.props, [1, 'Action']);
    });

    test('should return a valid model from JSON', () {
      // Arrange
      final jsonMap = tGenreJson;
      
      // Act
      final result = GenreModel.fromJson(jsonMap);
      
      // Assert
      expect(result, tGenreModel);
    });

    test('should return a JSON map containing proper data', () {
      // Act
      final result = tGenreModel.toJson();
      
      // Assert
      final expectedMap = {
        'id': 1,
        'name': 'Action',
      };
      expect(result, expectedMap);
    });

    test('should return a valid entity from model', () {
      // Act
      final result = tGenreModel.toEntity();
      
      // Assert
      expect(result.id, 1);
      expect(result.name, 'Action');
    });

    test('should return true when comparing equal models', () {
      // Arrange
      const tGenreModel2 = GenreModel(id: 1, name: 'Action');
      
      // Act & Assert
      expect(tGenreModel == tGenreModel2, true);
    });

    test('should return false when comparing different models', () {
      // Arrange
      const tDifferentGenreModel = GenreModel(id: 2, name: 'Comedy');
      
      // Act & Assert
      expect(tGenreModel == tDifferentGenreModel, false);
    });
  });
}