/// Sentry错误追踪服务
library;

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry.dart';

/// 错误追踪服务
///
/// 使用Sentry捕获和报告应用错误
class ErrorTrackingService {
  // 单例模式
  ErrorTrackingService._private();
  static final ErrorTrackingService instance = ErrorTrackingService._private();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// 初始化Sentry
  ///
  /// [dsn] Sentry DSN，为null时只在开发环境输出日志
  /// [environment] 环境标识，如 'production', 'staging', 'development'
  /// [tracesSampleRate] 性能追踪采样率 (0.0-1.0)
  Future<void> initialize({
    String? dsn,
    String environment = 'production',
    double tracesSampleRate = 0.1,
  }) async {
    if (_isInitialized) {
      debugPrint('Sentry already initialized');
      return;
    }

    // 如果没有提供DSN，在开发模式下使用模拟初始化
    if (dsn == null || dsn.isEmpty) {
      debugPrint('Sentry DSN not provided, running in development mode');
      _isInitialized = true;
      return;
    }

    try {
      await SentryFlutter.init(
        (options) => options
          ..dsn = dsn
          ..environment = environment
          ..tracesSampleRate = tracesSampleRate
          ..sampleRate = 1.0
          ..debug = kDebugMode
          ..diagnosticLevel = kDebugMode
              ? SentryLevel.debug
              : SentryLevel.error
          // Before sending breadcrumb, check if we are in debug mode
          ..beforeBreadcrumb = (breadcrumb) {
            if (kDebugMode) {
              debugPrint('Breadcrumb: ${breadcrumb.message}');
            }
            return breadcrumb;
          }
          // 自定义事件处理器
          ..beforeSend = (event, {hint}) {
            if (kDebugMode) {
              debugPrint('Sending event to Sentry: ${event.message}');
            }
            return event;
          }
          // 启用性能监控
          ..enableAutoPerformanceTracing = true
          // 启用崩溃处理
          ..enableAutoSessionTracking = true
          // 应用版本
          ..release = '0.1.0+1',
        appRunner: () => debugPrint('Sentry initialized'),
      );

      _isInitialized = true;
      debugPrint('Sentry initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize Sentry: $e');
      debugPrint(stackTrace.toString());
    }
  }

  /// 捕获异常
  ///
  /// [exception] 异常对象
  /// [stackTrace] 堆栈跟踪
  /// [hint] 额外提示信息
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  }) async {
    if (!_isInitialized) {
      debugPrint('Sentry not initialized');
      debugPrint('Exception: $exception');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
      return;
    }

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint,
    );
  }

  /// 捕获消息
  ///
  /// [message] 消息内容
  /// [level] 日志级别
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
  }) async {
    if (!_isInitialized) {
      debugPrint('[$level] $message');
      return;
    }

    await Sentry.captureMessage(
      message,
      level: level,
    );
  }

  /// 添加面包屑
  ///
  /// [message] 面包屑消息
  /// [category] 分类
  /// [level] 级别
  /// [data] 附加数据
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
  }) async {
    if (!_isInitialized) {
      debugPrint('Breadcrumb: [$category] $message');
      return;
    }

    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category ?? 'custom',
        level: level,
        data: data,
      ),
    );
  }

  /// 设置用户上下文
  ///
  /// [id] 用户ID
  /// [email] 用户邮箱
  /// [username] 用户名
  /// [data] 额外数据
  void setUserContext({
    String? id,
    String? email,
    String? username,
    Map<String, dynamic>? data,
  }) {
    if (!_isInitialized) {
      debugPrint('Set user: $id, $email, $username');
      return;
    }

    Sentry.configureScope((scope) {
      scope.user = SentryUser(
        id: id,
        email: email,
        username: username,
        data: data,
      );
    });
  }

  /// 设置标签上下文
  ///
  /// [key] 标签名
  /// [value] 标签值
  void setTag(String key, String value) {
    if (!_isInitialized) {
      debugPrint('Set tag: $key = $value');
      return;
    }

    Sentry.configureScope((scope) {
      scope.setTag(key, value);
    });
  }

  /// 设置额外上下文
  ///
  /// [key] 键名
  /// [value] 值
  void setContext(String key, dynamic value) {
    if (!_isInitialized) {
      debugPrint('Set context: $key = $value');
      return;
    }

    Sentry.configureScope((scope) {
      scope.setContexts(key, value);
    });
  }

  /// 清除用户上下文
  void clearUserContext() {
    if (!_isInitialized) {
      debugPrint('Clear user context');
      return;
    }

    Sentry.configureScope((scope) {
      scope.user = null;
    });
  }

  /// 开始性能追踪
  ///
  /// [name] 追踪名称
  /// [description] 描述
  /// [operation] 操作类型
  ISentryTransaction? startTransaction({
    required String name,
    String? description,
    String? operation,
  }) {
    if (!_isInitialized) {
      debugPrint('Start transaction: $name');
      return null;
    }

    final transaction = Sentry.startTransaction(
      name,
      operation: operation ?? 'navigation',
      description: description,
      bindToScope: true,
    );

    return transaction;
  }

  /// 结束性能追踪
  ///
  /// [transaction] 事务对象
  /// [status] 状态
  Future<void> endTransaction(
    ISentryTransaction? transaction, {
    SentryStatus status = SentryStatus.ok(),
  }) async {
    if (transaction == null) {
      debugPrint('Transaction is null');
      return;
    }

    await transaction.finish(status: status);
  }

  /// 性能追踪辅助方法
  ///
  /// 用于追踪代码块的执行时间
  Future<T> tracePerformance<T>(
    String name, {
    String? operation,
    required Future<T> Function() block,
  }) async {
    final transaction = startTransaction(
      name: name,
      operation: operation ?? 'custom',
    );

    try {
      final result = await block();
      await endTransaction(transaction, status: SentryStatus.ok());
      return result;
    } catch (e, stackTrace) {
      await captureException(e, stackTrace: stackTrace);
      await endTransaction(transaction, status: SentryStatus.internalError());
      rethrow;
    }
  }

  /// 关闭Sentry
  Future<void> close() async {
    if (!_isInitialized) {
      return;
    }

    await Sentry.close();
    _isInitialized = false;
    debugPrint('Sentry closed');
  }
}

/// 辅助类：简化错误追踪使用
///
/// 用法示例：
/// ```dart
/// await ErrorTracker.trace('loadData', () async {
///   // 你的代码
///   return data;
/// });
/// ```
class ErrorTracker {
  static final _service = ErrorTrackingService.instance;

  /// 捕获异常（静默，不中断流程）
  static Future<void> capture(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  }) async {
    await _service.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint,
    );
  }

  /// 追踪性能
  static Future<T> trace<T>(
    String name, {
    String? operation,
    required Future<T> Function() block,
  }) async {
    return await _service.tracePerformance<T>(
      name,
      operation: operation,
      block: block,
    );
  }

  /// 添加日志
  static Future<void> log(
    String message, {
    SentryLevel level = SentryLevel.info,
  }) async {
    await _service.captureMessage(message, level: level);
  }

  /// 设置用户
  static void setUser({
    String? id,
    String? email,
    String? username,
  }) {
    _service.setUserContext(id: id, email: email, username: username);
  }

  /// 设置标签
  static void setTag(String key, String value) {
    _service.setTag(key, value);
  }

  /// 添加面包屑
  static void breadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  }) {
    _service.addBreadcrumb(
      message,
      category: category ?? 'custom',
      data: data,
    );
  }
}
