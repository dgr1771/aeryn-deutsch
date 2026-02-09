/// 学习路径界面
///
/// 显示技能树、学习进度和今日推荐任务
library;

import 'package:flutter/material.dart';
import '../../core/learning_path/skill_tree.dart';
import '../../core/grammar_engine.dart';
import '../../services/learning_path_service.dart';
import '../../services/learning_manager.dart';
import '../../data/german_skill_tree.dart';

/// 学习路径主界面
class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({Key? key}) : super(key: key);

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  late LearningManager _learningManager;
  late LearningPathService _pathService;
  late UserLearningProgress _progress;
  late LearningRecommendation _recommendation;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    try {
      // 初始化学习管理器
      _learningManager = LearningManager();
      await _learningManager.initialize('user_001');

      // 初始化学习路径服务
      final skillTree = GermanSkillTreeFactory.createCompleteTree();
      _pathService = LearningPathService(skillTree: skillTree);

      // 从数据库加载用户进度
      await _loadProgress();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// 从数据库加载进度
  Future<void> _loadProgress() async {
    // 获取用户进度
    final userProgress = await _learningManager.getUserProgress();
    if (userProgress == null) {
      throw Exception('用户不存在');
    }

    // 获取技能进度
    final skillProgressList = await _learningManager.getSkillProgress();

    // 构建掌握度映射
    final masteredSkills = <String, double>{};
    final completedSkillIds = <String>[];
    for (final skill in skillProgressList) {
      masteredSkills[skill.skillId] = skill.masteryLevel;
      if (skill.isMastered) {
        completedSkillIds.add(skill.skillId);
      }
    }

    // 获取今日推荐
    final recommendedContent = await _learningManager.getRecommendedContent();

    // 构建UI模型
    _progress = UserLearningProgress(
      userId: userProgress.userId,
      currentLevel: userProgress.currentLevel,
      masteredSkills: masteredSkills,
      completedSkillIds: completedSkillIds,
      lastStudyDate: userProgress.lastStudyDate ?? DateTime.now(),
      totalStudyDays: userProgress.totalStudyDays,
      currentStreak: userProgress.currentStreak,
    );

    // 构建推荐技能列表（这里需要从skillId转换为SkillNode）
    final recommendedSkills = <SkillNode>[];
    for (final skillId in recommendedContent['newSkills'] as List<String>) {
      final skill = _pathService.skillTree.nodes[skillId];
      if (skill != null) {
        recommendedSkills.add(skill);
      }
    }

    _recommendation = LearningRecommendation(
      recommendedSkills: recommendedSkills,
      estimatedMinutes: 30,
      reason: recommendedContent['recommendation'] as String? ?? '继续学习',
    );
  }

  /// 刷新数据
  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await _loadProgress();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: GrammarEngine.genderColors['der'],
              ),
              const SizedBox(height: 16),
              Text(
                '加载学习数据...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  '加载失败',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _refresh,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GrammarEngine.genderColors['der'],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: GrammarEngine.genderColors['der'],
        child: CustomScrollView(
          slivers: [
            // 顶部导航栏
            _buildAppBar(),

            // 统计卡片
            SliverToBoxAdapter(
              child: _buildStatisticsCards(),
            ),

            // 今日推荐
            SliverToBoxAdapter(
              child: _buildDailyRecommendation(),
            ),

            // 技能树
            SliverToBoxAdapter(
              child: _buildSkillTree(),
            ),
          ],
        ),
      ),
    );
  }

  /// 顶部导航栏
  Widget _buildAppBar() {
    final stats = _pathService.getLearningStatistics(_progress);

    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          '学习路径',
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
                GrammarEngine.genderColors['der']!.withValues(alpha: 0.1),
                GrammarEngine.genderColors['die']!.withValues(alpha: 0.1),
                GrammarEngine.genderColors['das']!.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Center(
            child: _buildProgressRing(stats['overallProgress'] as double),
          ),
        ),
      ),
    );
  }

  /// 进度环
  Widget _buildProgressRing(double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              GrammarEngine.genderColors['der']!,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '完成度',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 统计卡片
  Widget _buildStatisticsCards() {
    final stats = _pathService.getLearningStatistics(_progress);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '已掌握',
              '${stats['masteredSkills']}',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '学习中',
              '${stats['inProgressSkills']}',
              Icons.pending,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '连续天数',
              '${_progress.currentStreak}',
              Icons.local_fire_department,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  /// 统计卡片
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 今日推荐
  Widget _buildDailyRecommendation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '今日推荐',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: GrammarEngine.genderColors['die']!.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_recommendation.estimatedMinutes} 分钟',
                  style: TextStyle(
                    fontSize: 12,
                    color: GrammarEngine.genderColors['die'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: GrammarEngine.genderColors['das'],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _recommendation.reason,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._recommendation.recommendedSkills.map((skill) =>
                  _buildSkillItem(skill),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 技能项
  Widget _buildSkillItem(SkillNode skill) {
    final mastery = _progress.masteredSkills[skill.id] ?? 0.0;
    final isUnlocked = skill.isUnlocked(_progress.masteredSkills);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? GrammarEngine.genderColors['der']!.withValues(alpha: 0.05)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? GrammarEngine.genderColors['der']!.withValues(alpha: 0.2)
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? GrammarEngine.genderColors['der']
                  : Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSkillIcon(skill.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isUnlocked ? Colors.black87 : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  skill.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 进度
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(mastery * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? GrammarEngine.genderColors['der']
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: mastery,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isUnlocked
                          ? (GrammarEngine.genderColors['der'] ?? Colors.blue)
                          : Colors.grey,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 技能图标
  IconData _getSkillIcon(SkillType type) {
    switch (type) {
      case SkillType.vocabulary:
        return Icons.book;
      case SkillType.grammar:
        return Icons.school;
      case SkillType.listening:
        return Icons.headphones;
      case SkillType.reading:
        return Icons.menu_book;
      case SkillType.writing:
        return Icons.edit;
      case SkillType.speaking:
        return Icons.record_voice_over;
      case SkillType.pronunciation:
        return Icons.volume_up;
    }
  }

  /// 技能树
  Widget _buildSkillTree() {
    final availableSkills = _pathService.skillTree
        .getAvailableSkills(_progress.masteredSkills);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '技能树',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          ...availableSkills.take(10).map((skill) =>
            _buildSkillItem(skill),
          ),
          if (availableSkills.length > 10)
            TextButton(
              onPressed: () {
                // 显示所有技能
              },
              child: Text(
                '查看全部 ${availableSkills.length} 个技能',
                style: TextStyle(color: GrammarEngine.genderColors['die']),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _learningManager.dispose();
    super.dispose();
  }
}
