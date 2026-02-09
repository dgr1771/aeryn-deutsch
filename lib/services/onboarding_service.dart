/// 新手引导服务
///
/// 管理用户的新手引导流程
library;

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../data/placement_test_data.dart';

/// 新手引导服务
class OnboardingService {
  // 单例模式
  OnboardingService._private();
  static final OnboardingService instance = OnboardingService._private();

  // SharedPreferences keys
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyOnboardingData = 'onboarding_data';
  static const String _keyUserProfile = 'user_profile';

  OnboardingData? _currentOnboardingData;
  UserProfile? _userProfile;

  /// 获取当前引导数据
  OnboardingData? get currentOnboardingData => _currentOnboardingData;

  /// 获取用户档案
  UserProfile? get userProfile => _userProfile;

  /// 是否已完成新手引导
  bool get hasCompletedOnboarding => _userProfile?.hasCompletedOnboarding ?? false;

  /// 初始化服务
  Future<void> initialize() async {
    await _loadOnboardingData();
    await _loadUserProfile();
  }

  /// 从本地加载引导数据
  Future<void> _loadOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = prefs.getString(_keyOnboardingData);
    if (dataJson != null) {
      // TODO: 解析JSON
      _currentOnboardingData = OnboardingData(
        currentStep: OnboardingStep.welcome,
      );
    }
  }

  /// 从本地加载用户档案
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_keyUserProfile);
    if (profileJson != null) {
      // TODO: 解析JSON
    }
  }

  /// 开始新手引导
  Future<void> startOnboarding() async {
    _currentOnboardingData = OnboardingData(
      currentStep: OnboardingStep.welcome,
    );
    await _saveOnboardingData();
  }

  /// 更新引导数据
  Future<void> updateOnboardingData(OnboardingData data) async {
    _currentOnboardingData = data;
    await _saveOnboardingData();
  }

  /// 保存引导数据到本地
  Future<void> _saveOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentOnboardingData != null) {
      // TODO: 序列化为JSON
      await prefs.setString(_keyOnboardingData, '');
    }
  }

  /// 完成新手引导
  Future<UserProfile> completeOnboarding() async {
    if (_currentOnboardingData == null ||
        !_currentOnboardingData!.isComplete) {
      throw Exception('Onboarding data is incomplete');
    }

    // 创建用户档案
    final profile = UserProfile.createDefault(
      userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
      primaryGoal: _currentOnboardingData!.selectedGoal!,
      targetLevel: _currentOnboardingData!.targetLevel!,
      learningStyle: _currentOnboardingData!.learningStyle!,
      dailyStudyTime: _currentOnboardingData!.dailyStudyTime!,
      initialLevel: _currentOnboardingData!.assessedLevel,
      targetDate: _currentOnboardingData!.examDate,
      preferredTopics: _currentOnboardingData!.preferredTopics,
    );

    _userProfile = profile;
    await _saveUserProfile(profile);

    // 标记引导完成
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasCompletedOnboarding, true);

    return profile;
  }

  /// 保存用户档案
  Future<void> _saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final json = profile.toJson();
    await prefs.setString(_keyUserProfile, json.toString());
  }

  /// 重置新手引导
  Future<void> resetOnboarding() async {
    _currentOnboardingData = null;
    _userProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasCompletedOnboarding);
    await prefs.remove(_keyOnboardingData);
    await prefs.remove(_keyUserProfile);
  }

  /// 获取推荐学习计划
  LearningPlan getRecommendedPlan() {
    if (_userProfile == null) {
      return LearningPlan.getDefault();
    }

    return LearningPlan.generateForProfile(_userProfile!);
  }
}

/// 学习计划
class LearningPlan {
  final String title;
  final String description;
  final int dailyMinutes;
  final int estimatedDaysToTarget;
  final List<DailyTask> dailyTasks;
  final List<Milestone> milestones;
  final DateTime startDate;
  final DateTime? targetDate;

  const LearningPlan({
    required this.title,
    required this.description,
    required this.dailyMinutes,
    required this.estimatedDaysToTarget,
    required this.dailyTasks,
    required this.milestones,
    required this.startDate,
    this.targetDate,
  });

  /// 为用户档案生成计划
  factory LearningPlan.generateForProfile(UserProfile profile) {
    final dailyMinutes = switch (profile.dailyStudyTime) {
      DailyStudyTime.fiveToTen => 10,
      DailyStudyTime.tenToTwenty => 15,
      DailyStudyTime.twentyToThirty => 25,
      DailyStudyTime.thirtyToSixty => 45,
      DailyStudyTime.moreThanSixty => 75,
    };

    final estimatedDays = profile.estimatedDaysToTarget;
    final startDate = DateTime.now();
    final targetDate = profile.targetDate != null
        ? profile.targetDate!
        : startDate.add(Duration(days: estimatedDays));

    // 每日任务
    final dailyTasks = _generateDailyTasks(profile);

    // 里程碑
    final milestones = _generateMilestones(profile, targetDate);

    return LearningPlan(
      title: '我的德语学习计划',
      description: '目标：${profile.goalDescription}',
      dailyMinutes: dailyMinutes,
      estimatedDaysToTarget: estimatedDays,
      dailyTasks: dailyTasks,
      milestones: milestones,
      startDate: startDate,
      targetDate: targetDate,
    );
  }

  /// 获取默认计划
  static LearningPlan getDefault() {
    return LearningPlan(
      title: '我的德语学习计划',
      description: '达到A1水平',
      dailyMinutes: 20,
      estimatedDaysToTarget: 90,
      dailyTasks: [
        DailyTask(
          id: 'vocab',
          title: '词汇学习',
          description: '学习10个新单词',
          durationMinutes: 10,
          type: TaskType.vocabulary,
        ),
        DailyTask(
          id: 'reading',
          title: '阅读练习',
          description: '阅读1篇短文',
          durationMinutes: 10,
          type: TaskType.reading,
        ),
      ],
      milestones: [
        Milestone(
          title: '学会100个单词',
          description: '完成第一阶段词汇学习',
          targetDays: 30,
        ),
        Milestone(
          title: '完成A1水平',
          description: '达到基础德语水平',
          targetDays: 90,
        ),
      ],
      startDate: DateTime.now(),
      targetDate: DateTime.now().add(const Duration(days: 90)),
    );
  }

  /// 生成每日任务
  static List<DailyTask> _generateDailyTasks(UserProfile profile) {
    final tasks = <DailyTask>[];

    // 词汇学习
    tasks.add(DailyTask(
      id: 'vocab',
      title: '词汇学习',
      description: '学习${_getVocabCount(profile.dailyStudyTime)}个新单词',
      durationMinutes: _getVocabDuration(profile.dailyStudyTime),
      type: TaskType.vocabulary,
    ));

    // 语法练习
    tasks.add(DailyTask(
      id: 'grammar',
      title: '语法练习',
      description: '完成5道语法题',
      durationMinutes: 5,
      type: TaskType.grammar,
    ));

    // 阅读理解
    if (profile.currentLevel.index >= LanguageLevel.A2.index) {
      tasks.add(DailyTask(
        id: 'reading',
        title: '阅读理解',
        description: '阅读1篇文章',
        durationMinutes: 10,
        type: TaskType.reading,
      ));
    }

    // 听力练习
    if (profile.currentLevel.index >= LanguageLevel.A2.index) {
      tasks.add(DailyTask(
        id: 'listening',
        title: '听力练习',
        description: '听一段德语音频',
        durationMinutes: 5,
        type: TaskType.listening,
      ));
    }

    return tasks;
  }

  /// 生成里程碑
  static List<Milestone> _generateMilestones(
    UserProfile profile,
    DateTime targetDate,
  ) {
    final milestones = <Milestone>[];
    final totalDays = profile.estimatedDaysToTarget;

    // 词汇里程碑
    milestones.add(Milestone(
      title: '掌握${profile.currentLevel.index * 500 + 500}个词汇',
      description: '完成词汇积累目标',
      targetDays: (totalDays * 0.3).round(),
    ));

    // 语法里程碑
    milestones.add(Milestone(
      title: '完成${profile.currentLevel.name}语法',
      description: '掌握该级别核心语法',
      targetDays: (totalDays * 0.5).round(),
    ));

    // 阅读里程碑
    milestones.add(Milestone(
      title: '阅读20篇文章',
      description: '提升阅读理解能力',
      targetDays: (totalDays * 0.7).round(),
    ));

    // 最终目标
    milestones.add(Milestone(
      title: '达到${profile.targetLevel.name}水平',
      description: profile.goalDescription,
      targetDays: totalDays,
    ));

    return milestones;
  }

  /// 获取每日词汇数量
  static int _getVocabCount(DailyStudyTime studyTime) {
    return switch (studyTime) {
      DailyStudyTime.fiveToTen => 5,
      DailyStudyTime.tenToTwenty => 10,
      DailyStudyTime.twentyToThirty => 15,
      DailyStudyTime.thirtyToSixty => 20,
      DailyStudyTime.moreThanSixty => 30,
    };
  }

  /// 获取词汇学习时长
  static int _getVocabDuration(DailyStudyTime studyTime) {
    return switch (studyTime) {
      DailyStudyTime.fiveToTen => 5,
      DailyStudyTime.tenToTwenty => 10,
      DailyStudyTime.twentyToThirty => 15,
      DailyStudyTime.thirtyToSixty => 20,
      DailyStudyTime.moreThanSixty => 30,
    };
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dailyMinutes': dailyMinutes,
      'estimatedDaysToTarget': estimatedDaysToTarget,
      'dailyTasks': dailyTasks.map((t) => t.toJson()).toList(),
      'milestones': milestones.map((m) => m.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
    };
  }
}

/// 每日任务
class DailyTask {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final TaskType type;
  final bool isCompleted;

  const DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.type,
    this.isCompleted = false,
  });

  /// 完成任务
  DailyTask complete() {
    return DailyTask(
      id: id,
      title: title,
      description: description,
      durationMinutes: durationMinutes,
      type: type,
      isCompleted: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'type': type.name,
      'isCompleted': isCompleted,
    };
  }
}

/// 任务类型
enum TaskType {
  vocabulary,
  grammar,
  reading,
  listening,
  writing,
  speaking,
}

/// 里程碑
class Milestone {
  final String title;
  final String description;
  final int targetDays;
  final bool isAchieved;

  const Milestone({
    required this.title,
    required this.description,
    required this.targetDays,
    this.isAchieved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'targetDays': targetDays,
      'isAchieved': isAchieved,
    };
  }
}
