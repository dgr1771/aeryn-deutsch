/// 写作智能批改服务（基于规则，不使用API）
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/writing_practice.dart';

/// 写作批改服务
class WritingCorrectionService {
  static const String _historyKey = 'writing_history';
  static const String _statsKey = 'writing_stats';

  SharedPreferences? _prefs;
  List<WritingPractice> _practiceHistory = [];
  int _totalWordsWritten = 0;
  int _totalPractices = 0;

  /// 初始化服务
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadHistory();
    await _loadStats();
  }

  /// 加载历史记录
  Future<void> _loadHistory() async {
    if (_prefs == null) return;

    final historyJson = _prefs!.getStringList(_historyKey) ?? [];
    _practiceHistory = historyJson
        .map((json) => _parsePractice(jsonDecode(json)))
        .whereType<WritingPractice>()
        .toList();
  }

  /// 保存历史记录
  Future<void> _saveHistory() async {
    if (_prefs == null) return;

    final historyJson =
        _practiceHistory.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs!.setStringList(_historyKey, historyJson);
  }

  /// 加载统计信息
  Future<void> _loadStats() async {
    if (_prefs == null) return;

    final statsJson = _prefs!.getString(_statsKey);
    if (statsJson != null) {
      final stats = jsonDecode(statsJson) as Map<String, dynamic>;
      _totalWordsWritten = stats['totalWords'] as int? ?? 0;
      _totalPractices = stats['totalPractices'] as int? ?? 0;
    }
  }

  /// 保存统计信息
  Future<void> _saveStats() async {
    if (_prefs == null) return;

    final stats = {
      'totalWords': _totalWordsWritten,
      'totalPractices': _totalPractices,
    };
    await _prefs!.setString(_statsKey, jsonEncode(stats));
  }

  /// 评估写作（核心方法 - 基于规则）
  Future<WritingEvaluation> evaluateWriting({
    required String taskId,
    required String userText,
  }) async {
    await initialize();

    final wordCount = userText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final errors = <WritingError>[];

    // 1. 检查基本语法错误
    errors.addAll(_checkGrammarErrors(userText));

    // 2. 检查拼写错误（基础规则）
    errors.addAll(_checkSpellingErrors(userText));

    // 3. 检查标点符号
    errors.addAll(_checkPunctuationErrors(userText));

    // 4. 检查词汇用法
    errors.addAll(_checkVocabularyErrors(userText));

    // 5. 检查文体
    errors.addAll(_checkStyleErrors(userText));

    // 计算评分
    final dimensions = _calculateScoringDimensions(userText, errors, wordCount);
    final totalScore = dimensions.fold<double>(
      0,
      (sum, dim) => sum + dim.score,
    );
    final maxScore = dimensions.fold<double>(
      0,
      (sum, dim) => sum + dim.maxScore,
    );

    // 生成改进版本
    final improvedVersion = _generateImprovedVersion(userText, errors);

    // 生成总体反馈
    final generalFeedback = _generateGeneralFeedback(errors, wordCount);

    // 更新统计
    _totalWordsWritten += wordCount;
    _totalPractices++;
    await _saveStats();

    return WritingEvaluation(
      taskId: taskId,
      userText: userText,
      totalScore: totalScore,
      maxScore: maxScore,
      errors: errors,
      dimensions: dimensions,
      generalFeedback: generalFeedback,
      improvedVersion: improvedVersion,
      evaluatedAt: DateTime.now(),
    );
  }

  /// 检查语法错误
  List<WritingError> _checkGrammarErrors(String text) {
    final errors = <WritingError>[];

    // 检查大写规则（名词首字母大写）
    final nounPattern = RegExp(r'\b(der|die|das|ein|eine|mein|dein|sein|ihr)\s+([a-z])');
    for (final match in nounPattern.allMatches(text)) {
      final noun = match.group(2)!;
      errors.add(WritingError(
        id: 'grammar_${errors.length}',
        type: ErrorType.grammar,
        severity: ErrorSeverity.minor,
        originalText: noun,
        correctedText: noun[0].toUpperCase() + noun.substring(1),
        message: '德语名词必须首字母大写',
        rule: '名词大写规则',
        startIndex: match.start + match.group(1)!.length + 1,
        endIndex: match.start + match.group(1)!.length + 2,
      ));
    }

    // 检查动词第二位（V2规则）
    final sentencePattern = RegExp(r'([.!?]\s+|^)([^.!?]+)([.!?])', multiLine: true);
    for (final match in sentencePattern.allMatches(text)) {
      final sentence = match.group(2)!;
      final words = sentence.trim().split(RegExp(r'\s+'));
      if (words.length >= 2) {
        final secondWord = words[1];
        // 简单检查：第二个词应该是动词形式
        // 这里只是简化规则，实际需要更复杂的NLP
        if (!_isLikelyVerb(secondWord)) {
          // 这里可能不是错误，只是提示
          // 不添加错误，避免误报
        }
      }
    }

    // 检查常见语法错误
    final commonGrammarErrors = {
      'ich habe gehen': 'ich bin gegangen',
      'er haben': 'er hat',
      'sie haben': 'sie hat',
      'das haus': 'das Haus',
      'ein buch': 'ein Buch',
    };

    commonGrammarErrors.forEach((wrong, correct) {
      final index = text.toLowerCase().indexOf(wrong);
      if (index != -1) {
        errors.add(WritingError(
          id: 'grammar_${errors.length}',
          type: ErrorType.grammar,
          severity: ErrorSeverity.moderate,
          originalText: text.substring(index, index + wrong.length),
          correctedText: correct,
          message: '语法错误：需要使用正确的动词形式',
          rule: '完成时/助动词规则',
          startIndex: index,
          endIndex: index + wrong.length,
        ));
      }
    });

    return errors;
  }

  /// 检查拼写错误
  List<WritingError> _checkSpellingErrors(String text) {
    final errors = <WritingError>[];

    // 常见拼写错误字典
    final commonSpellingErrors = {
      'dass': 'das',
      'haben': 'habe',  // 可能的误用
      'sein': 'seine',
    };

    // 注意：这只是示例，实际需要更完整的拼写检查
    final words = text.split(RegExp(r'\s+'));
    var currentIndex = 0;

    for (final word in words) {
      final lowerWord = word.toLowerCase().replaceAll(RegExp(r'[.,!?;:]'), '');

      // 检查常见混淆词
      if (lowerWord == 'das' && text.contains('das,')) {
        errors.add(WritingError(
          id: 'spelling_${errors.length}',
          type: ErrorType.spelling,
          severity: ErrorSeverity.moderate,
          originalText: 'das,',
          correctedText: 'dass,',
          message: '"dass" 是从句连词，"das" 是指示代词',
          rule: 'dass vs das',
          startIndex: currentIndex,
          endIndex: currentIndex + 4,
        ));
      }

      currentIndex += word.length + 1;
    }

    return errors;
  }

  /// 检查标点符号错误
  List<WritingError> _checkPunctuationErrors(String text) {
    final errors = <WritingError>[];

    // 检查句子是否以大写字母开头
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    var currentIndex = 0;

    for (final sentence in sentences) {
      if (sentence.isNotEmpty && sentence[0] != sentence[0].toUpperCase()) {
        errors.add(WritingError(
          id: 'punct_${errors.length}',
          type: ErrorType.punctuation,
          severity: ErrorSeverity.minor,
          originalText: sentence[0],
          correctedText: sentence[0].toUpperCase(),
          message: '句子应该以大写字母开头',
          rule: '标点符号规则',
          startIndex: currentIndex,
          endIndex: currentIndex + 1,
        ));
      }
      currentIndex += sentence.length + 1;
    }

    // 检查逗号后是否有空格
    final commaPattern = RegExp(r',[^ ]');
    for (final match in commaPattern.allMatches(text)) {
      errors.add(WritingError(
        id: 'punct_${errors.length}',
        type: ErrorType.punctuation,
        severity: ErrorSeverity.minor,
        originalText: ',',
        correctedText: ', ',
        message: '逗号后应该有空格',
        rule: '标点符号规则',
        startIndex: match.start,
        endIndex: match.start + 1,
      ));
    }

    return errors;
  }

  /// 检查词汇错误
  List<WritingError> _checkVocabularyErrors(String text) {
    final errors = <WritingError>[];

    // 检查重复用词
    final words = text.toLowerCase().split(RegExp(r'[\s.,!?;:]+'));
    final wordCounts = <String, int>{};

    for (final word in words) {
      if (word.length > 3) {  // 忽略短词
        wordCounts[word] = (wordCounts[word] ?? 0) + 1;
      }
    }

    wordCounts.forEach((word, count) {
      if (count >= 5) {  // 如果一个词出现5次以上
        errors.add(WritingError(
          id: 'vocab_${errors.length}',
          type: ErrorType.vocabulary,
          severity: ErrorSeverity.minor,
          originalText: word,
          correctedText: word,
          message: '"$word" 重复使用了 $count 次，建议使用同义词替换',
          rule: '词汇多样性',
          startIndex: 0,
          endIndex: word.length,
          suggestions: _getSynonyms(word),
        ));
      }
    });

    return errors;
  }

  /// 检查文体错误
  List<WritingError> _checkStyleErrors(String text) {
    final errors = <WritingError>[];

    // 检查是否过于简单的句子
    final sentences = text.split(RegExp(r'[.!?]'));
    for (final sentence in sentences) {
      final words = sentence.trim().split(RegExp(r'\s+'));
      if (words.length < 4 && words.length > 0) {
        // 句子太短
        final index = text.indexOf(sentence.trim());
        errors.add(WritingError(
          id: 'style_${errors.length}',
          type: ErrorType.style,
          severity: ErrorSeverity.minor,
          originalText: sentence.trim(),
          correctedText: sentence.trim(),
          message: '这个句子太短了，建议使用连词扩展',
          rule: '句子长度',
          startIndex: index,
          endIndex: index + sentence.trim().length,
        ));
      }
    }

    return errors;
  }

  /// 计算评分维度
  List<ScoringDimension> _calculateScoringDimensions(
    String text,
    List<WritingError> errors,
    int wordCount,
  ) {
    final dimensions = <ScoringDimension>[];

    // 1. 语法准确性 (0-10分)
    final grammarErrors = errors.where((e) => e.type == ErrorType.grammar).length;
    final grammarScore = (10 - grammarErrors * 2).clamp(0, 10).toDouble();
    dimensions.add(ScoringDimension(
      name: '语法准确性',
      description: '语法的正确性和多样性',
      score: grammarScore,
      maxScore: 10,
      feedback: grammarErrors == 0
          ? '语法使用正确！'
          : '发现 $grammarErrors 处语法错误，建议复习相关语法规则。',
    ));

    // 2. 词汇丰富度 (0-10分)
    final uniqueWords = text.split(RegExp(r'\s+')).toSet().length;
    final vocabularyRatio = wordCount > 0 ? uniqueWords / wordCount : 0;
    final vocabularyScore = (vocabularyRatio * 10).clamp(0, 10);
    dimensions.add(ScoringDimension(
      name: '词汇丰富度',
      description: '词汇的多样性和恰当性',
      score: vocabularyScore,
      maxScore: 10,
      feedback: vocabularyRatio > 0.6
          ? '词汇使用丰富多样！'
          : '建议增加词汇量，避免重复使用相同的词汇。',
    ));

    // 3. 内容完整性 (0-10分)
    final contentScore = wordCount >= 50 ? 10.0 : (wordCount / 50 * 10).clamp(0, 10);
    dimensions.add(ScoringDimension(
      name: '内容完整性',
      description: '内容的完整性和充实度',
      score: contentScore,
      maxScore: 10,
      feedback: wordCount >= 50
          ? '内容充实完整。'
          : '内容较少，建议增加更多细节和例子。',
    ));

    // 4. 结构连贯性 (0-10分)
    final coherenceErrors = errors.where((e) => e.type == ErrorType.coherence).length;
    final coherenceScore = (10 - coherenceErrors * 2).clamp(0, 10).toDouble();
    dimensions.add(ScoringDimension(
      name: '结构连贯性',
      description: '文章结构和逻辑连贯性',
      score: coherenceScore,
      maxScore: 10,
      feedback: coherenceErrors == 0
          ? '文章结构清晰，逻辑连贯。'
          : '建议使用连接词改善文章连贯性。',
    ));

    return dimensions;
  }

  /// 生成改进版本
  String _generateImprovedVersion(String text, List<WritingError> errors) {
    var improved = text;

    // 按位置倒序排序，避免索引变化
    final sortedErrors = errors.toList()
      ..sort((a, b) => b.startIndex.compareTo(a.startIndex));

    for (final error in sortedErrors) {
      improved = improved.substring(0, error.startIndex) +
          error.correctedText +
          improved.substring(error.endIndex);
    }

    return improved;
  }

  /// 生成总体反馈
  String _generateGeneralFeedback(List<WritingError> errors, int wordCount) {
    final buffer = StringBuffer();

    // 总体评价
    if (errors.isEmpty) {
      buffer.writeln(' excellent! 你的写作非常棒！');
    } else if (errors.length <= 3) {
      buffer.writeln('做得很好！只有少量错误。');
    } else if (errors.length <= 7) {
      buffer.writeln('总体不错，还有一些改进空间。');
    } else {
      buffer.writeln('需要继续努力，建议多练习基础语法。');
    }

    buffer.writeln();

    // 具体建议
    final errorTypes = errors.map((e) => e.type).toSet();
    if (errorTypes.contains(ErrorType.grammar)) {
      buffer.writeln('• 重点关注语法规则，特别是动词变位和冠词使用。');
    }
    if (errorTypes.contains(ErrorType.spelling)) {
      buffer.writeln('• 注意拼写检查，特别是容易混淆的词汇。');
    }
    if (errorTypes.contains(ErrorType.punctuation)) {
      buffer.writeln('• 注意标点符号的正确使用。');
    }
    if (errorTypes.contains(ErrorType.vocabulary)) {
      buffer.writeln('• 尝试使用更多样化的词汇表达。');
    }
    if (errorTypes.contains(ErrorType.style)) {
      buffer.writeln('• 可以尝试使用更复杂的句子结构。');
    }

    // 字数建议
    if (wordCount < 30) {
      buffer.writeln('• 文章较短，建议增加更多内容和细节。');
    }

    return buffer.toString().trim();
  }

  /// 辅助方法：判断是否可能是动词
  bool _isLikelyVerb(String word) {
    // 德语动词常见结尾
    final verbEndings = ['en', 'n', 'eln', 'ern', 'te', 'et', 'st', 'e'];
    return verbEndings.any((ending) => word.toLowerCase().endsWith(ending));
  }

  /// 辅助方法：获取同义词建议
  List<String>? _getSynonyms(String word) {
    final synonyms = <String, List<String>>{
      'gut': ['positiv', 'schön', 'ausgezeichnet'],
      'machen': ['tun', 'durchführen', 'ausführen'],
      'sagen': ['äußern', 'erklären', 'mitteilen'],
      'gehen': ['laufen', 'wandern', 'fortbewegen'],
      'sehen': ['blicken', 'schauen', 'beobachten'],
    };

    return synonyms[word.toLowerCase()];
  }

  /// 保存练习记录
  Future<void> savePractice(WritingPractice practice) async {
    await initialize();

    _practiceHistory.add(practice);
    await _saveHistory();
  }

  /// 获取练习历史
  List<WritingPractice> getPracticeHistory() {
    return List.from(_practiceHistory);
  }

  /// 获取统计信息
  Map<String, dynamic> getStatistics() {
    return {
      'totalPractices': _totalPractices,
      'totalWords': _totalWordsWritten,
      'averageWords': _totalPractices > 0
          ? (_totalWordsWritten / _totalPractices).round()
          : 0,
      'historyCount': _practiceHistory.length,
    };
  }

  /// 清除历史记录
  Future<void> clearHistory() async {
    _practiceHistory.clear();
    await _saveHistory();
  }

  /// 解析练习记录
  WritingPractice? _parsePractice(Map<String, dynamic> json) {
    try {
      return WritingPractice(
        taskId: json['taskId'] as String,
        userText: json['userText'] as String,
        evaluation: json['evaluation'] != null
            ? WritingEvaluation(
                taskId: json['evaluation']['taskId'] as String,
                userText: json['evaluation']['userText'] as String,
                totalScore: (json['evaluation']['totalScore'] as num).toDouble(),
                maxScore: (json['evaluation']['maxScore'] as num).toDouble(),
                errors: (json['evaluation']['errors'] as List<dynamic>?)
                        ?.map((e) => WritingError(
                              id: e['id'] as String,
                              type: ErrorType.values.firstWhere(
                                (t) => t.name == e['type'],
                                orElse: () => ErrorType.grammar,
                              ),
                              severity: ErrorSeverity.values.firstWhere(
                                (s) => s.name == e['severity'],
                                orElse: () => ErrorSeverity.minor,
                              ),
                              originalText: e['originalText'] as String,
                              correctedText: e['correctedText'] as String,
                              message: e['message'] as String,
                              rule: e['rule'] as String?,
                              startIndex: e['startIndex'] as int,
                              endIndex: e['endIndex'] as int,
                              suggestions: (e['suggestions'] as List<dynamic>?)
                                  ?.cast<String>(),
                            ))
                        .toList() ??
                    [],
                dimensions: (json['evaluation']['dimensions'] as List<dynamic>?)
                        ?.map((d) => ScoringDimension(
                              name: d['name'] as String,
                              description: d['description'] as String,
                              score: (d['score'] as num).toDouble(),
                              maxScore: (d['maxScore'] as num).toDouble(),
                              feedback: d['feedback'] as String?,
                            ))
                        .toList() ??
                    [],
                generalFeedback: json['evaluation']['generalFeedback'] as String?,
                improvedVersion: json['evaluation']['improvedVersion'] as String?,
                evaluatedAt: DateTime.parse(json['evaluation']['evaluatedAt'] as String),
              )
            : null,
        startedAt: DateTime.parse(json['startedAt'] as String),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        timeSpentSeconds: json['timeSpentSeconds'] as int,
      );
    } catch (e) {
      return null;
    }
  }
}
