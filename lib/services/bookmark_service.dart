/// 收藏和笔记服务
library;

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_bookmark.dart';

/// 收藏和笔记服务
class BookmarkService {
  // 单例模式
  BookmarkService._private();
  static final BookmarkService instance = BookmarkService._private();

  final Uuid _uuid = const Uuid();

  // SharedPreferences keys
  static const String _keyBookmarks = 'bookmarks';
  static const String _keyNotes = 'notes';

  List<Bookmark> _bookmarks = [];
  List<Note> _notes = [];

  /// 初始化
  Future<void> initialize() async {
    await _loadBookmarks();
    await _loadNotes();
  }

  /// 加载收藏列表
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString(_keyBookmarks);
    if (bookmarksJson != null && bookmarksJson.isNotEmpty) {
      // TODO: 解析JSON
      // _bookmarks = ...
    }
  }

  /// 加载笔记列表
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString(_keyNotes);
    if (notesJson != null && notesJson.isNotEmpty) {
      // TODO: 解析JSON
      // _notes = ...
    }
  }

  /// 保存收藏列表
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: 序列化为JSON
    // final json = jsonEncode(_bookmarks.map((b) => b.toJson()).toList());
    // await prefs.setString(_keyBookmarks, json);
  }

  /// 保存笔记列表
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: 序列化为JSON
    // final json = jsonEncode(_notes.map((n) => n.toJson()).toList());
    // await prefs.setString(_keyNotes, json);
  }

  /// 添加收藏
  Future<Bookmark> addBookmark({
    required String userId,
    required BookmarkType type,
    required String itemId,
    String? title,
    String? description,
  }) async {
    final bookmark = Bookmark(
      id: _uuid.v4(),
      userId: userId,
      type: type,
      itemId: itemId,
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    _bookmarks.add(bookmark);
    await _saveBookmarks();

    return bookmark;
  }

  /// 移除收藏
  Future<void> removeBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((b) => b.id == bookmarkId);
    await _saveBookmarks();

    // 同时删除相关笔记
    _notes.removeWhere((n) => n.bookmarkId == bookmarkId);
    await _saveNotes();
  }

  /// 检查是否已收藏
  bool isBookmarked({
    required String userId,
    required BookmarkType type,
    required String itemId,
  }) {
    return _bookmarks.any(
      (b) => b.userId == userId && b.type == type && b.itemId == itemId,
    );
  }

  /// 获取用户的所有收藏
  List<Bookmark> getUserBookmarks(String userId) {
    return _bookmarks.where((b) => b.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 按类型获取收藏
  List<Bookmark> getBookmarksByType({
    required String userId,
    required BookmarkType type,
  }) {
    return _bookmarks
        .where((b) => b.userId == userId && b.type == type)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 添加笔记
  Future<Note> addNote({
    required String bookmarkId,
    required String content,
    List<String>? tags,
    String? highlight,
  }) async {
    final note = Note(
      id: _uuid.v4(),
      bookmarkId: bookmarkId,
      content: content,
      tags: tags,
      highlight: highlight,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _notes.add(note);

    // 更新收藏的笔记列表
    final bookmarkIndex = _bookmarks.indexWhere((b) => b.id == bookmarkId);
    if (bookmarkIndex != -1) {
      final bookmark = _bookmarks[bookmarkIndex];
      final notes = bookmark.notes ?? [];
      _bookmarks[bookmarkIndex] = bookmark.copyWith(
        notes: [...notes, note],
      );
    }

    await _saveNotes();
    await _saveBookmarks();

    return note;
  }

  /// 更新笔记
  Future<Note> updateNote({
    required String noteId,
    String? content,
    List<String>? tags,
    String? highlight,
  }) async {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index == -1) {
      throw Exception('Note not found');
    }

    final updatedNote = _notes[index].copyWith(
      content: content,
      tags: tags,
      highlight: highlight,
      updatedAt: DateTime.now(),
    );

    _notes[index] = updatedNote;
    await _saveNotes();

    return updatedNote;
  }

  /// 删除笔记
  Future<void> removeNote(String noteId) async {
    final note = _notes.firstWhere(
      (n) => n.id == noteId,
      orElse: () => throw Exception('Note not found'),
    );

    _notes.removeWhere((n) => n.id == noteId);

    // 从收藏中移除该笔记
    final bookmarkIndex = _bookmarks.indexWhere((b) => b.id == note.bookmarkId);
    if (bookmarkIndex != -1) {
      final bookmark = _bookmarks[bookmarkIndex];
      final notes = bookmark.notes?.where((n) => n.id != noteId).toList();
      _bookmarks[bookmarkIndex] = bookmark.copyWith(notes: notes);
    }

    await _saveNotes();
    await _saveBookmarks();
  }

  /// 获取收藏的所有笔记
  List<Note> getBookmarkNotes(String bookmarkId) {
    return _notes.where((n) => n.bookmarkId == bookmarkId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 按标签搜索笔记
  List<Note> searchNotesByTag(String tag) {
    return _notes
        .where((n) => n.tags?.contains(tag) ?? false)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 搜索笔记内容
  List<Note> searchNotes(String query) {
    final lowerQuery = query.toLowerCase();
    return _notes
        .where((n) =>
            n.content.toLowerCase().contains(lowerQuery) ||
            (n.highlight?.toLowerCase().contains(lowerQuery) ?? false))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 获取所有标签
  List<String> getAllTags() {
    final tags = <String>{};
    for (final note in _notes) {
      if (note.tags != null) {
        tags.addAll(note.tags!);
      }
    }
    return tags.toList()..sort();
  }

  /// 清除所有数据
  Future<void> clearAll() async {
    _bookmarks.clear();
    _notes.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBookmarks);
    await prefs.remove(_keyNotes);
  }

  /// 获取统计信息
  Map<String, int> getStatistics(String userId) {
    final userBookmarks = getUserBookmarks(userId);

    final vocabCount = userBookmarks
        .where((b) => b.type == BookmarkType.vocabulary)
        .length;
    final grammarCount = userBookmarks
        .where((b) => b.type == BookmarkType.grammar)
        .length;
    final readingCount = userBookmarks
        .where((b) => b.type == BookmarkType.reading)
        .length;
    final questionCount = userBookmarks
        .where((b) => b.type == BookmarkType.question)
        .length;

    final totalNotes = _notes.length;

    return {
      'totalBookmarks': userBookmarks.length,
      'vocabulary': vocabCount,
      'grammar': grammarCount,
      'reading': readingCount,
      'question': questionCount,
      'totalNotes': totalNotes,
    };
  }
}
