/// 写作练习页面
library;

import 'package:flutter/material.dart';
import '../../models/writing_practice.dart';
import '../../data/writing_tasks.dart';
import '../../services/writing_correction_service.dart';

class WritingPracticeScreen extends StatefulWidget {
  const WritingPracticeScreen({super.key});

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  final WritingCorrectionService _service = WritingCorrectionService();
  final TextEditingController _textController = TextEditingController();

  WritingLevel _selectedLevel = WritingLevel.A1;
  WritingTask? _selectedTask;
  List<WritingTask> _filteredTasks = [];

  WritingEvaluation? _evaluation;
  bool _isEvaluating = false;
  bool _showHints = true;
  int _timeSpentSeconds = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _updateTasks();
    _service.initialize();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateTasks() {
    _filteredTasks = getTasksByLevel(_selectedLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('写作练习'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistory,
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：等级选择和任务列表
          SizedBox(
            width: 320,
            child: _buildSidebar(),
          ),
          // 右侧：主要内容
          Expanded(
            child: _selectedTask != null
                ? _buildTaskContent()
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
                  children: WritingLevel.values.map((level) {
                    final isSelected = _selectedLevel == level;
                    return ChoiceChip(
                      label: Text(level.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedLevel = level;
                            _selectedTask = null;
                            _updateTasks();
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
          // 任务列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                final isSelected = _selectedTask?.id == task.id;

                return ListTile(
                  leading: Icon(
                    _getTaskTypeIcon(task.type),
                    color: Colors.blue.shade600,
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${task.type.name} · ${task.minWords}-${task.maxWords ?? '∞'} 词',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${task.suggestedMinutes} 分钟',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.blue.shade50,
                  onTap: () {
                    setState(() {
                      _selectedTask = task;
                      _evaluation = null;
                      _textController.clear();
                      _timeSpentSeconds = 0;
                      _startTime = DateTime.now();
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
            Icons.edit_note,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 24),
          Text(
            '请选择一个写作任务',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '共有 ${_filteredTasks.length} 个任务',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskContent() {
    if (_selectedTask == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 任务信息
          _buildTaskHeader(),

          const SizedBox(height: 24),

          // 提示和工具
          _buildHintsAndTools(),

          const SizedBox(height: 24),

          // 写作区域
          _buildWritingArea(),

          const SizedBox(height: 24),

          // 评估结果
          if (_evaluation != null) _buildEvaluationResults(),

          const SizedBox(height: 24),

          // 提交按钮
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTaskHeader() {
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
                _getTaskTypeIcon(_selectedTask!.type),
                color: Colors.blue.shade700,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTask!.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(_selectedTask!.level.name),
                          backgroundColor: Colors.blue.shade600,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        Chip(
                          label: Text(_selectedTask!.type.name),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        Chip(
                          label: Text('${_selectedTask!.minWords}-${_selectedTask!.maxWords ?? "∞"} 词'),
                          backgroundColor: Colors.orange.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_selectedTask!.context != null) ...[
            const SizedBox(height: 12),
            Text(
              _selectedTask!.context!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            _selectedTask!.prompt,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintsAndTools() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text(
                '提示和工具',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              IconButton(
                icon: Icon(_showHints ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _showHints = !_showHints;
                  });
                },
              ),
            ],
          ),
          if (_showHints) ...[
            const SizedBox(height: 16),
            if (_selectedTask!.keyPoints != null) ...[
              Text(
                '要点提示',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...(_selectedTask!.keyPoints!.map((point) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: Colors.blue.shade600)),
                    Expanded(child: Text(point)),
                  ],
                ),
              ))),
              const SizedBox(height: 12),
            ],
            if (_selectedTask!.usefulVocabulary != null) ...[
              Text(
                '有用词汇',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (_selectedTask!.usefulVocabulary!.map((vocab) {
                  final parts = vocab.split(' - ');
                  return Chip(
                    label: Text(parts[0]),
                    backgroundColor: Colors.green.shade50,
                    tooltip: parts.length > 1 ? parts[1] : '',
                  );
                }).toList()),
              ),
              const SizedBox(height: 12),
            ],
            if (_selectedTask!.usefulPhrases != null) ...[
              Text(
                '有用句型',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...(_selectedTask!.usefulPhrases!.map((phrase) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.format_quote, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Expanded(child: Text(phrase)),
                  ],
                ),
              ))),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildWritingArea() {
    final wordCount = _textController.text.split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 工具栏
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '写作区域',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '字数: $wordCount',
                      style: TextStyle(
                        color: wordCount >= (_selectedTask?.minWords ?? 0)
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedTask?.maxWords != null) ...[
                      Text(' / ${_selectedTask!.maxWords}', style: TextStyle(
                        color: Colors.grey.shade600,
                      )),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // 文本输入框
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _textController,
              maxLines: 20,
              decoration: const InputDecoration(
                hintText: '在此开始写作...',
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationResults() {
    if (_evaluation == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总分
          Row(
            children: [
              Icon(
                Icons.grade,
                color: Colors.amber,
                size: 40,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '得分',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${_evaluation!.totalScore.toStringAsFixed(1)} / ${_evaluation!.maxScore.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildScoreProgressBar(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 评分维度
          Text(
            '评分维度',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          ...(_evaluation!.dimensions.map((dim) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDimensionCard(dim),
          ))),

          if (_evaluation!.errors.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              '发现 ${_evaluation!.errorCount} 处错误',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildErrorsList(),
          ],

          if (_evaluation!.generalFeedback != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        '总体反馈',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_evaluation!.generalFeedback!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreProgressBar() {
    final percentage = _evaluation!.percentage;
    final color = percentage >= 80
        ? Colors.green
        : percentage >= 60
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildDimensionCard(ScoringDimension dimension) {
    final percentage = dimension.percentage;
    final color = percentage >= 80
        ? Colors.green
        : percentage >= 60
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dimension.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                '${dimension.score.toStringAsFixed(1)}/${dimension.maxScore.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: dimension.score / dimension.maxScore,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          if (dimension.feedback != null) ...[
            const SizedBox(height: 8),
            Text(
              dimension.feedback!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _evaluation!.errors.length,
        itemBuilder: (context, index) {
          final error = _evaluation!.errors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: Icon(
                _getErrorIcon(error.type),
                color: _getErrorColor(error.severity),
              ),
              title: Text(
                error.message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '${error.originalText} → ${error.correctedText}',
                style: TextStyle(fontSize: 13),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (error.rule != null) ...[
                        Text(
                          '规则: ${error.rule}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (error.suggestions != null && error.suggestions!.isNotEmpty) ...[
                        Text(
                          '建议: ${error.suggestions!.join(", ")}',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isEvaluating ? null : _evaluateWriting,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isEvaluating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('提交批改'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _textController.clear();
                _evaluation = null;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('清空'),
          ),
        ),
      ],
    );
  }

  Future<void> _evaluateWriting() async {
    if (_selectedTask == null) return;

    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先输入文本'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isEvaluating = true;
    });

    try {
      final evaluation = await _service.evaluateWriting(
        taskId: _selectedTask!.id,
        userText: text,
      );

      // 保存练习记录
      final practice = WritingPractice(
        taskId: _selectedTask!.id,
        userText: text,
        evaluation: evaluation,
        startedAt: _startTime ?? DateTime.now(),
        completedAt: DateTime.now(),
        timeSpentSeconds: _timeSpentSeconds,
      );
      await _service.savePractice(practice);

      setState(() {
        _evaluation = evaluation;
        _isEvaluating = false;
      });
    } catch (e) {
      setState(() {
        _isEvaluating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('批改失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('写作历史'),
        content: FutureBuilder<List<WritingPractice>>(
          future: Future.value(_service.getPracticeHistory()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final history = snapshot.data!;

            if (history.isEmpty) {
              return const Center(child: Text('暂无写作记录'));
            }

            return SizedBox(
              width: 500,
              height: 400,
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final practice = history[index];
                  return ListTile(
                    title: Text('任务 ${practice.taskId}'),
                    subtitle: Text(
                      '${practice.startedAt.toString().substring(0, 16)} · '
                      '${practice.userText.length} 字',
                    ),
                    trailing: practice.evaluation != null
                        ? Text(
                            '${practice.evaluation!.totalScore.toStringAsFixed(1)} 分',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade600,
                            ),
                          )
                        : const Text('未批改'),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  IconData _getTaskTypeIcon(WritingTaskType type) {
    return switch (type) {
      WritingTaskType.email => Icons.email,
      WritingTaskType.essay => Icons.description,
      WritingTaskType.letter => Icons.mail,
      WritingTaskType.report => Icons.assessment,
      WritingTaskType.summary => Icons.summarize,
      WritingTaskType.argumentation => Icons_forum,
      WritingTaskType.description => Icons.subject,
    };
  }

  IconData _getErrorIcon(ErrorType type) {
    return switch (type) {
      ErrorType.grammar => Icons.spellcheck,
      ErrorType.spelling => Icons.g_mobiledata,
      ErrorType.punctuation => Icons.text_fields,
      ErrorType.vocabulary => Icons.menu_book,
      ErrorType.style => Icons.brush,
      ErrorType.coherence => Icons.link,
    };
  }

  Color _getErrorColor(ErrorSeverity severity) {
    return switch (severity) {
      ErrorSeverity.minor => Colors.orange,
      ErrorSeverity.moderate => Colors.amber,
      ErrorSeverity.serious => Colors.red,
    };
  }
}
