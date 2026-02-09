/// 难度自适应系统
///
/// 基于最近发展区理论(ZPD)动态调节学习难度
library;

import '../grammar_engine.dart';

/// 用户表现数据
class UserPerformance {
  final double recentAccuracy;          // 最近正确率
  final double averageResponseTime;     // 平均响应时间（秒）
  final int consecutiveErrors;          // 连续错误次数
  final int consecutiveSuccess;         // 连续成功次数
  final double sessionDifficulty;       // 当前会话难度
  final List<double> recentAccuracies;  // 最近10次正确率

  UserPerformance({
    required this.recentAccuracy,
    required this.averageResponseTime,
    this.consecutiveErrors = 0,
    this.consecutiveSuccess = 0,
    this.sessionDifficulty = 0.5,
    this.recentAccuracies = const [],
  });

  /// 计算趋势（改善、稳定、下降）
  PerformanceTrend getTrend() {
    if (recentAccuracies.length < 3) return PerformanceTrend.stable;

    final recent = recentAccuracies.take(3).reduce((a, b) => a + b) / 3;
    final older = recentAccuracies.skip(3).take(3).reduce((a, b) => a + b) / 3;

    if (recent - older > 0.1) return PerformanceTrend.improving;
    if (recent - older < -0.1) return PerformanceTrend.declining;
    return PerformanceTrend.stable;
  }

  /// 是否在心流状态
  bool get isInFlowState {
    return recentAccuracy >= 0.65 &&
           recentAccuracy <= 0.85 &&
           consecutiveErrors < 3;
  }

  /// 是否需要降低难度
  bool get needsLowerDifficulty {
    return recentAccuracy < 0.5 || consecutiveErrors >= 3;
  }

  /// 是否可以增加难度
  bool get canIncreaseDifficulty {
    return recentAccuracy > 0.85 && consecutiveSuccess >= 5;
  }
}

enum PerformanceTrend {
  improving,
  stable,
  declining,
}

/// 学习任务
class LearningTask {
  final String id;
  final String title;
  final LanguageLevel baseLevel;
  final double estimatedDifficulty;  // 0-1
  final List<String> requiredSkills;

  LearningTask({
    required this.id,
    required this.title,
    required this.baseLevel,
    required this.estimatedDifficulty,
    this.requiredSkills = const [],
  });

  /// 实际难度（考虑用户水平）
  double getActualDifficulty(double userLevel) {
    return (estimatedDifficulty - userLevel).abs();
  }
}

/// 难度调节器
class DifficultyAdapter {
  // 理想目标正确率（处于心流状态）
  static const double TARGET_ACCURACY = 0.75;
  static const double MIN_ACCURACY = 0.50;
  static const double MAX_ACCURACY = 0.90;

  // 最小/最大难度调整步长
  static const double MIN_ADJUSTMENT = 0.05;
  static const double MAX_ADJUSTMENT = 0.20;

  /// 计算最优难度
  double calculateOptimalDifficulty(UserPerformance perf) {
    double currentAccuracy = perf.recentAccuracy;
    double currentDifficulty = perf.sessionDifficulty;

    // 如果在心流状态，保持当前难度
    if (perf.isInFlowState) {
      return currentDifficulty;
    }

    double adjustment = 0.0;

    // 如果表现太好，增加难度
    if (perf.canIncreaseDifficulty) {
      adjustment = _calculateIncreaseAmount(perf);
    }
    // 如果表现太差，降低难度
    else if (perf.needsLowerDifficulty) {
      adjustment = -_calculateDecreaseAmount(perf);
    }
    // 平滑调整
    else {
      final diff = currentAccuracy - TARGET_ACCURACY;
      adjustment = diff * 0.3; // 缓慢调整
    }

    // 限制调整幅度
    adjustment = adjustment.clamp(-MAX_ADJUSTMENT, MAX_ADJUSTMENT);

    // 计算新难度
    double newDifficulty = currentDifficulty + adjustment;
    return newDifficulty.clamp(0.0, 1.0);
  }

  /// 计算增加幅度
  double _calculateIncreaseAmount(UserPerformance perf) {
    double baseAmount = MIN_ADJUSTMENT;

    // 根据连续成功次数增加
    baseAmount += (perf.consecutiveSuccess - 5) * 0.02;

    // 根据趋势调整
    if (perf.getTrend() == PerformanceTrend.improving) {
      baseAmount += 0.05;
    }

    return baseAmount.clamp(MIN_ADJUSTMENT, MAX_ADJUSTMENT);
  }

  /// 计算降低幅度
  double _calculateDecreaseAmount(UserPerformance perf) {
    double baseAmount = MIN_ADJUSTMENT;

    // 根据连续错误次数增加
    baseAmount += (perf.consecutiveErrors - 3) * 0.03;

    // 根据趋势调整
    if (perf.getTrend() == PerformanceTrend.declining) {
      baseAmount += 0.08;
    }

    return baseAmount.clamp(MIN_ADJUSTMENT, MAX_ADJUSTMENT);
  }

  /// 检查任务是否在最近发展区(ZPD)
  bool isInZPD(LearningTask task, double userLevel) {
    double taskDifficulty = task.estimatedDifficulty;

    // ZPD范围：用户水平±0.2
    double zpdLower = (userLevel - 0.2).clamp(0.0, 1.0);
    double zpdUpper = (userLevel + 0.2).clamp(0.0, 1.0);

    return taskDifficulty >= zpdLower && taskDifficulty <= zpdUpper;
  }

  /// 为用户推荐任务
  List<LearningTask> recommendTasks(
    List<LearningTask> availableTasks,
    double userLevel,
  ) {
    // 1. 筛选ZPD内的任务
    final zpdTasks = availableTasks
        .where((task) => isInZPD(task, userLevel))
        .toList();

    if (zpdTasks.isEmpty) {
      // 如果没有ZPD内的任务，返回最接近的
      final taskEntries = availableTasks
          .map((task) => MapEntry(
                task,
                (task.estimatedDifficulty - userLevel).abs(),
              ))
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      return taskEntries
          .take(5)
          .map((e) => e.key)
          .toList();
    }

    // 2. 按优先级排序
    zpdTasks.sort((a, b) {
      // 优先选择接近用户水平的任务
      final aDiff = (a.estimatedDifficulty - userLevel).abs();
      final bDiff = (b.estimatedDifficulty - userLevel).abs();

      return aDiff.compareTo(bDiff);
    });

    return zpdTasks.take(10).toList();
  }

  /// 调整任务难度
  LearningTask adjustTask(LearningTask task, double targetDifficulty) {
    // 这里简化处理，实际应该调整任务内容
    // 例如：减少选项、提供提示、简化词汇等

    return task; // 暂时返回原任务
  }

  /// 预测用户在该难度下的表现
  double predictPerformance(double userLevel, double taskDifficulty) {
    final difficulty = (taskDifficulty - userLevel).abs();

    if (difficulty <= 0.1) {
      return 0.85; // 简单
    } else if (difficulty <= 0.3) {
      return 0.75; // 适中
    } else if (difficulty <= 0.5) {
      return 0.60; // 困难
    } else {
      return 0.40; // 太难
    }
  }
}
