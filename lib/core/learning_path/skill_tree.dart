/// 技能树系统
///
/// 基于科学学习理论设计，确保学习者在最近发展区(ZPD)内学习
library;

import '../grammar_engine.dart';

/// 技能类型
enum SkillType {
  vocabulary,      // 词汇
  grammar,         // 语法
  listening,       // 听力
  reading,         // 阅读
  writing,         // 写作
  speaking,        // 口语
  pronunciation,   // 发音
}

/// 技能节点
class SkillNode {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final LanguageLevel level;

  // 前置技能依赖
  final List<String> prerequisites;

  // 掌握要求
  final double masteryThreshold;  // 0-1，默认0.8
  final int minPracticeCount;     // 最少练习次数
  final double minAccuracy;       // 最低正确率

  // 学习资源
  final List<String> exerciseIds;
  final List<String> vocabularyIds;
  final List<String> readingIds;

  // 当前状态
  double currentMastery;          // 当前掌握度 0-1
  int practiceCount;              // 已练习次数
  double averageAccuracy;         // 平均正确率

  SkillNode({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.level,
    this.prerequisites = const [],
    this.masteryThreshold = 0.8,
    this.minPracticeCount = 5,
    this.minAccuracy = 0.75,
    this.exerciseIds = const [],
    this.vocabularyIds = const [],
    this.readingIds = const [],
    this.currentMastery = 0.0,
    this.practiceCount = 0,
    this.averageAccuracy = 0.0,
  });

  /// 是否已解锁
  bool isUnlocked(Map<String, double> masteredSkills) {
    return prerequisites.every((preId) {
      final mastery = masteredSkills[preId] ?? 0.0;
      return mastery >= masteryThreshold;
    });
  }

  /// 是否已掌握
  bool get isMastered {
    return currentMastery >= masteryThreshold &&
           practiceCount >= minPracticeCount &&
           averageAccuracy >= minAccuracy;
  }

  /// 是否可以开始（已解锁且未掌握）
  bool canStart(Map<String, double> masteredSkills) {
    return isUnlocked(masteredSkills) && !isMastered;
  }

  /// 更新进度
  SkillNode updateProgress({
    required double newAccuracy,
    int additionalPractice = 1,
  }) {
    // 使用指数移动平均计算平均正确率
    double newAverageAccuracy = averageAccuracy;
    if (practiceCount == 0) {
      newAverageAccuracy = newAccuracy;
    } else {
      // 新数据的权重是0.3
      newAverageAccuracy = (averageAccuracy * 0.7) + (newAccuracy * 0.3);
    }

    // 计算掌握度（综合考虑正确率、练习次数）
    double newMastery = (newAverageAccuracy * 0.6) +
                        ((practiceCount + additionalPractice) / minPracticeCount * 0.4);
    newMastery = newMastery.clamp(0.0, 1.0);

    return SkillNode(
      id: id,
      name: name,
      description: description,
      type: type,
      level: level,
      prerequisites: prerequisites,
      masteryThreshold: masteryThreshold,
      minPracticeCount: minPracticeCount,
      minAccuracy: minAccuracy,
      exerciseIds: exerciseIds,
      vocabularyIds: vocabularyIds,
      readingIds: readingIds,
      currentMastery: newMastery,
      practiceCount: practiceCount + additionalPractice,
      averageAccuracy: newAverageAccuracy,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'level': level.name,
      'prerequisites': prerequisites,
      'masteryThreshold': masteryThreshold,
      'minPracticeCount': minPracticeCount,
      'minAccuracy': minAccuracy,
      'exerciseIds': exerciseIds,
      'vocabularyIds': vocabularyIds,
      'readingIds': readingIds,
      'currentMastery': currentMastery,
      'practiceCount': practiceCount,
      'averageAccuracy': averageAccuracy,
    };
  }

  /// 从JSON创建
  factory SkillNode.fromJson(Map<String, dynamic> json) {
    return SkillNode(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: SkillType.values.firstWhere((e) => e.name == json['type']),
      level: LanguageLevel.values.firstWhere((e) => e.name == json['level']),
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      masteryThreshold: (json['masteryThreshold'] as num).toDouble(),
      minPracticeCount: json['minPracticeCount'] as int? ?? 5,
      minAccuracy: (json['minAccuracy'] as num?)?.toDouble() ?? 0.75,
      exerciseIds: List<String>.from(json['exerciseIds'] ?? []),
      vocabularyIds: List<String>.from(json['vocabularyIds'] ?? []),
      readingIds: List<String>.from(json['readingIds'] ?? []),
      currentMastery: (json['currentMastery'] as num?)?.toDouble() ?? 0.0,
      practiceCount: json['practiceCount'] as int? ?? 0,
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// 技能树
class SkillTree {
  final Map<String, SkillNode> nodes;

  const SkillTree({required this.nodes});

  /// 获取可学习的技能
  List<SkillNode> getAvailableSkills(Map<String, double> masteredSkills) {
    return nodes.values
        .where((node) => node.canStart(masteredSkills))
        .toList()
      ..sort((a, b) => b.level.index.compareTo(a.level.index)); // 优先学习低级别
  }

  /// 获取已掌握的技能
  List<SkillNode> getMasteredSkills() {
    return nodes.values.where((node) => node.isMastered).toList();
  }

  /// 获取技能依赖链
  List<SkillNode> getDependencyChain(String skillId) {
    List<SkillNode> chain = [];
    SkillNode? current = nodes[skillId];

    while (current != null) {
      chain.insert(0, current);
      if (current.prerequisites.isEmpty) break;
      current = nodes[current.prerequisites.first];
    }

    return chain;
  }

  /// 更新技能进度
  SkillTree updateSkillProgress(
    String skillId,
    double newAccuracy,
    int additionalPractice,
  ) {
    final node = nodes[skillId];
    if (node == null) return this;

    final updatedNode = node.updateProgress(
      newAccuracy: newAccuracy,
      additionalPractice: additionalPractice,
    );

    return SkillTree(nodes: {...nodes, skillId: updatedNode});
  }

  /// 计算整体进度
  double calculateOverallProgress() {
    if (nodes.isEmpty) return 0.0;

    final totalMastery = nodes.values
        .map((node) => node.currentMastery)
        .reduce((a, b) => a + b);

    return totalMastery / nodes.length;
  }

  /// 获取推荐学习路径
  List<SkillNode> getRecommendedPath(Map<String, double> masteredSkills) {
    final available = getAvailableSkills(masteredSkills);

    // 按优先级排序
    available.sort((a, b) {
      // 1. 优先学习前置技能少的
      final aPreCount = a.prerequisites.length;
      final bPreCount = b.prerequisites.length;
      if (aPreCount != bPreCount) {
        return aPreCount.compareTo(bPreCount);
      }

      // 2. 优先学习低级别的
      if (a.level != b.level) {
        return a.level.index.compareTo(b.level.index);
      }

      // 3. 优先学习掌握度接近阈值的
      final aProgress = a.currentMastery / a.masteryThreshold;
      final bProgress = b.currentMastery / b.masteryThreshold;
      return bProgress.compareTo(aProgress);
    });

    return available;
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  /// 从JSON创建
  factory SkillTree.fromJson(Map<String, dynamic> json) {
    final nodesMap = <String, SkillNode>{};
    final nodesData = json['nodes'] as Map<String, dynamic>;

    nodesData.forEach((key, value) {
      nodesMap[key] = SkillNode.fromJson(value as Map<String, dynamic>);
    });

    return SkillTree(nodes: nodesMap);
  }
}
