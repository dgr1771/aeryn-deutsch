import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../core/oral_production_system.dart';
import '../../models/word.dart';
import 'dart:async';

/// 口语练习界面 - Oral Practice Screen
///
/// C2级别：5星流利度训练
/// 场景：学术、医疗、政治、冲突、日常、专业
class OralScreen extends StatefulWidget {
  const OralScreen({Key? key}) : super(key: key);

  @override
  State<OralScreen> createState() => _OralScreenState();
}

class _OralScreenState extends State<OralScreen> {
  final OralProductionSystem _oralSystem = OralProductionSystem();

  ScenarioType _selectedScenario = ScenarioType.academic;
  CEFRLevel _userLevel = CEFRLevel.B2;
  OralTask? _currentTask;
  bool _isRecording = false;
  bool _isProcessing = false;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  OralEvaluation? _evaluation;

  @override
  void initState() {
    super.initState();
    _generateTask();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _generateTask() {
    setState(() {
      _currentTask = _oralSystem.generateC2Task(
        scenarioType: _selectedScenario,
      );
      _evaluation = null;
    });
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });

      // 自动停止（达到时间限制）
      if (_currentTask != null && _recordingSeconds >= _currentTask!.targetLengthMinutes * 60) {
        _stopRecording();
      }
    });
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();

    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });

    // TODO: 实际录音和评估
    // 这里使用模拟数据
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _evaluation = OralEvaluation(
        taskId: _currentTask!.id,
        userTranscript: '这是模拟的语音识别结果...',
        targetTranscript: '目标文本...',
        overallScore: 85.0,
        starRating: 5,
        pronunciationScore: 88.0,
        grammarScore: 82.0,
        vocabularyScore: 86.0,
        fluencyScore: 83.0,
        contentScore: 87.0,
        feedback: 'Sehr gut! Ihre mündliche Ausdrucksfähigkeit ist auf einem hohen Niveau.',
        improvements: [
          'Verwenden Sie mehr Konnektoren',
          'Achten Sie auf die Verbstellung',
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _currentTask == null
          ? _buildLoadingState()
          : _buildTaskContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Oral Practice'),
      backgroundColor: GrammarEngine.genderColors['die'],
      elevation: 0,
      actions: [
        PopupMenuButton<CEFRLevel>(
          icon: const Icon(Icons.school),
          onSelected: (level) {
            setState(() => _userLevel = level);
          },
          itemBuilder: (context) => CEFRLevel.values.map((level) {
            return PopupMenuItem(
              value: level,
              child: Text('级别: ${level.toString().split('.').last}'),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTaskContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 场景选择器
          _buildScenarioSelector(),

          const SizedBox(height: 20),

          // 任务卡片
          _buildTaskCard(),

          const SizedBox(height: 20),

          // 词汇和语法重点
          _buildKeyPoints(),

          const SizedBox(height: 20),

          // 录音控制
          _buildRecordingControls(),

          if (_evaluation != null) ...[
            const SizedBox(height: 20),
            _buildEvaluationResult(),
          ],
        ],
      ),
    );
  }

  Widget _buildScenarioSelector() {
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
            '选择场景',
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
            children: ScenarioType.values.map((type) {
              final isSelected = type == _selectedScenario;
              final scenarioInfo = _getScenarioInfo(type);

              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(scenarioInfo['icon'] as IconData, size: 16),
                    const SizedBox(width: 4),
                    Text(scenarioInfo['label'] as String),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedScenario = type;
                      _generateTask();
                    });
                  }
                },
                selectedColor: scenarioInfo['color'] as Color,
                backgroundColor: (scenarioInfo['color'] as Color).withOpacity(0.1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getScenarioInfo(ScenarioType type) {
    switch (type) {
      case ScenarioType.academic:
        return {
          'label': '学术讨论',
          'icon': Icons.school,
          'color': GrammarEngine.genderColors['der']!,
        };
      case ScenarioType.medical:
        return {
          'label': '医疗场景',
          'icon': Icons.local_hospital,
          'color': GrammarEngine.genderColors['die']!,
        };
      case ScenarioType.political:
        return {
          'label': '政治讨论',
          'icon': Icons.how_to_vote,
          'color': GrammarEngine.genderColors['das']!,
        };
      case ScenarioType.conflict:
        return {
          'label': '冲突解决',
          'icon': Icons.gavel,
          'color': Colors.orange,
        };
      case ScenarioType.casual:
        return {
          'label': '日常闲聊',
          'icon': Icons.coffee,
          'color': Colors.brown,
        };
      case ScenarioType.professional:
        return {
          'label': '专业场景',
          'icon': Icons.work,
          'color': Colors.deepPurple,
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
              (_getScenarioInfo(_selectedScenario)['color'] as Color).withOpacity(0.1),
              (_getScenarioInfo(_selectedScenario)['color'] as Color).withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和难度
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
                      _currentTask!.level.toString().split('.').last,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 描述
              Text(
                _currentTask!.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 16),

              // 时间限制
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 20,
                    color: GrammarEngine.genderColors['die'],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '目标时长: ${_currentTask!.targetLengthMinutes} 分钟',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 展开/折叠上下文
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Text(
                    '任务详情',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: GrammarEngine.genderColors['der'],
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _currentTask!.context,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),

              if (_currentTask!.targetSample != null) ...[
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      '参考表达',
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
                          _currentTask!.targetSample!,
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

  Widget _buildKeyPoints() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '重点词汇',
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
              children: _currentTask!.keyVocabulary.take(10).map((word) {
                return Chip(
                  label: Text(word),
                  backgroundColor: GrammarEngine.genderColors['die']!.withOpacity(0.1),
                  side: BorderSide(
                    color: GrammarEngine.genderColors['die']!.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              '语法重点',
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
              children: _currentTask!.grammarFocus.map((point) {
                return Chip(
                  label: Text(point),
                  backgroundColor: GrammarEngine.genderColors['das']!.withOpacity(0.1),
                  side: BorderSide(
                    color: GrammarEngine.genderColors['das']!.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingControls() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 录音状态
            if (_isRecording) ...[
              Text(
                '录音中...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GrammarEngine.genderColors['die'],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${_recordingSeconds ~/ 60}:${(_recordingSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: GrammarEngine.genderColors['die'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '/ ${_currentTask!.targetLengthMinutes}:${'00'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ] else if (_isProcessing) ...[
              const SizedBox(height: 20),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              Text(
                'AI正在分析您的发音...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ] else ...[
              Text(
                '准备好开始了吗？',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '点击下方按钮开始录音，完成后AI将评估您的表现',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 24),

            // 录音按钮
            GestureDetector(
              onTap: _isProcessing ? null : _toggleRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isRecording
                        ? [
                            GrammarEngine.genderColors['die']!,
                            GrammarEngine.genderColors['der']!,
                          ]
                        : [
                            (_getScenarioInfo(_selectedScenario)['color'] as Color),
                            (_getScenarioInfo(_selectedScenario)['color'] as Color).withOpacity(0.7),
                          ],
                  ),
                  boxShadow: [
                    if (_isRecording)
                      BoxShadow(
                        color: GrammarEngine.genderColors['die']!.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    BoxShadow(
                      color: (_getScenarioInfo(_selectedScenario)['color'] as Color).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),

            if (!_isRecording && !_isProcessing) ...[
              const SizedBox(height: 16),
              Text(
                '点击录音',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationResult() {
    final score = _evaluation!.overallScore;
    final stars = _evaluation!.starRating;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '评估结果',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GrammarEngine.genderColors['der'],
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < stars ? Icons.star : Icons.star_border,
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
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score),
                      ),
                    ),
                    Text(
                      '总分',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 分项评分
              _buildScoreItem('发音', _evaluation!.pronunciationScore),
              _buildScoreItem('语法', _evaluation!.grammarScore),
              _buildScoreItem('词汇', _evaluation!.vocabularyScore),
              _buildScoreItem('流利度', _evaluation!.fluencyScore),
              _buildScoreItem('内容', _evaluation!.contentScore),

              const SizedBox(height: 24),

              // 反馈
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GrammarEngine.genderColors['das']!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: GrammarEngine.genderColors['das'],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI 反馈',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: GrammarEngine.genderColors['das'],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_evaluation!.feedback),
                  ],
                ),
              ),

              if (_evaluation!.improvements.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GrammarEngine.genderColors['die']!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: GrammarEngine.genderColors['die'],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '改进建议',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: GrammarEngine.genderColors['die'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._evaluation!.improvements.map((suggestion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  color: GrammarEngine.genderColors['die'],
                                ),
                              ),
                              Expanded(child: Text(suggestion)),
                            ],
                          ),
                        );
                      }).toList(),
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

  Widget _buildScoreItem(String label, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: score / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getScoreColor(score),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              score.toStringAsFixed(0),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return GrammarEngine.genderColors['das']!;
    if (score >= 80) return GrammarEngine.genderColors['der']!;
    if (score >= 70) return GrammarEngine.genderColors['die']!;
    return Colors.orange;
  }
}
