/// AI对话界面
library;

import 'package:flutter/material.dart';
import '../../models/conversation.dart';
import '../../services/ai_conversation_service.dart';
import '../../services/subscription_service.dart';
import '../../data/conversation_scenarios.dart';

class AIConversationScreen extends StatefulWidget {
  const AIConversationScreen({super.key});

  @override
  State<AIConversationScreen> createState() => _AIConversationScreenState();
}

class _AIConversationScreenState extends State<AIConversationScreen> {
  final ConversationService _conversationService = ConversationService.instance;
  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasPremium = false;
  bool _isTrial = false;
  int _trialDaysRemaining = 0;
  bool _canStartTrial = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _conversationService.initialize();
    await _subscriptionService.initialize();
    await _updateSubscriptionStatus();
  }

  Future<void> _updateSubscriptionStatus() async {
    final hasPremium = _subscriptionService.hasPremiumAccess;
    final isTrial = _subscriptionService.currentSubscription?.isTrial ?? false;
    final trialDaysRemaining = _subscriptionService.trialDaysRemaining;
    final canStartTrial = _subscriptionService.canStartTrial;

    if (mounted) {
      setState(() {
        _hasPremium = hasPremium;
        _isTrial = isTrial;
        _trialDaysRemaining = trialDaysRemaining;
        _canStartTrial = canStartTrial;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('德语对话练习'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // 试用期/付费指示器
          if (_isTrial)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: Colors.green.shade700),
                  const SizedBox(width: 4),
                  Text(
                    '试用 $_trialDaysRemaining 天',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          if (_hasPremium && !_isTrial)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'Premium AI',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: _showScenarioSelection,
            tooltip: '选择场景',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: '设置',
          ),
        ],
      ),
      body: Column(
        children: [
          // 对话历史
          Expanded(
            child: _buildMessagesList(),
          ),
          // 输入区域
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    final messages = _conversationService.messages;

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              '选择一个场景开始对话',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showScenarioSelection,
              icon: const Icon(Icons.list_alt),
              label: const Text('选择场景'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Icon(Icons.smart_toy,
                    size: 20, color: Colors.blue.shade700),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.blue.shade600
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                      // 纠正建议
                      if (message.correction != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue.shade100
                                  : Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message.correction!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                Icon(Icons.person, size: 20, color: Colors.green.shade700),
              ],
            ],
          ),
          // 时间戳
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 试用期提示
            if (_isTrial)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '试用期剩余 $_trialDaysRemaining 天',
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '享受基础AI对话功能',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _showSubscriptionDialog,
                      child: const Text('升级'),
                    ),
                  ],
                ),
              ),
            // 未订阅提示
            if (!_hasPremium && !_isTrial)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.upgrade, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '开始7天免费试用',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '体验基础AI对话功能',
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _startTrial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('开始试用'),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                // 语音按钮（暂时禁用）
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('语音功能即将推出')),
                    );
                  },
                  tooltip: '语音输入',
                ),
                // 输入框
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: '输入德语消息...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                // 发送按钮
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: _isLoading ? null : () => _sendMessage(_textController.text),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 检查权限
    if (!_canSendMessage()) {
      _showUpgradeDialog();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _conversationService.sendMessage(text);
      _textController.clear();

      // 滚动到底部
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// 检查是否可以发送消息
  bool _canSendMessage() {
    // 规则引擎所有人都可以用
    // 试用和付费用户可以用基础AI
    // 付费用户可以用高级AI
    return _hasPremium || _isTrial;
  }

  /// 显示升级对话框
  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('升级到Premium'),
        content: const Text('开始7天免费试用，体验基础AI对话功能！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startTrial();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('开始试用'),
          ),
        ],
      ),
    );
  }

  /// 开始试用
  Future<void> _startTrial() async {
    final success = await SubscriptionService.instance.startTrial();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '试用期已开始！' : '开始试用失败'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        await _initialize();
      }
    }
  }

  void _showScenarioSelection() {
    showDialog(
      context: context,
      builder: (context) => ScenarioSelectionDialog(
        onScenarioSelected: (scenario) {
          Navigator.pop(context);
          _conversationService.startConversation(scenario);
          setState(() {});
        },
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ConversationSettingsSheet(
        preferences: _conversationService.preferences,
        onPreferencesChanged: (prefs) async {
          await _conversationService.updatePreferences(prefs);
          setState(() {});
        },
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => const SubscriptionDialog(),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

/// 场景选择对话框
class ScenarioSelectionDialog extends StatefulWidget {
  final Function(ConversationScenario) onScenarioSelected;

  const ScenarioSelectionDialog({
    super.key,
    required this.onScenarioSelected,
  });

  @override
  State<ScenarioSelectionDialog> createState() => _ScenarioSelectionDialogState();
}

class _ScenarioSelectionDialogState extends State<ScenarioSelectionDialog> {
  String _selectedLevel = 'All';

  @override
  Widget build(BuildContext context) {
    final scenarios = ConversationScenarios.getAllScenarios();
    final filteredScenarios = _selectedLevel == 'All'
        ? scenarios
        : ConversationScenarios.getScenariosByLevel(_selectedLevel);

    return Dialog(
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          children: [
            // 标题
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
              ),
              child: Row(
                children: [
                  const Icon(Icons.list_alt, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '选择对话场景',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // 级别筛选
            if (ModalRoute.of(context)?.isFirst != false)
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildLevelChip('All', '全部'),
                    _buildLevelChip('A1', 'A1 (初学)'),
                    _buildLevelChip('A2', 'A2 (基础)'),
                    _buildLevelChip('B1', 'B1 (进阶)'),
                    _buildLevelChip('B2', 'B2 (高级)'),
                  ],
                ),
              ),
            // 场景列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredScenarios.length,
                itemBuilder: (context, index) {
                  final scenario = filteredScenarios[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        widget.onScenarioSelected(scenario);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: scenario.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                scenario.icon,
                                color: scenario.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        scenario.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: scenario.color.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          scenario.level,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: scenario.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    scenario.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelChip(String level, String label) {
    final isSelected = _selectedLevel == level;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedLevel = level;
        });
      },
      selectedColor: Colors.blue.shade600,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
    );
  }
}

/// 设置底部表单
class ConversationSettingsSheet extends StatelessWidget {
  final ConversationPreferences preferences;
  final Function(ConversationPreferences) onPreferencesChanged;

  const ConversationSettingsSheet({
    super.key,
    required this.preferences,
    required this.onPreferencesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings, color: Colors.blue),
              const SizedBox(width: 12),
              const Text(
                '对话设置',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 设置选项
          SwitchListTile(
            title: const Text('语法纠正'),
            subtitle: const Text('自动纠正语法错误'),
            value: preferences.enableGrammarCorrection,
            onChanged: (value) {
              onPreferencesChanged(
                preferences.copyWith(enableGrammarCorrection: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('语音输入'),
            subtitle: const Text('使用语音输入消息'),
            value: preferences.enableVoiceInput,
            onChanged: (value) {
              onPreferencesChanged(
                preferences.copyWith(enableVoiceInput: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('语音输出'),
            subtitle: const Text('AI响应使用语音播放'),
            value: preferences.enableVoiceOutput,
            onChanged: (value) {
              onPreferencesChanged(
                preferences.copyWith(enableVoiceOutput: value),
              );
            },
          ),
          const SizedBox(height: 16),
          // 级别选择
          const Text(
            '对话级别',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].map((level) {
              return ChoiceChip(
                label: Text(level),
                selected: preferences.level == level,
                onSelected: (selected) {
                  if (selected) {
                    onPreferencesChanged(
                      preferences.copyWith(level: level),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// 订阅对话框
class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.card_membership,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '升级到Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // 订阅计划
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: SubscriptionPlans.allPlans.map((plan) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: plan.discount > 0 ? 4 : 1,
                    child: InkWell(
                      onTap: () {
                        _showPurchaseConfirmation(context, plan);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(plan.icon,
                                    color: plan.color, size: 32),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plan.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        plan.description,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '€${plan.effectivePrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: plan.color,
                                      ),
                                    ),
                                    if (plan.discount > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          plan.discountText,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // 特性列表
                            ...plan.features.take(4).map((feature) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  feature,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            }),
                            if (plan.features.length > 4)
                              Text(
                                '+ ${plan.features.length - 4} 更多功能',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseConfirmation(
      BuildContext context, SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认购买 ${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('价格: €${plan.effectivePrice.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('期限: ${plan.duration.inDays}天'),
            if (plan.isFamily)
              Text('成员数: ${plan.maxMembers}人'),
            const SizedBox(height: 16),
            const Text('购买后将自动续费，您可以随时取消。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await SubscriptionService.instance
                  .purchaseSubscription(plan.type);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        success ? '订阅成功！' : '订阅失败，请重试'),
                    backgroundColor:
                        success ? Colors.green : Colors.red,
                  ),
                );
                if (success) Navigator.pop(context);
              }
            },
            child: const Text('确认购买'),
          ),
        ],
      ),
    );
  }
}
