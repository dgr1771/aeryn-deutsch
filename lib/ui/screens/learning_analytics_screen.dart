/// 学习数据可视化页面
library;

import 'package:flutter/material.dart';
import '../../models/learning_analytics.dart';
import '../../services/learning_analytics_service.dart';

class LearningAnalyticsScreen extends StatefulWidget {
  const LearningAnalyticsScreen({super.key});

  @override
  State<LearningAnalyticsScreen> createState() =>
      _LearningAnalyticsScreenState();
}

class _LearningAnalyticsScreenState extends State<LearningAnalyticsScreen> {
  final LearningAnalyticsService _service = LearningAnalyticsService();

  LearningAnalytics? _analytics;
  bool _isLoading = true;
  int _selectedPeriod = 7; // 默认显示7天

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final analytics = await _service.getAnalytics();
      setState(() {
        _analytics = analytics;
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
        title: const Text('学习数据'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analytics == null
              ? const Center(child: Text('暂无数据'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 概览卡片
                      _buildOverviewCards(),

                      const SizedBox(height: 24),

                      // 学习时间图表
                      _buildStudyTimeChart(),

                      const SizedBox(height: 24),

                      // 活动分布
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildActivityDistribution(),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildSkillsMastery(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 学习目标
                      _buildGoals(),

                      const SizedBox(height: 24),

                      // 成就
                      _buildAchievements(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          '总学习天数',
          '${_analytics!.totalStudyDays}',
          Icons.calendar_today,
          Colors.blue,
        ),
        _buildStatCard(
          '总学习时长',
          '${(_analytics!.totalStudyMinutes / 60).toStringAsFixed(1)} 小时',
          Icons.access_time,
          Colors.green,
        ),
        _buildStatCard(
          '平均每日',
          '${_analytics!.averageDailyMinutes.toStringAsFixed(0)} 分钟',
          Icons.trending_up,
          Colors.orange,
        ),
        _buildStatCard(
          '当前连续',
          '${_analytics!.currentStreak} 天',
          Icons.local_fire_department,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyTimeChart() {
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
              Text(
                '学习时间趋势',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Row(
                children: [
                  _buildPeriodChip(7, '7天'),
                  const SizedBox(width: 8),
                  _buildPeriodChip(30, '30天'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: _buildDailyChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(int days, String label) {
    final isSelected = _selectedPeriod == days;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPeriod = days;
          });
        }
      },
      selectedColor: Colors.blue.shade600,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildDailyChart() {
    // 筛选对应天数的数据
    final data = _analytics!.dailyStats.take(_selectedPeriod).toList();

    if (data.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    // 找出最大值用于缩放
    final maxValue = data
        .map((d) => d.totalSeconds / 60)
        .reduce((a, b) => a > b ? a : b)
        .clamp(10.0, double.infinity);

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _StudyTimeChartPainter(
        data: data,
        maxValue: maxValue,
      ),
    );
  }

  Widget _buildActivityDistribution() {
    final activityTime = _analytics!.activityTime;
    final activityPercentage = _analytics!.activityPercentage;

    if (activityTime.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(child: Text('暂无活动数据')),
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
          Text(
            '活动分布',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          ...activityTime.entries.map((entry) {
            final percentage = activityPercentage[entry.key] ?? 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getActivityTypeName(entry.key),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '${entry.value} 分钟 (${percentage.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getActivityColor(entry.key),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSkillsMastery() {
    final skills = _analytics!.skills;

    if (skills.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(child: Text('暂无技能数据')),
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
          Text(
            '技能掌握度',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          ...skills.take(5).map((skill) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        skill.skillName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '${skill.percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: skill.masteryLevel,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      skill.masteryLevel >= 0.8
                          ? Colors.green
                          : skill.masteryLevel >= 0.5
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGoals() {
    final goals = _analytics!.goals;

    if (goals.isEmpty) {
      return const SizedBox.shrink();
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
          Text(
            '学习目标',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          ...goals.map((goal) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          goal.goalName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      if (goal.isCompleted)
                        Icon(Icons.check_circle, color: Colors.green)
                      else
                        Text(
                          '剩余 ${goal.daysRemaining} 天',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: goal.currentProgress / goal.targetProgress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      goal.isCompleted ? Colors.green : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(goal.currentProgress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final unlockedIds = _analytics!.achievements;
    final achievements = predefinedAchievements
        .where((a) => unlockedIds.contains(a.id))
        .toList();

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
            '成就 (${unlockedIds.length}/${predefinedAchievements.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          if (achievements.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '还没有解锁任何成就，继续加油！',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          achievement.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _getActivityTypeName(LearningActivityType type) {
    return switch (type) {
      LearningActivityType.vocabulary => '词汇',
      LearningActivityType.grammar => '语法',
      LearningActivityType.reading => '阅读',
      LearningActivityType.listening => '听力',
      LearningActivityType.writing => '写作',
      LearningActivityType.speaking => '口语',
      LearningActivityType.test => '测试',
      LearningActivityType.review => '复习',
    };
  }

  Color _getActivityColor(LearningActivityType type) {
    return switch (type) {
      LearningActivityType.vocabulary => Colors.blue,
      LearningActivityType.grammar => Colors.green,
      LearningActivityType.reading => Colors.orange,
      LearningActivityType.listening => Colors.purple,
      LearningActivityType.writing => Colors.red,
      LearningActivityType.speaking => Colors.teal,
      LearningActivityType.test => Colors.amber,
      LearningActivityType.review => Colors.indigo,
    };
  }
}

/// 自定义图表绘制器
class _StudyTimeChartPainter extends CustomPainter {
  final List<DailyStats> data;
  final double maxValue;

  _StudyTimeChartPainter({
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 40.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;

    // 绘制网格线
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    for (var i = 0; i <= 5; i++) {
      final y = padding + (chartHeight / 5) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );
    }

    // 绘制数据线和区域
    if (data.isNotEmpty) {
      final barWidth = chartWidth / data.length * 0.6;
      final barSpacing = chartWidth / data.length;

      for (var i = 0; i < data.length; i++) {
        final value = data[i].totalSeconds / 60;
        final barHeight = (value / maxValue) * chartHeight;
        final x = padding + barSpacing * i + (barSpacing - barWidth) / 2;
        final y = size.height - padding - barHeight;

        // 绘制柱状图
        final barPaint = Paint()
          ..color = Colors.blue.shade600
          ..style = PaintingStyle.fill;

        final rRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(4),
        );
        canvas.drawRRect(rRect, barPaint);

        // 绘制数值标签
        if (value > 0) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: '${value.toInt()}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 10,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(x + (barWidth - textPainter.width) / 2, y - 14),
          );
        }

        // 绘制日期标签
        if (i % 5 == 0 || i == data.length - 1) {
          final dateText = '${data[i].day}/${data[i].month}';
          final textPainter = TextPainter(
            text: TextSpan(
              text: dateText,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(x + (barWidth - textPainter.width) / 2, size.height - padding + 8),
          );
        }
      }
    }

    // 绘制坐标轴
    final axisPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      axisPaint,
    );
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      axisPaint,
    );
  }

  @override
  bool shouldRepaint(_StudyTimeChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.maxValue != maxValue;
  }
}
