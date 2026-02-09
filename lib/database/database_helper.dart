/// 数据库辅助类
///
/// 管理SQLite数据库的创建、升级和基本操作
library;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// 数据库管理类
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // 数据库名称和版本
  static const String _databaseName = 'aeryn_deutsch.db';
  static const int _databaseVersion = 1;

  // 表名
  static const String tableUserProgress = 'user_progress';
  static const String tableSkillProgress = 'skill_progress';
  static const String tableStudySession = 'study_session';
  static const String tableVocabularyProgress = 'vocabulary_progress';
  static const String tableGrammarProgress = 'grammar_progress';

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建表
  Future<void> _onCreate(Database db, int version) async {
    // 用户进度表
    await db.execute('''
      CREATE TABLE $tableUserProgress (
        id TEXT PRIMARY KEY,
        current_level TEXT NOT NULL,
        total_study_days INTEGER DEFAULT 0,
        current_streak INTEGER DEFAULT 0,
        last_study_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 技能进度表
    await db.execute('''
      CREATE TABLE $tableSkillProgress (
        skill_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        mastery_level REAL DEFAULT 0.0,
        practice_count INTEGER DEFAULT 0,
        average_accuracy REAL DEFAULT 0.0,
        is_mastered INTEGER DEFAULT 0,
        last_practiced_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES $tableUserProgress (id) ON DELETE CASCADE
      )
    ''');

    // 学习会话表
    await db.execute('''
      CREATE TABLE $tableStudySession (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        session_date TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        skills_practiced TEXT NOT NULL,
        total_exercises INTEGER DEFAULT 0,
        correct_exercises INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES $tableUserProgress (id) ON DELETE CASCADE
      )
    ''');

    // 词汇进度表
    await db.execute('''
      CREATE TABLE $tableVocabularyProgress (
        word_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        skill_level TEXT NOT NULL,
        review_count INTEGER DEFAULT 0,
        ease_factor REAL DEFAULT 2.5,
        interval INTEGER DEFAULT 0,
        next_review_date TEXT,
        last_reviewed_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES $tableUserProgress (id) ON DELETE CASCADE
      )
    ''');

    // 语法练习进度表
    await db.execute('''
      CREATE TABLE $tableGrammarProgress (
        exercise_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        exercise_type TEXT NOT NULL,
        level TEXT NOT NULL,
        attempts INTEGER DEFAULT 0,
        correct_attempts INTEGER DEFAULT 0,
        last_attempt_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES $tableUserProgress (id) ON DELETE CASCADE
      )
    ''');

    // 创建索引以提高查询性能
    await _createIndexes(db);
  }

  /// 创建索引
  Future<void> _createIndexes(Database db) async {
    // 用户进度索引
    await db.execute('''
      CREATE INDEX idx_user_progress_level ON $tableUserProgress(current_level)
    ''');

    // 技能进度索引
    await db.execute('''
      CREATE INDEX idx_skill_user ON $tableSkillProgress(user_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_skill_mastery ON $tableSkillProgress(mastery_level)
    ''');

    // 学习会话索引
    await db.execute('''
      CREATE INDEX idx_session_user_date ON $tableStudySession(user_id, session_date)
    ''');

    // 词汇进度索引
    await db.execute('''
      CREATE INDEX idx_vocab_user ON $tableVocabularyProgress(user_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_vocab_next_review ON $tableVocabularyProgress(next_review_date)
    ''');

    // 语法练习索引
    await db.execute('''
      CREATE INDEX idx_grammar_user ON $tableGrammarProgress(user_id)
    ''');
  }

  /// 数据库升级
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 未来版本升级逻辑
      // 例如：添加新表、修改表结构等
    }
  }

  /// 关闭数据库
  Future<void> close() async {
    final db = await database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// 清空所有数据（用于测试或重置）
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(tableUserProgress);
    await db.delete(tableSkillProgress);
    await db.delete(tableStudySession);
    await db.delete(tableVocabularyProgress);
    await db.delete(tableGrammarProgress);
  }

  /// 获取数据库文件大小
  Future<int> getDatabaseSize() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    final file = File(path);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  /// 导出数据库（用于备份）
  Future<String> exportDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return path;
  }
}
