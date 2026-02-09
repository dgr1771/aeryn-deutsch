/// AI对话系统数据模型
library;

import 'package:flutter/material.dart';

/// 对话消息
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;  // true=用户消息, false=AI消息
  final DateTime timestamp;
  final String? correction;  // 纠正建议（如果有）
  final Map<String, dynamic>? metadata;  // 额外元数据

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.correction,
    this.metadata,
  });

  factory ChatMessage.user(String content, {String? correction}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      correction: correction,
    );
  }

  factory ChatMessage.ai(String content, {Map<String, dynamic>? metadata}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'correction': correction,
      'metadata': metadata,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      correction: json['correction'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// 对话场景
class ConversationScenario {
  final String id;
  final String name;
  final String description;
  final String level;  // A1, A2, B1, B2, C1, C2
  final String category;  // daily, shopping, restaurant, travel, work, study
  final IconData icon;
  final Color color;
  final List<String> keyPhrases;  // 关键短语
  final String introduction;  // 场景介绍
  final List<DialoguePrompt> prompts;  // 预设对话提示

  ConversationScenario({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.category,
    required this.icon,
    required this.color,
    required this.keyPhrases,
    required this.introduction,
    required this.prompts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'category': category,
      'icon': icon.codePoint,
      'color': color.value,
      'keyPhrases': keyPhrases,
      'introduction': introduction,
      'prompts': prompts.map((p) => p.toJson()).toList(),
    };
  }

  factory ConversationScenario.fromJson(Map<String, dynamic> json) {
    return ConversationScenario(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      level: json['level'] as String,
      category: json['category'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] as int),
      keyPhrases: List<String>.from(json['keyPhrases'] as List),
      introduction: json['introduction'] as String,
      prompts: (json['prompts'] as List)
          .map((p) => DialoguePrompt.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 对话提示
class DialoguePrompt {
  final String german;
  final String chinese;
  final String? hint;  // 提示
  final String? grammar;  // 语法点

  DialoguePrompt({
    required this.german,
    required this.chinese,
    this.hint,
    this.grammar,
  });

  Map<String, dynamic> toJson() {
    return {
      'german': german,
      'chinese': chinese,
      'hint': hint,
      'grammar': grammar,
    };
  }

  factory DialoguePrompt.fromJson(Map<String, dynamic> json) {
    return DialoguePrompt(
      german: json['german'] as String,
      chinese: json['chinese'] as String,
      hint: json['hint'] as String?,
      grammar: json['grammar'] as String?,
    );
  }
}

/// 对话会话
class ConversationSession {
  final String id;
  final String scenarioId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ChatMessage> messages;
  final String level;  // 当前对话级别
  final int turns;  // 对话轮数
  final double score;  // 对话得分
  final Map<String, int> errorCounts;  // 错误统计

  ConversationSession({
    required this.id,
    required this.scenarioId,
    required this.startTime,
    this.endTime,
    this.messages = const [],
    this.level = 'A1',
    this.turns = 0,
    this.score = 0.0,
    this.errorCounts = const {},
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  bool get isActive => endTime == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scenarioId': scenarioId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'level': level,
      'turns': turns,
      'score': score,
      'errorCounts': errorCounts,
    };
  }

  factory ConversationSession.fromJson(Map<String, dynamic> json) {
    return ConversationSession(
      id: json['id'] as String,
      scenarioId: json['scenarioId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      level: json['level'] as String? ?? 'A1',
      turns: json['turns'] as int? ?? 0,
      score: json['score'] as double? ?? 0.0,
      errorCounts: Map<String, int>.from(json['errorCounts'] ?? {}),
    );
  }
}

/// AI引擎类型
enum AIEngine {
  ruleBased,   // 规则引擎（免费）
  openai,      // OpenAI GPT-4
  claude,      // Anthropic Claude
  gemini,      // Google Gemini
  custom,      // 自定义模型
}

/// 对话意图
enum Intent {
  greeting,        // 问候
  farewell,        // 告别
  question,        // 提问
  statement,       // 陈述
  request,         // 请求
  complaint,       // 投诉
  compliment,      // 赞美
  agreement,       // 同意
  disagreement,    // 不同意
  unknown,         // 未知
}

/// 用户偏好设置
class ConversationPreferences {
  final AIEngine preferredEngine;
  final String level;  // A1-C2
  final bool enableGrammarCorrection;
  final bool enableVoiceInput;
  final bool enableVoiceOutput;
  final String voiceSpeed;  // slow, normal, fast
  final bool saveHistory;
  final int? maxTurns;  // 最大对话轮数

  ConversationPreferences({
    this.preferredEngine = AIEngine.ruleBased,
    this.level = 'A1',
    this.enableGrammarCorrection = true,
    this.enableVoiceInput = false,
    this.enableVoiceOutput = false,
    this.voiceSpeed = 'normal',
    this.saveHistory = true,
    this.maxTurns,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferredEngine': preferredEngine.toString(),
      'level': level,
      'enableGrammarCorrection': enableGrammarCorrection,
      'enableVoiceInput': enableVoiceInput,
      'enableVoiceOutput': enableVoiceOutput,
      'voiceSpeed': voiceSpeed,
      'saveHistory': saveHistory,
      'maxTurns': maxTurns,
    };
  }

  factory ConversationPreferences.fromJson(Map<String, dynamic> json) {
    return ConversationPreferences(
      preferredEngine: json['preferredEngine'] != null
          ? AIEngine.values.firstWhere(
              (e) => e.toString() == json['preferredEngine'],
              orElse: () => AIEngine.ruleBased,
            )
          : AIEngine.ruleBased,
      level: json['level'] as String? ?? 'A1',
      enableGrammarCorrection: json['enableGrammarCorrection'] as bool? ?? true,
      enableVoiceInput: json['enableVoiceInput'] as bool? ?? false,
      enableVoiceOutput: json['enableVoiceOutput'] as bool? ?? false,
      voiceSpeed: json['voiceSpeed'] as String? ?? 'normal',
      saveHistory: json['saveHistory'] as bool? ?? true,
      maxTurns: json['maxTurns'] as int?,
    );
  }

  ConversationPreferences copyWith({
    AIEngine? preferredEngine,
    String? level,
    bool? enableGrammarCorrection,
    bool? enableVoiceInput,
    bool? enableVoiceOutput,
    String? voiceSpeed,
    bool? saveHistory,
    int? maxTurns,
  }) {
    return ConversationPreferences(
      preferredEngine: preferredEngine ?? this.preferredEngine,
      level: level ?? this.level,
      enableGrammarCorrection: enableGrammarCorrection ?? this.enableGrammarCorrection,
      enableVoiceInput: enableVoiceInput ?? this.enableVoiceInput,
      enableVoiceOutput: enableVoiceOutput ?? this.enableVoiceOutput,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      saveHistory: saveHistory ?? this.saveHistory,
      maxTurns: maxTurns ?? this.maxTurns,
    );
  }
}
