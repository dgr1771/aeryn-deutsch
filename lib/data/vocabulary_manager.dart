/// 词汇管理器
///
/// 统一管理所有词汇数据，提供高效的词汇查询和统计功能
library;

import 'vocabulary.dart';
import 'vocabulary_extended.dart';
import 'vocabulary_b2_expanded.dart';
import 'vocabulary_expanded.dart';
import 'vocabulary_massive.dart';
import 'vocabulary_massive_2.dart';
import 'vocabulary_massive_3.dart';
import 'vocabulary_massive_4.dart';
import 'vocabulary_massive_5.dart';
import '../models/word.dart';
import '../core/grammar_engine.dart';

/// 词汇管理器
class VocabularyManager {
  static VocabularyManager? _instance;
  List<Word>? _allVocabulary;
  Map<String, Word>? _wordIndex;
  Map<LanguageLevel, List<Word>>? _wordsByLevel;
  int? _totalCount;

  VocabularyManager._internal();

  /// 获取单例
  static VocabularyManager get instance {
    _instance ??= VocabularyManager._internal();
    return _instance!;
  }

  /// 初始化词汇库
  Future<void> initialize() async {
    if (_allVocabulary != null) return;

    // 合并所有词汇数据源 - 处理不同类型的数据
    final allWords = <Word>[];

    // 添加原始词汇 (VocabularyEntry类型)
    for (final entry in [...vocabularyA1, ...vocabularyA2, ...vocabularyB1, ...vocabularyB2]) {
      allWords.add(_entryToWord(entry));
    }

    // 添加扩展词汇 (Map类型)
    for (final map in [
      ...vocabularyA1Extended,
      ...vocabularyA2Extended,
      ...vocabularyB1Extended,
      ...vocabularyB2Extended,
      ...vocabularyC1Extended,
      ...vocabularyC2Extended,
    ]) {
      allWords.add(Word.fromMap(map));
    }

    // 添加其他词汇源 (Map类型)
    for (final map in [
      ...vocabularyB2Expanded,
      ...vocabularyExtendedC2,
      ...vocabularyMassive,
      ...vocabularyMassive2,
      ...vocabularyMassive3,
      ...vocabularyMassive4,
      ...vocabularyMassive5,
    ]) {
      allWords.add(Word.fromMap(map));
    }

    _allVocabulary = allWords;

    // 构建索引
    _wordIndex = {};
    for (final word in _allVocabulary!) {
      _wordIndex![word.word] = word;
    }

    // 按级别分组
    _wordsByLevel = {};
    for (final level in LanguageLevel.values) {
      _wordsByLevel![level] = _allVocabulary!
          .where((w) => w.level == level)
          .toList();
    }

    _totalCount = _allVocabulary!.length;
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (_allVocabulary == null) {
      await initialize();
    }
  }

  /// 获取所有词汇
  Future<List<Word>> getAllVocabulary() async {
    await _ensureInitialized();
    return List.unmodifiable(_allVocabulary!);
  }

  /// 根据单词查找
  Future<Word?> getWord(String word) async {
    await _ensureInitialized();
    return _wordIndex![word];
  }

  /// 根据级别获取词汇
  Future<List<Word>> getWordsByLevel(LanguageLevel level) async {
    await _ensureInitialized();
    return List.unmodifiable(_wordsByLevel![level]!);
  }

  /// 获取词汇总数
  Future<int> get totalCount async {
    await _ensureInitialized();
    return _totalCount!;
  }

  /// 获取词汇统计
  Future<Map<String, dynamic>> getStatistics() async {
    await _ensureInitialized();

    final stats = <String, int>{};
    for (final level in LanguageLevel.values) {
      stats[level.name] = _wordsByLevel![level]!.length;
    }
    stats['total'] = _totalCount!;

    return {
      'byLevel': stats,
      'total': _totalCount,
      'averageFrequency': _allVocabulary!
          .map((w) => w.frequency)
          .reduce((a, b) => a + b) / _totalCount!,
    };
  }

  /// 搜索词汇
  Future<List<Word>> searchWords({
    String? query,
    LanguageLevel? level,
    String? category,
    int? minFrequency,
    int? maxFrequency,
    int limit = 100,
  }) async {
    await _ensureInitialized();

    var results = _allVocabulary!;

    // 按查询词过滤
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results.where((w) =>
        w.word.toLowerCase().contains(lowerQuery) ||
        w.meaning.contains(query)
      ).toList();
    }

    // 按级别过滤
    if (level != null) {
      results = results.where((w) => w.level == level).toList();
    }

    // 按类别过滤
    if (category != null && category.isNotEmpty) {
      results = results.where((w) =>
        w.category == category ||
        (w.tags != null && w.tags!.contains(category))
      ).toList();
    }

    // 按频率过滤
    if (minFrequency != null) {
      results = results.where((w) => w.frequency >= minFrequency).toList();
    }
    if (maxFrequency != null) {
      results = results.where((w) => w.frequency <= maxFrequency).toList();
    }

    // 限制结果数量
    return results.take(limit).toList();
  }

  /// 获取随机词汇
  Future<List<Word>> getRandomWords({
    int count = 10,
    LanguageLevel? level,
    int? maxFrequency,
  }) async {
    await _ensureInitialized();

    var pool = _allVocabulary!;

    if (level != null) {
      pool = pool.where((w) => w.level == level).toList();
    }

    if (maxFrequency != null) {
      pool = pool.where((w) => w.frequency <= maxFrequency).toList();
    }

    // 随机打乱
    pool.shuffle();

    return pool.take(count).toList();
  }

  /// 获取高频词
  Future<List<Word>> getHighFrequencyWords({
    int count = 100,
    LanguageLevel? level,
  }) async {
    await _ensureInitialized();

    var results = _allVocabulary!;

    if (level != null) {
      results = results.where((w) => w.level == level).toList();
    }

    // 按频率排序（低频率=高频）
    results.sort((a, b) => a.frequency.compareTo(b.frequency));

    return results.take(count).toList();
  }

  /// 获取低频词（生僻词）
  Future<List<Word>> getLowFrequencyWords({
    int count = 100,
    LanguageLevel? level,
  }) async {
    await _ensureInitialized();

    var results = _allVocabulary!;

    if (level != null) {
      results = results.where((w) => w.level == level).toList();
    }

    // 按频率排序（高频率=低频）
    results.sort((a, b) => b.frequency.compareTo(a.frequency));

    return results.take(count).toList();
  }

  /// 根据频率获取词汇
  Future<List<Word>> getWordsByFrequencyRange({
    required int minFreq,
    required int maxFreq,
    LanguageLevel? level,
  }) async {
    await _ensureInitialized();

    var results = _allVocabulary!;

    if (level != null) {
      results = results.where((w) => w.level == level).toList();
    }

    results = results.where((w) =>
      w.frequency >= minFreq && w.frequency <= maxFreq
    ).toList();

    return results;
  }

  /// 导出词汇数据
  Future<Map<String, dynamic>> exportVocabulary({
    LanguageLevel? level,
    String format = 'json',
  }) async {
    await _ensureInitialized();

    var words = _allVocabulary!;

    if (level != null) {
      words = words.where((w) => w.level == level).toList();
    }

    return {
      'format': format,
      'count': words.length,
      'words': words.map((w) => w.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// 获取学习建议
  Future<Map<String, dynamic>> getStudyRecommendations(
    LanguageLevel currentLevel,
    Set<String> knownWords,
  ) async {
    await _ensureInitialized();

    // 获取当前级别的词汇
    final levelWords = await getWordsByLevel(currentLevel);
    final unknownWords = levelWords
        .where((w) => !knownWords.contains(w.word))
        .toList();

    // 计算掌握度
    final knownCount = levelWords.length - unknownWords.length;
    final masteryRate = knownCount / levelWords.length;

    // 推荐策略
    String recommendation;
    int recommendedCount;

    if (masteryRate < 0.5) {
      recommendation = 'focus_on_current_level';
      recommendedCount = 20;
    } else if (masteryRate < 0.8) {
      recommendation = 'review_and_advance';
      recommendedCount = 15;
    } else {
      recommendation = 'advance_to_next_level';
      recommendedCount = 20;
    }

    return {
      'currentLevel': currentLevel.name,
      'totalWords': levelWords.length,
      'knownWords': knownCount,
      'unknownWords': unknownWords.length,
      'masteryRate': masteryRate,
      'recommendation': recommendation,
      'recommendedCount': recommendedCount,
      'suggestedWords': unknownWords.take(recommendedCount).map((w) => w.word).toList(),
    };
  }

  /// 获取每日词汇建议
  Future<List<Word>> getDailyWords({
    required LanguageLevel userLevel,
    required Set<String> knownWords,
    int count = 20,
  }) async {
    await _ensureInitialized();

    final recommendations = await getStudyRecommendations(userLevel, knownWords);
    final suggestedWords = recommendations['suggestedWords'] as List<String>;

    // 获取词汇对象
    final words = <Word>[];
    for (final word in suggestedWords) {
      final w = await getWord(word);
      if (w != null) {
        words.add(w);
      }
    }

    // 如果不够，从下一级别补充
    if (words.length < count) {
      final nextLevelIndex = userLevel.index + 1;
      if (nextLevelIndex < LanguageLevel.values.length) {
        final nextLevel = LanguageLevel.values[nextLevelIndex];
        final additionalWords = await getRandomWords(
          count: count - words.length,
          level: nextLevel,
          maxFrequency: 5000,
        );
        words.addAll(additionalWords);
      }
    }

    return words.take(count).toList();
  }

  /// 将VocabularyEntry转换为Word对象
  Word _entryToWord(VocabularyEntry entry) {
    return Word(
      id: entry.word,
      word: entry.word,
      article: entry.article,
      gender: entry.gender,
      meaning: entry.meaning,
      exampleSentence: entry.example,
      rootWord: entry.etymology,
      level: entry.level,
      createdAt: DateTime.now(),
      frequency: entry.frequency ?? 5000,
      category: null,
      tags: entry.collocations,
    );
  }


/// 词汇统计信息
}
class VocabularyStatistics {
  final Map<String, int> byLevel;
  final int total;
  final double averageFrequency;

  VocabularyStatistics({
    required this.byLevel,
    required this.total,
    required this.averageFrequency,
  });

/// 词汇导出配置
}
class VocabularyExportConfig {
  final LanguageLevel? level;
  final String format; // 'json', 'csv', 'excel'
  final bool includeDefinitions;
  final bool includeExamples;
  final bool includeFrequency;

  const VocabularyExportConfig({
    this.level,
    this.format = 'json',
    this.includeDefinitions = true,
    this.includeExamples = true,
    this.includeFrequency = true,
  });
}
