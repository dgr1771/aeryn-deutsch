/// TTS (Text-to-Speech) 服务
///
/// 提供德语文本的朗读功能，支持发音练习和听力训练
library;

import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

/// TTS服务
class TTSService {
  static TTSService? _instance;
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;

  // 支持的语言
  static const List<String> supportedLanguages = [
    'de-DE', // 德语（德国）
    'de-AT', // 德语（奥地利）
    'de-CH', // 德语（瑞士）
    'en-US', // 英语（美国）
    'en-GB', // 英语（英国）
  ];

  // 语音速率
  double _speechRate = 0.5; // 0.0 - 1.0
  double _pitch = 1.0;     // 0.5 - 2.0
  double _volume = 1.0;    // 0.0 - 1.0

  // 事件回调
  Function()? _onStart;
  Function()? _onComplete;
  Function()? _onError;
  Function(String)? _onProgress;

  TTSService._internal();

  /// 获取单例
  static TTSService get instance {
    _instance ??= TTSService._internal();
    return _instance!;
  }

  /// 初始化TTS
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _flutterTts = FlutterTts();

      // 设置初始化回调
      _flutterTts!.setInitHandler(() {
        print('TTS initialized');
      });

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        _onComplete?.call();
      });

      _flutterTts!.setErrorHandler((msg) {
        print('TTS error: $msg');
        _isSpeaking = false;
        _onError?.call();
      });

      _flutterTts!.setProgressHandler((text, start, end, word) {
        _onProgress?.call(text ?? '');
      });

      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
        _onStart?.call();
      });

      // 设置语言为德语
      await setLanguage('de-DE');

      // 设置默认参数
      await _flutterTts!.setSpeechRate(_speechRate);
      await _flutterTts!.setPitch(_pitch);
      await _flutterTts!.setVolume(_volume);

      // 等待初始化完成
      await _flutterTts!.awaitSpeakCompletion(true);

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Failed to initialize TTS: $e');
      return false;
    }
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// 朗读文本
  Future<bool> speak(String text) async {
    await _ensureInitialized();

    if (_isSpeaking) {
      await stop();
    }

    try {
      final result = await _flutterTts!.speak(text);
      return result == 1;
    } catch (e) {
      print('Failed to speak: $e');
      return false;
    }
  }

  /// 停止朗读
  Future<void> stop() async {
    if (_flutterTts != null && _isSpeaking) {
      await _flutterTts!.stop();
      _isSpeaking = false;
    }
  }

  /// 暂停朗读
  Future<void> pause() async {
    if (_flutterTts != null && _isSpeaking) {
      await _flutterTts!.pause();
    }
  }

  /// 继续朗读
  Future<void> resume() async {
    if (_flutterTts != null) {
      _flutterTts!.awaitSpeakCompletion(true);
      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
        _onStart?.call();
      });
    }
  }

  /// 设置语言
  Future<bool> setLanguage(String languageCode) async {
    await _ensureInitialized();

    try {
      final languages = await _flutterTts!.getLanguages;
      if (languages.contains(languageCode)) {
        await _flutterTts!.setLanguage(languageCode);
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to set language: $e');
      return false;
    }
  }

  /// 获取支持的语言列表
  Future<List<String>> getLanguages() async {
    await _ensureInitialized();
    return await _flutterTts!.getLanguages;
  }

  /// 设置语音速率
  Future<void> setSpeechRate(double rate) async {
    await _ensureInitialized();
    _speechRate = rate.clamp(0.0, 1.0);
    await _flutterTts!.setSpeechRate(_speechRate);
  }

  /// 设置音调
  Future<void> setPitch(double pitch) async {
    await _ensureInitialized();
    _pitch = pitch.clamp(0.5, 2.0);
    await _flutterTts!.setPitch(_pitch);
  }

  /// 设置音量
  Future<void> setVolume(double volume) async {
    await _ensureInitialized();
    _volume = volume.clamp(0.0, 1.0);
    await _flutterTts!.setVolume(_volume);
  }

  /// 设置事件监听器
  void setEventListeners({
    Function()? onStart,
    Function()? onComplete,
    Function()? onError,
    Function(String)? onProgress,
  }) {
    _onStart = onStart;
    _onComplete = onComplete;
    _onError = onError;
    _onProgress = onProgress;
  }

  /// 朗读单词（用于词汇学习）
  Future<bool> speakWord({
    required String word,
    required String article,
    String? example,
    double rate = 0.4,
  }) async {
    await _ensureInitialized();

    // 设置较慢的语速以便学习者听清
    await setSpeechRate(rate);

    // 朗读顺序：冠词 + 单词 + 例句
    final buffer = StringBuffer();
    buffer.write(article);
    buffer.write(' ');
    buffer.write(word);
    if (example != null) {
      buffer.write('. ');
      buffer.write(example);
    }

    return await speak(buffer.toString());
  }

  /// 朗读句子（用于例句学习）
  Future<bool> speakSentence({
    required String sentence,
    double rate = 0.45,
  }) async {
    await _ensureInitialized();
    await setSpeechRate(rate);
    return await speak(sentence);
  }

  /// 慢速朗读（适合初学者）
  Future<bool> speakSlow(String text, {double rate = 0.3}) async {
    await _ensureInitialized();
    await setSpeechRate(rate);
    return await speak(text);
  }

  /// 正常速度朗读
  Future<bool> speakNormal(String text) async {
    await _ensureInitialized();
    await setSpeechRate(0.5);
    return await speak(text);
  }

  /// 快速朗读（适合高级学习者）
  Future<bool> speakFast(String text, {double rate = 0.7}) async {
    await _ensureInitialized();
    await setSpeechRate(rate);
    return await speak(text);
  }

  /// 重复朗读（用于听力练习）
  Future<void> speakRepeated({
    required String text,
    int repetitions = 3,
    Duration pauseBetween = const Duration(seconds: 2),
  }) async {
    for (int i = 0; i < repetitions; i++) {
      await speak(text);
      await _flutterTts!.awaitSpeakCompletion(true);

      if (i < repetitions - 1) {
        await Future.delayed(pauseBetween);
      }
    }
  }

  /// 获取当前状态
  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;
  double get speechRate => _speechRate;
  double get pitch => _pitch;
  double get volume => _volume;

  /// 释放资源
  Future<void> dispose() async {
    await stop();
    await _flutterTts?.stop();
    _isInitialized = false;
  }
}

/// TTS配置类
class TTSConfig {
  final String language;
  final double speechRate;
  final double pitch;
  final double volume;

  const TTSConfig({
    this.language = 'de-DE',
    this.speechRate = 0.5,
    this.pitch = 1.0,
    this.volume = 1.0,
  });

  /// 初学者配置（慢速）
  static const TTSConfig beginner = TTSConfig(
    speechRate: 0.3,
    pitch: 1.0,
  );

  /// 中级配置
  static const TTSConfig intermediate = TTSConfig(
    speechRate: 0.45,
    pitch: 1.0,
  );

  /// 高级配置（正常速度）
  static const TTSConfig advanced = TTSConfig(
    speechRate: 0.5,
    pitch: 1.0,
  );

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'speechRate': speechRate,
      'pitch': pitch,
      'volume': volume,
    };
  }
}
