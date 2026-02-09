/// 形容词变格表页面
library;

import 'package:flutter/material.dart';
import '../../models/adjective_declension.dart';

class AdjectiveDeclensionScreen extends StatefulWidget {
  const AdjectiveDeclensionScreen({super.key});

  @override
  State<AdjectiveDeclensionScreen> createState() =>
      _AdjectiveDeclensionScreenState();
}

class _AdjectiveDeclensionScreenState extends State<AdjectiveDeclensionScreen> {
  final TextEditingController _adjectiveController = TextEditingController(
    text: 'gut',
  );
  AdjectiveDeclensionType _selectedType = AdjectiveDeclensionType.weak;

  @override
  void dispose() {
    _adjectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('形容词变格表'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 形容词输入
            _buildAdjectiveInput(),

            const SizedBox(height: 24),

            // 变化类型选择
            _buildTypeSelector(),

            const SizedBox(height: 24),

            // 规则说明
            _buildRuleCard(),

            const SizedBox(height: 24),

            // 变格表
            _buildDeclensionTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjectiveInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '输入形容词',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _adjectiveController,
                decoration: InputDecoration(
                  hintText: '例如: gut, schön, groß',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<String>(
              icon: Icon(Icons.history, color: Colors.blue.shade600),
              tooltip: '常用形容词',
              onSelected: (value) {
                _adjectiveController.text = value;
                setState(() {});
              },
              itemBuilder: (context) {
                return commonAdjectives.map((adj) {
                  return PopupMenuItem<String>(
                    value: adj,
                    child: Text(adj),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择变化类型',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<AdjectiveDeclensionType>(
          segments: AdjectiveDeclensionType.values.map((type) {
            return ButtonSegment<AdjectiveDeclensionType>(
              value: type,
              label: Text(_getTypeShortName(type)),
            );
          }).toList(),
          selected: {_selectedType},
          onSelectionChanged: (Set<AdjectiveDeclensionType> newSelection) {
            setState(() {
              _selectedType = newSelection.first;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blue.shade600;
              }
              return Colors.grey.shade200;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return Colors.grey.shade700;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleCard() {
    final rule = adjectiveDeclensionRules
        .firstWhere((r) => r.type == _selectedType);

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
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rule.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rule.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '示例:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...rule.examples.map((example) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                '• $example',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDeclensionTable() {
    final adjective = _adjectiveController.text.trim();
    if (adjective.isEmpty) {
      return const Center(
        child: Text('请输入形容词'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
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
                Icon(Icons.table_chart, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        declensionTypeLabels[_selectedType] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        adjective,
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
          ),

          // 单数表
          _buildNumberTable(Number.singular),

          // 复数表
          _buildNumberTable(Number.plural),
        ],
      ),
    );
  }

  Widget _buildNumberTable(Number number) {
    final endings = _getEndingsForType(_selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            numberLabels[number] ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // 表头
              _buildTableRow(
                ['', ...GermanCase.values.map((c) => caseShortLabels[c]!)],
                isHeader: true,
              ),
              // 阳性
              _buildTableRow(
                ['Maskulin\n(der)', ...GermanCase.values.map((c) {
                  final ending = endings[c]?[number]?[GermanGender.der] ?? '';
                  return _adjectiveController.text + ending;
                })],
              ),
              // 阴性
              _buildTableRow(
                ['Feminin\n(die)', ...GermanCase.values.map((c) {
                  final ending = endings[c]?[number]?[GermanGender.die] ?? '';
                  return _adjectiveController.text + ending;
                })],
              ),
              // 中性
              _buildTableRow(
                ['Neuter\n(das)', ...GermanCase.values.map((c) {
                  final ending = endings[c]?[number]?[GermanGender.das] ?? '';
                  return _adjectiveController.text + ending;
                })],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blue.shade100 : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cells.asMap().entries.map((entry) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: entry.value == ''
                    ? const SizedBox()
                    : Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Map<GermanCase, Map<Number, Map<GermanGender, String>>> _getEndingsForType(
      AdjectiveDeclensionType type) {
    switch (type) {
      case AdjectiveDeclensionType.weak:
        return weakEndings;
      case AdjectiveDeclensionType.strong:
        return strongEndings;
      case AdjectiveDeclensionType.mixed:
        return mixedEndings;
    }
  }

  String _getTypeShortName(AdjectiveDeclensionType type) {
    return switch (type) {
      AdjectiveDeclensionType.weak => '弱变化',
      AdjectiveDeclensionType.strong => '强变化',
      AdjectiveDeclensionType.mixed => '混合',
    };
  }
}
