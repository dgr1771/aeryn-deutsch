/// 个性化学习路径模型
library;

/// 学习目标类型
enum LearningGoalType {
  vocabulary,           // 词汇目标
  grammar,             // 语法目标
  communication,       // 交际目标
  examPreparation,     // 考试准备
  skillImprovement,    // 技能提升
}

/// 学习资源类型
enum ResourceType {
  vocabulary,          // 词汇练习
  grammar,             // 语法讲解
  reading,             // 阅读材料
  listening,           // 听力练习
  writing,             // 写作任务
  speaking,            // 口语练习
  test,                // 测试
  video,               // 视频
  article,             // 文章
}

/// 难度等级
enum DifficultyLevel {
  beginner,            // 初级
  intermediate,        // 中级
  advanced,            // 高级
}

/// 学习步骤
class LearningStep {
  final String id;
  final String title;
  final String description;
  final ResourceType resourceType;
  final String resourceId;               // 资源ID
  final int estimatedMinutes;            // 预计用时（分钟）
  final bool isCompleted;
  final DateTime? completedAt;
  final double? score;                   // 得分（如果有）

  LearningStep({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceType,
    required this.resourceId,
    required this.estimatedMinutes,
    required this.isCompleted,
    this.completedAt,
    this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'resourceType': resourceType.name,
      'resourceId': resourceId,
      'estimatedMinutes': estimatedMinutes,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'score': score,
    };
  }

  factory LearningStep.fromJson(Map<String, dynamic> json) {
    return LearningStep(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      resourceType: ResourceType.values.firstWhere(
        (e) => e.name == json['resourceType'],
      ),
      resourceId: json['resourceId'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      score: (json['score'] as num?)?.toDouble(),
    );
  }
}

/// 学习阶段
class LearningPhase {
  final String id;
  final String title;
  final String description;
  final int order;
  final List<LearningStep> steps;
  final bool isLocked;
  final bool isCompleted;

  LearningPhase({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.steps,
    required this.isLocked,
    required this.isCompleted,
  });

  double get completionRate {
    if (steps.isEmpty) return 0.0;
    final completedSteps = steps.where((s) => s.isCompleted).length;
    return completedSteps / steps.length;
  }

  int get totalEstimatedMinutes {
    return steps.fold<int>(
      0,
      (sum, step) => sum + step.estimatedMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'steps': steps.map((s) => s.toJson()).toList(),
      'isLocked': isLocked,
      'isCompleted': isCompleted,
    };
  }

  factory LearningPhase.fromJson(Map<String, dynamic> json) {
    return LearningPhase(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      steps: (json['steps'] as List<dynamic>)
          .map((s) => LearningStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      isLocked: json['isLocked'] as bool,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}

/// 学习路径
class LearningPath {
  final String id;
  final String name;
  final String description;
  final LearningGoalType goalType;
  final DifficultyLevel difficulty;
  final int estimatedDays;               // 预计完成天数
  final int totalEstimatedMinutes;       // 总预计用时（分钟）
  final List<LearningPhase> phases;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double progress;                 // 总进度（0-1）

  LearningPath({
    required this.id,
    required this.name,
    required this.description,
    required this.goalType,
    required this.difficulty,
    required this.estimatedDays,
    required this.totalEstimatedMinutes,
    required this.phases,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    required this.progress,
  });

  double get completionPercentage => progress * 100;

  int get completedPhases {
    return phases.where((p) => p.isCompleted).length;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'goalType': goalType.name,
      'difficulty': difficulty.name,
      'estimatedDays': estimatedDays,
      'totalEstimatedMinutes': totalEstimatedMinutes,
      'phases': phases.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'progress': progress,
    };
  }

  factory LearningPath.fromJson(Map<String, dynamic> json) {
    return LearningPath(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      goalType: LearningGoalType.values.firstWhere(
        (e) => e.name == json['goalType'],
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),
      estimatedDays: json['estimatedDays'] as int,
      totalEstimatedMinutes: json['totalEstimatedMinutes'] as int,
      phases: (json['phases'] as List<dynamic>)
          .map((p) => LearningPhase.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      progress: (json['progress'] as num).toDouble(),
    );
  }
}

/// 学习推荐
class LearningRecommendation {
  final String id;
  final String title;
  final String description;
  final ResourceType resourceType;
  final String resourceId;
  final String reason;                     // 推荐理由
  final double priority;                   // 优先级（0-1）
  final int estimatedMinutes;

  LearningRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceType,
    required this.resourceId,
    required this.reason,
    required this.priority,
    required this.estimatedMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'resourceType': resourceType.name,
      'resourceId': resourceId,
      'reason': reason,
      'priority': priority,
      'estimatedMinutes': estimatedMinutes,
    };
  }
}

/// 学习诊断结果
class LearningDiagnosis {
  final Map<String, double> skillLevels;           // 技能水平（0-1）
  final List<String> weakPoints;                   // 弱项
  final List<String> strongPoints;                 // 强项
  final List<LearningRecommendation> recommendations;  // 推荐

  LearningDiagnosis({
    required this.skillLevels,
    required this.weakPoints,
    required this.strongPoints,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'skillLevels': skillLevels,
      'weakPoints': weakPoints,
      'strongPoints': strongPoints,
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
    };
  }
}
