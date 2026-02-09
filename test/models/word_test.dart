import 'package:flutter_test/flutter_test.dart';
import 'package:aeryn_deutsch/models/word.dart';

void main() {
  group('Word Model Tests', () {
    test('Word.fromMap should create valid Word instance', () {
      // Arrange
      final map = {
        'word': 'Haus',
        'article': 'das',
        'gender': 'neuter',
        'meaning': '房子',
        'example': 'Das ist ein Haus.',
        'frequency': 500,
        'level': 'A1',
        'category': 'Wohnung',
      };

      // Act
      final word = Word.fromMap(map);

      // Assert
      expect(word.word, equals('Haus'));
      expect(word.article, equals('das'));
      expect(word.gender, equals(GermanGender.neuter));
      expect(word.meaning, equals('房子'));
      expect(word.example, equals('Das ist ein Haus.'));
      expect(word.frequency, equals(500));
      expect(word.level, equals('A1'));
      expect(word.category, equals('Wohnung'));
    });

    test('Word.toJson should serialize correctly', () {
      // Arrange
      final word = Word(
        word: 'Haus',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '房子',
        example: 'Das ist ein Haus.',
        frequency: 500,
        level: 'A1',
        category: 'Wohnung',
      );

      // Act
      final json = word.toJson();

      // Assert
      expect(json['word'], equals('Haus'));
      expect(json['article'], equals('das'));
      expect(json['gender'], equals('neuter'));
      expect(json['meaning'], equals('房子'));
      expect(json['example'], equals('Das ist ein Haus.'));
      expect(json['frequency'], equals(500));
      expect(json['level'], equals('A1'));
      expect(json['category'], equals('Wohnung'));
    });

    test('Word.fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'word': 'Haus',
        'article': 'das',
        'gender': 'neuter',
        'meaning': '房子',
        'example': 'Das ist ein Haus.',
        'frequency': 500,
        'level': 'A1',
        'category': 'Wohnung',
      };

      // Act
      final word = Word.fromJson(json);

      // Assert
      expect(word.word, equals('Haus'));
      expect(word.gender, equals(GermanGender.neuter));
    });

    test('Word.copyWith should create modified copy', () {
      // Arrange
      final word = Word(
        word: 'Haus',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '房子',
        frequency: 500,
        level: 'A1',
        category: 'Wohnung',
      );

      // Act
      final modified = word.copyWith(meaning: '房屋');

      // Assert
      expect(modified.word, equals(word.word));
      expect(modified.meaning, equals('房屋'));
      expect(modified.gender, equals(word.gender));
    });

    test('GermanGender enum should have correct values', () {
      // Assert
      expect(GermanGender.masculine, isNotNull);
      expect(GermanGender.feminine, isNotNull);
      expect(GermanGender.neuter, isNotNull);
      expect(GermanGender.none, isNotNull);
    });
  });
}
