import 'package:flutter/material.dart';
import '../../services/subscription_service.dart';

/// 订阅管理界面
///
/// 功能：
/// - 显示5种订阅方案（免费、月度、季度、年度、家庭组）
/// - 7天免费试用
/// - 功能对比
/// - 订阅管理
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  bool _isLoading = true;
  UserSubscription? _currentSubscription;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    await _subscriptionService.initialize();
    _currentSubscription = _subscriptionService.currentSubscription;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('订阅方案'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _initializeData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 当前订阅状态
                  _buildCurrentStatus(),

                  const SizedBox(height: 24),

                  // 免费试用卡片
                  if (_subscriptionService.canStartTrial)
                    _buildFreeTrialCard(),

                  const SizedBox(height: 24),

                  // 订阅方案
                  _buildPlansSection(),

                  const SizedBox(height: 24),

                  // 功能对比表
                  _buildFeatureComparison(),

                  const SizedBox(height: 24),

                  // 常见问题
                  _buildFAQSection(),
                ],
              ),
            ),
    );
  }

  /// 当前订阅状态
  Widget _buildCurrentStatus() {
    final status = _currentSubscription?.status ?? SubscriptionStatus.none;
    final daysRemaining = _subscriptionService.daysRemaining;

    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case SubscriptionStatus.trial:
        statusText = '试用期中 (剩余 $daysRemaining 天)';
        statusColor = Colors.orange;
        statusIcon = Icons.timer;
        break;
      case SubscriptionStatus.active:
        statusText = '已订阅 (剩余 $daysRemaining 天)';
        statusColor = Colors.green;
        statusIcon = Icons.verified;
        break;
      case SubscriptionStatus.expired:
        statusText = '已过期';
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case SubscriptionStatus.cancelled:
        statusText = '已取消';
        statusColor = Colors.grey;
        statusIcon = Icons.cancel;
        break;
      default:
        statusText = '免费版';
        statusColor = Colors.blue;
        statusIcon = Icons.person_outline;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withValues(alpha: 0.2),
              statusColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前状态',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            if (status == SubscriptionStatus.active ||
                status == SubscriptionStatus.trial)
              ElevatedButton(
                onPressed: _showManageOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('管理'),
              ),
          ],
        ),
      ),
    );
  }

  /// 免费试用卡片
  Widget _buildFreeTrialCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withValues(alpha: 0.2),
              Colors.purple.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '7天免费试用',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '体验所有高级功能',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('包含：'),
            const SizedBox(height: 8),
            ..._buildTrialFeatures(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startTrial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '开始免费试用',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 试用功能列表
  List<Widget> _buildTrialFeatures() {
    return const [
      _FeatureItem(icon: '✅', text: '高级AI对话 (GPT-4/Claude/Gemini)'),
      _FeatureItem(icon: '✅', text: '无限对话次数'),
      _FeatureItem(icon: '✅', text: '所有对话场景'),
      _FeatureItem(icon: '✅', text: '无广告体验'),
    ];
  }

  /// 订阅方案区域
  Widget _buildPlansSection() {
    final plans = SubscriptionPlans.allPlans;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择订阅方案',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...plans.map((plan) => _buildPlanCard(plan)),
      ],
    );
  }

  /// 单个订阅方案卡片
  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isBestValue = plan.type == SubscriptionType.yearly ||
        plan.discount >= 40;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isBestValue ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isBestValue
            ? BorderSide(color: plan.color, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showPurchaseDialog(plan),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                plan.color.withValues(alpha: 0.15),
                plan.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和推荐标签
              Row(
                children: [
                  Icon(plan.icon, color: plan.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      plan.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: plan.color,
                      ),
                    ),
                  ),
                  if (isBestValue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: plan.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '推荐',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plan.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              // 价格
              Row(
                children: [
                  Text(
                    '€${plan.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: plan.color,
                    ),
                  ),
                  if (plan.discount > 0) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan.discountText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              // 功能列表
              const SizedBox(height: 12),
              ...plan.features.take(4).map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
              if (plan.features.length > 4)
                Text(
                  '+ 更多功能...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 功能对比表
  Widget _buildFeatureComparison() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '功能对比',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow('基础词汇学习', const ['✅', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('基础语法学习', const ['✅', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('规则引擎对话', const ['✅', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('高级AI对话', const ['❌', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('无限对话次数', const ['❌', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('语法纠正建议', const ['❌', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('无广告体验', const ['❌', '✅', '✅', '✅', '✅']),
            _buildComparisonRow('学习报告', const ['❌', '❌', '📊', '📊', '📊']),
            _buildComparisonRow('专属资料', const ['❌', '❌', '❌', '✅', '✅']),
            _buildComparisonRow('家庭共享', const ['❌', '❌', '❌', '❌', '👨‍👩‍👧‍👦']),
            const SizedBox(height: 8),
            Text(
              '* 📊 季度/月度报告  👨‍👩‍👧‍👦 最多5人',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String feature, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          ...values.map(
            (value) => Expanded(
              child: Center(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 常见问题
  Widget _buildFAQSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '常见问题',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              '如何取消订阅？',
              '您可以随时在订阅管理中取消订阅，取消后将继续享受已付费时长的服务，直到当前周期结束。',
            ),
            _buildFAQItem(
              '可以更换订阅方案吗？',
              '可以！您可以在当前订阅周期结束后更换到其他方案，或立即升级享受更优惠的价格。',
            ),
            _buildFAQItem(
              '家庭组如何添加成员？',
              '订阅家庭组后，您可以在账户管理中邀请最多4位家庭成员，共享高级功能。',
            ),
            _buildFAQItem(
              '试用期结束后会自动扣费吗？',
              '不会。试用期结束后需要您手动选择订阅方案，我们不会自动扣费。',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  /// 开始试用
  Future<void> _startTrial() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('开始免费试用'),
        content: const Text('您将开始7天免费试用，体验所有高级功能。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('开始试用'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _subscriptionService.startTrial();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '🎉 试用已开始！' : '启动试用失败，请稍后重试。'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        await _initializeData();
      }
    }
  }

  /// 显示购买对话框
  Future<void> _showPurchaseDialog(SubscriptionPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('订阅${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '价格：€${plan.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (plan.discount > 0)
              Text(
                plan.discountText,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
            const Text('包含功能：'),
            const SizedBox(height: 8),
            ...plan.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(feature, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: plan.color,
            ),
            child: const Text('确认订阅'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: 集成实际的支付逻辑
      final success = await _subscriptionService.purchaseSubscription(plan.type);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '🎉 订阅成功！' : '订阅失败，请稍后重试。'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        await _initializeData();
      }
    }
  }

  /// 显示管理选项
  Future<void> _showManageOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('订阅详情'),
              onTap: () {
                Navigator.pop(context);
                _showSubscriptionDetails();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('取消订阅'),
              onTap: () {
                Navigator.pop(context);
                _cancelSubscription();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('恢复购买'),
              onTap: () {
                Navigator.pop(context);
                _restorePurchase();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示订阅详情
  void _showSubscriptionDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('订阅详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('订阅类型', _currentSubscription?.type?.name ?? '无'),
            _buildDetailRow('状态', _currentSubscription?.status.name ?? '无'),
            _buildDetailRow(
              '开始日期',
              _currentSubscription?.startDate.toString().split('.')[0] ?? '无',
            ),
            _buildDetailRow(
              '结束日期',
              _currentSubscription?.endDate.toString().split('.')[0] ?? '无',
            ),
            _buildDetailRow(
              '剩余天数',
              '${_subscriptionService.daysRemaining} 天',
            ),
            _buildDetailRow(
              '自动续费',
              _currentSubscription?.autoRenew == true ? '是' : '否',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label：',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// 取消订阅
  Future<void> _cancelSubscription() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('取消订阅'),
        content: const Text(
          '取消后，您将继续享受当前订阅周期的服务，直到周期结束。之后将不会自动续费。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('保留订阅'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('确认取消'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _subscriptionService.cancelSubscription();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '已取消订阅' : '操作失败，请稍后重试'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        await _initializeData();
      }
    }
  }

  /// 恢复购买
  Future<void> _restorePurchase() async {
    final success = await _subscriptionService.restorePurchase();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '购买已恢复' : '未找到可恢复的购买记录',
          ),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );
      await _initializeData();
    }
  }
}

/// 功能条目组件
class _FeatureItem extends StatelessWidget {
  final String icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
