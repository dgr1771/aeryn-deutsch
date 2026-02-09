/// 搜索服务
///
/// 提供词汇、语法、阅读材料的搜索功能
library;

import '../models/word.dart';
import '../models/word.dart';
import '../models/question.dart';
import '../data/reading_materials.dart';
import 'vocabulary_service.dart';
import 'grammar_exercise_engine.dart';

/// 搜索结果类型
enum SearchResultType {
  vocabulary,
  grammar,
  reading,
}

/// 搜索结果
class SearchResult {
  final String id;
  final SearchResultType type;
  final String title;
  final String? subtitle;
  final String description;
  final double relevance;  // 相关度 0-1
  final Map<String, dynamic>? data;

  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.description,
    required this.relevance,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'relevance': relevance,
      'data': data,
    };
  }
}

/// 搜索过滤选项
class SearchFilter {
  final List<SearchResultType>? types;       // 搜索类型
  final List<LanguageLevel>? levels;         // 级别过滤
  final List<String>? categories;            // 类别过滤
  final int? minFrequency;                   // 最小词频
  final int? maxFrequency;                   // 最大词频
  final bool? hasAudio;                      // 是否有音频

  const SearchFilter({
    this.types,
    this.levels,
    this.categories,
    this.minFrequency,
    this.maxFrequency,
    this.hasAudio,
  });

  /// 是否应用过滤
  bool get hasFilter =>
      types != null ||
      levels != null ||
      (categories != null && categories!.isNotEmpty) ||
      minFrequency != null ||
      maxFrequency != null ||
      hasAudio != null;
}

/// 搜索服务
class SearchService {
  // 单例模式
  SearchService._private();
  static final SearchService instance = SearchService._private();

  final VocabularyService _vocabService = VocabularyService.instance;
  final List<ReadingMaterialData> _readingMaterials = readingMaterials;

  /// 搜索
  ///
  /// [query] 搜索关键词
  /// [filter] 可选的过滤条件
  Future<List<SearchResult>> search(
    String query, {
    SearchFilter? filter,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final results = <SearchResult>[];

    // 确定要搜索的类型
    final types = filter?.types ?? SearchResultType.values;

    // 搜索词汇
    if (types.contains(SearchResultType.vocabulary)) {
      final vocabResults = await _searchVocabulary(query, filter);
      results.addAll(vocabResults);
    }

    // 搜索语法
    if (types.contains(SearchResultType.grammar)) {
      final grammarResults = await _searchGrammar(query, filter);
      results.addAll(grammarResults);
    }

    // 搜索阅读材料
    if (types.contains(SearchResultType.reading)) {
      final readingResults = await _searchReading(query, filter);
      results.addAll(readingResults);
    }

    // 按相关度排序
    results.sort((a, b) => b.relevance.compareTo(a.relevance));

    return results;
  }

  /// 搜索词汇
  Future<List<SearchResult>> _searchVocabulary(
    String query,
    SearchFilter? filter,
  ) async {
    final results = <SearchResult>[];
    final allWords = await _vocabService.getAllWords();

    final normalizedQuery = query.toLowerCase().trim();

    for (final word in allWords) {
      // 计算相关度
      double relevance = 0;

      // 精确匹配德语单词
      if (word.word.toLowerCase() == normalizedQuery) {
        relevance = 1.0;
      }
      // 德语单词前缀匹配
      else if (word.word.toLowerCase().startsWith(normalizedQuery)) {
        relevance = 0.9;
      }
      // 德语单词包含
      else if (word.word.toLowerCase().contains(normalizedQuery)) {
        relevance = 0.7;
      }
      // 中文释义包含
      else if (word.meaning.contains(query)) {
        relevance = 0.8;
      }
      // 例句包含
      else if (word.example.toLowerCase().contains(normalizedQuery)) {
        relevance = 0.6;
      }

      // 如果相关度太低，跳过
      if (relevance == 0) continue;

      // 应用过滤条件
      if (!_passesFilter(word, filter)) continue;

      results.add(SearchResult(
        id: 'vocab_${word.word}',
        type: SearchResultType.vocabulary,
        title: word.word,
        subtitle: word.article != null ? '${word.article} ${word.word}' : null,
        description: word.meaning,
        relevance: relevance,
        data: word.toJson(),
      ));
    }

    return results;
  }

  /// 搜索语法
  Future<List<SearchResult>> _searchGrammar(
    String query,
    SearchFilter? filter,
  ) async {
    final results = <SearchResult>[];
    final normalizedQuery = query.toLowerCase().trim();

    // 语法主题列表
    final grammarTopics = [
      {
        'id': 'verb_conjugation',
        'title': '动词变位',
        'description': '德语动词在不同人称和时态下的变位',
        'keywords': ['verb', 'konjugation', '变位', '动词'],
      },
      {
        'id': 'article',
        'title': '冠词',
        'description': '德语定冠词和不定冠词的用法',
        'keywords': ['artikel', 'article', '冠词', 'der', 'die', 'das'],
      },
      {
        'id': 'cases',
        'title': '格',
        'description': '德语四个格：Nominativ, Akkusativ, Dativ, Genitiv',
        'keywords': ['kasus', 'fall', '格', 'nom', 'akk', 'dat', 'gen'],
      },
      {
        'id': 'adjective_endings',
        'title': '形容词词尾',
        'description': '德语形容词在不同格后的词尾变化',
        'keywords': ['adjektiv', 'adjective', '形容词', '词尾', 'endungen'],
      },
      {
        'id': 'prepositions',
        'title': '介词',
        'description': '德语介词及其格的支配',
        'keywords': ['präposition', 'preposition', '介词'],
      },
      {
        'id': 'sentence_structure',
        'title': '句子结构',
        'description': '德语语序：主句、从句、疑问句',
        'keywords': ['satz', 'sentence', '句子', '语序', '结构'],
      },
      {
        'id': 'passive',
        'title': '被动语态',
        'description': '德语被动语态的构成和用法',
        'keywords': ['passiv', 'passive', '被动'],
      },
      {
        'id': 'subjunctive',
        'title': '虚拟式',
        'description': '德语第一和第二虚拟式',
        'keywords': ['konjunktiv', 'subjunctive', '虚拟式'],
      },
    ];

    for (final topic in grammarTopics) {
      double relevance = 0;

      // 检查标题匹配
      if (topic['title']!.toLowerCase().contains(normalizedQuery)) {
        relevance = 0.9;
      }
      // 检查关键词
      else {
        for (final keyword in topic['keywords'] as List<String>) {
          if (keyword.toLowerCase().contains(normalizedQuery) ||
              normalizedQuery.contains(keyword.toLowerCase())) {
            relevance = relevance > 0.6 ? relevance : 0.6;
            break;
          }
        }
      }

      if (relevance > 0) {
        results.add(SearchResult(
          id: 'grammar_${topic['id']}',
          type: SearchResultType.grammar,
          title: topic['title'] as String,
          description: topic['description'] as String,
          relevance: relevance,
          data: {'topicId': topic['id']},
        ));
      }
    }

    return results;
  }

  /// 搜索阅读材料
  Future<List<SearchResult>> _searchReading(
    String query,
    SearchFilter? filter,
  ) async {
    final results = <SearchResult>[];
    final normalizedQuery = query.toLowerCase().trim();

    for (final material in _readingMaterials) {
      double relevance = 0;

      // 标题匹配
      if (material.title.toLowerCase().contains(normalizedQuery)) {
        relevance = 0.9;
      }
      // 内容匹配
      else if (material.content.toLowerCase().contains(normalizedQuery)) {
        // 计算出现次数
        final count = material.content
                .toLowerCase()
                .replaceAll(normalizedQuery, '')
                .length -
            material.content.length;
        relevance = (0.5 + (count / material.content.length) * 0.3).clamp(0.0, 1.0);
      }
      // 类别匹配
      else if (material.category.toLowerCase().contains(normalizedQuery)) {
        relevance = 0.7;
      }

      if (relevance == 0) continue;

      // 级别过滤
      if (filter?.levels != null &&
          !filter!.levels!.contains(material.level)) {
        continue;
      }

      results.add(SearchResult(
        id: 'reading_${material.id}',
        type: SearchResultType.reading,
        title: material.title,
        subtitle: material.level.name.toUpperCase(),
        description: _getPreview(material.content, 100),
        relevance: relevance,
        data: {
          'materialId': material.id,
          'level': material.level.name,
          'wordCount': material.wordCount,
        },
      ));
    }

    return results;
  }

  /// 检查是否通过过滤条件
  bool _passesFilter(Word word, SearchFilter? filter) {
    if (filter == null || !filter.hasFilter) return true;

    // 级别过滤
    if (filter.levels != null) {
      final wordLevel = LanguageLevel.values.firstWhere(
        (level) => level.name == word.level,
        orElse: () => LanguageLevel.A1,
      );
      if (!filter.levels!.contains(wordLevel)) {
        return false;
      }
    }

    // 类别过滤
    if (filter.categories != null && filter.categories!.isNotEmpty) {
      if (!filter.categories!.contains(word.category)) {
        return false;
      }
    }

    // 词频过滤
    if (filter.minFrequency != null && word.frequency < filter.minFrequency!) {
      return false;
    }
    if (filter.maxFrequency != null && word.frequency > filter.maxFrequency!) {
      return false;
    }

    return true;
  }

  /// 获取文本预览
  String _getPreview(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  /// 获取搜索建议
  ///
  /// 基于当前输入提供搜索建议
  Future<List<String>> getSuggestions(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final suggestions = <String>[];

    // 从词汇中获取建议
    final allWords = await _vocabService.getAllWords();
    final normalizedQuery = query.toLowerCase();

    for (final word in allWords) {
      if (word.word.toLowerCase().startsWith(normalizedQuery)) {
        suggestions.add(word.word);
        if (suggestions.length >= 5) break;
      }
    }

    return suggestions;
  }

  /// 获取热门搜索
  List<String> getPopularSearches() {
    return [
      '不定冠词',
      '动词变位',
      'Passiv',
      'Relativsatz',
      'Wechselpräpositionen',
      '情态动词',
      '完成时',
      '形容词词尾',
    ];
  }

  /// 获取最近搜索
  Future<List<String>> getRecentSearches() async {
    // TODO: 从SharedPreferences获取最近搜索
    return [];
  }

  /// 保存搜索历史
  Future<void> saveSearchHistory(String query) async {
    // TODO: 保存到SharedPreferences
  }

  /// 清除搜索历史
  Future<void> clearSearchHistory() async {
    // TODO: 清除SharedPreferences
  }
}
