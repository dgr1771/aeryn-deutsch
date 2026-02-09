/// 听力训练材料模型
library;

import 'package:flutter/foundation.dart';

/// 听力材料等级
enum ListeningLevel {
  A1,
  A2,
  B1,
  B2,
}

/// 听力材料类型
enum ListeningType {
  dialogue,        // 对话
  monologue,       // 独白
  announcement,    // 公告
  interview,       // 采访
  lecture,         // 讲座
  news,            // 新闻
}

/// 听力理解题目类型
enum QuestionType {
  multipleChoice,  // 选择题
  trueFalse,      // 判断题
  fillInBlank,    // 填空题
  shortAnswer,    // 简答题
}

/// 听力题目
class ListeningQuestion {
  final String id;
  final QuestionType type;
  final String question;
  final List<String>? options;        // 选择题选项
  final String? correctAnswer;        // 正确答案
  final int? startTime;               // 题目对应音频开始时间(秒)
  final int? endTime;                 // 题目对应音频结束时间(秒)
  final String? explanation;          // 解析

  ListeningQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.correctAnswer,
    this.startTime,
    this.endTime,
    this.explanation,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) {
    return ListeningQuestion(
      id: json['id'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      question: json['question'] as String,
      options: json['options'] as List<String>?,
      correctAnswer: json['correctAnswer'] as String?,
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'startTime': startTime,
      'endTime': endTime,
      'explanation': explanation,
    };
  }
}

/// 听力材料
class ListeningMaterial {
  final String id;
  final String title;
  final ListeningLevel level;
  final ListeningType type;
  final String topic;                  // 主题
  final String content;                // 文本内容（用于显示 transcript）
  final String? audioPath;             // 音频文件路径
  final int duration;                  // 时长（秒）
  final List<ListeningQuestion> questions;  // 题目
  final String? vocabulary;            // 重点词汇
  final String? culturalNote;          // 文化注释

  ListeningMaterial({
    required this.id,
    required this.title,
    required this.level,
    required this.type,
    required this.topic,
    required this.content,
    this.audioPath,
    required this.duration,
    required this.questions,
    this.vocabulary,
    this.culturalNote,
  });

  factory ListeningMaterial.fromJson(Map<String, dynamic> json) {
    return ListeningMaterial(
      id: json['id'] as String,
      title: json['title'] as String,
      level: ListeningLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => ListeningLevel.A1,
      ),
      type: ListeningType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ListeningType.dialogue,
      ),
      topic: json['topic'] as String,
      content: json['content'] as String,
      audioPath: json['audioPath'] as String?,
      duration: json['duration'] as int,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => ListeningQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      vocabulary: json['vocabulary'] as String?,
      culturalNote: json['culturalNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'level': level.name,
      'type': type.name,
      'topic': topic,
      'content': content,
      'audioPath': audioPath,
      'duration': duration,
      'questions': questions.map((q) => q.toJson()).toList(),
      'vocabulary': vocabulary,
      'culturalNote': culturalNote,
    };
  }
}

/// 听力训练记录
class ListeningProgress {
  final String materialId;
  final DateTime timestamp;
  final int? score;                   // 得分
  final int totalScore;               // 总分
  final List<String> correctAnswers;  // 正确答案
  final List<String> wrongAnswers;    // 错误答案
  final int listenCount;              // 听的次数
  final bool isCompleted;             // 是否完成

  ListeningProgress({
    required this.materialId,
    required this.timestamp,
    this.score,
    required this.totalScore,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.listenCount,
    required this.isCompleted,
  });

  double get accuracy {
    if (totalScore == 0) return 0.0;
    return (score ?? 0) / totalScore;
  }

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'timestamp': timestamp.toIso8601String(),
      'score': score,
      'totalScore': totalScore,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'listenCount': listenCount,
      'isCompleted': isCompleted,
    };
  }

  factory ListeningProgress.fromJson(Map<String, dynamic> json) {
    return ListeningProgress(
      materialId: json['materialId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      score: json['score'] as int?,
      totalScore: json['totalScore'] as int,
      correctAnswers: List<String>.from(json['correctAnswers'] as List),
      wrongAnswers: List<String>.from(json['wrongAnswers'] as List),
      listenCount: json['listenCount'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}

/// 听力统计信息
class ListeningStatistics {
  final int totalMaterials;         // 总材料数
  final int completedMaterials;     // 完成的材料数
  final int totalListeningTime;     // 总听力时长（秒）
  final double averageAccuracy;     // 平均正确率
  final Map<ListeningLevel, int> progressByLevel;  // 各等级进度

  ListeningStatistics({
    required this.totalMaterials,
    required this.completedMaterials,
    required this.totalListeningTime,
    required this.averageAccuracy,
    required this.progressByLevel,
  });

  double get completionRate {
    if (totalMaterials == 0) return 0.0;
    return completedMaterials / totalMaterials;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMaterials': totalMaterials,
      'completedMaterials': completedMaterials,
      'totalListeningTime': totalListeningTime,
      'averageAccuracy': averageAccuracy,
      'progressByLevel': progressByLevel.map(
        (key, value) => MapEntry(key.name, value),
      ),
    };
  }
}
