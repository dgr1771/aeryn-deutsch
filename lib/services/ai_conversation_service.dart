/// AI对话服务
///
/// 提供混合AI引擎：免费规则引擎 + 付费云端AI
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversation.dart';
import 'grammar_checker_service.dart';
import 'enhanced_grammar_checker_service.dart';

/// AI服务配置
class AIServiceConfig {
  // OpenAI配置
  static String? _openaiApiKey;
  static bool _openaiEnabled = false;

  // Claude配置
  static String? _claudeApiKey;
  static bool _claudeEnabled = false;

  // Gemini配置
  static String? _geminiApiKey;
  static bool _geminiEnabled = false;

  // DeepSeek配置
  static String? _deepseekApiKey;
  static bool _deepseekEnabled = false;

  /// 加载配置
  static Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _openaiApiKey = prefs.getString('openai_api_key');
    _openaiEnabled = prefs.getBool('openai_enabled') ?? false;
    _claudeApiKey = prefs.getString('claude_api_key');
    _claudeEnabled = prefs.getBool('claude_enabled') ?? false;
    _geminiApiKey = prefs.getString('gemini_api_key');
    _geminiEnabled = prefs.getBool('gemini_enabled') ?? false;
    _deepseekApiKey = prefs.getString('deepseek_api_key');
    _deepseekEnabled = prefs.getBool('deepseek_enabled') ?? false;
  }

  /// 保存API密钥
  static Future<void> saveAPIKey(String provider, String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    switch (provider.toLowerCase()) {
      case 'openai':
        _openaiApiKey = apiKey;
        _openaiEnabled = true;
        await prefs.setString('openai_api_key', apiKey);
        await prefs.setBool('openai_enabled', true);
        break;
      case 'claude':
        _claudeApiKey = apiKey;
        _claudeEnabled = true;
        await prefs.setString('claude_api_key', apiKey);
        await prefs.setBool('claude_enabled', true);
        break;
      case 'gemini':
        _geminiApiKey = apiKey;
        _geminiEnabled = true;
        await prefs.setString('gemini_api_key', apiKey);
        await prefs.setBool('gemini_enabled', true);
        break;
      case 'deepseek':
        _deepseekApiKey = apiKey;
        _deepseekEnabled = true;
        await prefs.setString('deepseek_api_key', apiKey);
        await prefs.setBool('deepseek_enabled', true);
        break;
    }
  }

  /// 删除API密钥
  static Future<void> deleteAPIKey(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    switch (provider.toLowerCase()) {
      case 'openai':
        _openaiApiKey = null;
        _openaiEnabled = false;
        await prefs.remove('openai_api_key');
        await prefs.setBool('openai_enabled', false);
        break;
      case 'claude':
        _claudeApiKey = null;
        _claudeEnabled = false;
        await prefs.remove('claude_api_key');
        await prefs.setBool('claude_enabled', false);
        break;
      case 'gemini':
        _geminiApiKey = null;
        _geminiEnabled = false;
        await prefs.remove('gemini_api_key');
        await prefs.setBool('gemini_enabled', false);
        break;
      case 'deepseek':
        _deepseekApiKey = null;
        _deepseekEnabled = false;
        await prefs.remove('deepseek_api_key');
        await prefs.setBool('deepseek_enabled', false);
        break;
    }
  }

  /// 检查是否已配置
  static bool isConfigured(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return _openaiEnabled && _openaiApiKey != null;
      case 'claude':
        return _claudeEnabled && _claudeApiKey != null;
      case 'gemini':
        return _geminiEnabled && _geminiApiKey != null;
      case 'deepseek':
        return _deepseekEnabled && _deepseekApiKey != null;
      default:
        return false;
    }
  }

  /// 获取API密钥
  static String? getAPIKey(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return _openaiApiKey;
      case 'claude':
        return _claudeApiKey;
      case 'gemini':
        return _geminiApiKey;
      case 'deepseek':
        return _deepseekApiKey;
      default:
        return null;
    }
  }

  /// 获取已配置的提供者列表
  static List<String> getConfiguredProviders() {
    final providers = <String>[];
    if (isConfigured('openai')) providers.add('OpenAI');
    if (isConfigured('claude')) providers.add('Claude');
    if (isConfigured('gemini')) providers.add('Gemini');
    if (isConfigured('deepseek')) providers.add('DeepSeek');
    return providers;
  }
}

/// 对话服务
class ConversationService {
  static ConversationService? _instance;
  ConversationScenario? _currentScenario;
  final List<ChatMessage> _messages = [];
  ConversationPreferences _preferences = ConversationPreferences();

  ConversationService._();

  static ConversationService get instance {
    _instance ??= ConversationService._();
    return _instance!;
  }

  /// 初始化
  Future<void> initialize() async {
    await AIServiceConfig.loadConfig();
    await _loadPreferences();
  }

  /// 加载用户偏好
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsJson = prefs.getString('conversation_preferences');
    if (prefsJson != null) {
      _preferences = ConversationPreferences.fromJson(
        Map<String, dynamic>.from(
          // 简化处理，实际应该完整解析JSON
          {'level': prefsJson},
        ),
      );
    }
  }

  /// 保存用户偏好
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('conversation_preferences', _preferences.level);
  }

  /// 开始新对话
  void startConversation(ConversationScenario scenario) {
    _currentScenario = scenario;
    _messages.clear();
    _messages.add(ChatMessage.ai(scenario.introduction));
  }

  /// 发送消息并获取响应
  Future<ChatMessage> sendMessage(String userInput) async {
    // 1. 添加用户消息
    final userMessage = ChatMessage.user(userInput);
    _messages.add(userMessage);

    // 2. 检查语法（如果启用）
    String? correction;
    if (_preferences.enableGrammarCorrection) {
      final result = await EnhancedGermanGrammarRules.checkGrammarEnhanced(userInput);
      if (result.errors.isNotEmpty) {
        correction = _generateCorrection(result.errors.first);
      }
    }

    // 3. 生成AI响应
    String response;
    if (_preferences.preferredEngine == AIEngine.ruleBased ||
        !AIServiceConfig.getConfiguredProviders().isNotEmpty) {
      // 使用免费规则引擎
      response = await _generateRuleBasedResponse(userInput);
    } else {
      // 使用付费AI引擎
      try {
        response = await _generateAIResponse(userInput);
      } catch (e) {
        debugPrint('AI engine failed, falling back to rule-based: $e');
        response = await _generateRuleBasedResponse(userInput);
      }
    }

    // 4. 添加AI响应
    final aiMessage = ChatMessage.ai(response);
    _messages.add(aiMessage);

    return aiMessage;
  }

  /// 规则引擎生成响应
  Future<String> _generateRuleBasedResponse(String input) async {
    // 1. 识别意图
    final intent = _recognizeIntent(input);

    // 2. 提取关键词
    final keywords = _extractKeywords(input);

    // 3. 根据场景和意图生成响应
    if (_currentScenario != null) {
      return await _generateScenarioResponse(intent, keywords);
    }

    // 4. 默认响应
    return _getDefaultResponse(intent);
  }

  /// 意图识别
  Intent _recognizeIntent(String input) {
    final lowerInput = input.toLowerCase();

    // 问候
    if (lowerInput.contains('hallo') ||
        lowerInput.contains('guten tag') ||
        lowerInput.contains('guten morgen') ||
        lowerInput.contains('guten abend') ||
        lowerInput.contains('hi')) {
      return Intent.greeting;
    }

    // 告别
    if (lowerInput.contains('auf wiedersehen') ||
        lowerInput.contains('tschüss') ||
        lowerInput.contains('bye') ||
        lowerInput.contains('wiedersehen')) {
      return Intent.farewell;
    }

    // 提问
    if (lowerInput.contains('?')) {
      return Intent.question;
    }

    // 请求
    if (lowerInput.contains('können sie') ||
        lowerInput.contains('könnten sie') ||
        lowerInput.contains('bitte') ||
        lowerInput.contains('würden sie')) {
      return Intent.request;
    }

    // 抱怨
    if (lowerInput.contains('problem') ||
        lowerInput.contains('nicht gut') ||
        lowerInput.contains('beschwerde')) {
      return Intent.complaint;
    }

    // 赞美
    if (lowerInput.contains('gut') ||
        lowerInput.contains('toll') ||
        lowerInput.contains('wunderbar') ||
        lowerInput.contains('ausgezeichnet')) {
      return Intent.compliment;
    }

    return Intent.statement;
  }

  /// 提取关键词
  List<String> _extractKeywords(String input) {
    // 简化版：移除常见词，返回剩余词汇
    final stopWords = {
      'der', 'die', 'das', 'ein', 'eine', 'den', 'dem', 'des',
      'ich', 'du', 'er', 'sie', 'es', 'wir', 'ihr',
      'sein', 'haben', 'werden', 'können', 'müssen',
      'nicht', 'auch', 'nur', 'schon', 'noch',
      'für', 'mit', 'von', 'zu', 'auf', 'in', 'an',
    };

    final words = input.toLowerCase().split(RegExp(r'[\s,.!?;:]'));
    return words.where((w) => w.isNotEmpty && !stopWords.contains(w)).toList();
  }

  /// 生成场景响应
  Future<String> _generateScenarioResponse(Intent intent, List<String> keywords) async {
    if (_currentScenario == null) return _getDefaultResponse(intent);

    switch (_currentScenario!.category) {
      case 'daily':
        return _generateDailyConversationResponse(intent, keywords);
      case 'shopping':
        return _generateShoppingResponse(intent, keywords);
      case 'restaurant':
        return _generateRestaurantResponse(intent, keywords);
      case 'travel':
        return _generateTravelResponse(intent, keywords);
      case 'work':
        return _generateWorkResponse(intent, keywords);
      case 'study':
        return _generateStudyResponse(intent, keywords);
      default:
        return _getDefaultResponse(intent);
    }
  }

  /// 日常对话响应
  String _generateDailyConversationResponse(Intent intent, List<String> keywords) {
    switch (intent) {
      case Intent.greeting:
        final greetings = [
          'Hallo! Wie geht es Ihnen heute?',
          'Guten Tag! Schön, Sie zu sehen!',
          'Hallo! Was gibt\'s Neues?',
        ];
        return greetings[(DateTime.now().millisecond) % greetings.length];

      case Intent.farewell:
        return 'Auf Wiedersehen! Bis zum nächsten Mal!';

      case Intent.question:
        if (keywords.any((k) => k.contains('wie') || k.contains('gehen'))) {
          return 'Mir geht es gut, danke der Nachfrage! Und Ihnen?';
        }
        return 'Das ist eine gute Frage!';

      case Intent.compliment:
        return 'Vielen Dank für das Kompliment! Das freut mich sehr.';

      default:
        return 'Verstehe. Erzählen Sie mir mehr darüber!';
    }
  }

  /// 购物场景响应
  String _generateShoppingResponse(Intent intent, List<String> keywords) {
    switch (intent) {
      case Intent.greeting:
        return 'Willkommen in unserem Geschäft! Wie kann ich Ihnen helfen?';

      case Intent.request:
        if (keywords.any((k) => k.contains('suche') || k.contains('suchen'))) {
          return 'Natürlich, was suchen Sie denn?';
        }
        if (keywords.any((k) => k.contains('preis') || k.contains('kosten'))) {
          return 'Das kostet 19,99 Euro. Es ist sehr günstig!';
        }
        return 'Gerne! Was können wir für Sie tun?';

      case Intent.question:
        return 'Ja, dieses Produkt ist auf Lager. Wir haben verschiedene Farben.';

      default:
        return 'Sonst noch etwas, das Sie interessiert?';
    }
  }

  /// 餐厅场景响应
  String _generateRestaurantResponse(Intent intent, List<String> keywords) {
    switch (intent) {
      case Intent.greeting:
        return 'Guten Abend! Haben Sie reserviert oder kommen Sie spontan?';

      case Intent.request:
        if (keywords.any((k) => k.contains('karte') || k.contains('speise'))) {
          return 'Natürlich, hier ist unsere Speisekarte. Die Tagesgerichte finden Sie oben.';
        }
        if (keywords.any((k) => k.contains('bestellen'))) {
          return 'Sehr gerne! Was möchten Sie bestellen?';
        }
        return 'Gerne! Was darf es sein?';

      case Intent.complaint:
        return 'Entschuldigen Sie bitte! Wir werden das sofort korrigieren. Was ist das Problem?';

      default:
        return 'Möchten Sie noch etwas bestellen oder ist alles okay?';
    }
  }

  /// 旅行场景响应
  String _generateTravelResponse(Intent intent, List<String> keywords) {
    switch (intent) {
      case Intent.greeting:
        return 'Hallo! Wo möchten Sie denn heute hin?';

      case Intent.request:
        if (keywords.any((k) => k.contains('weg') || k.contains('route'))) {
          return 'Der Weg ist ganz einfach. Fahren Sie geradeaus und dann links.';
        }
        if (keywords.any((k) => k.contains('fahrkarte') || k.contains('ticket'))) {
          return 'Eine Fahrkarte kostet 3,50 Euro. Hin und zurück 6,50 Euro.';
        }
        return 'Wie kann ich Ihnen helfen?';

      case Intent.question:
        return 'Der Zug kommt in 10 Minuten auf Gleis 3.';

      default:
        return 'Wünschen Sie noch weitere Auskünfte?';
    }
  }

  /// 工作场景响应
  String _generateWorkResponse(Intent intent, List<String> keywords) {
    switch (intent) {
      case Intent.greeting:
        return 'Guten Morgen! Schön, dass Sie da sind. Wie geht es dem Projekt?';

      case Intent.request:
        if (keywords.any((k) => k.contains('bericht') || k.contains('bericht'))) {
          return 'Der Bericht ist fast fertig. Ich sende Ihnen ihn später per E-Mail.';
        }
        if (keywords.any((k) => k.contains('meeting') || k.contains('sitzung'))) {
          return 'Die Besprechung ist um 14 Uhr in Konferenzraum A.';
        }
        return 'Gerne! Was brauchen Sie?';

      case Intent.statement:
        return 'Verstehe. Lassen Sie uns das besprechen.';

      default:
        return 'Alles klar. Sonst noch etwas?';
    }
  }

  /// 学习场景响应
  String _generateStudyResponse(Intent intent, List<String> keywords) {
    switch (intent) {
      case Intent.greeting:
        return 'Hallo! Bereit für heute\'s Thema?';

      case Intent.question:
        if (keywords.any((k) => k.contains('verstehen') || k.contains('verstehe'))) {
          return 'Das verstehen Sie gut! Lassen Sie mich das erklären.';
        }
        return 'Gute Frage! Das erkläre ich Ihnen gern.';

      case Intent.statement:
        return 'Sehr gut! Das haben Sie richtig verstanden.';

      case Intent.request:
        return 'Natürlich! Was möchten Sie wiederholen?';

      default:
        return 'Machen Sie so weiter! Ihr Deutsch wird immer besser.';
    }
  }

  /// 默认响应
  String _getDefaultResponse(Intent intent) {
    switch (intent) {
      case Intent.greeting:
        return 'Hallo! Wie kann ich Ihnen helfen?';
      case Intent.farewell:
        return 'Auf Wiedersehen! Bis bald!';
      case Intent.question:
        return 'Das ist eine interessante Frage.';
      case Intent.statement:
        return 'Verstehe. Erzählen Sie mir mehr.';
      case Intent.request:
        return 'Gerne! Was möchten Sie wissen?';
      case Intent.complaint:
        return 'Verstehe ich. Lassen Sie uns das klären.';
      case Intent.compliment:
        return 'Vielen Dank!';
      default:
        return 'Können Sie das bitte wiederholen?';
    }
  }

  /// AI引擎生成响应（付费功能）
  Future<String> _generateAIResponse(String input) async {
    // 这里调用外部AI API
    // 暂时返回占位符
    // TODO: 实现实际的API调用

    final provider = AIServiceConfig.getConfiguredProviders().first;
    debugPrint('Using AI provider: $provider');

    // 模拟AI响应
    await Future.delayed(const Duration(seconds: 1));
    return 'Das verstehe ich. Danke für Ihre Nachricht! (Powered by $provider)';
  }

  /// 生成语法纠正
  String _generateCorrection(GrammarError error) {
    return '💡 Hinweis: "${error.originalText}" → "${error.correctedText}"\n'
        '${error.explanation ?? ""}';
  }

  /// 获取消息历史
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  /// 获取当前场景
  ConversationScenario? get currentScenario => _currentScenario;

  /// 更新偏好设置
  Future<void> updatePreferences(ConversationPreferences newPrefs) async {
    _preferences = newPrefs;
    await _savePreferences();
  }

  /// 获取偏好设置
  ConversationPreferences get preferences => _preferences;

  /// 清除历史
  void clearHistory() {
    _messages.clear();
  }

  /// 结束对话
  void endConversation() {
    _messages.add(ChatMessage.ai(
      'Vielen Dank für das Gespräch! Bis zum nächsten Mal! 🇩🇪',
    ));
  }
}
