# Sentry 错误追踪集成指南

## 版本: v1.0
## 更新日期: 2026-02-08

---

## 一、概述

Aeryn-Deutsch已集成Sentry错误追踪系统，用于捕获和分析应用中的错误和性能问题。

### 主要功能

- ✅ **自动崩溃捕获** - 应用崩溃自动上报
- ✅ **异常追踪** - 手动捕获异常
- ✅ **性能监控** - 追踪慢速操作
- ✅ **面包屑** - 记录用户操作路径
- ✅ **用户上下文** - 关联错误与用户
- ✅ **环境区分** - 开发/生产环境独立

---

## 二、配置步骤

### 2.1 获取Sentry DSN

1. 访问 [Sentry.io](https://sentry.io/)
2. 创建新项目或使用现有项目
3. 选择 **Flutter** 平台
4. 复制 **DSN** (Data Source Name)

### 2.2 配置环境变量

**方式1: 使用环境变量 (推荐)**

在运行应用时设置环境变量：

```bash
# 开发环境 (不启用Sentry)
flutter run

# 生产环境 (启用Sentry)
flutter run --dart-define=SENTRY_DSN=https://your-dsn@sentry.io/project-id
```

**方式2: 直接在代码中配置** (仅用于测试)

修改 `lib/main.dart`:

```dart
await ErrorTrackingService.instance.initialize(
  dsn: 'https://your-dsn@sentry.io/project-id', // 替换为你的DSN
  environment: kReleaseMode ? 'production' : 'development',
  tracesSampleRate: kReleaseMode ? 0.1 : 1.0,
);
```

⚠️ **警告**: 不要将DSN硬编码到生产代码中！

### 2.3 构建发布版本

```bash
# Android
flutter build apk --dart-define=SENTRY_DSN=https://your-dsn@sentry.io/project-id

# iOS
flutter build ios --dart-define=SENTRY_DSN=https://your-dsn@sentry.io/project-id
```

---

## 三、使用方法

### 3.1 自动错误捕获

Sentry会自动捕获以下类型的错误：

- 未捕获的异常
- Flutter框架错误
- 应用崩溃

无需额外代码。

### 3.2 手动捕获异常

**基础用法**:

```dart
try {
  // 可能出错的代码
  final result = await riskyOperation();
} catch (e, stackTrace) {
  await ErrorTrackingService.instance.captureException(
    e,
    stackTrace: stackTrace,
  );
}
```

**使用简化API**:

```dart
try {
  await riskyOperation();
} catch (e, stackTrace) {
  await ErrorTracker.capture(e, stackTrace: stackTrace);
}
```

**添加额外信息**:

```dart
await ErrorTracker.capture(
  exception,
  stackTrace: stackTrace,
  hint: {
    'userId': '123',
    'action': 'loadData',
    'context': '加载用户数据时出错',
  },
);
```

### 3.3 记录日志

```dart
// Info级别
await ErrorTracker.log('用户登录成功');

// Warning级别
await ErrorTracker.log(
  'API响应时间过长',
  level: SentryLevel.warning,
);

// Error级别
await ErrorTracker.log(
  '关键功能失败',
  level: SentryLevel.error,
);
```

### 3.4 添加面包屑 (Breadcrumbs)

面包屑记录用户操作路径，帮助重现问题：

```dart
// 记录用户操作
ErrorTracker.breadcrumb(
  '用户点击按钮',
  category: 'user.action',
  data: {'button': 'login', 'screen': 'login_screen'},
);

// 记录API调用
ErrorTracker.breadcrumb(
  '调用用户API',
  category: 'http.request',
  data: {'url': '/api/user', 'method': 'GET'},
);
```

### 3.5 设置用户上下文

```dart
// 用户登录时
ErrorTracker.setUser(
  id: 'user_123',
  email: 'user@example.com',
  username: 'john_doe',
);

// 用户登出时
ErrorTrackingService.instance.clearUserContext();
```

### 3.6 设置标签

```dart
// 设置应用版本
ErrorTracker.setTag('app_version', '0.1.0+1');

// 设置语言
ErrorTracker.setTag('language', 'de-DE');

// 设置级别
ErrorTracker.setTag('user_level', 'B1');
```

### 3.7 性能追踪

**方式1: 手动追踪**

```dart
final transaction = ErrorTrackingService.instance.startTransaction(
  name: 'load_vocabulary',
  operation: 'database',
);

try {
  final data = await loadData();
  await ErrorTrackingService.instance.endTransaction(
    transaction,
    status: SentryStatus.ok(),
  );
  return data;
} catch (e) {
  await ErrorTrackingService.instance.endTransaction(
    transaction,
    status: SentryStatus.internalError(),
  );
  rethrow;
}
```

**方式2: 使用辅助方法 (推荐)**

```dart
final result = await ErrorTracker.trace(
  'load_vocabulary',
  operation: 'database',
  block: () async {
    return await loadData();
  },
);
```

**自动追踪耗时操作**:

```dart
await ErrorTracker.trace('load_words', block: () async {
  return await vocabularyService.loadWords();
});
```

---

## 四、最佳实践

### 4.1 关键操作添加追踪

```dart
class VocabularyService {
  Future<List<Word>> loadWords() async {
    return await ErrorTracker.trace('vocabulary.load', block: () async {
      // 添加面包屑
      ErrorTracker.breadcrumb('开始加载词汇', category: 'vocabulary');

      final words = await _fetchFromDatabase();

      // 记录加载的词汇数量
      ErrorTracker.setTag('word_count', words.length.toString());

      return words;
    });
  }
}
```

### 4.2 API请求添加上下文

```dart
Future<User> fetchUser(String id) async {
  ErrorTracker.breadcrumb(
    '获取用户信息',
    category: 'api',
    data: {'userId': id},
  );

  try {
    final response = await api.getUser(id);
    ErrorTracker.setTag('api_status', 'success');
    return response;
  } catch (e) {
    ErrorTracker.setTag('api_status', 'error');
    await ErrorTracker.capture(e, hint: {'userId': id});
    rethrow;
  }
}
```

### 4.3 用户操作添加记录

```dart
class OnboardingFlow {
  void _goToStep(OnboardingStep step) {
    ErrorTracker.breadcrumb(
      '用户进入新步骤',
      category: 'onboarding',
      data: {'step': step.name},
    );

    setState(() {
      _currentData = _currentData!.copyWith(currentStep: step);
    });
  }

  Future<void> _completeOnboarding() async {
    try {
      final profile = await _onboardingService.completeOnboarding();

      // 记录成功
      await ErrorTracker.log(
        '新手引导完成',
        level: SentryLevel.info,
        hint: {
          'user_goal': profile.primaryGoal.name,
          'target_level': profile.targetLevel.name,
        },
      );
    } catch (e) {
      // 记录失败
      await ErrorTracker.capture(
        e,
        hint: {'context': '完成新手引导时出错'},
      );
    }
  }
}
```

---

## 五、测试

### 5.1 测试错误捕获

```dart
// 测试代码
void testErrorCapture() async {
  try {
    throw Exception('这是一个测试错误');
  } catch (e, stackTrace) {
    await ErrorTracker.capture(e, stackTrace: stackTrace);
  }
}
```

### 5.2 测试性能追踪

```dart
void testPerformanceTracing() async {
  final result = await ErrorTracker.trace('test_operation', block: () async {
    await Future.delayed(const Duration(seconds: 1));
    return '完成';
  });
  print(result);
}
```

### 5.3 验证Sentry配置

1. 运行应用
2. 执行测试代码
3. 访问Sentry Dashboard
4. 查看 Issues 页面，应该能看到测试错误

---

## 六、开发模式 vs 生产模式

### 开发模式

```dart
await ErrorTrackingService.instance.initialize(
  dsn: null, // 不启用Sentry
  environment: 'development',
);
```

**行为**:
- 不发送错误到Sentry
- 所有日志输出到控制台
- 便于本地调试

### 生产模式

```dart
await ErrorTrackingService.instance.initialize(
  dsn: 'https://your-dsn@sentry.io/project-id', // 启用Sentry
  environment: 'production',
  tracesSampleRate: 0.1, // 仅采样10%的性能追踪
);
```

**行为**:
- 发送错误到Sentry
- 性能追踪采样 (减少成本)
- 自动崩溃报告

---

## 七、成本优化

### 7.1 性能追踪采样率

```dart
// 生产环境降低采样率
await ErrorTrackingService.instance.initialize(
  tracesSampleRate: 0.1, // 仅追踪10%的事务
);

// 开发环境完全追踪
await ErrorTrackingService.instance.initialize(
  tracesSampleRate: 1.0, // 追踪100%的事务
);
```

### 7.2 事件过滤

```dart
await ErrorTrackingService.instance.initialize(
  beforeSend: (event, {hint}) {
    // 过滤掉调试信息
    if (event.level == SentryLevel.debug) {
      return null;
    }
    return event;
  },
);
```

### 7.3 面包屑限制

Sentry默认保留最近的100个面包屑，可以通过配置调整：

```dart
await ErrorTrackingService.instance.initialize(
  maxBreadcrumbs: 50, // 减少到50个
);
```

---

## 八、故障排除

### 问题1: Sentry初始化失败

**症状**: 应用启动时出现Sentry相关错误

**解决**:
1. 检查DSN是否正确
2. 确认网络连接
3. 查看Sentry Dashboard状态

### 问题2: 错误未上报

**症状**: 发生错误但Sentry看不到

**解决**:
1. 确认`_isInitialized`为true
2. 检查环境变量是否正确设置
3. 查看控制台日志

### 问题3: 性能追踪无数据

**症状**: Performance页面无数据

**解决**:
1. 检查`tracesSampleRate`配置
2. 确认使用了`tracePerformance`或`startTransaction`
3. 查看Sentry Performance页面

---

## 九、常见问题

### Q1: 是否必须使用Sentry？

**A**: 不是。Sentry是可选的，不配置也能正常运行。开发模式下会使用控制台日志。

### Q2: Sentry数据存储在哪里？

**A**: Sentry提供云服务 (sentry.io) 或自托管选项。我们使用云服务。

### Q3: 是否影响应用性能？

**A**: Sentry的性能影响极小 (<1%)，生产环境使用采样率进一步降低影响。

### Q4: 如何关闭Sentry？

**A**: 设置`dsn: null`或移除环境变量即可。

---

## 十、总结

### 已完成的集成

- ✅ Sentry SDK集成
- ✅ 错误追踪服务封装
- ✅ 性能监控支持
- ✅ 用户上下文管理
- ✅ 面包屑记录
- ✅ 简化API (ErrorTracker)
- ✅ 开发/生产环境区分

### 下一步

- [ ] 在Sentry创建项目
- [ ] 配置环境变量
- [ ] 测试错误上报
- [ ] 配置告警通知
- [ ] 设置性能监控阈值

---

**文档版本**: v1.0
**最后更新**: 2026-02-08
**作者**: Claude (Sonnet 4.5)
