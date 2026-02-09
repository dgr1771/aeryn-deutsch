/// 写作练习模型
library;

/// 写作任务类型
enum WritingTaskType {
  email,           // 邮件
  essay,           // 作文
  letter,          // 信件
  report,          // 报告
  summary,         // 总结
  argumentation,   // 议论文
  description,     // 描述文
}

/// 写作等级
enum WritingLevel {
  A1,
  A2,
  B1,
  B2,
}

/// 错误类型
enum ErrorType {
  grammar,        // 语法错误
  spelling,       // 拼写错误
  punctuation,    // 标点错误
  vocabulary,     // 词汇错误
  style,          // 文体错误
  coherence,      // 连贯性错误
}

/// 错误严重程度
enum ErrorSeverity {
  minor,          // 轻微
  moderate,       // 中等
  serious,        // 严重
}

/// 写作错误
class WritingError {
  final String id;
  final ErrorType type;
  final ErrorSeverity severity;
  final String originalText;        // 原文
  final String correctedText;       // 修正
  final String message;             // 错误说明
  final String? rule;               // 相关语法规则
  final int startIndex;             // 起始位置
  final int endIndex;               // 结束位置
  final List<String>? suggestions;  // 其他建议

  WritingError({
    required this.id,
    required this.type,
    required this.severity,
    required this.originalText,
    required this.correctedText,
    required this.message,
    this.rule,
    required this.startIndex,
    required this.endIndex,
    this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'severity': severity.name,
      'originalText': originalText,
      'correctedText': correctedText,
      'message': message,
      'rule': rule,
      'startIndex': startIndex,
      'endIndex': endIndex,
      'suggestions': suggestions,
    };
  }
}

/// 写作评分维度
class ScoringDimension {
  final String name;           // 维度名称
  final String description;    // 描述
  final double score;          // 得分
  final double maxScore;       // 满分
  final String? feedback;      // 反馈

  ScoringDimension({
    required this.name,
    required this.description,
    required this.score,
    required this.maxScore,
    this.feedback,
  });

  double get percentage => maxScore > 0 ? (score / maxScore) * 100 : 0;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'score': score,
      'maxScore': maxScore,
      'feedback': feedback,
    };
  }
}

/// 写作评估结果
class WritingEvaluation {
  final String taskId;
  final String userText;
  final double totalScore;              // 总分
  final double maxScore;                // 满分
  final List<WritingError> errors;      // 错误列表
  final List<ScoringDimension> dimensions; // 评分维度
  final String? generalFeedback;        // 总体反馈
  final String? improvedVersion;        // 改进版本
  final DateTime evaluatedAt;

  WritingEvaluation({
    required this.taskId,
    required this.userText,
    required this.totalScore,
    required this.maxScore,
    required this.errors,
    required this.dimensions,
    this.generalFeedback,
    this.improvedVersion,
    required this.evaluatedAt,
  });

  double get percentage => maxScore > 0 ? (totalScore / maxScore) * 100 : 0;

  int get errorCount => errors.length;

  Map<ErrorType, int> get errorsByType {
    final map = <ErrorType, int>{};
    for (final error in errors) {
      map[error.type] = (map[error.type] ?? 0) + 1;
    }
    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'userText': userText,
      'totalScore': totalScore,
      'maxScore': maxScore,
      'errors': errors.map((e) => e.toJson()).toList(),
      'dimensions': dimensions.map((d) => d.toJson()).toList(),
      'generalFeedback': generalFeedback,
      'improvedVersion': improvedVersion,
      'evaluatedAt': evaluatedAt.toIso8601String(),
    };
  }
}

/// 写作任务
class WritingTask {
  final String id;
  final String title;
  final WritingTaskType type;
  final WritingLevel level;
  final String prompt;                  // 题目要求
  final String? context;                // 上下文
  final int minWords;                   // 最少字数
  final int? maxWords;                  // 最多字数
  final int suggestedMinutes;           // 建议用时
  final List<String>? keyPoints;        // 要点提示
  final List<String>? usefulVocabulary; // 有用词汇
  final List<String>? usefulPhrases;    // 有用短语

  WritingTask({
    required this.id,
    required this.title,
    required this.type,
    required this.level,
    required this.prompt,
    this.context,
    required this.minWords,
    this.maxWords,
    required this.suggestedMinutes,
    this.keyPoints,
    this.usefulVocabulary,
    this.usefulPhrases,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'level': level.name,
      'prompt': prompt,
      'context': context,
      'minWords': minWords,
      'maxWords': maxWords,
      'suggestedMinutes': suggestedMinutes,
      'keyPoints': keyPoints,
      'usefulVocabulary': usefulVocabulary,
      'usefulPhrases': usefulPhrases,
    };
  }
}

/// 写作练习记录
class WritingPractice {
  final String taskId;
  final String userText;
  final WritingEvaluation? evaluation;  // 评估结果
  final DateTime startedAt;
  final DateTime? completedAt;
  final int timeSpentSeconds;

  WritingPractice({
    required this.taskId,
    required this.userText,
    this.evaluation,
    required this.startedAt,
    this.completedAt,
    required this.timeSpentSeconds,
  });

  bool get isCompleted => completedAt != null;

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'userText': userText,
      'evaluation': evaluation?.toJson(),
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'timeSpentSeconds': timeSpentSeconds,
    };
  }
}

/// 写作模板
class WritingTemplate {
  final String id;
  final String title;
  final WritingTaskType type;
  final WritingLevel level;
  final String description;
  final List<String> structure;         // 结构说明
  final List<String> usefulPhrases;     // 有用句型
  final String? example;                // 范文

  WritingTemplate({
    required this.id,
    required this.title,
    required this.type,
    required this.level,
    required this.description,
    required this.structure,
    required this.usefulPhrases,
    this.example,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'level': level.name,
      'description': description,
      'structure': structure,
      'usefulPhrases': usefulPhrases,
      'example': example,
    };
  }
}
