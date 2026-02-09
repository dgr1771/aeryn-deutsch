/// 增强的德语语法检查引擎
///
/// 使用外部数据集提供更准确的语法检查
library;

import 'grammar_checker_service.dart';
import 'external_data_integration_service.dart';

/// 增强的语法检查结果
class EnhancedGrammarCheckResult extends GrammarCheckResult {
  final List<GrammarSuggestion> suggestions;
  final Map<String, int> errorDistribution;
  final String? overallFeedback;

  EnhancedGrammarCheckResult({
    required super.originalText,
    required super.errors,
    required super.errorCount,
    required super.warningCount,
    required super.criticalCount,
    required super.score,
    this.suggestions = const [],
    this.errorDistribution = const {},
    this.overallFeedback,
  });
}

/// 语法改进建议
class GrammarSuggestion {
  final String title;
  final String description;
  final String? exampleBefore;
  final String? exampleAfter;
  final String category;  // vocabulary, grammar, style
  final int priority;  // 1-5, 5 is highest

  GrammarSuggestion({
    required this.title,
    required this.description,
    this.exampleBefore,
    this.exampleAfter,
    required this.category,
    required this.priority,
  });
}

/// 增强的德语语法规则引擎
class EnhancedGermanGrammarRules extends GermanGrammarRules {
  /// 缓存的外部数据
  static List<GermanNoun>? _nounDatabase;
  static List<GermanVerb>? _verbDatabase;
  static Map<String, GermanNoun>? _nounIndex;
  static Map<String, GermanVerb>? _verbIndex;

  /// 加载外部数据
  static Future<void> loadExternalData() async {
    if (_nounDatabase != null && _verbDatabase != null) return;

    try {
      // 这里应该从ExternalDataIntegrationService加载
      // 目前使用内置示例数据
      _nounDatabase = await _loadSampleNouns();
      _verbDatabase = await _loadSampleVerbs();

      // 建立索引以加快查询
      _nounIndex = {
        for (var noun in _nounDatabase!)
          noun.word.toLowerCase(): noun
      };

      _verbIndex = {
        for (var verb in _verbDatabase!)
          verb.infinitive.toLowerCase(): verb
      };
    } catch (e) {
      // 如果加载失败，使用空列表
      _nounDatabase = [];
      _verbDatabase = [];
      _nounIndex = {};
      _verbIndex = {};
    }
  }

  /// 增强的语法检查
  static Future<EnhancedGrammarCheckResult> checkGrammarEnhanced(
    String text, {
    bool useExternalData = true,
  }) async {
    if (useExternalData) {
      await loadExternalData();
    }

    final errors = <GrammarError>[];

    // 1. 基础检查（来自父类）
    errors.addAll(_checkNounCapitalization(text));
    errors.addAll(_checkVerbSecondPosition(text));
    errors.addAll(_checkArticles(text));
    errors.addAll(_checkPrepositions(text));
    errors.addAll(_checkCommonSpelling(text));

    // 2. 增强检查（使用外部数据）
    if (useExternalData && _nounIndex != null && _verbIndex != null) {
      errors.addAll(_checkNounArticleAgreement(text));
      errors.addAll(_checkVerbConjugation(text));
      errors.addAll(_checkNounPlurals(text));
      errors.addAll(_checkWordChoice(text));
    }

    // 3. 风格检查
    errors.addAll(_checkStyle(text));

    // 统计错误
    final errorCount = errors.where((e) => e.severity == GrammarErrorSeverity.error).length;
    final warningCount = errors.where((e) => e.severity == GrammarErrorSeverity.warning).length;
    final criticalCount = errors.where((e) => e.severity == GrammarErrorSeverity.critical).length;

    // 计算得分
    final totalErrors = errors.length;
    final score = totalErrors > 0 ? (1 - (totalErrors / text.split(' ').length)).clamp(0.0, 1.0) : 1.0;

    // 生成建议
    final suggestions = _generateSuggestions(text, errors);
    final errorDistribution = _calculateErrorDistribution(errors);
    final overallFeedback = _generateOverallFeedback(score, errors);

    return EnhancedGrammarCheckResult(
      originalText: text,
      errors: errors,
      errorCount: errorCount,
      warningCount: warningCount,
      criticalCount: criticalCount,
      score: score,
      suggestions: suggestions,
      errorDistribution: errorDistribution,
      overallFeedback: overallFeedback,
    );
  }

  /// 检查名词-冠词一致性（使用外部数据库）
  static List<GrammarError> _checkNounArticleAgreement(String text) {
    final errors = <GrammarError>[];

    if (_nounIndex == null || _nounIndex!.isEmpty) return errors;

    final words = text.split(RegExp(r'(\s|[.!?,:;])'));

    for (var i = 0; i < words.length - 1; i++) {
      final article = words[i].trim().toLowerCase();
      final noun = words[i + 1].trim();

      // 检查是否是冠词+名词组合
      if (['der', 'die', 'das', 'ein', 'eine', 'einen'].contains(article)) {
        final nounData = _nounIndex![noun.toLowerCase()];

        if (nounData != null) {
          String? correctArticle;

          // 确定正确的冠词
          if (article.startsWith('e')) {
            // 不定冠词
            if (nounData.article == 'der') {
              correctArticle = 'ein';
            } else if (nounData.article == 'die') {
              correctArticle = 'eine';
            } else {
              correctArticle = 'ein';
            }
          } else {
            // 定冠词
            correctArticle = nounData.article;
          }

          // 检查冠词是否正确
          if (article != correctArticle?.toLowerCase() && article != 'ein' && article != 'eine') {
            final position = text.indexOf(article, i > 0 ? text.indexOf(words[i - 1]) + words[i - 1].length : 0);

            errors.add(GrammarError(
              id: 'art_agree_${errors.length}',
              type: GrammarErrorType.article,
              severity: GrammarErrorSeverity.error,
              originalText: article,
              correctedText: correctArticle!,
              message: '冠词与名词不一致',
              rule: '冠词-名词一致性',
              explanation: '名词"$noun"的词性是${nounData.article}，应该使用"$correctArticle"',
              startPosition: position,
              endPosition: position + article.length,
              suggestions: [correctArticle],
            ));
          }
        }
      }
    }

    return errors;
  }

  /// 检查动词变位（使用外部数据库）
  static List<GrammarError> _checkVerbConjugation(String text) {
    final errors = <GrammarError>[];

    if (_verbIndex == null || _verbIndex!.isEmpty) return errors;

    // 简化的检查：查找常见的不正确变位
    final commonMistakes = {
      'ich haben': 'ich habe',
      'du haben': 'du hast',
      'er haben': 'er hat',
      'ich sein': 'ich bin',
      'du sein': 'du bist',
      'er sein': 'er ist',
      'ich werden': 'ich werde',
      'du werden': 'du wirst',
      'er werden': 'er wird',
    };

    commonMistakes.forEach((wrong, correct) {
      if (text.contains(wrong)) {
        final position = text.indexOf(wrong);
        errors.add(GrammarError(
          id: 'verb_conj_${errors.length}',
          type: GrammarErrorType.conjugation,
          severity: GrammarErrorSeverity.error,
          originalText: wrong,
          correctedText: correct,
          message: '动词变位错误',
          rule: '动词变位',
          explanation: '"${wrong.split(' ')[1]}"的正确变位应该是"$correct"',
          startPosition: position,
          endPosition: position + wrong.length,
          suggestions: [correct],
        ));
      }
    });

    return errors;
  }

  /// 检查名词复数（使用外部数据库）
  static List<GrammarError> _checkNounPlurals(String text) {
    final errors = <GrammarError>[];

    if (_nounIndex == null || _nounIndex!.isEmpty) return errors;

    // 检查常见的复数错误
    final pluralMistakes = {
      'die Tisches': 'die Tische',
      'die Stuhles': 'die Stühle',
      'die Hauses': 'die Häuser',
      'die Buches': 'die Bücher',
      'die Fraues': 'die Frauen',
      'die Mannes': 'die Männer',
    };

    pluralMistakes.forEach((wrong, correct) {
      if (text.contains(wrong)) {
        final position = text.indexOf(wrong);
        errors.add(GrammarError(
          id: 'noun_plural_${errors.length}',
          type: GrammarErrorType.spelling,
          severity: GrammarErrorSeverity.error,
          originalText: wrong,
          correctedText: correct,
          message: '名词复数形式错误',
          rule: '名词复数',
          explanation: '正确的复数形式应该是"$correct"',
          startPosition: position,
          endPosition: position + wrong.length,
          suggestions: [correct],
        ));
      }
    });

    return errors;
  }

  /// 检查词汇选择（使用词频数据）
  static List<GrammarError> _checkWordChoice(String text) {
    final errors = <GrammarError>[];

    // 检查常见的词汇选择错误
    final wordChoiceMistakes = {
      'kennen': '您可能想用"wissen"（知道）还是"kennen"（认识）？',
      'essen': '您是在描述人还是动物在吃？人应该用"essen"，动物用"fressen"',
    };

    // 这里可以添加更复杂的词汇选择检查
    // 例如基于语域、正式程度等

    return errors;
  }

  /// 检查文体风格
  static List<GrammarError> _checkStyle(String text) {
    final errors = <GrammarError>[];

    // 检查句子长度
    final sentences = text.split(RegExp(r'[.!?]'));
    for (var i = 0; i < sentences.length; i++) {
      final sentence = sentences[i].trim();
      final words = sentence.split(RegExp(r'\s+'));

      if (words.length > 30) {
        final position = text.indexOf(sentence);
        errors.add(GrammarError(
          id: 'style_length_${i}',
          type: GrammarErrorType.wordOrder,
          severity: GrammarErrorSeverity.warning,
          originalText: sentence.substring(0, 20) + '...',
          correctedText: sentence,
          message: '句子过长',
          rule: '句子长度',
          explanation: '这个句子有${words.length}个词，建议分成多个较短的句子以提高可读性',
          startPosition: position,
          endPosition: position + sentence.length,
        ));
      }
    }

    // 检查重复用词
    final wordCount = <String, int>{};
    final words = text.toLowerCase().split(RegExp(r'(\s|[.!?,:;])'));
    for (final word in words) {
      if (word.length > 3) {  // 忽略短词
        wordCount[word] = (wordCount[word] ?? 0) + 1;
      }
    }

    wordCount.forEach((word, count) {
      if (count >= 5) {
        errors.add(GrammarError(
          id: 'style_repeat_${word}',
          type: GrammarErrorType.wordOrder,
          severity: GrammarErrorSeverity.warning,
          originalText: word,
          correctedText: word,
          message: '词汇重复',
          rule: '词汇多样性',
          explanation: '单词"$word"出现了$count次，考虑使用同义词增加表达多样性',
          startPosition: 0,
          endPosition: word.length,
        ));
      }
    });

    return errors;
  }

  /// 生成改进建议
  static List<GrammarSuggestion> _generateSuggestions(
    String text,
    List<GrammarError> errors,
  ) {
    final suggestions = <GrammarSuggestion>[];

    // 分析错误类型
    final errorTypes = <GrammarErrorType, int>{};
    for (final error in errors) {
      errorTypes[error.type] = (errorTypes[error.type] ?? 0) + 1;
    }

    // 基于错误类型生成建议
    if (errorTypes[GrammarErrorType.capitalization] != null &&
        errorTypes[GrammarErrorType.capitalization]! > 2) {
      suggestions.add(GrammarSuggestion(
        title: '注意名词大写',
        description: '德语中所有名词必须首字母大写。这是德语最重要的拼写规则之一。',
        exampleBefore: 'der mann spielt heute fußball.',
        exampleAfter: 'Der Mann spielt heute Fußball.',
        category: 'grammar',
        priority: 5,
      ));
    }

    if (errorTypes[GrammarErrorType.article] != null &&
        errorTypes[GrammarErrorType.article]! > 1) {
      suggestions.add(GrammarSuggestion(
        title: '复习冠词用法',
        description: '德语冠词（der/die/das）需要根据名词的词性、格和数变化。建议记忆常用名词的词性。',
        exampleBefore: 'die Frau',
        exampleAfter: 'die Frau (正确)',
        category: 'grammar',
        priority: 4,
      ));
    }

    if (errorTypes[GrammarErrorType.conjugation] != null) {
      suggestions.add(GrammarSuggestion(
        title: '练习动词变位',
        description: '不规则动词的变位需要特别记忆。建议使用flashcards进行练习。',
        exampleBefore: 'ich haben',
        exampleAfter: 'ich habe',
        category: 'grammar',
        priority: 5,
      ));
    }

    // 总是添加通用建议
    suggestions.add(GrammarSuggestion(
      title: '多读多写',
      description: '阅读德语文章可以帮助你熟悉正确的语法结构。尝试每天阅读一些简单的德语文本。',
      category: 'general',
      priority: 3,
    ));

    suggestions.add(GrammarSuggestion(
      title: '使用母语者材料',
      description: '听德语播客、看德语视频可以帮助你掌握自然的表达方式。',
      category: 'general',
      priority: 3,
    ));

    return suggestions;
  }

  /// 计算错误分布
  static Map<String, int> _calculateErrorDistribution(List<GrammarError> errors) {
    final distribution = <String, int>{};

    for (final error in errors) {
      final typeName = error.type.toString().split('.').last;
      distribution[typeName] = (distribution[typeName] ?? 0) + 1;
    }

    return distribution;
  }

  /// 生成总体反馈
  static String? _generateOverallFeedback(double score, List<GrammarError> errors) {
    if (score >= 0.95) {
      return '太棒了！你的德语写作非常准确，几乎没有错误。';
    } else if (score >= 0.85) {
      return '很好！只有少量小错误，继续加油！';
    } else if (score >= 0.70) {
      return '不错，但还有一些语法问题需要注意。建议查看详细错误说明。';
    } else if (score >= 0.50) {
      return '需要改进。建议重点复习基础语法规则。';
    } else {
      return '建议从基础开始系统学习德语语法。使用app中的语法学习模块会很有帮助。';
    }
  }

  /// 加载示例名词数据
  static Future<List<GermanNoun>> _loadSampleNouns() async {
    // 这里返回一些示例数据
    // 实际应用中应该从CSV文件加载
    return [
      GermanNoun(
        word: 'Tisch',
        article: 'der',
        plural: 'Tische',
        genitive: 'Tisches',
        meanings: ['桌子'],
        cefrLevel: 'A1',
        frequencyRank: 234,
      ),
      GermanNoun(
        word: 'Stuhl',
        article: 'der',
        plural: 'Stühle',
        genitive: 'Stuhles',
        meanings: ['椅子'],
        cefrLevel: 'A1',
        frequencyRank: 456,
      ),
      GermanNoun(
        word: 'Haus',
        article: 'das',
        plural: 'Häuser',
        genitive: 'Hauses',
        meanings: ['房子'],
        cefrLevel: 'A1',
        frequencyRank: 123,
      ),
      // 添加更多名词...
    ];
  }

  /// 加载示例动词数据
  static Future<List<GermanVerb>> _loadSampleVerbs() async {
    // 这里返回一些示例数据
    return [
      GermanVerb(
        infinitive: 'sein',
        english: 'to be',
        chinese: '是',
        type: 'strong',
        present: {
          'ich': 'bin',
          'du': 'bist',
          'er': 'ist',
          'wir': 'sind',
          'ihr': 'seid',
          'sie': 'sind',
        },
        prateritum: {
          'ich': 'war',
          'du': 'warst',
          'er': 'war',
          'wir': 'waren',
          'ihr': 'wart',
          'sie': 'waren',
        },
        perfect: 'ist',
        cefrLevel: 'A1',
      ),
      GermanVerb(
        infinitive: 'haben',
        english: 'to have',
        chinese: '有',
        type: 'strong',
        present: {
          'ich': 'habe',
          'du': 'hast',
          'er': 'hat',
          'wir': 'haben',
          'ihr': 'habt',
          'sie': 'haben',
        },
        prateritum: {
          'ich': 'hatte',
          'du': 'hattest',
          'er': 'hatte',
          'wir': 'hatten',
          'ihr': 'hattet',
          'sie': 'hatten',
        },
        perfect: 'hat',
        cefrLevel: 'A1',
      ),
      // 添加更多动词...
    ];
  }
}
