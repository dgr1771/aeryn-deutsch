/// 语音识别服务（框架）
///
/// 提供：语音识别、发音评分、可视化反馈
/// 注意：当前版本不配置API，使用模拟数据
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// 识别状态
enum RecognitionStatus {
  idle,       // 空闲
  listening,  // 正在听
  processing, // 处理中
  completed,  // 完成
  error,      // 错误
}

/// 识别结果
class RecognitionResult {
  final String recognizedText;  // 识别的文本
  final double confidence;       // 置信度 (0-1)
  final Duration duration;       // 音频时长
  final Map<String, dynamic>? metadata; // 元数据

  const RecognitionResult({
    required this.recognizedText,
    required this.confidence,
    required this.duration,
    this.metadata,
  });

  factory RecognitionResult.fromJson(Map<String, dynamic> json) {
    return RecognitionResult(
      recognizedText: json['recognizedText'],
      confidence: (json['confidence'] as num).toDouble(),
      duration: Duration(milliseconds: json['duration']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recognizedText': recognizedText,
      'confidence': confidence,
      'duration': duration.inMilliseconds,
      'metadata': metadata,
    };
  }
}

/// 发音评分
class PronunciationScore {
  final String recordedText;      // 录音文本
  final String targetText;        // 目标文本
  final double overallScore;       // 总分 (0-100)
  final double accuracyScore;      // 准确度得分 (0-100)
  final double fluencyScore;       // 流利度得分 (0-100)
  final double prosodyScore;       // 韵律得分 (0-100)
  final List<PronunciationError> errors; // 错误列表

  const PronunciationScore({
    required this.recordedText,
    required this.targetText,
    required this.overallScore,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.prosodyScore,
    required this.errors,
  });

  /// 获取评级
  String get grade {
    if (overallScore >= 90) return '优秀 (Excellent)';
    if (overallScore >= 80) return '良好 (Good)';
    if (overallScore >= 70) return '中等 (Fair)';
    if (overallScore >= 60) return '及格 (Pass)';
    return '需改进 (Needs Improvement)';
  }

  /// 获取颜色
  Color get gradeColor {
    if (overallScore >= 90) => Colors.green;
    if (overallScore >= 80) => Colors.lightGreen;
    if (overallScore >= 70) => Colors.blue;
    if (overallScore >= 60) => Colors.orange;
    return Colors.red;
  }

  Map<String, dynamic> toJson() {
    return {
      'recordedText': recordedText,
      'targetText': targetText,
      'overallScore': overallScore,
      'accuracyScore': accuracyScore,
      'fluencyScore': fluencyScore,
      'prosodyScore': prosodyScore,
      'errors': errors.map((e) => e.toJson()).toList(),
    };
  }
}

/// 发音错误
class PronunciationError {
  final String type;           // 错误类型
  final String position;       // 位置描述
  final String expected;       // 期望的发音
  final String actual;         // 实际的发音
  final String suggestion;     // 建议
  final double severity;       // 严重程度 (0-1)

  const PronunciationError({
    required this.type,
    required this.position,
    required this.expected,
    required this.actual,
    required this.suggestion,
    required this.severity,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'position': position,
      'expected': expected,
      'actual': actual,
      'suggestion': suggestion,
      'severity': severity,
    };
  }
}

/// 音频数据
class AudioData {
  final List<int> samples;       // 音频采样点
  final int sampleRate;          // 采样率
  final int channels;            // 声道数
  final Duration duration;        // 时长

  const AudioData({
    required this.samples,
    required this.sampleRate,
    required this.channels,
    required this.duration,
  });
}

/// 语音识别服务
class SpeechRecognitionService {
  // 单例模式
  SpeechRecognitionService._private();
  static final SpeechRecognitionService instance =
      SpeechRecognitionService._private();

  RecognitionStatus _status = RecognitionStatus.idle;
  RecognitionStatus get status => _status;

  final StreamController<RecognitionStatus> _statusController =
      StreamController<RecognitionStatus>.broadcast();
  Stream<RecognitionStatus> get statusStream => _statusController.stream;

  /// 检查是否支持语音识别
  Future<bool> isAvailable() async {
    // TODO: 检查设备和权限
    // 当前返回true表示支持，实际需要检查：
    // 1. 麦克风权限
    // 2. 录音设备
    // 3. 平台支持
    return true;
  }

  /// 初始化
  Future<void> initialize() async {
    // TODO: 初始化语音识别引擎
    // 配置API密钥、语言等
    if (kDebugMode) {
      print('SpeechRecognitionService initialized (debug mode)');
    }
  }

  /// 开始识别
  Future<void> startListening() async {
    if (_status == RecognitionStatus.listening) {
      throw Exception('Already listening');
    }

    _updateStatus(RecognitionStatus.listening);

    // TODO: 实际调用语音识别API
    // 例如：
    // - iOS: Speech Framework
    // - Android: Google Speech API
    // - Web: Web Speech API

    // 模拟延迟
    await Future.delayed(const Duration(seconds: 2));

    _updateStatus(RecognitionStatus.completed);
  }

  /// 停止识别
  Future<void> stopListening() async {
    if (_status == RecognitionStatus.idle) {
      return;
    }

    // TODO: 停止语音识别
    _updateStatus(RecognitionStatus.idle);
  }

  /// 取消识别
  Future<void> cancelListening() async {
    await stopListening();
  }

  /// 评分发音（不依赖API）
  Future<PronunciationScore> scorePronunciation({
    required String targetText,
    required AudioData recordedAudio,
  }) async {
    // TODO: 实际实现需要：
    // 1. 音频处理（降噪、归一化）
    // 2. 特征提取（MFCC、音高、节奏）
    // 3. 与标准发音对比
    // 4. 错误检测和定位

    // 当前使用基于规则的模拟评分
    return _simulatePronunciationScoring(targetText);
  }

  /// 评分发音（基于文本对比，简化版）
  Future<PronunciationScore> scorePronunciationByText({
    required String targetText,
    required String recognizedText,
  }) async {
    // 基于文本相似度的简单评分
    final similarity = _calculateTextSimilarity(targetText, recognizedText);
    final overallScore = (similarity * 100).roundToDouble();

    return PronunciationScore(
      recordedText: recognizedText,
      targetText: targetText,
      overallScore: overallScore,
      accuracyScore: overallScore,
      fluencyScore: 80.0, // 默认值
      prosodyScore: 75.0, // 默认值
      errors: [],
    );
  }

  /// 释放资源
  Future<void> dispose() async {
    await _statusController.close();
  }

  void _updateStatus(RecognitionStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
  }

  /// 模拟发音评分（基于规则）
  PronunciationScore _simulatePronunciationScoring(String targetText) {
    // 生成模拟分数
    final random = DateTime.now().millisecondsSinceEpoch % 30;
    final overallScore = 70.0 + random; // 70-100分

    return PronunciationScore(
      recordedText: targetText, // 假设识别正确
      targetText: targetText,
      overallScore: overallScore,
      accuracyScore: overallScore,
      fluencyScore: 75.0 + (random / 2),
      prosodyScore: 70.0 + (random / 3),
      errors: [],
    );
  }

  /// 计算文本相似度（Levenshtein距离）
  double _calculateTextSimilarity(String text1, String text2) {
    final distance = _levenshteinDistance(text1, text2);
    final maxLen = text1.length > text2.length ? text1.length : text2.length;
    if (maxLen == 0) return 1.0;
    return 1.0 - (distance / maxLen);
  }

  /// Levenshtein距离算法
  int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;

    final matrix = List.generate(
      len1 + 1,
      (i) => List.generate(len2 + 1, (j) => 0),
    );

    for (int i = 0; i <= len1; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= len2; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // 删除
          matrix[i][j - 1] + 1, // 插入
          matrix[i - 1][j - 1] + cost, // 替换
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[len1][len2];
  }
}

// 导入Color类（如果需要）
import 'package:flutter/painting.dart';
