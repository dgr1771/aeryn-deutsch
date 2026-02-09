/// 数据仓库
///
/// 统一管理所有数据操作，提供简洁的API
library;

import 'database_helper.dart';
import 'user_progress_dao.dart' show UserProgressDAO, VocabularyProgressEntity;
import 'skill_progress_dao.dart';
import 'vocabulary_progress_dao.dart';
import '../core/learning_path/skill_tree.dart';
import '../core/grammar_engine.dart';

/// 学习统计信息
class LearningStatistics {
  final Map<String, dynamic> userStats;
  final Map<String, dynamic> studyStats;
  final Map<String, dynamic> vocabularyStats;
  final Map<String, dynamic> grammarStats;

  LearningStatistics({
    required this.userStats,
    required this.studyStats,
    required this.vocabularyStats,
    required this.grammarStats,
  });

  Map<String, dynamic> toJson() {
    return {
      'userStats': userStats,
      'studyStats': studyStats,
      'vocabularyStats': vocabularyStats,
      'grammarStats': grammarStats,
    };
  }
}

/// 数据仓库类
class Repository {
  late DatabaseHelper _dbHelper;
  late UserProgressDAO _userProgressDAO;
  late SkillProgressDAO _skillProgressDAO;
  late StudySessionDAO _studySessionDAO;
  late VocabularyProgressDAO _vocabularyProgressDAO;
  late GrammarProgressDAO _grammarProgressDAO;

  bool _isInitialized = false;

  /// 获取单例
  static final Repository _instance = Repository._internal();
  factory Repository() => _instance;

  Repository._internal();

  /// 初始化数据库
  Future<void> initialize() async {
    if (_isInitialized) return;

    _dbHelper = DatabaseHelper();
    await _dbHelper.database; // 触发初始化

    _userProgressDAO = UserProgressDAO(_dbHelper);
    _skillProgressDAO = SkillProgressDAO(_dbHelper);
    _studySessionDAO = StudySessionDAO(_dbHelper);
    _vocabularyProgressDAO = VocabularyProgressDAO(_dbHelper);
    _grammarProgressDAO = GrammarProgressDAO(_dbHelper);

    _isInitialized = true;
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // ========== 用户进度 ==========

  /// 创建新用户
  Future<void> createUser(String userId, LanguageLevel initialLevel) async {
    await _ensureInitialized();
    await _userProgressDAO.createUser(userId, initialLevel);
  }

  /// 获取用户进度
  Future<UserProgressEntity?> getUserProgress(String userId) async {
    await _ensureInitialized();
    return await _userProgressDAO.getUserProgress(userId);
  }

  /// 更新学习日期
  Future<void> updateStudyDate(String userId) async {
    await _ensureInitialized();
    await _userProgressDAO.updateStudyDate(userId);
  }

  /// 升级用户级别
  Future<bool> upgradeLevel(String userId) async {
    await _ensureInitialized();
    return await _userProgressDAO.upgradeLevel(userId);
  }

  // ========== 技能进度 ==========

  /// 保存技能进度
  Future<void> saveSkillProgress(SkillProgressEntity progress) async {
    await _ensureInitialized();
    await _skillProgressDAO.saveSkillProgress(progress);
  }

  /// 获取用户的所有技能进度
  Future<List<SkillProgressEntity>> getUserSkillProgress(String userId) async {
    await _ensureInitialized();
    return await _skillProgressDAO.getUserSkillProgress(userId);
  }

  /// 获取需要复习的技能
  Future<List<SkillProgressEntity>> getSkillsForReview(String userId) async {
    await _ensureInitialized();
    return await _skillProgressDAO.getSkillsForReview(userId);
  }

  /// 获取已掌握的技能
  Future<List<SkillProgressEntity>> getMasteredSkills(String userId) async {
    await _ensureInitialized();
    return await _skillProgressDAO.getMasteredSkills(userId);
  }

  /// 更新技能练习结果
  Future<void> updateSkillPracticeResult(
    String skillId,
    String userId,
    double accuracy,
  ) async {
    await _ensureInitialized();
    await _skillProgressDAO.updateSkillProgress(skillId, userId, accuracy);
  }

  /// 批量更新技能进度
  Future<void> batchUpdateSkillProgress(
    Map<String, double> progressMap,
    String userId,
  ) async {
    await _ensureInitialized();
    await _skillProgressDAO.batchUpdateSkillProgress(progressMap, userId);
  }

  // ========== 学习会话 ==========

  /// 开始学习会话
  Future<String> startStudySession(
    String userId,
    List<String> skillIds,
  ) async {
    await _ensureInitialized();
    final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';

    final session = StudySessionEntity(
      id: sessionId,
      userId: userId,
      sessionDate: DateTime.now(),
      durationMinutes: 0,
      skillsPracticed: skillIds,
    );

    await _studySessionDAO.saveStudySession(session);
    return sessionId;
  }

  /// 结束学习会话
  Future<void> endStudySession(
    String sessionId,
    int totalExercises,
    int correctExercises,
  ) async {
    await _ensureInitialized();

    final session = await _studySessionDAO.getUserStudySessions(
      'dummy', // 这里需要userId
      limit: 1,
    );

    if (session.isEmpty) return;

    final updated = StudySessionEntity(
      id: sessionId,
      userId: session.first.userId,
      sessionDate: session.first.sessionDate,
      durationMinutes: 0, // 实际应该计算
      skillsPracticed: session.first.skillsPracticed,
      totalExercises: totalExercises,
      correctExercises: correctExercises,
    );

    await _studySessionDAO.saveStudySession(updated);
  }

  /// 获取今日学习会话
  Future<List<StudySessionEntity>> getTodaySessions(String userId) async {
    await _ensureInitialized();
    return await _studySessionDAO.getTodaySessions(userId);
  }

  /// 获取学习统计
  Future<Map<String, dynamic>> getStudyStatistics(String userId) async {
    await _ensureInitialized();
    return await _studySessionDAO.getStudyStatistics(userId);
  }

  // ========== 词汇进度 ==========

  /// 保存词汇进度
  Future<void> saveVocabularyProgress(
    VocabularyProgressEntity progress,
  ) async {
    await _ensureInitialized();
    await _vocabularyProgressDAO.saveVocabularyProgress(progress);
  }

  /// 获取特定词汇进度
  Future<VocabularyProgressEntity?> getVocabularyProgress(
    String wordId,
    String userId,
  ) async {
    await _ensureInitialized();
    return await _vocabularyProgressDAO.getVocabularyProgress(wordId, userId);
  }

  /// 获取需要复习的词汇
  Future<List<VocabularyProgressEntity>> getWordsForReview(
    String userId,
  ) async {
    await _ensureInitialized();
    return await _vocabularyProgressDAO.getWordsForReview(userId);
  }

  /// 获取新学词汇
  Future<List<VocabularyProgressEntity>> getNewWords(
    String userId,
    LanguageLevel level,
  ) async {
    await _ensureInitialized();
    return await _vocabularyProgressDAO.getNewWords(userId, level);
  }

  /// 更新词汇复习结果
  Future<void> updateVocabularyReview(
    String wordId,
    String userId,
    int quality,
  ) async {
    await _ensureInitialized();
    await _vocabularyProgressDAO.updateVocabularyReview(wordId, userId, quality);
  }

  /// 批量添加词汇
  Future<void> batchAddVocabulary(
    List<String> wordIds,
    String userId,
    LanguageLevel level,
  ) async {
    await _ensureInitialized();
    await _vocabularyProgressDAO.batchAddVocabulary(wordIds, userId, level);
  }

  /// 获取词汇统计
  Future<Map<String, int>> getVocabularyStatistics(
    String userId,
    LanguageLevel level,
  ) async {
    await _ensureInitialized();
    return await _vocabularyProgressDAO.getVocabularyStatistics(userId);
  }

  // ========== 语法练习进度 ==========

  /// 保存语法练习进度
  Future<void> saveGrammarProgress(
    String exerciseId,
    String userId,
    String exerciseType,
    String level,
    bool isCorrect,
  ) async {
    await _ensureInitialized();

    // 获取当前进度
    final progress = await _grammarProgressDAO.getUserGrammarProgress(userId, exerciseType);
    final current = progress
        .where((p) => p['exercise_id'] == exerciseId)
        .firstOrNull;

    final now = DateTime.now();
    final attempts = (current?['attempts'] as int? ?? 0) + 1;
    final correct = (current?['correct_attempts'] as int? ?? 0) + (isCorrect ? 1 : 0);

    await _grammarProgressDAO.saveGrammarProgress({
      'exercise_id': exerciseId,
      'user_id': userId,
      'exercise_type': exerciseType,
      'level': level,
      'attempts': attempts,
      'correct_attempts': correct,
    });
  }

  /// 获取语法练习统计
  Future<Map<String, dynamic>> getGrammarStatistics(
    String userId,
    String? exerciseType,
  ) async {
    await _ensureInitialized();
    return await _grammarProgressDAO.getGrammarStatistics(userId, exerciseType);
  }

  // ========== 综合统计 ==========

  /// 获取完整的学习统计
  Future<LearningStatistics> getLearningStatistics(String userId) async {
    await _ensureInitialized();

    final userProgress = await getUserProgress(userId);
    final studyStats = await getStudyStatistics(userId);
    final vocabStats = await _vocabularyProgressDAO.getVocabularyStatistics(userId);
    final grammarStats = await _grammarProgressDAO.getGrammarStatistics(userId, null);

    return LearningStatistics(
      userStats: {
        'currentLevel': userProgress?.currentLevel.name ?? 'A1',
        'totalStudyDays': userProgress?.totalStudyDays ?? 0,
        'currentStreak': userProgress?.currentStreak ?? 0,
        'lastStudyDate': userProgress?.lastStudyDate?.toIso8601String(),
      },
      studyStats: studyStats,
      vocabularyStats: vocabStats,
      grammarStats: grammarStats,
    );
  }

  /// 获取今日学习摘要
  Future<Map<String, dynamic>> getTodaySummary(String userId) async {
    await _ensureInitialized();

    final todaySessions = await getTodaySessions(userId);
    final wordsForReview = await getWordsForReview(userId);
    final skillsForReview = await getSkillsForReview(userId);

    int totalExercises = 0;
    int correctExercises = 0;

    for (final session in todaySessions) {
      totalExercises += session.totalExercises;
      correctExercises += session.correctExercises;
    }

    return {
      'sessionsCount': todaySessions.length,
      'totalMinutes': todaySessions.fold<int>(
        0,
        (sum, session) => sum + session.durationMinutes,
      ),
      'totalExercises': totalExercises,
      'correctExercises': correctExercises,
      'accuracy': totalExercises > 0
          ? correctExercises / totalExercises
          : 0.0,
      'wordsForReview': wordsForReview.length,
      'skillsForReview': skillsForReview.length,
      'averageAccuracy': totalExercises > 0
          ? correctExercises / totalExercises
          : 0.0,
    };
  }

  // ========== 数据清理 ==========

  /// 删除用户的所有数据
  Future<void> deleteUserData(String userId) async {
    await _ensureInitialized();

    await _userProgressDAO.deleteUser(userId);
    await _skillProgressDAO.deleteUserSkills(userId);
    await _studySessionDAO.deleteUserSessions(userId);
    await _vocabularyProgressDAO.deleteUserVocabulary(userId);
    await _grammarProgressDAO.deleteUserGrammarProgress(userId);
  }

  /// 清空所有数据
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _dbHelper.clearAllData();
  }

  /// 获取数据库大小
  Future<int> getDatabaseSize() async {
    await _ensureInitialized();
    return await _dbHelper.getDatabaseSize();
  }

  /// 导出数据库
  Future<String> exportDatabase() async {
    await _ensureInitialized();
    return await _dbHelper.exportDatabase();
  }

  /// 关闭数据库
  Future<void> close() async {
    if (_isInitialized) {
      await _dbHelper.close();
      _isInitialized = false;
    }
  }
}
