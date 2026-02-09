# Aeryn-Deutsch AI对话系统设计文档

## 📋 系统概述

### 设计理念
- **免费基础**: 所有用户都能使用基础对话功能
- **付费升级**: 高级AI接口供订阅用户使用
- **隐私优先**: 本地处理为主，可选云端AI
- **离线友好**: 核心功能支持离线使用

### 架构模式
```
┌─────────────────────────────────────┐
│         用户界面层 (UI)              │
│  - 对话场景选择                      │
│  - 实时对话界面                      │
│  - 语音输入/输出                     │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│      AI对话引擎管理层                │
│  - 场景管理器                        │
│  - 对话状态追踪                      │
│  - 错误处理                          │
└─┬───────────────┬───────────────────┘
  │               │
  ▼               ▼
┌─────────────┐ ┌──────────────────┐
│ 本地引擎    │ │   云端API引擎    │
│ (免费)      │ │   (付费订阅)     │
├─────────────┤ ├──────────────────┤
│ • 规则系统  │ │ • OpenAI GPT-4   │
│ • 模板对话  │ │ • Claude Opus    │
│ • 场景脚本  │ │ • Gemini Pro     │
│ • 预设响应  │ │ • 德语专用模型   │
└─────────────┘ └──────────────────┘
```

---

## 🆓 免费AI引擎 (本地)

### 1. 规则对话系统 (Rule-Based)

**原理**: 基于预定义规则和模式匹配

**优点**:
- ✅ 完全免费
- ✅ 100%离线
- ✅ 响应快速
- ✅ 隐私安全
- ✅ 可预测性强

**适用场景**:
- 简单问答
- 固定对话练习
- 语法纠正
- 词汇复习

**技术实现**:
```dart
class RuleBasedAIEngine {
  // 1. 意图识别
  Intent recognizeIntent(String userInput);

  // 2. 实体提取
  Map<String, String> extractEntities(String userInput);

  // 3. 响应生成
  String generateResponse(Intent intent, Map<String, String> entities);

  // 4. 上下文管理
  void updateContext(ConversationContext context);
}
```

### 2. 场景对话 (Scenario-Based)

**预设计场景**:
1. **日常对话** (Alltag)
   - 自我介绍
   - 问候和告别
   - 表达喜好
   - 日常安排

2. **购物场景** (Einkaufen)
   - 询问价格
   - 讨论商品
   - 砍价对话
   - 支付方式

3. **餐厅场景** (Im Restaurant)
   - 预订座位
   - 点餐
   - 投诉与建议
   - 结账

4. **旅行场景** (Reisen)
   - 询问路线
   - 购买票务
   - 酒店入住
   - 求助

5. **工作场景** (Beruf)
   - 面试准备
   - 会议讨论
   - 邮件写作
   - 电话沟通

6. **学术场景** (Studium)
   - 课堂讨论
   - 论文指导
   - 学术交流

**对话流程**:
```dart
class ScenarioDialogue {
  final String scenarioId;
  final String level;  // A1, A2, B1, B2, C1, C2
  final List<DialogueStage> stages;

  // 动态难度调整
  DialogueStage getCurrentStage();
  void provideHint();
  void skipToNext();
}
```

### 3. 模板响应 (Template Responses)

**响应模板系统**:
```dart
const Map<String, List<String>> responseTemplates = {
  'greeting': [
    'Hallo! Wie kann ich Ihnen helfen?',
    'Guten Tag! Was möchten Sie besprechen?',
    'Willkommen! Wie geht es Ihnen?',
  ],
  'grammar_correction': [
    'Fast richtig! Besser wäre: "{correction}"',
    'Guter Versuch. Die korrekte Form ist: "{correction}"',
    'Nicht schlecht. Aber man sagt: "{correction}"',
  ],
  'encouragement': [
    'Sehr gut! Machen Sie so weiter!',
    'Ausgezeichnet! Ihr Deutsch verbessert sich.',
    'Toll! Das haben Sie gut gemacht.',
  ],
};
```

### 4. 语法纠正引擎

**集成语法检查器**:
```dart
class GrammarCorrectionBot {
  Future<String> processInput(String userInput) async {
    // 1. 检查语法错误
    final result = await EnhancedGermanGrammarRules.checkGrammarEnhanced(userInput);

    // 2. 如果有错误，提供纠正
    if (result.errors.isNotEmpty) {
      return generateCorrection(userInput, result.errors.first);
    }

    // 3. 如果正确，继续对话
    return generateResponse(userInput);
  }

  String generateCorrection(String original, GrammarError error) {
    return 'Sie sagten: "$original"\n'
        'Besser: "${error.correctedText}"\n'
        'Erklärung: ${error.explanation}';
  }
}
```

---

## 💎 付费AI引擎 (云端API)

### 支持的AI服务

#### 1. OpenAI GPT-4
**配置**:
```dart
class OpenAIConfig {
  final String apiKey;
  final String model = 'gpt-4-turbo-preview';
  final String baseUrl = 'https://api.openai.com/v1';
  final Map<String, dynamic> parameters = {
    'temperature': 0.7,
    'max_tokens': 500,
    'top_p': 0.9,
  };
}
```

**德语优化**:
- System prompt优化为德语对话
- 添加德语语法知识
- 文化背景理解

#### 2. Anthropic Claude
**配置**:
```dart
class ClaudeConfig {
  final String apiKey;
  final String model = 'claude-3-opus-20240229';
  final String baseUrl = 'https://api.anthropic.com/v1';
  final Map<String, dynamic> parameters = {
    'temperature': 0.7,
    'max_tokens': 1000,
    'top_k': 250,
  };
}
```

**优势**:
- 更长的上下文窗口 (200K tokens)
- 更好的多语言支持
- 更安全的输出

#### 3. Google Gemini
**配置**:
```dart
class GeminiConfig {
  final String apiKey;
  final String model = 'gemini-pro';
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1';
  final Map<String, dynamic> parameters = {
    'temperature': 0.7,
    'maxOutputTokens': 1000,
    'topP': 0.9,
    'topK': 40,
  };
}
```

**优势**:
- Google强大的多语言能力
- 实时网络信息（可选）
- 更具性价比

#### 4. 德语专用模型

**推荐**:
- **Aleph Alpha** (德国AI公司)
- **Hugging Face** 德语模型
- **EU合规** 的模型选项

```dart
class GermanAIModel {
  final String provider = 'Aleph Alpha';
  final String model = 'luminous-supreme';
  final bool isGDPRCompliant = true;
  final bool serversInEU = true;
}
```

---

## 🔧 混合引擎架构

### 自动降级策略

```dart
class HybridAIEngine {
  Future<String> generateResponse(String userInput) async {
    // 1. 检查用户订阅状态
    final hasPremium = await UserService.hasPremiumSubscription();

    if (hasPremium) {
      try {
        // 2. 尝试使用高级AI
        return await _callPremiumAI(userInput);
      } catch (e) {
        // 3. 如果失败，降级到本地引擎
        debugPrint('Premium AI failed, falling back to local: $e');
        return _callLocalEngine(userInput);
      }
    } else {
      // 4. 免费用户使用本地引擎
      return _callLocalEngine(userInput);
    }
  }

  Future<String> _callPremiumAI(String input) async {
    final provider = await UserService.getSelectedAIProvider();
    switch (provider) {
      case AIProvider.openai:
        return await OpenAIService.chat(input);
      case AIProvider.claude:
        return await ClaudeService.chat(input);
      case AIProvider.gemini:
        return await GeminiService.chat(input);
      default:
        throw UnimplementedError();
    }
  }

  String _callLocalEngine(String input) {
    return RuleBasedAIEngine.process(input);
  }
}
```

### API配置管理

```dart
class AIServiceConfig {
  // OpenAI配置
  static String? openaiApiKey;
  static bool openaiEnabled = false;

  // Claude配置
  static String? claudeApiKey;
  static bool claudeEnabled = false;

  // Gemini配置
  static String? geminiApiKey;
  static bool geminiEnabled = false;

  // 加载配置
  static Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    openaiApiKey = prefs.getString('openai_api_key');
    openaiEnabled = prefs.getBool('openai_enabled') ?? false;
    // ... 其他配置
  }

  // 保存配置
  static Future<void> saveConfig(String provider, String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    switch (provider) {
      case 'openai':
        openaiApiKey = apiKey;
        openaiEnabled = true;
        await prefs.setString('openai_api_key', apiKey);
        await prefs.setBool('openai_enabled', true);
        break;
      // ... 其他provider
    }
  }

  // 检查是否配置
  static bool isConfigured(String provider) {
    switch (provider) {
      case 'openai': return openaiEnabled && openaiApiKey != null;
      case 'claude': return claudeEnabled && claudeApiKey != null;
      case 'gemini': return geminiEnabled && geminiApiKey != null;
      default: return false;
    }
  }
}
```

---

## 📱 用户界面设计

### 对话场景选择

```dart
class ScenarioSelectionScreen extends StatelessWidget {
  final scenarios = [
    Scenario(
      id: 'daily_greeting',
      name: '日常问候',
      level: 'A1',
      icon: Icons.waving_hand,
      color: Colors.blue,
    ),
    Scenario(
      id: 'shopping',
      name: '购物',
      level: 'A2',
      icon: Icons.shopping_cart,
      color: Colors.green,
    ),
    Scenario(
      id: 'restaurant',
      name: '餐厅',
      level: 'B1',
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    Scenario(
      id: 'job_interview',
      name: '求职面试',
      level: 'B2',
      icon: Icons.work,
      color: Colors.purple,
    ),
  ];
}
```

### 对话界面

```dart
class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController textController = TextEditingController();
  bool isPremiumUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('德语对话练习'),
        actions: [
          // AI引擎指示器
          if (isPremiumUser)
            Icon(Icons.auto_awesome, color: Colors.amber),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showAIConfig(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 对话历史
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          // 输入框
          _buildInputArea(),
          // 语音按钮
          _buildVoiceButton(),
        ],
      ),
    );
  }
}
```

---

## 💰 订阅集成

### 免费功能
- ✅ 规则对话系统
- ✅ 10个预设场景
- ✅ 基础语法纠正
- ✅ 文字对话

### 付费功能 (€10/月 或 €70/年)
- ✅ 高级AI对话 (GPT-4/Claude/Gemini)
- ✅ 无限对话次数
- ✅ 语音输入/输出
- ✅ 自定义场景
- ✅ 对话历史保存
- ✅ 进度报告

### API配置界面

```dart
class AIConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI设置')),
      body: ListView(
        children: [
          _buildProviderCard(
            name: 'OpenAI GPT-4',
            description: '最强大的语言模型',
            icon: 'assets/openai.png',
            isConfigured: AIServiceConfig.isConfigured('openai'),
            onTap: () => _showAPIKeyDialog('openai'),
          ),
          _buildProviderCard(
            name: 'Claude',
            description: 'Anthropic的AI助手',
            icon: 'assets/claude.png',
            isConfigured: AIServiceConfig.isConfigured('claude'),
            onTap: () => _showAPIKeyDialog('claude'),
          ),
          _buildProviderCard(
            name: 'Gemini',
            description: 'Google的AI模型',
            icon: 'assets/gemini.png',
            isConfigured: AIServiceConfig.isConfigured('gemini'),
            onTap: () => _showAPIKeyDialog('gemini'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔐 隐私与安全

### 数据处理

**本地引擎**:
- ✅ 所有数据本地处理
- ✅ 不需要网络连接
- ✅ 符合GDPR
- ✅ 零数据收集

**云端引擎**:
- ⚠️ 发送到第三方API
- ✅ 提供清晰的隐私政策
- ✅ 可选择匿名模式
- ✅ 不保存对话历史（除非用户同意）

### API密钥安全

```dart
class SecureStorage {
  static const secureKey = 'aeryn_secure_storage';

  static Future<void> saveAPIKey(String provider, String key) async {
    final storage = await FlutterSecureStorage();
    await storage.write(key: '${provider}_api_key', value: key);
  }

  static Future<String?> getAPIKey(String provider) async {
    final storage = await FlutterSecureStorage();
    return await storage.read(key: '${provider}_api_key');
  }

  static Future<void> deleteAPIKey(String provider) async {
    final storage = await FlutterSecureStorage();
    await storage.delete(key: '${provider}_api_key');
  }
}
```

---

## 📊 性能优化

### 响应时间目标
- 本地引擎: < 100ms
- 云端引擎: < 2s
- 语音识别: < 1s
- 语音合成: < 1s

### 缓存策略
```dart
class ResponseCache {
  static final cache = <String, CachedResponse>{};

  static Future<String> getCachedResponse(String input) async {
    final cached = cache[input];
    if (cached != null && !cached.isExpired) {
      return cached.response;
    }
    return null;
  }

  static void cacheResponse(String input, String response) {
    cache[input] = CachedResponse(
      response: response,
      timestamp: DateTime.now(),
      ttl: Duration(hours: 24),
    );
  }
}
```

---

## 🎯 实施路线图

### Phase 1: 基础系统 (Week 1-2)
- [x] 规则对话引擎
- [x] 场景对话框架
- [ ] UI界面实现
- [ ] 基础测试

### Phase 2: 高级功能 (Week 3-4)
- [ ] OpenAI集成
- [ ] Claude集成
- [ ] Gemini集成
- [ ] API配置管理

### Phase 3: 语音功能 (Week 5-6)
- [ ] 语音识别 (STT)
- [ ] 语音合成 (TTS)
- [ ] 发音评分

### Phase 4: 优化与发布 (Week 7-8)
- [ ] 性能优化
- [ ] 用户体验优化
- [ ] 文档完善
- [ ] 测试与发布

---

**最后更新**: 2026-02-08
**状态**: 设计完成，开始实施
