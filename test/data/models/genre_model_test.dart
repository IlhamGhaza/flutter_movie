import 'package:ditonton/data/models/genre_model.dart';
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
      final Map<String, dynamic> jsonMap = tGenreJson;
      
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

    test('should return a Genre entity', () {
      // Act
      final result = tGenreModel.toEntity();
      
      // Assert
      expect(result.id, 1);
      expect(result.name, 'Action');
    });

    test('should have correct props', () {
      // Arrange
      const model1 = GenreModel(id: 1, name: 'Action');
      const model2 = GenreModel(id: 1, name: 'Action');
      const model3 = GenreModel(id: 2, name: 'Drama');
      
      // Assert
      expect(model1, model2);
      expect(model1.props, model2.props);
      expect(model1, isNot(equals(model3)));
      expect(model1.props, isNot(equals(model3.props)));
    });
  });
}