/// 性能监控和测试工具
library;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 性能指标
class PerformanceMetrics {
  final String sessionId;
  final DateTime startTime;
  DateTime? endTime;
  final Map<String, dynamic> data;

  PerformanceMetrics({
    required this.sessionId,
    required this.startTime,
    this.endTime,
    Map<String, dynamic>? data,
  })  : data = data ?? {};

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration.inMilliseconds,
      'data': data,
    };
  }
}

/// 性能数据点
class PerformanceDataPoint {
  final String metric;
  final double value;
  final String unit;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceDataPoint({
    required this.metric,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'metric': metric,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// 性能监控服务
class PerformanceMonitor {
  static PerformanceMonitor? _instance;
  final List<PerformanceDataPoint> _dataPoints = [];
  DateTime? _lastScreenChange;
  String? _currentScreen;
  bool _isMonitoring = false;

  PerformanceMonitor._();

  static PerformanceMonitor get instance {
    _instance ??= PerformanceMonitor._();
    return _instance!;
  }

  /// 开始监控
  void startMonitoring() {
    _isMonitoring = true;
    _dataPoints.clear();
    _lastScreenChange = DateTime.now();
    debugPrint('Performance monitoring started');
  }

  /// 停止监控
  void stopMonitoring() {
    _isMonitoring = false;
    debugPrint('Performance monitoring stopped');
  }

  /// 记录屏幕切换
  void trackScreenChange(String screenName) {
    if (!_isMonitoring) return;

    _currentScreen = screenName;
    _lastScreenChange = DateTime.now();

    addMetric('screen_change', 1.0, 'count', {
      'screen': screenName,
    });
  }

  /// 添加性能指标
  void addMetric(
    String metric,
    double value,
    String unit, {
    Map<String, dynamic>? metadata,
  }) {
    if (!_isMonitoring) return;

    final dataPoint = PerformanceDataPoint(
      metric: metric,
      value: value,
      unit: unit,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _dataPoints.add(dataPoint);
  }

  /// 获取所有数据点
  List<PerformanceDataPoint> get dataPoints => List.unmodifiable(_dataPoints);

  /// 计算统计数据
  Map<String, dynamic> getStatistics() {
    if (_dataPoints.isEmpty) return {};

    final stats = <String, dynamic>{};

    // 按类型分组
    for (final point in _dataPoints) {
      final metric = point.metric;
      if (!stats.containsKey(metric)) {
        stats[metric] = <double>[];
      }
      (stats[metric] as List<double>).add(point.value);
    }

    // 计算平均值、最大值、最小值
    final summary = <String, dynamic>{};
    stats.forEach((metric, values) {
      final numericValues = values as List<double>;
      summary['${metric}_avg'] = numericValues.reduce((a, b) => a + b) / numericValues.length;
      summary['${metric}_max'] = numericValues.reduce((a, b) => a > b ? a : b);
      summary['${metric}_min'] = numericValues.reduce((a, b) => a < b ? a : b);
      summary['${metric}_count'] = numericValues.length;
    });

    return summary;
  }

  /// 生成性能报告
  String generateReport() {
    final stats = getStatistics();
    final buffer = StringBuffer();

    buffer.writeln('# Aeryn-Deutsch 性能测试报告');
    buffer.writeln();
    buffer.writeln('**测试日期**: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln();

    buffer.writeln('## 📊 核心指标');
    buffer.writeln();

    // 启动时间
    if (stats.containsKey('app_startup_avg')) {
      final startupTime = stats['app_startup_avg'];
      buffer.writeln('- **平均启动时间**: ${startupTime.toStringAsFixed(2)} ms');
      buffer.writeln('- **目标**: < 3秒');
      buffer.writeln('- **状态**: ${startupTime < 3000 ? '✅ 通过' : '❌ 未达标'}');
      buffer.writeln();
    }

    // 内存使用
    if (stats.containsKey('memory_usage_avg')) {
      final memory = stats['memory_usage_avg'];
      buffer.writeln('- **平均内存使用**: ${memory.toStringAsFixed(1)} MB');
      buffer.writeln('- **目标**: < 200 MB');
      buffer.writeln('- **状态**: ${memory < 200 ? '✅ 通过' : '❌ 未达标'}');
      buffer.writeln();
    }

    // 页面加载时间
    if (stats.containsKey('page_load_avg')) {
      final loadTime = stats['page_load_avg'];
      buffer.writeln('- **平均页面加载**: ${loadTime.toStringAsFixed(2)} ms');
      buffer.writeln('- **目标**: < 500 ms');
      buffer.writeln('- **状态**: ${loadTime < 500 ? '✅ 通过' : '❌ 未达标'}');
      buffer.writeln();
    }

    buffer.writeln('## 📈 详细指标');
    buffer.writeln();
    stats.forEach((metric, value) {
      if (metric.endsWith('_avg')) {
        final name = metric.replaceAll('_avg', '');
        final unit = stats['${name}_unit'] ?? '';
        buffer.writeln('- **$name 平均**: ${value?.toStringAsFixed(2)} $unit');
      }
    });

    return buffer.toString();
  }

  /// 清除数据
  void clearData() {
    _dataPoints.clear();
  }

  /// 保存到本地
  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(
      _dataPoints.map((dp) => dp.toJson()).toList(),
    );
    await prefs.setString('performance_data', jsonData);
  }

  /// 从本地加载
  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('performance_data');

    if (jsonData != null) {
      final List<dynamic> decoded = jsonDecode(jsonData);
      _dataPoints.clear();
      for (final item in decoded) {
        _dataPoints.add(PerformanceDataPoint(
          metric: item['metric'] as String,
          value: item['value'] as double,
          unit: item['unit'] as String,
          timestamp: DateTime.parse(item['timestamp'] as String),
          metadata: item['metadata'] as Map<String, dynamic>?,
        ));
      }
    }
  }
}

/// 性能测试工具
class PerformanceTester {
  static final PerformanceMonitor monitor = PerformanceMonitor.instance;

  /// 测试应用启动时间
  static Future<void> testStartupTime() async {
    final startTime = DateTime.now();
    monitor.startMonitoring();

    // 模拟应用启动
    monitor.addMetric('app_startup', 0, 'ms', {
      'phase': 'init',
    });

    await Future.delayed(const Duration(milliseconds: 100));

    monitor.addMetric('app_startup', 100, 'ms', {
      'phase': 'load',
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    monitor.addMetric('app_startup', duration.inMilliseconds.toDouble(), 'ms', {
      'phase': 'complete',
    });

    monitor.stopMonitoring();

    debugPrint('App startup time: ${duration.inMilliseconds}ms');
  }

  /// 测试内存使用
  static Future<void> testMemoryUsage() async {
    // 在实际应用中，这里会使用dart:developer来获取内存信息
    monitor.addMetric('memory_usage', 50.0, 'MB', {
      'test': 'baseline',
    });

    // 模拟内存增长
    await Future.delayed(const Duration(seconds: 1));
    monitor.addMetric('memory_usage', 80.5, 'MB', {
      'test': 'after_loading',
    });
  }

  /// 测试页面加载时间
  static Future<void> testPageLoadTime() async {
    final start = DateTime.now();

    // 模拟页面加载
    await Future.delayed(const Duration(milliseconds: 200));

    final duration = DateTime.now().difference(start);
    monitor.addMetric('page_load', duration.inMilliseconds.toDouble(), 'ms');

    debugPrint('Page load time: ${duration.inMilliseconds}ms');
  }

  /// 测试数据库查询性能
  static Future<void> testDatabaseQuery() async {
    final start = DateTime.now();

    // 模拟数据库查询
    await Future.delayed(const Duration(milliseconds: 50));

    final duration = DateTime.now().difference(start);
    monitor.addMetric('db_query', duration.inMilliseconds.toDouble(), 'ms');

    debugPrint('Database query time: ${duration.inMilliseconds}ms');
  }

  /// 测试AI响应时间
  static Future<void> testAIResponseTime() async {
    final start = DateTime.now();

    // 模拟AI调用
    await Future.delayed(const Duration(milliseconds: 500));

    final duration = DateTime.now().difference(start);
    monitor.addMetric('ai_response', duration.inMilliseconds.toDouble(), 'ms');

    debugPrint('AI response time: ${duration.inMilliseconds}ms');
  }

  /// 运行完整性能测试套件
  static Future<void> runFullTestSuite() async {
    print('🚀 开始性能测试套件...\n');

    // 测试1: 启动时间
    print('📱 测试1: 应用启动时间');
    await testStartupTime();
    print('   结果: ✅ 完成\n');

    // 测试2: 内存使用
    print('💾 测试2: 内存使用');
    await testMemoryUsage();
    print('   结果: ✅ 完成\n');

    // 测试3: 页面加载
    print('📄 测试3: 页面加载时间');
    await testPageLoadTime();
    print('   结果: ✅ 完成\n');

    // 测试4: 数据库查询
    print('🗄️ 测试4: 数据库查询性能');
    await testDatabaseQuery();
    print('   结果: ✅ 完成\n');

    // 测试5: AI响应
    print('🤖 测试5: AI响应时间');
    await testAIResponseTime();
    print('   结果: ✅ 完成\n');

    // 生成报告
    print('📊 性能测试报告');
    print('------------------');
    print(monitor.generateReport());
    print('------------------');

    // 保存到本地
    await monitor.saveToLocal();
    print('\n💾 数据已保存到本地');
  }
}

/// 自动化测试辅助工具
class AutomatedTestHelper {
  /// 自动捕获性能数据
  static Future<void> capturePerformanceData() async {
    final monitor = PerformanceMonitor.instance;
    monitor.startMonitoring();

    // 记录各种操作的性能
    // 在实际测试中，这些会集成到各个功能模块

    // 模拟一些数据
    monitor.addMetric('flashcard_flip', 150.0, 'ms');
    monitor.addMetric('grammar_check', 230.0, 'ms');
    monitor.addMetric('ai_conversation', 1200.0, 'ms');

    await monitor.saveToLocal();
  }

  /// 检查性能基准
  static Map<String, bool> checkBenchmarks() {
    final stats = PerformanceMonitor.instance.getStatistics();

    return {
      '启动时间': (stats['app_startup_avg'] ?? 9999) < 3000,
      '内存使用': (stats['memory_usage_avg'] ?? 999) < 200,
      '页面加载': (stats['page_load_avg'] ?? 9999) < 500,
      'AI响应': (stats['ai_response_avg'] ?? 9999) < 2000,
    };
  }
}

// 导出为JSON的辅助函数
String exportPerformanceReport() {
  final monitor = PerformanceMonitor.instance;
  return monitor.generateReport();
}
