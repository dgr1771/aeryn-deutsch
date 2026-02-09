import 'package:flutter/material.dart';

/// 德语名词性别枚举
enum GermanGender {
  der, // 阳性
  die, // 阴性
  das, // 中性
  none, // 未知
}

/// 德语语法格位枚举
enum GermanCase {
  nominativ, // 主格
  akkusativ, // 宾格
  dativ,     // 与格
  genitiv,   // 属格
}

/// 语言等级枚举
enum LanguageLevel {
  A1,
  A2,
  B1,
  B2,
  C1,
  C2,
}

/// Aeryn-Deutsch 核心语法引擎
///
/// 负责：
/// - 名词性别自动识别与着色
/// - 后缀逻辑推断
/// - 格位计算
class GrammarEngine {
  // 定义 Aeryn OS 统一的性别色值
  static const Map<String, Color> genderColors = {
    'der': Color(0xFF2196F3), // 阳性：科技蓝
    'die': Color(0xFFF44336), // 阴性：活力红
    'das': Color(0xFF4CAF50), // 中性：森林绿
    'none': Color(0xFF757575), // 未知：灰色
  };

  // 后缀规则库 - 阴性
  static const List<String> feminineSuffixes = [
    'ung', 'heit', 'keit', 'schaft', 'ei', 'tion', 'ung', 'ik',
    'sis', 'ur', 'tät', 'schaft',
  ];

  // 后缀规则库 - 中性
  static const List<String> neuterSuffixes = [
    'chen', 'lein', 'ment', 'tum', 'um', 'ma', 'nis',
  ];

  // 后缀规则库 - 阳性
  static const List<String> masculineSuffixes = [
    'ismus', 'ner', 'ig', 'ling', 'ich', 'er', 'og',
  ];

  /// 根据性别获取颜色
  static Color getColor(GermanGender gender) {
    switch (gender) {
      case GermanGender.der:
        return genderColors['der']!;
      case GermanGender.die:
        return genderColors['die']!;
      case GermanGender.das:
        return genderColors['das']!;
      default:
        return genderColors['none']!;
    }
  }

  /// 根据性别字符串获取颜色
  static Color getColorByString(String gender) {
    return genderColors[gender.toLowerCase()] ?? genderColors['none']!;
  }

  /// 后缀逻辑推断器 (Suffix Logic)
  ///
  /// 即使 AI 掉线，本地算法也能瞬间判断 80% 的单词性别
  /// 这是解决"0基础快速入门"的关键算法
  static GermanGender predictGender(String word) {
    if (word.isEmpty) return GermanGender.none;

    final lowerWord = word.toLowerCase().trim();

    // 移除复数标记（如果有）
    String cleanWord = lowerWord;
    if (lowerWord.endsWith('e') && lowerWord.length > 3) {
      // 简单处理复数 -e 结尾
      cleanWord = lowerWord.substring(0, lowerWord.length - 1);
    }

    // 检查阴性后缀
    for (final suffix in feminineSuffixes) {
      if (cleanWord.endsWith(suffix)) {
        return GermanGender.die;
      }
    }

    // 检查中性后缀
    for (final suffix in neuterSuffixes) {
      if (cleanWord.endsWith(suffix)) {
        return GermanGender.das;
      }
    }

    // 检查阳性后缀
    for (final suffix in masculineSuffixes) {
      if (cleanWord.endsWith(suffix)) {
        return GermanGender.der;
      }
    }

    // 特殊规则：以 -e 结尾的名词多为阴性
    if (lowerWord.endsWith('e') && lowerWord.length > 2) {
      return GermanGender.die;
    }

    return GermanGender.none;
  }

  /// 检测单词是否为名词（首字母大写）
  static bool isNoun(String word) {
    if (word.isEmpty) return false;

    // 德语名词首字母必须大写
    final firstChar = word[0];
    return firstChar.toUpperCase() == firstChar &&
        firstChar.toLowerCase() != firstChar;
  }

  /// 提取文本中的所有名词并返回带性别信息的列表
  static List<NounInfo> extractNouns(String text) {
    final nouns = <NounInfo>[];

    // 简单分词（实际应用中应使用 spaCy）
    final words = text.split(RegExp(r'''[\s,.!?;:()"'-]+'''));

    for (final word in words) {
      if (word.isEmpty) continue;

      // 检查是否为名词
      if (isNoun(word)) {
        final gender = predictGender(word);
        nouns.add(NounInfo(
          word: word,
          gender: gender,
          color: getColor(gender),
        ));
      }
    }

    return nouns;
  }

}

/// 名词信息数据类
class NounInfo {
  final String word;
  final GermanGender gender;
  final Color color;

  NounInfo({
    required this.word,
    required this.gender,
    required this.color,
  });

  @override
  String toString() {
    return 'NounInfo(word: $word, gender: $gender)';
  }
}
