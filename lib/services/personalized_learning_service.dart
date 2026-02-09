/// 个性化学习路径服务
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/personalized_learning.dart';
import '../models/learning_analytics.dart';
import 'learning_analytics_service.dart';

/// 个性化学习路径服务
class PersonalizedLearningService {
  static const String _pathsKey = 'learning_paths';
  static const String _currentPathKey = 'current_learning_path';

  SharedPreferences? _prefs;
  final LearningAnalyticsService _analyticsService = LearningAnalyticsService();

  List<LearningPath> _paths = [];
  LearningPath? _currentPath;

  /// 初始化服务
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadPaths();
    await _loadCurrentPath();
  }

  /// 加载学习路径
  Future<void> _loadPaths() async {
    if (_prefs == null) return;

    final pathsJson = _prefs!.getStringList(_pathsKey) ?? [];
    _paths = pathsJson
        .map((json) => LearningPath.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存学习路径
  Future<void> _savePaths() async {
    if (_prefs == null) return;

    final pathsJson = _paths.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs!.setStringList(_pathsKey, pathsJson);
  }

  /// 加载当前路径
  Future<void> _loadCurrentPath() async {
    if (_prefs == null) return;

    final currentPathJson = _prefs!.getString(_currentPathKey);
    if (currentPathJson != null) {
      _currentPath = LearningPath.fromJson(jsonDecode(currentPathJson));
    }
  }

  /// 保存当前路径
  Future<void> _saveCurrentPath() async {
    if (_prefs == null) return;

    if (_currentPath != null) {
      await _prefs!.setString(_currentPathKey, jsonEncode(_currentPath!.toJson()));
    } else {
      await _prefs!.remove(_currentPathKey);
    }
  }

  /// 生成个性化学习诊断
  Future<LearningDiagnosis> generateDiagnosis() async {
    await initialize();
    await _analyticsService.initialize();

    final analytics = await _analyticsService.getAnalytics();

    // 分析技能水平
    final skillLevels = <String, double>{};

    // 根据学习时间计算技能水平
    final activityTime = analytics.activityTime;
    final totalTime = analytics.totalStudyMinutes;

    for (final activity in activityTime.entries) {
      final ratio = totalTime > 0 ? activity.value / totalTime : 0.0;
      final skillName = _getActivitySkillName(activity.key);
      // 简化的技能水平计算：基于投入时间
      skillLevels[skillName] = (ratio * 2).clamp(0.0, 1.0);
    }

    // 识别弱项和强项
    final weakPoints = <String>[];
    final strongPoints = <String>[];

    skillLevels.forEach((skill, level) {
      if (level < 0.3) {
        weakPoints.add(skill);
      } else if (level > 0.7) {
        strongPoints.add(skill);
      }
    });

    // 生成推荐
    final recommendations = _generateRecommendations(skillLevels, weakPoints);

    return LearningDiagnosis(
      skillLevels: skillLevels,
      weakPoints: weakPoints,
      strongPoints: strongPoints,
      recommendations: recommendations,
    );
  }

  /// 生成个性化学习路径
  Future<LearningPath> generatePersonalizedPath({
    required LearningGoalType goalType,
    required DifficultyLevel difficulty,
  }) async {
    await initialize();

    final diagnosis = await generateDiagnosis();
    final phases = <LearningPhase>[];

    // 根据目标类型生成不同的阶段
    switch (goalType) {
      case LearningGoalType.vocabulary:
        phases.addAll(_generateVocabularyPath(difficulty, diagnosis));
        break;
      case LearningGoalType.grammar:
        phases.addAll(_generateGrammarPath(difficulty, diagnosis));
        break;
      case LearningGoalType.communication:
        phases.addAll(_generateCommunicationPath(difficulty, diagnosis));
        break;
      case LearningGoalType.examPreparation:
        phases.addAll(_generateExamPrepPath(difficulty, diagnosis));
        break;
      case LearningGoalType.skillImprovement:
        phases.addAll(_generateSkillImprovementPath(difficulty, diagnosis));
        break;
    }

    final totalMinutes = phases.fold<int>(
      0,
      (sum, phase) => sum + phase.totalEstimatedMinutes,
    );

    final estimatedDays = (totalMinutes / 60).ceil() * 7; // 假设每天1小时

    final path = LearningPath(
      id: 'path_${DateTime.now().millisecondsSinceEpoch}',
      name: _getPathName(goalType, difficulty),
      description: _getPathDescription(goalType, difficulty),
      goalType: goalType,
      difficulty: difficulty,
      estimatedDays: estimatedDays,
      totalEstimatedMinutes: totalMinutes,
      phases: phases,
      createdAt: DateTime.now(),
      progress: 0.0,
    );

    // 添加到路径列表
    _paths.add(path);
    await _savePaths();

    return path;
  }

  /// 生成词汇学习路径
  List<LearningPhase> _generateVocabularyPath(
    DifficultyLevel difficulty,
    LearningDiagnosis diagnosis,
  ) {
    final phases = <LearningPhase>[];

    // 阶段1: 基础词汇
    phases.add(LearningPhase(
      id: 'vocab_phase_1',
      title: '基础词汇学习',
      description: '掌握日常生活中最常用的词汇',
      order: 1,
      isLocked: false,
      isCompleted: false,
      steps: [
        LearningStep(
          id: 'vocab_step_1_1',
          title: '日常问候词汇',
          description: '学习基本的问候和自我介绍词汇',
          resourceType: ResourceType.vocabulary,
          resourceId: 'greetings_vocab',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
        LearningStep(
          id: 'vocab_step_1_2',
          title: '数字和时间',
          description: '学习数字、日期和时间表达',
          resourceType: ResourceType.vocabulary,
          resourceId: 'numbers_time_vocab',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
        LearningStep(
          id: 'vocab_step_1_3',
          title: '家庭成员',
          description: '学习家庭成员称谓',
          resourceType: ResourceType.vocabulary,
          resourceId: 'family_vocab',
          estimatedMinutes: 20,
          isCompleted: false,
        ),
      ],
    ));

    // 阶段2: 主题词汇
    phases.add(LearningPhase(
      id: 'vocab_phase_2',
      title: '主题词汇扩展',
      description: '按主题扩展词汇量',
      order: 2,
      isLocked: true,
      isCompleted: false,
      steps: [
        LearningStep(
          id: 'vocab_step_2_1',
          title: '食物和饮料',
          description: '餐厅和食物相关词汇',
          resourceType: ResourceType.vocabulary,
          resourceId: 'food_vocab',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
        LearningStep(
          id: 'vocab_step_2_2',
          title: '交通和出行',
          description: '交通工具和出行词汇',
          resourceType: ResourceType.vocabulary,
          resourceId: 'transport_vocab',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
      ],
    ));

    // 阶段3: 高级词汇
    if (difficulty == DifficultyLevel.intermediate ||
        difficulty == DifficultyLevel.advanced) {
      phases.add(LearningPhase(
        id: 'vocab_phase_3',
        title: '高级词汇掌握',
        description: '学习更抽象和专业的词汇',
        order: 3,
        isLocked: true,
        isCompleted: false,
        steps: [
          LearningStep(
            id: 'vocab_step_3_1',
            title: '抽象概念',
            description: '学习表达抽象概念的词汇',
            resourceType: ResourceType.vocabulary,
            resourceId: 'abstract_vocab',
            estimatedMinutes: 40,
            isCompleted: false,
          ),
        ],
      ));
    }

    return phases;
  }

  /// 生成语法学习路径
  List<LearningPhase> _generateGrammarPath(
    DifficultyLevel difficulty,
    LearningDiagnosis diagnosis,
  ) {
    final phases = <LearningPhase>[];

    // 阶段1: 基础语法
    phases.add(LearningPhase(
      id: 'grammar_phase_1',
      title: '基础语法',
      description: '掌握德语基础语法规则',
      order: 1,
      isLocked: false,
      isCompleted: false,
      steps: [
        LearningStep(
          id: 'grammar_step_1_1',
          title: '动词变位（现在时）',
          description: '学习规则动词和不规则动词的变位',
          resourceType: ResourceType.grammar,
          resourceId: 'verb_conjugation',
          estimatedMinutes: 45,
          isCompleted: false,
        ),
        LearningStep(
          id: 'grammar_step_1_2',
          title: '名词的性和格',
          description: '学习名词的性和四个格的变化',
          resourceType: ResourceT ype.grammar,
          resourceId: 'noun_cases',
          estimatedMinutes: 45,
          isCompleted: false,
        ),
        LearningStep(
          id: 'grammar_step_1_3',
          title: '冠词的使用',
          description: '定冠词、不定冠词和否定冠词',
          resourceType: ResourceType.grammar,
          resourceId: 'articles',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
      ],
    ));

    // 阶段2: 中级语法
    if (difficulty != DifficultyLevel.beginner) {
      phases.add(LearningPhase(
        id: 'grammar_phase_2',
        title: '中级语法',
        description: '学习更复杂的语法结构',
        order: 2,
        isLocked: true,
        isCompleted: false,
        steps: [
          LearningStep(
            id: 'grammar_step_2_1',
            title: '完成时',
            description: '学习现在完成时和过去完成时',
            resourceType: ResourceType.grammar,
            resourceId: 'perfect_tenses',
            estimatedMinutes: 45,
            isCompleted: false,
          ),
          LearningStep(
            id: 'grammar_step_2_2',
            title: '形容词变格',
            description: '学习形容词的弱变化、强变化和混合变化',
            resourceType: ResourceType.grammar,
            resourceId: 'adjective_declension',
            estimatedMinutes: 40,
            isCompleted: false,
          ),
          LearningStep(
            id: 'grammar_step_2_3',
            title: '介词',
            description: '学习介词的用法和格支配',
            resourceType: ResourceType.grammar,
            resourceId: 'prepositions',
            estimatedMinutes: 45,
            isCompleted: false,
          ),
        ],
      ));
    }

    return phases;
  }

  /// 生成交际学习路径
  List<LearningPhase> _generateCommunicationPath(
    DifficultyLevel difficulty,
    LearningDiagnosis diagnosis,
  ) {
    final phases = <LearningPhase>[];

    // 阶段1: 基础对话
    phases.add(LearningPhase(
      id: 'comm_phase_1',
      title: '基础对话',
      description: '掌握日常交际对话',
      order: 1,
      isLocked: false,
      isCompleted: false,
      steps: [
        LearningStep(
          id: 'comm_step_1_1',
          title: '自我介绍',
          description: '学习如何介绍自己和他人',
          resourceType: ResourceType.speaking,
          resourceId: 'self_introduction',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
        LearningStep(
          id: 'comm_step_1_2',
          title: '问路和指路',
          description: '学习询问和指示方向',
          resourceType: ResourceT ype.listening,
          resourceId: 'asking_directions',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
        LearningStep(
          id: 'comm_step_1_3',
          title: '购物对话',
          description: '学习在商店购物的对话',
          resourceType: ResourceType.speaking,
          resourceId: 'shopping_dialogue',
          estimatedMinutes: 30,
          isCompleted: false,
        ),
      ],
    ));

    return phases;
  }

  /// 生成考试准备路径
  List<LearningPhase> _generateExamPrepPath(
    DifficultyLevel difficulty,
    LearningDiagnosis diagnosis,
  ) {
    final phases = <LearningPhase>[];

    // 阶段1: 基础技能训练
    phases.add(LearningPhase(
      id: 'exam_phase_1',
      title: '基础技能训练',
      description: '听说读写四项基础技能训练',
      order: 1,
      isLocked: false,
      isCompleted: false,
      steps: [
        LearningStep(
          id: 'exam_step_1_1',
          title: '听力练习',
          description: '完成5个听力练习',
          resourceType: ResourceType.listening,
          resourceId: 'listening_practice_1',
          estimatedMinutes: 60,
          isCompleted: false,
        ),
        LearningStep(
          id: 'exam_step_1_2',
          title: '阅读练习',
          description: '完成3篇阅读理解',
          resourceType: ResourceType.reading,
          resourceId: 'reading_practice_1',
          estimatedMinutes: 45,
          isCompleted: false,
        ),
        LearningStep(
          id: 'exam_step_1_3',
          title: '写作练习',
          description: '完成2篇写作任务',
          resourceType: ResourceType.writing,
          resourceId: 'writing_practice_1',
          estimatedMinutes: 60,
          isCompleted: false,
        ),
      ],
    ));

    // 阶段2: 模拟测试
    phases.add(LearningPhase(
      id: 'exam_phase_2',
      title: '模拟测试',
      description: '进行完整的模拟考试',
      order: 2,
      isLocked: true,
      isCompleted: false,
      steps: [
        LearningStep(
          id: 'exam_step_2_1',
          title: '模拟考试1',
          description: '完成第一套模拟试题',
          resourceType: ResourceType.test,
          resourceId: 'mock_exam_1',
          estimatedMinutes: 180,
          isCompleted: false,
        ),
      ],
    ));

    return phases;
  }

  /// 生成技能提升路径
  List<LearningPhase> _generateSkillImprovementPath(
    DifficultyLevel difficulty,
    LearningDiagnosis diagnosis,
  ) {
    final phases = <LearningPhase>[];

    // 根据弱项生成针对性的学习内容
    for (final weakPoint in diagnosis.weakPoints) {
      phases.add(LearningPhase(
        id: 'skill_${weakPoint}_phase',
        title: '提升$weakPoint能力',
        description: '针对$weakPoint的专项训练',
        order: phases.length + 1,
        isLocked: phases.isNotEmpty,
        isCompleted: false,
        steps: [
          LearningStep(
            id: 'skill_${weakPoint}_step_1',
            title: '${weakPoint}基础训练',
            description: '完成${weakPoint}的基础练习',
            resourceType: _getResourceTypeFromSkill(weakPoint),
            resourceId: '${weakPoint}_basic',
            estimatedMinutes: 30,
            isCompleted: false,
          ),
          LearningStep(
            id: 'skill_${weakPoint}_step_2',
            title: '${weakPoint}进阶训练',
            description: '完成${weakPoint}的进阶练习',
            resourceType: _getResourceTypeFromSkill(weakPoint),
            resourceId: '${weakPoint}_advanced',
            estimatedMinutes: 40,
            isCompleted: false,
          ),
        ],
      ));
    }

    return phases;
  }

  /// 设置当前学习路径
  Future<void> setCurrentPath(LearningPath path) async {
    await initialize();

    _currentPath = path;
    await _saveCurrentPath();
  }

  /// 获取当前学习路径
  LearningPath? getCurrentPath() {
    return _currentPath;
  }

  /// 更新步骤完成状态
  Future<void> updateStepProgress({
    required String pathId,
    required String phaseId,
    required String stepId,
    required bool isCompleted,
    double? score,
  }) async {
    await initialize();

    final pathIndex = _paths.indexWhere((p) => p.id == pathId);
    if (pathIndex == -1) return;

    final path = _paths[pathIndex];
    final phaseIndex = path.phases.indexWhere((p) => p.id == phaseId);
    if (phaseIndex == -1) return;

    final phase = path.phases[phaseIndex];
    final stepIndex = phase.steps.indexWhere((s) => s.id == stepId);
    if (stepIndex == -1) return;

    // 更新步骤
    final updatedStep = LearningStep(
      id: phase.steps[stepIndex].id,
      title: phase.steps[stepIndex].title,
      description: phase.steps[stepIndex].description,
      resourceType: phase.steps[stepIndex].resourceType,
      resourceId: phase.steps[stepIndex].resourceId,
      estimatedMinutes: phase.steps[stepIndex].estimatedMinutes,
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
      score: score,
    );

    final updatedSteps = List<LearningStep>.from(phase.steps);
    updatedSteps[stepIndex] = updatedStep;

    // 更新阶段
    final updatedPhase = LearningPhase(
      id: phase.id,
      title: phase.title,
      description: phase.description,
      order: phase.order,
      steps: updatedSteps,
      isLocked: phase.isLocked,
      isCompleted: updatedSteps.every((s) => s.isCompleted),
    );

    final updatedPhases = List<LearningPhase>.from(path.phases);
    updatedPhases[phaseIndex] = updatedPhase;

    // 更新路径
    final totalSteps = updatedPhases.fold<int>(
      0,
      (sum, p) => sum + p.steps.length,
    );
    final completedSteps = updatedPhases.fold<int>(
      0,
      (sum, p) => sum + p.steps.where((s) => s.isCompleted).length,
    );

    final updatedPath = LearningPath(
      id: path.id,
      name: path.name,
      description: path.description,
      goalType: path.goalType,
      difficulty: path.difficulty,
      estimatedDays: path.estimatedDays,
      totalEstimatedMinutes: path.totalEstimatedMinutes,
      phases: updatedPhases,
      createdAt: path.createdAt,
      startedAt: path.startedAt,
      completedAt: completedSteps == totalSteps ? DateTime.now() : path.completedAt,
      progress: totalSteps > 0 ? completedSteps / totalSteps : 0.0,
    );

    _paths[pathIndex] = updatedPath;
    if (_currentPath?.id == pathId) {
      _currentPath = updatedPath;
      await _saveCurrentPath();
    }

    await _savePaths();

    // 解锁下一阶段
    if (updatedPhase.isCompleted && phaseIndex < updatedPhases.length - 1) {
      final nextPhase = updatedPhases[phaseIndex + 1];
      if (nextPhase.isLocked) {
        final unlockedPhase = LearningPhase(
          id: nextPhase.id,
          title: nextPhase.title,
          description: nextPhase.description,
          order: nextPhase.order,
          steps: nextPhase.steps,
          isLocked: false,
          isCompleted: nextPhase.isCompleted,
        );
        updatedPhases[phaseIndex + 1] = unlockedPhase;

        final finalPath = LearningPath(
          id: updatedPath.id,
          name: updatedPath.name,
          description: updatedPath.description,
          goalType: updatedPath.goalType,
          difficulty: updatedPath.difficulty,
          estimatedDays: updatedPath.estimatedDays,
          totalEstimatedMinutes: updatedPath.totalEstimatedMinutes,
          phases: updatedPhases,
          createdAt: updatedPath.createdAt,
          startedAt: updatedPath.startedAt,
          completedAt: updatedPath.completedAt,
          progress: updatedPath.progress,
        );

        _paths[pathIndex] = finalPath;
        if (_currentPath?.id == pathId) {
          _currentPath = finalPath;
          await _saveCurrentPath();
        }

        await _savePaths();
      }
    }
  }

  /// 获取所有学习路径
  List<LearningPath> getAllPaths() {
    return List.from(_paths);
  }

  /// 生成推荐
  List<LearningRecommendation> _generateRecommendations(
    Map<String, double> skillLevels,
    List<String> weakPoints,
  ) {
    final recommendations = <LearningRecommendation>[];

    // 根据弱项生成推荐
    for (final weakPoint in weakPoints) {
      recommendations.add(LearningRecommendation(
        id: 'rec_${weakPoint}_1',
        title: '提升$weakPoint能力',
        description: '针对$weakPoint的专项练习',
        resourceType: _getResourceTypeFromSkill(weakPoint),
        resourceId: '${weakPoint}_practice',
        reason: '检测到$weakPoint较为薄弱，建议加强练习',
        priority: 0.8,
        estimatedMinutes: 30,
      ));
    }

    return recommendations;
  }

  String _getActivitySkillName(LearningActivityType activityType) {
    return switch (activityType) {
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

  ResourceType _getResourceTypeFromSkill(String skill) {
    return switch (skill) {
      '词汇' => ResourceType.vocabulary,
      '语法' => ResourceType.grammar,
      '阅读' => ResourceType.reading,
      '听力' => ResourceType.listening,
      '写作' => ResourceType.writing,
      '口语' => ResourceType.speaking,
      _ => ResourceType.vocabulary,
    };
  }

  String _getPathName(LearningGoalType goalType, DifficultyLevel difficulty) {
    final goalName = switch (goalType) {
      LearningGoalType.vocabulary => '词汇提升',
      LearningGoalType.grammar => '语法精通',
      LearningGoalType.communication => '交际能力',
      LearningGoalType.examPreparation => '考试准备',
      LearningGoalType.skillImprovement => '技能提升',
    };

    final difficultyName = switch (difficulty) {
      DifficultyLevel.beginner => '初级',
      DifficultyLevel.intermediate => '中级',
      DifficultyLevel.advanced => '高级',
    };

    return '$goalName-$difficultyName路径';
  }

  String _getPathDescription(LearningGoalType goalType, DifficultyLevel difficulty) {
    return '针对${_getPathName(goalType, difficulty)}的个性化学习计划';
  }
}
