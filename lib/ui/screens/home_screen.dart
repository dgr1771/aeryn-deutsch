import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../services/learning_manager.dart';

/// Deutsch 主页 - Aeryn OS Dashboard
///
/// 设计理念：
/// - 简洁、专业的界面
/// - 实时显示 B2 进度
/// - 快速访问核心功能
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late LearningManager _learningManager;

  // 用户数据
  LanguageLevel _currentLevel = LanguageLevel.A1;
  double _overallProgress = 0.0;
  int _currentStreak = 0;
  int _totalStudyDays = 0;
  Map<String, dynamic>? _todaySummary;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    try {
      _learningManager = LearningManager();
      await _learningManager.initialize('user_001');
      await _loadUserData();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('加载数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 加载用户数据
  Future<void> _loadUserData() async {
    // 获取用户进度
    final userProgress = await _learningManager.getUserProgress();
    if (userProgress != null) {
      _currentLevel = userProgress.currentLevel;
      _currentStreak = userProgress.currentStreak;
      _totalStudyDays = userProgress.totalStudyDays;

      // 计算总进度（基于当前级别的百分比）
      final levelIndex = userProgress.currentLevel.index;
      final totalLevels = LanguageLevel.values.length;
      _overallProgress = (levelIndex + 0.15) / totalLevels;
    }

    // 获取今日摘要
    _todaySummary = await _learningManager.getTodaySummary();
  }

  /// 刷新数据
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: GrammarEngine.genderColors['der'],
          child: CustomScrollView(
            slivers: [
              // 顶部导航栏
              _buildAppBar(),

              // 主内容区
              SliverToBoxAdapter(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 顶部导航栏
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Aeryn OS',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GrammarEngine.genderColors['der']!.withOpacity(0.1),
                GrammarEngine.genderColors['die']!.withOpacity(0.1),
                GrammarEngine.genderColors['das']!.withOpacity(0.1),
              ],
            ),
          ),
          child: _buildProgressRing(),
        ),
      ),
    );
  }

  /// 进度环
  Widget _buildProgressRing() {
    final progressPercentage = (_overallProgress * 100).toInt();

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景环
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: _overallProgress,
              strokeWidth: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                GrammarEngine.genderColors['der']!,
              ),
            ),
          ),
          // 中心文字
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentLevel.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: GrammarEngine.genderColors['der'],
                ),
              ),
              Text(
                '$progressPercentage%',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 主内容
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 今日任务卡片
          _buildTodayTasks(),

          const SizedBox(height: 16),

          // 功能快捷入口
          _buildFeatureGrid(),

          const SizedBox(height: 16),

          // 词汇热力图
          _buildVocabularyHeatmap(),
        ],
      ),
    );
  }

  /// 今日任务卡片
  Widget _buildTodayTasks() {
    final sessionsCount = _todaySummary?['sessionsCount'] ?? 0;
    final totalExercises = _todaySummary?['totalExercises'] ?? 0;
    final correctExercises = _todaySummary?['correctExercises'] ?? 0;
    final wordsForReview = _todaySummary?['wordsForReview'] ?? 0;
    final accuracy = _todaySummary?['accuracy'] ?? 0.0;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '今日实战',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: GrammarEngine.genderColors['die']!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$sessionsCount 次会话',
                    style: TextStyle(
                      color: GrammarEngine.genderColors['die'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTaskItem(
              '📝 练习',
              '完成 $totalExercises 题，正确 $correctExercises 题',
              totalExercises > 0,
            ),
            _buildTaskItem(
              '🎯 准确率',
              '${(accuracy * 100).toInt()}%',
              true,
            ),
            _buildTaskItem(
              '📚 词汇复习',
              '$wordsForReview 词待复习',
              wordsForReview == 0,
            ),
            _buildTaskItem(
              '🔥 连续天数',
              '$_currentStreak 天',
              _currentStreak > 0,
            ),
            _buildTaskItem(
              '📖 累计学习',
              '$_totalStudyDays 天',
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String icon, String title, bool completed) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.circle_outlined,
          color: completed
              ? GrammarEngine.genderColors['das']
              : Colors.grey[400],
        ),
        const SizedBox(width: 12),
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  /// 功能快捷入口
  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildFeatureCard(
          '分级阅读',
          'Graded Reading',
          Icons.menu_book,
          GrammarEngine.genderColors['der']!,
          () => Navigator.pushNamed(context, '/reading'),
        ),
        _buildFeatureCard(
          '新闻滤镜',
          'News Filter',
          Icons.article,
          GrammarEngine.genderColors['die']!,
          () => Navigator.pushNamed(context, '/news'),
        ),
        _buildFeatureCard(
          '语法练习',
          'Grammar',
          Icons.school,
          GrammarEngine.genderColors['das']!,
          () => Navigator.pushNamed(context, '/grammar'),
        ),
        _buildFeatureCard(
          '生词本',
          'Vocabulary',
          Icons.book,
          Colors.orange,
          () => Navigator.pushNamed(context, '/vocabulary'),
        ),
        _buildFeatureCard(
          '学习路径',
          'Learning Path',
          Icons.map,
          Colors.purple,
          () => Navigator.pushNamed(context, '/learning-path'),
        ),
        _buildFeatureCard(
          '数字矩阵',
          'Numbers',
          Icons.pin,
          Colors.teal,
          () => Navigator.pushNamed(context, '/numbers'),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 词汇热力图
  Widget _buildVocabularyHeatmap() {
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
              '词汇热力图',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                itemBuilder: (context, index) {
                  final hasActivity = index % 3 != 0;
                  return Container(
                    width: 30,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: hasActivity
                          ? GrammarEngine.genderColors['der']!.withOpacity(0.3 + (index % 5) * 0.15)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部导航栏
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '主页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: '新闻',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: '学习',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _learningManager.dispose();
    super.dispose();
  }
}
