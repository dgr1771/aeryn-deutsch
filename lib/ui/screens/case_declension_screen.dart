/// 格变表可视化页面
library;

import 'package:flutter/material.dart';
import '../../models/case_declension.dart';
import '../../data/case_declensions.dart';

class CaseDeclensionScreen extends StatefulWidget {
  const CaseDeclensionScreen({super.key});

  @override
  State<CaseDeclensionScreen> createState() => _CaseDeclensionScreenState();
}

class _CaseDeclensionScreenState extends State<CaseDeclensionScreen> {
  final List<NounPhraseDeclension> _nouns = getNounsSorted();
  NounPhraseDeclension? _selectedNoun;
  ArticleType _selectedArticle = ArticleType.definite;

  @override
  void initState() {
    super.initState();
    if (_nouns.isNotEmpty) {
      _selectedNoun = _nouns.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('格变表'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // 名词列表
          SizedBox(
            width: 200,
            child: _buildNounList(),
          ),
          // 格变表
          Expanded(
            child: _selectedNoun != null
                ? _buildDeclensionTable()
                : const Center(child: Text('请选择一个名词')),
          ),
        ],
      ),
    );
  }

  Widget _buildNounList() {
    return ListView.builder(
      itemCount: _nouns.length,
      itemBuilder: (context, index) {
        final noun = _nouns[index];
        final isSelected = _selectedNoun?.noun == noun.noun;

        return ListTile(
          title: Text(
            noun.noun,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          subtitle: Text('${noun.gender.name} - ${noun.number.name}'),
          selected: isSelected,
          onTap: () {
            setState(() {
              _selectedNoun = noun;
            });
          },
        );
      },
    );
  }

  Widget _buildDeclensionTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 冠词类型选择
          _buildArticleTypeSelector(),
          const SizedBox(height: 24),
          // 格变表
          _buildTable(),
        ],
      ),
    );
  }

  Widget _buildArticleTypeSelector() {
    return Row(
      children: ArticleType.values.map((type) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FilterChip(
            label: Text(articleTypeLabels[type]!.split(' ')[0]),
            selected: _selectedArticle == type,
            onSelected: (selected) {
              setState(() {
                _selectedArticle = type;
              });
            },
            selectedColor: Colors.blue.shade600,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 表头
          _buildTableRow(
            ['格', 'Nominativ', 'Akkusativ', 'Dativ', 'Genitiv'],
            isHeader: true,
          ),
          // 定冠词行
          _buildTableRow(
            [
              '定冠词',
              _selectedNoun?.definiteArticle[GermanCase.nominativ] ?? '',
              _selectedNoun?.definiteArticle[GermanCase.akkusativ] ?? '',
              _selectedNoun?.definiteArticle[GermanCase.dativ] ?? '',
              _selectedNoun?.definiteArticle[GermanCase.genitiv] ?? '',
            ],
          ),
          // 不定冠词/否定冠词行
          if (_selectedArticle != ArticleType.definite)
            _buildTableRow(
              [
                _selectedArticle == ArticleType.indefinite ? '不定冠词' : '否定冠词',
                _getArticle(GermanCase.nominativ),
                _getArticle(GermanCase.akkusativ),
                _getArticle(GermanCase.dativ),
                _getArticle(GermanCase.genitiv),
              ],
            ),
          // 名词行
          _buildTableRow(
            [
              '名词',
              _selectedNoun?.nounForm[GermanCase.nominativ] ?? '',
              _selectedNoun?.nounForm[GermanCase.akkusativ] ?? '',
              _selectedNoun?.nounForm[GermanCase.dativ] ?? '',
              _selectedNoun?.nounForm[GermanCase.genitiv] ?? '',
            ],
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(List<String> cells, {bool isHeader = false, bool highlight = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blue.shade100 : (highlight ? Colors.yellow.shade50 : null),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: cells.asMap().entries.map((entry) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getArticle(GermanCase case_) {
    if (_selectedArticle == ArticleType.indefinite) {
      return _selectedNoun?.indefiniteArticle?[case_] ?? '-';
    } else {
      return _selectedNoun?.negativeArticle[case_] ?? '-';
    }
  }
}
