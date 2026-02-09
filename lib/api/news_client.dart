import 'package:http/http.dart' as http;
import '../models/news_article.dart';
import '../core/grammar_engine.dart';
import '../core/complexity_engine.dart';

/// 新闻客户端 - News Client
///
/// 负责从德国新闻源抓取实时新闻
/// 支持：Deutsche Welle, Tagesschau, Der Spiegel
class NewsClient {
  // 新闻源 RSS
  static const Map<String, String> newsSources = {
    'DW': 'https://www.dw.com/de/rss-alle/top-meldungen/2090',
    'Tagesschau': 'https://www.tagesschau.de/xml/rss2/',
    'Spiegel': 'https://www.spiegel.de/schlagzeilen/tops/index.rss',
  };

  final String? apiKey; // 可选的 API Key
  final http.Client _client;

  NewsClient({http.Client? client, this.apiKey})
      : _client = client ?? http.Client();

  /// 抓取新闻列表
  Future<List<NewsArticle>> fetchNews({
    String source = 'DW',
    int limit = 10,
  }) async {
    final url = newsSources[source];
    if (url == null) {
      throw Exception('Unknown news source: $source');
    }

    try {
      final response = await _client.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        return _parseRSS(response.body, source);
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  /// 解析 RSS Feed
  List<NewsArticle> _parseRSS(String rssBody, String source) {
    final articles = <NewsArticle>[];

    // 简单的 RSS 解析（实际应使用 webfeed 包）
    final itemPattern = RegExp(r'<item>(.*?)</item>', dotAll: true);
    final titlePattern = RegExp(r'<title><!\[CDATA\[(.*?)\]\]></title>');
    final linkPattern = RegExp(r'<link>(.*?)</link>');
    final descPattern = RegExp(r'<description><!\[CDATA\[(.*?)\]\]></description>');
    final pubDatePattern = RegExp(r'<pubDate>(.*?)</pubDate>');

    final items = itemPattern.allMatches(rssBody);

    for (final item in items) {
      final content = item.group(1) ?? '';

      final titleMatch = titlePattern.firstMatch(content);
      final linkMatch = linkPattern.firstMatch(content);
      final descMatch = descPattern.firstMatch(content);
      final dateMatch = pubDatePattern.firstMatch(content);

      final title = titleMatch?.group(1) ?? '';
      final link = linkMatch?.group(1) ?? '';
      final description = descMatch?.group(1) ?? '';
      final pubDate = dateMatch?.group(1) ?? '';

      // 移除 HTML 标签
      final cleanDesc = _stripHtml(description);

      articles.add(NewsArticle(
        title: title,
        description: cleanDesc,
        link: link,
        pubDate: _parseDate(pubDate),
        source: source,
        originalLevel: _estimateLevel(title + cleanDesc),
      ));
    }

    return articles;
  }

  /// 移除 HTML 标签
  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  /// 解析日期
  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// 估算新闻难度等级
  LanguageLevel _estimateLevel(String text) {
    return ComplexityEngine.analyzeLevel(text);
  }

  /// 搜索特定主题的新闻
  Future<List<NewsArticle>> searchNews(String keyword) async {
    final allArticles = await fetchNews();
    return allArticles
        .where((article) =>
            article.title.toLowerCase().contains(keyword.toLowerCase()) ||
            article.description.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  /// 关闭客户端
  void close() {
    _client.close();
  }
}
