/// 新手引导 - 目标选择页面
library;

import 'package:flutter/material.dart';
import '../../widgets/color_coded_text.dart';
import '../../../models/user_profile.dart';
import '../../../models/word.dart';
import '../../../core/grammar_engine.dart';
import '../../../services/onboarding_service.dart';

class OnboardingGoalScreen extends StatefulWidget {
  final OnboardingData onboardingData;
  final Function(OnboardingData) onUpdate;

  const OnboardingGoalScreen({
    super.key,
    required this.onboardingData,
    required this.onUpdate,
  });

  @override
  State<OnboardingGoalScreen> createState() => _OnboardingGoalScreenState();
}

class _OnboardingGoalScreenState extends State<OnboardingGoalScreen> {
  LearningGoal? _selectedGoal;
  LanguageLevel? _targetLevel;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.onboardingData.selectedGoal;
    _targetLevel = widget.onboardingData.targetLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置学习目标'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 提示文本
            Text(
              '您学习德语的目标是什么？',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '选择您的主要学习目标，我们将为您定制学习计划',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // 学习目标选项
            ...LearningGoal.values.map((goal) {
              return _buildGoalCard(goal);
            }),

            const SizedBox(height: 24),

            // 目标级别
            Text(
              '您的目标级别？',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),

            // 级别选择
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: LanguageLevel.values
                  .where((level) =>
                      level.index >= LanguageLevel.A1.index &&
                      level.index <= LanguageLevel.C2.index)
                  .map((level) {
                return _buildLevelChip(level);
              }).toList(),
            ),

            const SizedBox(height: 32),

            // 下一步按钮
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedGoal != null && _targetLevel != null
                    ? _goToNext
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  '下一步',
                  style: TextStyle(
                    fontSize: 18,
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

  Widget _buildGoalCard(LearningGoal goal) {
    final isSelected = _selectedGoal == goal;
    final goalInfo = _getGoalInfo(goal);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGoal = goal;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.shade600
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  goalInfo['icon'] as IconData,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalInfo['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goalInfo['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelChip(LanguageLevel level) {
    final isSelected = _targetLevel == level;
    return FilterChip(
      label: Text(level.name.toUpperCase()),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _targetLevel = selected ? level : null;
        });
      },
      selectedColor: Colors.blue.shade600,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Map<String, dynamic> _getGoalInfo(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.testDaF => {
          'icon': Icons.school,
          'title': 'TestDaF考试',
          'description': '准备TestDaF考试，用于德国大学申请',
        },
      LearningGoal.goethe => {
          'icon': Icons.workspace_premium,
          'title': 'Goethe证书',
          'description': '获得国际认可的德语证书',
        },
      LearningGoal.dsh => {
          'icon': Icons.menu_book,
          'title': 'DSH考试',
          'description': '德国大学入学德语考试',
        },
      LearningGoal.telc => {
          'icon': Icons.card_membership,
          'title': 'Telc证书',
          'description': '欧洲语言证书',
        },
      LearningGoal.dailyLife => {
          'icon': Icons.chat_bubble,
          'title': '日常交流',
          'description': '掌握日常德语对话能力',
        },
      LearningGoal.work => {
          'icon': Icons.work,
          'title': '工作需求',
          'description': '德语工作环境必备',
        },
      LearningGoal.study => {
          'icon': Icons.flight_takeoff,
          'title': '留学德国',
          'description': '为德国留学做准备',
        },
      LearningGoal.travel => {
          'icon': Icons.luggage,
          'title': '旅行',
          'description': '德国旅行德语必备',
        },
      LearningGoal.culture => {
          'icon': Icons.theater_comedy,
          'title': '文化学习',
          'description': '了解德国文化和语言',
        },
      LearningGoal.interest => {
          'icon': Icons.favorite,
          'title': '兴趣爱好',
          'description': '出于兴趣学习德语',
        },
    };
  }

  void _goToNext() {
    widget.onUpdate(widget.onboardingData.copyWith(
      selectedGoal: _selectedGoal,
      targetLevel: _targetLevel,
      currentStep: OnboardingStep.levelAssessment,
    ));
  }
}
