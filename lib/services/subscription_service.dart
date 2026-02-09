/// 订阅管理系统
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_conversation_service.dart' show AIServiceConfig;

/// 订阅类型
enum SubscriptionType {
  monthly,      // 月度订阅
  quarterly,    // 季度订阅
  yearly,       // 年度订阅
  family,       // 家庭组（5人）年度订阅
}

/// 订阅状态
enum SubscriptionStatus {
  none,         // 未订阅
  trial,        // 试用期
  active,       // 活跃
  expired,      // 已过期
  cancelled,    // 已取消
  pending,      // 处理中
}

/// 订阅计划
class SubscriptionPlan {
  final SubscriptionType type;
  final String name;
  final String description;
  final double price;  // 欧元
  final Duration duration;
  final int? maxMembers;  // 最大成员数（仅家庭组）
  final List<String> features;
  final Color color;
  final IconData icon;
  final double discount;  // 折扣百分比

  const SubscriptionPlan({
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.maxMembers,
    required this.features,
    required this.color,
    required this.icon,
    this.discount = 0.0,
  });

  /// 计算实际价格（应用折扣）
  double get effectivePrice => price * (1 - discount / 100);

  /// 计算每月价格（用于比较）
  double get monthlyEquivalent {
    final days = duration.inDays;
    return (effectivePrice / days) * 30;
  }

  /// 是否为家庭计划
  bool get isFamily => type == SubscriptionType.family;

  /// 获取折扣文本
  String get discountText {
    if (discount > 0) {
      return '节省 $discount%';
    }
    return '';
  }
}

/// 所有订阅计划
class SubscriptionPlans {
  static const List<SubscriptionPlan> allPlans = [
    SubscriptionPlan(
      type: SubscriptionType.monthly,
      name: '月度订阅',
      description: '灵活的月付方案',
      price: 10.0,
      duration: Duration(days: 30),
      features: [
        '✅ 高级AI对话 (GPT-4/Claude/Gemini)',
        '✅ 无限对话次数',
        '✅ 所有对话场景',
        '✅ 语法纠正和建议',
        '✅ 无广告体验',
        '✅ 优先客户支持',
      ],
      color: Colors.blue,
      icon: Icons.calendar_today,
    ),
    SubscriptionPlan(
      type: SubscriptionType.quarterly,
      name: '季度订阅',
      description: '季度付费，更优价格',
      price: 20.0,
      duration: Duration(days: 90),
      discount: 33,
      features: [
        '✅ 高级AI对话 (GPT-4/Claude/Gemini)',
        '✅ 无限对话次数',
        '✅ 所有对话场景',
        '✅ 语法纠正和建议',
        '✅ 无广告体验',
        '✅ 优先客户支持',
        '🎁 季度报告',
      ],
      color: Colors.green,
      icon: Icons.date_range,
    ),
    SubscriptionPlan(
      type: SubscriptionType.yearly,
      name: '年度订阅',
      description: '年度付费，节省42%',
      price: 70.0,
      duration: Duration(days: 365),
      discount: 42,
      features: [
        '✅ 高级AI对话 (GPT-4/Claude/Gemini)',
        '✅ 无限对话次数',
        '✅ 所有对话场景',
        '✅ 语法纠正和建议',
        '✅ 无广告体验',
        '✅ 优先客户支持',
        '🎁 月度学习报告',
        '🎁 专属学习资料',
        '🎁 早期功能体验',
      ],
      color: Colors.purple,
      icon: Icons.card_membership,
    ),
    SubscriptionPlan(
      type: SubscriptionType.family,
      name: '家庭组订阅',
      description: '5人共享年度订阅，每人仅€2.5/月',
      price: 150.0,
      duration: Duration(days: 365),
      maxMembers: 5,
      discount: 57,
      features: [
        '✅ 高级AI对话 (5个账户)',
        '✅ 无限对话次数',
        '✅ 所有对话场景',
        '✅ 语法纠正和建议',
        '✅ 无广告体验',
        '✅ 优先客户支持',
        '🎁 家庭学习报告',
        '🎁 家长监控面板',
        '🎁 专属学习资料',
        '🎁 早期功能体验',
      ],
      color: Colors.orange,
      icon: Icons.family_restroom,
    ),
  ];

  /// 根据类型获取计划
  static SubscriptionPlan getPlan(SubscriptionType type) {
    return allPlans.firstWhere((plan) => plan.type == type);
  }
}

/// 用户订阅信息
class UserSubscription {
  final String userId;
  final SubscriptionType? type;
  final SubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool autoRenew;
  final String? transactionId;

  UserSubscription({
    required this.userId,
    this.type,
    this.status = SubscriptionStatus.none,
    this.startDate,
    this.endDate,
    this.autoRenew = true,
    this.transactionId,
  });

  /// 是否活跃（包括试用期）
  bool get isActive {
    if (status != SubscriptionStatus.active &&
        status != SubscriptionStatus.trial) return false;
    if (endDate == null) return false;
    return DateTime.now().isBefore(endDate!);
  }

  /// 是否在试用期
  bool get isTrial => status == SubscriptionStatus.trial;

  /// 是否为付费订阅
  bool get isPaid => status == SubscriptionStatus.active;

  /// 剩余天数
  int get daysRemaining {
    if (endDate == null) return 0;
    final difference = endDate!.difference(DateTime.now());
    return difference.isNegative ? 0 : difference.inDays;
  }

  /// 是否即将到期（7天内）
  bool get isExpiringSoon {
    return daysRemaining <= 7 && daysRemaining > 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type?.toString(),
      'status': status.toString(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'autoRenew': autoRenew,
      'transactionId': transactionId,
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      userId: json['userId'] as String,
      type: json['type'] != null
          ? SubscriptionType.values.firstWhere(
              (e) => e.toString() == json['type'],
              orElse: () => SubscriptionType.monthly,
            )
          : null,
      status: json['status'] != null
          ? SubscriptionStatus.values.firstWhere(
              (e) => e.toString() == json['status'],
              orElse: () => SubscriptionStatus.none,
            )
          : SubscriptionStatus.none,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      autoRenew: json['autoRenew'] as bool? ?? true,
      transactionId: json['transactionId'] as String?,
    );
  }
}

/// 订阅管理服务
class SubscriptionService {
  static SubscriptionService? _instance;
  UserSubscription? _currentSubscription;
  QuotaService? _quotaService;

  SubscriptionService._();

  static SubscriptionService get instance {
    _instance ??= SubscriptionService._();
    return _instance!;
  }

  /// 初始化
  Future<void> initialize() async {
    await _loadSubscription();
    _quotaService = QuotaService.instance;
    await _quotaService!.initialize();

    // 根据订阅状态设置配额
    if (_currentSubscription?.isTrial ?? false) {
      await _quotaService!.setTrialQuota();
    } else if ((_currentSubscription?.isPaid ?? false) && (_currentSubscription?.type != null)) {
      await _quotaService!.setPaidQuota(_currentSubscription!.type!);
    } else {
      await _quotaService!.setTrialQuota();  // 免费用户使用基础配额
    }
  }

  /// 加载订阅信息
  Future<void> _loadSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final subJson = prefs.getString('user_subscription');

    if (subJson != null) {
      _currentSubscription = UserSubscription.fromJson(
        Map<String, dynamic>.from(
          // 简化处理，实际应该完整解析JSON
          {'userId': 'default', ...Map<String, dynamic>.from(subJson as Map)},
        ),
      );
    } else {
      _currentSubscription = UserSubscription(userId: 'default');
    }

    // 检查订阅是否过期
    if (_currentSubscription?.isActive == false &&
        _currentSubscription?.status == SubscriptionStatus.active) {
      await _updateStatus(SubscriptionStatus.expired);
    }
  }

  /// 更新订阅状态
  Future<void> _updateStatus(SubscriptionStatus newStatus) async {
    if (_currentSubscription == null) return;

    _currentSubscription = UserSubscription(
      userId: _currentSubscription!.userId,
      type: _currentSubscription!.type,
      status: newStatus,
      startDate: _currentSubscription!.startDate,
      endDate: _currentSubscription!.endDate,
      autoRenew: _currentSubscription!.autoRenew,
      transactionId: _currentSubscription!.transactionId,
    );

    await _saveSubscription();
  }

  /// 保存订阅信息
  Future<void> _saveSubscription() async {
    if (_currentSubscription == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_subscription', _currentSubscription!.toString());
  }

  /// 开始试用（7天免费试用）
  Future<bool> startTrial() async {
    try {
      final now = DateTime.now();
      final trialEnd = now.add(const Duration(days: 7));

      _currentSubscription = UserSubscription(
        userId: 'default',
        type: null,  // 试用期没有固定类型
        status: SubscriptionStatus.trial,
        startDate: now,
        endDate: trialEnd,
        autoRenew: false,
        transactionId: 'trial_${now.millisecondsSinceEpoch}',
      );

      await _saveSubscription();

      // 设置试用期配额
      if (_quotaService != null) {
        await _quotaService!.setTrialQuota();
      }

      return true;
    } catch (e) {
      debugPrint('Start trial failed: $e');
      return false;
    }
  }

  /// 检查是否可以使用试用
  bool get canStartTrial {
    return _currentSubscription?.status == SubscriptionStatus.none;
  }

  /// 购买订阅
  Future<bool> purchaseSubscription(SubscriptionType type) async {
    try {
      final plan = SubscriptionPlans.getPlan(type);
      final now = DateTime.now();

      // TODO: 集成实际的应用内购买
      // 这里使用模拟数据
      await Future.delayed(const Duration(seconds: 2));

      _currentSubscription = UserSubscription(
        userId: 'default',
        type: type,
        status: SubscriptionStatus.active,
        startDate: now,
        endDate: now.add(plan.duration),
        autoRenew: true,
        transactionId: 'txn_${now.millisecondsSinceEpoch}',
      );

      await _saveSubscription();

      // 设置付费配额
      if (_quotaService != null) {
        await _quotaService!.setPaidQuota(type);
      }

      return true;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    }
  }

  /// 取消订阅
  Future<bool> cancelSubscription() async {
    if (_currentSubscription == null) return false;

    try {
      // TODO: 集成实际的取消逻辑

      _currentSubscription = UserSubscription(
        userId: _currentSubscription!.userId,
        type: _currentSubscription!.type,
        status: SubscriptionStatus.cancelled,
        startDate: _currentSubscription!.startDate,
        endDate: _currentSubscription!.endDate,
        autoRenew: false,
        transactionId: _currentSubscription!.transactionId,
      );

      await _saveSubscription();
      return true;
    } catch (e) {
      debugPrint('Cancel failed: $e');
      return false;
    }
  }

  /// 恢复购买
  Future<bool> restorePurchase() async {
    try {
      // TODO: 集成实际的恢复购买逻辑
      await Future.delayed(const Duration(seconds: 1));

      if (_currentSubscription?.isActive == true) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Restore failed: $e');
      return false;
    }
  }

  /// 获取当前订阅
  UserSubscription? get currentSubscription => _currentSubscription;

  /// 检查是否有高级功能权限
  bool get hasPremiumAccess {
    return _currentSubscription?.isActive ?? false;
  }

  /// 检查是否可以使用特定AI引擎
  bool canUseAIEngine(String engineType) {
    // 规则引擎所有人都可以用
    if (engineType == 'ruleBased') return true;

    // 基础AI（规则引擎增强版）：试用期和付费用户可用
    if (engineType == 'basic_ai') {
      return isActive;  // 包括试用和付费
    }

    // 高级AI（OpenAI/Claude/Gemini）：仅付费用户可用
    if (['openai', 'claude', 'gemini'].contains(engineType)) {
      return isPaid;  // 仅付费用户
    }

    return false;
  }

  /// 获取可用的AI引擎列表
  List<String> getAvailableAIEngines() {
    final engines = <String>[];

    // 规则引擎总是可用
    engines.add('ruleBased');

    // 如果在试用期或已付费，可以使用基础AI
    if (_currentSubscription?.isActive ?? false) {
      engines.add('basic_ai');
    }

    // 如果已付费，可以使用所有高级AI
    if (_currentSubscription?.isPaid ?? false) {
      final configuredProviders = AIServiceConfig.getConfiguredProviders();
      engines.addAll(configuredProviders.map((p) => p.toLowerCase()));
    }

    return engines;
  }

  /// 获取推荐的AI引擎
  String getRecommendedAIEngine() {
    if (isPaid) {
      // 付费用户优先使用配置的高级AI
      final providers = AIServiceConfig.getConfiguredProviders();
      if (providers.isNotEmpty) {
        return providers.first.toLowerCase();
      }
      return 'basic_ai';
    } else if (_currentSubscription?.isTrial ?? false) {
      // 试用期用户使用基础AI
      return 'basic_ai';
    } else {
      // 未订阅用户使用规则引擎
      return 'ruleBased';
    }
  }

  /// 获取试用剩余天数
  int get trialDaysRemaining {
    if (!(_currentSubscription?.isTrial ?? false)) return 0;
    return daysRemaining;
  }

  /// 试用是否即将结束（2天内）
  bool get isTrialEndingSoon {
    if (!(_currentSubscription?.isTrial ?? false)) return false;
    return trialDaysRemaining <= 2 && trialDaysRemaining > 0;
  }

  /// 获取剩余天数
  int get daysRemaining => _currentSubscription?.daysRemaining ?? 0;

  /// 获取订阅状态
  SubscriptionStatus get status => _currentSubscription?.status ?? SubscriptionStatus.none;

  /// 获取订阅类型
  SubscriptionType? get subscriptionType => _currentSubscription?.type;

  /// 清除订阅（测试用）
  Future<void> clearSubscription() async {
    _currentSubscription = UserSubscription(userId: 'default');
    await _saveSubscription();
  }
}

/// 价格和优惠信息
class PricingInfo {
  /// 计算最优惠的计划
  static SubscriptionPlan getBestValuePlan() {
    final plans = SubscriptionPlans.allPlans;
    return plans.reduce((a, b) =>
      a.monthlyEquivalent < b.monthlyEquivalent ? a : b);
  }

  /// 计算相比月付的节省
  static double calculateSavings(SubscriptionPlan plan) {
    final monthlyPlan = SubscriptionPlans.getPlan(SubscriptionType.monthly);
    final monthlyCost = monthlyPlan.monthlyEquivalent;
    final planMonthlyCost = plan.monthlyEquivalent;

    return ((monthlyCost - planMonthlyCost) / monthlyCost) * 100;
  }
}
