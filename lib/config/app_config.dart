/// 应用配置
///
/// 用于初始化应用级配置，包括API密钥等
library;

import 'package:flutter/foundation.dart';
import '../services/ai_conversation_service.dart';

/// 应用配置类
class AppConfig {
  static bool _initialized = false;

  /// 初始化应用配置
  ///
  /// 此方法应在应用启动时调用
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await AIServiceConfig.loadConfig();

      // 注意：API密钥应通过SharedPreferences安全存储
      // 不要在代码中硬编码API密钥

      _initialized = true;
      debugPrint('AppConfig initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize AppConfig: $e');
    }
  }

  /// 配置DeepSeek API密钥（仅用于初始化配置）
  ///
  /// 注意：此方法仅用于首次配置，API密钥会安全存储在SharedPreferences中
  /// 生产环境中应通过安全的用户界面输入API密钥
  static Future<void> configureDeepSeek(String apiKey) async {
    try {
      await AIServiceConfig.saveAPIKey('deepseek', apiKey);
      debugPrint('DeepSeek API key configured successfully');
    } catch (e) {
      debugPrint('Failed to configure DeepSeek: $e');
      rethrow;
    }
  }

  /// 获取默认配置的DeepSeek API密钥（用于开发环境）
  ///
  /// 注意：在生产环境中，应移除此方法或确保不会暴露API密钥
  static String? get defaultDeepSeekKey {
    // 开发环境：可以从安全的环境变量或配置文件中读取
    // 生产环境：应移除此硬编码，通过用户界面输入
    if (kDebugMode) {
      // 仅在调试模式下使用
      // 实际部署时应移除此硬编码或使用环境变量
      return const String.fromEnvironment('DEEPSEEK_API_KEY');
    }
    return null;
  }

  /// 检查是否已初始化
  static bool get isInitialized => _initialized;
}
