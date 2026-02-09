import '../core/grammar_engine.dart';

/// 单词模型 - C2级别需要10000+词汇
class Word {
  final String id;
  final String word;
  final String? article; // der/die/das
  final GermanGender gender;
  final String meaning;
  final String? exampleSentence;
  final String? rootWord; // 词根（用于词簇映射）
  final LanguageLevel level;
  final DateTime createdAt;
  DateTime? nextReview;
  int reviewCount;
  double easeFactor;
  int interval;

  // 词汇扩展字段
  final int frequency;                  // 词频
  final String? category;               // 类别
  final List<String>? tags;             // 标签

  // C2扩展字段
  final List<String>? synonyms;        // 同义词
  final List<String>? antonyms;        // 反义词
  final List<String>? collocations;    // 搭配
  final String? etymology;             // 词源
  final int? frequencyRank;            // 词频排名

  Word({
    required this.id,
    required this.word,
    this.article,
    required this.gender,
    required this.meaning,
    this.exampleSentence,
    this.rootWord,
    required this.level,
    required this.createdAt,
    required this.frequency,
    this.category,
    this.tags,
    this.nextReview,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
    this.interval = 0,
    this.synonyms,
    this.antonyms,
    this.collocations,
    this.etymology,
    this.frequencyRank,
  });

  /// 从Map创建Word对象（用于词汇库）
  factory Word.fromMap(Map<String, dynamic> map) {
    // 解析level字符串为LanguageLevel枚举
    LanguageLevel parseLevel(String levelStr) {
      switch (levelStr.toUpperCase()) {
        case 'A1':
          return LanguageLevel.A1;
        case 'A2':
          return LanguageLevel.A2;
        case 'B1':
          return LanguageLevel.B1;
        case 'B2':
          return LanguageLevel.B2;
        case 'C1':
          return LanguageLevel.C1;
        case 'C2':
          return LanguageLevel.C2;
        default:
          return LanguageLevel.B1; // 默认值
      }
    }

    // 解析gender字符串为GermanGender枚举
    GermanGender parseGender(dynamic gender) {
      if (gender is GermanGender) return gender;
      if (gender == null) return GermanGender.none;

      switch (gender.toString().toLowerCase()) {
        case 'der':
        case 'masculine':
          return GermanGender.der;
        case 'die':
        case 'feminine':
          return GermanGender.die;
        case 'das':
        case 'neuter':
          return GermanGender.das;
        default:
          return GermanGender.none;
      }
    }

    return Word(
      id: map['word'] ?? map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      word: map['word'] ?? '',
      article: map['article'],
      gender: parseGender(map['gender']),
      meaning: map['meaning'] ?? '',
      exampleSentence: map['example'],
      rootWord: map['rootWord'],
      level: parseLevel(map['level'] ?? 'B1'),
      createdAt: DateTime.now(),
      frequency: map['frequency'] ?? 5000,
      category: map['category'],
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      reviewCount: 0,
      easeFactor: 2.5,
      interval: 0,
    );
  }

  /// 转换为Map（用于序列化）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'article': article,
      'gender': gender,
      'meaning': meaning,
      'exampleSentence': exampleSentence,
      'rootWord': rootWord,
      'level': level.name,
      'createdAt': createdAt.toIso8601String(),
      'frequency': frequency,
      'category': category,
      'tags': tags,
      'nextReview': nextReview?.toIso8601String(),
      'reviewCount': reviewCount,
      'easeFactor': easeFactor,
      'interval': interval,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'collocations': collocations,
      'etymology': etymology,
      'frequencyRank': frequencyRank,
    };
  }

  /// 是否需要复习
  bool get needsReview {
    if (nextReview == null) return true;
    return DateTime.now().isAfter(nextReview!);
  }
}
