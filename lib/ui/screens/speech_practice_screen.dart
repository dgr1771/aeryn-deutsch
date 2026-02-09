/// 语音识别练习页面
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/speech_recognition_service.dart';

class SpeechPracticeScreen extends StatefulWidget {
  const SpeechPracticeScreen({super.key});

  @override
  State<SpeechPracticeScreen> createState() => _SpeechPracticeScreenState();
}

class _SpeechPracticeScreenState extends State<SpeechPracticeScreen> {
  final SpeechRecognitionService _speechService =
      SpeechRecognitionService.instance;
  final TextEditingController _targetTextController = TextEditingController(
    text: 'Guten Tag',
  );

  RecognitionStatus _status = RecognitionStatus.idle;
  PronunciationScore? _lastScore;

  @override
  void initState() {
    super.initState();
    _speechService.statusStream.listen((status) {
      setState(() {
        _status = status;
      });
    });
  }

  @override
  void dispose() {
    _targetTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语音练习'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明卡片
            _buildInfoCard(),

            const SizedBox(height: 24),

            // 目标文本输入
            _buildTargetTextInput(),

            const SizedBox(height: 24),

            // 录音按钮
            _buildRecordButton(),

            const SizedBox(height: 24),

            // 状态显示
            _buildStatusIndicator(),

            const SizedBox(height: 24),

            // 评分结果
            if (_lastScore != null) _buildScoreCard(_lastScore!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mic, color: Colors.blue.shade700, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '语音识别与发音评分',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '点击麦克风按钮开始录音，再次点击结束。系统将识别您的发音并给出评分。',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '目标文本',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _targetTextController,
          decoration: InputDecoration(
            hintText: '输入要练习的德语文本',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildExampleChip('Guten Tag'),
            _buildExampleChip('Wie geht es Ihnen?'),
            _buildExampleChip('Ich lerne Deutsch'),
            _buildExampleChip('Entschuldigung'),
          ],
        ),
      ],
    );
  }

  Widget _buildExampleChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _targetTextController.text = text;
        setState(() {});
      },
      backgroundColor: Colors.blue.shade50,
      labelStyle: TextStyle(
        color: Colors.blue.shade700,
        fontSize: 12,
      ),
    );
  }

  Widget _buildRecordButton() {
    return Center(
      child: GestureDetector(
        onTap: () => _toggleRecording(),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getRecordButtonColor(),
            boxShadow: [
              BoxShadow(
                color: _getRecordButtonColor().withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Icon(
            _getRecordButtonIcon(),
            size: 48,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    String statusText;
    Color statusColor;

    switch (_status) {
      case RecognitionStatus.idle:
        statusText = '准备就绪';
        statusColor = Colors.grey;
        break;
      case RecognitionStatus.listening:
        statusText = '正在录音...';
        statusColor = Colors.red;
        break;
      case RecognitionStatus.processing:
        statusText = '正在处理...';
        statusColor = Colors.orange;
        break;
      case RecognitionStatus.completed:
        statusText = '完成';
        statusColor = Colors.green;
        break;
      case RecognitionStatus.error:
        statusText = '出错了';
        statusColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(PronunciationScore score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: score.gradeColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: score.gradeColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: score.gradeColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '评分结果',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${score.overallScore.toStringAsFixed(0)}分 - ${score.grade}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: score.gradeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildScoreBar('准确度', score.accuracyScore),
          const SizedBox(height: 12),
          _buildScoreBar('流利度', score.fluencyScore),
          const SizedBox(height: 12),
          _buildScoreBar('韵律', score.prosodyScore),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '目标文本:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      score.targetText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '${score.toStringAsFixed(0)}分',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: score / 100,
            child: Container(
              decoration: BoxDecoration(
                color: _getScoreColor(score),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRecordButtonColor() {
    switch (_status) {
      case RecognitionStatus.listening:
        return Colors.red;
      case RecognitionStatus.processing:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getRecordButtonIcon() {
    switch (_status) {
      case RecognitionStatus.listening:
        return Icons.stop;
      case RecognitionStatus.processing:
        return Icons.hourglass_empty;
      default:
        return Icons.mic;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.blue;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Future<void> _toggleRecording() async {
    if (_status == RecognitionStatus.listening) {
      await _speechService.stopListening();
      _simulateScoring();
    } else {
      try {
        await _speechService.startListening();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('无法开始录音: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _simulateScoring() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final targetText = _targetTextController.text.trim();
    if (targetText.isEmpty) {
      return;
    }

    // 模拟评分结果
    final score = await _speechService.scorePronunciationByText(
      targetText: targetText,
      recognizedText: targetText, // 假设识别正确
    );

    setState(() {
      _lastScore = score;
    });
  }
}
