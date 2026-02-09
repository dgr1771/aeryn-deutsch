/// 学习路径生成器
///
/// 根据用户目标和当前水平生成个性化学习路径
library;

import 'skill_tree.dart';
import 'difficulty_adapter.dart';
import '../grammar_engine.dart';

/// 学习目标
enum LearningGoal {
  casual,          // 日常对话（A2）
  travel,          // 旅行（B1）
  business,        // 商务（B2）
  academic,        // 学术（C1）
  literature,      // 文学（C2）
  testPrep,        // 考试准备（TestDaF/Goethe）
}

/// 学习计划
class LearningPlan {
  final String id;
  final String name;
  final String description;
  final LearningGoal goal;
  final LanguageLevel targetLevel;
  final Duration estimatedDuration;  // 预计所需时间
  final List<SkillNode> requiredSkills;
  final List<StudySession> sessions;

  LearningPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.goal,
    required this.targetLevel,
    required this.estimatedDuration,
    required this.requiredSkills,
    required this.sessions,
  });

  /// 计算完成进度
  double calculateProgress(Map<String, double> masteredSkills) {
    if (requiredSkills.isEmpty) return 0.0;

    final mastered = requiredSkills
        .where((skill) => (masteredSkills[skill.id] ?? 0) >= skill.masteryThreshold)
        .length;

    return mastered / requiredSkills.length;
  }

  /// 获取今日学习任务
  List<SkillNode> getTodaysTasks(DateTime date, Map<String, double> masteredSkills) {
    final dayIndex = date.difference(DateTime.now()).inDays;

    if (dayIndex < 0 || dayIndex >= sessions.length) {
      return [];
    }

    final session = sessions[dayIndex];
    return session.tasks
        .where((task) => task.canStart(masteredSkills))
        .toList();
  }
}

/// 学习会话
class StudySession {
  final String id;
  final String title;
  final Duration estimatedTime;
  final List<SkillNode> tasks;
  final String? description;

  StudySession({
    required this.id,
    required this.title,
    required this.estimatedTime,
    required this.tasks,
    this.description,
  });
}

/// 学习路径生成器
class LearningPathGenerator {
  /// 生成学习路径
  static LearningPlan generatePath(
    LearningGoal goal,
    LanguageLevel currentLevel,
    LanguageLevel targetLevel,
    Map<String, double> masteredSkills,
  ) {
    // 1. 确定所需技能
    final requiredSkills = _getRequiredSkills(goal, targetLevel);

    // 2. 过滤已掌握的技能
    final unmasteredSkills = requiredSkills
        .where((skill) => !((masteredSkills[skill.id] ?? 0) >= skill.masteryThreshold))
        .toList();

    // 3. 按依赖关系排序
    final sortedSkills = _topologicalSort(unmasteredSkills);

    // 4. 估算时间
    final estimatedDuration = _estimateDuration(currentLevel, targetLevel, goal);

    // 5. 生成学习会话
    final sessions = _generateSessions(sortedSkills, currentLevel, goal);

    return LearningPlan(
      id: '${goal.name}_${targetLevel.name}_${DateTime.now().millisecondsSinceEpoch}',
      name: _getPlanName(goal, targetLevel),
      description: _getPlanDescription(goal, targetLevel),
      goal: goal,
      targetLevel: targetLevel,
      estimatedDuration: estimatedDuration,
      requiredSkills: sortedSkills,
      sessions: sessions,
    );
  }

  /// 获取所需技能
  static List<SkillNode> _getRequiredSkills(LearningGoal goal, LanguageLevel level) {
    // 这里应该从数据库或配置文件中读取
    // 简化示例，实际应该更详细
    return []; // TODO: 实现技能数据库
  }

  /// 拓扑排序（考虑依赖关系）
  static List<SkillNode> _topologicalSort(List<SkillNode> skills) {
    final sorted = <SkillNode>[];
    final visited = <String>{};

    void visit(SkillNode node) {
      if (visited.contains(node.id)) return;
      visited.add(node.id);

      // 先访问依赖
      for (final preId in node.prerequisites) {
        final preNode = skills.firstWhere(
          (s) => s.id == preId,
          orElse: () => node, // 简化处理
        );
        visit(preNode);
      }

      sorted.add(node);
    }

    for (final skill in skills) {
      visit(skill);
    }

    return sorted;
  }

  /// 估算学习时间
  static Duration _estimateDuration(
    LanguageLevel current,
    LanguageLevel target,
    LearningGoal goal,
  ) {
    // 基于CEFR标准估算
    // A1: 80-100小时
    // A2: +100-120小时
    // B1: +150-200小时
    // B2: +200-250小时
    // C1: +300-400小时
    // C2: +400-500小时

    final hours = {
      LanguageLevel.A1: 100,
      LanguageLevel.A2: 220,
      LanguageLevel.B1: 400,
      LanguageLevel.B2: 620,
      LanguageLevel.C1: 950,
      LanguageLevel.C2: 1400,
    };

    final targetHours = hours[target] ?? 100;
    final currentHours = hours[current] ?? 0;

    // 根据目标调整
    double multiplier = 1.0;
    switch (goal) {
      case LearningGoal.casual:
        multiplier = 0.8;
        break;
      case LearningGoal.travel:
        multiplier = 0.9;
        break;
      case LearningGoal.business:
        multiplier = 1.2;
        break;
      case LearningGoal.academic:
        multiplier = 1.5;
        break;
      case LearningGoal.literature:
        multiplier = 1.8;
        break;
      case LearningGoal.testPrep:
        multiplier = 1.3;
        break;
    }

    final totalHours = ((targetHours - currentHours) * multiplier).round();
    return Duration(hours: totalHours);
  }

  /// 生成学习会话
  static List<StudySession> _generateSessions(
    List<SkillNode> skills,
    LanguageLevel currentLevel,
    LearningGoal goal,
  ) {
    final sessions = <StudySession>[];

    // 每个会话包含2-4个技能，每天30-60分钟
    final skillsPerSession = goal == LearningGoal.testPrep ? 4 : 3;

    for (int i = 0; i < skills.length; i += skillsPerSession) {
      final end = (i + skillsPerSession > skills.length) ? skills.length : i + skillsPerSession;
      final sessionSkills = skills.sublist(i, end);

      sessions.add(StudySession(
        id: 'session_${sessions.length}',
        title: '学习会话 ${sessions.length + 1}',
        estimatedTime: Duration(minutes: 45),
        tasks: sessionSkills,
        description: '完成${sessionSkills.length}个技能的学习',
      ));
    }

    return sessions;
  }

  /// 获取计划名称
  static String _getPlanName(LearningGoal goal, LanguageLevel level) {
    final goalNames = {
      LearningGoal.casual: '日常德语',
      LearningGoal.travel: '旅行德语',
      LearningGoal.business: '商务德语',
      LearningGoal.academic: '学术德语',
      LearningGoal.literature: '文学德语',
      LearningGoal.testPrep: '考试准备',
    };

    return '${goalNames[goal]} - ${level.name}级';
  }

  /// 获取计划描述
  static String _getPlanDescription(LearningGoal goal, LanguageLevel level) {
    return '系统学习${level.name}级德语，达到${goal.name}目标';
  }

  /// 生成每日任务列表
  static List<SkillNode> generateDailyTasks(
    LearningPlan plan,
    DateTime date,
    Map<String, double> masteredSkills,
  ) {
    // 获取今日任务
    final todaysTasks = plan.getTodaysTasks(date, masteredSkills);

    // 如果今日任务已完成或为空，获取下一个未完成的会话
    if (todaysTasks.isEmpty) {
      // 查找下一个有未完成技能的会话
      for (final session in plan.sessions) {
        final unmastered = session.tasks
            .where((task) => task.canStart(masteredSkills))
            .toList();

        if (unmastered.isNotEmpty) {
          return unmastered;
        }
      }
    }

    return todaysTasks;
  }

  /// 调整学习计划
  static LearningPlan adjustPlan(
    LearningPlan original,
    Map<String, double> masteredSkills,
    UserPerformance performance,
  ) {
    // 根据用户表现调整计划
    // 例如：增加复习会话、调整难度等

    // 简化实现，直接返回原计划
    return original;
  }

  /// 生成复习计划
  static List<SkillNode> generateReviewPlan(
    Map<String, double> masteredSkills,
    List<SkillNode> allSkills,
  ) {
    // 获取需要复习的技能（掌握度在0.6-0.8之间）
    return allSkills
        .where((skill) {
          final mastery = masteredSkills[skill.id] ?? 0;
          return mastery >= 0.6 && mastery < skill.masteryThreshold;
        })
        .toList()
      ..sort((a, b) {
        final aMastery = masteredSkills[a.id] ?? 0;
        final bMastery = masteredSkills[b.id] ?? 0;
        return aMastery.compareTo(bMastery); // 优先复习掌握度低的
      });
  }
}
