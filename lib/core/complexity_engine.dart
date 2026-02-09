import 'grammar_engine.dart';

/// 复杂度分析引擎
///
/// 负责检测文本难度等级并实现"向下兼容"逻辑
class ComplexityEngine {
  /// 分析文本的语言等级
  ///
  /// 算法逻辑：
  /// - 嵌套深度 > 2 层 → C1
  /// - 被动语态密度 > 30% → B2+
  /// - 从句比例 > 40% → B2
  static LanguageLevel analyzeLevel(String text) {
    if (text.isEmpty) return LanguageLevel.A1;

    int nestedDepth = 0;
    int passiveVoiceCount = 0;
    int subordinateClauseCount = 0;
    int totalSentences = 0;

    // 简单分析（实际应使用 spaCy）
    final sentences = text.split(RegExp(r'[.!?]'));

    for (final sentence in sentences) {
      if (sentence.trim().isEmpty) continue;
      totalSentences++;

      // 检测从句（含 weil, dass, wenn 等）
      if (RegExp(r'\b(weil|dass|wenn|ob|obwohl|da|während|nachdem)\b', caseSensitive: false)
          .hasMatch(sentence)) {
        subordinateClauseCount++;
        nestedDepth++;
      }

      // 检测被动语态（werden + 过去分词）
      if (RegExp(r'\bwerden\b.*\b/ge?\w{2,4}\b', caseSensitive: false)
          .hasMatch(sentence)) {
        passiveVoiceCount++;
      }
    }

    // 计算密度
    final subordinateRatio = totalSentences > 0
        ? subordinateClauseCount / totalSentences
        : 0.0;
    final passiveRatio = totalSentences > 0
        ? passiveVoiceCount / totalSentences
        : 0.0;

    // 判定等级
    if (nestedDepth >= 2 || passiveRatio > 0.4 || subordinateRatio > 0.5) {
      return LanguageLevel.C1;
    }
    if (passiveRatio > 0.2 || subordinateRatio > 0.3) {
      return LanguageLevel.B2;
    }
    if (subordinateRatio > 0.1) {
      return LanguageLevel.B1;
    }
    if (text.length > 100) {
      return LanguageLevel.A2;
    }
    return LanguageLevel.A1;
  }

  /// 处理输入：高维向下兼容
  ///
  /// 如果输入是 C1/C2 级别，不要求用户掌握，而是提供"降维视图"
  static ProcessingResult processInput(
    String text,
    LanguageLevel userTarget,
  ) {
    final currentInputLevel = analyzeLevel(text);

    if (currentInputLevel.index > userTarget.index) {
      // 触发【降维打击】逻辑
      return ProcessingResult(
        originalLevel: currentInputLevel,
        userLevel: userTarget,
        needsDecomposition: true,
        message: '检测到超纲 (${_levelToString(currentInputLevel)}) 结构：启动【解剖刀】进行 ${_levelToString(userTarget)} 级拆解',
        strategy: ProcessingStrategy.decompose,
      );
    } else {
      // 触发【实战巩固】逻辑
      return ProcessingResult(
        originalLevel: currentInputLevel,
        userLevel: userTarget,
        needsDecomposition: false,
        message: '目标级别 (${_levelToString(userTarget)}) 匹配：启动【实战注入】',
        strategy: ProcessingStrategy.practice,
      );
    }
  }

  /// 获取等级的友好名称
  static String _levelToString(LanguageLevel level) {
    return level.toString().split('.').last.toUpperCase();
  }

  /// 估算达到目标等级所需时间（小时）
  ///
  /// 基于欧洲语言共同框架（CEFR）标准
  static int estimateHoursToLevel(LanguageLevel from, LanguageLevel to) {
    final hoursPerLevel = {
      LanguageLevel.A1: 100,
      LanguageLevel.A2: 100,
      LanguageLevel.B1: 200,
      LanguageLevel.B2: 200,
      LanguageLevel.C1: 200,
      LanguageLevel.C2: 200,
    };

    int total = 0;
    for (int i = from.index; i < to.index; i++) {
      final level = LanguageLevel.values[i];
      total += hoursPerLevel[level] ?? 0;
    }

    return total;
  }

  /// 根据当前学习速度预测达到目标的时间
  ///
  /// 假设每天学习 studyHoursPerDay 小时
  static DateTime predictTargetDate(
    LanguageLevel currentLevel,
    LanguageLevel targetLevel,
    int studyHoursPerDay,
  ) {
    final remainingHours = estimateHoursToLevel(currentLevel, targetLevel);
    final daysNeeded = (remainingHours / studyHoursPerDay).ceil();

    return DateTime.now().add(Duration(days: daysNeeded));
  }
}

/// 处理结果
class ProcessingResult {
  final LanguageLevel originalLevel;
  final LanguageLevel userLevel;
  final bool needsDecomposition;
  final String message;
  final ProcessingStrategy strategy;

  ProcessingResult({
    required this.originalLevel,
    required this.userLevel,
    required this.needsDecomposition,
    required this.message,
    required this.strategy,
  });
}

/// 处理策略
enum ProcessingStrategy {
  decompose, // 降维拆解（C1/C2 → B2）
  practice,  // 实战巩固（匹配级别）
  skip,      // 跳过（低于目标级别）
}
