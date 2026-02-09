/// 个性化学习路径页面
library;

import 'package:flutter/material.dart';
import '../../models/personalized_learning.dart';
import '../../services/personalized_learning_service.dart';

class PersonalizedLearningScreen extends StatefulWidget {
  const PersonalizedLearningScreen({super.key});

  @override
  State<PersonalizedLearningScreen> createState() =>
      _PersonalizedLearningScreenState();
}

class _PersonalizedLearningScreenState extends State<PersonalizedLearningScreen> {
  final PersonalizedLearningService _service = PersonalizedLearningService();

  LearningPath? _currentPath;
  LearningDiagnosis? _diagnosis;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _service.initialize();
      final path = _service.getCurrentPath();
      final diagnosis = await _service.generateDiagnosis();

      setState(() {
        _currentPath = path;
        _diagnosis = diagnosis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个性化学习路径'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 诊断和推荐
                  if (_diagnosis != null) _buildDiagnosis(),

                  const SizedBox(height: 24),

                  // 当前学习路径
                  _buildCurrentPath(),

                  const SizedBox(height: 24),

                  // 创建新路径
                  _buildCreatePath(),
                ],
              ),
            ),
    );
  }

  Widget _buildDiagnosis() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.blue.shade700, size: 32),
              const SizedBox(width: 12),
              Text(
                '学习诊断',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 技能水平
          Text(
            '技能水平',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          ...(_diagnosis!.skillLevels.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text('${(entry.value * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      entry.value >= 0.7
                          ? Colors.green
                          : entry.value >= 0.4
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          })),

          if (_diagnosis!.weakPoints.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              '需要加强的技能',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _diagnosis!.weakPoints.map((weakPoint) {
                return Chip(
                  label: Text(weakPoint),
                  backgroundColor: Colors.orange.shade100,
                  avatar: const Icon(Icons.warning, size: 16),
                );
              }).toList(),
            ),
          ],

          if (_diagnosis!.recommendations.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              '学习推荐',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            ...(_diagnosis!.recommendations.take(3).map((rec) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(_getResourceIcon(rec.resourceType)),
                title: Text(rec.title),
                subtitle: Text(rec.reason),
                trailing: Text('${rec.estimatedMinutes} 分钟'),
              ),
            ))),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentPath() {
    if (_currentPath == null) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.route, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                '还没有学习路径',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '根据你的学习情况创建个性化路径',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPath!.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_currentPath!.description),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_currentPath!.completionPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Text('完成度'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 进度条
          LinearProgressIndicator(
            value: _currentPath!.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
          const SizedBox(height: 20),

          // 统计信息
          Row(
            children: [
              _buildStatItem(
                '预计天数',
                '${_currentPath!.estimatedDays}',
                Icons.calendar_today,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                '已完成',
                '${_currentPath!.completedPhases}/${_currentPath!.phases.length}',
                Icons.check_circle,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                '总时长',
                '${(_currentPath!.totalEstimatedMinutes / 60).toStringAsFixed(0)} 小时',
                Icons.access_time,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 学习阶段
          Text(
            '学习阶段',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          ...(_currentPath!.phases.map((phase) => _buildPhaseCard(phase))),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(LearningPhase phase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: phase.isCompleted
              ? Colors.green
              : phase.isLocked
                  ? Colors.grey
                  : Colors.blue,
          child: Icon(
            phase.isCompleted
                ? Icons.check
                : phase.isLocked
                    ? Icons.lock
                    : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        title: Text(
          phase.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: phase.isLocked ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phase.description),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: phase.completionRate,
              backgroundColor: Colors.grey.shade200,
            ),
            Text(
              '${(phase.completionRate * 100).toStringAsFixed(0)}% · ${phase.steps.length} 个步骤',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        children: [
          ...phase.steps.map((step) => _buildStepTile(phase, step)),
        ],
      ),
    );
  }

  Widget _buildStepTile(LearningPhase phase, LearningStep step) {
    return ListTile(
      leading: Icon(
        _getResourceIcon(step.resourceType),
        color: step.isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(
        step.title,
        style: TextStyle(
          decoration: step.isCompleted ? TextDecoration.lineThrough : null,
          color: step.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text('${step.description} · ${step.estimatedMinutes} 分钟'),
      trailing: step.isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : step.score != null
              ? Text('${step.score!.toStringAsFixed(1)} 分')
              : null,
      onTap: () {
        if (!step.isCompleted && !phase.isLocked) {
          _showStepDialog(step);
        }
      },
    );
  }

  Widget _buildCreatePath() {
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
            '创建新的学习路径',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: LearningGoalType.values.map((goalType) {
              return ElevatedButton.icon(
                onPressed: () => _showCreatePathDialog(goalType),
                icon: Icon(_getGoalIcon(goalType)),
                label: Text(_getGoalTypeName(goalType)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.blue.shade600),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _showCreatePathDialog(LearningGoalType goalType) {
    DifficultyLevel selectedDifficulty = DifficultyLevel.beginner;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('创建${_getGoalTypeName(goalType)}路径'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '选择难度级别',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              ...DifficultyLevel.values.map((difficulty) {
                return RadioListTile<DifficultyLevel>(
                  title: Text(_getDifficultyName(difficulty)),
                  value: difficulty,
                  groupValue: selectedDifficulty,
                  onChanged: (value) {
                    setDialogState(() {
                      selectedDifficulty = value!;
                    });
                  },
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // 创建路径
                try {
                  final path = await _service.generatePersonalizedPath(
                    goalType: goalType,
                    difficulty: selectedDifficulty,
                  );

                  await _service.setCurrentPath(path);

                  setState(() {
                    _currentPath = path;
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('学习路径已创建'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('创建失败: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('创建'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStepDialog(LearningStep step) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(step.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${step.estimatedMinutes} 分钟'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 跳转到对应的学习资源
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('开始学习: ${step.title}')),
              );
            },
            child: const Text('开始学习'),
          ),
        ],
      ),
    );
  }

  IconData _getResourceIcon(ResourceType type) {
    return switch (type) {
      ResourceType.vocabulary => Icons.menu_book,
      ResourceType.grammar => Icons.school,
      ResourceType.reading => Icons.article,
      ResourceType.listening => Icons.headphones,
      ResourceType.writing => Icons.edit,
      ResourceType.speaking => Icons.mic,
      ResourceType.test => Icons.quiz,
      ResourceType.video => Icons.play_circle,
      ResourceType.article => Icons.description,
    };
  }

  IconData _getGoalIcon(LearningGoalType type) {
    return switch (type) {
      LearningGoalType.vocabulary => Icons.menu_book,
      LearningGoalType.grammar => Icons.school,
      LearningGoalType.communication => Icons.chat,
      LearningGoalType.examPreparation => Icons.assignment,
      LearningGoalType.skillImprovement => Icons.trending_up,
    };
  }

  String _getGoalTypeName(LearningGoalType type) {
    return switch (type) {
      LearningGoalType.vocabulary => '词汇提升',
      LearningGoalType.grammar => '语法精通',
      LearningGoalType.communication => '交际能力',
      LearningGoalType.examPreparation => '考试准备',
      LearningGoalType.skillImprovement => '技能提升',
    };
  }

  String _getDifficultyName(DifficultyLevel level) {
    return switch (level) {
      DifficultyLevel.beginner => '初级',
      DifficultyLevel.intermediate => '中级',
      DifficultyLevel.advanced => '高级',
    };
  }
}
