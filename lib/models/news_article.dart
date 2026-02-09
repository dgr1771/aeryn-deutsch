import '../core/grammar_engine.dart';

/// 新闻文章模型
class NewsArticle {
  final String title;
  final String description;
  final String link;
  final DateTime pubDate;
  final String source;
  final LanguageLevel originalLevel;
  String? transformedText;
  LanguageLevel? targetLevel;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    required this.source,
    required this.originalLevel,
    this.transformedText,
    this.targetLevel,
  });

  /// 获取完整内容
  String get fullContent => title + '\n\n' + description;

  /// 是否已转换
  bool get isTransformed => transformedText != null;

  /// 获取当前显示文本
  String get displayText => transformedText ?? description;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      pubDate: DateTime.parse(json['pubDate'] ?? DateTime.now().toIso8601String()),
      source: json['source'] ?? 'DW',
      originalLevel: LanguageLevel.values.firstWhere(
        (e) => e.toString() == json['originalLevel'],
        orElse: () => LanguageLevel.B2,
      ),
      transformedText: json['transformedText'],
      targetLevel: json['targetLevel'] != null
          ? LanguageLevel.values.firstWhere(
              (e) => e.toString() == json['targetLevel'],
              orElse: () => LanguageLevel.B1,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'pubDate': pubDate.toIso8601String(),
      'source': source,
      'originalLevel': originalLevel.toString(),
      'transformedText': transformedText,
      'targetLevel': targetLevel?.toString(),
    };
  }

  NewsArticle copyWith({
    String? title,
    String? description,
    String? link,
    DateTime? pubDate,
    String? source,
    LanguageLevel? originalLevel,
    String? transformedText,
    LanguageLevel? targetLevel,
  }) {
    return NewsArticle(
      title: title ?? this.title,
      description: description ?? this.description,
      link: link ?? this.link,
      pubDate: pubDate ?? this.pubDate,
      source: source ?? this.source,
      originalLevel: originalLevel ?? this.originalLevel,
      transformedText: transformedText ?? this.transformedText,
      targetLevel: targetLevel ?? this.targetLevel,
    );
  }
}
