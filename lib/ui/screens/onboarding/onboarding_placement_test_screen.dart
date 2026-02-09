/// 新手引导 - 水平测试页面
library;

import 'package:flutter/material.dart';
import '../../../data/placement_test_data.dart';
import '../../../models/user_profile.dart';
import '../../../models/question.dart';
import '../../../models/word.dart';
import '../../../core/grammar_engine.dart';
import '../../../services/onboarding_service.dart';

class OnboardingPlacementTestScreen extends StatefulWidget {
  final OnboardingData onboardingData;
  final Function(OnboardingData) onUpdate;

  const OnboardingPlacementTestScreen({
    super.key,
    required this.onboardingData,
    required this.onUpdate,
  });

  @override
  State<OnboardingPlacementTestScreen> createState() =>
      _OnboardingPlacementTestScreenState();
}

class _OnboardingPlacementTestScreenState
    extends State<OnboardingPlacementTestScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= placementTestQuestions.length) {
      // 测试完成，显示结果
      return _buildResultScreen();
    }

    final question = placementTestQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('水平测试'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 进度条
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) /
                placementTestQuestions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),

          // 进度文本
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '问题 ${_currentQuestionIndex + 1}/${placementTestQuestions.length}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getLevelColor(question.targetLevel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    question.targetLevel.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 问题内容
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 问题文本
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      question.question,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 选项
                  ...question.options!.map((option) {
                    return _buildOption(question, option);
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 底部按钮
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // 上一题
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousQuestion,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '上一题',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (_currentQuestionIndex > 0) const SizedBox(width: 12),

                  // 下一题/完成
                  Expanded(
                    flex: _currentQuestionIndex > 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _answers.containsKey(question.id)
                          ? _nextQuestion
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentQuestionIndex <
                                placementTestQuestions.length - 1
                            ? '下一题'
                            : '查看结果',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(Question question, QuestionOption option) {
    final isSelected = _answers[question.id] == option.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _answers[question.id] = option.id;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.shade600
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + question.options!.indexOf(option)),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.blue.shade600,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    // 计算结果
    final result = PlacementTestResult.fromAnswers(_answers);

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
                  // 结果图标
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _getScoreColor(result.score).shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 50,
                      color: _getScoreColor(result.score),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 标题
                  const Text(
                    '测试完成！',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 得分
                  Text(
                    '${result.score}分',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(result.score),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 正确率
                  Text(
                    '正确 ${result.correctAnswers}/${result.totalQuestions} 题',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 评估级别
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(result.score),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '您的水平：${result.level.name.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 详细反馈
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      result.feedback,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 确认按钮
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onUpdate(widget.onboardingData.copyWith(
                          assessedLevel: result.level,
                          currentStep: OnboardingStep.learningPreferences,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        '继续设置',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 重新测试
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex = 0;
                        _answers.clear();
                      });
                    },
                    child: Text(
                      '重新测试',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(LanguageLevel level) {
    return switch (level) {
      LanguageLevel.A1 => Colors.green,
      LanguageLevel.A2 => Colors.lightGreen,
      LanguageLevel.B1 => Colors.blue,
      LanguageLevel.B2 => Colors.orange,
      LanguageLevel.C1 => Colors.red,
      LanguageLevel.C2 => Colors.purple,
    };
  }

  MaterialColor _getScoreColor(int score) {
    if (score >= 76) return Colors.green;
    if (score >= 51) return Colors.blue;
    if (score >= 26) return Colors.orange;
    return Colors.red;
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }
}
