import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../core/grammar_exercise_engine.dart';
import 'dart:async';

/// 语法练习界面 - Grammar Practice Screen
///
/// 功能：
/// - 3000+道分级练习题
/// - 8种语法类型
/// - 即时反馈
/// - 错题模式
class GrammarScreen extends StatefulWidget {
  const GrammarScreen({Key? key}) : super(key: key);

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  final GrammarExerciseEngine _exerciseEngine = GrammarExerciseEngine();

  GrammarLevel _userLevel = GrammarLevel.B2;
  GrammarType _selectedType = GrammarType.kasus;
  GrammarExercise? _currentExercise;
  String? _userAnswer;
  bool _isSubmitted = false;
  ExerciseResult? _result;
  int _currentIndex = 0;
  int _correctCount = 0;
  int _totalCount = 0;
  final List<GrammarExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _generateNewExercise();
  }

  void _generateNewExercise() {
    setState(() {
      _currentExercise = _exerciseEngine.generateExercise(
        level: _userLevel,
        type: _selectedType,
        seed: DateTime.now().millisecondsSinceEpoch,
      );
      _userAnswer = null;
      _isSubmitted = false;
      _result = null;
      _currentIndex++;
      _totalCount++;
    });
  }

  void _submitAnswer() {
    if (_userAnswer == null || _userAnswer!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择或输入答案')),
      );
      return;
    }

    final result = _exerciseEngine.evaluateAnswer(
      exercise: _currentExercise!,
      userAnswer: _userAnswer!,
      timeSpentSeconds: 0, // TODO: 实际计时
    );

    setState(() {
      _result = result;
      _isSubmitted = true;
      if (result.isCorrect) {
        _correctCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _currentExercise == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Grammar Lab'),
      backgroundColor: GrammarEngine.genderColors['der'],
      elevation: 0,
    actions: [
        // 进度统计
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_correctCount/$_totalCount',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        PopupMenuButton<GrammarLevel>(
          icon: const Icon(Icons.school),
          onSelected: (level) {
            setState(() => _userLevel = level);
          },
          itemBuilder: (context) => GrammarLevel.values.map((level) {
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

          // 题目卡片
          _buildExerciseCard(),

          if (_result != null) ...[
            const SizedBox(height: 20),
            _buildResultCard(),
          ],

          const SizedBox(height: 20),

          // 控制按钮
          _buildControlButtons(),
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
            '语法类型',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GrammarEngine.genderColors['der'],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: GrammarType.values.map((type) {
              final isSelected = type == _selectedType;
              final typeInfo = _getTypeInfo(type);

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedType = type;
                    _generateNewExercise();
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? typeInfo['color']
                        : (typeInfo['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (typeInfo['color'] as Color)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        typeInfo['icon'] as IconData,
                        size: 24,
                        color: isSelected ? Colors.white : (typeInfo['color'] as Color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        typeInfo['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : (typeInfo['color'] as Color),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getTypeInfo(GrammarType type) {
    switch (type) {
      case GrammarType.kasus:
        return {
          'label': '格位',
          'icon': Icons.category,
          'color': GrammarEngine.genderColors['der']!,
        };
      case GrammarType.verbConjugation:
        return {
          'label': '动词变位',
          'icon': Icons.abc,
          'color': GrammarEngine.genderColors['die']!,
        };
      case GrammarType.adjectiveEnding:
        return {
          'label': '形容词词尾',
          'icon': Icons.text_fields,
          'color': GrammarEngine.genderColors['das']!,
        };
      case GrammarType.subordinateClause:
        return {
          'label': '从句',
          'icon': Icons.link,
          'color': Colors.deepPurple,
        };
      case GrammarType.passive:
        return {
          'label': '被动',
          'icon': Icons.sync_alt,
          'color': Colors.teal,
        };
      case GrammarType.konjunktiv:
        return {
          'label': '虚拟式',
          'icon': Icons.psychology,
          'color': Colors.orange,
        };
      case GrammarType.preposition:
        return {
          'label': '介词',
          'icon': Icons.input,
          'color': Colors.pink,
        };
      case GrammarType.sentenceStructure:
        return {
          'label': '句法',
          'icon': Icons.account_tree,
          'color': Colors.indigo,
        };
    }
  }

  Widget _buildExerciseCard() {
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
              // 题目编号和类型
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '题目 #$_currentIndex',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (_getTypeInfo(_selectedType)['color'] as Color),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getTypeInfo(_selectedType)['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 问题
              Text(
                _currentExercise!.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),

              // 答案区域
              const SizedBox(height: 20),

              if (_currentExercise!.isMultipleChoice)
                _buildMultipleChoiceOptions()
              else
                _buildTextInput(),

              if (_result != null && _result!.explanation != null) ...[
                const SizedBox(height: 20),
                _buildExplanation(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceOptions() {
    final options = _currentExercise!.options!;

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _userAnswer == option;
        final isCorrect = option == _currentExercise!.correctAnswer;

        Color? backgroundColor;
        Color? textColor;
        IconData? trailing;

        if (_isSubmitted) {
          if (isCorrect) {
            backgroundColor = GrammarEngine.genderColors['das']!.withOpacity(0.2);
            textColor = GrammarEngine.genderColors['das'];
            trailing = Icons.check_circle;
          } else if (isSelected && !isCorrect) {
            backgroundColor = GrammarEngine.genderColors['die']!.withOpacity(0.2);
            textColor = GrammarEngine.genderColors['die'];
            trailing = Icons.cancel;
          }
        } else if (isSelected) {
          backgroundColor = (_getTypeInfo(_selectedType)['color'] as Color).withOpacity(0.2);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: _isSubmitted ? null : () {
              setState(() => _userAnswer = option);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                border: Border.all(
                  color: isSelected
                      ? (_getTypeInfo(_selectedType)['color'] as Color)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor ?? Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (trailing != null)
                    Icon(trailing, color: textColor),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextInput() {
    return TextField(
      onChanged: (value) {
        setState(() => _userAnswer = value);
      },
      enabled: !_isSubmitted,
      decoration: InputDecoration(
        hintText: '输入你的答案...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _getTypeInfo(_selectedType)['color'] as Color,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _buildExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _result!.isCorrect
            ? GrammarEngine.genderColors['das']!.withOpacity(0.1)
            : GrammarEngine.genderColors['die']!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _result!.isCorrect
              ? GrammarEngine.genderColors['das']!
              : GrammarEngine.genderColors['die']!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _result!.isCorrect ? Icons.check_circle : Icons.info,
                color: _result!.isCorrect
                    ? GrammarEngine.genderColors['das']
                    : GrammarEngine.genderColors['die'],
              ),
              const SizedBox(width: 8),
              Text(
                _result!.isCorrect ? '正确！' : '答案解析',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _result!.isCorrect
                      ? GrammarEngine.genderColors['das']
                      : GrammarEngine.genderColors['die'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_result!.isCorrect)
            Text(
              '正确答案: ${_currentExercise!.correctAnswer}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: GrammarEngine.genderColors['das'],
              ),
            ),
          const SizedBox(height: 8),
          Text(_result!.explanation!),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final score = _result!.score;
    final isCorrect = _result!.isCorrect;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCorrect
                ? [
                    GrammarEngine.genderColors['das']!.withOpacity(0.1),
                    Colors.white,
                  ]
                : [
                    GrammarEngine.genderColors['die']!.withOpacity(0.1),
                    Colors.white,
                  ],
        ),
      ),
        child: Column(
          children: [
            // 结果标题
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCorrect ? Icons.celebration : Icons.psychology,
                  size: 32,
                  color: isCorrect
                      ? GrammarEngine.genderColors['das']
                      : GrammarEngine.genderColors['die'],
                ),
                const SizedBox(width: 12),
                Text(
                  isCorrect ? '太棒了！' : '继续努力',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? GrammarEngine.genderColors['das']
                        : GrammarEngine.genderColors['die'],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 语法点
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _currentExercise!.grammarPoints?.map((point) {
                return Chip(
                  label: Text(point),
                  backgroundColor: (_getTypeInfo(_selectedType)['color'] as Color).withOpacity(0.1),
                  side: BorderSide(
                    color: (_getTypeInfo(_selectedType)['color'] as Color).withOpacity(0.3),
                  ),
                );
              }).toList() ?? [],
            ),

            const SizedBox(height: 20),

            // 分数显示
            if (!isCorrect)
              Center(
                child: Column(
                  children: [
                    Text(
                      '得分',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      score.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: GrammarEngine.genderColors['die'],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedType = GrammarType.values[(_selectedType.index + 1) % GrammarType.values.length];
                _generateNewExercise();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('跳过'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isSubmitted ? _generateNewExercise : _submitAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getTypeInfo(_selectedType)['color'] as Color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(_isSubmitted ? '下一题' : '提交答案'),
          ),
        ),
      ],
    );
  }
}
