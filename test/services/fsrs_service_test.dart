import 'package:flutter_test/flutter_test.dart';
import 'package:aeryn_deutsch/models/word.dart';
import 'package:aeryn_deutsch/services/fsrs_service.dart';

void main() {
  group('FSRS Service Tests', () {
    late FSRSService fsrsService;

    setUp(() {
      fsrsService = FSRSService.instance;
    });

    test('should schedule word for next review', () {
      // Arrange
      final word = Word(
        word: 'Test',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '测试',
        frequency: 500,
        level: 'A1',
        category: 'Test',
      );

      // Act
      final scheduled = fsrsService.scheduleNextReview(word, quality: 3);

      // Assert
      expect(scheduled.nextReviewDate, isNotNull);
      expect(scheduled.nextReviewDate!.isAfter(DateTime.now()), isTrue);
      expect(scheduled.interval, greaterThan(0));
    });

    test('should increase interval after good reviews', () {
      // Arrange
      final word = Word(
        word: 'Test',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '测试',
        frequency: 500,
        level: 'A1',
        category: 'Test',
      );

      // Act - First review with quality 4
      var scheduled = fsrsService.scheduleNextReview(word, quality: 4);
      final firstInterval = scheduled.interval;

      // Second review with quality 4
      final updatedWord = word.copyWith(
        nextReviewDate: scheduled.nextReviewDate,
        interval: scheduled.interval,
        easeFactor: scheduled.easeFactor,
      );
      scheduled = fsrsService.scheduleNextReview(updatedWord, quality: 4);

      // Assert
      expect(scheduled.interval, greaterThan(firstInterval));
    });

    test('should decrease interval after bad reviews', () {
      // Arrange
      final word = Word(
        word: 'Test',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '测试',
        frequency: 500,
        level: 'A1',
        category: 'Test',
        interval: 10,
      );

      // Act
      final scheduled = fsrsService.scheduleNextReview(word, quality: 1);

      // Assert
      expect(scheduled.interval, lessThan(word.interval!));
    });

    test('should adjust ease factor based on quality', () {
      // Arrange
      final word = Word(
        word: 'Test',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '测试',
        frequency: 500,
        level: 'A1',
        category: 'Test',
        easeFactor: 2.5,
      );

      // Act
      final scheduled = fsrsService.scheduleNextReview(word, quality: 5);

      // Assert
      expect(scheduled.easeFactor, greaterThan(word.easeFactor!));
    });

    test('should return words due for review', () async {
      // Arrange
      final words = [
        Word(
          word: 'Due1',
          article: 'das',
          gender: GermanGender.neuter,
          meaning: '到期1',
          frequency: 500,
          level: 'A1',
          category: 'Test',
          nextReviewDate: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Word(
          word: 'Due2',
          article: 'das',
          gender: GermanGender.neuter,
          meaning: '到期2',
          frequency: 500,
          level: 'A1',
          category: 'Test',
          nextReviewDate: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        Word(
          word: 'Future',
          article: 'das',
          gender: GermanGender.neuter,
          meaning: '未来',
          frequency: 500,
          level: 'A1',
          category: 'Test',
          nextReviewDate: DateTime.now().add(const Duration(hours: 1)),
        ),
      ];

      // Act
      final dueWords = await fsrsService.getDueWords(words);

      // Assert
      expect(dueWords.length, equals(2));
      expect(dueWords[0].word, equals('Due1'));
      expect(dueWords[1].word, equals('Due2'));
    });

    test('should calculate correct next review date', () {
      // Arrange
      final word = Word(
        word: 'Test',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '测试',
        frequency: 500,
        level: 'A1',
        category: 'Test',
        interval: 1,
      );

      // Act
      final scheduled = fsrsService.scheduleNextReview(word, quality: 3);

      // Assert
      final expectedDate = DateTime.now().add(const Duration(days: 1));
      final diff = scheduled.nextReviewDate!.difference(expectedDate).inSeconds;
      expect(diff.abs(), lessThan(60)); // Within 1 minute
    });
  });
}
