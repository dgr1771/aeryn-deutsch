/// 自适应测试页面
///
/// 实现智能自适应测试界面
library;

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../models/question.dart';
import '../../../services/adaptive_test_service.dart';
import '../../../core/grammar_engine.dart';

class AdaptiveTestScreen extends StatefulWidget {
  final OnboardingData onboardingData;
  final Function(OnboardingData) onUpdate;

  const AdaptiveTestScreen({
    super.key,
    required this.onboardingData,
    required this.onUpdate,
  });

  @override
  State<AdaptiveTestScreen> createState() => _AdaptiveTestScreenState();
}

class _AdaptiveTestScreenState extends State<AdaptiveTestScreen> {
  final AdaptiveTestService _testService = AdaptiveTestService.instance;
  late final StreamSubscription _subscription;

  Question? _currentQuestion;
  String? _selectedAnswer;
  bool _isLoading = false;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeTest();
    _subscription = _testService.stateStream.listen((state) {
      if (mounted) {
        setState(() {
          if (!state.isComplete) {
            _currentQuestion = _testService.getNextQuestion();
          }
        });
      }
    });
  }

  void _initializeTest() {
    _testService.initializeTest(startLevel: LanguageLevel.A1);
    setState(() {
      _hasStarted = true;
      _currentQuestion = _testService.getNextQuestion();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasStarted || _isLoading) {
      return _buildLoadingScreen();
    }

    final state = _testService.state;

    if (state.isComplete) {
      return _buildResultScreen();
    }

    if (_currentQuestion == null) {
      return _buildLoadingScreen();
    }

    return _buildQuestionScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在准备测试...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final state = _testService.state;
    final question = _currentQuestion!;
    final progress = (state.currentQuestionIndex / 12).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('智能自适应测试'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // 跳过按钮
          TextButton(
            onPressed: () => _showSkipDialog(),
            child: const Text(
              '跳过',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 进度条
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            minHeight: 6,
          ),

          // 进度信息
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '问题 ${state.currentQuestionIndex + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 20,
                      color: _getLevelColor(state.currentLevel),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getLevelColor(state.currentLevel),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        state.currentLevel.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 难度提示
          if (state.consecutiveCorrect > 0 || state.consecutiveWrong > 0)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: state.consecutiveCorrect >= 2
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.consecutiveCorrect >= 2
                      ? Colors.green.shade200
                      : Colors.orange.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    state.consecutiveCorrect >= 2
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 16,
                    color: state.consecutiveCorrect >= 2
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.consecutiveCorrect >= 2
                          ? '表现出色！正在提升难度...'
                          : '正在调整难度以找到最适合您的水平...',
                      style: TextStyle(
                        fontSize: 12,
                        color: state.consecutiveCorrect >= 2
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 选项
                  ...question.options!.map((option) {
                    return _buildOption(question, option);
                  }),
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
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedAnswer != null
                      ? () => _submitAnswer()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '提交答案',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(Question question, QuestionOption option) {
    final isSelected = _selectedAnswer == option.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedAnswer = option.id;
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    final result = _testService.getResult();
    if (result == null) return _buildLoadingScreen();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_getLevelColor(result.assessedLevel).shade50, Colors.white],
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
                      color: _getLevelColor(result.assessedLevel).shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 50,
                      color: _getLevelColor(result.assessedLevel),
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

                  // 评估级别
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: _getLevelColor(result.assessedLevel),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '您的水平：${result.assessedLevel.name.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 统计信息
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
                    child: Column(
                      children: [
                        _buildStatRow('题目数量', '${result.totalQuestionsAsked}题'),
                        const Divider(height: 24),
                        _buildStatRow('正确', '${result.correctAnswers}题',
                            color: Colors.green),
                        const Divider(height: 24),
                        _buildStatRow('错误', '${result.wrongAnswers}题',
                            color: Colors.red),
                        const Divider(height: 24),
                        _buildStatRow('准确率', '${(result.accuracy * 100).round()}%'),
                        const Divider(height: 24),
                        _buildStatRow('用时', '${result.duration.inMinutes}分钟'),
                        const Divider(height: 24),
                        _buildStatRow('置信度', '${result.confidenceScore}%'),
                      ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.orange.shade600),
                            const SizedBox(width: 8),
                            const Text(
                              '评估反馈',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          result.feedback,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ],
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
                          assessedLevel: result.assessedLevel,
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
                        _initializeTest();
                        _selectedAnswer = null;
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

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  MaterialColor _getLevelColor(LanguageLevel level) {
    return switch (level) {
      LanguageLevel.A1 => Colors.green,
      LanguageLevel.A2 => Colors.lightGreen,
      LanguageLevel.B1 => Colors.blue,
      LanguageLevel.B2 => Colors.orange,
      LanguageLevel.C1 => Colors.red,
      LanguageLevel.C2 => Colors.purple,
    };
  }

  void _submitAnswer() async {
    if (_selectedAnswer == null || _currentQuestion == null) return;

    setState(() {
      _isLoading = true;
    });

    await _testService.submitAnswer(_currentQuestion!.id, _selectedAnswer!);

    setState(() {
      _isLoading = false;
      _selectedAnswer = null;
    });
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('跳过测试？'),
        content: const Text(
          '跳过测试后，您需要手动选择起始水平。建议选择稍低于您实际水平的级别，这样可以巩固基础并建立信心。\n\n确定跳过吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // 返回到选择页面
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定跳过'),
          ),
        ],
      ),
    );
  }
}
