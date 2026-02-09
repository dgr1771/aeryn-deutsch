/// AI对话配额管理系统
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// subscription-type
import 'subscription_service.dart' show SubscriptionType;

/// 配额类型
enum QuotaType {
  dailyMessages,      // 每日消息数
  monthlyMessages,    // 每月消息数
  aiCalls,           // AI调用次数
  premiumFeatures,   // 高级功能使用
}

/// 用户配额
class UserQuota {
  final String userId;
  final Map<QuotaType, int> used;
  final Map<QuotaType, int> limits;
  final DateTime lastResetDate;
  final DateTime? lastMonthlyResetDate;

  UserQuota({
    required this.userId,
    Map<QuotaType, int>? used,
    Map<QuotaType, int>? limits,
    required this.lastResetDate,
    this.lastMonthlyResetDate,
  })  : used = used ??
            {
              QuotaType.dailyMessages: 0,
              QuotaType.monthlyMessages: 0,
              QuotaType.aiCalls: 0,
              QuotaType.premiumFeatures: 0,
            },
        limits = limits ??
            {
              QuotaType.dailyMessages: 20,  // 免费用户每天20条
              QuotaType.monthlyMessages: 300,
              QuotaType.aiCalls: 0,  // 免费用户不能使用AI
              QuotaType.premiumFeatures: 0,
            };

  /// 检查是否可以使用配额
  bool canUseQuota(QuotaType type, int amount) {
    final usedCount = used[type] ?? 0;
    final limit = limits[type] ?? 0;

    // 如果limit为-1，表示无限制
    if (limit < 0) return true;

    return usedCount + amount <= limit;
  }

  /// 使用配额
  UserQuota useQuota(QuotaType type, int amount) {
    final currentUsed = used[type] ?? 0;
    final newUsed = Map<QuotaType, int>.from(used);
    newUsed[type] = currentUsed + amount;

    return UserQuota(
      userId: userId,
      used: newUsed,
      limits: limits,
      lastResetDate: lastResetDate,
      lastMonthlyResetDate: lastMonthlyResetDate,
    );
  }

  /// 获取剩余配额
  int getRemaining(QuotaType type) {
    final usedCount = used[type] ?? 0;
    final limit = limits[type] ?? 0;

    if (limit < 0) return -1;  // -1表示无限制
    return (limit - usedCount).clamp(0, limit);
  }

  /// 检查是否需要重置每日配额
  bool needsDailyReset() {
    final now = DateTime.now();
    final lastReset = lastResetDate;

    return now.day != lastReset.day ||
        now.month != lastReset.month ||
        now.year != lastReset.year;
  }

  /// 检查是否需要重置每月配额
  bool needsMonthlyReset() {
    final now = DateTime.now();
    final lastReset = lastMonthlyResetDate ?? lastResetDate;

    return now.month != lastReset.month || now.year != lastReset.year;
  }

  /// 重置每日配额
  UserQuota resetDailyQuota() {
    final newUsed = Map<QuotaType, int>.from(used);
    newUsed[QuotaType.dailyMessages] = 0;

    return UserQuota(
      userId: userId,
      used: newUsed,
      limits: limits,
      lastResetDate: DateTime.now(),
      lastMonthlyResetDate: lastMonthlyResetDate,
    );
  }

  /// 重置每月配额
  UserQuota resetMonthlyQuota() {
    final newUsed = Map<QuotaType, int>.from(used);
    newUsed[QuotaType.monthlyMessages] = 0;
    newUsed[QuotaType.aiCalls] = 0;

    return UserQuota(
      userId: userId,
      used: newUsed,
      limits: limits,
      lastResetDate: lastResetDate,
      lastMonthlyResetDate: DateTime.now(),
    );
  }

  /// 更新限制（用于订阅升级）
  UserQuota updateLimits(Map<QuotaType, int> newLimits) {
    return UserQuota(
      userId: userId,
      used: used,
      limits: newLimits,
      lastResetDate: lastResetDate,
      lastMonthlyResetDate: lastMonthlyResetDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'used': used.map((k, v) => MapEntry(k.toString(), v)),
      'limits': limits.map((k, v) => MapEntry(k.toString(), v)),
      'lastResetDate': lastResetDate.toIso8601String(),
      'lastMonthlyResetDate': lastMonthlyResetDate?.toIso8601String(),
    };
  }

  factory UserQuota.fromJson(Map<String, dynamic> json) {
    return UserQuota(
      userId: json['userId'] as String,
      used: Map<QuotaType, int>.from(
        (json['used'] as Map).map(
          (k, v) => MapEntry(
            QuotaType.values.firstWhere(
              (e) => e.toString() == k,
              orElse: () => QuotaType.dailyMessages,
            ),
            v as int,
          ),
        ),
      ),
      limits: Map<QuotaType, int>.from(
        (json['limits'] as Map).map(
          (k, v) => MapEntry(
            QuotaType.values.firstWhere(
              (e) => e.toString() == k,
              orElse: () => QuotaType.dailyMessages,
            ),
            v as int,
          ),
        ),
      ),
      lastResetDate: DateTime.parse(json['lastResetDate'] as String),
      lastMonthlyResetDate: json['lastMonthlyResetDate'] != null
          ? DateTime.parse(json['lastMonthlyResetDate'] as String)
          : null,
    );
  }
}

/// 配额管理服务
class QuotaService {
  static QuotaService? _instance;
  UserQuota? _currentQuota;

  QuotaService._();

  static QuotaService get instance {
    _instance ??= QuotaService._();
    return _instance!;
  }

  /// 初始化
  Future<void> initialize() async {
    await _loadQuota();
    await _checkAndResetQuotas();
  }

  /// 加载配额
  Future<void> _loadQuota() async {
    final prefs = await SharedPreferences.getInstance();
    final quotaJson = prefs.getString('user_quota');

    if (quotaJson != null) {
      _currentQuota = UserQuota.fromJson(
        Map<String, dynamic>.from(
          // 简化处理
          {'userId': 'default', ...Map<String, dynamic>.from(quotaJson as Map)},
        ),
      );
    } else {
      _currentQuota = UserQuota(
        userId: 'default',
        lastResetDate: DateTime.now(),
      );
    }
  }

  /// 保存配额
  Future<void> _saveQuota() async {
    if (_currentQuota == null) return;

    final prefs = await SharedPreferences.getInstance();
    final json = _currentQuota!.toJson();
    // 简化：实际需要正确的JSON序列化
    await prefs.setString('user_quota', json.toString());
  }

  /// 检查并重置配额
  Future<void> _checkAndResetQuotas() async {
    if (_currentQuota == null) return;

    bool needsSave = false;

    // 检查每日重置
    if (_currentQuota!.needsDailyReset()) {
      _currentQuota = _currentQuota!.resetDailyQuota();
      needsSave = true;
      debugPrint('Daily quota reset');
    }

    // 检查每月重置
    if (_currentQuota!.needsMonthlyReset()) {
      _currentQuota = _currentQuota!.resetMonthlyQuota();
      needsSave = true;
      debugPrint('Monthly quota reset');
    }

    if (needsSave) {
      await _saveQuota();
    }
  }

  /// 获取当前配额
  UserQuota? get currentQuota => _currentQuota;

  /// 检查是否可以发送消息
  bool canSendMessage() {
    if (_currentQuota == null) return false;
    return _currentQuota!.canUseQuota(QuotaType.dailyMessages, 1);
  }

  /// 使用消息配额
  Future<bool> useMessageQuota() async {
    if (_currentQuota == null) return false;

    // 先检查是否需要重置
    await _checkAndResetQuotas();

    if (!canSendMessage()) {
      debugPrint('Message quota exceeded');
      return false;
    }

    _currentQuota = _currentQuota!.useQuota(QuotaType.dailyMessages, 1);
    _currentQuota = _currentQuota!.useQuota(QuotaType.monthlyMessages, 1);
    await _saveQuota();

    debugPrint('Message quota used. Remaining: ${getRemainingMessages()}');
    return true;
  }

  /// 检查是否可以使用AI
  bool canUseAI() {
    if (_currentQuota == null) return false;
    return _currentQuota!.canUseQuota(QuotaType.aiCalls, 1);
  }

  /// 使用AI配额
  Future<bool> useAIQuota() async {
    if (_currentQuota == null) return false;

    if (!canUseAI()) {
      debugPrint('AI quota exceeded');
      return false;
    }

    _currentQuota = _currentQuota!.useQuota(QuotaType.aiCalls, 1);
    await _saveQuota();

    debugPrint('AI quota used. Remaining: ${getRemainingAICalls()}');
    return true;
  }

  /// 获取剩余消息数
  int getRemainingMessages() {
    return _currentQuota?.getRemaining(QuotaType.dailyMessages) ?? 0;
  }

  /// 获取剩余AI调用数
  int getRemainingAICalls() {
    final remaining = _currentQuota?.getRemaining(QuotaType.aiCalls) ?? 0;
    return remaining == -1 ? 999999 : remaining;  // -1表示无限制
  }

  /// 更新配额限制（当用户升级订阅时调用）
  Future<void> updateQuotaLimits(SubscriptionType subscriptionType) async {
    if (_currentQuota == null) return;

    final newLimits = _getLimitsForSubscription(subscriptionType);
    _currentQuota = _currentQuota!.updateLimits(newLimits);
    await _saveQuota();

    debugPrint('Quota limits updated for $subscriptionType');
  }

  /// 根据订阅类型获取配额限制
  Map<QuotaType, int> _getLimitsForSubscription(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.monthly:
        return {
          QuotaType.dailyMessages: -1,  // 无限制
          QuotaType.monthlyMessages: -1,
          QuotaType.aiCalls: 100,  // 每月100次AI调用
          QuotaType.premiumFeatures: -1,
        };
      case SubscriptionType.quarterly:
        return {
          QuotaType.dailyMessages: -1,
          QuotaType.monthlyMessages: -1,
          QuotaType.aiCalls: 150,  // 每月150次
          QuotaType.premiumFeatures: -1,
        };
      case SubscriptionType.yearly:
        return {
          QuotaType.dailyMessages: -1,
          QuotaType.monthlyMessages: -1,
          QuotaType.aiCalls: 200,  // 每月200次
          QuotaType.premiumFeatures: -1,
        };
      case SubscriptionType.family:
        return {
          QuotaType.dailyMessages: -1,
          QuotaType.monthlyMessages: -1,
          QuotaType.aiCalls: 500,  // 家庭组共享500次/月
          QuotaType.premiumFeatures: -1,
        };
    }
  }

  /// 获取试用期的配额限制
  Map<QuotaType, int> getTrialLimits() {
    return {
      QuotaType.dailyMessages: 50,  // 试用期间每天50条
      QuotaType.monthlyMessages: 300,
      QuotaType.aiCalls: 30,  // 试用期间总共30次AI调用
      QuotaType.premiumFeatures: 10,
    };
  }

  /// 获取免费用户的配额限制
  Map<QuotaType, int> getFreeLimits() {
    return {
      QuotaType.dailyMessages: 20,  // 免费用户每天20条规则引擎
      QuotaType.monthlyMessages: 300,
      QuotaType.aiCalls: 0,  // 免费用户不能使用AI
      QuotaType.premiumFeatures: 0,
    };
  }

  /// 设置试用期配额
  Future<void> setTrialQuota() async {
    if (_currentQuota == null) return;

    final trialLimits = getTrialLimits();
    _currentQuota = _currentQuota!.updateLimits(trialLimits);
    await _saveQuota();
  }

  /// 设置付费配额
  Future<void> setPaidQuota(SubscriptionType type) async {
    await updateQuotaLimits(type);
  }

  /// 重置配额（测试用）
  Future<void> resetQuota() async {
    _currentQuota = UserQuota(
      userId: 'default',
      lastResetDate: DateTime.now(),
    );
    await _saveQuota();
  }

  /// 获取配额使用统计
  Map<String, dynamic> getQuotaStats() {
    if (_currentQuota == null) return {};

    return {
      'dailyMessages': {
        'used': _currentQuota!.used[QuotaType.dailyMessages] ?? 0,
        'limit': _currentQuota!.limits[QuotaType.dailyMessages] ?? 0,
        'remaining': getRemainingMessages(),
      },
      'aiCalls': {
        'used': _currentQuota!.used[QuotaType.aiCalls] ?? 0,
        'limit': _currentQuota!.limits[QuotaType.aiCalls] ?? 0,
        'remaining': getRemainingAICalls(),
      },
    };
  }
}

// 导入SubscriptionType
import 'subscription_service.dart';
/// 配额管理服务
///
/// 管理用户使用配额
library;

/// 配额服务存根实现
class QuotaService {
  static QuotaService? _instance;
  
  QuotaService._();
  
  static QuotaService get instance {
    _instance ??= QuotaService._();
    return _instance!;
  }
  
  Future<void> initialize() async {
    // 存根实现
  }
  
  Future<void> setTrialQuota() async {
    // 存根实现
  }
  
  Future<void> setPaidQuota(String type) async {
    // 存根实现
  }
}
