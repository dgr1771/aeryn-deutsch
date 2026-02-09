/// 学习路径服务
///
/// 管理用户学习进度、推荐学习任务、生成学习计划
library;

import '../core/learning_path/skill_tree.dart';
import '../core/learning_path/difficulty_adapter.dart';
import '../core/learning_path/learning_path_generator.dart';
import '../core/grammar_engine.dart';

/// 用户学习进度
class UserLearningProgress {
  final String userId;
  final LanguageLevel currentLevel;
  final Map<String, double> masteredSkills;  // 技能ID -> 掌握度
  final List<String> completedSkillIds;
  final DateTime lastStudyDate;
  final int totalStudyDays;
  final int currentStreak;  // 连续学习天数

  UserLearningProgress({
    required this.userId,
    required this.currentLevel,
    required this.masteredSkills,
    this.completedSkillIds = const [],
    required this.lastStudyDate,
    this.totalStudyDays = 0,
    this.currentStreak = 0,
  });

  /// 更新技能进度
  UserLearningProgress updateSkillProgress(
    String skillId,
    double newMastery,
  ) {
    final updated = Map<String, double>.from(masteredSkills);
    updated[skillId] = newMastery;

    return UserLearningProgress(
      userId: userId,
      currentLevel: currentLevel,
      masteredSkills: updated,
      completedSkillIds: completedSkillIds,
      lastStudyDate: lastStudyDate,
      totalStudyDays: totalStudyDays,
      currentStreak: currentStreak,
    );
  }

  /// 标记技能完成
  UserLearningProgress markSkillCompleted(String skillId) {
    return UserLearningProgress(
      userId: userId,
      currentLevel: currentLevel,
      masteredSkills: masteredSkills,
      completedSkillIds: [...completedSkillIds, skillId],
      lastStudyDate: lastStudyDate,
      totalStudyDays: totalStudyDays,
      currentStreak: currentStreak,
    );
  }

  /// 更新学习日期
  UserLearningProgress updateStudyDate(DateTime newDate) {
    final today = DateTime.now();
    final daysDiff = newDate.difference(lastStudyDate).inDays;

    int newStreak = currentStreak;
    int newTotalDays = totalStudyDays;

    if (daysDiff == 1) {
      // 连续学习
      newStreak++;
      newTotalDays++;
    } else if (daysDiff == 0) {
      // 同一天，不更新
    } else {
      // 中断了
      newStreak = 1;
      newTotalDays++;
    }

    return UserLearningProgress(
      userId: userId,
      currentLevel: currentLevel,
      masteredSkills: masteredSkills,
      completedSkillIds: completedSkillIds,
      lastStudyDate: newDate,
      totalStudyDays: newTotalDays,
      currentStreak: newStreak,
    );
  }

  /// 计算整体进度
  double calculateOverallProgress(int totalSkills) {
    if (totalSkills == 0) return 0.0;
    return completedSkillIds.length / totalSkills;
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentLevel': currentLevel.name,
      'masteredSkills': masteredSkills,
      'completedSkillIds': completedSkillIds,
      'lastStudyDate': lastStudyDate.toIso8601String(),
      'totalStudyDays': totalStudyDays,
      'currentStreak': currentStreak,
    };
  }

  /// 从JSON创建
  factory UserLearningProgress.fromJson(Map<String, dynamic> json) {
    return UserLearningProgress(
      userId: json['userId'] as String,
      currentLevel: LanguageLevel.values.firstWhere(
        (e) => e.name == json['currentLevel'],
      ),
      masteredSkills: Map<String, double>.from(
        json['masteredSkills'] as Map,
      ),
      completedSkillIds: List<String>.from(json['completedSkillIds'] ?? []),
      lastStudyDate: DateTime.parse(json['lastStudyDate'] as String),
      totalStudyDays: json['totalStudyDays'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
    );
  }
}

/// 学习任务推荐
class LearningRecommendation {
  final List<SkillNode> recommendedSkills;
  final List<SkillNode> reviewSkills;
  final String reason;
  final int estimatedMinutes;

  LearningRecommendation({
    required this.recommendedSkills,
    this.reviewSkills = const [],
    required this.reason,
    required this.estimatedMinutes,
  });
}

/// 学习路径服务
class LearningPathService {
  final SkillTree skillTree;
  final DifficultyAdapter difficultyAdapter;

  LearningPathService({
    required this.skillTree,
    DifficultyAdapter? difficultyAdapter,
  }) : difficultyAdapter = difficultyAdapter ?? DifficultyAdapter();

  /// 获取今日学习推荐
  LearningRecommendation getDailyRecommendation(
    UserLearningProgress progress,
    UserPerformance? performance,
  ) {
    // 1. 获取可学习的技能
    final availableSkills = skillTree.getAvailableSkills(progress.masteredSkills);

    // 2. 获取需要复习的技能
    final reviewSkills = _getSkillsNeedingReview(progress);

    // 3. 根据表现调整推荐
    List<SkillNode> recommended = [];

    if (performance != null && performance.needsLowerDifficulty) {
      // 表现不好，推荐复习
      recommended = reviewSkills.take(3).toList();
      return LearningRecommendation(
        recommendedSkills: recommended,
        reviewSkills: reviewSkills,
        reason: '检测到学习困难，建议先复习已学内容',
        estimatedMinutes: 30,
      );
    }

    // 4. 平衡新技能学习和复习
    final newSkillsCount = reviewSkills.isEmpty ? 4 : 2;
    recommended = availableSkills.take(newSkillsCount).toList();

    // 5. 组合推荐
    final finalRecommended = <SkillNode>[
      ...recommended,
      ...reviewSkills.take(2),
    ];

    return LearningRecommendation(
      recommendedSkills: finalRecommended,
      reviewSkills: reviewSkills,
      reason: _generateRecommendationReason(finalRecommended, reviewSkills),
      estimatedMinutes: _estimateTime(finalRecommended.length),
    );
  }

  /// 获取需要复习的技能
  List<SkillNode> _getSkillsNeedingReview(UserLearningProgress progress) {
    return skillTree.nodes.values
        .where((skill) {
          final mastery = progress.masteredSkills[skill.id] ?? 0;
          return mastery >= 0.6 && mastery < skill.masteryThreshold;
        })
        .toList()
      ..sort((a, b) {
        final aMastery = progress.masteredSkills[a.id] ?? 0;
        final bMastery = progress.masteredSkills[b.id] ?? 0;
        return aMastery.compareTo(bMastery);
      });
  }

  /// 生成推荐理由
  String _generateRecommendationReason(
    List<SkillNode> newSkills,
    List<SkillNode> reviewSkills,
  ) {
    if (reviewSkills.isEmpty) {
      return '继续学习新技能，保持学习进度';
    }

    if (newSkills.isEmpty) {
      return '专注复习已学内容，巩固基础';
    }

    return '学习新技能的同时复习 ${reviewSkills.length} 个已学技能';
  }

  /// 估算学习时间
  int _estimateTime(int skillCount) {
    return skillCount * 15; // 每个技能约15分钟
  }

  /// 生成学习计划
  LearningPlan generateLearningPlan(
    UserLearningProgress progress,
    LearningGoal goal,
    LanguageLevel targetLevel,
  ) {
    return LearningPathGenerator.generatePath(
      goal,
      progress.currentLevel,
      targetLevel,
      progress.masteredSkills,
    );
  }

  /// 记录学习结果
  UserLearningProgress recordLearningResult(
    UserLearningProgress progress,
    String skillId,
    double accuracy,
    int practiceCount,
  ) {
    // 更新技能进度
    final node = skillTree.nodes[skillId];
    if (node == null) return progress;

    final updatedNode = node.updateProgress(
      newAccuracy: accuracy,
      additionalPractice: practiceCount,
    );

    // 更新用户进度
    var updatedProgress = progress.updateSkillProgress(
      skillId,
      updatedNode.currentMastery,
    );

    // 如果技能已掌握，标记完成
    if (updatedNode.isMastered &&
        !progress.completedSkillIds.contains(skillId)) {
      updatedProgress = updatedProgress.markSkillCompleted(skillId);
    }

    // 更新学习日期
    final newDate = DateTime.now();
    if (progress.lastStudyDate.day != newDate.day ||
        progress.lastStudyDate.month != newDate.month ||
        progress.lastStudyDate.year != newDate.year) {
      updatedProgress = updatedProgress.updateStudyDate(newDate);
    }

    // 检查是否需要升级
    final newLevel = _checkLevelUpgrade(progress);
    if (newLevel != null) {
      // 这里应该更新用户级别
      // 简化处理，直接返回
    }

    return updatedProgress;
  }

  /// 检查是否应该升级
  LanguageLevel? _checkLevelUpgrade(UserLearningProgress progress) {
    final currentLevelIndex = progress.currentLevel.index;

    // 统计当前级别的技能掌握情况
    final currentLevelSkills = skillTree.nodes.values
        .where((node) => node.level == progress.currentLevel)
        .toList();

    if (currentLevelSkills.isEmpty) return null;

    final masteredCount = currentLevelSkills
        .where((skill) => (progress.masteredSkills[skill.id] ?? 0.0) >= 0.8)
        .length;

    final masteryRate = masteredCount / currentLevelSkills.length;

    // 如果当前级别掌握度超过80%，建议升级
    if (masteryRate >= 0.8 && currentLevelIndex < LanguageLevel.values.length - 1) {
      return LanguageLevel.values[currentLevelIndex + 1];
    }

    return null;
  }

  /// 获取学习统计
  Map<String, dynamic> getLearningStatistics(UserLearningProgress progress) {
    final totalSkills = skillTree.nodes.length;
    final masteredSkills = progress.completedSkillIds.length;
    final inProgressSkills = progress.masteredSkills.values
        .where((mastery) => mastery > 0 && mastery < 0.8)
        .length;

    return {
      'totalSkills': totalSkills,
      'masteredSkills': masteredSkills,
      'inProgressSkills': inProgressSkills,
      'notStartedSkills': totalSkills - masteredSkills - inProgressSkills,
      'overallProgress': progress.calculateOverallProgress(totalSkills),
      'currentLevel': progress.currentLevel.name,
      'totalStudyDays': progress.totalStudyDays,
      'currentStreak': progress.currentStreak,
      'lastStudyDate': progress.lastStudyDate,
    };
  }

  /// 获取技能详情
  SkillNode? getSkillDetails(String skillId) {
    return skillTree.nodes[skillId];
  }

  /// 获取技能依赖链
  List<SkillNode> getSkillDependencyChain(String skillId) {
    return skillTree.getDependencyChain(skillId);
  }

  /// 解锁新技能
  List<SkillNode> getNewlyUnlockedSkills(UserLearningProgress progress) {
    final allSkills = skillTree.nodes.values;
    final newlyUnlocked = <SkillNode>[];

    for (final skill in allSkills) {
      // 如果之前不能学习，现在可以学习了
      if (!progress.masteredSkills.containsKey(skill.id) &&
          skill.isUnlocked(progress.masteredSkills)) {
        newlyUnlocked.add(skill);
      }
    }

    return newlyUnlocked;
  }

  /// 预测学习完成时间
  Duration predictCompletionTime(
    UserLearningProgress progress,
    LearningPlan plan,
  ) {
    final remainingSkills = plan.requiredSkills
        .where((skill) => !(progress.masteredSkills[skill.id] ?? 0 >= skill.masteryThreshold))
        .length;

    // 假设每天学习3个技能
    final daysNeeded = (remainingSkills / 3).ceil();

    return Duration(days: daysNeeded);
  }
}
