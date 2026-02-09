/// 外部数据管理页面
///
/// 用于管理和导入外部德语学习数据集
library;

import 'package:flutter/material.dart';
import '../../services/external_data_integration_service.dart';

class ExternalDataManagementScreen extends StatefulWidget {
  const ExternalDataManagementScreen({super.key});

  @override
  State<ExternalDataManagementScreen> createState() => _ExternalDataManagementScreenState();
}

class _ExternalDataManagementScreenState extends State<ExternalDataManagementScreen> {
  bool _isLoading = true;
  Map<String, int>? _statistics;
  List<DataIntegrationResult>? _integrationHistory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final stats = await ExternalDataIntegrationService.getDataStatistics();
      final history = await ExternalDataIntegrationService.getIntegrationResults();

      setState(() {
        _statistics = stats;
        _integrationHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载数据失败: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('外部数据管理'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: '刷新',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatisticsCard(),
                  const SizedBox(height: 24),
                  _buildDataSourcesSection(),
                  const SizedBox(height: 24),
                  _buildIntegrationHistory(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.blue.shade700, size: 28),
                const SizedBox(width: 12),
                Text(
                  '数据统计',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_statistics != null) ...[
              _buildStatItem('总导入次数', '${_statistics!['totalImports']}次', Colors.green),
              const SizedBox(height: 12),
              _buildStatItem('成功导入', '${_statistics!['successfulImports']}次', Colors.blue),
              const SizedBox(height: 12),
              _buildStatItem('失败次数', '${_statistics!['failedImports']}次', Colors.red),
              const SizedBox(height: 12),
              _buildStatItem('总记录数', '${_statistics!['totalRecords']}条', Colors.purple),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '可用数据源',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        _buildDataSourceCard(
          title: '德语名词数据库',
          description: '100,000+ 德语名词及语法属性',
          icon: Icons.book,
          color: Colors.blue,
          source: DataSource.germanNounsDatabase,
          onTap: () => _importData(DataSource.germanNounsDatabase),
        ),
        const SizedBox(height: 12),
        _buildDataSourceCard(
          title: '德语动词数据库',
          description: '完整动词变位表',
          icon: Icons.edit,
          color: Colors.green,
          source: DataSource.germanVerbsDatabase,
          onTap: () => _importData(DataSource.germanVerbsDatabase),
        ),
        const SizedBox(height: 12),
        _buildDataSourceCard(
          title: '词频数据',
          description: '基于语料库的德语词频',
          icon: Icons.trending_up,
          color: Colors.orange,
          source: DataSource.wordFrequencies,
          onTap: () => _importData(DataSource.wordFrequencies),
        ),
        const SizedBox(height: 12),
        _buildDataSourceCard(
          title: 'Deutsch im Blick',
          description: '德州大学开源教材',
          icon: Icons.school,
          color: Colors.purple,
          source: DataSource.userImported,
          onTap: _showOERInfo,
        ),
        const SizedBox(height: 12),
        _buildDataSourceCard(
          title: 'Deutsche Welle',
          description: '德国之声免费课程',
          icon: Icons.play_circle,
          color: Colors.red,
          source: DataSource.dwContent,
          onTap: _showDWInfo,
        ),
      ],
    );
  }

  Widget _buildDataSourceCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required DataSource source,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntegrationHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '导入历史',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        if (_integrationHistory == null || _integrationHistory!.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      '还没有导入记录',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ..._integrationHistory!.map((result) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    _getStatusIcon(result.status),
                    color: _getStatusColor(result.status),
                  ),
                  title: Text(_getSourceName(result.source)),
                  subtitle: Text(_formatDate(result.timestamp)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${result.recordsProcessed} 条',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(result.status),
                        ),
                      ),
                      Text(
                        _getStatusText(result.status),
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  Future<void> _importData(DataSource source) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认导入'),
        content: Text('确定要导入 ${_getSourceName(source)} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 显示进度对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('正在导入 ${_getSourceName(source)}...'),
          ],
        ),
      ),
    );

    try {
      DataIntegrationResult result;

      switch (source) {
        case DataSource.germanNounsDatabase:
          result = await ExternalDataIntegrationService.importGermanNouns();
          break;
        case DataSource.germanVerbsDatabase:
          result = await ExternalDataIntegrationService.importGermanVerbs();
          break;
        case DataSource.wordFrequencies:
          result = await ExternalDataIntegrationService.importWordFrequencies();
          break;
        default:
          result = DataIntegrationResult(
            source: source,
            status: DataIntegrationStatus.failed,
            errorMessage: '不支持的数据源',
          );
      }

      Navigator.pop(context); // 关闭进度对话框

      if (mounted) {
        if (result.status == DataIntegrationStatus.completed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('成功导入 ${result.recordsProcessed} 条记录'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('导入失败: ${result.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        // 刷新数据
        _loadData();
      }
    } catch (e) {
      Navigator.pop(context); // 关闭进度对话框
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导入失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showOERInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deutsch im Blick'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('来源: 德克萨斯大学奥斯汀分校 COERLL'),
              SizedBox(height: 8),
              Text('许可: Creative Commons Attribution (CC BY)'),
              SizedBox(height: 8),
              Text('级别: A1-A2 (初学者)'),
              SizedBox(height: 8),
              Text('内容:'),
              SizedBox(height: 4),
              Text('• 10章完整教材'),
              Text('• 语法讲解 (Grimm Grammar)'),
              Text('• 词汇表'),
              Text('• 视频和音频'),
              Text('• 练习题'),
              SizedBox(height: 16),
              Text('这是一个完全免费的德语学习资源，可合法用于学习和教学。', style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 这里可以打开网页或使用内容
            },
            child: const Text('访问网站'),
          ),
        ],
      ),
    );
  }

  void _showDWInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deutsche Welle'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('来源: 德国国际广播公司'),
              SizedBox(height: 8),
              Text('许可: 免费教育用途'),
              SizedBox(height: 8),
              Text('级别: A1-C1 (全级别)'),
              SizedBox(height: 8),
              Text('内容:'),
              SizedBox(height: 4),
              Text('• Nicos Weg (A1-B1)'),
              Text('• Harry - gefangen in der Zeit'),
              Text('• Langsam gesprochene Nachrichten'),
              Text('• Top-Thema mit Vokabeln'),
              Text('• 视频、音频、文本'),
              SizedBox(height: 16),
              Text('DW提供完全免费的德语学习课程，适合各个级别的学习者。', style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 这里可以打开DW网站
            },
            child: const Text('访问DW'),
          ),
        ],
      ),
    );
  }

  String _getSourceName(DataSource source) {
    return switch (source) {
      DataSource.germanNounsDatabase => '德语名词数据库',
      DataSource.germanVerbsDatabase => '德语动词数据库',
      DataSource.wordFrequencies => '词频数据',
      DataSource.deutschImBlick => 'Deutsch im Blick',
      DataSource.dwContent => 'Deutsche Welle',
      DataSource.userImported => '用户导入',
    };
  }

  IconData _getStatusIcon(DataIntegrationStatus status) {
    return switch (status) {
      DataIntegrationStatus.completed => Icons.check_circle,
      DataIntegrationStatus.failed => Icons.error,
      DataIntegrationStatus.downloading => Icons.download,
      DataIntegrationStatus.processing => Icons.settings,
      DataIntegrationStatus.notStarted => Icons.pending,
    };
  }

  Color _getStatusColor(DataIntegrationStatus status) {
    return switch (status) {
      DataIntegrationStatus.completed => Colors.green,
      DataIntegrationStatus.failed => Colors.red,
      DataIntegrationStatus.downloading => Colors.blue,
      DataIntegrationStatus.processing => Colors.orange,
      DataIntegrationStatus.notStarted => Colors.grey,
    };
  }

  String _getStatusText(DataIntegrationStatus status) {
    return switch (status) {
      DataIntegrationStatus.completed => '已完成',
      DataIntegrationStatus.failed => '失败',
      DataIntegrationStatus.downloading => '下载中',
      DataIntegrationStatus.processing => '处理中',
      DataIntegrationStatus.notStarted => '未开始',
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
