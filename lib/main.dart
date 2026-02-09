import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/vocabulary_screen.dart';
import 'ui/screens/grammar_screen.dart';
import 'ui/screens/ai_conversation_screen.dart';
import 'ui/screens/speech_learning_screen.dart';
import 'ui/screens/pomodoro_screen.dart';
import 'ui/screens/subscription_screen.dart';
// import 'services/error_tracking_service.dart';  // 暂时禁用：依赖问题

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 仅在生产环境启用错误追踪
  // 暂时禁用：sentry_flutter 依赖问题
  // if (kReleaseMode) {
  //   await ErrorTrackingService.instance.initialize(
  //     dsn: const String.fromEnvironment('SENTRY_DSN'),
  //     environment: 'production',
  //     tracesSampleRate: 0.1,
  //   );
  // }

  runApp(const AerynDeutschApp());
}

/// Aeryn-Deutsch 主应用
class AerynDeutschApp extends StatelessWidget {
  const AerynDeutschApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aeryn-Deutsch - 德语学习',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      routes: {
        '/vocabulary': (context) => const VocabularyScreen(),
        '/grammar': (context) => const GrammarScreen(),
        '/ai-chat': (context) => const AIConversationScreen(),
        '/speech': (context) => const SpeechLearningScreen(),
        '/pomodoro': (context) => const PomodoroScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
      },
    );
  }

  /// 亮色主题
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF667eea),
        brightness: Brightness.light,
      ),
      fontFamily: 'NotoSans',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// 暗色主题
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF667eea),
        brightness: Brightness.dark,
      ),
      fontFamily: 'NotoSans',
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
