import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../models/word.dart';

/// 词汇本界面 - Vocabulary Screen
///
/// 功能：
/// - FSRS智能复习
/// - 词汇详情
/// - 词簇映射
class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  // TODO: 从数据库加载实际词汇
  final List<Word> _words = [];
  String _selectedFilter = 'all'; // all, due, mastered

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('生词本'),
        backgroundColor: GrammarEngine.genderColors['das'],
        elevation: 0,
      ),
      body: _words.isEmpty ? _buildEmptyState() : _buildWordList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '生词本是空的',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '在阅读或练习中标记的单词会出现在这里',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _words.length,
      itemBuilder: (context, index) {
        final word = _words[index];
        return _buildWordCard(word);
      },
    );
  }

  Widget _buildWordCard(Word word) {
    final color = GrammarEngine.getColor(word.gender);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showWordDetailBottomSheet(word);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // 词性冠词
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    word.article ?? '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // 单词
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.meaning,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // 等级标识
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getLevelColor(word.level).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getLevelColor(word.level).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getLevelShortText(word.level),
                  style: TextStyle(
                    color: _getLevelColor(word.level),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWordDetailBottomSheet(Word word) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _WordDetailSheet(word: word),
      ),
    );
  }

  Color _getLevelColor(LanguageLevel level) {
    switch (level) {
      case LanguageLevel.A1:
      case LanguageLevel.A2:
        return Colors.green;
      case LanguageLevel.B1:
      case LanguageLevel.B2:
        return GrammarEngine.genderColors['der']!;
      case LanguageLevel.C1:
      case LanguageLevel.C2:
        return GrammarEngine.genderColors['die']!;
    }
  }

  String _getLevelShortText(LanguageLevel level) {
    return level.toString().split('.').last;
  }
}

class _WordDetailSheet extends StatelessWidget {
  final Word word;

  const _WordDetailSheet({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = GrammarEngine.getColor(word.gender);

    return Column(
      children: [
        // 拖动指示器
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // 单词详情
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 词性和单词
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        word.article ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        word.word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 释义
                _buildSection('释义', word.meaning),

                if (word.exampleSentence != null) ...[
                  const SizedBox(height: 16),
                  _buildSection('例句', word.exampleSentence!),
                ],

                if (word.rootWord != null) ...[
                  const SizedBox(height: 16),
                  _buildSection('词根', word.rootWord!),
                ],

                if (word.synonyms != null && word.synonyms!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSection('同义词', word.synonyms!.join(', ')),
                ],

                if (word.collocations != null && word.collocations!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSection('搭配', word.collocations!.join(', ')),
                ],

                const SizedBox(height: 24),

                // 学习统计
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '学习统计',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: GrammarEngine.genderColors['der'],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatItem('复习次数', '${word.reviewCount}'),
                      _buildStatItem('间隔天数', '${word.interval}'),
                      _buildStatItem('难度系数', word.easeFactor.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: GrammarEngine.genderColors['der'],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
