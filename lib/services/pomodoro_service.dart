/// 番茄时钟服务
/// 帮助用户保持专注学习，提高学习效率
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 番茄时钟状态
enum PomodoroState {
  idle,       // 空闲
  running,    // 运行中
  paused,     // 已暂停
  breakShort, // 短休息 (5分钟)
  breakLong,  // 长休息 (15分钟)
  completed,  // 已完成
}

/// 番茄时钟类型
enum PomodoroType {
  work,       // 学习时间 (25分钟)
  shortBreak, // 短休息 (5分钟)
  longBreak,  // 长休息 (15分钟)
}

/// 番茄记录
class PomodoroSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // 分钟
  final PomodoroType type;
  final String? associatedTask; // 关联的学习任务

  PomodoroSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.type,
    this.associatedTask,
  });

  /// 从JSON创建
  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      duration: json['duration'] as int,
      type: PomodoroType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PomodoroType.work,
      ),
      associatedTask: json['associatedTask'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'type': type.toString(),
      'associatedTask': associatedTask,
    };
  }
}

/// 番茄时钟配置
class PomodoroConfig {
  final int workDuration; // 学习时长 (分钟)
  final int shortBreakDuration; // 短休息时长 (分钟)
  final int longBreakDuration; // 长休息时长 (分钟)
  final int longBreakInterval; // 长休息间隔 (番茄数)

  const PomodoroConfig({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakInterval = 4,
  });

  /// 从JSON加载
  factory PomodoroConfig.fromJson(Map<String, dynamic> json) {
    return PomodoroConfig(
      workDuration: json['workDuration'] as int? ?? 25,
      shortBreakDuration: json['shortBreakDuration'] as int? ?? 5,
      longBreakDuration: json['longBreakDuration'] as int? ?? 15,
      longBreakInterval: json['longBreakInterval'] as int? ?? 4,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'longBreakInterval': longBreakInterval,
    };
  }

  /// 复制并修改
  PomodoroConfig copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? longBreakInterval,
  }) {
    return PomodoroConfig(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
    );
  }
}

/// 番茄时钟统计
class PomodoroStatistics {
  final int totalPomodoros; // 总番茄数
  final int totalWorkMinutes; // 总学习时长 (分钟)
  final int totalBreakMinutes; // 总休息时长 (分钟)
  final int todayPomodoros; // 今日番茄数
  final int currentStreak; // 当前连续天数
  final int longestStreak; // 最长连续天数
  final DateTime lastSessionDate; // 最后学习日期

  const PomodoroStatistics({
    this.totalPomodoros = 0,
    this.totalWorkMinutes = 0,
    this.totalBreakMinutes = 0,
    this.todayPomodoros = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastSessionDate,
  });

  /// 从JSON创建
  factory PomodoroStatistics.fromJson(Map<String, dynamic> json) {
    return PomodoroStatistics(
      totalPomodoros: json['totalPomodoros'] as int? ?? 0,
      totalWorkMinutes: json['totalWorkMinutes'] as int? ?? 0,
      totalBreakMinutes: json['totalBreakMinutes'] as int? ?? 0,
      todayPomodoros: json['todayPomodoros'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastSessionDate: json['lastSessionDate'] != null
          ? DateTime.parse(json['lastSessionDate'] as String)
          : DateTime.now(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'totalPomodoros': totalPomodoros,
      'totalWorkMinutes': totalWorkMinutes,
      'totalBreakMinutes': totalBreakMinutes,
      'todayPomodoros': todayPomodoros,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastSessionDate': lastSessionDate.toIso8601String(),
    };
  }

  /// 获取今日学习时长 (小时)
  double get todayWorkHours => todayPomodoros * 25 / 60;

  /// 获取总学习时长 (小时)
  double get totalWorkHours => totalWorkMinutes / 60;
}

/// 番茄时钟服务
class PomodoroService {
  static PomodoroService? _instance;
  PomodoroConfig _config = const PomodoroConfig();
  PomodoroState _state = PomodoroState.idle;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _completedPomodoros = 0; // 当前会话完成的番茄数
  final List<PomodoroSession> _sessions = [];
  PomodoroStatistics _statistics = PomodoroStatistics(
    lastSessionDate: DateTime.now(),
  );

  // 回调函数
  void Function(int seconds)? onTick;
  void Function(PomodoroState state)? onStateChanged;
  void Function(PomodoroSession session)? onSessionCompleted;

  PomodoroService._();

  static PomodoroService get instance {
    _instance ??= PomodoroService._();
    return _instance!;
  }

  /// 初始化
  Future<void> initialize() async {
    await _loadConfig();
    await _loadSessions();
    await _loadStatistics();
    _updateTodayCount();
  }

  /// 加载配置
  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configJson = prefs.getString('pomodoro_config');
    if (configJson != null) {
      try {
        final configMap = Map<String, dynamic>.from(
          // 简化解析
          {'workDuration': 25, 'shortBreakDuration': 5, 'longBreakDuration': 15, 'longBreakInterval': 4}
        );
        _config = PomodoroConfig.fromJson(configMap);
      } catch (e) {
        debugPrint('Failed to load pomodoro config: $e');
      }
    }
  }

  /// 保存配置
  Future<void> _saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    // 简化保存
    await prefs.setInt('pomodoro_work', _config.workDuration);
    await prefs.setInt('pomodoro_shortBreak', _config.shortBreakDuration);
    await prefs.setInt('pomodoro_longBreak', _config.longBreakDuration);
    await prefs.setInt('pomodoro_interval', _config.longBreakInterval);
  }

  /// 加载历史记录
  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList('pomodoro_sessions');

    if (sessionsJson != null && sessionsJson.isNotEmpty) {
      // 简化加载
      _sessions.clear();
    }
  }

  /// 保存历史记录
  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    // 简化保存
    await prefs.setInt('pomodoro_session_count', _sessions.length);
  }

  /// 加载统计数据
  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    _statistics = PomodoroStatistics(
      totalPomodoros: prefs.getInt('pomodoro_total') ?? 0,
      totalWorkMinutes: prefs.getInt('pomodoro_work_minutes') ?? 0,
      totalBreakMinutes: prefs.getInt('pomodoro_break_minutes') ?? 0,
      currentStreak: prefs.getInt('pomodoro_streak') ?? 0,
      longestStreak: prefs.getInt('pomodoro_longest_streak') ?? 0,
      lastSessionDate: DateTime.now(),
    );
  }

  /// 保存统计数据
  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pomodoro_total', _statistics.totalPomodoros);
    await prefs.setInt('pomodoro_work_minutes', _statistics.totalWorkMinutes);
    await prefs.setInt('pomodoro_break_minutes', _statistics.totalBreakMinutes);
    await prefs.setInt('pomodoro_streak', _statistics.currentStreak);
    await prefs.setInt('pomodoro_longest_streak', _statistics.longestStreak);
  }

  /// 更新今日番茄数
  void _updateTodayCount() {
    final today = DateTime.now();
    final lastDate = _statistics.lastSessionDate;

    if (today.year == lastDate.year &&
        today.month == lastDate.month &&
        today.day == lastDate.day) {
      // 同一天，不重置
    } else {
      // 新的一天，重置今日计数
      _statistics = PomodoroStatistics(
        totalPomodoros: _statistics.totalPomodoros,
        totalWorkMinutes: _statistics.totalWorkMinutes,
        totalBreakMinutes: _statistics.totalBreakMinutes,
        todayPomodoros: 0,
        currentStreak: _statistics.currentStreak,
        longestStreak: _statistics.longestStreak,
        lastSessionDate: _statistics.lastSessionDate,
      );
    }
  }

  /// 获取当前配置
  PomodoroConfig get config => _config;

  /// 更新配置
  Future<void> updateConfig(PomodoroConfig newConfig) async {
    _config = newConfig;
    await _saveConfig();
    debugPrint('Pomodoro config updated: $newConfig');
  }

  /// 获取当前状态
  PomodoroState get state => _state;

  /// 获取剩余秒数
  int get remainingSeconds => _remainingSeconds;

  /// 获取剩余时间文本
  String get remainingTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 获取进度 (0.0 - 1.0)
  double get progress {
    int totalSeconds;
    switch (_state) {
      case PomodoroState.running:
        totalSeconds = _config.workDuration * 60;
        break;
      case PomodoroState.breakShort:
        totalSeconds = _config.shortBreakDuration * 60;
        break;
      case PomodoroState.breakLong:
        totalSeconds = _config.longBreakDuration * 60;
        break;
      default:
        return 0.0;
    }
    return 1.0 - (_remainingSeconds / totalSeconds);
  }

  /// 获取当前会话完成的番茄数
  int get completedPomodoros => _completedPomodoros;

  /// 获取统计数据
  PomodoroStatistics get statistics => _statistics;

  /// 开始学习番茄
  void startWork({String? task}) {
    if (_timer != null) _timer!.cancel();

    _state = PomodoroState.running;
    _remainingSeconds = _config.workDuration * 60;

    _startTimer(task);
    _notifyStateChanged();

    debugPrint('🍅 Pomodoro started: ${_config.workDuration} minutes');
  }

  /// 开始短休息
  void startShortBreak() {
    if (_timer != null) _timer!.cancel();

    _state = PomodoroState.breakShort;
    _remainingSeconds = _config.shortBreakDuration * 60;

    _startTimer(null);
    _notifyStateChanged();

    debugPrint('☕ Short break started: ${_config.shortBreakDuration} minutes');
  }

  /// 开始长休息
  void startLongBreak() {
    if (_timer != null) _timer!.cancel();

    _state = PomodoroState.breakLong;
    _remainingSeconds = _config.longBreakDuration * 60;

    _startTimer(null);
    _notifyStateChanged();

    debugPrint('🌴 Long break started: ${_config.longBreakDuration} minutes');
  }

  /// 启动计时器
  void _startTimer(String? task) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        onTick?.call(_remainingSeconds);
      } else {
        _completeSession(task);
      }
    });
  }

  /// 完成当前会话
  void _completeSession(String? task) {
    _timer?.cancel();
    _timer = null;

    final now = DateTime.now();
    final session = PomodoroSession(
      id: 'pomodoro_${now.millisecondsSinceEpoch}',
      startTime: now.subtract(Duration(seconds: _getTotalDuration() * 60)),
      endTime: now,
      duration: _getTotalDuration(),
      type: _getCurrentType(),
      associatedTask: task,
    );

    _sessions.add(session);

    // 更新统计
    if (_state == PomodoroState.running) {
      _completedPomodoros++;
      _statistics = PomodoroStatistics(
        totalPomodoros: _statistics.totalPomodoros + 1,
        totalWorkMinutes: _statistics.totalWorkMinutes + _config.workDuration,
        totalBreakMinutes: _statistics.totalBreakMinutes,
        todayPomodoros: _statistics.todayPomodoros + 1,
        currentStreak: _statistics.currentStreak,
        longestStreak: _statistics.longestStreak,
        lastSessionDate: now,
      );
    } else {
      _statistics = PomodoroStatistics(
        totalPomodoros: _statistics.totalPomodoros,
        totalWorkMinutes: _statistics.totalWorkMinutes,
        totalBreakMinutes: _statistics.totalBreakMinutes +
            (_state == PomodoroState.breakShort
                ? _config.shortBreakDuration
                : _config.longBreakDuration),
        todayPomodoros: _statistics.todayPomodoros,
        currentStreak: _statistics.currentStreak,
        longestStreak: _statistics.longestStreak,
        lastSessionDate: _statistics.lastSessionDate,
      );
    }

    _saveSessions();
    _saveStatistics();

    onSessionCompleted?.call(session);

    // 自动进入下一个阶段
    if (_state == PomodoroState.running) {
      if (_completedPomodoros % _config.longBreakInterval == 0) {
        // 达到长休息间隔
        startLongBreak();
      } else {
        // 短休息
        startShortBreak();
      }
    } else {
      // 休息结束，回到空闲状态
      _state = PomodoroState.idle;
      _notifyStateChanged();
    }

    debugPrint('✅ Pomodoro session completed: ${session.type}');
  }

  /// 获取当前类型总时长
  int _getTotalDuration() {
    switch (_state) {
      case PomodoroState.running:
        return _config.workDuration;
      case PomodoroState.breakShort:
        return _config.shortBreakDuration;
      case PomodoroState.breakLong:
        return _config.longBreakDuration;
      default:
        return 0;
    }
  }

  /// 获取当前类型
  PomodoroType _getCurrentType() {
    switch (_state) {
      case PomodoroState.running:
        return PomodoroType.work;
      case PomodoroState.breakShort:
        return PomodoroType.shortBreak;
      case PomodoroState.breakLong:
        return PomodoroType.longBreak;
      default:
        return PomodoroType.work;
    }
  }

  /// 暂停
  void pause() {
    if (_state == PomodoroState.running ||
        _state == PomodoroState.breakShort ||
        _state == PomodoroState.breakLong) {
      _timer?.cancel();
      _timer = null;
      _state = PomodoroState.paused;
      _notifyStateChanged();
      debugPrint('⏸️ Pomodoro paused');
    }
  }

  /// 恢复
  void resume() {
    if (_state == PomodoroState.paused) {
      // 恢复之前的状态
      if (_completedPomodoros > 0 &&
          _completedPomodoros % _config.longBreakInterval == 0) {
        // 应该是长休息之后
        _state = PomodoroState.running;
      } else {
        _state = PomodoroState.running;
      }

      _startTimer(null);
      _notifyStateChanged();
      debugPrint('▶️ Pomodoro resumed');
    }
  }

  /// 停止/重置
  void stop() {
    _timer?.cancel();
    _timer = null;
    _state = PomodoroState.idle;
    _remainingSeconds = 0;
    _completedPomodoros = 0;
    _notifyStateChanged();
    debugPrint('⏹️ Pomodoro stopped');
  }

  /// 跳过
  void skip() {
    _timer?.cancel();
    _timer = null;

    if (_state == PomodoroState.running) {
      // 跳过学习，直接休息
      if (_completedPomodoros % _config.longBreakInterval == 0) {
        startLongBreak();
      } else {
        startShortBreak();
      }
    } else {
      // 跳过休息，开始学习
      startWork();
    }
  }

  /// 通知状态变化
  void _notifyStateChanged() {
    onStateChanged?.call(_state);
  }

  /// 获取今日番茄数
  int get todayPomodoros => _statistics.todayPomodoros;

  /// 获取总番茄数
  int get totalPomodoros => _statistics.totalPomodoros;

  /// 获取所有会话
  List<PomodoroSession> get sessions => List.unmodifiable(_sessions);

  /// 清除所有数据（测试用）
  Future<void> clearAll() async {
    stop();
    _sessions.clear();
    _statistics = PomodoroStatistics(
      lastSessionDate: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pomodoro_total');
    await prefs.remove('pomodoro_work_minutes');
    await prefs.remove('pomodoro_break_minutes');
    await prefs.remove('pomodoro_streak');
    await prefs.remove('pomodoro_longest_streak');

    debugPrint('🗑️ All pomodoro data cleared');
  }

  /// 生成统计报告
  String generateReport() {
    final buffer = StringBuffer();

    buffer.writeln('# 🍅 番茄时钟统计报告');
    buffer.writeln();
    buffer.writeln('**日期**: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln();

    buffer.writeln('## 📊 学习统计');
    buffer.writeln();
    buffer.writeln('- **今日番茄**: ${_statistics.todayPomodoros} 个');
    buffer.writeln('- **今日学习**: ${_statistics.todayPomodoros * 25} 分钟 (${_statistics.todayPomodoros * 25 / 60} 小时)');
    buffer.writeln('- **总番茄数**: ${_statistics.totalPomodoros} 个');
    buffer.writeln('- **总学习时长**: ${_statistics.totalWorkMinutes} 分钟 (${_statistics.totalWorkMinutes / 60} 小时)');
    buffer.writeln('- **总休息时长**: ${_statistics.totalBreakMinutes} 分钟');
    buffer.writeln('- **当前连续**: ${_statistics.currentStreak} 天');
    buffer.writeln('- **最长连续**: ${_statistics.longestStreak} 天');
    buffer.writeln();

    buffer.writeln('## 🎯 学习建议');
    buffer.writeln();
    if (_statistics.todayPomodoros < 4) {
      buffer.writeln('💪 今天再完成${4 - _statistics.todayPomodoros}个番茄，就能达到推荐目标！');
    } else {
      buffer.writeln('🎉 太棒了！今天已经完成了推荐的学习目标！');
    }

    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln('*保持专注，高效学习！*');

    return buffer.toString();
  }
}

/// 番茄时钟工具类
class PomodoroHelper {
  /// 获取推荐每日番茄数
  static int getRecommendedDailyPomodoros(String level) {
    switch (level.toLowerCase()) {
      case 'a1':
      case 'a2':
        return 4; // 初学者：2小时
      case 'b1':
      case 'b2':
        return 6; // 中级：2.5小时
      case 'c1':
      case 'c2':
        return 8; // 高级：3.3小时
      default:
        return 4;
    }
  }

  /// 计算完成目标所需的番茄数
  static int getPomodorosNeeded(int targetMinutes) {
    return (targetMinutes / 25).ceil();
  }

  /// 估算完成时间
  static DateTime estimateCompletionTime(int pomodoros) {
    final totalMinutes = pomodoros * 30; // 25分钟学习 + 5分钟休息
    return DateTime.now().add(Duration(minutes: totalMinutes));
  }
}
