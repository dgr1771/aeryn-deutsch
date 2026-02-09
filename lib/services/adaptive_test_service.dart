/// 自适应水平测试服务
///
/// 实现智能自适应算法，根据用户表现动态调整测试难度
library;

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../core/grammar_engine.dart';
import '../data/adaptive_test_data.dart';

/// 测试模式
enum TestMode {
  adaptive,    // 自适应测试（6-12题）
  complete,    // 完整测试（20题）
  quick,       // 快速评估（3题）
}

/// 测试状态
class AdaptiveTestState {
  final int currentQuestionIndex;
  final LanguageLevel currentLevel;
  final int consecutiveCorrect;
  final int consecutiveWrong;
  final int totalCorrect;
  final int totalWrong;
  final List<Question> askedQuestions;
  final Map<String, String> answers;
  final bool isComplete;
  final LanguageLevel? finalLevel;
  final int? confidenceScore;

  const AdaptiveTestState({
    this.currentQuestionIndex = 0,
    this.currentLevel = LanguageLevel.A1,
    this.consecutiveCorrect = 0,
    this.consecutiveWrong = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.askedQuestions = const [],
    this.answers = const {},
    this.isComplete = false,
    this.finalLevel,
    this.confidenceScore,
  });

  AdaptiveTestState copyWith({
    int? currentQuestionIndex,
    LanguageLevel? currentLevel,
    int? consecutiveCorrect,
    int? consecutiveWrong,
    int? totalCorrect,
    int? totalWrong,
    List<Question>? askedQuestions,
    Map<String, String>? answers,
    bool? isComplete,
    LanguageLevel? finalLevel,
    int? confidenceScore,
  }) {
    return AdaptiveTestState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentLevel: currentLevel ?? this.currentLevel,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      consecutiveWrong: consecutiveWrong ?? this.consecutiveWrong,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      askedQuestions: askedQuestions ?? this.askedQuestions,
      answers: answers ?? this.answers,
      isComplete: isComplete ?? this.isComplete,
      finalLevel: finalLevel ?? this.finalLevel,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }
}

/// 自适应测试结果
class AdaptiveTestResult {
  final LanguageLevel assessedLevel;
  final int confidenceScore;          // 0-100，评估置信度
  final int totalQuestionsAsked;
  final int correctAnswers;
  final int wrongAnswers;
  final Duration duration;
  final List<Question> questionHistory;
  final Map<LanguageLevel, int> levelPerformance; // 每个级别的表现

  const AdaptiveTestResult({
    required this.assessedLevel,
    required this.confidenceScore,
    required this.totalQuestionsAsked,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.duration,
    required this.questionHistory,
    required this.levelPerformance,
  });

  /// 正确率
  double get accuracy => totalQuestionsAsked > 0
      ? correctAnswers / totalQuestionsAsked
      : 0.0;

  /// 获取详细反馈
  String get feedback {
    final accuracyPercent = (accuracy * 100).round();

    if (accuracyPercent >= 90) {
      return '太棒了！您在${assessedLevel.name}级别表现出色，正确率达到${accuracyPercent}%。建议继续当前级别的深入学习，并挑战更高难度。';
    } else if (accuracyPercent >= 75) {
      return '很好！您已经掌握了${assessedLevel.name}级别的大部分内容，正确率${accuracyPercent}%。建议巩固当前级别的薄弱环节。';
    } else if (accuracyPercent >= 60) {
      return '不错！您达到了${assessedLevel.name}水平，正确率${accuracyPercent}%。建议从当前级别的简单内容开始，逐步提升。';
    } else {
      return '建议从${assessedLevel.name}级别的基础内容开始系统学习。重点复习基础语法和核心词汇。';
    }
  }

  /// 获取推荐学习计划
  Map<String, dynamic> get recommendations {
    return {
      'level': assessedLevel.name,
      'confidence': confidenceScore,
      'accuracy': (accuracy * 100).round(),
      'focusAreas': _getFocusAreas(),
      'estimatedTimeToNext': _getEstimatedTimeToNext(),
    };
  }

  List<String> _getFocusAreas() {
    final areas = <String>[];

    // 根据错误率推荐重点学习领域
    levelPerformance.forEach((level, score) {
      if (score < 60) {
        areas.add('加强${level.name}级别的语法基础');
      } else if (score < 80) {
        areas.add('巩固${level.name}级别的词汇和表达');
      }
    });

    if (areas.isEmpty) {
      areas.add('继续保持当前学习节奏');
    }

    return areas;
  }

  String _getEstimatedTimeToNext() {
    final currentLevelIndex = assessedLevel.index;
    if (currentLevelIndex >= LanguageLevel.values.length - 1) {
      return '已达到高级水平，建议保持练习';
    }

    final nextLevel = LanguageLevel.values[currentLevelIndex + 1];
    final accuracyPercent = (accuracy * 100);

    if (accuracyPercent >= 90) {
      return '预计1-2个月可达到${nextLevel.name}水平';
    } else if (accuracyPercent >= 75) {
      return '预计2-4个月可达到${nextLevel.name}水平';
    } else {
      return '预计3-6个月可达到${nextLevel.name}水平';
    }
  }
}

/// 自适应测试服务
class AdaptiveTestService {
  // 单例模式
  AdaptiveTestService._private();
  static final AdaptiveTestService instance = AdaptiveTestService._private();

  // 配置常量
  static const int _minQuestions = 6;              // 最少题目数
  static const int _maxQuestions = 12;             // 最多题目数
  static const int _consecutiveCorrectToAdvance = 3;   // 连续对几题升级
  static const int _consecutiveWrongToDescend = 2;     // 连续错几题降级
  static const int _minConfidenceScore = 85;       // 最低置信度才能结束测试

  // 状态
  AdaptiveTestState _state = const AdaptiveTestState();
  final StreamController<AdaptiveTestState> _stateController =
      StreamController<AdaptiveTestState>.broadcast();
  DateTime? _testStartTime;
  final List<Question> _availableQuestions = [];

  // SharedPreferences keys
  static const String _keyTestHistory = 'adaptive_test_history';
  static const String _keyLastTestDate = 'last_adaptive_test_date';

  /// 获取状态流
  Stream<AdaptiveTestState> get stateStream => _stateController.stream;

  /// 获取当前状态
  AdaptiveTestState get state => _state;

  /// 初始化测试
  void initializeTest({
    LanguageLevel startLevel = LanguageLevel.A1,
    TestMode mode = TestMode.adaptive,
  }) {
    // 重置状态
    _state = AdaptiveTestState(
      currentLevel: startLevel,
      currentQuestionIndex: 0,
      askedQuestions: [],
      answers: {},
    );

    // 初始化题库
    _availableQuestions.clear();
    allAdaptiveTestQuestions.forEach((level, questions) {
      _availableQuestions.addAll(questions);
    });

    // 记录开始时间
    _testStartTime = DateTime.now();

    // 广播状态
    _stateController.add(_state);
  }

  /// 获取下一道题目
  Question? getNextQuestion() {
    if (_state.isComplete) {
      return null;
    }

    // 检查是否应该结束测试
    if (_shouldEndTest()) {
      _completeTest();
      return null;
    }

    // 根据当前级别获取题目
    final questions = getQuestionsForLevel(_state.currentLevel);
    final available = questions.where((q) =>
        !_state.askedQuestions.any((asked) => asked.id == q.id)).toList();

    if (available.isEmpty) {
      // 当前级别题目用完，返回其他级别的题目
      final allQuestions = allAdaptiveTestQuestions.values
          .expand((qs) => qs)
          .toList();
      final remaining = allQuestions.where((q) =>
          !_state.askedQuestions.any((asked) => asked.id == q.id)).toList();

      if (remaining.isEmpty) {
        _completeTest();
        return null;
      }

      return remaining.first;
    }

    // 随机选择一道题目
    final random = DateTime.now().millisecondsSinceEpoch % available.length;
    return available[random];
  }

  /// 提交答案
  Future<void> submitAnswer(String questionId, String answer) async {
    // 查找题目 - 先在已问列表中找，找不到就在可用题库中找
    Question? question;
    try {
      question = _state.askedQuestions
          .firstWhere((q) => q.id == questionId);
    } catch (e) {
      // 题目不在已问列表中，从题库中获取
      if (_availableQuestions.any((q) => q.id == questionId)) {
        question = _availableQuestions.firstWhere((q) => q.id == questionId);
      } else {
        throw Exception('Question not found: $questionId');
      }
    }

    final isCorrect = question.isAnswerCorrect(answer);

    // 更新统计
    final newAnswers = Map<String, String>.from(_state.answers);
    newAnswers[questionId] = answer;

    int newConsecutiveCorrect = _state.consecutiveCorrect;
    int newConsecutiveWrong = _state.consecutiveWrong;
    int newTotalCorrect = _state.totalCorrect;
    int newTotalWrong = _state.totalWrong;
    LanguageLevel newCurrentLevel = _state.currentLevel;

    if (isCorrect) {
      newConsecutiveCorrect++;
      newConsecutiveWrong = 0;
      newTotalCorrect++;

      // 检查是否应该升级
      if (newConsecutiveCorrect >= _consecutiveCorrectToAdvance &&
          _state.currentLevel.index < LanguageLevel.B2.index) {
        newCurrentLevel = LanguageLevel.values[_state.currentLevel.index + 1];
        newConsecutiveCorrect = 0; // 重置连续正确计数
      }
    } else {
      newConsecutiveWrong++;
      newConsecutiveCorrect = 0;
      newTotalWrong++;

      // 检查是否应该降级
      if (newConsecutiveWrong >= _consecutiveWrongToDescend &&
          _state.currentLevel.index > LanguageLevel.A1.index) {
        newCurrentLevel = LanguageLevel.values[_state.currentLevel.index - 1];
        newConsecutiveWrong = 0; // 重置连续错误计数
      }
    }

    // 更新状态
    _state = _state.copyWith(
      currentQuestionIndex: _state.currentQuestionIndex + 1,
      currentLevel: newCurrentLevel,
      consecutiveCorrect: newConsecutiveCorrect,
      consecutiveWrong: newConsecutiveWrong,
      totalCorrect: newTotalCorrect,
      totalWrong: newTotalWrong,
      answers: newAnswers,
    );

    // 添加题目到历史记录
    final updatedHistory = List<Question>.from(_state.askedQuestions)
      ..add(question);
    _state = _state.copyWith(askedQuestions: updatedHistory);

    // 广播状态更新
    _stateController.add(_state);

    // 检查是否应该结束测试
    if (_shouldEndTest()) {
      _completeTest();
    }
  }

  /// 判断是否应该结束测试
  bool _shouldEndTest() {
    final questionCount = _state.currentQuestionIndex;

    // 已经达到最大题目数
    if (questionCount >= _maxQuestions) {
      return true;
    }

    // 至少回答了最少题目数，且置信度足够
    if (questionCount >= _minQuestions) {
      final confidence = _calculateConfidence();
      if (confidence >= _minConfidenceScore) {
        return true;
      }
    }

    return false;
  }

  /// 计算置信度
  int _calculateConfidence() {
    final questionCount = _state.currentQuestionIndex;
    if (questionCount < _minQuestions) return 0;

    // 基于连续正确/错误次数和总体表现
    final accuracy = _state.totalCorrect /
        (_state.totalCorrect + _state.totalWrong);

    final stabilityBonus = (_state.consecutiveCorrect * 5).clamp(0, 15);
    final questionBonus = ((questionCount - _minQuestions) * 3).clamp(0, 15);

    final confidence = (accuracy * 60 + stabilityBonus + questionBonus).round();
    return confidence.clamp(0, 100);
  }

  /// 完成测试
  void _completeTest() {
    if (_state.isComplete) return;

    final assessedLevel = _determineFinalLevel();
    final confidence = _calculateConfidence();
    final duration = _testStartTime != null
        ? DateTime.now().difference(_testStartTime!)
        : Duration.zero;

    final levelPerformance = _calculateLevelPerformance();

    _state = _state.copyWith(
      isComplete: true,
      finalLevel: assessedLevel,
      confidenceScore: confidence,
    );

    // 保存测试历史
    _saveTestHistory(assessedLevel, confidence, duration);

    // 广播最终状态
    _stateController.add(_state);
  }

  /// 确定最终级别
  LanguageLevel _determineFinalLevel() {
    // 基于当前级别和表现确定最终级别
    final accuracy = _state.totalCorrect /
        (_state.totalCorrect + _state.totalWrong);

    if (accuracy >= 0.8) {
      // 如果正确率很高，可能级别可以更高
      if (_state.currentLevel.index < LanguageLevel.B2.index) {
        return _state.currentLevel;
      }
      return _state.currentLevel;
    } else if (accuracy >= 0.6) {
      return _state.currentLevel;
    } else {
      // 正确率较低，降低一个级别
      if (_state.currentLevel.index > LanguageLevel.A1.index) {
        return LanguageLevel.values[_state.currentLevel.index - 1];
      }
      return _state.currentLevel;
    }
  }

  /// 计算每个级别的表现
  Map<LanguageLevel, int> _calculateLevelPerformance() {
    final performance = <LanguageLevel, int>{};

    for (final level in [LanguageLevel.A1, LanguageLevel.A2, LanguageLevel.B1, LanguageLevel.B2]) {
      final levelQuestions = _state.askedQuestions
          .where((q) => q.targetLevel == level);
      final total = levelQuestions.length;
      final correct = levelQuestions.where((q) =>
          _state.answers[q.id] != null &&
          q.isAnswerCorrect(_state.answers[q.id]!)).length;

      if (total > 0) {
        performance[level] = ((correct / total) * 100).round();
      }
    }

    return performance;
  }

  /// 保存测试历史
  Future<void> _saveTestHistory(
    LanguageLevel level,
    int confidence,
    Duration duration,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // 保存测试日期
    await prefs.setString(_keyLastTestDate, DateTime.now().toIso8601String());

    // 保存测试历史
    final historyJson = prefs.getString(_keyTestHistory) ?? '[]';
    // TODO: 解析并添加新记录
    await prefs.setString(_keyTestHistory, historyJson);
  }

  /// 获取测试结果
  AdaptiveTestResult? getResult() {
    if (!_state.isComplete) return null;

    final duration = _testStartTime != null
        ? DateTime.now().difference(_testStartTime!)
        : Duration.zero;

    return AdaptiveTestResult(
      assessedLevel: _state.finalLevel!,
      confidenceScore: _state.confidenceScore!,
      totalQuestionsAsked: _state.currentQuestionIndex,
      correctAnswers: _state.totalCorrect,
      wrongAnswers: _state.totalWrong,
      duration: duration,
      questionHistory: List.from(_state.askedQuestions),
      levelPerformance: _calculateLevelPerformance(),
    );
  }

  /// 跳过测试，手动选择级别
  void skipTest(LanguageLevel selectedLevel) {
    _state = _state.copyWith(
      isComplete: true,
      finalLevel: selectedLevel,
      confidenceScore: 100, // 手动选择的置信度为100%
    );

    _stateController.add(_state);
  }

  /// 重置测试
  void resetTest() {
    _state = const AdaptiveTestState();
    _testStartTime = null;
    _availableQuestions.clear();
    _stateController.add(_state);
  }

  /// 检查是否可以进行重新测试
  Future<bool> canRetest() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTestStr = prefs.getString(_keyLastTestDate);

    if (lastTestStr == null) return true;

    final lastTest = DateTime.parse(lastTestStr);
    final daysSinceLastTest = DateTime.now().difference(lastTest).inDays;

    // 30天后可以重新测试
    return daysSinceLastTest >= 30;
  }

  /// 距离下次可测试的剩余天数
  Future<int> daysUntilRetest() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTestStr = prefs.getString(_keyLastTestDate);

    if (lastTestStr == null) return 0;

    final lastTest = DateTime.parse(lastTestStr);
    final daysSinceLastTest = DateTime.now().difference(lastTest).inDays;

    return (30 - daysSinceLastTest).clamp(0, 30);
  }

  /// 释放资源
  void dispose() {
    _stateController.close();
  }
}
