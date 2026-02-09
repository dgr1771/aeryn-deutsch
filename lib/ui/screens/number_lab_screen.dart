import 'package:flutter/material.dart';
import '../../core/number_matrix.dart';
import '../../core/grammar_engine.dart';

/// 数字实验室 - Number Lab
///
/// 实现"跳跃式学习"德语数字
/// 通过交互式动画展示数字的组成逻辑
class NumberLabScreen extends StatefulWidget {
  const NumberLabScreen({Key? key}) : super(key: key);

  @override
  State<NumberLabScreen> createState() => _NumberLabScreenState();
}

class _NumberLabScreenState extends State<NumberLabScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _currentNumber = 1;
  NumberDecomposition? _decomposition;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _generateNewNumber();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateNewNumber() {
    setState(() {
      _currentNumber = NumberMatrix.generateRandom(1, 1000);
      _decomposition = NumberMatrix.decompose(_currentNumber);
      _showAnswer = false;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('数字矩阵'),
        backgroundColor: GrammarEngine.genderColors['der'],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 数字展示卡片
              _buildNumberCard(),

              const SizedBox(height: 24),

              // 德语单词（带动画）
              _buildGermanWord(),

              const SizedBox(height: 32),

              // 逻辑分解
              if (_showAnswer) _buildDecomposition(),

              const SizedBox(height: 24),

              // 操作按钮
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateNewNumber,
        backgroundColor: GrammarEngine.genderColors['die'],
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// 数字展示卡片
  Widget _buildNumberCard() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + 0.2 * _controller.value,
          child: Opacity(
            opacity: _controller.value,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    GrammarEngine.genderColors['der']!,
                    GrammarEngine.genderColors['die']!,
                    GrammarEngine.genderColors['das']!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: GrammarEngine.genderColors['der']!.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$_currentNumber',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 德语单词
  Widget _buildGermanWord() {
    final germanWord = NumberMatrix.numberToGerman(_currentNumber);

    return GestureDetector(
      onTap: () {
        setState(() {
          _showAnswer = !_showAnswer;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: GrammarEngine.genderColors['das']!.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              _showAnswer ? germanWord : '点击查看德语',
              style: TextStyle(
                fontSize: _showAnswer ? 32 : 18,
                fontWeight: FontWeight.bold,
                color: _showAnswer
                    ? GrammarEngine.genderColors['der']
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (!_showAnswer)
              Icon(
                Icons.visibility,
                color: GrammarEngine.genderColors['die'],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// 逻辑分解
  Widget _buildDecomposition() {
    if (_decomposition == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '逻辑组成',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GrammarEngine.genderColors['der'],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decomposition!.parts.map((part) {
              return _buildPartChip(part);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPartChip(NumberPart part) {
    Color color;
    IconData icon;

    switch (part.type) {
      case NumberPartType.million:
        color = Colors.purple;
        icon = Icons.public;
        break;
      case NumberPartType.thousand:
        color = Colors.orange;
        icon = Icons.filter_1;
        break;
      case NumberPartType.hundred:
        color = GrammarEngine.genderColors['der']!;
        icon = Icons.hdr_on;
        break;
      case NumberPartType.tens:
        color = GrammarEngine.genderColors['die']!;
        icon = Icons.filter_9_plus;
        break;
      case NumberPartType.ones:
        color = GrammarEngine.genderColors['das']!;
        icon = Icons.filter_1;
        break;
      case NumberPartType.basic:
        color = Colors.blue;
        icon = Icons.star;
        break;
      case NumberPartType.connector:
        color = Colors.grey;
        icon = Icons.add;
        break;
    }

    return Chip(
      label: Text(
        part.german,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      avatar: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  /// 操作按钮
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          '播报',
          Icons.volume_up,
          GrammarEngine.genderColors['der'] ?? Colors.blue,
          () {
            // TODO: 播放德语发音
          },
        ),
        _buildActionButton(
          '下一个',
          Icons.arrow_forward,
          GrammarEngine.genderColors['die'] ?? Colors.red,
          _generateNewNumber,
        ),
        _buildActionButton(
          '练习',
          Icons.edit,
          GrammarEngine.genderColors['das'] ?? Colors.green,
          () {
            _showPracticeDialog();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showPracticeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('输入德语'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: '输入这个数字的德语...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            final isCorrect = NumberMatrix.validateInput(_currentNumber, value);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCorrect ? '正确！🎉' : '再想想...',
                ),
                backgroundColor: isCorrect
                    ? GrammarEngine.genderColors['das']
                    : GrammarEngine.genderColors['die'],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
}
