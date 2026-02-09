/// 用户进度数据访问对象
///
/// 管理用户学习进度的数据库操作
library;

import '../models/word.dart';
import '../core/learning_path/skill_tree.dart';
import '../core/grammar_engine.dart';
import 'database_helper.dart';

/// 用户进度实体
class UserProgressEntity {
  final String userId;
  final LanguageLevel currentLevel;
  final int totalStudyDays;
  final int currentStreak;
  final DateTime? lastStudyDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProgressEntity({
    required this.userId,
    required this.currentLevel,
    this.totalStudyDays = 0,
    this.currentStreak = 0,
    this.lastStudyDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// 从数据库Map创建
  factory UserProgressEntity.fromMap(Map<String, dynamic> map) {
    return UserProgressEntity(
      userId: map['id'] as String,
      currentLevel: LanguageLevel.values.firstWhere(
        (e) => e.name == map['current_level'],
        orElse: () => LanguageLevel.A1,
      ),
      totalStudyDays: map['total_study_days'] as int? ?? 0,
      currentStreak: map['current_streak'] as int? ?? 0,
      lastStudyDate: map['last_study_date'] != null
          ? DateTime.parse(map['last_study_date'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为数据库Map
  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'current_level': currentLevel.name,
      'total_study_days': totalStudyDays,
      'current_streak': currentStreak,
      'last_study_date': lastStudyDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// 技能进度实体
class SkillProgressEntity {
  final String skillId;
  final String userId;
  final double masteryLevel;
  final int practiceCount;
  final double averageAccuracy;
  final bool isMastered;
  final DateTime? lastPracticedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SkillProgressEntity({
    required this.skillId,
    required this.userId,
    required this.masteryLevel,
    this.practiceCount = 0,
    this.averageAccuracy = 0.0,
    this.isMastered = false,
    this.lastPracticedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SkillProgressEntity.fromMap(Map<String, dynamic> map) {
    return SkillProgressEntity(
      skillId: map['skill_id'] as String,
      userId: map['user_id'] as String,
      masteryLevel: (map['mastery_level'] as num).toDouble(),
      practiceCount: map['practice_count'] as int? ?? 0,
      averageAccuracy: (map['average_accuracy'] as num?)?.toDouble() ?? 0.0,
      isMastered: (map['is_mastered'] as int) == 1,
      lastPracticedAt: map['last_practiced_at'] != null
          ? DateTime.parse(map['last_practiced_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'skill_id': skillId,
      'user_id': userId,
      'mastery_level': masteryLevel,
      'practice_count': practiceCount,
      'average_accuracy': averageAccuracy,
      'is_mastered': isMastered ? 1 : 0,
      'last_practiced_at': lastPracticedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// 学习会话实体
class StudySessionEntity {
  final String id;
  final String userId;
  final DateTime sessionDate;
  final int durationMinutes;
  final List<String> skillsPracticed;
  final int totalExercises;
  final int correctExercises;
  final DateTime createdAt;

  StudySessionEntity({
    required this.id,
    required this.userId,
    required this.sessionDate,
    required this.durationMinutes,
    required this.skillsPracticed,
    this.totalExercises = 0,
    this.correctExercises = 0,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now();

  factory StudySessionEntity.fromMap(Map<String, dynamic> map) {
    return StudySessionEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      sessionDate: DateTime.parse(map['session_date'] as String),
      durationMinutes: map['duration_minutes'] as int,
      skillsPracticed: List<String>.from(
        map['skills_practiced'] as String? ?? '',
      ),
      totalExercises: map['total_exercises'] as int? ?? 0,
      correctExercises: map['correct_exercises'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'session_date': sessionDate.toIso8601String(),
      'duration_minutes': durationMinutes,
      'skills_practiced': skillsPracticed.join(','),
      'total_exercises': totalExercises,
      'correct_exercises': correctExercises,
      'created_at': createdAt.toIso8601String(),
    };
  }

/// 词汇进度实体
class VocabularyProgressEntity {
  final String wordId;
  final String userId;
  final LanguageLevel skillLevel;
  final int reviewCount;
  final double easeFactor;
  final int interval;
  final DateTime? nextReviewDate;
  final DateTime? lastReviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  VocabularyProgressEntity({
    required this.wordId,
    required this.userId,
    required this.skillLevel,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
    this.interval = 0,
    this.nextReviewDate,
    this.lastReviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory VocabularyProgressEntity.fromMap(Map<String, dynamic> map) {
    return VocabularyProgressEntity(
      wordId: map['word_id'] as String,
      userId: map['user_id'] as String,
      skillLevel: LanguageLevel.values.firstWhere(
        (e) => e.name == map['skill_level'],
        orElse: () => LanguageLevel.A1,
      ),
      reviewCount: map['review_count'] as int? ?? 0,
      easeFactor: (map['ease_factor'] as num?)?.toDouble() ?? 2.5,
      interval: map['interval'] as int? ?? 0,
      nextReviewDate: map['next_review_date'] != null
          ? DateTime.parse(map['next_review_date'] as String)
          : null,
      lastReviewedAt: map['last_reviewed_at'] != null
          ? DateTime.parse(map['last_reviewed_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word_id': wordId,
      'user_id': userId,
      'skill_level': skillLevel.name,
      'review_count': reviewCount,
      'ease_factor': easeFactor,
      'interval': interval,
      'next_review_date': nextReviewDate?.toIso8601String(),
      'last_reviewed_at': lastReviewedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// 用户进度DAO
class UserProgressDAO {
  final DatabaseHelper _dbHelper;

  UserProgressDAO(this._dbHelper);

  /// 保存或更新用户进度
  Future<void> saveUserProgress(UserProgressEntity progress) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableUserProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取用户进度
  Future<UserProgressEntity?> getUserProgress(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableUserProgress,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return UserProgressEntity.fromMap(maps.first);
    }
    return null;
  }

  /// 创建新用户
  Future<void> createUser(String userId, LanguageLevel initialLevel) async {
    final now = DateTime.now();
    final progress = UserProgressEntity(
      userId: userId,
      currentLevel: initialLevel,
      createdAt: now,
      updatedAt: now,
    );
    await saveUserProgress(progress);
  }

  /// 更新学习日期和连续天数
  Future<void> updateStudyDate(String userId) async {
    final progress = await getUserProgress(userId);
    if (progress == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = progress.currentStreak;
    int newTotalDays = progress.totalStudyDays;

    if (progress.lastStudyDate != null) {
      final lastDate = DateTime(
        progress.lastStudyDate!.year,
        progress.lastStudyDate!.month,
        progress.lastStudyDate!.day,
      );
      final daysDiff = today.difference(lastDate).inDays;

      if (daysDiff == 1) {
        newStreak++;
        newTotalDays++;
      } else if (daysDiff > 1) {
        newStreak = 1;
        newTotalDays++;
      }
    } else {
      newStreak = 1;
      newTotalDays = 1;
    }

    final updated = UserProgressEntity(
      userId: progress.userId,
      currentLevel: progress.currentLevel,
      totalStudyDays: newTotalDays,
      currentStreak: newStreak,
      lastStudyDate: today,
      createdAt: progress.createdAt,
      updatedAt: now,
    );

    await saveUserProgress(updated);
  }

  /// 升级用户级别
  Future<bool> upgradeLevel(String userId) async {
    final progress = await getUserProgress(userId);
    if (progress == null) return false;

    final currentIndex = progress.currentLevel.index;
    if (currentIndex < LanguageLevel.values.length - 1) {
      final newLevel = LanguageLevel.values[currentIndex + 1];
      final updated = UserProgressEntity(
        userId: progress.userId,
        currentLevel: newLevel,
        totalStudyDays: progress.totalStudyDays,
        currentStreak: progress.currentStreak,
        lastStudyDate: progress.lastStudyDate,
        createdAt: progress.createdAt,
        updatedAt: DateTime.now(),
      );

      await saveUserProgress(updated);
      return true;
    }
    return false;
  }

  /// 删除用户
  Future<void> deleteUser(String userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableUserProgress,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
