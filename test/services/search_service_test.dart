import 'package:flutter_test/flutter_test.dart';
import 'package:aeryn_deutsch/services/search_service.dart';

void main() {
  group('Search Service Tests', () {
    late SearchService searchService;

    setUp(() {
      searchService = SearchService.instance;
    });

    test('should return empty list for empty query', () async {
      // Act
      final results = await searchService.search('');

      // Assert
      expect(results, isEmpty);
    });

    test('should search vocabulary by German word', () async {
      // Act
      final results = await searchService.search(
        'Haus',
        filter: const SearchFilter(
          types: [SearchResultType.vocabulary],
        ),
      );

      // Assert
      expect(results, isNotEmpty);
      expect(
        results.any((r) => r.type == SearchResultType.vocabulary),
        isTrue,
      );
    });

    test('should search vocabulary by Chinese meaning', () async {
      // Act
      final results = await searchService.search(
        '房子',
        filter: const SearchFilter(
          types: [SearchResultType.vocabulary],
        ),
      );

      // Assert
      expect(results, isNotEmpty);
      final vocabResults = results
          .where((r) => r.type == SearchResultType.vocabulary)
          .toList();
      expect(vocabResults, isNotEmpty);
    });

    test('should filter results by level', () async {
      // Act
      final results = await searchService.search(
        'Haus',
        filter: const SearchFilter(
          types: [SearchResultType.vocabulary],
          levels: [LanguageLevel.A1],
        ),
      );

      // Assert
      for (final result in results) {
        if (result.type == SearchResultType.vocabulary && result.data != null) {
          // Verify level filter is applied
          expect(result.data!['level'], equals('A1'));
        }
      }
    });

    test('should filter results by type', () async {
      // Act
      final results = await searchService.search(
        'Haus',
        filter: const SearchFilter(
          types: [SearchResultType.vocabulary],
        ),
      );

      // Assert
      for (final result in results) {
        expect(result.type, equals(SearchResultType.vocabulary));
      }
    });

    test('should return results sorted by relevance', () async {
      // Act
      final results = await searchService.search('Haus');

      // Assert
      if (results.length > 1) {
        for (int i = 0; i < results.length - 1; i++) {
          expect(
            results[i].relevance,
            greaterThanOrEqualTo(results[i + 1].relevance),
          );
        }
      }
    });

    test('should get search suggestions', () async {
      // Act
      final suggestions = await searchService.getSuggestions('Hau');

      // Assert
      expect(suggestions, isNotEmpty);
      expect(suggestions.every((s) => s.startsWith('Hau')), isTrue);
    });

    test('should get popular searches', () {
      // Act
      final popular = searchService.getPopularSearches();

      // Assert
      expect(popular, isNotEmpty);
      expect(popular.length, greaterThan(5));
    });

    test('should handle special characters in search', () async {
      // Act
      final results = await searchService.search('ä');

      // Assert - Should not throw
      expect(results, isA<List<SearchResult>>());
    });

    test('should search grammar topics', () async {
      // Act
      final results = await searchService.search(
        'verb',
        filter: const SearchFilter(
          types: [SearchResultType.grammar],
        ),
      );

      // Assert
      final grammarResults = results
          .where((r) => r.type == SearchResultType.grammar)
          .toList();
      expect(grammarResults, isNotEmpty);
    });

    test('should search reading materials', () async {
      // Act
      final results = await searchService.search(
        'Deutsch',
        filter: const SearchFilter(
          types: [SearchResultType.reading],
        ),
      );

      // Assert
      final readingResults = results
          .where((r) => r.type == SearchResultType.reading)
          .toList();
      expect(readingResults, isNotEmpty);
    });
  });
}
