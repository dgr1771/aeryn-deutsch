/// 学习分析服务
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/learning_analytics.dart';

/// 学习分析服务
class LearningAnalyticsService {
  static const String _sessionsKey = 'learning_sessions';
  static const String _goalsKey = 'learning_goals';
  static const String _achievementsKey = 'achievements';

  SharedPreferences? _prefs;
  List<LearningSession> _sessions = [];
  List<LearningGoalProgress> _goals = [];
  List<String> _unlockedAchievements = [];

  /// 初始化服务
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadSessions();
    await _loadGoals();
    await _loadAchievements();
  }

  /// 加载学习会话记录
  Future<void> _loadSessions() async {
    if (_prefs == null) return;

    final sessionsJson = _prefs!.getStringList(_sessionsKey) ?? [];
    _sessions = sessionsJson
        .map((json) => LearningSession.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存学习会话记录
  Future<void> _saveSessions() async {
    if (_prefs == null) return;

    final sessionsJson = _sessions.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs!.setStringList(_sessionsKey, sessionsJson);
  }

  /// 加载学习目标
  Future<void> _loadGoals() async {
    if (_prefs == null) return;

    final goalsJson = _prefs!.getStringList(_goalsKey) ?? [];
    _goals = goalsJson
        .map((json) => _parseGoal(jsonDecode(json)))
        .whereType<LearningGoalProgress>()
        .toList();
  }

  /// 保存学习目标
  Future<void> _saveGoals() async {
    if (_prefs == null) return;

    final goalsJson = _goals.map((g) => jsonEncode(g.toJson())).toList();
    await _prefs!.setStringList(_goalsKey, goalsJson);
  }

  /// 加载成就
  Future<void> _loadAchievements() async {
    if (_prefs == null) return;

    _unlockedAchievements = _prefs!.getStringList(_achievementsKey) ?? [];
  }

  /// 保存成就
  Future<void> _saveAchievements() async {
    if (_prefs == null) return;

    await _prefs!.setStringList(_achievementsKey, _unlockedAchievements);
  }

  /// 记录学习会话
  Future<void> recordSession({
    required LearningActivityType activityType,
    required int durationSeconds,
    String? details,
  }) async {
    await initialize();

    final now = DateTime.now();
    final session = LearningSession(
      id: 'session_${now.millisecondsSinceEpoch}',
      activityType: activityType,
      startTime: now.subtract(Duration(seconds: durationSeconds)),
      endTime: now,
      durationSeconds: durationSeconds,
      details: details,
    );

    _sessions.add(session);
    await _saveSessions();

    // 检查并解锁成就
    await _checkAndUnlockAchievements();
  }

  /// 获取学习分析报告
  Future<LearningAnalytics> getAnalytics() async {
    await initialize();

    if (_sessions.isEmpty) {
      return _createEmptyAnalytics();
    }

    // 计算基础统计
    final totalMinutes = _sessions.fold<int>(
      0,
      (sum, session) => sum + (session.durationSeconds ~/ 60),
    );

    final totalSessions = _sessions.length;

    // 计算学习天数
    final uniqueDays = _sessions
        .map((s) => DateTime(s.startTime.year, s.startTime.month, s.startTime.day))
        .toSet()
        .length;

    // 计算平均每日学习时间
    final averageDailyMinutes = uniqueDays > 0
        ? (totalMinutes / uniqueDays)
        : 0.0;

    // 计算连续学习天数
    final currentStreak = _calculateCurrentStreak();
    final longestStreak = _calculateLongestStreak();

    // 计算活动分布
    final activityTime = <LearningActivityType, int>{};
    final activityCount = <LearningActivityType, int>{};

    for (final session in _sessions) {
      activityTime[session.activityType] =
          (activityTime[session.activityType] ?? 0) + (session.durationSeconds ~/ 60);
      activityCount[session.activityType] =
          (activityCount[session.activityType] ?? 0) + 1;
    }

    // 生成每日统计（最近30天）
    final dailyStats = _generateDailyStats(30);

    // 生成周趋势（最近12周）
    final weeklyTrend = _generateWeeklyTrend(12);

    // 生成技能掌握度（简化版）
    final skills = _generateSkillMastery();

    return LearningAnalytics(
      totalStudyDays: uniqueDays,
      totalStudyMinutes: totalMinutes,
      totalSessions: totalSessions,
      averageDailyMinutes: averageDailyMinutes,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      activityTime: activityTime,
      activityCount: activityCount,
      dailyStats: dailyStats,
      weeklyTrend: weeklyTrend,
      goals: List.from(_goals),
      skills: skills,
      achievements: List.from(_unlockedAchievements),
    );
  }

  /// 创建空的分析报告
  LearningAnalytics _createEmptyAnalytics() {
    return LearningAnalytics(
      totalStudyDays: 0,
      totalStudyMinutes: 0,
      totalSessions: 0,
      averageDailyMinutes: 0.0,
      currentStreak: 0,
      longestStreak: 0,
      activityTime: {},
      activityCount: {},
      dailyStats: [],
      weeklyTrend: [],
      goals: [],
      skills: [],
      achievements: [],
    );
  }

  /// 计算当前连续学习天数
  int _calculateCurrentStreak() {
    if (_sessions.isEmpty) return 0;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // 获取最近的学习日期
    final studyDates = _sessions
        .map((s) => DateTime(s.startTime.year, s.startTime.month, s.startTime.day))
        .toSet()
        .toList()
        ..sort();

    if (studyDates.isEmpty) return 0;

    final lastStudyDate = studyDates.last;
    final diffDays = today.difference(lastStudyDate).inDays;

    // 如果最后学习日期是昨天或今天，开始计算连续天数
    if (diffDays <= 1) {
      var streak = 1;
      for (var i = studyDates.length - 2; i >= 0; i--) {
        final currentDiff = studyDates[i + 1].difference(studyDates[i]).inDays;
        if (currentDiff == 1) {
          streak++;
        } else {
          break;
        }
      }
      return streak;
    }

    return 0;
  }

  /// 计算最长连续学习天数
  int _calculateLongestStreak() {
    if (_sessions.isEmpty) return 0;

    final studyDates = _sessions
        .map((s) => DateTime(s.startTime.year, s.startTime.month, s.startTime.day))
        .toSet()
        .toList()
        ..sort();

    if (studyDates.isEmpty) return 0;

    var maxStreak = 1;
    var currentStreak = 1;

    for (var i = 1; i < studyDates.length; i++) {
      final diff = studyDates[i].difference(studyDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
      } else {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  /// 生成每日统计
  List<DailyStats> _generateDailyStats(int days) {
    final now = DateTime.now();
    final stats = <DailyStats>[];

    for (var i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // 筛选当天的学习会话
      final daySessions = _sessions.where((s) =>
          s.startTime.isAfter(dayStart) && s.startTime.isBefore(dayEnd));

      if (daySessions.isEmpty) {
        stats.add(DailyStats(
          date: date,
          totalSeconds: 0,
          sessionCount: 0,
          activityTime: {},
        ));
      } else {
        final totalSeconds = daySessions.fold<int>(
          0,
          (sum, s) => sum + s.durationSeconds,
        );

        final activityTime = <LearningActivityType, int>{};
        for (final session in daySessions) {
          activityTime[session.activityType] =
              (activityTime[session.activityType] ?? 0) + session.durationSeconds;
        }

        stats.add(DailyStats(
          date: date,
          totalSeconds: totalSeconds,
          sessionCount: daySessions.length,
          activityTime: activityTime,
        ));
      }
    }

    return stats;
  }

  /// 生成周趋势
  List<LearningTrend> _generateWeeklyTrend(int weeks) {
    final trends = <LearningTrend>[];
    final now = DateTime.now();

    for (var i = weeks - 1; i >= 0; i--) {
      final weekEnd = now.subtract(Duration(days: i * 7));
      final weekStart = weekEnd.subtract(const Duration(days: 7));

      // 筛选当周的学习会话
      final weekSessions = _sessions.where((s) =>
          s.startTime.isAfter(weekStart) && s.startTime.isBefore(weekEnd));

      final totalMinutes = weekSessions.fold<int>(
        0,
        (sum, s) => sum + (s.durationSeconds ~/ 60),
      );

      trends.add(LearningTrend(
        period: weekStart,
        value: totalMinutes.toDouble(),
        label: '${weekStart.month}/${weekStart.day}',
      ));
    }

    return trends;
  }

  /// 生成技能掌握度
  List<SkillMastery> _generateSkillMastery() {
    // 这里是简化版，实际应该根据具体的技能练习记录计算
    final skills = <SkillMastery>[];

    // 根据活动类型生成技能
    for (final activityType in LearningActivityType.values) {
      final activitySessions = _sessions.where((s) => s.activityType == activityType);
      if (activitySessions.isNotEmpty) {
        final totalMinutes = activitySessions.fold<int>(
          0,
          (sum, s) => sum + (s.durationSeconds ~/ 60),
        );

        // 简化的掌握度计算：每100小时掌握度为1
        final masteryLevel = (totalMinutes / (100 * 60)).clamp(0.0, 1.0);

        skills.add(SkillMastery(
          skillName: _getActivityTypeName(activityType),
          skillId: activityType.name,
          masteryLevel: masteryLevel,
          practiceCount: activitySessions.length,
          lastPracticeDate: activitySessions
              .map((s) => s.startTime)
              .reduce((a, b) => a.isAfter(b) ? a : b),
        ));
      }
    }

    return skills;
  }

  /// 检查并解锁成就
  Future<void> _checkAndUnlockAchievements() async {
    final analytics = await getAnalytics();

    for (final achievement in predefinedAchievements) {
      if (_unlockedAchievements.contains(achievement.id)) continue;

      bool unlocked = false;

      switch (achievement.id) {
        case 'first_day':
          unlocked = analytics.totalStudyDays >= 1;
          break;
        case 'streak_7':
          unlocked = analytics.currentStreak >= 7;
          break;
        case 'streak_30':
          unlocked = analytics.currentStreak >= 30;
          break;
        case 'hours_10':
          unlocked = analytics.totalStudyMinutes >= 600;
          break;
        case 'hours_50':
          unlocked = analytics.totalStudyMinutes >= 3000;
          break;
        case 'vocab_100':
          unlocked = analytics.activityCount[LearningActivityType.vocabulary] != null &&
              analytics.activityCount[LearningActivityType.vocabulary]! >= 100;
          break;
        case 'vocab_500':
          unlocked = analytics.activityCount[LearningActivityType.vocabulary] != null &&
              analytics.activityCount[LearningActivityType.vocabulary]! >= 500;
          break;
        case 'listening_10':
          unlocked = analytics.activityCount[LearningActivityType.listening] != null &&
              analytics.activityCount[LearningActivityType.listening]! >= 10;
          break;
        case 'writing_10':
          unlocked = analytics.activityCount[LearningActivityType.writing] != null &&
              analytics.activityCount[LearningActivityType.writing]! >= 10;
          break;
        case 'perfect_score':
          // 需要从details中检查是否有满分
          unlocked = _sessions.any((s) =>
              s.details != null && s.details!.contains('perfect_score'));
          break;
      }

      if (unlocked) {
        _unlockedAchievements.add(achievement.id);
        await _saveAchievements();
        // TODO: 发送成就解锁通知
      }
    }
  }

  /// 添加学习目标
  Future<void> addGoal(LearningGoalProgress goal) async {
    await initialize();

    _goals.add(goal);
    await _saveGoals();
  }

  /// 更新学习目标进度
  Future<void> updateGoalProgress({
    required String goalId,
    required double newProgress,
  }) async {
    await initialize();

    final index = _goals.indexWhere((g) => g.goalId == goalId);
    if (index != -1) {
      final goal = _goals[index];
      _goals[index] = LearningGoalProgress(
        goalId: goal.goalId,
        goalName: goal.goalName,
        currentProgress: newProgress.clamp(0.0, 1.0),
        targetProgress: goal.targetProgress,
        deadline: goal.deadline,
        isCompleted: newProgress >= goal.targetProgress,
      );
      await _saveGoals();
    }
  }

  /// 获取所有学习目标
  List<LearningGoalProgress> getGoals() {
    return List.from(_goals);
  }

  /// 获取已解锁的成就
  List<String> getUnlockedAchievements() {
    return List.from(_unlockedAchievements);
  }

  /// 清除所有数据
  Future<void> clearAllData() async {
    await initialize();

    _sessions.clear();
    _goals.clear();
    _unlockedAchievements.clear();

    await _saveSessions();
    await _saveGoals();
    await _saveAchievements();
  }

  /// 解析学习目标
  LearningGoalProgress? _parseGoal(Map<String, dynamic> json) {
    try {
      return LearningGoalProgress(
        goalId: json['goalId'] as String,
        goalName: json['goalName'] as String,
        currentProgress: (json['currentProgress'] as num).toDouble(),
        targetProgress: (json['targetProgress'] as num).toDouble(),
        deadline: DateTime.parse(json['deadline'] as String),
        isCompleted: json['isCompleted'] as bool,
      );
    } catch (e) {
      return null;
    }
  }

  /// 获取活动类型名称
  String _getActivityTypeName(LearningActivityType type) {
    return switch (type) {
      LearningActivityType.vocabulary => '词汇',
      LearningActivityType.grammar => '语法',
      LearningActivityType.reading => '阅读',
      LearningActivityType.listening => '听力',
      LearningActivityType.writing => '写作',
      LearningActivityType.speaking => '口语',
      LearningActivityType.test => '测试',
      LearningActivityType.review => '复习',
    };
  }
}
