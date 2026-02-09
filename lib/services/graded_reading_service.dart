/// 分级阅读服务
///
/// 整合文本难度分析和i+1控制，提供完整的分级阅读功能
library;

import '../core/graded_reading/text_difficulty_analyzer.dart';
import '../core/graded_reading/i1_controller.dart';
import '../core/learning_path/skill_tree.dart';
import '../core/grammar_engine.dart';
import '../database/repository.dart';
import 'learning_manager.dart';
import '../data/reading_materials.dart';

/// 阅读材料
class ReadingMaterial {
  final String id;
  final String title;
  final String content;
  final String category;
  final LanguageLevel originalLevel;
  final TextDifficultyScore difficulty;
  final int wordCount;
  final DateTime? lastReadAt;
  final double? userRating; // 0-5

  const ReadingMaterial({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.originalLevel,
    required this.difficulty,
    required this.wordCount,
    this.lastReadAt,
    this.userRating,
  });

  factory ReadingMaterial.fromMap(Map<String, dynamic> map) {
    return ReadingMaterial(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      originalLevel: LanguageLevel.values.firstWhere(
        (e) => e.name == map['original_level'],
        orElse: () => LanguageLevel.A1,
      ),
      difficulty: TextDifficultyScore(
        overallScore: (map['difficulty_score'] as num).toDouble(),
        estimatedLevel: LanguageLevel.values.firstWhere(
          (e) => e.name == map['estimated_level'],
          orElse: () => LanguageLevel.A1,
        ),
        vocabularyDifficulty: (map['vocab_difficulty'] as num).toDouble(),
        grammarComplexity: (map['grammar_complexity'] as num).toDouble(),
        sentenceComplexity: (map['sentence_complexity'] as num).toDouble(),
        unknownWordRatio: map['unknown_word_ratio'] as int? ?? 0,
      ),
      wordCount: map['word_count'] as int? ?? 0,
      lastReadAt: map['last_read_at'] != null
          ? DateTime.parse(map['last_read_at'] as String)
          : null,
      userRating: (map['user_rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'original_level': originalLevel.name,
      'difficulty_score': difficulty.overallScore,
      'estimated_level': difficulty.estimatedLevel.name,
      'vocab_difficulty': difficulty.vocabularyDifficulty,
      'grammar_complexity': difficulty.grammarComplexity,
      'sentence_complexity': difficulty.sentenceComplexity,
      'unknown_word_ratio': difficulty.unknownWordRatio,
      'word_count': wordCount,
      'last_read_at': lastReadAt?.toIso8601String(),
      'user_rating': userRating,
    };
  }
}

/// 阅读会话
class ReadingSession {
  final String id;
  final String userId;
  final String materialId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int comprehensionScore; // 0-100
  final List<String> learnedWords; // 新学的词汇

  const ReadingSession({
    required this.id,
    required this.userId,
    required this.materialId,
    required this.startTime,
    this.endTime,
    this.durationSeconds = 0,
    this.comprehensionScore = 0,
    this.learnedWords = const [],
  });
}

/// 分级阅读服务
class GradedReadingService {
  final LearningManager _learningManager;
  final I1Controller _i1Controller;
  final List<ReadingMaterial> _materialLibrary;

  GradedReadingService({
    required LearningManager learningManager,
    I1Controller? i1Controller,
    List<ReadingMaterial>? materialLibrary,
  })  : _learningManager = learningManager,
        _i1Controller = i1Controller ?? const I1Controller(),
        _materialLibrary = materialLibrary ?? _createDefaultLibrary();

  /// 创建默认材料库
  static List<ReadingMaterial> _createDefaultLibrary() {
    return readingMaterialsExpanded.map((data) {
      // 计算难度分数 (基于级别和未知词比例)
      final levelScore = _getLevelScore(data.level);
      final difficultyScore = TextDifficultyScore(
        overallScore: levelScore,
        estimatedLevel: data.level,
        vocabularyDifficulty: (levelScore * 1.1).clamp(0.0, 1.0),
        grammarComplexity: (levelScore * 1.0).clamp(0.0, 1.0),
        sentenceComplexity: (levelScore * 0.9).clamp(0.0, 1.0),
        unknownWordRatio: data.unknownWordRatio,
      );

      return ReadingMaterial(
        id: data.id,
        title: data.title,
        content: data.content,
        category: data.category,
        originalLevel: data.level,
        difficulty: difficultyScore,
        wordCount: data.wordCount,
      );
    }).toList();
  }

  /// 获取级别的难度分数
  static double _getLevelScore(LanguageLevel level) {
    switch (level) {
      case LanguageLevel.A1:
        return 0.15;
      case LanguageLevel.A2:
        return 0.30;
      case LanguageLevel.B1:
        return 0.50;
      case LanguageLevel.B2:
        return 0.65;
      case LanguageLevel.C1:
        return 0.80;
      case LanguageLevel.C2:
        return 0.90;
    }
  }

  /// 获取用户当前水平
  Future<LanguageLevel> _getUserLevel(String userId) async {
    final progress = await _learningManager.getUserProgress();
    if (progress == null) {
      return LanguageLevel.A1;
    }
    return progress.currentLevel;
  }

  /// 获取用户已知词汇
  Future<Set<String>> _getUserKnownWords(String userId) async {
    // 从数据库获取用户已掌握的词汇
    // 这里简化为返回空集合，实际应该从词汇进度中获取
    return {};
  }

  /// 推荐阅读材料
  Future<List<ReadingMaterial>> getRecommendedMaterials(String userId) async {
    final userLevel = await _getUserLevel(userId);
    final knownWords = await _getUserKnownWords(userId);

    // 获取适合当前水平的材料
    final suitableMaterials = _materialLibrary.where((material) {
      return material.difficulty.isSuitableForLevel(userLevel);
    }).toList();

    return suitableMaterials;
  }

  /// 开始阅读会话
  Future<ReadingSession> startReadingSession(
    String userId,
    String materialId,
  ) async {
    final userLevel = await _getUserLevel(userId);
    final knownWords = await _getUserKnownWords(userId);

    // 获取材料
    final material = _materialLibrary.firstWhere(
      (m) => m.id == materialId,
      orElse: () => throw Exception('Material not found'),
    );

    // 使用i+1控制器适配文本
    final adapted = _i1Controller.selectOptimalText(
      material.content,
      userLevel,
      knownWords,
    );

    // 创建会话
    final session = ReadingSession(
      id: 'reading_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      materialId: materialId,
      startTime: DateTime.now(),
    );

    return session;
  }

  /// 结束阅读会话
  Future<void> endReadingSession(
    ReadingSession session, {
    int comprehensionScore = 0,
    List<String> learnedWords = const [],
  }) async {
    // 更新学习数据
    // 1. 记录新学词汇
    for (final word in learnedWords) {
      await _learningManager.recordVocabularyPractice(word, 4); // 默认质量评分4
    }

    // 2. 更新材料评分
    // （这里应该保存到数据库）

    // 3. 记录学习统计
    // （这里应该保存到数据库）
  }

  /// 获取阅读统计
  Future<Map<String, dynamic>> getReadingStatistics(String userId) async {
    final userProgress = await _learningManager.getUserProgress();
    if (userProgress == null) {
      return {'error': 'User not found'};
    }

    // 获取今日摘要
    final todaySummary = await _learningManager.getTodaySummary();

    return {
      'userId': userId,
      'currentLevel': userProgress.currentLevel.name,
      'totalReadingSessions': todaySummary['sessionsCount'] ?? 0,
      'totalWordsRead': _materialLibrary.fold<int>(
        0,
        (sum, m) => sum + m.wordCount,
      ),
      'averageComprehension': 0.0, // 需要从数据库获取
      'materialsAvailable': _materialLibrary.length,
      'materialsByLevel': _getMaterialsByLevel(),
    };
  }

  /// 按级别统计材料
  Map<String, int> _getMaterialsByLevel() {
    final byLevel = <String, int>{};

    for (final level in LanguageLevel.values) {
      byLevel[level.name] = _materialLibrary
          .where((m) => m.originalLevel == level)
          .length;
    }

    return byLevel;
  }

  /// 生成阅读理解测试
  List<ComprehensionQuestion> generateReadingTest(
    String materialId,
    int questionCount,
  ) {
    final material = _materialLibrary.firstWhere(
      (m) => m.id == materialId,
      orElse: () => throw Exception('Material not found'),
    );

    return I1Controller.generateComprehensionQuestions(
      material.content,
      questionCount,
    );
  }

  /// 分析阅读进度并给出建议
  Future<UserReadingState> analyzeReadingProgress(String userId) async {
    final userLevel = await _getUserLevel(userId);
    final knownWords = await _getUserKnownWords(userId);

    // 获取最近阅读的材料
    final recentMaterials = await getRecommendedMaterials(userId);
    final recentTexts = recentMaterials.take(5).map((m) => m.content).toList();

    return _i1Controller.getUserReadingState(
      userLevel,
      knownWords,
      recentTexts,
    );
  }

  /// 添加自定义材料
  void addCustomMaterial(ReadingMaterial material) {
    _materialLibrary.add(material);
  }

  /// 获取所有可用材料
  List<ReadingMaterial> getAllMaterials() {
    return List.unmodifiable(_materialLibrary);
  }

  /// 按类别获取材料
  List<ReadingMaterial> getMaterialsByCategory(String category) {
    return _materialLibrary.where((m) => m.category == category).toList();
  }

  /// 按级别获取材料
  List<ReadingMaterial> getMaterialsByLevel(LanguageLevel level) {
    return _materialLibrary.where((m) => m.originalLevel == level).toList();
  }
}
