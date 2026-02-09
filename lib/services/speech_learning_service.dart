/// 演讲学习服务
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/speech_learning.dart';
import '../data/german_speeches.dart';

/// 演讲学习服务
class SpeechLearningService {
  static const String _progressKey = 'speech_progress';
  static const String _statisticsKey = 'speech_statistics';
  static const String _favoritesKey = 'speech_favorites';

  SharedPreferences? _prefs;
  List<SpeechProgress> _progressHistory = [];
  Set<String> _favoriteSpeeches = {};
  Map<String, SpeechStatistics> _statistics = {};

  /// 初始化服务
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadProgress();
    await _loadFavorites();
    await _loadStatistics();
  }

  /// 加载进度
  Future<void> _loadProgress() async {
    if (_prefs == null) return;

    final progressJson = _prefs!.getStringList(_progressKey) ?? [];
    _progressHistory = progressJson
        .map((json) => SpeechProgress.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存进度
  Future<void> _saveProgress() async {
    if (_prefs == null) return;

    final progressJson = _progressHistory.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs!.setStringList(_progressKey, progressJson);
  }

  /// 加载收藏
  Future<void> _loadFavorites() async {
    if (_prefs == null) return;

    final favoritesJson = _prefs!.getStringList(_favoritesKey) ?? [];
    _favoriteSpeeches = favoritesJson.toSet();
  }

  /// 保存收藏
  Future<void> _saveFavorites() async {
    if (_prefs == null) return;

    await _prefs!.setStringList(_favoritesKey, _favoriteSpeeches.toList());
  }

  /// 加载统计
  Future<void> _loadStatistics() async {
    if (_prefs == null) return;

    final statsJson = _prefs!.getString(_statisticsKey);
    if (statsJson != null) {
      final stats = jsonDecode(statsJson) as Map<String, dynamic>;
      _statistics = stats.map((key, value) =>
        MapEntry(key, SpeechStatistics.fromJson(value as Map<String, dynamic>)));
    }
  }

  /// 保存统计
  Future<void> _saveStatistics() async {
    if (_prefs == null) return;

    final statsJson = _statistics.map((key, value) =>
      MapEntry(key, jsonEncode(value.toJson())));
    await _prefs!.setString(_favoritesKey, statsJson);
  }

  /// 获取演讲列表
  List<Speech> getAllSpeeches() {
    return getAllSpeeches();
  }

  /// 根据难度获取演讲
  List<Speech> getSpeechesByDifficulty(SpeechDifficulty difficulty) {
    return getSpeechesByDifficulty(difficulty);
  }

  /// 根据主题获取演讲
  List<Speech> getSpeechesByTopic(SpeechTopic topic) {
    return getSpeechesByTopic(topic);
  }

  /// 根据性别获取演讲者
  List<Speaker> getSpeakersByGender(String gender) {
    return getSpeakersByGender(gender);
  }

  /// 获取推荐演讲
  Future<List<Speech>> getRecommendedSpeeches() async {
    await initialize();

    final allSpeeches = getAllSpeeches();

    // 基于学习历史的推荐
    final completedIds = _progressHistory
        .where((p) => p.completedAt != null)
        .map((p) => p.speechId)
        .toSet();

    // 过滤未完成的演讲
    final uncompletedSpeeches = allSpeeches
        .where((s) => !completedIds.contains(s.id))
        .toList();

    // 优先推荐同难度或稍低难度的演讲
    // TODO: 可以根据用户的学习水平进一步优化

    return uncompletedSpeeches.take(5).toList();
  }

  /// 开始学习演讲
  Future<void> startLearning(String speechId) async {
    await initialize();

    // 检查是否已有进度
    final existingProgress = _progressHistory.cast<SpeechProgress?>()
        .firstWhere((p) => p?.speechId == speechId, orElse: () => null);

    if (existingProgress == null) {
      // 创建新的学习记录
      final progress = SpeechProgress(
        speechId: speechId,
        startedAt: DateTime.now(),
        completedAt: null,
        completedSegments: [],
        favoriteSegments: [],
        notes: {},
        listenCount: 1,
        lastPosition: 0,
      );

      _progressHistory.add(progress);
      await _saveProgress();
    } else {
      // 更新听力次数
      final updatedProgress = SpeechProgress(
        speechId: existingProgress.speechId,
        startedAt: existingProgress.startedAt,
        completedAt: existingProgress.completedAt,
        completedSegments: existingProgress.completedSegments,
        favoriteSegments: existingProgress.favoriteSegments,
        notes: existingProgress.notes,
        listenCount: existingProgress.listenCount + 1,
        lastPosition: 0,
      );

      _progressHistory.remove(existingProgress);
      _progressHistory.add(updatedProgress);
      await _saveProgress();
    }

    await _updateStatistics(speechId);
  }

  /// 完成片段学习
  Future<void> completeSegment(String speechId, String segmentId) async {
    await initialize();

    final progress = _progressHistory.cast<SpeechProgress?>()
        .firstWhere((p) => p?.speechId == speechId, orElse: () => null);

    if (progress != null) {
      if (!progress.completedSegments.contains(segmentId)) {
        final updatedSegments = List<String>.from(progress.completedSegments);
        updatedSegments.add(segmentId);

        final updatedProgress = SpeechProgress(
          speechId: progress.speechId,
          startedAt: progress.startedAt,
          completedAt: progress.completedAt,
          completedSegments: updatedSegments,
          favoriteSegments: progress.favoriteSegments,
          notes: progress.notes,
          listenCount: progress.listenCount,
          lastPosition: progress.lastPosition,
        );

        _progressHistory.remove(progress);
        _progressHistory.add(updatedProgress);
        await _saveProgress();
      }
    }
  }

  /// 添加笔记
  Future<void> addNote(String speechId, String segmentId, String note) async {
    await initialize();

    final progress = _progressHistory.cast<SpeechProgress?>()
        .firstWhere((p) => p?.speechId == speechId, orElse: () => null);

    if (progress != null) {
      final updatedNotes = Map<String, String>.from(progress.notes);
      updatedNotes[segmentId] = note;

      final updatedProgress = SpeechProgress(
        speechId: progress.speechId,
        startedAt: progress.startedAt,
        completedAt: progress.completedAt,
        completedSegments: progress.completedSegments,
        favoriteSegments: progress.favoriteSegments,
        notes: updatedNotes,
        listenCount: progress.listenCount,
        lastPosition: progress.lastPosition,
      );

      _progressHistory.remove(progress);
      _progressHistory.add(updatedProgress);
      await _saveProgress();
    }
  }

  /// 收藏片段
  Future<void> favoriteSegment(String speechId, String segmentId) async {
    await initialize();

    final progress = _progressHistory.cast<SpeechProgress?>()
        .firstWhere((p) => p?.speechId == speechId, orElse: () => null);

    if (progress != null) {
      if (!progress.favoriteSegments.contains(segmentId)) {
        final updatedFavorites = List<String>.from(progress.favoriteSegments);
        updatedFavorites.add(segmentId);

        final updatedProgress = SpeechProgress(
          speechId: progress.speechId,
          startedAt: progress.startedAt,
          completedAt: progress.completedAt,
          completedSegments: progress.completedSegments,
          favoriteSegments: updatedFavorites,
          notes: progress.notes,
          listenCount: progress.listenCount,
          lastPosition: progress.lastPosition,
        );

        _progressHistory.remove(progress);
        _progressHistory.add(updatedProgress);
        await _saveProgress();
      }
    }
  }

  /// 更新播放位置
  Future<void> updatePosition(String speechId, int position) async {
    await initialize();

    final progress = _progressHistory.cast<SpeechProgress?>()
        .firstWhere((p) => p?.speechId == speechId, orElse: () => null);

    if (progress != null) {
      final updatedProgress = SpeechProgress(
        speechId: progress.speechId,
        startedAt: progress.startedAt,
        completedAt: progress.completedAt,
        completedSegments: progress.completedSegments,
        favoriteSegments: progress.favoriteSegments,
        notes: progress.notes,
        listenCount: progress.listenCount,
        lastPosition: position,
      );

      _progressHistory.remove(progress);
      _progressHistory.add(updatedProgress);
      await _saveProgress();
    }
  }

  /// 收藏演讲
  Future<void> favoriteSpeech(String speechId) async {
    await initialize();

    _favoriteSpeeches.add(speechId);
    await _saveFavorites();
  }

  /// 取消收藏演讲
  Future<void> unfavoriteSpeech(String speechId) async {
    await initialize();

    _favoriteSpeeches.remove(speechId);
    await _saveFavorites();
  }

  /// 检查是否已收藏
  bool isFavorited(String speechId) {
    return _favoriteSpeeches.contains(speechId);
  }

  /// 获取收藏列表
  List<String> getFavorites() {
    return _favoriteSpeeches.toList();
  }

  /// 获取学习进度
  SpeechProgress? getProgress(String speechId) {
    return _progressHistory.cast<SpeechProgress?>()
        .firstWhere((p) => p?.speechId == speechId, orElse: () => null);
  }

  /// 获取所有学习进度
  List<SpeechProgress> getAllProgress() {
    return List.from(_progressHistory);
  }

  /// 获取学习统计
  Future<SpeechStatistics> getStatistics() async {
    await initialize();

    // 计算统计数据
    final speechesListened = _progressHistory.length;
    final totalMinutes = _progressHistory.fold<int>(
      0,
      (sum, p) {
        final speech = getSpeechById(p.speechId);
        return sum + (speech?.duration ?? 0) ~/ 60;
      },
    );

    final byDifficulty = <SpeechDifficulty, int>{};
    final byTopic = <SpeechTopic, int>{};

    for (final progress in _progressHistory) {
      final speech = getSpeechById(progress.speechId);
      if (speech != null) {
        byDifficulty[speech.difficulty] =
            (byDifficulty[speech.difficulty] ?? 0) + 1;

        for (final topic in speech.topics) {
          byTopic[topic] = (byTopic[topic] ?? 0) + 1;
        }
      }
    }

    final favoriteSpeakers = <String>[];

    return SpeechStatistics(
      totalSpeechesListened: speechesListened,
      totalListeningMinutes: totalMinutes,
      speechesByDifficulty: byDifficulty,
      speechesByTopic: byTopic,
      favoriteSpeakers: favoriteSpeakers,
      totalSegmentsCompleted: _progressHistory.fold<int>(
        0,
        (sum, p) => sum + p.completedSegments.length,
      ),
    );
  }

  /// 更新统计信息
  Future<void> _updateStatistics(String speechId) async {
    final stats = await getStatistics();

    _statistics['global'] = stats;
    await _saveStatistics();
  }

  /// 获取演讲学习建议
  List<String> getLearningTips(Speech speech) {
    final tips = <String>[];

    // 基于难度的建议
    switch (speech.difficulty) {
      case SpeechDifficulty.beginner:
        tips.add('建议先阅读转录文本，了解大意');
        tips.add('可以以0.75倍速播放');
        tips.add('重点学习基础词汇');
        break;
      case SpeechDifficulty.intermediate:
        tips.add('尝试不看文本听一遍');
        tips.add('注意演讲者的语气和停顿');
        tips.add('学习地道的表达方式');
        break;
      case SpeechDifficulty.advanced:
        tips.add('挑战1.25倍速播放');
        tips.add('尝试做笔记总结要点');
        tips.add('模仿演讲者的语调和发音');
        break;
      case SpeechDifficulty.expert:
        tips.add('完全脱稿听写');
        tips.add('分析演讲的逻辑结构');
        tips.add('学习专业术语和文化背景');
        break;
    }

    // 基于演讲类型的建议
    switch (speech.type) {
      case SpeechType.political:
        tips.add('注意正式的政治用语');
        tips.add('学习演讲的说服技巧');
        break;
      case SpeechType.business:
        tips.add('了解相关的商业术语');
        tips.add('注意专业表达方式');
        break;
      case SpeechType.tedTalk:
        tips.add('TED演讲通常较通俗易懂');
        tips.add('学习演讲者的个人风格');
        break;
      default:
        break;
    }

    return tips;
  }

  /// 清除所有数据
  Future<void> clearAllData() async {
    await initialize();

    _progressHistory.clear();
    _favoriteSpeeches.clear();
    _statistics.clear();

    await _saveProgress();
    await _saveFavorites();
    await _saveStatistics();
  }
}
