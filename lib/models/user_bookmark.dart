/// 用户收藏和笔记模型
library;

/// 收藏类型
enum BookmarkType {
  vocabulary,
  grammar,
  reading,
  question,
}

/// 收藏项
class Bookmark {
  final String id;
  final String userId;
  final BookmarkType type;
  final String itemId;          // 被收藏项的ID
  final String? title;          // 标题
  final String? description;    // 描述
  final DateTime createdAt;
  final List<Note>? notes;      // 笔记列表

  const Bookmark({
    required this.id,
    required this.userId,
    required this.type,
    required this.itemId,
    this.title,
    this.description,
    required this.createdAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'itemId': itemId,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes?.map((n) => n.toJson()).toList(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      userId: json['userId'],
      type: BookmarkType.values.firstWhere((e) => e.name == json['type']),
      itemId: json['itemId'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      notes: (json['notes'] as List<dynamic>?)
          ?.map((n) => Note.fromJson(n))
          .toList(),
    );
  }

  Bookmark copyWith({
    String? id,
    String? userId,
    BookmarkType? type,
    String? itemId,
    String? title,
    String? description,
    DateTime? createdAt,
    List<Note>? notes,
  }) {
    return Bookmark(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

/// 笔记
class Note {
  final String id;
  final String bookmarkId;     // 所属收藏ID
  final String content;        // 笔记内容
  final List<String>? tags;    // 标签
  final String? highlight;     // 高亮文本
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.bookmarkId,
    required this.content,
    this.tags,
    this.highlight,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookmarkId': bookmarkId,
      'content': content,
      'tags': tags,
      'highlight': highlight,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      bookmarkId: json['bookmarkId'],
      content: json['content'],
      tags: (json['tags'] as List<dynamic>)?.cast<String>(),
      highlight: json['highlight'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Note copyWith({
    String? id,
    String? bookmarkId,
    String? content,
    List<String>? tags,
    String? highlight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      bookmarkId: bookmarkId ?? this.bookmarkId,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      highlight: highlight ?? this.highlight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
