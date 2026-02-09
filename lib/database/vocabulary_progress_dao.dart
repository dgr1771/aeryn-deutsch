/// 词汇进度数据访问对象
///
/// 管理词汇学习和复习进度的数据库操作
library;

import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'user_progress_dao.dart' show VocabularyProgressEntity;
import '../core/grammar_engine.dart';

/// 词汇进度DAO
class VocabularyProgressDAO {
  final DatabaseHelper _dbHelper;

  VocabularyProgressDAO(this._dbHelper);

  /// 保存或更新词汇进度
  Future<void> saveVocabularyProgress(VocabularyProgressEntity progress) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableVocabularyProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取用户的所有词汇进度
  Future<List<VocabularyProgressEntity>> getUserVocabularyProgress(
    String userId,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableVocabularyProgress,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => VocabularyProgressEntity.fromMap(map)).toList();
  }

  /// 获取特定词汇进度
  Future<VocabularyProgressEntity?> getVocabularyProgress(
    String wordId,
    String userId,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableVocabularyProgress,
      where: 'word_id = ? AND user_id = ?',
      whereArgs: [wordId, userId],
    );

    if (maps.isNotEmpty) {
      return VocabularyProgressEntity.fromMap(maps.first);
    }
    return null;
  }

  /// 获取需要复习的词汇
  Future<List<VocabularyProgressEntity>> getWordsForReview(
    String userId,
  ) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();

    final maps = await db.query(
      DatabaseHelper.tableVocabularyProgress,
      where: 'user_id = ? AND next_review_date <= ?',
      whereArgs: [userId, now.toIso8601String()],
      orderBy: 'next_review_date ASC',
    );

    return maps.map((map) => VocabularyProgressEntity.fromMap(map)).toList();
  }

  /// 获取新学词汇（复习次数为0）
  Future<List<VocabularyProgressEntity>> getNewWords(
    String userId,
    LanguageLevel level,
  ) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      DatabaseHelper.tableVocabularyProgress,
      where: 'user_id = ? AND skill_level = ? AND review_count = 0',
      whereArgs: [userId, level.name],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => VocabularyProgressEntity.fromMap(map)).toList();
  }

  /// 获取学习中的词汇（复习次数1-10）
  Future<List<VocabularyProgressEntity>> getLearningWords(
    String userId,
    LanguageLevel level,
  ) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      DatabaseHelper.tableVocabularyProgress,
      where: 'user_id = ? AND skill_level = ? AND review_count > 0 AND review_count <= 10',
      whereArgs: [userId, level.name],
      orderBy: 'review_count DESC, updated_at DESC',
    );

    return maps.map((map) => VocabularyProgressEntity.fromMap(map)).toList();
  }

  /// 获取已掌握的词汇（掌握度>=0.9）
  Future<List<VocabularyProgressEntity>> getMasteredWords(
    String userId,
    LanguageLevel level,
  ) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      DatabaseHelper.tableVocabularyProgress,
      where: 'user_id = ? AND skill_level = ? AND review_count >= 10',
      whereArgs: [userId, level.name],
      orderBy: 'review_count DESC',
    );

    return maps.map((map) => VocabularyProgressEntity.fromMap(map)).toList();
  }

  /// 更新词汇复习结果
  Future<void> updateVocabularyReview(
    String wordId,
    String userId,
    int quality, // 1-5评分
  ) async {
    final current = await getVocabularyProgress(wordId, userId);
    final now = DateTime.now();

    if (current == null) {
      // 创建新记录
      final newProgress = VocabularyProgressEntity(
        wordId: wordId,
        userId: userId,
        skillLevel: LanguageLevel.A1, // 默认A1，实际应该从词汇数据中获取
        reviewCount: 1,
        easeFactor: 2.5,
        interval: quality >= 3 ? 1 : 0,
        nextReviewDate: _calculateNextReview(1, quality),
        lastReviewedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await saveVocabularyProgress(newProgress);
    } else {
      // 更新现有记录
      int newInterval;
      double newEaseFactor;

      if (quality >= 3) {
        // 答对了
        if (current.reviewCount == 1) {
          newInterval = 6;
        } else {
          newInterval = (current.interval * current.easeFactor).round();
        }
        newEaseFactor = current.easeFactor + (0.1 - (5 - quality) * 0.08);
        if (newEaseFactor < 1.3) newEaseFactor = 1.3;
      } else {
        // 答错了
        newInterval = 0;
        newEaseFactor = current.easeFactor - 0.2;
        if (newEaseFactor < 1.3) newEaseFactor = 1.3;
      }

      final updated = VocabularyProgressEntity(
        wordId: current.wordId,
        userId: current.userId,
        skillLevel: current.skillLevel,
        reviewCount: current.reviewCount + 1,
        easeFactor: newEaseFactor,
        interval: newInterval,
        nextReviewDate: _calculateNextReview(newInterval, quality),
        lastReviewedAt: now,
        createdAt: current.createdAt,
        updatedAt: now,
      );

      await saveVocabularyProgress(updated);
    }
  }

  /// 计算下次复习时间
  DateTime? _calculateNextReview(int interval, int quality) {
    final now = DateTime.now();

    if (interval == 0) {
      // 10分钟后重试
      return now.add(const Duration(minutes: 10));
    }

    // 根据间隔天数计算下次复习时间
    return now.add(Duration(days: interval));
  }

  /// 批量添加词汇
  Future<void> batchAddVocabulary(
    List<String> wordIds,
    String userId,
    LanguageLevel level,
  ) async {
    final now = DateTime.now();

    for (final wordId in wordIds) {
      final progress = VocabularyProgressEntity(
        wordId: wordId,
        userId: userId,
        skillLevel: level,
        reviewCount: 0,
        easeFactor: 2.5,
        interval: 0,
        createdAt: now,
        updatedAt: now,
      );
      await saveVocabularyProgress(progress);
    }
  }

  /// 删除用户的所有词汇进度
  Future<void> deleteUserVocabulary(String userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableVocabularyProgress,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// 获取词汇统计
  Future<Map<String, int>> getVocabularyStatistics(String userId) async {
    final allWords = await getUserVocabularyProgress(userId);

    final newWords = allWords.where((w) => w.reviewCount == 0).length;
    final learningWords = allWords.where((w) => w.reviewCount > 0 && w.reviewCount <= 10).length;
    final masteredWords = allWords.where((w) => w.reviewCount >= 10).length;

    return {
      'total': allWords.length,
      'new': newWords,
      'learning': learningWords,
      'mastered': masteredWords,
    };
  }
}

/// 语法练习进度DAO
class GrammarProgressDAO {
  final DatabaseHelper _dbHelper;

  GrammarProgressDAO(this._dbHelper);

  /// 保存语法练习进度
  Future<void> saveGrammarProgress(Map<String, dynamic> progressData) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();

    final data = {
      'exercise_id': progressData['exercise_id'],
      'user_id': progressData['user_id'],
      'exercise_type': progressData['exercise_type'],
      'level': progressData['level'],
      'attempts': progressData['attempts'] ?? 0,
      'correct_attempts': progressData['correct_attempts'] ?? 0,
      'last_attempt_at': now.toIso8601String(),
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    await db.insert(
      DatabaseHelper.tableGrammarProgress,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取用户语法练习进度
  Future<List<Map<String, dynamic>>> getUserGrammarProgress(
    String userId,
    String? exerciseType,
  ) async {
    final db = await _dbHelper.database;

    String? where;
    List<dynamic>? whereArgs;

    if (exerciseType != null) {
      where = 'user_id = ? AND exercise_type = ?';
      whereArgs = [userId, exerciseType];
    } else {
      where = 'user_id = ?';
      whereArgs = [userId];
    }

    final maps = await db.query(
      DatabaseHelper.tableGrammarProgress,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => Map<String, dynamic>.from(map)).toList();
  }

  /// 获取语法练习统计
  Future<Map<String, dynamic>> getGrammarStatistics(
    String userId,
    String? exerciseType,
  ) async {
    final progress = await getUserGrammarProgress(userId, exerciseType);

    if (progress.isEmpty) {
      return {
        'totalAttempts': 0,
        'correctAttempts': 0,
        'averageAccuracy': 0.0,
        'totalExercises': progress.length,
      };
    }

    final totalAttempts = progress.fold<int>(
      0,
      (sum, p) => sum + (p['attempts'] as int? ?? 0),
    );

    final correctAttempts = progress.fold<int>(
      0,
      (sum, p) => sum + (p['correct_attempts'] as int? ?? 0),
    );

    return {
      'totalAttempts': totalAttempts,
      'correctAttempts': correctAttempts,
      'averageAccuracy': totalAttempts > 0
          ? correctAttempts / totalAttempts
          : 0.0,
      'totalExercises': progress.length,
    };
  }

  /// 删除用户的语法练习进度
  Future<void> deleteUserGrammarProgress(String userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableGrammarProgress,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
