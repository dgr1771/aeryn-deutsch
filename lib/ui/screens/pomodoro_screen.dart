/// 番茄时钟UI界面
library;

import 'package:flutter/material.dart';
import '../../services/pomodoro_service.dart';

/// 番茄时钟界面
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final PomodoroService _pomodoroService = PomodoroService.instance;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _pomodoroService.initialize();

    _pomodoroService.onTick = (seconds) {
      if (mounted) setState(() {});
    };

    _pomodoroService.onStateChanged = (state) {
      if (mounted) setState(() {});
    };

    _pomodoroService.onSessionCompleted = (session) {
      // 移除音频播放，使用震动或视觉通知
      _showCompletionNotification(session);
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCompletionNotification(PomodoroSession session) {
    String message = '';

    switch (session.type) {
      case PomodoroType.work:
        message = '学习完成！休息一下吧~';
        break;
      case PomodoroType.shortBreak:
        message = '休息结束，继续加油！';
        break;
      case PomodoroType.longBreak:
        message = '休息结束，准备开始新的学习！';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '知道了',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍅 番茄时钟'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatistics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTimerCard(),
            const SizedBox(height: 20),
            _buildControlButtons(),
            const SizedBox(height: 20),
            _buildStatisticsCards(),
            const SizedBox(height: 20),
            _buildTodayProgress(),
          ],
        ),
      ),
    );
  }

  /// 构建计时器卡片
  Widget _buildTimerCard() {
    final state = _pomodoroService.state;
    final remainingTime = _pomodoroService.remainingTime;
    final progress = _pomodoroService.progress;

    String title;
    Color subtitleColor;
    IconData icon;

    switch (state) {
      case PomodoroState.idle:
        title = '准备学习';
        subtitleColor = Colors.grey;
        icon = Icons.timer_outlined;
        break;
      case PomodoroState.running:
        title = '专注学习中';
        subtitleColor = Colors.red;
        icon = Icons.timer;
        break;
      case PomodoroState.paused:
        title = '已暂停';
        subtitleColor = Colors.orange;
        icon = Icons.pause_circle_outline;
        break;
      case PomodoroState.breakShort:
        title = '☕ 短休息';
        subtitleColor = Colors.green;
        icon = Icons.free_breakfast_outlined;
        break;
      case PomodoroState.breakLong:
        title = '🌴 长休息';
        subtitleColor = Colors.blue;
        icon = Icons.beach_access_outlined;
        break;
      default:
        title = '番茄时钟';
        subtitleColor = Colors.grey;
        icon = Icons.timer_outlined;
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: subtitleColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(subtitleColor),
                  ),
                ),
                Text(
                  remainingTime,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '已完成 ${_pomodoroService.completedPomodoros} 个番茄',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建控制按钮
  Widget _buildControlButtons() {
    final state = _pomodoroService.state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (state == PomodoroState.idle) ...[
            _buildControlButton(
              icon: Icons.play_arrow,
              label: '开始学习',
              color: Colors.green,
              onPressed: () => _pomodoroService.startWork(),
            ),
          ] else if (state == PomodoroState.running) ...[
            _buildControlButton(
              icon: Icons.pause,
              label: '暂停',
              color: Colors.orange,
              onPressed: () => _pomodoroService.pause(),
            ),
            _buildControlButton(
              icon: Icons.stop,
              label: '停止',
              color: Colors.red,
              onPressed: () => _pomodoroService.stop(),
            ),
            _buildControlButton(
              icon: Icons.skip_next,
              label: '跳过',
              color: Colors.grey,
              onPressed: () => _pomodoroService.skip(),
            ),
          ] else if (state == PomodoroState.paused) ...[
            _buildControlButton(
              icon: Icons.play_arrow,
              label: '继续',
              color: Colors.green,
              onPressed: () => _pomodoroService.resume(),
            ),
            _buildControlButton(
              icon: Icons.stop,
              label: '停止',
              color: Colors.red,
              onPressed: () => _pomodoroService.stop(),
            ),
          ] else if (state == PomodoroState.breakShort ||
              state == PomodoroState.breakLong) ...[
            _buildControlButton(
              icon: Icons.play_arrow,
              label: '跳过休息',
              color: Colors.green,
              onPressed: () => _pomodoroService.skip(),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建单个控制按钮
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label,
          backgroundColor: color,
          onPressed: onPressed,
          child: Icon(icon),
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

  /// 构建统计卡片
  Widget _buildStatisticsCards() {
    final stats = _pomodoroService.statistics;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 学习统计',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: '今日番茄',
                  value: '${stats.todayPomodoros}',
                  unit: '个',
                  icon: Icons.today,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: '今日学习',
                  value: '${(stats.todayPomodoros * 25 / 60).toStringAsFixed(1)}',
                  unit: '小时',
                  icon: Icons.access_time,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: '总番茄数',
                  value: '${stats.totalPomodoros}',
                  unit: '个',
                  icon: Icons.emoji_events,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: '总学习时长',
                  value: '${(stats.totalWorkMinutes / 60).toStringAsFixed(1)}',
                  unit: '小时',
                  icon: Icons.schedule,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建单个统计卡片
  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
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

  /// 构建今日进度
  Widget _buildTodayProgress() {
    final todayCount = _pomodoroService.todayPomodoros;
    final targetCount = 6; // 推荐每日6个番茄
    final progress = todayCount / targetCount;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🎯 今日目标进度',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$todayCount / $targetCount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progress >= 1.0
                  ? '🎉 太棒了！已达成今日目标！'
                  : '💪 还有 ${targetCount - todayCount} 个番茄就能达成目标',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示设置对话框
  void _showSettings() {
    final config = _pomodoroService.config;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚙️ 番茄时钟设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('学习时长'),
              subtitle: Text('${config.workDuration} 分钟'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editDuration('work', config.workDuration),
              ),
            ),
            ListTile(
              title: const Text('短休息时长'),
              subtitle: Text('${config.shortBreakDuration} 分钟'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _editDuration('shortBreak', config.shortBreakDuration),
              ),
            ),
            ListTile(
              title: const Text('长休息时长'),
              subtitle: Text('${config.longBreakDuration} 分钟'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _editDuration('longBreak', config.longBreakDuration),
              ),
            ),
            ListTile(
              title: const Text('长休息间隔'),
              subtitle: Text('${config.longBreakInterval} 个番茄'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _editDuration('interval', config.longBreakInterval),
              ),
            ),
          ],
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

  /// 编辑时长
  void _editDuration(String type, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getDurationTitle(type)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '分钟',
            suffixText: '分钟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final newValue = int.tryParse(controller.text);
              if (newValue != null && newValue > 0) {
                final config = _pomodoroService.config;
                PomodoroConfig newConfig;

                switch (type) {
                  case 'work':
                    newConfig = config.copyWith(workDuration: newValue);
                    break;
                  case 'shortBreak':
                    newConfig = config.copyWith(shortBreakDuration: newValue);
                    break;
                  case 'longBreak':
                    newConfig = config.copyWith(longBreakDuration: newValue);
                    break;
                  case 'interval':
                    newConfig = config.copyWith(longBreakInterval: newValue);
                    break;
                  default:
                    newConfig = config;
                }

                _pomodoroService.updateConfig(newConfig);
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  String _getDurationTitle(String type) {
    switch (type) {
      case 'work':
        return '设置学习时长';
      case 'shortBreak':
        return '设置短休息时长';
      case 'longBreak':
        return '设置长休息时长';
      case 'interval':
        return '设置长休息间隔';
      default:
        return '设置';
    }
  }

  /// 显示统计详情
  void _showStatistics() {
    final report = _pomodoroService.generateReport();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📊 学习统计报告'),
        content: SingleChildScrollView(
          child: Text(report),
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
}
