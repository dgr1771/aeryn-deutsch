import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../core/writing_training_system.dart';
import '../../api/ai_service.dart';
import '../../main.dart' show AppConfig;
import 'dart:async';

/// 写作练习界面 - Writing Practice Screen
///
/// 功能：
/// - 5种写作类型
/// - AI智能批改
/// - 语法错误标注
/// - 词汇升级建议
class WritingScreen extends StatefulWidget {
  const WritingScreen({Key? key}) : super(key: key);

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final WritingTrainingSystem _writingSystem = WritingTrainingSystem(
    aiService: AIService(apiKey: AppConfig.deepSeekApiKey),
  );

  WritingType _selectedType = WritingType.email;
  LanguageLevel _userLevel = LanguageLevel.B2;
  WritingTask? _currentTask;
  TextEditingController _textController = TextEditingController();
  bool _isSubmitting = false;
  WritingEvaluation? _evaluation;

  @override
  void initState() {
    super.initState();
    _generateTask();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateTask() {
    setState(() {
      _currentTask = _writingSystem.generateTask(
        type: _selectedType,
        level: _userLevel,
      );
      _textController.clear();
      _evaluation = null;
    });
  }

  Future<void> _submitText() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入文本')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final evaluation = await _writingSystem.evaluateText(
        task: _currentTask!,
        userText: _textController.text,
      );

      setState(() {
        _evaluation = evaluation;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('提交失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _currentTask == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Writing Lab'),
      backgroundColor: GrammarEngine.genderColors['das'],
      elevation: 0,
      actions: [
        PopupMenuButton<LanguageLevel>(
          icon: const Icon(Icons.school),
          onSelected: (level) {
            setState(() => _userLevel = level as LanguageLevel);
          },
          itemBuilder: (context) => LanguageLevel.values.map((level) {
            return PopupMenuItem(
              value: level,
              child: Text('级别: ${level.toString().split('.').last}'),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 类型选择器
          _buildTypeSelector(),

          const SizedBox(height: 20),

          // 任务卡片
          _buildTaskCard(),

          const SizedBox(height: 20),

          // 写作区域
          _buildWritingArea(),

          if (_evaluation != null) ...[
            const SizedBox(height: 20),
            _buildEvaluationResult(),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '写作类型',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GrammarEngine.genderColors['der'],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: WritingType.values.map((type) {
              final isSelected = type == _selectedType;
              final typeInfo = _getTypeInfo(type);

              return FilterChip(
                label: Text(typeInfo['label'] as String),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedType = type;
                      _generateTask();
                    });
                  }
                },
                selectedColor: typeInfo['color'] as Color,
                backgroundColor: (typeInfo['color'] as Color).withOpacity(0.1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getTypeInfo(WritingType type) {
    switch (type) {
      case WritingType.email:
        return {
          'label': '邮件',
          'color': GrammarEngine.genderColors['der']!,
        };
      case WritingType.description:
        return {
          'label': '描述',
          'color': GrammarEngine.genderColors['die']!,
        };
      case WritingType.argumentation:
        return {
          'label': '论证',
          'color': GrammarEngine.genderColors['das']!,
        };
      case WritingType.academic:
        return {
          'label': '学术',
          'color': Colors.deepPurple,
        };
      case WritingType.creative:
        return {
          'label': '创意',
          'color': Colors.orange,
        };
    }
  }

  Widget _buildTaskCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (_getTypeInfo(_selectedType)['color'] as Color).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和要求
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _currentTask!.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: GrammarEngine.genderColors['das'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentTask!.targetLength} 词',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                _currentTask!.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              // 关键要素
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '关键要素',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: GrammarEngine.genderColors['der'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._currentTask!.keyElements.map((element) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Text('• '),
                            Expanded(child: Text(element)),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              if (_currentTask!.sampleStructure != null) ...[
                const SizedBox(height: 16),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      '结构参考',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: GrammarEngine.genderColors['die'],
                      ),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentTask!.sampleStructure!,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWritingArea() {
    final currentLength = _textController.text.split(' ').where((s) => s.isNotEmpty).length;
    final targetLength = _currentTask!.targetLength;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '你的写作',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GrammarEngine.genderColors['der'],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentLength >= targetLength
                        ? GrammarEngine.genderColors['das']
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$currentLength / $targetLength',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 文本输入框
            TextField(
              controller: _textController,
              maxLines: 15,
              maxLength: targetLength * 2,
              decoration: InputDecoration(
                hintText: '在这里开始写作...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: GrammarEngine.genderColors['das']!,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GrammarEngine.genderColors['das'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('提交批改'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationResult() {
    final score = _evaluation!.overallScore;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getScoreColor(score).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 总分和星级
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AI 批改结果',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GrammarEngine.genderColors['der'],
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < _evaluation!.stars ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 24,
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 总分
              Center(
                child: Column(
                  children: [
                    Text(
                      score.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score),
                      ),
                    ),
                    Text(
                      '总分',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // 优点和改进
              if (_evaluation!.strengths.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildFeedbackSection('优点', _evaluation!.strengths, Icons.check_circle, GrammarEngine.genderColors['das']!),
              ],

              if (_evaluation!.weaknesses.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildFeedbackSection('待改进', _evaluation!.weaknesses, Icons.warning, Colors.orange),
              ],

              if (_evaluation!.grammarErrors.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildGrammarErrors(),
              ],

              if (_evaluation!.vocabularyImprovements.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildVocabularyImprovements(),
              ],

              if (_evaluation!.nextSteps.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildNextSteps(),
              ],

              if (_evaluation!.sampleSolution != null) ...[
                const SizedBox(height: 20),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      '参考范文',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: GrammarEngine.genderColors['die'],
                      ),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _evaluation!.sampleSolution!,
                          style: const TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // 重新写作按钮
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _evaluation = null;
                      _textController.clear();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新写作'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: GrammarEngine.genderColors['das'],
                    side: BorderSide(color: GrammarEngine.genderColors['das']!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(String title, List<String> items, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color)),
                  Expanded(child: Text(item)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGrammarErrors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.spellcheck,
              color: GrammarEngine.genderColors['die'],
            ),
            const SizedBox(width: 8),
            Text(
              '语法错误 (${_evaluation!.grammarErrors.length})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: GrammarEngine.genderColors['die'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._evaluation!.grammarErrors.take(5).map((error) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        error.original,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 16),
                    Expanded(
                      child: Text(
                        error.correction,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  error.explanation,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildVocabularyImprovements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: GrammarEngine.genderColors['der'],
            ),
            const SizedBox(width: 8),
            Text(
              '词汇升级建议',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: GrammarEngine.genderColors['der'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._evaluation!.vocabularyImprovements.take(5).map((improvement) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GrammarEngine.genderColors['der']!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    improvement.original,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 16),
                Expanded(
                  child: Text(
                    improvement.suggestion,
                    style: TextStyle(
                      color: GrammarEngine.genderColors['der'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNextSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_run,
              color: GrammarEngine.genderColors['das'],
            ),
            const SizedBox(width: 8),
            Text(
              '下一步建议',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: GrammarEngine.genderColors['das'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._evaluation!.nextSteps.map((step) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: GrammarEngine.genderColors['das'])),
                Expanded(child: Text(step)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return GrammarEngine.genderColors['das']!;
    if (score >= 80) return GrammarEngine.genderColors['der']!;
    if (score >= 70) return GrammarEngine.genderColors['die']!;
    return Colors.orange;
  }
}
