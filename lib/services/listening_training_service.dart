/// 听力训练服务
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/listening_material.dart';

/// 听力训练服务
class ListeningTrainingService {
  static const String _progressKey = 'listening_progress';
  static const String _statisticsKey = 'listening_statistics';

  SharedPreferences? _prefs;
  List<ListeningProgress> _progressHistory = [];
  int _currentListenTime = 0;

  /// 初始化服务
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadProgress();
    await _loadStatistics();
  }

  /// 加载进度
  Future<void> _loadProgress() async {
    if (_prefs == null) return;

    final progressJson = _prefs!.getStringList(_progressKey) ?? [];
    _progressHistory = progressJson
        .map((json) => ListeningProgress.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存进度
  Future<void> _saveProgress() async {
    if (_prefs == null) return;

    final progressJson =
        _progressHistory.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs!.setStringList(_progressKey, progressJson);
  }

  /// 加载统计信息
  Future<void> _loadStatistics() async {
    if (_prefs == null) return;

    final statsJson = _prefs!.getString(_statisticsKey);
    if (statsJson != null) {
      final stats = jsonDecode(statsJson) as Map<String, dynamic>;
      _currentListenTime = stats['totalListeningTime'] as int? ?? 0;
    }
  }

  /// 保存统计信息
  Future<void> _saveStatistics() async {
    if (_prefs == null) return;

    final stats = {
      'totalListeningTime': _currentListenTime,
    };
    await _prefs!.setString(_statisticsKey, jsonEncode(stats));
  }

  /// 获取材料的听力进度
  ListeningProgress? getMaterialProgress(String materialId) {
    try {
      return _progressHistory.firstWhere(
        (p) => p.materialId == materialId,
      );
    } catch (e) {
      return null;
    }
  }

  /// 记录听力行为
  Future<void> recordListening({
    required String materialId,
    required int durationSeconds,
  }) async {
    await initialize();

    // 更新总听力时长
    _currentListenTime += durationSeconds;
    await _saveStatistics();

    // 更新该材料的听力次数
    final existingProgress = getMaterialProgress(materialId);
    if (existingProgress != null) {
      final updatedProgress = ListeningProgress(
        materialId: materialId,
        timestamp: existingProgress.timestamp,
        score: existingProgress.score,
        totalScore: existingProgress.totalScore,
        correctAnswers: existingProgress.correctAnswers,
        wrongAnswers: existingProgress.wrongAnswers,
        listenCount: existingProgress.listenCount + 1,
        isCompleted: existingProgress.isCompleted,
      );

      // 移除旧记录，添加新记录
      _progressHistory.removeWhere((p) => p.materialId == materialId);
      _progressHistory.add(updatedProgress);
      await _saveProgress();
    } else {
      // 创建新记录
      final newProgress = ListeningProgress(
        materialId: materialId,
        timestamp: DateTime.now(),
        totalScore: 0,
        correctAnswers: [],
        wrongAnswers: [],
        listenCount: 1,
        isCompleted: false,
      );
      _progressHistory.add(newProgress);
      await _saveProgress();
    }
  }

  /// 提交答案并评分
  Future<ListeningProgress> submitAnswers({
    required String materialId,
    required int totalScore,
    required Map<String, String> answers,
  }) async {
    await initialize();

    final material = await getMaterialById(materialId);
    if (material == null) {
      throw Exception('Material not found: $materialId');
    }

    final correctAnswers = <String>[];
    final wrongAnswers = <String>[];
    var score = 0;

    // 评分
    for (final question in material.questions) {
      final userAnswer = answers[question.id];
      if (userAnswer == null) continue;

      if (userAnswer == question.correctAnswer) {
        score++;
        correctAnswers.add(question.id);
      } else {
        wrongAnswers.add(question.id);
      }
    }

    // 更新进度
    final existingProgress = getMaterialProgress(materialId);
    final updatedProgress = ListeningProgress(
      materialId: materialId,
      timestamp: DateTime.now(),
      score: score,
      totalScore: totalScore,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      listenCount: existingProgress?.listenCount ?? 1,
      isCompleted: true,
    );

    // 移除旧记录，添加新记录
    _progressHistory.removeWhere((p) => p.materialId == materialId);
    _progressHistory.add(updatedProgress);
    await _saveProgress();

    return updatedProgress;
  }

  /// 获取听力统计信息
  Future<ListeningStatistics> getStatistics() async {
    await initialize();

    final allMaterials = await getAllMaterials();
    final completedCount = _progressHistory
        .where((p) => p.isCompleted)
        .length;

    // 计算平均正确率
    double averageAccuracy = 0.0;
    final completedProgress =
        _progressHistory.where((p) => p.isCompleted).toList();
    if (completedProgress.isNotEmpty) {
      final totalAccuracy = completedProgress
          .map((p) => p.accuracy)
          .reduce((a, b) => a + b);
      averageAccuracy = totalAccuracy / completedProgress.length;
    }

    // 计算各等级进度
    final progressByLevel = <ListeningLevel, int>{};
    for (final level in ListeningLevel.values) {
      final levelMaterials = allMaterials.where((m) => m.level == level).length;
      final levelCompleted = _progressHistory
          .where((p) => p.isCompleted)
          .where((p) {
            final material = allMaterials.firstWhere(
              (m) => m.id == p.materialId,
            );
            return material.level == level;
          })
          .length;
      progressByLevel[level] = levelCompleted;
    }

    return ListeningStatistics(
      totalMaterials: allMaterials.length,
      completedMaterials: completedCount,
      totalListeningTime: _currentListenTime,
      averageAccuracy: averageAccuracy,
      progressByLevel: progressByLevel,
    );
  }

  /// 获取推荐材料
  Future<List<ListeningMaterial>> getRecommendedMaterials() async {
    await initialize();

    final allMaterials = await getAllMaterials();
    final completedIds =
        _progressHistory.where((p) => p.isCompleted).map((p) => p.materialId).toSet();

    // 过滤未完成的材料
    final uncompletedMaterials = allMaterials
        .where((m) => !completedIds.contains(m.id))
        .toList();

    // 如果没有未完成的，返回正确率较低的材料
    if (uncompletedMaterials.isEmpty) {
      final lowAccuracyProgress = _progressHistory
          .where((p) => p.isCompleted && p.accuracy < 0.8)
          .map((p) => p.materialId)
          .toSet();

      return allMaterials.where((m) => lowAccuracyProgress.contains(m.id)).toList();
    }

    // 优先推荐同等级的未完成材料
    // TODO: 可以根据用户的学习等级进一步优化
    return uncompletedMaterials;
  }

  /// 重置进度
  Future<void> resetProgress(String materialId) async {
    await initialize();

    _progressHistory.removeWhere((p) => p.materialId == materialId);
    await _saveProgress();
  }

  /// 重置所有进度
  Future<void> resetAllProgress() async {
    await initialize();

    _progressHistory.clear();
    _currentListenTime = 0;
    await _saveProgress();
    await _saveStatistics();
  }

  /// 计算题目正确答案（用于自动评分）
  String? getCorrectAnswer(String materialId, String questionId) {
    // 这里需要获取材料数据
    // 实际实现需要从数据库或数据文件中获取
    return null; // TODO: 实现
  }

  /// 辅助方法：获取材料
  Future<ListeningMaterial?> getMaterialById(String id) async {
    // TODO: 从数据源获取材料
    return null;
  }

  /// 辅助方法：获取所有材料
  Future<List<ListeningMaterial>> getAllMaterials() async {
    // TODO: 从数据源获取所有材料
    return [];
  }

  /// 获取特定等级的材料数量
  Future<int> getMaterialCountByLevel(ListeningLevel level) async {
    final allMaterials = await getAllMaterials();
    return allMaterials.where((m) => m.level == level).length;
  }

  /// 获取特定类型的材料数量
  Future<int> getMaterialCountByType(ListeningType type) async {
    final allMaterials = await getAllMaterials();
    return allMaterials.where((m) => m.type == type).length;
  }
}
