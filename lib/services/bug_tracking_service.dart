/// Bug跟踪管理系统
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bug严重程度
enum BugSeverity {
  critical,  // P0: 应用崩溃、数据丢失
  high,      // P1: 核心功能无法使用
  medium,    // P2: 次要功能bug
  low,       // P3: UI小瑕疵
}

/// Bug状态
enum BugStatus {
  open,      // 新建
  assigned,  // 已分配
  inProgress,// 修复中
  resolved,  // 已修复
  verified,  // 已验证
  closed,    // 已关闭
  wontfix,   // 不予修复
}

/// Bug报告
class BugReport {
  final String id;
  final String title;
  final String description;
  final BugSeverity severity;
  final BugStatus status;
  final String? component;  // 功能模块
  final String? assignee;   // 分配给
  final String reporter;    // 报告人
  final DateTime createdDate;
  final DateTime? updatedDate;
  final DateTime? resolvedDate;
  final String? version;    // app版本
  final List<String> steps;  // 复现步骤
  final String? expectedBehavior;
  final String? actualBehavior;
  final String? deviceInfo;
  final String? osInfo;
  final List<String>? attachments;  // 截图路径
  final int? priority;  // 优先级(1-10)

  BugReport({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.reporter,
    required this.createdDate,
    this.component,
    this.assignee,
    this.updatedDate,
    this.resolvedDate,
    this.version,
    this.steps = const [],
    this.expectedBehavior,
    this.actualBehavior,
    this.deviceInfo,
    this.osInfo,
    this.attachments,
    this.priority,
  });

  /// 从JSON创建
  factory BugReport.fromJson(Map<String, dynamic> json) {
    return BugReport(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: BugSeverity.values.firstWhere(
        (e) => e.toString() == json['severity'],
        orElse: () => BugSeverity.medium,
      ),
      status: BugStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => BugStatus.open,
      ),
      reporter: json['reporter'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      component: json['component'] as String?,
      assignee: json['assignee'] as String?,
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'] as String)
          : null,
      resolvedDate: json['resolvedDate'] != null
          ? DateTime.parse(json['resolvedDate'] as String)
          : null,
      version: json['version'] as String?,
      steps: json['steps'] != null
          ? List<String>.from(json['steps'] as List)
          : const [],
      expectedBehavior: json['expectedBehavior'] as String?,
      actualBehavior: json['actualBehavior'] as String?,
      deviceInfo: json['deviceInfo'] as String?,
      osInfo: json['osInfo'] as String?,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'] as List)
          : null,
      priority: json['priority'] as int?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity.toString(),
      'status': status.toString(),
      'component': component,
      'assignee': assignee,
      'reporter': reporter,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'resolvedDate': resolvedDate?.toIso8601String(),
      'version': version,
      'steps': steps,
      'expectedBehavior': expectedBehavior,
      'actualBehavior': actualBehavior,
      'deviceInfo': deviceInfo,
      'osInfo': osInfo,
      'attachments': attachments,
      'priority': priority,
    };
  }

  /// 更新状态
  BugReport withStatus(BugStatus newStatus) {
    return BugReport(
      id: id,
      title: title,
      description: description,
      severity: severity,
      status: newStatus,
      reporter: reporter,
      createdDate: createdDate,
      component: component,
      assignee: assignee,
      updatedDate: DateTime.now(),
      resolvedDate: newStatus == BugStatus.resolved
          ? DateTime.now()
          : resolvedDate,
      version: version,
      steps: steps,
      expectedBehavior: expectedBehavior,
      actualBehavior: actualBehavior,
      deviceInfo: deviceInfo,
      osInfo: osInfo,
      attachments: attachments,
      priority: priority,
    );
  }

  /// 是否已修复
  bool get isResolved => status == BugStatus.resolved ||
                        status == BugStatus.verified ||
                        status == BugStatus.closed;

  /// 是否未修复
  bool get isOpen => status == BugStatus.open ||
                      status == BugStatus.assigned ||
                      status == BugStatus.inProgress;

  /// 计算优先级分数
  int get priorityScore {
    if (priority != null) return priority!;

    // 根据严重程度自动计算
    switch (severity) {
      case BugSeverity.critical:
        return 10;
      case BugSeverity.high:
        return 7;
      case BugSeverity.medium:
        return 5;
      case BugSeverity.low:
        return 2;
    }
  }
}

/// Bug跟踪服务
class BugTrackingService {
  static BugTrackingService? _instance;
  final List<BugReport> _bugs = [];
  final List<BugReport> _filteredBugs = [];

  BugTrackingService._();

  static BugTrackingService get instance {
    _instance ??= BugTrackingService._();
    return _instance!;
  }

  /// 初始化
  Future<void> initialize() async {
    await _loadBugs();
  }

  /// 加载bug列表
  Future<void> _loadBugs() async {
    final prefs = await SharedPreferences.getInstance();
    final bugsJson = prefs.getStringList('bug_reports');

    if (bugsJson != null && bugsJson.isNotEmpty) {
      _bugs.clear();
      for (final json in bugsJson) {
        try {
          final bug = BugReport.fromJson(
            Map<String, dynamic>.from(
              // 简化解析，实际需要完整JSON支持
              {'id': 'unknown', ...Map<String, dynamic>.from(json as Map)},
            ),
          );
          _bugs.add(bug);
        } catch (e) {
          debugPrint('Failed to load bug: $e');
        }
      }
    }
  }

  /// 保存bug列表
  Future<void> _saveBugs() async {
    final prefs = await SharedPreferences.getInstance();
    final bugsJson = _bugs.map((bug) => bug.toString()).toList();
    await prefs.setStringList('bug_reports', bugsJson);
  }

  /// 创建bug报告
  Future<BugReport> createBug({
    required String title,
    required String description,
    required BugSeverity severity,
    String? component,
    List<String> steps = const [],
    String? expectedBehavior,
    String? actualBehavior,
    String? deviceInfo,
    String? osInfo,
    String? version,
  }) async {
    final bug = BugReport(
      id: 'BUG_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      severity: severity,
      status: BugStatus.open,
      reporter: 'tester',
      createdDate: DateTime.now(),
      component: component,
      steps: steps,
      expectedBehavior: expectedBehavior,
      actualBehavior: actualBehavior,
      deviceInfo: deviceInfo,
      osInfo: osInfo,
      version: version,
    );

    _bugs.add(bug);
    await _saveBugs();

    debugPrint('Bug created: ${bug.id}');
    return bug;
  }

  /// 更新bug状态
  Future<void> updateBugStatus(String bugId, BugStatus newStatus) async {
    final index = _bugs.indexWhere((bug) => bug.id == bugId);
    if (index != -1) {
      _bugs[index] = _bugs[index].withStatus(newStatus);
      await _saveBugs();
      debugPrint('Bug $bugId status updated to $newStatus');
    }
  }

  /// 分配bug
  Future<void> assignBug(String bugId, String assignee) async {
    final index = _bugs.indexWhere((bug) => bug.id == bugId);
    if (index != -1) {
      final bug = _bugs[index];
      _bugs[index] = BugReport(
        id: bug.id,
        title: bug.title,
        description: bug.description,
        severity: bug.severity,
        status: BugStatus.assigned,
        reporter: bug.reporter,
        createdDate: bug.createdDate,
        component: bug.component,
        assignee: assignee,
        updatedDate: DateTime.now(),
        resolvedDate: bug.resolvedDate,
        version: bug.version,
        steps: bug.steps,
        expectedBehavior: bug.expectedBehavior,
        actualBehavior: bug.actualBehavior,
        deviceInfo: bug.deviceInfo,
        osInfo: bug.osInfo,
        attachments: bug.attachments,
        priority: bug.priority,
      );
      await _saveBugs();
    }
  }

  /// 获取所有bug
  List<BugReport> get bugs => List.unmodifiable(_bugs);

  /// 按严重程度筛选
  List<BugReport> getBugsBySeverity(BugSeverity severity) {
    return _bugs.where((bug) => bug.severity == severity).toList();
  }

  /// 按状态筛选
  List<BugReport> getBugsByStatus(BugStatus status) {
    return _bugs.where((bug) => bug.status == status).toList();
  }

  /// 获取未修复的P0/P1 bug
  List<BugReport> getCriticalBugs() {
    return _bugs.where((bug) =>
      bug.isOpen &&
      (bug.severity == BugSeverity.critical ||
       bug.severity == BugSeverity.high)
    ).toList()
      ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
  }

  /// 获取bug统计
  Map<String, int> getBugStatistics() {
    final stats = <String, int>{};

    for (final bug in _bugs) {
      // 按严重程度统计
      final severity = bug.severity.toString();
      stats['severity_$severity'] = (stats['severity_$severity'] ?? 0) + 1;

      // 按状态统计
      final status = bug.status.toString();
      stats['status_$status'] = (stats['status_$status'] ?? 0) + 1;
    }

    // 计算通过率
    final total = _bugs.length;
    final resolved = _bugs.where((b) => b.isResolved).length;
    if (total > 0) {
      stats['resolved_rate'] = ((resolved / total) * 100).round();
    }

    return stats;
  }

  /// 清除所有bug（测试用）
  Future<void> clearAllBugs() async {
    _bugs.clear();
    await _saveBugs();
  }

  /// 生成测试报告
  String generateTestReport() {
    final stats = getBugStatistics();
    final criticalBugs = getCriticalBugs();

    final buffer = StringBuffer();

    buffer.writeln('# Aeryn-Deutsch 测试报告');
    buffer.writeln();
    buffer.writeln('**日期**: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('**版本**: v2.8.0-Alpha');
    buffer.writeln();

    buffer.writeln('## 📊 Bug统计');
    buffer.writeln();
    buffer.writeln('### 严重程度分布');
    buffer.writeln('- **Critical (P0)**: ${stats['severity_BugSeverity.critical'] ?? 0}');
    buffer.writeln('- **High (P1)**: ${stats['severity_BugSeverity.high'] ?? 0}');
    buffer.writeln('- **Medium (P2)**: ${stats['severity_BugSeverity.medium'] ?? 0}');
    buffer.writeln('- **Low (P3)**: ${stats['severity_BugSeverity.low'] ?? 0}');
    buffer.writeln();

    buffer.writeln('### 状态分布');
    buffer.writeln('- **Open**: ${stats['status_BugStatus.open'] ?? 0}');
    buffer.writeln('- **In Progress**: ${stats['status_BugStatus.inProgress'] ?? 0}');
    buffer.writeln('- **Resolved**: ${stats['status_BugStatus.resolved'] ?? 0}');
    buffer.writeln();

    if (stats.containsKey('resolved_rate')) {
      buffer.writeln('### 修复率');
      buffer.writeln('${stats['resolved_rate']}%');
      buffer.writeln();
    }

    buffer.writeln('## 🐛 未修复的严重Bug');
    buffer.writeln();

    if (criticalBugs.isEmpty) {
      buffer.writeln('✅ 无未修复的P0/P1 bug');
    } else {
      for (final bug in criticalBugs.take(10)) {
        buffer.writeln('### ${bug.id}');
        buffer.writeln('- **标题**: ${bug.title}');
        buffer.writeln('- **严重程度**: ${bug.severity}');
        buffer.writeln('- **状态**: ${bug.status}');
        buffer.writeln('- **描述**: ${bug.description}');
        buffer.writeln();
      }
    }

    buffer.writeln('---');
    buffer.writeln('*报告生成时间: ${DateTime.now()}*');

    return buffer.toString();
  }
}

/// 测试结果记录
class TestResult {
  final String testCaseId;
  final String title;
  final bool passed;
  final String? notes;
  final DateTime timestamp;
  final String? tester;

  TestResult({
    required this.testCaseId,
    required this.title,
    required this.passed,
    this.notes,
    required this.timestamp,
    this.tester,
  });

  /// 通过测试
  factory TestResult.passed({
    required String testCaseId,
    required String title,
    String? notes,
    String? tester,
  }) {
    return TestResult(
      testCaseId: testCaseId,
      title: title,
      passed: true,
      notes: notes,
      timestamp: DateTime.now(),
      tester: tester ?? 'tester',
    );
  }

  /// 失败测试
  factory TestResult.failed({
    required String testCaseId,
    required String title,
    String? notes,
    String? tester,
  }) {
    return TestResult(
      testCaseId: testCaseId,
      title: title,
      passed: false,
      notes: notes,
      timestamp: DateTime.now(),
      tester: tester ?? 'tester',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testCaseId': testCaseId,
      'title': title,
      'passed': passed,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
      'tester': tester,
    };
  }
}
