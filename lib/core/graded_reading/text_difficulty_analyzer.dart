/// 文本难度分析器
///
/// 基于多种指标评估德语文本难度，实现i+1理论
library;

import '../grammar_engine.dart';
import '../../models/word.dart';
import '../learning_path/skill_tree.dart';

/// 文本难度评分
class TextDifficultyScore {
  final double overallScore; // 0-1，越高越难
  final LanguageLevel estimatedLevel;
  final double vocabularyDifficulty;
  final double grammarComplexity;
  final double sentenceComplexity;
  final int unknownWordRatio; // 每千词未知词数

  const TextDifficultyScore({
    required this.overallScore,
    required this.estimatedLevel,
    required this.vocabularyDifficulty,
    required this.grammarComplexity,
    required this.sentenceComplexity,
    required this.unknownWordRatio,
  });

  /// 是否适合当前用户水平（i+1原则）
  bool isSuitableForLevel(LanguageLevel userLevel) {
    final levelDiff = estimatedLevel.index - userLevel.index;
    // 允许高1个级别，但不建议低级别或高太多
    return levelDiff >= 0 && levelDiff <= 1;
  }

  /// 获取难度描述
  String getDifficultyDescription() {
    if (overallScore < 0.2) return '非常简单';
    if (overallScore < 0.4) return '简单';
    if (overallScore < 0.6) return '中等';
    if (overallScore < 0.8) return '困难';
    return '非常困难';
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'estimatedLevel': estimatedLevel.name,
      'vocabularyDifficulty': vocabularyDifficulty,
      'grammarComplexity': grammarComplexity,
      'sentenceComplexity': sentenceComplexity,
      'unknownWordRatio': unknownWordRatio,
      'description': getDifficultyDescription(),
    };
  }
}

/// 词频数据（简化版，实际应用中应该从大型语料库统计）
class WordFrequencyData {
  static const Map<String, int> _frequency = {
    // A1 最常用词 (频率 1-100)
    'der': 1, 'die': 2, 'das': 3, 'ein': 4, 'eine': 5,
    'ich': 6, 'du': 7, 'er': 8, 'sie': 9, 'es': 10,
    'sein': 11, 'haben': 12, 'werden': 13, 'können': 14, 'machen': 15,
    'sagen': 16, 'gehen': 17, 'kommen': 18, 'sehen': 19, 'wollen': 20,

    // A2 常用词 (频率 101-500)
    'geben': 101, 'denken': 102, 'bringen': 103, 'halten': 104,
    'stehen': 105, 'liegen': 106, 'sitzen': 107, 'stellen': 108,

    // B1 中级词 (频率 501-2000)
    'gewinnen': 501, 'verlieren': 502, 'erklären': 503, 'beschreiben': 504,
    'entscheiden': 505, 'verstehen': 506, 'bedeuten': 507, 'hervorragen': 508,

    // B2 中高级词 (频率 2001-5000)
    'beeinflussen': 2001, 'herausstellen': 2002, 'zurückführen': 2003,
    'veranschaulichen': 2004, 'darlegen': 2005, 'erörtern': 2006,

    // C1 高级词 (频率 5001-10000)
    'konstituieren': 5001, 'manifestieren': 5002, 'spezifizieren': 5003,
    'legitimieren': 5004, 'stipulieren': 5005, 'adjungieren': 5006,

    // C2 专业/学术词 (频率 10000+)
    'metaphysisch': 10001, 'epistemologisch': 10002, 'hermeneutisch': 10003,
    'phänomenologisch': 10004, 'dialektisch': 10005, 'heuristic': 10006,
  };

  /// 获取词频等级 (0-5，越高越罕见)
  static int getFrequencyLevel(String word) {
    final lowerWord = word.toLowerCase();
    final freq = _frequency[lowerWord];

    if (freq == null) return 6; // 未知词汇
    if (freq <= 100) return 0; // A1
    if (freq <= 500) return 1; // A2
    if (freq <= 2000) return 2; // B1
    if (freq <= 5000) return 3; // B2
    if (freq <= 10000) return 4; // C1
    return 5; // C2
  }

  /// 是否为高频词
  static bool isHighFrequency(String word) {
    return getFrequencyLevel(word) <= 2;
  }
}

/// 文本难度分析器
class TextDifficultyAnalyzer {
  /// 分析文本难度
  static TextDifficultyScore analyzeText(
    String text, {
    Set<String>? knownWords,
    LanguageLevel? userLevel,
  }) {
    // 分词
    final words = _tokenize(text);

    // 1. 词汇难度分析
    final vocabScore = _analyzeVocabulary(words, knownWords);

    // 2. 语法复杂度分析
    final grammarScore = _analyzeGrammar(text);

    // 3. 句子复杂度分析
    final sentenceScore = _analyzeSentences(text, words.length);

    // 4. 计算综合难度
    final overallScore = _calculateOverallScore(
      vocabScore,
      grammarScore,
      sentenceScore,
    );

    // 5. 估算CEFR级别
    final estimatedLevel = _estimateLevel(overallScore);

    // 6. 计算未知词比例
    final unknownRatio = _calculateUnknownWordRatio(words, knownWords);

    return TextDifficultyScore(
      overallScore: overallScore,
      estimatedLevel: estimatedLevel,
      vocabularyDifficulty: vocabScore,
      grammarComplexity: grammarScore,
      sentenceComplexity: sentenceScore,
      unknownWordRatio: unknownRatio,
    );
  }

  /// 分词
  static List<String> _tokenize(String text) {
    // 移除标点符号，转换为小写
    final cleanText = text
        .replaceAll(RegExp(r'[.,!?;:]'), ' ')
        .replaceAll('"', ' ')
        .replaceAll('"', ' ')
        .replaceAll(''', ' ')
        .replaceAll(''', ' ')
        .replaceAll('`', ' ')
        .replaceAll('´', ' ')
        .replaceAll('(', ' ')
        .replaceAll(')', ' ')
        .replaceAll('[', ' ')
        .replaceAll(']', ' ')
        .replaceAll('{', ' ')
        .replaceAll('}', ' ')
        .toLowerCase();

    // 分割成词
    return cleanText
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  /// 分析词汇难度
  static double _analyzeVocabulary(List<String> words, Set<String>? knownWords) {
    if (words.isEmpty) return 0.0;

    // 计算平均词频等级
    double totalFrequencyLevel = 0;
    int rareWordCount = 0;

    for (final word in words) {
      final freqLevel = WordFrequencyData.getFrequencyLevel(word);
      totalFrequencyLevel += freqLevel;

      // 统计低频词（B2及以上）
      if (freqLevel >= 3) {
        rareWordCount++;
      }
    }

    final avgFrequencyLevel = totalFrequencyLevel / words.length;
    final rareWordRatio = rareWordCount / words.length;

    // 词汇难度 = (平均频率等级 * 0.6 + 低频词比例 * 0.4)
    final vocabDifficulty = (avgFrequencyLevel / 6 * 0.6) + (rareWordRatio * 0.4);

    return vocabDifficulty.clamp(0.0, 1.0);
  }

  /// 分析语法复杂度
  static double _analyzeGrammar(String text) {
    double complexity = 0.0;

    // 1. 检查高级语法结构
    final advancedPatterns = [
      // 从句
      RegExp(r'\b(weil|da|ob|wenn|falls|sobald|nachdem|bevor|seit|bis)\b'),
      // 被动语态
      RegExp(r'\b(werden|wurde|worden)\s+\w+'),
      // 虚拟式
      RegExp(r'\b(wäre|hätte|müsste\s+|könnte\s+|dürfte\s+)'),
      // 关系代词
      RegExp(r'\b(der|die|das|den|dem|dessen|deren|welcher|welche|welches)\b\s+\w+'),
      // 分词结构
      RegExp(r'\w+(?=(?:end|tend|ant)\s+\w+)'),
      // 可分动词
      RegExp(r'\w+(?=(?:ab|an|auf|aus|bei|ein|fest|fort|her|hin|hinter|los|mit|nach|nieder|vor|weg|zu|zurück|zusammen)'),
      // 不定式结构
      RegExp(r'\b(zu\s+\w+en|um\s+\w+en|ohne\s+\w+en|statt\s+\w+en)'),
    ];

    for (final pattern in advancedPatterns) {
      final matches = pattern.allMatches(text);
      complexity += matches.length * 0.05;
    }

    // 2. 检查句子嵌套深度（简化版：通过逗号数量估算）
    final commaCount = ','.allMatches(text).length;
    final sentenceCount = RegExp(r'[.!?]').allMatches(text).length;
    final avgCommasPerSentence = sentenceCount > 0
        ? commaCount / sentenceCount
        : 0;

    complexity += avgCommasPerSentence * 0.1;

    // 3. 检查长难句（超过30词的句子）
    final sentences = text.split(RegExp(r'[.!?]'));
    final longSentences = sentences.where((s) => _tokenize(s).length > 30).length;
    complexity += longSentences * 0.1;

    return complexity.clamp(0.0, 1.0);
  }

  /// 分析句子复杂度
  static double _analyzeSentences(String text, int totalWords) {
    if (totalWords == 0) return 0.0;

    final sentences = text.split(RegExp(r'[.!?]')).where((s) => s.trim().isNotEmpty).length;

    if (sentences == 0) return 0.0;

    // 平均句长
    final avgSentenceLength = totalWords / sentences;

    // 句长标准化（20词为基准）
    final lengthScore = (avgSentenceLength - 10) / 40;

    return lengthScore.clamp(0.0, 1.0);
  }

  /// 计算综合难度
  static double _calculateOverallScore(
    double vocabScore,
    double grammarScore,
    double sentenceScore,
  ) {
    // 加权平均
    return (vocabScore * 0.5) + (grammarScore * 0.3) + (sentenceScore * 0.2);
  }

  /// 根据难度分数估算CEFR级别
  static LanguageLevel _estimateLevel(double score) {
    if (score < 0.2) return LanguageLevel.A1;
    if (score < 0.35) return LanguageLevel.A2;
    if (score < 0.5) return LanguageLevel.B1;
    if (score < 0.65) return LanguageLevel.B2;
    if (score < 0.8) return LanguageLevel.C1;
    return LanguageLevel.C2;
  }

  /// 计算未知词比例（每千词）
  static int _calculateUnknownWordRatio(List<String> words, Set<String>? knownWords) {
    if (knownWords == null || knownWords.isEmpty || words.isEmpty) {
      return 0; // 无法计算
    }

    int unknownCount = 0;
    for (final word in words) {
      if (!knownWords.contains(word.toLowerCase())) {
        unknownCount++;
      }
    }

    // 每千词未知词数
    return (unknownCount / words.length * 1000).round();
  }

  /// 提取文本中的关键词（用于学习）
  static List<String> extractKeyWords(String text, {int maxWords = 20}) {
    final words = _tokenize(text);
    final wordFreq = <String, int>{};

    // 统计词频
    for (final word in words) {
      if (word.length > 3) { // 忽略短词
        wordFreq[word] = (wordFreq[word] ?? 0) + 1;
      }
    }

    // 按频率排序，返回前N个
    final sorted = wordFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(maxWords)
        .map((e) => e.key)
        .toList();
  }

  /// 检查文本是否适合i+1原则
  /// i+1原则：未知词比例应在5-10%之间
  static bool checkI1Principle(String text, Set<String> knownWords) {
    final words = _tokenize(text);
    if (words.isEmpty) return false;

    int unknownCount = 0;
    for (final word in words) {
      if (!knownWords.contains(word.toLowerCase())) {
        unknownCount++;
      }
    }

    final unknownRatio = unknownCount / words.length;

    // i+1: 5-10%未知词
    return unknownRatio >= 0.05 && unknownRatio <= 0.10;
  }

  /// 调整文本难度（简化版：实际应用中需要更复杂的NLP处理）
  static String adjustDifficulty(
    String originalText,
    TextDifficultyScore currentScore,
    LanguageLevel targetLevel,
  ) {
    final targetScore = levelToScore(targetLevel);

    // 如果难度合适，直接返回
    if ((currentScore.overallScore - targetScore).abs() < 0.1) {
      return originalText;
    }

    // 如果当前文本太难，简化它
    if (currentScore.overallScore > targetScore) {
      return _simplifyText(originalText);
    }

    // 如果当前文本太简单，可以返回原文（实际应用中可以扩展）
    return originalText;
  }

  /// 简化文本
  static String _simplifyText(String text) {
    // 这是一个简化的实现
    // 实际应用中需要使用NLP技术来重写文本

    var simplified = text;

    // 1. 拆分长句
    simplified = simplified.replaceAllMapped(
      RegExp(r',\s+und\s+'),
      (match) => '. Und ',
    );

    // 2. 简化连词
    simplified = simplified.replaceAll('obwohl', 'wenn');
    simplified = simplified.replaceAll('während', 'wenn');
    simplified = simplified.replaceAll('sobald', 'wenn');

    // 注意：这是一个非常简化的版本
    // 真正的文本简化需要复杂的NLP处理

    return simplified;
  }

  /// 将级别转换为分数
  static double levelToScore(LanguageLevel level) {
    switch (level) {
      case LanguageLevel.A1: return 0.1;
      case LanguageLevel.A2: return 0.3;
      case LanguageLevel.B1: return 0.45;
      case LanguageLevel.B2: return 0.6;
      case LanguageLevel.C1: return 0.75;
      case LanguageLevel.C2: return 0.9;
    }
  }
}
