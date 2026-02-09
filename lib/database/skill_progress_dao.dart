/// 技能进度数据访问对象
///
/// 管理技能学习进度的数据库操作
library;

import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'user_progress_dao.dart';

/// 技能进度DAO
class SkillProgressDAO {
  final DatabaseHelper _dbHelper;

  SkillProgressDAO(this._dbHelper);

  /// 保存或更新技能进度
  Future<void> saveSkillProgress(SkillProgressEntity progress) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableSkillProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取用户的所有技能进度
  Future<List<SkillProgressEntity>> getUserSkillProgress(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSkillProgress,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => SkillProgressEntity.fromMap(map)).toList();
  }

  /// 获取特定技能进度
  Future<SkillProgressEntity?> getSkillProgress(
    String skillId,
    String userId,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSkillProgress,
      where: 'skill_id = ? AND user_id = ?',
      whereArgs: [skillId, userId],
    );

    if (maps.isNotEmpty) {
      return SkillProgressEntity.fromMap(maps.first);
    }
    return null;
  }

  /// 获取需要复习的技能（掌握度在0.6-0.8之间）
  Future<List<SkillProgressEntity>> getSkillsForReview(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSkillProgress,
      where: 'user_id = ? AND mastery_level >= ? AND mastery_level < ?',
      whereArgs: [userId, 0.6, 0.8],
      orderBy: 'mastery_level ASC',
    );

    return maps.map((map) => SkillProgressEntity.fromMap(map)).toList();
  }

  /// 获取已掌握的技能
  Future<List<SkillProgressEntity>> getMasteredSkills(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSkillProgress,
      where: 'user_id = ? AND is_mastered = 1',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => SkillProgressEntity.fromMap(map)).toList();
  }

  /// 更新技能进度
  Future<void> updateSkillProgress(
    String skillId,
    String userId,
    double newAccuracy,
  ) async {
    final current = await getSkillProgress(skillId, userId);
    if (current == null) {
      // 创建新记录
      final now = DateTime.now();
      final newProgress = SkillProgressEntity(
        skillId: skillId,
        userId: userId,
        masteryLevel: newAccuracy,
        practiceCount: 1,
        averageAccuracy: newAccuracy,
        isMastered: newAccuracy >= 0.8,
        lastPracticedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await saveSkillProgress(newProgress);
    } else {
      // 更新现有记录
      final newPracticeCount = current.practiceCount + 1;
      final newAverageAccuracy = (current.averageAccuracy * 0.7) + (newAccuracy * 0.3);

      final newMastery = (newAverageAccuracy * 0.6) +
                          (newPracticeCount / 10 * 0.4);
      final finalMastery = newMastery.clamp(0.0, 1.0);

      final updated = SkillProgressEntity(
        skillId: current.skillId,
        userId: current.userId,
        masteryLevel: finalMastery,
        practiceCount: newPracticeCount,
        averageAccuracy: newAverageAccuracy,
        isMastered: finalMastery >= 0.8,
        lastPracticedAt: DateTime.now(),
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
      );

      await saveSkillProgress(updated);
    }
  }

  /// 批量更新技能进度
  Future<void> batchUpdateSkillProgress(
    Map<String, double> progressMap,
    String userId,
  ) async {
    for (final entry in progressMap.entries) {
      await updateSkillProgress(entry.key, userId, entry.value);
    }
  }

  /// 删除用户的所有技能进度
  Future<void> deleteUserSkills(String userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableSkillProgress,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}

/// 学习会话DAO
class StudySessionDAO {
  final DatabaseHelper _dbHelper;

  StudySessionDAO(this._dbHelper);

  /// 保存学习会话
  Future<void> saveStudySession(StudySessionEntity session) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableStudySession,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取用户的学习会话
  Future<List<StudySessionEntity>> getUserStudySessions(
    String userId, {
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String? where;
    List<dynamic>? whereArgs;

    if (startDate != null && endDate != null) {
      where = 'user_id = ? AND session_date BETWEEN ? AND ?';
      whereArgs = [userId, startDate.toIso8601String(), endDate.toIso8601String()];
    } else if (startDate != null) {
      where = 'user_id = ? AND session_date >= ?';
      whereArgs = [userId, startDate.toIso8601String()];
    } else {
      where = 'user_id = ?';
      whereArgs = [userId];
    }

    final maps = await db.query(
      DatabaseHelper.tableStudySession,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'session_date DESC',
      limit: limit,
    );

    return maps.map((map) => StudySessionEntity.fromMap(map)).toList();
  }

  /// 获取今日学习会话
  Future<List<StudySessionEntity>> getTodaySessions(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final tomorrow = today.add(const Duration(days: 1));

    return getUserStudySessions(
      userId,
      startDate: today,
      endDate: tomorrow,
    );
  }

  /// 获取学习统计
  Future<Map<String, dynamic>> getStudyStatistics(String userId) async {
    final sessions = await getUserStudySessions(userId, limit: 1000);

    if (sessions.isEmpty) {
      return {
        'totalSessions': 0,
        'totalMinutes': 0,
        'averageAccuracy': 0.0,
        'longestStreak': 0,
        'totalDays': 0,
      };
    }

    final totalMinutes = sessions.fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );

    final totalExercises = sessions.fold<int>(
      0,
      (sum, session) => sum + session.totalExercises,
    );

    final correctExercises = sessions.fold<int>(
      0,
      (sum, session) => sum + session.correctExercises,
    );

    final averageAccuracy = totalExercises > 0
        ? correctExercises / totalExercises
        : 0.0;

    // 计算学习天数
    final uniqueDays = <DateTime>{};
    for (final session in sessions) {
      final date = DateTime(
        session.sessionDate.year,
        session.sessionDate.month,
        session.sessionDate.day,
      );
      uniqueDays.add(date);
    }

    // 计算最长连续学习天数
    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    final sortedDates = uniqueDays.toList()..sort();
    for (final date in sortedDates) {
      if (lastDate == null) {
        currentStreak = 1;
      } else {
        final diff = date.difference(lastDate!).inDays;
        if (diff == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }
      lastDate = date;
      longestStreak = longestStreak > longestStreak ? longestStreak : currentStreak;
    }

    return {
      'totalSessions': sessions.length,
      'totalMinutes': totalMinutes,
      'totalExercises': totalExercises,
      'averageAccuracy': averageAccuracy,
      'longestStreak': longestStreak,
      'totalDays': uniqueDays.length,
    };
  }

  /// 删除用户的所有会话
  Future<void> deleteUserSessions(String userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableStudySession,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
