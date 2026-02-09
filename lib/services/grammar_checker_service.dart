/// 德语语法检查引擎
library;

import '../models/writing_practice.dart';

/// 语法错误类型
enum GrammarErrorType {
  capitalization,   // 大小写错误
  conjugation,      // 变位错误
  article,         // 冠词错误
  preposition,     // 介词错误
  wordOrder,       // 语序错误
  agreement,       // 一致性错误
  spelling,        // 拼写错误
}

/// 语法错误严重程度
enum GrammarErrorSeverity {
  warning,         // 警告（可能是错误）
  error,           // 错误
  critical,        // 严重错误
}

/// 语法错误
class GrammarError {
  final String id;
  final GrammarErrorType type;
  final GrammarErrorSeverity severity;
  final String originalText;
  final String correctedText;
  final String message;
  final String? rule;
  final String? explanation;
  final int startPosition;
  final int endPosition;
  final List<String>? suggestions;

  GrammarError({
    required this.id,
    required this.type,
    required this.severity,
    required this.originalText,
    required this.correctedText,
    required this.message,
    this.rule,
    this.explanation,
    required this.startPosition,
    required this.endPosition,
    this.suggestions,
  });
}

/// 语法检查结果
class GrammarCheckResult {
  final String originalText;
  final List<GrammarError> errors;
  final int errorCount;
  final int warningCount;
  final int criticalCount;
  final double score;  // 0-1 (1 = 完美, 0 = 很差)

  GrammarCheckResult({
    required this.originalText,
    required this.errors,
    required this.errorCount,
    required this.warningCount,
    required this.criticalCount,
    required this.score,
  });
}

/// 德语语法规则引擎
class GermanGrammarRules {
  /// 可分动词前缀列表
  static const Set<String> separablePrefixes = {
    'ab', 'an', 'auf', 'aus', 'bei', 'ein', 'ent', 'er', 'her', 'hin', 'mit',
    'nach', 'vor', 'weg', 'zu', 'zurück', 'zusammen',
  };

  /// 不可分前缀列表
  static const Set<String> inseparablePrefixes = {
    'be', 'emp', 'ent', 'er', 'ge', 'miss', 'ver', 'zer',
  };

  /// 弱变化定冠词（各格）
  static const Map<String, Map<String, String>> weakDefiniteArticles = {
    'nominativ': {'masc': 'der', 'fem': 'die', 'neut': 'das', 'plural': 'die'},
    'akkusativ': {'masc': 'den', 'fem': 'die', 'neut': 'das', 'plural': 'die'},
    'dativ': {'masc': 'dem', 'fem': 'der', 'neut': 'dem', 'plural': 'den'},
    'genitiv': {'masc': 'des', 'fem': 'der', 'neut': 'des', 'plural': 'der'},
  };

  /// 强变化指示词
  static const Set<String> strongIndicators = {
    'ein', 'kein', 'mein', 'dein', 'sein', 'ihr', 'unser', 'euer',
    'ander', 'dies', 'solch', 'welch', 'jemand', 'nichts',
  };

  /// 名词后缀（用于识别名词）
  static const Set<String> nounSuffixes = {
    '-heit', '-keit', '-ung', '-schaft', '-tion', '-ment', '-ling',
    '-nis', '-tum', '-schaft', '-ik', '-ur',
  };

  /// 检查文本中的语法错误
  static GrammarCheckResult checkGrammar(String text) {
    final errors = <GrammarError>[];

    // 1. 检查名词大写
    errors.addAll(_checkNounCapitalization(text));

    // 2. 检查动词第二位规则
    errors.addAll(_checkVerbSecondPosition(text));

    // 3. 检查冠词使用
    errors.addAll(_checkArticles(text));

    // 4. 检查介词使用
    errors.addAll(_checkPrepositions(text));

    // 5. 检查常见拼写错误
    errors.addAll(_checkCommonSpelling(text));

    // 统计错误
    final errorCount = errors.where((e) => e.severity == GrammarErrorSeverity.error).length;
    final warningCount = errors.where((e) => e.severity == GrammarErrorSeverity.warning).length;
    final criticalCount = errors.where((e) => e.severity == GrammarErrorSeverity.critical).length;

    // 计算得分
    final totalErrors = errors.length;
    final score = totalErrors > 0 ? (1 - (totalErrors / text.split(' ').length)).clamp(0.0, 1.0) : 1.0;

    return GrammarCheckResult(
      originalText: text,
      errors: errors,
      errorCount: errorCount,
      warningCount: warningCount,
      criticalCount: criticalCount,
      score: score,
    );
  }

  /// 检查名词大写规则
  static List<GrammarError> _checkNounCapitalization(String text) {
    final errors = <GrammarError>[];

    // 分词
    final words = text.split(RegExp(r'(\s|[.!?,:;])'));

    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.isEmpty) continue;

      // 检查是否是名词（简单判断：以特定后缀结尾或前面有冠词）
      final previousWord = i > 0 ? words[i - 1] : '';

      // 如果前面是定冠词或指示代词，当前词应该是名词
      if (_isArticle(previousWord) || _isDemonstrative(previousWord)) {
        if (word.isNotEmpty && word[0] == word[0].toLowerCase()) {
          errors.add(GrammarError(
            id: 'cap_${errors.length}',
            type: GrammarErrorType.capitalization,
            severity: GrammarErrorSeverity.error,
            originalText: word,
            correctedText: _capitalize(word),
            message: '德语名词必须首字母大写',
            rule: '名词大写规则',
            explanation: '在德语中，所有名词必须首字母大写',
            startPosition: text.indexOf(word),
            endPosition: text.indexOf(word) + word.length,
            suggestions: [_capitalize(word)],
          ));
        }
      }

      // 检查是否以名词后缀结尾但小写
      for (final suffix in nounSuffixes) {
        if (word.toLowerCase().endsWith(suffix) &&
            word.isNotEmpty &&
            word[0] == word[0].toLowerCase()) {
          errors.add(GrammarError(
            id: 'cap_${errors.length}',
            type: GrammarErrorType.capitalization,
            severity: GrammarErrorSeverity.error,
            originalText: word,
            correctedText: _capitalize(word),
            message: '名词必须首字母大写',
            rule: '名词后缀规则',
            explanation: '以${suffix}结尾的词通常是名词，应大写',
            startPosition: text.indexOf(word),
            endPosition: text.indexOf(word) + word.length,
            suggestions: [_capitalize(word)],
          ));
        }
      }
    }

    return errors;
  }

  /// 检查动词第二位规则
  static List<GrammarError> _checkVerbSecondPosition(String text) {
    final errors = <GrammarError>[];

    // 分句
    final sentences = text.split(RegExp(r'[.!?]'));
    var sentenceIndex = 0;

    for (final sentence in sentences) {
      if (sentence.trim().isEmpty) continue;

      final words = sentence.trim().split(RegExp(r'\s+'));
      if (words.length < 2) continue;

      // 检查第二个词
      final secondWord = words[1];
      final position = sentenceIndex + text.indexOf(sentence) + words.take(1).fold(0, (sum, w) => sum + w.length + 1);

      // 简化检查：如果第二个词以-en结尾，很可能是动词
      if (_couldBeVerb(secondWord)) {
        // 这里只是提示，不是错误
        errors.add(GrammarError(
          id: 'v2_${errors.length}',
          type: GrammarErrorType.conjugation,
          severity: GrammarErrorSeverity.warning,
          originalText: secondWord,
          correctedText: secondWord,
          message: '第二个词应该是动词（V2规则）',
          rule: '动词第二位规则',
          explanation: '德语陈述句中，变位动词应该位于第二位',
          startPosition: position,
          endPosition: position + secondWord.length,
        ));
      }

      sentenceIndex += sentence.length;
    }

    return errors;
  }

  /// 检查冠词使用
  static List<GrammarError> _checkArticles(String text) {
    final errors = <GrammarError>[];

    // 常见冠词错误
    final commonMistakes = {
      'das Mann': 'der Mann',
      'die Frau': 'die Frau',  // 正确
      'der Frau': 'die Frau',  // 错误
      'das Kind': 'das Kind',   // 正确
      'die Kind': 'das Kind',    // 错误
    };

    commonMistakes.forEach((wrong, correct) {
      final index = text.toLowerCase().indexOf(wrong);
      if (index != -1) {
        errors.add(GrammarError(
          id: 'art_${errors.length}',
          type: GrammarErrorType.article,
          severity: GrammarErrorSeverity.error,
          originalText: wrong,
          correctedText: correct,
          message: '冠词使用错误',
          rule: '冠词-名词一致性',
          explanation: '阴性名词使用"die"，阳性名词使用"der"，中性名词使用"das"',
          startPosition: index,
          endPosition: index + wrong.length,
          suggestions: [correct],
        ));
      }
    });

    return errors;
  }

  /// 检查介词使用
  static List<GrammarError> _checkPrepositions(String text) {
    final errors = <GrammarError>[];

    // 介词+宾格/与格
    final prepositionCases = {
      'für': ['akkusativ'],
      'ohne': ['akkusativ'],
      'gegen': ['akkusativ'],
      'um': ['akkusativ'],
      'durch': ['akkusativ'],
      'für': ['akkusativ'],
      'aus': ['dativ'],
      'bei': ['dativ'],
      'mit': ['dativ'],
      'nach': ['dativ'],
      'zu': ['dativ'],
      'von': ['dativ'],
      'seit': ['dativ'],
      'aus': ['dativ'],
    };

    // 简化检查：检查介词后的名词是否使用了正确的格
    // 这里只做基本的模式匹配
    prepositionCases.forEach((preposition, cases) {
      final pattern = RegExp(r'$preposition\s+(\w+)\s+(\w+)', caseSensitive: false);
      final matches = pattern.allMatches(text);

      for (final match in matches) {
        // 这里可以添加更复杂的格检查逻辑
        // 目前只是示例
        errors.add(GrammarError(
          id: 'prep_${errors.length}',
          type: GrammarErrorType.preposition,
          severity: GrammarErrorSeverity.warning,
          originalText: match.group(0)!,
          correctedText: match.group(0)!,
          message: '请检查介词后的格是否正确',
          rule: '介词格支配',
          explanation: '$preposition支配${cases.join('或')}格',
          startPosition: match.start,
          endPosition: match.end,
        ));
      }
    });

    return errors;
  }

  /// 检查常见拼写错误
  static List<GrammarError> _checkCommonSpelling(String text) {
    final errors = <GrammarError>[];

    final commonMistakes = {
      'das, dass': 'dass',
      'dass, das': 'dass',  // 上下文相关
      'habe, hast': 'habe',
      'hat, habe': 'hat',
    };

    // 简化的检查逻辑
    // 实际应用中需要更复杂的上下文分析
    for (final entry in commonMistakes.entries) {
      final parts = entry.split(',');
      if (text.toLowerCase().contains(parts[0])) {
        errors.add(GrammarError(
          id: 'spell_${errors.length}',
          type: GrammarErrorType.spelling,
          severity: GrammarErrorSeverity.error,
          originalText: parts[0],
          correctedText: parts[1],
          message: '常见拼写错误',
          rule: '词汇区分',
          explanation: '${parts[0]}应该写为${parts[1]}',
          startPosition: text.toLowerCase().indexOf(parts[0]),
          endPosition: text.toLowerCase().indexOf(parts[0]) + parts[0].length,
          suggestions: [parts[1]],
        ));
      }
    }

    return errors;
  }

  /// 判断是否可能是动词
  static bool _couldBeVerb(String word) {
    // 德语动词常见结尾
    final verbEndings = ['en', 'n', 'eln', 'ern', 'ieren'];
    return verbEndings.any((ending) => word.toLowerCase().endsWith(ending));
  }

  /// 判断是否是冠词
  static bool _isArticle(String word) {
    return ['der', 'die', 'das', 'ein', 'eine', 'einen', 'einen', 'einem'].contains(word);
  }

  /// 判断是否是指示代词
  static bool _isDemonstrative(String word) {
    return ['dieser', 'diese', 'dieses', 'jener', 'jene', 'jenes'].contains(word);
  }

  /// 首字母大写
  static String _capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }

  /// 验证动词变位
  static bool validateVerbConjugation({
    required String verb,
    required Map<String, String> conjugations,
  }) {
    // 检查是否有基本的变位模式
    final basicPattern = RegExp(r'^[a-zäöüß]+$');

    if (!basicPattern.hasMatch(verb)) {
      return false;
    }

    // 检查是否有足够的形式
    if (conjugations.length < 6) {
      return false;
    }

    // 检查是否包含所有基本人称
    final requiredPersons = ['ich', 'du', 'er', 'wir', 'ihr', 'sie'];
    final hasAllPersons = requiredPersons.every((person) =>
      conjugations.containsKey(person));

    return hasAllPersons;
  }

  /// 验证形容词词尾
  static bool validateAdjectiveEnding({
    required String article,
    required String case,
    required String gender,
    required String adjective,
  }) {
    // 这里实现形容词词尾验证逻辑
    // 基于弱/强/混合变化规则

    // 弱变化词尾
    final weakEndings = {
      'nominativ': {'masc': 'e', 'fem': 'e', 'neut': 'e', 'plural': 'en'},
      'akkusativ': {'masc': 'en', 'fem': 'e', 'neut': 'e', 'plural': 'en'},
      'dativ': {'masc': 'en', 'fem': 'en', 'neut': 'en', 'plural': 'en'},
      'genitiv': {'masc': 'en', 'fem': 'en', 'neut': 'en', 'plural': 'en'},
    };

    // 检查是否使用正确的词尾
    // 这里只是简化示例
    return true;
  }

  /// 获取语法规则说明
  static Map<String, String> getGrammarRuleExplanation(String ruleId) {
    final explanations = {
      'noun_capitalization': '''
# 名词大写规则

## 规则
所有德语名词必须首字母大写。

## 示例
- der Tisch (桌子)
- die Stadt (城市)
- das Buch (书)

## 注意
- 这适用于普通名词、专有名词、名词化动词等
- 唯一不需要大写的是代词、介词、连词等''',
      'verb_second_position': '''
# 动词第二位规则 (V2规则)

## 规则
在德语陈述句中，变位动词必须位于第二位。

## 示例
- Ich spiele heute Fußball. (主语 + 动词 + ...)
- Heute spiele ich Fußball. (时间 + 动词 + 主语 + ...)

## 例外
- 祈使句：Spiel mir bitte! (动词在第一位)
- 问句: Spielst du heute? (动词在第一位)
''',
    };

    return explanations[ruleId] ?? '规则说明不存在';
  }
}
