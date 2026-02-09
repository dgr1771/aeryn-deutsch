/// 学习管理服务
///
/// 集成数据库功能和学习路径系统，提供完整的学习管理功能
library;

import '../core/learning_path/learning_path_generator.dart';
import '../services/learning_path_service.dart';
import '../database/repository.dart';
import '../database/user_progress_dao.dart';
import '../data/german_skill_tree.dart';

/// 学习管理器
class LearningManager {
  final Repository _repository;
  late LearningPathService _pathService;

  String? _currentUserId;

  LearningManager({Repository? repository})
      : _repository = repository ?? Repository() {
    _pathService = LearningPathService(skillTree: GermanSkillTreeFactory.createCompleteTree());
  }

  /// 初始化
  Future<void> initialize(String userId) async {
    await _repository.initialize();
    _currentUserId = userId;

    // 检查用户是否存在
    final userProgress = await _repository.getUserProgress(userId);
    if (userProgress == null) {
      // 创建新用户
      await _repository.createUser(userId, LanguageLevel.A1);
    }
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (_currentUserId == null) {
      throw StateError('LearningManager not initialized. Call initialize() first.');
    }
  }

  /// 开始学习会话
  Future<String> startLearningSession(List<String> skillIds) async {
    await _ensureInitialized();
    return await _repository.startStudySession(_currentUserId!, skillIds);
  }

  /// 结束学习会话
  Future<void> endLearningSession({
    required String sessionId,
    required List<String> skillIds,
    required int totalExercises,
    required int correctExercises,
    int durationMinutes = 0,
  }) async {
    await _ensureInitialized();

    // 更新用户学习日期
    await _repository.updateStudyDate(_currentUserId!);

    // 结束会话
    await _repository.endStudySession(
      sessionId,
      totalExercises,
      correctExercises,
    );

    // 更新技能进度（假设每题平均影响所有涉及的技能）
    final accuracy = totalExercises > 0
        ? correctExercises / totalExercises
        : 0.0;

    for (final skillId in skillIds) {
      await _repository.updateSkillPracticeResult(skillId, _currentUserId!, accuracy);
    }
  }

  /// 记录技能学习结果
  Future<void> recordSkillPractice(
    String skillId,
    double accuracy,
  ) async {
    await _ensureInitialized();
    await _repository.updateSkillPracticeResult(skillId, _currentUserId!, accuracy);

    // 更新学习日期
    await _repository.updateStudyDate(_currentUserId!);
  }

  /// 记录词汇学习结果
  Future<void> recordVocabularyPractice(
    String wordId,
    int quality, // 1-5评分
  ) async {
    await _ensureInitialized();

    // 更新复习结果（会自动创建新记录如果不存在）
    await _repository.updateVocabularyReview(wordId, _currentUserId!, quality);

    // 更新学习日期
    await _repository.updateStudyDate(_currentUserId!);
  }

  /// 记录语法练习结果
  Future<void> recordGrammarPractice(
    String exerciseId,
    String exerciseType,
    String level,
    bool isCorrect,
  ) async {
    await _ensureInitialized();

    await _repository.saveGrammarProgress(
      exerciseId,
      _currentUserId!,
      exerciseType,
      level,
      isCorrect,
    );

    // 更新学习日期
    await _repository.updateStudyDate(_currentUserId!);
  }

  /// 获取今日学习任务
  Future<Map<String, dynamic>> getTodayLearningTasks() async {
    await _ensureInitialized();

    final userProgress = await _repository.getUserProgress(_currentUserId!);
    if (userProgress == null) {
      return {'error': 'User not found'};
    }

    // 获取今日复习词汇
    final wordsForReview = await _repository.getWordsForReview(_currentUserId!);

    // 获取今日复习技能
    final skillsForReview = await _repository.getSkillsForReview(_currentUserId!);

    // 获取新学词汇
    final newWords = await _repository.getNewWords(
      _currentUserId!,
      userProgress.currentLevel,
    );

    // 获取今日会话
    final todaySessions = await _repository.getTodaySessions(_currentUserId!);

    // 构建返回数据（确保非空）
    final wordIds = wordsForReview.map((w) => w.wordId).toList();
    final skillIds = skillsForReview.map((s) => s.skillId).toList();
    final newWordIds = newWords.map((w) => w.wordId).toList();

    return {
      'userId': _currentUserId,
      'currentLevel': userProgress.currentLevel.name,
      'totalStudyDays': userProgress.totalStudyDays,
      'currentStreak': userProgress.currentStreak,
      'wordsForReview': wordIds,
      'skillsForReview': skillIds,
      'newWords': newWordIds,
      'todaySessions': todaySessions.length,
      'averageAccuracy': todaySessions.isNotEmpty
          ? todaySessions
              .map((s) => s.correctExercises / (s.totalExercises > 0 ? s.totalExercises : 1))
              .reduce((a, b) => a + b) / todaySessions.length
          : 0.0,
    };
  }

  /// 获取学习统计
  Future<LearningStatistics> getLearningStatistics() async {
    await _ensureInitialized();
    return await _repository.getLearningStatistics(_currentUserId!);
  }

  /// 获取今日学习摘要
  Future<Map<String, dynamic>> getTodaySummary() async {
    await _ensureInitialized();
    return await _repository.getTodaySummary(_currentUserId!);
  }

  /// 获取用户进度
  Future<UserProgressEntity?> getUserProgress() async {
    await _ensureInitialized();
    return await _repository.getUserProgress(_currentUserId!);
  }

  /// 获取技能进度
  Future<List<SkillProgressEntity>> getSkillProgress() async {
    await _ensureInitialized();
    return await _repository.getUserSkillProgress(_currentUserId!);
  }

  /// 智能推荐学习内容
  Future<Map<String, dynamic>> getRecommendedContent() async {
    await _ensureInitialized();

    final summary = await getTodaySummary();

    // 获取需要复习的内容
    final reviewWords = await _repository.getWordsForReview(_currentUserId!);
    final reviewSkills = await _repository.getSkillsForReview(_currentUserId!);

    // 根据今日表现调整推荐
    final averageAccuracy = summary['averageAccuracy'] as double;

    // 如果正确率太低，减少新内容
    final maxNewWords = averageAccuracy < 0.6 ? 5 : 15;
    final maxNewSkills = averageAccuracy < 0.6 ? 2 : 5;

    // 获取新内容
    final userProgress = await getUserProgress();
    if (userProgress == null) {
      return {'error': 'User not found'};
    }

    final newWords = await _repository.getNewWords(
      _currentUserId!,
      userProgress.currentLevel,
    );

    // 使用学习路径服务获取推荐技能
    final masteredSkills = await _repository.getMasteredSkills(_currentUserId!);
    final masteredSkillMap = <String, double>{};
    for (final skill in masteredSkills) {
      masteredSkillMap[skill.skillId] = skill.masteryLevel;
    }

    final availableSkills = _pathService.skillTree.getAvailableSkills(
      masteredSkillMap,
    );

    // 构建返回数据（确保非空）
    final reviewWordIds = reviewWords
        .take(20)
        .map<String>((w) => w.wordId)
        .toList();
    final reviewSkillIds = reviewSkills
        .take(5)
        .map<String>((s) => s.skillId)
        .toList();
    final newWordIds = newWords
        .take(maxNewWords)
        .map<String>((w) => w.wordId)
        .toList();
    final newSkillIds = availableSkills
        .take(maxNewSkills)
        .map<String>((s) => s.id)
        .toList();

    return {
      'reviewWords': reviewWordIds,
      'reviewSkills': reviewSkillIds,
      'newWords': newWordIds,
      'newSkills': newSkillIds,
      'accuracy': averageAccuracy,
      'recommendation': _generateRecommendation(averageAccuracy),
    };
  }

  /// 生成推荐建议
  String _generateRecommendation(double accuracy) {
    if (accuracy >= 0.9) {
      return '表现优秀！可以尝试更有挑战的内容。';
    } else if (accuracy >= 0.75) {
      return '表现良好！继续保持，可以适当增加难度。';
    } else if (accuracy >= 0.6) {
      return '表现一般，建议多复习已学内容。';
    } else {
      return '今天有些困难，建议重点复习基础内容。';
    }
  }

  /// 生成个性化学习计划
  Future<Map<String, dynamic>> generateLearningPlan({
    required LearningGoal goal,
    required LanguageLevel targetLevel,
    required int weeksPerLevel,
  }) async {
    await _ensureInitialized();

    final userProgress = await getUserProgress();
    if (userProgress == null) {
      return {'error': 'User not found'};
    }

    // 构建已掌握技能映射
    final skillProgress = await getSkillProgress();
    final masteredSkills = <String, double>{};
    for (final skill in skillProgress) {
      masteredSkills[skill.skillId] = skill.masteryLevel;
    }

    // 使用学习路径生成器创建计划
    final plan = LearningPathGenerator.generatePath(
      goal,
      userProgress.currentLevel,
      targetLevel,
      masteredSkills,
    );

    return {
      'planId': plan.id,
      'planName': plan.name,
      'description': plan.description,
      'estimatedDuration': plan.estimatedDuration.inDays,
      'requiredSkills': plan.requiredSkills.length,
      'sessionsCount': plan.sessions.length,
      'targetLevel': targetLevel.name,
      'goal': goal.name,
    };
  }

  /// 获取学习报告
  Future<Map<String, dynamic>> generateLearningReport() async {
    await _ensureInitialized();

    final stats = await getLearningStatistics();
    final summary = await getTodaySummary();
    final userProgress = await getUserProgress();

    if (userProgress == null) {
      return {'error': 'User not found'};
    }

    return {
      'userId': _currentUserId,
      'currentLevel': userProgress.currentLevel.name,
      'totalStudyDays': userProgress.totalStudyDays,
      'currentStreak': userProgress.currentStreak,
      'overallProgress': stats.studyStats['totalDays'] ?? 0,
      'vocabularyStats': stats.vocabularyStats,
      'grammarStats': stats.grammarStats,
      'todayStats': summary,
      'lastStudyDate': userProgress.lastStudyDate?.toIso8601String(),
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// 导出学习数据
  Future<Map<String, dynamic>> exportLearningData() async {
    await _ensureInitialized();

    final stats = await getLearningStatistics();
    final summary = await getTodaySummary();
    final dbPath = await _repository.exportDatabase();

    return {
      'statistics': stats.toJson(),
      'todaySummary': summary,
      'databasePath': dbPath,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// 清空用户数据
  Future<void> resetProgress() async {
    await _ensureInitialized();
    await _repository.deleteUserData(_currentUserId!);

    // 重新创建用户
    await _repository.createUser(_currentUserId!, LanguageLevel.A1);
  }

  /// 关闭数据库连接
  Future<void> dispose() async {
    await _repository.close();
  }
}
