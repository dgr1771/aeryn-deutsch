/// i+1 输入控制器
///
/// 实现Krashen的输入假说（Input Hypothesis）
/// i = 当前水平，+1 = 略高于当前水平的可理解输入
library;

import 'text_difficulty_analyzer.dart';
import '../learning_path/skill_tree.dart';
import '../grammar_engine.dart';

/// i+1 控制参数
class I1ControlParameters {
  final double minUnknownRatio; // 最小未知词比例 (默认 0.05 = 5%)
  final double maxUnknownRatio; // 最大未知词比例 (默认 0.10 = 10%)
  final int minSentences; // 最少句子数
  final int maxSentences; // 最多句子数
  final double maxDifficultyIncrease; // 最大难度增幅

  const I1ControlParameters({
    this.minUnknownRatio = 0.05,
    this.maxUnknownRatio = 0.10,
    this.minSentences = 3,
    this.maxSentences = 20,
    this.maxDifficultyIncrease = 0.15,
  });
}

/// 文本适配结果
class TextAdaptationResult {
  final String adaptedText;
  final TextDifficultyScore difficulty;
  final double unknownWordRatio;
  final int adaptationLevel; // 0-未修改, 1-简化, 2-扩展

  const TextAdaptationResult({
    required this.adaptedText,
    required this.difficulty,
    required this.unknownWordRatio,
    required this.adaptationLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'adaptedText': adaptedText,
      'difficulty': difficulty.toJson(),
      'unknownWordRatio': unknownWordRatio,
      'adaptationLevel': adaptationLevel,
    };
  }
}

/// i+1 控制器
class I1Controller {
  final I1ControlParameters parameters;

  const I1Controller({
    this.parameters = const I1ControlParameters(),
  });

  /// 为用户选择合适的文本
  ///
  /// 根据用户当前水平，从文本库中选择符合i+1原则的文本
  TextAdaptationResult? selectOptimalText(
    String text,
    LanguageLevel userLevel,
    Set<String> knownWords,
  ) {
    // 1. 分析文本难度
    final difficulty = TextDifficultyAnalyzer.analyzeText(
      text,
      knownWords: knownWords,
      userLevel: userLevel,
    );

    // 2. 检查是否符合i+1原则
    if (difficulty.isSuitableForLevel(userLevel)) {
      // 计算未知词比例
      final words = TextDifficultyAnalyzer.analyzeText(text, knownWords: knownWords);
      final unknownRatio = difficulty.unknownWordRatio / 1000.0;

      if (unknownRatio >= parameters.minUnknownRatio &&
          unknownRatio <= parameters.maxUnknownRatio) {
        // 完美符合i+1
        return TextAdaptationResult(
          adaptedText: text,
          difficulty: difficulty,
          unknownWordRatio: unknownRatio,
          adaptationLevel: 0,
        );
      }
    }

    // 3. 如果不符合，需要调整
    return _adaptText(text, userLevel, knownWords, difficulty);
  }

  /// 调整文本以符合i+1原则
  TextAdaptationResult? _adaptText(
    String originalText,
    LanguageLevel userLevel,
    Set<String> knownWords,
    TextDifficultyScore currentDifficulty,
  ) {
    // 计算目标难度
    final targetLevelIndex = userLevel.index + 1; // i+1
    final targetLevel = targetLevelIndex < LanguageLevel.values.length
        ? LanguageLevel.values[targetLevelIndex]
        : LanguageLevel.C2;

    // 如果当前文本太难
    if (currentDifficulty.estimatedLevel.index > targetLevel.index) {
      return _simplifyText(originalText, userLevel, knownWords, currentDifficulty);
    }

    // 如果当前文本太简单
    if (currentDifficulty.estimatedLevel.index < userLevel.index) {
      return _enhanceText(originalText, userLevel, knownWords, currentDifficulty);
    }

    return null;
  }

  /// 简化过难的文本
  TextAdaptationResult _simplifyText(
    String text,
    LanguageLevel userLevel,
    Set<String> knownWords,
    TextDifficultyScore currentDifficulty,
  ) {
    // 策略1: 移除复杂的从句
    var simplified = _removeComplexClauses(text);

    // 策略2: 简化词汇
    simplified = _simplifyVocabulary(simplified, knownWords);

    // 策略3: 拆分长句
    simplified = _splitLongSentences(simplified);

    // 重新分析难度
    final newDifficulty = TextDifficultyAnalyzer.analyzeText(
      simplified,
      knownWords: knownWords,
      userLevel: userLevel,
    );

    final unknownRatio = newDifficulty.unknownWordRatio / 1000.0;

    return TextAdaptationResult(
      adaptedText: simplified,
      difficulty: newDifficulty,
      unknownWordRatio: unknownRatio,
      adaptationLevel: 1,
    );
  }

  /// 增强过简的文本
  TextAdaptationResult _enhanceText(
    String text,
    LanguageLevel userLevel,
    Set<String> knownWords,
    TextDifficultyScore currentDifficulty,
  ) {
    // 策略1: 添加复杂的从句（谨慎使用）
    var enhanced = _addComplexity(text);

    // 策略2: 使用更高级的词汇
    enhanced = _upgradeVocabulary(enhanced, userLevel);

    // 重新分析难度
    final newDifficulty = TextDifficultyAnalyzer.analyzeText(
      enhanced,
      knownWords: knownWords,
      userLevel: userLevel,
    );

    final unknownRatio = newDifficulty.unknownWordRatio / 1000.0;

    return TextAdaptationResult(
      adaptedText: enhanced,
      difficulty: newDifficulty,
      unknownWordRatio: unknownRatio,
      adaptationLevel: 2,
    );
  }

  /// 移除复杂的从句结构
  String _removeComplexClauses(String text) {
    var result = text;

    // 1. 简化关系从句
    result = result.replaceAllMapped(
      RegExp(r',\s+(der|die|das|den|dem)\s+\w+\s+,'),
      (match) => ':',
    );

    // 2. 简化让步从句
    result = result.replaceAll('obwohl', 'wenn');

    // 3. 移除过多的嵌套
    result = result.replaceAllMapped(
      RegExp(r'\w+\s+,\s+(wenn|da|weil)\s+'),
      (match) => '. ',
    );

    return result;
  }

  /// 简化词汇
  String _simplifyVocabulary(String text, Set<String> knownWords) {
    // 高级词汇到简单词汇的映射
    final replacements = {
      'veranschaulichen': 'zeigen',
      'hervorheben': 'zeigen',
      'durchführen': 'machen',
      'betrachten': 'sehen',
      'verwenden': 'benutzen',
      'feststellen': 'sehen',
      'aufstellen': 'machen',
      'zurückführen': 'kommen',
      'herausfinden': 'finden',
      'begegnen': 'treffen',
      'erörtern': 'sprechen',
      'darlegen': 'sagen',
      'gewährleisten': 'machen',
      'berücksichtigen': 'sehen',
    };

    var result = text;

    replacements.forEach((complex, simple) {
      result = result.replaceAll(complex, simple);
    });

    return result;
  }

  /// 拆分长句
  String _splitLongSentences(String text) {
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    final result = <String>[];

    for (final sentence in sentences) {
      final words = sentence.split(RegExp(r'\s+'));
      if (words.length > 20) {
        // 在逗号处拆分
        final parts = sentence.split(RegExp(r',\s+'));
        for (var i = 0; i < parts.length; i++) {
          final part = parts[i].trim();
          if (part.isNotEmpty) {
            if (i < parts.length - 1) {
              result.add('$part,');
            } else {
              // 最后一个部分保留原来的标点
              result.add(part);
            }
          }
        }
      } else {
        result.add(sentence);
      }
    }

    return result.join(' ');
  }

  /// 添加复杂度（谨慎使用）
  String _addComplexity(String text) {
    // 注意：这是一个简化版本
    // 实际应用中需要更复杂的NLP处理

    return text; // 暂时不修改，避免产生不自然的文本
  }

  /// 升级词汇
  String _upgradeVocabulary(String text, LanguageLevel userLevel) {
    // 简单词汇到高级词汇的映射
    final Map<String, String> upgrades = {
      'machen': userLevel.index >= LanguageLevel.B1.index ? 'durchführen' : 'machen',
      'sagen': userLevel.index >= LanguageLevel.B2.index ? 'äußern' : 'sagen',
      'sehen': userLevel.index >= LanguageLevel.B2.index ? 'betrachten' : 'sehen',
      'gehen': userLevel.index >= LanguageLevel.B1.index ? 'fortbewegen' : 'gehen',
    };

    var result = text;

    upgrades.forEach((simple, complex) {
      if (complex != simple) {
        result = result.replaceAll(simple, complex);
      }
    });

    return result;
  }

  /// 生成阅读理解检查问题
  static List<ComprehensionQuestion> generateComprehensionQuestions(
    String text,
    int questionCount,
  ) {
    final questions = <ComprehensionQuestion>[];

    // 这是一个简化的实现
    // 实际应用中需要使用NLP和AI来生成高质量的问题

    // 1. 提取关键词
    final keywords = TextDifficultyAnalyzer.extractKeyWords(text, maxWords: 10);

    // 2. 基于关键词生成问题（简化版）
    for (var i = 0; i < questionCount && i < keywords.length; i++) {
      final keyword = keywords[i];

      questions.add(ComprehensionQuestion(
        question: 'Was erfahren Sie über "$keyword"?',
        options: [
          'Das wird im Text erklärt.',
          'Das ist nicht im Text.',
          'Das ist unwichtig.',
          'Das weiß man nicht.',
        ],
        correctAnswer: 0,
        type: QuestionType.multipleChoice,
      ));
    }

    return questions;
  }

  /// 批量适配文本
  List<TextAdaptationResult> batchAdaptTexts(
    List<String> texts,
    LanguageLevel userLevel,
    Set<String> knownWords,
  ) {
    final results = <TextAdaptationResult>[];

    for (final text in texts) {
      final result = selectOptimalText(text, userLevel, knownWords);
      if (result != null) {
        results.add(result);
      }
    }

    // 按难度排序
    results.sort((a, b) =>
      a.difficulty.overallScore.compareTo(b.difficulty.overallScore));

    return results;
  }

  /// 获取用户当前状态
  UserReadingState getUserReadingState(
    LanguageLevel currentLevel,
    Set<String> knownWords,
    List<String> recentTexts,
  ) {
    // 分析最近阅读的文本
    final difficulties = recentTexts.map((text) =>
      TextDifficultyAnalyzer.analyzeText(text, knownWords: knownWords)
    ).toList();

    if (difficulties.isEmpty) {
      return UserReadingState(
        currentLevel: currentLevel,
        recommendedLevel: currentLevel,
        averageDifficulty: 0.0,
        isOnTrack: true,
        suggestions: ['开始阅读适合您水平的文本'],
      );
    }

    // 计算平均难度
    final avgDifficulty = difficulties
        .map((d) => d.overallScore)
        .reduce((a, b) => a + b) / difficulties.length;

    // 判断是否在正轨上
    final targetScore = TextDifficultyAnalyzer.levelToScore(currentLevel);
    final isOnTrack = (avgDifficulty - targetScore).abs() < 0.15;

    // 生成建议
    final suggestions = <String>[];

    if (!isOnTrack) {
      if (avgDifficulty > targetScore + 0.15) {
        suggestions.add('文本可能太难，建议选择更简单的材料');
        suggestions.add('专注于理解大意，不要纠结于每个生词');
      } else {
        suggestions.add('您可以尝试更有挑战性的文本');
        suggestions.add('适当增加阅读难度有助于进步');
      }
    }

    suggestions.add('保持每天阅读的习惯');
    suggestions.add('遇到生词时，先尝试根据上下文猜测意思');

    return UserReadingState(
      currentLevel: currentLevel,
      recommendedLevel: difficulties.map((d) => d.estimatedLevel).reduce(
        (a, b) => a.index > b.index ? a : b
      ),
      averageDifficulty: avgDifficulty,
      isOnTrack: isOnTrack,
      suggestions: suggestions,
    );
  }
}

/// 阅读理解问题
class ComprehensionQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final QuestionType type;

  const ComprehensionQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.type,
  });

  bool isCorrect(int userAnswer) => userAnswer == correctAnswer;
}

/// 问题类型
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillInBlank,
  openEnded,
}

/// 用户阅读状态
class UserReadingState {
  final LanguageLevel currentLevel;
  final LanguageLevel recommendedLevel;
  final double averageDifficulty;
  final bool isOnTrack;
  final List<String> suggestions;

  const UserReadingState({
    required this.currentLevel,
    required this.recommendedLevel,
    required this.averageDifficulty,
    required this.isOnTrack,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel.name,
      'recommendedLevel': recommendedLevel.name,
      'averageDifficulty': averageDifficulty,
      'isOnTrack': isOnTrack,
      'suggestions': suggestions,
    };
  }
}
