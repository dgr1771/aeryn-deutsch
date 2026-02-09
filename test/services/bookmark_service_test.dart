import 'package:flutter_test/flutter_test.dart';
import 'package:aeryn_deutsch/models/user_bookmark.dart';
import 'package:aeryn_deutsch/services/bookmark_service.dart';

void main() {
  group('Bookmark Service Tests', () {
    late BookmarkService bookmarkService;
    const testUserId = 'test_user_123';

    setUp(() async {
      bookmarkService = BookmarkService.instance;
      await bookmarkService.initialize();
      // Clear any existing data
      await bookmarkService.clearAll();
    });

    test('should add bookmark successfully', () async {
      // Act
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
        title: 'Haus',
        description: '房子',
      );

      // Assert
      expect(bookmark.id, isNotEmpty);
      expect(bookmark.userId, equals(testUserId));
      expect(bookmark.type, equals(BookmarkType.vocabulary));
      expect(bookmark.itemId, equals('word_123'));
    });

    test('should check if item is bookmarked', () async {
      // Arrange
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );

      // Act
      final isBookmarked = bookmarkService.isBookmarked(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );

      // Assert
      expect(isBookmarked, isTrue);
    });

    test('should return false for non-bookmarked item', () {
      // Act
      final isBookmarked = bookmarkService.isBookmarked(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'nonexistent',
      );

      // Assert
      expect(isBookmarked, isFalse);
    });

    test('should get user bookmarks', () async {
      // Arrange
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_1',
      );
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.grammar,
        itemId: 'grammar_1',
      );

      // Act
      final bookmarks = bookmarkService.getUserBookmarks(testUserId);

      // Assert
      expect(bookmarks.length, equals(2));
    });

    test('should get bookmarks by type', () async {
      // Arrange
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_1',
      );
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.grammar,
        itemId: 'grammar_1',
      );

      // Act
      final vocabBookmarks = bookmarkService.getBookmarksByType(
        userId: testUserId,
        type: BookmarkType.vocabulary,
      );

      // Assert
      expect(vocabBookmarks.length, equals(1));
      expect(vocabBookmarks.first.type, equals(BookmarkType.vocabulary));
    });

    test('should remove bookmark', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );

      // Act
      await bookmarkService.removeBookmark(bookmark.id);

      // Assert
      final isBookmarked = bookmarkService.isBookmarked(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      expect(isBookmarked, isFalse);
    });

    test('should add note to bookmark', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );

      // Act
      final note = await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: '这是一个重要的单词',
        tags: ['重要', '复习'],
      );

      // Assert
      expect(note.id, isNotEmpty);
      expect(note.bookmarkId, equals(bookmark.id));
      expect(note.content, equals('这是一个重要的单词'));
      expect(note.tags, equals(['重要', '复习']));
    });

    test('should get bookmark notes', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Note 1',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Note 2',
      );

      // Act
      final notes = bookmarkService.getBookmarkNotes(bookmark.id);

      // Assert
      expect(notes.length, equals(2));
    });

    test('should update note', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      final note = await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Original content',
      );

      // Act
      final updated = await bookmarkService.updateNote(
        noteId: note.id,
        content: 'Updated content',
      );

      // Assert
      expect(updated.content, equals('Updated content'));
      expect(updated.updatedAt.isAfter(note.updatedAt), isTrue);
    });

    test('should remove note', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      final note = await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Test note',
      );

      // Act
      await bookmarkService.removeNote(note.id);

      // Assert
      final notes = bookmarkService.getBookmarkNotes(bookmark.id);
      expect(notes, isEmpty);
    });

    test('should search notes by content', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: '重要单词需要记住',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: '普通单词',
      );

      // Act
      final results = bookmarkService.searchNotes('重要');

      // Assert
      expect(results, isNotEmpty);
      expect(results.first.content, contains('重要'));
    });

    test('should search notes by tag', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Note 1',
        tags: ['important', 'review'],
      );

      // Act
      final results = bookmarkService.searchNotesByTag('important');

      // Assert
      expect(results, isNotEmpty);
      expect(results.first.tags, contains('important'));
    });

    test('should get all tags', () async {
      // Arrange
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Note 1',
        tags: ['important', 'review'],
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Note 2',
        tags: ['test', 'review'],
      );

      // Act
      final tags = bookmarkService.getAllTags();

      // Assert
      expect(tags, contains('important'));
      expect(tags, contains('review'));
      expect(tags, contains('test'));
    });

    test('should calculate statistics', () async {
      // Arrange
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_1',
      );
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.grammar,
        itemId: 'grammar_1',
      );
      final bookmark = await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.reading,
        itemId: 'reading_1',
      );
      await bookmarkService.addNote(
        bookmarkId: bookmark.id,
        content: 'Note',
      );

      // Act
      final stats = bookmarkService.getStatistics(testUserId);

      // Assert
      expect(stats['totalBookmarks'], equals(3));
      expect(stats['vocabulary'], equals(1));
      expect(stats['grammar'], equals(1));
      expect(stats['reading'], equals(1));
      expect(stats['totalNotes'], equals(1));
    });

    test('should clear all data', () async {
      // Arrange
      await bookmarkService.addBookmark(
        userId: testUserId,
        type: BookmarkType.vocabulary,
        itemId: 'word_123',
      );

      // Act
      await bookmarkService.clearAll();

      // Assert
      final bookmarks = bookmarkService.getUserBookmarks(testUserId);
      expect(bookmarks, isEmpty);
    });
  });
}
