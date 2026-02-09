/// 动词变位表可视化页面
library;

import 'package:flutter/material.dart';
import '../../models/verb_conjugation.dart';
import '../../data/verb_conjugations.dart';

class VerbConjugationScreen extends StatefulWidget {
  const VerbConjugationScreen({super.key});

  @override
  State<VerbConjugationScreen> createState() => _VerbConjugationScreenState();
}

class _VerbConjugationScreenState extends State<VerbConjugationScreen> {
  final List<VerbConjugation> _verbs = getVerbsSorted();
  VerbConjugation? _selectedVerb;
  VerbTense _selectedTense = VerbTense.praesens;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 默认选择第一个动词
    if (_verbs.isNotEmpty) {
      _selectedVerb = _verbs.firstWhere((v) => v.infinitive == 'sein');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动词变位表'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),

          // 动词列表
          Expanded(
            child: Row(
              children: [
                // 左侧：动词列表
                SizedBox(
                  width: 200,
                  child: _buildVerbList(),
                ),

                // 右侧：变位表
                Expanded(
                  child: _selectedVerb != null
                      ? _buildConjugationTable()
                      : _buildEmptyState(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索动词...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildVerbList() {
    final filteredVerbs = _searchController.text.isEmpty
        ? _verbs
        : _verbs
            .where((v) =>
                v.infinitive.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                (v.meaning?.contains(_searchController.text) ?? false))
            .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListView.builder(
        itemCount: filteredVerbs.length,
        itemBuilder: (context, index) {
          final verb = filteredVerbs[index];
          final isSelected = _selectedVerb?.infinitive == verb.infinitive;

          return ListTile(
            title: Text(
              verb.infinitive,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade600 : Colors.black87,
              ),
            ),
            subtitle: Text(
              verb.meaning ?? '',
              style: TextStyle(fontSize: 12),
            ),
            selected: isSelected,
            selectedTileColor: Colors.blue.shade50,
            onTap: () {
              setState(() {
                _selectedVerb = verb;
                _selectedTense = VerbTense.praesens;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildConjugationTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 动词信息卡片
          _buildVerbInfoCard(),

          const SizedBox(height: 24),

          // 时态选择器
          _buildTenseSelector(),

          const SizedBox(height: 24),

          // 变位表
          _buildTable(),
        ],
      ),
    );
  }

  Widget _buildVerbInfoCard() {
    if (_selectedVerb == null) return const SizedBox();

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
              Text(
                _selectedVerb!.infinitive,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getVerbTypeColor(_selectedVerb!.type),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  verbTypeLabels[_selectedVerb!.type] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _selectedVerb!.meaning ?? '',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),
          if (_selectedVerb!.example != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedVerb!.example!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              if (_selectedVerb!.partizip2 != null)
                _buildInfoChip('第二分词', _selectedVerb!.partizip2!),
              if (_selectedVerb!.praeteritum != null)
                _buildInfoChip('过去时词干', _selectedVerb!.praeteritum!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenseSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: VerbTense.values.map((tense) {
            final hasData = _selectedVerb?.conjugations.containsKey(tense) ?? false;
            if (!hasData) return const SizedBox();

            final isSelected = _selectedTense == tense;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(_getTenseShortName(tense)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTense = tense;
                  });
                },
                selectedColor: Colors.blue.shade600,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTable() {
    final conjugation = _selectedVerb?.getConjugation(_selectedTense, Person.firstSingular);

    if (conjugation == null || conjugation.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '该时态暂无数据',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
          // 表头
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tenseLabels[_selectedTense] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 表格内容
          ...Person.values.map((person) {
            return _buildTableRow(person);
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(Person person) {
    final pronoun = personalPronounsShort[person] ?? '';
    final conjugation = _selectedVerb?.getConjugation(_selectedTense, person) ?? '';
    final label = personLabels[person] ?? '';

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: InkWell(
        onTap: () {
          _showPersonDetail(person, pronoun, conjugation, label);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 人称代词
              SizedBox(
                width: 80,
                child: Text(
                  pronoun,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 变位形式
              Expanded(
                child: Text(
                  conjugation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),

              // 箭头图标
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPersonDetail(Person person, String pronoun, String conjugation, String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '人称代词: $pronoun',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '变位形式:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                conjugation,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '请从左侧选择一个动词',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getVerbTypeColor(VerbType type) {
    return switch (type) {
      VerbType.regular => Colors.green,
      VerbType.irregular => Colors.orange,
      VerbType.mixed => Colors.purple,
      VerbType.modal => Colors.blue,
      VerbType.separable => Colors.teal,
      VerbType.inseparable => Colors.red,
    };
  }

  String _getTenseShortName(VerbTense tense) {
    return switch (tense) {
      VerbTense.praesens => '现在时',
      VerbTense.praeteritum => '过去时',
      VerbTense.perfekt => '完成时',
      VerbTense.plusquamperfekt => '过完',
      VerbTense.futur1 => '将来I',
      VerbTense.futur2 => '将来II',
      VerbTense.konjunktiv1 => '虚拟I',
      VerbTense.konjunktiv2 => '虚拟II',
      VerbTense.imperativ => '命令式',
    };
  }
}
