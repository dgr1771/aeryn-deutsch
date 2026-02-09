import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/grammar_engine.dart';
import '../core/complexity_engine.dart';

/// AI 服务 - Aeryn AI Service
///
/// 负责与 DeepSeek API 交互
/// 功能：
/// - 新闻降级重写（B2 → A2/B1）
/// - 语法解释
/// - 句子拆解
class AIService {
  final String apiKey;
  final String baseUrl;
  final http.Client _client;

  AIService({
    required this.apiKey,
    this.baseUrl = 'https://api.deepseek.com/v1',
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// 将新闻降级到目标级别
  ///
  /// 核心功能：保留核心词汇，简化语法结构
  Future<NewsTransformationResult> transformNews(
    String originalText,
    LanguageLevel targetLevel,
  ) async {
    final prompt = _buildTransformationPrompt(originalText, targetLevel);

    try {
      final response = await _callChatAPI(prompt);

      return NewsTransformationResult(
        originalText: originalText,
        originalLevel: _detectLevel(originalText),
        transformedText: response,
        targetLevel: targetLevel,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to transform news: $e');
    }
  }

  /// 构建降级提示词
  String _buildTransformationPrompt(String text, LanguageLevel level) {
    final levelStr = _levelToString(level);

    return '''
作为一名德语教学专家，请将以下德语新闻重写为 $levelStr 级别。

要求：
1. 保留核心政治/经济/社会词汇（如：Regierung, Inflation, Energie）
2. 将复杂的嵌套从句（Nebensatz）简化为简单句或主从结构
3. 将被动语态（Passiv）转换为主动语态（Aktiv），并标注原句式
4. 缩短句子长度，每句不超过 15 个词
5. 保留原文的逻辑核心和关键信息

原文：
$text

请只输出重写后的德语文本，不要包含任何解释或标注。
''';
  }

  /// 解剖长难句
  ///
  /// 返回句子的结构化拆解
  Future<SentenceDissection> dissectSentence(String sentence) async {
    final prompt = '''
请分析以下德语句子的语法结构：

句子：$sentence

请以 JSON 格式返回：
{
  "mainClause": "主句核心",
  "subordinateClauses": ["从句1", "从句2"],
  "grammarPoints": [
    {
      "type": "时态/语态类型",
      "explanation": "简短解释"
    }
  ],
  "keyVocabulary": [
    {
      "word": "词汇",
      "meaning": "中文释义",
      "level": "B1/B2"
    }
  ]
}
''';

    try {
      final response = await _callChatAPI(prompt);
      final json = jsonDecode(response);

      return SentenceDissection(
        originalSentence: sentence,
        mainClause: json['mainClause'] ?? '',
        subordinateClauses: List<String>.from(json['subordinateClauses'] ?? []),
        grammarPoints: List<Map<String, String>>.from(
          json['grammarPoints'] ?? [],
        ).map((e) => GrammarPoint(
          type: e['type'] ?? '',
          explanation: e['explanation'] ?? '',
        )).toList(),
        keyVocabulary: List<Map<String, dynamic>>.from(
          json['keyVocabulary'] ?? [],
        ).map((e) => VocabularyItem(
          word: e['word'] ?? '',
          meaning: e['meaning'] ?? '',
          level: _parseLevel(e['level']),
        )).toList(),
      );
    } catch (e) {
      // 失败时返回基础拆解
      return SentenceDissection.createFallback(sentence);
    }
  }

  /// 调用 Chat API
  Future<String> _callChatAPI(String prompt) async {
    final url = Uri.parse('$baseUrl/chat/completions');

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.3,
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('API call failed: ${response.statusCode}');
    }
  }

  /// 检测文本等级
  LanguageLevel _detectLevel(String text) {
    return ComplexityEngine.analyzeLevel(text);
  }

  /// 公共API调用方法
  Future<String> callChatAPI(String prompt) async {
    return _callChatAPI(prompt);
  }

  /// 等级转字符串
  String _levelToString(LanguageLevel level) {
    return level.toString().split('.').last;
  }

  /// 字符串解析为等级
  LanguageLevel _parseLevel(String? str) {
    if (str == null) return LanguageLevel.B2;
    try {
      return LanguageLevel.values.firstWhere(
        (e) => e.toString().toLowerCase().contains(str.toLowerCase()),
      );
    } catch (e) {
      return LanguageLevel.B2;
    }
  }

  /// 关闭客户端
  void close() {
    _client.close();
  }
}

/// 新闻转换结果
class NewsTransformationResult {
  final String originalText;
  final LanguageLevel originalLevel;
  final String transformedText;
  final LanguageLevel targetLevel;
  final DateTime timestamp;

  NewsTransformationResult({
    required this.originalText,
    required this.originalLevel,
    required this.transformedText,
    required this.targetLevel,
    required this.timestamp,
  });
}

/// 句子解剖结果
class SentenceDissection {
  final String originalSentence;
  final String mainClause;
  final List<String> subordinateClauses;
  final List<GrammarPoint> grammarPoints;
  final List<VocabularyItem> keyVocabulary;

  SentenceDissection({
    required this.originalSentence,
    required this.mainClause,
    required this.subordinateClauses,
    required this.grammarPoints,
    required this.keyVocabulary,
  });

  /// 创建回退结果
  factory SentenceDissection.createFallback(String sentence) {
    return SentenceDissection(
      originalSentence: sentence,
      mainClause: sentence,
      subordinateClauses: [],
      grammarPoints: [],
      keyVocabulary: [],
    );
  }
}

/// 语法点
class GrammarPoint {
  final String type;
  final String explanation;

  GrammarPoint({required this.type, required this.explanation});
}

/// 词汇项
class VocabularyItem {
  final String word;
  final String meaning;
  final LanguageLevel level;

  VocabularyItem({
    required this.word,
    required this.meaning,
    required this.level,
  });
}
