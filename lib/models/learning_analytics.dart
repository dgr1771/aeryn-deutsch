/// 学习分析模型
library;

/// 学习活动类型
enum LearningActivityType {
  vocabulary,      // 词汇学习
  grammar,         // 语法学习
  reading,         // 阅读
  listening,       // 听力
  writing,         // 写作
  speaking,        // 口语
  test,            // 测试
  review,          // 复习
}

/// 学习会话记录
class LearningSession {
  final String id;
  final LearningActivityType activityType;
  final DateTime startTime;
  final DateTime endTime;
  final int durationSeconds;        // 持续时间（秒）
  final String? details;             // 详细信息（JSON格式）

  LearningSession({
    required this.id,
    required this.activityType,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityType': activityType.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationSeconds': durationSeconds,
      'details': details,
    };
  }

  factory LearningSession.fromJson(Map<String, dynamic> json) {
    return LearningSession(
      id: json['id'] as String,
      activityType: LearningActivityType.values.firstWhere(
        (e) => e.name == json['activityType'],
      ),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationSeconds: json['durationSeconds'] as int,
      details: json['details'] as String?,
    );
  }
}

/// 每日学习统计
class DailyStats {
  final DateTime date;
  final int totalSeconds;             // 总学习时间（秒）
  final int sessionCount;             // 学习次数
  final Map<LearningActivityType, int> activityTime;  // 各活动时长

  DailyStats({
    required this.date,
    required this.totalSeconds,
    required this.sessionCount,
    required this.activityTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalSeconds': totalSeconds,
      'sessionCount': sessionCount,
      'activityTime': activityTime.map(
        (key, value) => MapEntry(key.name, value),
      ),
    };
  }
}

/// 学习目标进度
class LearningGoalProgress {
  final String goalId;
  final String goalName;
  final double currentProgress;       // 当前进度（0-1）
  final double targetProgress;        // 目标进度（通常是1）
  final DateTime deadline;
  final bool isCompleted;

  LearningGoalProgress({
    required this.goalId,
    required this.goalName,
    required this.currentProgress,
    required this.targetProgress,
    required this.deadline,
    required this.isCompleted,
  });

  double get percentage => currentProgress * 100;

  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'goalName': goalName,
      'currentProgress': currentProgress,
      'targetProgress': targetProgress,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}

/// 技能掌握度
class SkillMastery {
  final String skillName;
  final String skillId;
  final double masteryLevel;          // 掌握度（0-1）
  final int practiceCount;            // 练习次数
  final DateTime lastPracticeDate;

  SkillMastery({
    required this.skillName,
    required this.skillId,
    required this.masteryLevel,
    required this.practiceCount,
    required this.lastPracticeDate,
  });

  double get percentage => masteryLevel * 100;

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'skillId': skillId,
      'masteryLevel': masteryLevel,
      'practiceCount': practiceCount,
      'lastPracticeDate': lastPracticeDate.toIso8601String(),
    };
  }
}

/// 学习趋势数据
class LearningTrend {
  final DateTime period;
  final double value;
  final String? label;

  LearningTrend({
    required this.period,
    required this.value,
    this.label,
  });

  Map<String, dynamic> toJson() {
    return {
      'period': period.toIso8601String(),
      'value': value,
      'label': label,
    };
  }
}

/// 学习分析报告
class LearningAnalytics {
  // 基础统计
  final int totalStudyDays;            // 总学习天数
  final int totalStudyMinutes;         // 总学习分钟数
  final int totalSessions;             // 总学习次数
  final double averageDailyMinutes;    // 平均每日学习分钟数
  final int currentStreak;             // 当前连续学习天数
  final int longestStreak;             // 最长连续学习天数

  // 活动分布
  final Map<LearningActivityType, int> activityTime;     // 各活动总时长（分钟）
  final Map<LearningActivityType, int> activityCount;   // 各活动次数

  // 进度数据
  final List<DailyStats> dailyStats;                    // 每日统计（最近30天）
  final List<LearningTrend> weeklyTrend;                // 周趋势（最近12周）
  final List<LearningGoalProgress> goals;               // 目标进度
  final List<SkillMastery> skills;                      // 技能掌握度

  // 成就
  final List<String> achievements;                      // 已获得的成就

  LearningAnalytics({
    required this.totalStudyDays,
    required this.totalStudyMinutes,
    required this.totalSessions,
    required this.averageDailyMinutes,
    required this.currentStreak,
    required this.longestStreak,
    required this.activityTime,
    required this.activityCount,
    required this.dailyStats,
    required this.weeklyTrend,
    required this.goals,
    required this.skills,
    required this.achievements,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalStudyDays': totalStudyDays,
      'totalStudyMinutes': totalStudyMinutes,
      'totalSessions': totalSessions,
      'averageDailyMinutes': averageDailyMinutes,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'activityTime': activityTime.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'activityCount': activityCount.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'dailyStats': dailyStats.map((d) => d.toJson()).toList(),
      'weeklyTrend': weeklyTrend.map((t) => t.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'achievements': achievements,
    };
  }

  /// 获取最常学习的活动类型
  LearningActivityType? get mostPracticedActivity {
    if (activityTime.isEmpty) return null;

    return activityTime.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// 获取学习时间占比
  Map<LearningActivityType, double> get activityPercentage {
    if (totalStudyMinutes == 0) return {};

    final result = <LearningActivityType, double>{};
    activityTime.forEach((type, minutes) {
      result[type] = (minutes / totalStudyMinutes) * 100;
    });
    return result;
  }

  /// 获取本周学习分钟数
  int get thisWeekMinutes {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return dailyStats
        .where((d) => d.date.isAfter(weekAgo))
        .fold(0, (sum, d) => sum + (d.totalSeconds ~/ 60));
  }

  /// 获取本月学习分钟数
  int get thisMonthMinutes {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));

    return dailyStats
        .where((d) => d.date.isAfter(monthAgo))
        .fold(0, (sum, d) => sum + (d.totalSeconds ~/ 60));
  }
}

/// 成就定义
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int? targetValue;             // 目标值（如果有）

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.targetValue,
  });
}

/// 预定义的成就列表
final List<Achievement> predefinedAchievements = [
  Achievement(
    id: 'first_day',
    name: '初学者',
    description: '完成第一天的学习',
    icon: '🌱',
  ),
  Achievement(
    id: 'streak_7',
    name: '坚持一周',
    description: '连续学习7天',
    icon: '🔥',
    targetValue: 7,
  ),
  Achievement(
    id: 'streak_30',
    name: '月度冠军',
    description: '连续学习30天',
    icon: '🏆',
    targetValue: 30,
  ),
  Achievement(
    id: 'hours_10',
    name: '学习达人',
    description: '累计学习10小时',
    icon: '⏱️',
    targetValue: 600,  // 10小时 = 600分钟
  ),
  Achievement(
    id: 'hours_50',
    name: '学习专家',
    description: '累计学习50小时',
    icon: '🎓',
    targetValue: 3000,  // 50小时 = 3000分钟
  ),
  Achievement(
    id: 'vocab_100',
    name: '词汇新手',
    description: '学习100个单词',
    icon: '📚',
    targetValue: 100,
  ),
  Achievement(
    id: 'vocab_500',
    name: '词汇大师',
    description: '学习500个单词',
    icon: '📖',
    targetValue: 500,
  ),
  Achievement(
    id: 'listening_10',
    name: '听力新手',
    description: '完成10个听力练习',
    icon: '🎧',
    targetValue: 10,
  ),
  Achievement(
    id: 'writing_10',
    name: '写作新手',
    description: '完成10篇写作',
    icon: '✍️',
    targetValue: 10,
  ),
  Achievement(
    id: 'perfect_score',
    name: '满分王者',
    description: '获得一次满分',
    icon: '💯',
  ),
];
