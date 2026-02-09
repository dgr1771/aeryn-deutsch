/// 问题模型
///
/// 用于阅读理解、词汇练习和语法练习的问题
library;

import 'word.dart';
import '../core/grammar_engine.dart';

/// 问题类型
enum QuestionType {
  multipleChoice,      // 选择题
  trueFalse,           // 判断题
  openEnded,           // 开放题
  fillInBlanks,        // 填空题
  matching,            // 配对题
  translation,         // 翻译题
  ordering,            // 排序题
  vocabulary,          // 词汇题
  grammar,             // 语法题
  comprehension,       // 理解题
}

/// 难度级别
enum QuestionDifficulty {
  veryEasy,            // 非常简单
  easy,                // 简单
  medium,              // 中等
  difficult,           // 困难
  veryDifficult,       // 非常困难
}

/// 问题选项
class QuestionOption {
  final String id;
  final String text;
  final bool isCorrect;
  final String? explanation;

  const QuestionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
      'explanation': explanation,
    };
  }

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
      explanation: json['explanation'],
    );
  }
}

/// 问题模型
class Question {
  final String id;
  final QuestionType type;
  final QuestionDifficulty difficulty;
  final String question;
  final List<QuestionOption>? options;
  final String? correctAnswer;
  final String? explanation;
  final String? hint;
  final int points;
  final LanguageLevel targetLevel;
  final DateTime createdAt;
  final List<String>? tags;

  // 关联信息
  final String? sourceId;           // 来源ID（如阅读材料ID）
  final String? sourceType;         // 来源类型（reading, vocabulary, grammar）
  final List<Word>? relatedWords;   // 相关词汇
  final GrammarTopic? relatedGrammar; // 相关语法主题

  const Question({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.targetLevel,
    this.options,
    this.correctAnswer,
    this.explanation,
    this.hint,
    this.points = 10,
    DateTime? createdAt,
    this.tags,
    this.sourceId,
    this.sourceType,
    this.relatedWords,
    this.relatedGrammar,
  }) : createdAt = createdAt ?? const Duration();

  /// 计算难度得分 (0-100)
  int get difficultyScore {
    switch (difficulty) {
      case QuestionDifficulty.veryEasy:
        return 20;
      case QuestionDifficulty.easy:
        return 40;
      case QuestionDifficulty.medium:
        return 60;
      case QuestionDifficulty.difficult:
        return 80;
      case QuestionDifficulty.veryDifficult:
        return 100;
    }
  }

  /// 获取正确选项
  QuestionOption? get correctOption {
    if (options == null) return null;
    try {
      return options!.firstWhere((option) => option.isCorrect);
    } catch (e) {
      return null;
    }
  }

  /// 验证答案
  bool isAnswerCorrect(String answer) {
    if (type == QuestionType.multipleChoice) {
      final option = options?.firstWhere(
        (opt) => opt.id == answer,
        orElse: () => const QuestionOption(
          id: '',
          text: '',
          isCorrect: false,
        ),
      );
      return option.isCorrect;
    } else {
      return answer == correctAnswer;
    }
  }

  /// 获取标准化答案
  String? get normalizedAnswer {
    return correctAnswer?.trim().toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'difficulty': difficulty.name,
      'question': question,
      'options': options?.map((opt) => opt.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'hint': hint,
      'points': points,
      'targetLevel': targetLevel.name,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'sourceId': sourceId,
      'sourceType': sourceType,
      'relatedWords': relatedWords?.map((w) => w.word).toList(),
      'relatedGrammar': relatedGrammar?.name,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: QuestionType.values.firstWhere((e) => e.name == json['type']),
      difficulty: QuestionDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),
      question: json['question'],
      options: (json['options'] as List<dynamic>?)
          ?.map((opt) => QuestionOption.fromJson(opt))
          .toList(),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      hint: json['hint'],
      points: json['points'] ?? 10,
      targetLevel: LanguageLevel.values.firstWhere(
        (e) => e.name == json['targetLevel'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      sourceId: json['sourceId'],
      sourceType: json['sourceType'],
    );
  }

  /// 复制并修改
  Question copyWith({
    String? id,
    QuestionType? type,
    QuestionDifficulty? difficulty,
    String? question,
    List<QuestionOption>? options,
    String? correctAnswer,
    String? explanation,
    String? hint,
    int? points,
    LanguageLevel? targetLevel,
    DateTime? createdAt,
    List<String>? tags,
    String? sourceId,
    String? sourceType,
    List<Word>? relatedWords,
    GrammarTopic? relatedGrammar,
  }) {
    return Question(
      id: id ?? this.id,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      hint: hint ?? this.hint,
      points: points ?? this.points,
      targetLevel: targetLevel ?? this.targetLevel,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      relatedWords: relatedWords ?? this.relatedWords,
      relatedGrammar: relatedGrammar ?? this.relatedGrammar,
    );
  }
}

/// 问题集
class QuestionSet {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int totalPoints;
  final LanguageLevel targetLevel;
  final DateTime createdAt;

  const QuestionSet({
    required this.id,
    required this.title,
    required this.questions,
    required this.targetLevel,
    this.description = '',
    DateTime? createdAt,
  })  : totalPoints = questions.fold(0, (sum, q) => sum + q.points),
        createdAt = createdAt ?? const Duration();

  /// 获取难度分布
  Map<QuestionDifficulty, int> get difficultyDistribution {
    final distribution = <QuestionDifficulty, int>{};
    for (final question in questions) {
      distribution[question.difficulty] =
          (distribution[question.difficulty] ?? 0) + 1;
    }
    return distribution;
  }

  /// 获取类型分布
  Map<QuestionType, int> get typeDistribution {
    final distribution = <QuestionType, int>{};
    for (final question in questions) {
      distribution[question.type] = (distribution[question.type] ?? 0) + 1;
    }
    return distribution;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'totalPoints': totalPoints,
      'targetLevel': targetLevel.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuestionSet.fromJson(Map<String, dynamic> json) {
    return QuestionSet(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q))
          .toList(),
      targetLevel: LanguageLevel.values.firstWhere(
        (e) => e.name == json['targetLevel'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// 用户答案记录
class UserAnswer {
  final String id;
  final String questionId;
  final String userId;
  final String answer;
  final bool isCorrect;
  final int pointsEarned;
  final DateTime answeredAt;
  final Duration? timeTaken;
  final String? note;

  const UserAnswer({
    required this.id,
    required this.questionId,
    required this.userId,
    required this.answer,
    required this.isCorrect,
    required this.pointsEarned,
    required this.answeredAt,
    this.timeTaken,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'userId': userId,
      'answer': answer,
      'isCorrect': isCorrect,
      'pointsEarned': pointsEarned,
      'answeredAt': answeredAt.toIso8601String(),
      'timeTaken': timeTaken?.inSeconds,
      'note': note,
    };
  }

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id'],
      questionId: json['questionId'],
      userId: json['userId'],
      answer: json['answer'],
      isCorrect: json['isCorrect'],
      pointsEarned: json['pointsEarned'],
      answeredAt: DateTime.parse(json['answeredAt']),
      timeTaken: json['timeTaken'] != null
          ? Duration(seconds: json['timeTaken'])
          : null,
      note: json['note'],
    );
  }
}
