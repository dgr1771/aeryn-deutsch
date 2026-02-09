/// 词族模型
library;

import '../models/word.dart';

/// 词族
class WordFamily {
  final String id;              // 词族ID
  final String root;            // 词根
  final String? meaning;        // 词根含义
  final String? etymology;      // 词源
  final List<Word> words;       // 该词族的所有词汇
  final List<WordFamilyRule> rules; // 构词规则

  const WordFamily({
    required this.id,
    required this.root,
    this.meaning,
    this.etymology,
    required this.words,
    required this.rules,
  });

  /// 获取基础词（通常是最简单的形式）
  Word? get baseWord {
    if (words.isEmpty) return null;
    // 尝试找没有前缀后缀的词
    return words.firstWhere(
      (w) => w.word == root,
      orElse: () => words.first,
    );
  }

  /// 按前缀分类
  Map<String, List<Word>> getByPrefix() {
    final map = <String, List<Word>>{};
    for (final word in words) {
      final prefix = _getPrefix(word.word);
      map.putIfAbsent(prefix, () => []).add(word);
    }
    return map;
  }

  /// 按后缀分类
  Map<String, List<Word>> getBySuffix() {
    final map = <String, List<Word>>{};
    for (final word in words) {
      final suffix = _getSuffix(word.word);
      map.putIfAbsent(suffix, () => []).add(word);
    }
    return map;
  }

  String _getPrefix(String word) {
    if (word.startsWith(root)) return '无前缀';
    final commonPrefixes = ['be', 'ver', 'er', 'ent', 'ge', 'miss', 'zer'];
    for (final prefix in commonPrefixes) {
      if (word.startsWith(prefix)) return prefix;
    }
    return '其他';
  }

  String _getSuffix(String word) {
    if (word == root) return '无后缀';
    final commonSuffixes = [
      'ung', 'heit', 'keit', 'schaft', 'tion', 'ieren',
      'lich', 'ig', 'isch', 'los', 'haft', 'bar', 'sam'
    ];
    for (final suffix in commonSuffixes) {
      if (word.endsWith(suffix)) return suffix;
    }
    return '其他';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'root': root,
      'meaning': meaning,
      'etymology': etymology,
      'words': words.map((w) => w.toJson()).toList(),
      'rules': rules.map((r) => r.toJson()).toList(),
    };
  }
}

/// 构词规则
class WordFamilyRule {
  final String id;
  final String name;            // 规则名称
  final String description;     // 描述
  final RuleType type;          // 规则类型
  final List<String> examples;  // 示例
  final String? pattern;        // 模式（正则）

  const WordFamilyRule({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.examples,
    this.pattern,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'examples': examples,
      'pattern': pattern,
    };
  }
}

/// 规则类型
enum RuleType {
  prefix,         // 前缀
  suffix,         // 后缀
  umlaut,         // 变音
  ablaut,         // 元音变化
  compounding,    // 复合
  conversion,     // 转化
}

/// 前缀信息
class PrefixInfo {
  final String prefix;
  final String meaning;
  final String? example;
  final bool separable;      // 是否可分

  const PrefixInfo({
    required this.prefix,
    required this.meaning,
    this.example,
    required this.separable,
  });
}

/// 后缀信息
class SuffixInfo {
  final String suffix;
  final String meaning;
  final String? example;
  final String? partOfSpeech; // 词性

  const SuffixInfo({
    required this.suffix,
    required this.meaning,
    this.example,
    this.partOfSpeech,
  });
}
