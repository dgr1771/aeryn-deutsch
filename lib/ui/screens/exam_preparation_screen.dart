/// 考试备考页面
library;

import 'package:flutter/material.dart';
import '../../models/exam_preparation.dart';
import '../../data/exam_data.dart';

class ExamPreparationScreen extends StatefulWidget {
  const ExamPreparationScreen({super.key});

  @override
  State<ExamPreparationScreen> createState() => _ExamPreparationScreenState();
}

class _ExamPreparationScreenState extends State<ExamPreparationScreen> {
  Exam? _selectedExam;
  final List<Exam> _exams = availableExams;

  @override
  void initState() {
    super.initState();
    _selectedExam = testDaFExam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('考试备考'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // 左侧：考试列表
          SizedBox(
            width: 250,
            child: _buildExamList(),
          ),
          // 右侧：考试详情
          Expanded(
            child: _selectedExam != null
                ? _buildExamDetail()
                : const Center(child: Text('请选择考试')),
          ),
        ],
      ),
    );
  }

  Widget _buildExamList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListView.builder(
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          final exam = _exams[index];
          final isSelected = _selectedExam?.id == exam.id;

          return ListTile(
            title: Text(
              exam.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            subtitle: Text(examLevelLabels[exam.level] ?? ''),
            selected: isSelected,
            selectedTileColor: Colors.blue.shade50,
            onTap: () {
              setState(() {
                _selectedExam = exam;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildExamDetail() {
    if (_selectedExam == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 考试标题
          _buildExamHeader(),

          const SizedBox(height: 24),

          // 考试描述
          _buildDescriptionCard(),

          const SizedBox(height: 24),

          // 考试部分
          Text(
            '考试部分',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          ..._selectedExam!.sections.map((section) {
            return _buildSectionCard(section);
          }).toList(),

          const SizedBox(height: 24),

          // 备考资源
          Text(
            '备考资源',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          _buildResourcesCard(),

          const SizedBox(height: 24),

          // 生成学习计划
          _buildStudyPlanButton(),
        ],
      ),
    );
  }

  Widget _buildExamHeader() {
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
              Icon(Icons.school, color: Colors.blue.shade700, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedExam!.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      examLevelLabels[_selectedExam!.level] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
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
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600),
              const SizedBox(width: 12),
              Text(
                '考试说明',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _selectedExam!.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip('总时长', '${_selectedExam!.totalDuration}分钟'),
              const SizedBox(width: 12),
              _buildInfoChip('总分', '${_selectedExam!.totalScore}分'),
              const SizedBox(width: 12),
              _buildInfoChip(
                '及格分',
                '${_selectedExam!.minPassScore}分',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(ExamSection section) {
    final passRate = (section.passScore / section.maxScore * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Icon(
                Icons.assignment,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip('时长', '${section.duration}分钟'),
              const SizedBox(width: 12),
              _buildInfoChip('满分', '${section.maxScore}分'),
              const SizedBox(width: 12),
              _buildInfoChip('及格', '${section.passScore}分'),
              const SizedBox(width: 12),
              _buildInfoChip('及格率', '$passRate%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesCard() {
    final resources = getExamResources(
      _selectedExam!.type,
      _selectedExam!.level,
    );

    if (resources.isEmpty) {
      return const Center(
        child: Text('暂无备考资源'),
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
        children: resources.map((resource) {
          return ListTile(
            leading: Icon(
              _getResourceIcon(resource.type),
              color: Colors.blue.shade600,
            ),
            title: Text(resource.title),
            subtitle: Text(resource.description ?? ''),
            trailing: Icon(Icons.open_in_new, color: Colors.grey.shade400),
            onTap: () {
              // TODO: 打开资源链接
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStudyPlanButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showStudyPlanDialog(),
        icon: const Icon(Icons.calendar_today),
        label: const Text('生成学习计划'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getResourceIcon(String type) {
    return switch (type) {
      'reading' => Icons.menu_book,
      'listening' => Icons.headphones,
      'writing' => Icons.edit,
      'speaking' => Icons.mic,
      _ => Icons.description,
    };
  }

  void _showStudyPlanDialog() {
    final targetDateController = TextEditingController();
    final dailyMinutesController = TextEditingController(text: '60');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('生成学习计划'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetDateController,
              decoration: const InputDecoration(
                labelText: '目标考试日期',
                hintText: 'YYYY-MM-DD',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                // TODO: 显示日期选择器
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dailyMinutesController,
              decoration: const InputDecoration(
                labelText: '每日学习分钟数',
                prefixIcon: Icon(Icons.access_time),
                hintText: '例如: 60',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 生成学习计划
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('学习计划已生成'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('生成'),
          ),
        ],
      ),
    );
  }
}
