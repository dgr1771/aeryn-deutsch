/// 用户学习档案模型
///
/// 包含用户的学习目标、偏好、当前水平等信息
library;

import 'word.dart';
import '../core/grammar_engine.dart';

/// 学习目标类型
enum LearningGoal {
  testDaF,              // TestDaF考试
  goethe,               // Goethe证书
  dsh,                  // DSH考试
  telc,                 // Telc证书
  dailyLife,            // 日常生活
  work,                 // 工作需求
  study,                // 留学德国
  travel,               // 旅行
  culture,              // 文化兴趣
  interest,             // 兴趣爱好
}

/// 学习风格类型
enum LearningStyle {
  visual,               // 视觉型（图表、颜色）
  auditory,             // 听觉型（音频、对话）
  reading,              // 读写型（文本、笔记）
  kinesthetic,          // 动觉型（互动、练习）
  balanced,             // 平衡型
}

/// 每日学习时长
enum DailyStudyTime {
  fiveToTen,            // 5-10分钟
  tenToTwenty,          // 10-20分钟
  twentyToThirty,       // 20-30分钟
  thirtyToSixty,        // 30-60分钟
  moreThanSixty,        // 60分钟以上
}

/// 学习档案
class UserProfile {
  final String id;
  final String userId;

  // 学习目标
  final LearningGoal primaryGoal;        // 主要目标
  final LanguageLevel targetLevel;       // 目标级别
  final DateTime? targetDate;            // 目标日期（如考试日期）

  // 学习偏好
  final LearningStyle learningStyle;     // 学习风格
  final DailyStudyTime dailyStudyTime;   // 每日学习时长
  final List<String> preferredTopics;    // 偏好主题

  // 当前状态
  final LanguageLevel currentLevel;      // 当前水平
  final int totalWordsLearned;           // 已学词汇数
  final int totalStudyMinutes;           // 总学习分钟数
  final int studyDays;                   // 学习天数
  final int currentStreak;               // 当前连续天数
  final int longestStreak;               // 最长连续天数

  // 技能评估（0-100）
  final double vocabularyScore;          // 词汇得分
  final double grammarScore;             // 语法得分
  final double listeningScore;           // 听力得分
  final double readingScore;             // 阅读得分
  final double writingScore;             // 写作得分
  final double speakingScore;            // 口语得分

  // 时间戳
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final DateTime? completedOnboardingAt;

  const UserProfile({
    required this.id,
    required this.userId,
    required this.primaryGoal,
    required this.targetLevel,
    this.targetDate,
    required this.learningStyle,
    required this.dailyStudyTime,
    this.preferredTopics = const [],
    required this.currentLevel,
    this.totalWordsLearned = 0,
    this.totalStudyMinutes = 0,
    this.studyDays = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.vocabularyScore = 0,
    this.grammarScore = 0,
    this.listeningScore = 0,
    this.readingScore = 0,
    this.writingScore = 0,
    this.speakingScore = 0,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    this.completedOnboardingAt,
  })  : createdAt = createdAt ?? const Duration(),
        lastActiveAt = lastActiveAt ?? const Duration();

  /// 是否完成新手引导
  bool get hasCompletedOnboarding => completedOnboardingAt != null;

  /// 综合得分
  double get overallScore {
    return (vocabularyScore +
            grammarScore +
            listeningScore +
            readingScore +
            writingScore +
            speakingScore) /
        6;
  }

  /// 距离目标级别的差距
  int get levelsToTarget {
    final currentIndex = LanguageLevel.values.indexOf(currentLevel);
    final targetIndex = LanguageLevel.values.indexOf(targetLevel);
    return targetIndex - currentIndex;
  }

  /// 估算达到目标所需天数（基于平均速度）
  int get estimatedDaysToTarget {
    if (levelsToTarget <= 0) return 0;

    // 每个级别平均需要100-200小时
    final hoursPerLevel = switch (currentLevel) {
      LanguageLevel.A1 => 100,
      LanguageLevel.A2 => 150,
      LanguageLevel.B1 => 200,
      LanguageLevel.B2 => 250,
      LanguageLevel.C1 => 300,
      LanguageLevel.C2 => 400,
    };

    // 每日学习时长（分钟）
    final dailyMinutes = switch (dailyStudyTime) {
      DailyStudyTime.fiveToTen => 7.5,
      DailyStudyTime.tenToTwenty => 15,
      DailyStudyTime.twentyToThirty => 25,
      DailyStudyTime.thirtyToSixty => 45,
      DailyStudyTime.moreThanSixty => 75,
    };

    final totalHoursNeeded = levelsToTarget * hoursPerLevel;
    final totalDaysNeeded = (totalHoursNeeded * 60 / dailyMinutes).round();

    return totalDaysNeeded;
  }

  /// 获取目标描述
  String get goalDescription {
    return switch (primaryGoal) {
      LearningGoal.testDaF => 'TestDaF考试准备',
      LearningGoal.goethe => 'Goethe-Zertifikat证书',
      LearningGoal.dsh => 'DSH考试准备',
      LearningGoal.telc => 'Telc证书考试',
      LearningGoal.dailyLife => '日常德语交流',
      LearningGoal.work => '工作德语需求',
      LearningGoal.study => '德国留学准备',
      LearningGoal.travel => '旅行德语',
      LearningGoal.culture => '德语文化学习',
      LearningGoal.interest => '兴趣爱好学习',
    };
  }

  /// 获取学习风格描述
  String get learningStyleDescription {
    return switch (learningStyle) {
      LearningStyle.visual => '视觉型学习者 - 喜欢图表、颜色',
      LearningStyle.auditory => '听觉型学习者 - 喜欢音频、对话',
      LearningStyle.reading => '读写型学习者 - 喜欢文本、笔记',
      LearningStyle.kinesthetic => '动觉型学习者 - 喜欢互动、练习',
      LearningStyle.balanced => '平衡型学习者 - 多样化学习',
    };
  }

  /// 创建副本
  UserProfile copyWith({
    String? id,
    String? userId,
    LearningGoal? primaryGoal,
    LanguageLevel? targetLevel,
    DateTime? targetDate,
    LearningStyle? learningStyle,
    DailyStudyTime? dailyStudyTime,
    List<String>? preferredTopics,
    LanguageLevel? currentLevel,
    int? totalWordsLearned,
    int? totalStudyMinutes,
    int? studyDays,
    int? currentStreak,
    int? longestStreak,
    double? vocabularyScore,
    double? grammarScore,
    double? listeningScore,
    double? readingScore,
    double? writingScore,
    double? speakingScore,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    DateTime? completedOnboardingAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      targetLevel: targetLevel ?? this.targetLevel,
      targetDate: targetDate ?? this.targetDate,
      learningStyle: learningStyle ?? this.learningStyle,
      dailyStudyTime: dailyStudyTime ?? this.dailyStudyTime,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      currentLevel: currentLevel ?? this.currentLevel,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      studyDays: studyDays ?? this.studyDays,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      vocabularyScore: vocabularyScore ?? this.vocabularyScore,
      grammarScore: grammarScore ?? this.grammarScore,
      listeningScore: listeningScore ?? this.listeningScore,
      readingScore: readingScore ?? this.readingScore,
      writingScore: writingScore ?? this.writingScore,
      speakingScore: speakingScore ?? this.speakingScore,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      completedOnboardingAt:
          completedOnboardingAt ?? this.completedOnboardingAt,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'primaryGoal': primaryGoal.name,
      'targetLevel': targetLevel.name,
      'targetDate': targetDate?.toIso8601String(),
      'learningStyle': learningStyle.name,
      'dailyStudyTime': dailyStudyTime.name,
      'preferredTopics': preferredTopics,
      'currentLevel': currentLevel.name,
      'totalWordsLearned': totalWordsLearned,
      'totalStudyMinutes': totalStudyMinutes,
      'studyDays': studyDays,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'vocabularyScore': vocabularyScore,
      'grammarScore': grammarScore,
      'listeningScore': listeningScore,
      'readingScore': readingScore,
      'writingScore': writingScore,
      'speakingScore': speakingScore,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'completedOnboardingAt': completedOnboardingAt?.toIso8601String(),
    };
  }

  /// 从JSON创建
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['userId'],
      primaryGoal: LearningGoal.values
          .firstWhere((e) => e.name == json['primaryGoal']),
      targetLevel: LanguageLevel.values
          .firstWhere((e) => e.name == json['targetLevel']),
      targetDate:
          json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      learningStyle: LearningStyle.values
          .firstWhere((e) => e.name == json['learningStyle']),
      dailyStudyTime: DailyStudyTime.values
          .firstWhere((e) => e.name == json['dailyStudyTime']),
      preferredTopics:
          (json['preferredTopics'] as List<dynamic>?)?.cast<String>() ?? [],
      currentLevel: LanguageLevel.values
          .firstWhere((e) => e.name == json['currentLevel']),
      totalWordsLearned: json['totalWordsLearned'] ?? 0,
      totalStudyMinutes: json['totalStudyMinutes'] ?? 0,
      studyDays: json['studyDays'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      vocabularyScore: (json['vocabularyScore'] ?? 0).toDouble(),
      grammarScore: (json['grammarScore'] ?? 0).toDouble(),
      listeningScore: (json['listeningScore'] ?? 0).toDouble(),
      readingScore: (json['readingScore'] ?? 0).toDouble(),
      writingScore: (json['writingScore'] ?? 0).toDouble(),
      speakingScore: (json['speakingScore'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      lastActiveAt: DateTime.parse(json['lastActiveAt']),
      completedOnboardingAt: json['completedOnboardingAt'] != null
          ? DateTime.parse(json['completedOnboardingAt'])
          : null,
    );
  }

  /// 创建默认档案
  factory UserProfile.createDefault({
    required String userId,
    required LearningGoal primaryGoal,
    required LanguageLevel targetLevel,
    required LearningStyle learningStyle,
    required DailyStudyTime dailyStudyTime,
    LanguageLevel? initialLevel,
    DateTime? targetDate,
    List<String>? preferredTopics,
  }) {
    final now = DateTime.now();
    return UserProfile(
      id: 'profile_$userId',
      userId: userId,
      primaryGoal: primaryGoal,
      targetLevel: targetLevel,
      targetDate: targetDate,
      learningStyle: learningStyle,
      dailyStudyTime: dailyStudyTime,
      preferredTopics: preferredTopics ?? [],
      currentLevel: initialLevel ?? LanguageLevel.A1,
      createdAt: now,
      lastActiveAt: now,
    );
  }
}

/// 新手引导步骤
enum OnboardingStep {
  welcome,              // 欢迎页
  goalSelection,        // 目标选择
  levelAssessment,      // 水平测试
  learningPreferences,  // 学习偏好
  studyPlan,            // 学习计划预览
  completed,            // 完成
}

/// 新手引导数据
class OnboardingData {
  final LearningGoal? selectedGoal;
  final LanguageLevel? targetLevel;
  final DateTime? examDate;
  final LanguageLevel? assessedLevel;
  final LearningStyle? learningStyle;
  final DailyStudyTime? dailyStudyTime;
  final List<String>? preferredTopics;
  final OnboardingStep currentStep;

  const OnboardingData({
    this.selectedGoal,
    this.targetLevel,
    this.examDate,
    this.assessedLevel,
    this.learningStyle,
    this.dailyStudyTime,
    this.preferredTopics,
    required this.currentStep,
  });

  /// 是否完成所有步骤
  bool get isComplete {
    return selectedGoal != null &&
        targetLevel != null &&
        assessedLevel != null &&
        learningStyle != null &&
        dailyStudyTime != null;
  }

  /// 创建副本
  OnboardingData copyWith({
    LearningGoal? selectedGoal,
    LanguageLevel? targetLevel,
    DateTime? examDate,
    LanguageLevel? assessedLevel,
    LearningStyle? learningStyle,
    DailyStudyTime? dailyStudyTime,
    List<String>? preferredTopics,
    OnboardingStep? currentStep,
  }) {
    return OnboardingData(
      selectedGoal: selectedGoal ?? this.selectedGoal,
      targetLevel: targetLevel ?? this.targetLevel,
      examDate: examDate ?? this.examDate,
      assessedLevel: assessedLevel ?? this.assessedLevel,
      learningStyle: learningStyle ?? this.learningStyle,
      dailyStudyTime: dailyStudyTime ?? this.dailyStudyTime,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
