/// 新手引导 - 学习偏好设置页面
library;

import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../services/onboarding_service.dart';

class OnboardingPreferencesScreen extends StatefulWidget {
  final OnboardingData onboardingData;
  final Function(OnboardingData) onUpdate;

  const OnboardingPreferencesScreen({
    super.key,
    required this.onboardingData,
    required this.onUpdate,
  });

  @override
  State<OnboardingPreferencesScreen> createState() =>
      _OnboardingPreferencesScreenState();
}

class _OnboardingPreferencesScreenState
    extends State<OnboardingPreferencesScreen> {
  LearningStyle? _selectedStyle;
  DailyStudyTime? _selectedStudyTime;
  final List<String> _selectedTopics = [];

  @override
  void initState() {
    super.initState();
    _selectedStyle = widget.onboardingData.learningStyle;
    _selectedStudyTime = widget.onboardingData.dailyStudyTime;
    _selectedTopics.addAll(widget.onboardingData.preferredTopics ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习偏好'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 学习风格
            Text(
              '您的学习风格？',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '选择最适合您的学习方式',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            ...LearningStyle.values.map((style) {
              return _buildStyleCard(style);
            }),

            const SizedBox(height: 32),

            // 每日学习时长
            Text(
              '每天能学习多长时间？',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '我们将根据您的时间制定学习计划',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            ...DailyStudyTime.values.map((time) {
              return _buildStudyTimeCard(time);
            }),

            const SizedBox(height: 32),

            // 兴趣主题
            Text(
              '您对哪些主题感兴趣？',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '可以多选，我们会优先推荐相关内容',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _getAvailableTopics().map((topic) {
                final isSelected = _selectedTopics.contains(topic['id'] as String);
                return FilterChip(
                  label: Text(topic['label'] as String),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTopics.add(topic['id'] as String);
                      } else {
                        _selectedTopics.remove(topic['id'] as String);
                      }
                    });
                  },
                  selectedColor: Colors.blue.shade600,
                  checkmarkColor: Colors.white,
                  avatar: isSelected ? null : Icon(topic['icon'] as IconData, size: 18),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                  backgroundColor: Colors.grey.shade200,
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // 下一步按钮
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedStyle != null && _selectedStudyTime != null
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

  Widget _buildStyleCard(LearningStyle style) {
    final isSelected = _selectedStyle == style;
    final styleInfo = _getStyleInfo(style);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedStyle = style;
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
                  styleInfo['icon'] as IconData,
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
                      styleInfo['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      styleInfo['description'] as String,
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

  Widget _buildStudyTimeCard(DailyStudyTime time) {
    final isSelected = _selectedStudyTime == time;
    final timeInfo = _getStudyTimeInfo(time);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedStudyTime = time;
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
                  Icons.access_time,
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
                      timeInfo['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeInfo['description'] as String,
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

  Map<String, dynamic> _getStyleInfo(LearningStyle style) {
    return switch (style) {
      LearningStyle.visual => {
          'icon': Icons.visibility,
          'title': '视觉型',
          'description': '喜欢看图表、颜色和图像',
        },
      LearningStyle.auditory => {
          'icon': Icons.headphones,
          'title': '听觉型',
          'description': '喜欢听音频和对话',
        },
      LearningStyle.reading => {
          'icon': Icons.menu_book,
          'title': '读写型',
          'description': '喜欢阅读文本和做笔记',
        },
      LearningStyle.kinesthetic => {
          'icon': Icons.touch_app,
          'title': '动觉型',
          'description': '喜欢互动和动手练习',
        },
      LearningStyle.balanced => {
          'icon': Icons.balance,
          'title': '平衡型',
          'description': '喜欢多样化的学习方式',
        },
    };
  }

  Map<String, dynamic> _getStudyTimeInfo(DailyStudyTime time) {
    return switch (time) {
      DailyStudyTime.fiveToTen => {
          'title': '5-10分钟',
          'description': '碎片时间学习',
        },
      DailyStudyTime.tenToTwenty => {
          'title': '10-20分钟',
          'description': '轻度学习',
        },
      DailyStudyTime.twentyToThirty => {
          'title': '20-30分钟',
          'description': '适中学习',
        },
      DailyStudyTime.thirtyToSixty => {
          'title': '30-60分钟',
          'description': '认真学习',
        },
      DailyStudyTime.moreThanSixty => {
          'title': '60分钟以上',
          'description': '深度学习',
        },
    };
  }

  List<Map<String, dynamic>> _getAvailableTopics() {
    return [
      {'id': 'daily_life', 'label': '日常生活', 'icon': Icons.home},
      {'id': 'travel', 'label': '旅行', 'icon': Icons.flight},
      {'id': 'work', 'label': '工作', 'icon': Icons.work},
      {'id': 'study', 'label': '学习', 'icon': Icons.school},
      {'id': 'culture', 'label': '文化', 'icon': Icons.theater_comedy},
      {'id': 'business', 'label': '商务', 'icon': Icons.business_center},
      {'id': 'technology', 'label': '科技', 'icon': Icons.computer},
      {'id': 'history', 'label': '历史', 'icon': Icons.history_edu},
      {'id': 'food', 'label': '美食', 'icon': Icons.restaurant},
      {'id': 'music', 'label': '音乐', 'icon': Icons.music_note},
      {'id': 'sports', 'label': '体育', 'icon': Icons.sports_soccer},
      {'id': 'nature', 'label': '自然', 'icon': Icons.nature},
    ];
  }

  void _goToNext() {
    widget.onUpdate(widget.onboardingData.copyWith(
      learningStyle: _selectedStyle,
      dailyStudyTime: _selectedStudyTime,
      preferredTopics: _selectedTopics,
      currentStep: OnboardingStep.studyPlan,
    ));
  }
}
