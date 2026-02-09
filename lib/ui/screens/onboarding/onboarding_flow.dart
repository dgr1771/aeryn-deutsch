/// 新手引导流程管理器
///
/// 管理整个新手引导流程，协调各个页面
library;

import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../services/onboarding_service.dart';
import 'onboarding_welcome_screen.dart';
import 'onboarding_goal_screen.dart';
import 'adaptive_test_selection_screen.dart';
import 'onboarding_preferences_screen.dart';
import 'onboarding_plan_screen.dart';

/// 新手引导流程
class OnboardingFlow extends StatefulWidget {
  final VoidCallback? onCompleted;

  const OnboardingFlow({
    super.key,
    this.onCompleted,
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final OnboardingService _onboardingService = OnboardingService.instance;
  OnboardingData? _currentData;

  @override
  void initState() {
    super.initState();
    _initializeOnboarding();
  }

  Future<void> _initializeOnboarding() async {
    await _onboardingService.initialize();

    // 如果已经完成，直接返回
    if (_onboardingService.hasCompletedOnboarding) {
      widget.onCompleted?.call();
      return;
    }

    // 开始新的引导
    await _onboardingService.startOnboarding();
    setState(() {
      _currentData = _onboardingService.currentOnboardingData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // 阻止返回键退出引导
        return false;
      },
      child: _buildCurrentStep(),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentData!.currentStep) {
      case OnboardingStep.welcome:
        return OnboardingWelcomeScreen(
          onNext: () => _goToStep(OnboardingStep.goalSelection),
        );

      case OnboardingStep.goalSelection:
        return OnboardingGoalScreen(
          onboardingData: _currentData!,
          onUpdate: (data) async {
            await _onboardingService.updateOnboardingData(data);
            setState(() {
              _currentData = data;
            });
            _goToStep(OnboardingStep.levelAssessment);
          },
        );

      case OnboardingStep.levelAssessment:
        return AdaptiveTestSelectionScreen(
          onboardingData: _currentData!,
          onUpdate: (data) async {
            await _onboardingService.updateOnboardingData(data);
            setState(() {
              _currentData = data;
            });
            _goToStep(OnboardingStep.learningPreferences);
          },
        );

      case OnboardingStep.learningPreferences:
        return OnboardingPreferencesScreen(
          onboardingData: _currentData!,
          onUpdate: (data) async {
            await _onboardingService.updateOnboardingData(data);
            setState(() {
              _currentData = data;
            });
            _goToStep(OnboardingStep.studyPlan);
          },
        );

      case OnboardingStep.studyPlan:
        return OnboardingPlanScreen(
          onboardingData: _currentData!,
          onComplete: () async {
            await _completeOnboarding();
          },
        );

      case OnboardingStep.completed:
        // 不应该到达这里，完成后会调用onCompleted
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }

  void _goToStep(OnboardingStep step) {
    setState(() {
      _currentData = _currentData!.copyWith(currentStep: step);
    });
  }

  Future<void> _completeOnboarding() async {
    try {
      // 完成引导并创建用户档案
      final userProfile = await _onboardingService.completeOnboarding();

      // 显示成功提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('设置完成！开始您的德语学习之旅吧！'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // 延迟一点后返回
      await Future.delayed(Duration(milliseconds: 500));

      // 调用完成回调
      widget.onCompleted?.call();
    } catch (e) {
      // 显示错误
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('完成设置时出错：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 新手引导入口Widget
///
/// 用法示例：
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return StreamBuilder<User?>(
///     stream: authStateChanges,
///     builder: (context, snapshot) {
///       if (snapshot.data == null) {
///         return LoginScreen();
///       }
///
///       return FutureBuilder<bool>(
///         future: checkOnboardingStatus(),
///         builder: (context, snapshot) {
///           if (snapshot.data == false) {
///             return OnboardingFlow(
///               onCompleted: () {
///                 // 引导完成，进入主界面
///               },
///             );
///           }
///           return HomeScreen();
///         },
///       );
///     },
///   );
/// }
/// ```
class OnboardingGuard extends StatelessWidget {
  final Widget child;
  final Future<bool> Function() checkOnboardingStatus;

  const OnboardingGuard({
    super.key,
    required this.child,
    required this.checkOnboardingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkOnboardingStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == false) {
          return OnboardingFlow(
            onCompleted: () {
              // 刷新页面
              (context as Element).markNeedsBuild();
            },
          );
        }

        return child;
      },
    );
  }
}

/// 检查新手引导状态的辅助函数
Future<bool> checkOnboardingStatus() async {
  final onboardingService = OnboardingService.instance;
  await onboardingService.initialize();
  return onboardingService.hasCompletedOnboarding;
}
