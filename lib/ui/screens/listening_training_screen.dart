/// 听力训练页面
library;

import 'package:flutter/material.dart';
import '../../models/listening_material.dart';
import '../../data/listening_materials.dart';
import '../../services/listening_training_service.dart';

class ListeningTrainingScreen extends StatefulWidget {
  const ListeningTrainingScreen({super.key});

  @override
  State<ListeningTrainingScreen> createState() =>
      _ListeningTrainingScreenState();
}

class _ListeningTrainingScreenState extends State<ListeningTrainingScreen> {
  final ListeningTrainingService _service = ListeningTrainingService();

  ListeningLevel _selectedLevel = ListeningLevel.A1;
  ListeningMaterial? _selectedMaterial;
  List<ListeningMaterial> _filteredMaterials = [];

  // 播放状态
  bool _isPlaying = false;
  double _playbackPosition = 0.0;
  double _playbackSpeed = 1.0;

  // 练习状态
  Map<String, String> _userAnswers = {};
  bool _showTranscript = false;
  bool _hasCompleted = false;

  // 统计信息
  ListeningStatistics? _statistics;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _service.initialize();
    _updateMaterials();
    _statistics = await _service.getStatistics();
    setState(() {});
  }

  void _updateMaterials() {
    _filteredMaterials = getMaterialsByLevel(_selectedLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('听力训练'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatistics,
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：等级选择和材料列表
          SizedBox(
            width: 280,
            child: _buildSidebar(),
          ),
          // 右侧：主要内容
          Expanded(
            child: _selectedMaterial != null
                ? _buildMaterialContent()
                : _buildWelcomeScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // 等级选择
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选择等级',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: ListeningLevel.values.map((level) {
                    final isSelected = _selectedLevel == level;
                    return ChoiceChip(
                      label: Text(level.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedLevel = level;
                            _selectedMaterial = null;
                            _updateMaterials();
                          });
                        }
                      },
                      selectedColor: Colors.blue.shade600,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // 材料列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = _filteredMaterials[index];
                final isSelected = _selectedMaterial?.id == material.id;

                return ListTile(
                  leading: Icon(
                    _getMaterialTypeIcon(material.type),
                    color: Colors.blue.shade600,
                  ),
                  title: Text(
                    material.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${material.topic} · ${material.duration}秒',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.blue.shade50,
                  onTap: () {
                    setState(() {
                      _selectedMaterial = material;
                      _userAnswers.clear();
                      _showTranscript = false;
                      _hasCompleted = false;
                      _playbackPosition = 0.0;
                      _isPlaying = false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.headphones,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 24),
          Text(
            '请选择一个听力材料',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '共有 ${_filteredMaterials.length} 个材料',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialContent() {
    if (_selectedMaterial == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 材料标题
          _buildMaterialHeader(),

          const SizedBox(height: 24),

          // 音频播放器
          _buildAudioPlayer(),

          const SizedBox(height: 24),

          // 选项卡：题目/原文
          _buildTabBar(),

          const SizedBox(height: 16),

          // 内容区域
          if (_showTranscript)
            _buildTranscript()
          else
            _buildQuestions(),

          const SizedBox(height: 24),

          // 底部按钮
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildMaterialHeader() {
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
              Icon(
                _getMaterialTypeIcon(_selectedMaterial!.type),
                color: Colors.blue.shade700,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedMaterial!.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          label: Text(_selectedMaterial!.level.name),
                          backgroundColor: Colors.blue.shade600,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_selectedMaterial!.type.name),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedMaterial!.duration}秒',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _selectedMaterial!.topic,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // 进度条
          Slider(
            value: _playbackPosition,
            max: _selectedMaterial!.duration.toDouble(),
            onChanged: (value) {
              setState(() {
                _playbackPosition = value;
              });
            },
          ),
          // 时间显示
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_playbackPosition.toInt())),
                Text(_formatDuration(_selectedMaterial!.duration)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 播放控制
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  setState(() {
                    _playbackPosition = (_playbackPosition - 10).clamp(0, _selectedMaterial!.duration.toDouble());
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 48,
                color: Colors.blue.shade600,
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                  // TODO: 实际播放音频
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  setState(() {
                    _playbackPosition = (_playbackPosition + 10).clamp(0, _selectedMaterial!.duration.toDouble());
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 播放速度
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '速度: ',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              0.5,
              0.75,
              1.0,
              1.25,
              1.5
            ].map((speed) {
              final s = speed as double;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text('${s}x'),
                  selected: _playbackSpeed == s,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _playbackSpeed = s;
                      });
                      // TODO: 调整播放速度
                    }
                  },
                  selectedColor: Colors.blue.shade600,
                  labelStyle: TextStyle(
                    color: _playbackSpeed == s ? Colors.white : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTranscript = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showTranscript ? Colors.blue.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '题目',
                    style: TextStyle(
                      color: !_showTranscript ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTranscript = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showTranscript ? Colors.blue.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '原文',
                    style: TextStyle(
                      color: _showTranscript ? Colors.white : Colors.grey.shade700,
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

  Widget _buildTranscript() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedMaterial!.content,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
          if (_selectedMaterial!.vocabulary != null) ...[
            const SizedBox(height: 20),
            Text(
              '重点词汇',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedMaterial!.vocabulary!,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          if (_selectedMaterial!.culturalNote != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedMaterial!.culturalNote!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestions() {
    return Column(
      children: _selectedMaterial!.questions.asMap().entries.map((entry) {
        final index = entry.key;
        final question = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 题目编号和类型
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Chip(
                    label: Text(_getQuestionTypeLabel(question.type)),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 题目内容
              Text(
                question.question,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              // 答案区域
              if (question.type == QuestionType.multipleChoice &&
                  question.options != null)
                ...question.options!.map((option) {
                  final isSelected = _userAnswers[question.id] == option;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _userAnswers[question.id],
                      onChanged: (value) {
                        setState(() {
                          _userAnswers[question.id] = value!;
                        });
                      },
                      selected: isSelected,
                      activeColor: Colors.blue.shade600,
                    ),
                  );
                })
              else if (question.type == QuestionType.trueFalse)
                ...['Richtig', 'Falsch'].map((option) {
                  final isSelected = _userAnswers[question.id] == option;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _userAnswers[question.id],
                      onChanged: (value) {
                        setState(() {
                          _userAnswers[question.id] = value!;
                        });
                      },
                      selected: isSelected,
                      activeColor: Colors.blue.shade600,
                    ),
                  );
                })
              else if (question.type == QuestionType.fillInBlank)
                TextField(
                  decoration: InputDecoration(
                    hintText: '在此输入答案',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[question.id] = value;
                    });
                  },
                )
              else if (question.type == QuestionType.shortAnswer)
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '在此输入答案',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[question.id] = value;
                    });
                  },
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _submitAnswers,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('提交答案'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _userAnswers.clear();
                _hasCompleted = false;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('重置'),
          ),
        ),
      ],
    );
  }

  void _showStatistics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('听力统计'),
        content: _statistics != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatItem('总材料数', '${_statistics!.totalMaterials}'),
                  _buildStatItem('已完成', '${_statistics!.completedMaterials}'),
                  _buildStatItem('完成率',
                      '${(_statistics!.completionRate * 100).toStringAsFixed(1)}%'),
                  _buildStatItem('总听力时长',
                      '${_formatDuration(_statistics!.totalListeningTime)}'),
                  _buildStatItem('平均正确率',
                      '${(_statistics!.averageAccuracy * 100).toStringAsFixed(1)}%'),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMaterialTypeIcon(ListeningType type) {
    return switch (type) {
      ListeningType.dialogue => Icons.chat_bubble,
      ListeningType.monologue => Icons.person,
      ListeningType.announcement => Icons.campaign,
      ListeningType.interview => Icons.question_answer,
      ListeningType.lecture => Icons.school,
      ListeningType.news => Icons.newspaper,
    };
  }

  String _getQuestionTypeLabel(QuestionType type) {
    return switch (type) {
      QuestionType.multipleChoice => '选择题',
      QuestionType.trueFalse => '判断题',
      QuestionType.fillInBlank => '填空题',
      QuestionType.shortAnswer => '简答题',
    };
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _submitAnswers() async {
    if (_selectedMaterial == null) return;

    // 检查是否所有题目都已回答
    final unansweredQuestions = _selectedMaterial!.questions
        .where((q) => !_userAnswers.containsKey(q.id) || _userAnswers[q.id]!.isEmpty)
        .length;

    if (unansweredQuestions > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('还有 $unansweredQuestions 道题目未作答'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 提交答案
    try {
      final progress = await _service.submitAnswers(
        materialId: _selectedMaterial!.id,
        totalScore: _selectedMaterial!.questions.length,
        answers: _userAnswers,
      );

      setState(() {
        _hasCompleted = true;
      });

      // 显示结果
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('练习完成'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  '得分: ${progress.score}/${progress.totalScore}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '正确率: ${(progress.accuracy * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildResultItem('正确', progress.correctAnswers.length, Colors.green),
                _buildResultItem('错误', progress.wrongAnswers.length, Colors.red),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('查看解析'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _userAnswers.clear();
                    _hasCompleted = false;
                  });
                },
                child: const Text('重新练习'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('提交失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildResultItem(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
