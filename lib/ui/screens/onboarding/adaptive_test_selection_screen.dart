/// 自适应测试选择页面
///
/// 让用户选择测试方式：自适应、完整、快速或手动选择
library;

import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../core/grammar_engine.dart';
import 'adaptive_test_screen.dart';

class AdaptiveTestSelectionScreen extends StatelessWidget {
  final OnboardingData onboardingData;
  final Function(OnboardingData) onUpdate;

  const AdaptiveTestSelectionScreen({
    super.key,
    required this.onboardingData,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 图标
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.quiz,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 标题
                  const Text(
                    '您的德语水平如何？',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 副标题
                  Text(
                    '选择适合您的评估方式，让我们为您定制学习计划',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // 选项列表
                  _buildOptionCard(
                    context,
                    icon: Icons.psychology,
                    title: '智能自适应测试',
                    subtitle: '6-12题 · 2-5分钟 · 准确度90-95%',
                    description: '推荐！系统会根据您的答题情况动态调整难度，快速精准评估您的水平',
                    color: Colors.blue,
                    isRecommended: true,
                    onTap: () => _startAdaptiveTest(context),
                  ),

                  const SizedBox(height: 16),

                  _buildOptionCard(
                    context,
                    icon: Icons.assignment,
                    title: '完整水平测试',
                    subtitle: '20题 · 8-10分钟 · 准确度95%+',
                    description: '全面测试您的德语水平，覆盖A1-B2所有核心语法点',
                    color: Colors.green,
                    onTap: () => _startCompleteTest(context),
                  ),

                  const SizedBox(height: 16),

                  _buildOptionCard(
                    context,
                    icon: Icons.touch_app,
                    title: '手动选择级别',
                    subtitle: '30秒 · 无需测试',
                    description: '如果您已经清楚自己的水平，可以直接选择起始级别',
                    color: Colors.orange,
                    onTap: () => _showManualSelection(context),
                  ),

                  const SizedBox(height: 16),

                  _buildOptionCard(
                    context,
                    icon: Icons.skip_next,
                    title: '完全初学者',
                    subtitle: '跳过测试 · 从A1开始',
                    description: '我是德语零基础，想从最基础的内容开始学习',
                    color: Colors.grey,
                    onTap: () => _skipToA1(context),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    bool isRecommended = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题行
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
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
                    ],
                  ),

                  const SizedBox(height: 4),

                  // 副标题
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 描述
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 箭头
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  void _startAdaptiveTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdaptiveTestScreen(
          onboardingData: onboardingData,
          onUpdate: onUpdate,
        ),
      ),
    );
  }

  void _startCompleteTest(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/placement-test');
  }

  void _showManualSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ManualSelectionSheet(
        onboardingData: onboardingData,
        onUpdate: onUpdate,
      ),
    );
  }

  void _skipToA1(BuildContext context) {
    // 显示确认对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认从A1开始？'),
        content: const Text(
          '您选择跳过测试，将从A1初学者级别开始学习。\n\n'
          '您可以在"设置"中随时重新评估您的水平。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              onUpdate(onboardingData.copyWith(
                assessedLevel: LanguageLevel.A1,
                currentStep: OnboardingStep.learningPreferences,
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}

/// 手动选择级别底部表单
class _ManualSelectionSheet extends StatefulWidget {
  final OnboardingData onboardingData;
  final Function(OnboardingData) onUpdate;

  const _ManualSelectionSheet({
    required this.onboardingData,
    required this.onUpdate,
  });

  @override
  State<_ManualSelectionSheet> createState() => _ManualSelectionSheetState();
}

class _ManualSelectionSheetState extends State<_ManualSelectionSheet> {
  LanguageLevel? _selectedLevel;

  final Map<LanguageLevel, Map<String, String>> _levelDescriptions = {
    LanguageLevel.A1: {
      'title': 'A1 - 初学者',
      'description': '能理解和使用熟悉的日常用语',
      'skills': '基础语法、1000个常用词汇',
      'time': '2-4年',
    },
    LanguageLevel.A2: {
      'title': 'A2 - 初级',
      'description': '能进行简单的日常交流',
      'skills': '扩展词汇、日常对话',
      'time': '1.5-3年',
    },
    LanguageLevel.B1: {
      'title': 'B1 - 中级',
      'description': '能应付大多数交流场景',
      'skills': '复杂语法、商务德语',
      'time': '1-2年',
    },
    LanguageLevel.B2: {
      'title': 'B2 - 中高级',
      'description': '能自然流利地交流',
      'skills': '高级表达、专业德语',
      'time': '6-12个月',
    },
    LanguageLevel.C1: {
      'title': 'C1 - 高级',
      'description': '能灵活运用语言进行社交和学术交流',
      'skills': '学术德语、专业领域',
      'time': '根据目标',
    },
    LanguageLevel.C2: {
      'title': 'C2 - 精通',
      'description': '接近母语水平的语言能力',
      'skills': '保持提升、深化理解',
      'time': '保持提升',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖动条
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 标题
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.orange.shade600,
                ),
                const SizedBox(width: 12),
                const Text(
                  '选择您的德语水平',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 级别选项
          SizedBox(
            height: 400,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: LanguageLevel.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final level = LanguageLevel.values[index];
                final info = _levelDescriptions[level]!;
                final isSelected = _selectedLevel == level;

                return _buildLevelOption(level, info, isSelected);
              },
            ),
          ),

          // 确认按钮
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedLevel != null
                    ? () => _confirmSelection(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '确认选择',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelOption(
    LanguageLevel level,
    Map<String, String> info,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade50 : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? Colors.orange.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.orange.shade600 : Colors.grey.shade400,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    info['title']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.orange.shade700 : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info['description']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildInfoChip('lightbulb', info['skills']!),
                      const SizedBox(width: 8),
                      _buildInfoChip('schedule', info['time']!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String iconName, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconName == 'lightbulb' ? Icons.lightbulb : Icons.schedule,
          size: 14,
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  void _confirmSelection(BuildContext context) {
    if (_selectedLevel == null) return;

    Navigator.pop(context); // 关闭底部表单
    widget.onUpdate(widget.onboardingData.copyWith(
      assessedLevel: _selectedLevel,
      currentStep: OnboardingStep.learningPreferences,
    ));
  }
}
