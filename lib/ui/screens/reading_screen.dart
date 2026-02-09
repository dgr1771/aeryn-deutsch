/// 分级阅读界面
///
/// 提供i+1自适应阅读体验
library;

import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../core/learning_path/skill_tree.dart';
import '../../core/graded_reading/i1_controller.dart';
import '../../services/learning_manager.dart';
import '../../services/graded_reading_service.dart';

/// 阅读界面
class ReadingScreen extends StatefulWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late GradedReadingService _readingService;
  late LearningManager _learningManager;

  // 状态
  bool _isLoading = true;
  String? _error;
  LanguageLevel _currentLevel = LanguageLevel.A1;
  List<ReadingMaterial> _recommendedMaterials = [];
  ReadingMaterial? _currentMaterial;
  bool _isReadingMode = false;

  // 阅读相关
  Set<String> _highlightedWords = {};
  Set<String> _learnedWords = {};
  String? _selectedWord;
  int _comprehensionScore = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// 初始化
  Future<void> _initialize() async {
    try {
      _learningManager = LearningManager();
      await _learningManager.initialize('user_001');

      _readingService = GradedReadingService(
        learningManager: _learningManager,
      );

      await _loadData();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// 加载数据
  Future<void> _loadData() async {
    // 获取用户级别
    final userProgress = await _learningManager.getUserProgress();
    if (userProgress != null) {
      _currentLevel = userProgress.currentLevel;
    }

    // 获取推荐材料
    _recommendedMaterials = await _readingService.getRecommendedMaterials('user_001');

    setState(() {
      _isLoading = false;
    });
  }

  /// 选择材料
  void _selectMaterial(ReadingMaterial material) {
    setState(() {
      _currentMaterial = material;
      _isReadingMode = true;
      _highlightedWords.clear();
      _learnedWords.clear();
    });
  }

  /// 返回材料列表
  void _backToMaterials() {
    setState(() {
      _isReadingMode = false;
      _currentMaterial = null;
    });
  }

  /// 高亮生词
  void _toggleHighlight(String word) {
    setState(() {
      if (_highlightedWords.contains(word)) {
        _highlightedWords.remove(word);
      } else {
        _highlightedWords.add(word);
      }
    });
  }

  /// 标记为已学习
  void _markAsLearned(String word) {
    setState(() {
      _learnedWords.add(word);
      _highlightedWords.remove(word);
    });
  }

  /// 完成阅读
  Future<void> _finishReading() async {
    if (_currentMaterial == null) return;

    // 显示理解度测试
    final questions = _readingService.generateReadingTest(
      _currentMaterial!.id,
      3,
    );

    if (mounted) {
      await _showComprehensionTest(questions);
    }
  }

  /// 显示理解度测试
  Future<void> _showComprehensionTest(List<ComprehensionQuestion> questions) async {
    int score = 0;

    for (final question in questions) {
      final answer = await _showQuestionDialog(question);
      if (answer != null && question.isCorrect(answer)) {
        score++;
      }
    }

    final finalScore = (score / questions.length * 100).round();

    setState(() {
      _comprehensionScore = finalScore;
    });

    if (mounted) {
      // 保存结果
      await _learningManager.endLearningSession(
        sessionId: 'reading_${DateTime.now().millisecondsSinceEpoch}',
        skillIds: ['reading_${_currentLevel.name}'],
        totalExercises: questions.length,
        correctExercises: score,
      );

      // 保存新学词汇
      for (final word in _learnedWords) {
        await _learningManager.recordVocabularyPractice(word, 4);
      }

      // 显示结果
      _showResultDialog(finalScore);
    }
  }

  /// 显示问题对话框
  Future<int?> _showQuestionDialog(ComprehensionQuestion question) async {
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verständnistest'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final option = entry.value;
              return ListTile(
                title: Text(option),
                leading: Radio<int>(
                  value: idx,
                  groupValue: null,
                  onChanged: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
                onTap: () {
                  Navigator.of(context).pop(idx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 显示结果对话框
  Future<void> _showResultDialog(int score) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lesen abgeschlossen!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ihr Ergebnis: $score%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: score >= 70
                    ? GrammarEngine.genderColors['das']
                    : Colors.orange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Neue Wörter: ${_learnedWords.length}',
              style: TextStyle(fontSize: 16),
            ),
            if (score >= 70)
              Text(
                'Sehr gut! Weiter so!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              )
            else
              Text(
                'Versuchen Sie es noch einmal!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _backToMaterials();
            },
            child: Text('Zurück'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: GrammarEngine.genderColors['der'],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('加载失败: $_error'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _initialize();
                },
                child: Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(_isReadingMode ? _currentMaterial?.title ?? '' : '分级阅读'),
        leading: _isReadingMode
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _backToMaterials,
              )
            : null,
        actions: _isReadingMode
            ? [
                IconButton(
                  icon: Icon(Icons.check_circle),
                  onPressed: _finishReading,
                  tooltip: '完成阅读',
                ),
              ]
            : null,
      ),
      body: _isReadingMode ? _buildReadingView() : _buildMaterialList(),
    );
  }

  /// 构建材料列表
  Widget _buildMaterialList() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: GrammarEngine.genderColors['der'],
      child: CustomScrollView(
        slivers: [
          // 用户状态卡片
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildUserStatusCard(),
            ),
          ),

          // 材料列表
          if (_recommendedMaterials.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('没有适合的材料'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final material = _recommendedMaterials[index];
                    return _buildMaterialCard(material);
                  },
                  childCount: _recommendedMaterials.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 用户状态卡片
  Widget _buildUserStatusCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GrammarEngine.genderColors['der']!.withOpacity(0.1),
            GrammarEngine.genderColors['die']!.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mein Niveau',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                _currentLevel.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: GrammarEngine.genderColors['der'],
                ),
              ),
              SizedBox(width: 16),
              Text(
                '${_recommendedMaterials.length} Materialien',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 材料卡片
  Widget _buildMaterialCard(ReadingMaterial material) {
    final difficultyColor = _getDifficultyColor(material.difficulty.overallScore);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectMaterial(material),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      material.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: difficultyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      material.difficulty.getDifficultyDescription(),
                      style: TextStyle(
                        color: difficultyColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                material.category,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.menu_book, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${material.wordCount} Wörter',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.bar_chart, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${material.originalLevel.name}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建阅读视图
  Widget _buildReadingView() {
    if (_currentMaterial == null) {
      return Center(child: Text('Kein Material ausgewählt'));
    }

    final content = _currentMaterial!.content;
    final words = content.split(RegExp(r'\s+'));

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 难度信息
          _buildDifficultyInfo(),

          SizedBox(height: 20),

          // 文本内容
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Wrap(
              children: words.map((word) {
                final cleanWord = word.replaceAll(RegExp(r'[.,!?;:]'), ' ')
                    .replaceAll('"', ' ')
                    .replaceAll('"', ' ')
                    .replaceAll(''', ' ')
                    .replaceAll(''', ' ')
                    .replaceAll('`', ' ')
                    .replaceAll('´', ' ')
                    .replaceAll('(', ' ')
                    .replaceAll(')', ' ')
                    .replaceAll('[', ' ')
                    .replaceAll(']', ' ')
                    .replaceAll('{', ' ')
                    .replaceAll('}', ' ')
                    .replaceAll('»', ' ')
                    .replaceAll('«', ' ')
                    .trim();
                final isHighlighted = _highlightedWords.contains(cleanWord);
                final isLearned = _learnedWords.contains(cleanWord);

                return GestureDetector(
                  onTap: () => _showWordMenu(cleanWord),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    decoration: BoxDecoration(
                      color: isLearned
                          ? Colors.green.withOpacity(0.2)
                          : isHighlighted
                              ? Colors.orange.withOpacity(0.2)
                              : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      word + ' ',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: isLearned
                            ? Colors.green
                            : isHighlighted
                                ? Colors.orange
                                : Colors.black87,
                        fontWeight: isLearned || isHighlighted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 20),

          // 学习统计
          _buildLearningStats(),

          SizedBox(height: 80), // 底部空间
        ],
      ),
    );
  }

  /// 难度信息
  Widget _buildDifficultyInfo() {
    final difficulty = _currentMaterial!.difficulty;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GrammarEngine.genderColors['der']!.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: GrammarEngine.genderColors['der']),
              SizedBox(width: 8),
              Text(
                'Schwierigkeitsgrad',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildDifficultyBar('Wörter', difficulty.vocabularyDifficulty),
              SizedBox(width: 8),
              _buildDifficultyBar('Grammatik', difficulty.grammarComplexity),
              SizedBox(width: 8),
              _buildDifficultyBar('Sätze', difficulty.sentenceComplexity),
            ],
          ),
        ],
      ),
    );
  }

  /// 难度条
  Widget _buildDifficultyBar(String label, double value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                value < 0.4
                    ? Colors.green
                    : value < 0.7
                        ? Colors.orange
                        : Colors.red,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  /// 学习统计
  Widget _buildLearningStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${_highlightedWords.length}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                'Neue Wörter',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '${_learnedWords.length}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                'Gelernt',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 显示单词菜单
  void _showWordMenu(String word) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.highlight, color: Colors.orange),
              title: Text('Markieren'),
              onTap: () {
                _toggleHighlight(word);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Als gelernt markieren'),
              onTap: () {
                _markAsLearned(word);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Text('Aussprache'),
              onTap: () {
                // TODO: 实现发音功能
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 获取难度颜色
  Color _getDifficultyColor(double difficulty) {
    if (difficulty < 0.3) return Colors.green;
    if (difficulty < 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _learningManager.dispose();
    super.dispose();
  }
}
