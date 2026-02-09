/// 错误报告页面
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ErrorReportScreen extends StatefulWidget {
  const ErrorReportScreen({super.key});

  @override
  State<ErrorReportScreen> createState() => _ErrorReportScreenState();
}

class _ErrorReportScreenState extends State<ErrorReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expectedTextController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSeverity;

  // 错误分类
  static const Map<String, String> errorCategories = {
    'grammar_mistake': '语法错误',
    'spelling_mistake': '拼写错误',
    'wrong_translation': '错误翻译',
    'unnatural_example': '不自然的例句',
    'cultural_inaccuracy': '文化错误',
    'data_error': '数据错误',
    'ui_bug': '界面问题',
    'feature_request': '功能建议',
    'other': '其他',
  };

  static const Map<String, String> severityLevels = {
    'minor': '轻微',
    'moderate': '中等',
    'severe': '严重',
    'critical': '紧急',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错误报告'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明文本
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '发现错误？请告诉我们！您的反馈帮助我们改进Aeryn-Deutsch。',
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '请详细描述您发现的错误或问题，我们会尽快审核并修复。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 错误分类
            Text(
              '错误分类 *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              hint: const Text('选择错误分类'),
              value: _selectedCategory,
              items: errorCategories.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 严重程度
            Text(
              '严重程度 *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: severityLevels.entries.map((entry) {
                final isSelected = _selectedSeverity == entry.key;
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedSeverity = entry.key;
                      });
                    }
                  },
                  selectedColor: _getSeverityColor(entry.key),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // 详细描述
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '详细描述 *',
                hintText: '请详细描述您发现的错误...\n例如：在"动词变位表"中，动词"sein"的第三人称单数形式错误',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // 期望的正确内容（可选）
            TextField(
              controller: _expectedTextController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '期望的正确内容（可选）',
                hintText: '如果有，请告诉我们正确的内容是什么',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.send),
                label: const Text('提交报告'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 历史报告
            Text(
              '我的报告历史',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getReportHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final history = snapshot.data!;

        if (history.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.history,
                    size: 48,
                    color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    '还没有提交过报告',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: history.length,
          itemBuilder: (context, index) {
            final report = history[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  _getStatusIcon(report['status']),
                  color: _getStatusColor(report['status']),
                ),
                title: Text(
                  errorCategories[report['category']] ?? '其他',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(DateTime.parse(report['timestamp'])),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                trailing: _buildStatusChip(report['status']),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitReport() async {
    // 验证输入
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择错误分类'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写详细描述'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认提交'),
        content: const Text('确定要提交此错误报告吗？'),
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

    try {
      // 保存报告
      await _saveReport({
        'category': _selectedCategory!,
        'severity': _selectedSeverity ?? 'moderate',
        'description': _descriptionController.text.trim(),
        'expectedText': _expectedTextController.text.trim().isEmpty
            ? null
            : _expectedTextController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'pending',
        'appVersion': '2.6.0',
        'platform': 'Flutter',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('报告已提交，感谢您的反馈！'),
            backgroundColor: Colors.green,
          ),
        );

        // 清空表单
        setState(() {
          _descriptionController.clear();
          _expectedTextController.clear();
          _selectedCategory = null;
          _selectedSeverity = null;
        });

        // 刷新历史列表
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('提交失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveReport(Map<String, dynamic> report) async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList('error_reports') ?? [];

    reportsJson.add(jsonEncode(report));
    await prefs.setStringList('error_reports', reportsJson);
  }

  Future<List<Map<String, dynamic>>> _getReportHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList('error_reports') ?? [];

    return reportsJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList()
      ..sort((a, b) => DateTime.parse(b['timestamp'])
          .compareTo(DateTime.parse(a['timestamp'])));
  }

  Widget _buildStatusChip(String status) {
    final label = _getStatusLabel(status);
    final color = _getStatusColor(status);

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    return switch (status) {
      'pending' => Icons.pending,
      'reviewing' => Icons.rate_review,
      'resolved' => Icons.check_circle,
      'rejected' => Icons.cancel,
      _ => Icons.info,
    };
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'pending' => Colors.orange,
      'reviewing' => Colors.blue,
      'resolved' => Colors.green,
      'rejected' => Colors.red,
      _ => Colors.grey,
    };
  }

  String _getStatusLabel(String status) {
    return switch (status) {
      'pending' => '待处理',
      'reviewing' => '审核中',
      'resolved' => '已解决',
      'rejected' => '已拒绝',
      _ => '未知',
    };
  }

  Color _getSeverityColor(String severity) {
    return switch (severity) {
      'minor' => Colors.green,
      'moderate' => Colors.orange,
      'severe' => Colors.red,
      'critical' => Colors.purple,
      _ => Colors.grey,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
