import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';
import '../../models/news_article.dart';
import '../../api/news_client.dart';
import '../../api/ai_service.dart';
import '../widgets/color_coded_text.dart';
import '../../main.dart' show AppConfig;

/// 新闻阅读界面 - News Screen
///
/// 功能：
/// - 实时抓取德国新闻
/// - B2→A2智能降级
/// - 词汇性别着色
/// - 难度滑块
class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsClient _newsClient = NewsClient();
  final AIService _aiService = AIService(apiKey: AppConfig.deepSeekApiKey);

  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  LanguageLevel _currentLevel = LanguageLevel.B2;
  int _selectedArticleIndex = 0;
  Map<String, NewsArticle> _transformedArticles = {};

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);

    try {
      final articles = await _newsClient.fetchNews(
        source: 'DW',
        limit: 10,
      );

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('新闻加载失败: $e')),
        );
      }
    }
  }

  Future<void> _transformArticle(NewsArticle article) async {
    if (_currentLevel == LanguageLevel.B2 || article.isTransformed) {
      return;
    }

    try {
      final result = await _aiService.transformNews(
        article.fullContent,
        _currentLevel,
      );

      setState(() {
        _transformedArticles[article.link] = article.copyWith(
          transformedText: result.transformedText,
          targetLevel: _currentLevel,
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI转换失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _articles.isEmpty
              ? _buildEmptyState()
              : _buildNewsContent(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('News Lab'),
      backgroundColor: GrammarEngine.genderColors['der'],
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadNews,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: _showBookmarkedWords,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无新闻',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadNews,
            child: const Text('重新加载'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent() {
    final currentArticle = _articles[_selectedArticleIndex];
    final displayArticle = _transformedArticles[currentArticle.link] ?? currentArticle;

    return Column(
      children: [
        // 难度滑块
        _buildDifficultySlider(),

        // 新闻内容
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 新闻标题
              _buildArticleTitle(displayArticle),

              const SizedBox(height: 12),

              // 元信息
              _buildArticleMeta(displayArticle),

              const SizedBox(height: 20),

              // 正文（带颜色编码）
              ColorCodedText(
                text: displayArticle.displayText,
                baseStyle: const TextStyle(fontSize: 16, height: 1.6),
                onWordTap: (word, gender) {
                  _showWordDetailBottomSheet(word, gender);
                },
              ),

              const SizedBox(height: 24),

              // AI转换按钮
              if (_currentLevel != LanguageLevel.B2 && !displayArticle.isTransformed)
                _buildTransformButton(currentArticle),

              const SizedBox(height: 16),

              // 操作按钮
              _buildActionButtons(currentArticle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '阅读难度',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: GrammarEngine.genderColors['der'],
                ),
              ),
              Text(
                _getLevelText(_currentLevel),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: GrammarEngine.genderColors['das'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _currentLevel.index.toDouble(),
            min: 0,
            max: LanguageLevel.values.length - 1,
            divisions: LanguageLevel.values.length - 1,
            activeColor: GrammarEngine.genderColors['die'],
            onChanged: (value) {
              setState(() {
                _currentLevel = LanguageLevel.values[value.round()];
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: LanguageLevel.values.map((level) {
              final isSelected = level == _currentLevel;
              return Text(
                _getLevelShortText(level),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? GrammarEngine.genderColors['die']
                      : Colors.grey[600],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getLevelText(LanguageLevel level) {
    switch (level) {
      case LanguageLevel.A1:
        return 'A1 - 初级';
      case LanguageLevel.A2:
        return 'A2 - 基础';
      case LanguageLevel.B1:
        return 'B1 - 进阶';
      case LanguageLevel.B2:
        return 'B2 - 中高级';
      case LanguageLevel.C1:
        return 'C1 - 高级';
      case LanguageLevel.C2:
        return 'C2 - 精通';
    }
  }

  String _getLevelShortText(LanguageLevel level) {
    return level.toString().split('.').last;
  }

  Widget _buildArticleTitle(NewsArticle article) {
    return Text(
      article.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }

  Widget _buildArticleMeta(NewsArticle article) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip(article.source, Icons.language, GrammarEngine.genderColors['der']!),
        _buildChip(
          _formatDate(article.pubDate),
          Icons.calendar_today,
          GrammarEngine.genderColors['die']!,
        ),
        if (article.originalLevel != LanguageLevel.B2)
          _buildChip(
            _getLevelShortText(article.originalLevel),
            Icons.trending_up,
            Colors.orange,
          ),
        if (article.isTransformed)
          _buildChip(
            'AI降级: ${_getLevelShortText(article.targetLevel!)}',
            Icons.auto_awesome,
            GrammarEngine.genderColors['das']!,
          ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  Widget _buildTransformButton(NewsArticle article) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _transformArticle(article),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('AI智能降级文本'),
        style: ElevatedButton.styleFrom(
          backgroundColor: GrammarEngine.genderColors['das'],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(NewsArticle article) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '学习工具',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GrammarEngine.genderColors['der'],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.hearing,
                    label: '播报',
                    color: GrammarEngine.genderColors['der']!,
                    onTap: () {
                      // TODO: 播报新闻
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.content_copy,
                    label: '复制',
                    color: GrammarEngine.genderColors['die']!,
                    onTap: () {
                      // TODO: 复制文本
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.translate,
                    label: '解剖',
                    color: GrammarEngine.genderColors['das']!,
                    onTap: () {
                      // TODO: 长难句解剖
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // 上一篇文章
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _selectedArticleIndex > 0
                ? () {
                    setState(() {
                      _selectedArticleIndex--;
                    });
                  }
                : null,
          ),

          // 文章列表
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedArticleIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedArticleIndex = index;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? GrammarEngine.genderColors['der']
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 下一篇文章
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _selectedArticleIndex < _articles.length - 1
                ? () {
                    setState(() {
                      _selectedArticleIndex++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showWordDetailBottomSheet(String word, GermanGender gender) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _WordDetailSheet(
          word: word,
          gender: gender,
          onAddToVocabulary: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已将 "$word" 添加到生词本'),
                backgroundColor: GrammarEngine.genderColors['das'],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBookmarkedWords() {
    Navigator.pushNamed(context, '/vocabulary');
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordDetailSheet extends StatelessWidget {
  final String word;
  final GermanGender gender;
  final VoidCallback onAddToVocabulary;

  const _WordDetailSheet({
    Key? key,
    required this.word,
    required this.gender,
    required this.onAddToVocabulary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = GrammarEngine.getColor(gender);

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

        // 单词信息
        Expanded(
          child: Padding(
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
                        _getGenderArticle(gender),
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
                        word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 操作按钮
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAddToVocabulary,
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text('加入生词本'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: 显示词簇映射
                        },
                        icon: const Icon(Icons.account_tree),
                        label: const Text('词簇'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: color,
                          side: BorderSide(color: color),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getGenderArticle(GermanGender gender) {
    switch (gender) {
      case GermanGender.der:
        return 'der';
      case GermanGender.die:
        return 'die';
      case GermanGender.das:
        return 'das';
      default:
        return '?';
    }
  }
}
