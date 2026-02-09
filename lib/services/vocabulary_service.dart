/// 词汇管理服务
///
/// 提供词汇查询、筛选、学习进度管理功能
library;

import '../core/grammar_engine.dart';
import '../data/vocabulary.dart';
import '../data/vocabulary_extended.dart';
import '../models/word.dart';

/// 词汇服务类
class VocabularyService {
  /// 获取指定级别的所有词汇
  static List<Word> getWordsByLevel(LanguageLevel level) {
    final entries = getVocabularyByLevel(level);
    final extendedEntries = getAllExtendedVocabulary(level);
    final allEntries = [...entries, ...extendedEntries];
    return allEntries.map((e) => e.toWord()).toList();
  }

  /// 获取随机词汇
  static Word getRandomWord(LanguageLevel level) {
    final allWords = getWordsByLevel(level);
    if (allWords.isEmpty) {
      // 如果没有词汇，返回一个默认词汇
      return Word(
        id: 'das',
        word: 'das',
        article: 'das',
        gender: GermanGender.das,
        meaning: '这',
        level: level,
        createdAt: DateTime.now(),
        nextReview: null,
        reviewCount: 0,
        easeFactor: 2.5,
        interval: 0,
      );
    }
    final randomIndex = DateTime.now().millisecondsSinceEpoch % allWords.length;
    return allWords[randomIndex];
  }

  /// 根据性别筛选词汇
  static List<Word> getWordsByGender(LanguageLevel level, GermanGender gender) {
    final words = getWordsByLevel(level);
    return words.where((w) => w.gender == gender).toList();
  }

  /// 搜索词汇
  static List<Word> searchWords(String query, {LanguageLevel? maxLevel}) {
    final level = maxLevel ?? LanguageLevel.B2;
    final words = getWordsByLevel(level);
    return words.where((w) =>
      w.word.toLowerCase().contains(query.toLowerCase()) ||
      w.meaning.contains(query)
    ).toList();
  }

  /// 获取今日词汇
  static List<Word> getDailyWords(LanguageLevel level, {int count = 10}) {
    final allWords = getWordsByLevel(level);
    final today = DateTime.now();
    final seed = today.day + today.month * 31;

    // 使用日期作为种子，确保每天相同的词汇
    final random = seed;
    final startIndex = random % allWords.length;

    final dailyWords = <Word>[];
    for (int i = 0; i < count && i < allWords.length; i++) {
      final index = (startIndex + i) % allWords.length;
      dailyWords.add(allWords[index]);
    }

    return dailyWords;
  }

  /// 获取高频词汇
  static List<Word> getFrequentWords(LanguageLevel level, {int topN = 100}) {
    final words = getWordsByLevel(level);
    final withFrequency = words.where((w) => w.frequencyRank != null).toList();
    withFrequency.sort((a, b) => a.frequencyRank!.compareTo(b.frequencyRank!));
    return withFrequency.take(topN).toList();
  }

  /// 获取指定范围的词汇
  static List<Word> getWordsInRange(LanguageLevel level, int start, int end) {
    final words = getWordsByLevel(level);
    if (start < 0) start = 0;
    if (end > words.length) end = words.length;
    return words.sublist(start, end);
  }

  /// 统计词汇数量
  static int getVocabularyCount(LanguageLevel level) {
    final baseCount = getTotalVocabularyCount();
    final extendedCount = getExtendedVocabularyCount();
    return baseCount + extendedCount;
  }

  /// 获取词汇统计信息
  static Map<String, dynamic> getVocabularyStats(LanguageLevel level) {
    final words = getWordsByLevel(level);

    // 按性别统计
    final genderCount = <GermanGender, int>{
      GermanGender.der: 0,
      GermanGender.die: 0,
      GermanGender.das: 0,
      GermanGender.none: 0,
    };

    for (final word in words) {
      genderCount[word.gender] = genderCount[word.gender]! + 1;
    }

    // 有频率排名的词汇
    final withFrequency = words.where((w) => w.frequencyRank != null).length;

    return {
      'total': words.length,
      'genderDistribution': genderCount,
      'withFrequencyRank': withFrequency,
      'withExample': words.where((w) => w.exampleSentence != null).length,
      'withCollocations': words.where((w) => w.collocations != null && w.collocations!.isNotEmpty).length,
    };
  }

  /// 获取学习建议
  static List<String> getStudyRecommendations(LanguageLevel currentLevel) {
    final recommendations = <String>[];

    switch (currentLevel) {
      case LanguageLevel.A1:
        recommendations.addAll([
          '重点学习基础词汇：家庭成员、日常用品、数字、颜色',
          '掌握最常用的100个动词（sein, haben, kommen, gehen等）',
          '每天学习20个新词，复习前一天的词汇',
          '使用闪卡记忆法，注重名词的词性',
        ]);
        break;
      case LanguageLevel.A2:
        recommendations.addAll([
          '扩展词汇到日常生活场景：购物、交通、餐饮',
          '学习常用动词短语和固定搭配',
          '开始学习形容词的变化形式',
          '阅读简单德语文章，在上下文中记忆词汇',
        ]);
        break;
      case LanguageLevel.B1:
        recommendations.addAll([
          '学习抽象词汇：情感、观点、社会现象',
          '掌握2000-3000个核心词汇',
          '学习同义词和反义词',
          '开始接触专业词汇（根据个人兴趣）',
        ]);
        break;
      case LanguageLevel.B2:
        recommendations.addAll([
          '扩展到学术和职业词汇',
          '学习复杂动词的搭配',
          '掌握C1级别的基础词汇',
          '阅读德语新闻和专业文章',
        ]);
        break;
      case LanguageLevel.C1:
        recommendations.addAll([
          '学习高阶词汇和文学表达',
          '掌握同义词的细微差别',
          '学习成语和俗语',
          '建立专业领域的词汇网络',
        ]);
        break;
      case LanguageLevel.C2:
        recommendations.addAll([
          '精通所有词汇层次',
          '学习古语和地区表达',
          '掌握语域转换（口语/书面语）',
          '建立个性化的词汇网络',
        ]);
        break;
    }

    return recommendations;
  }

  /// 获取应复习的词汇（基于遗忘曲线）
  static List<Word> getWordsForReview(List<Word> allWords) {
    final now = DateTime.now();
    final dueWords = allWords.where((word) {
      if (word.nextReview == null) return true;
      return word.nextReview!.isBefore(now) || word.nextReview!.isAtSameMomentAs(now);
    }).toList();

    // 按优先级排序：间隔时间短、难度大的优先
    dueWords.sort((a, b) {
      final aPriority = (a.interval * 1.0) / (a.easeFactor);
      final bPriority = (b.interval * 1.0) / (b.easeFactor);
      return aPriority.compareTo(bPriority);
    });

    return dueWords;
  }

  /// 词汇难度评估
  static double assessWordDifficulty(Word word) {
    double difficulty = 0.0;

    // 基础分数（级别）
    difficulty += word.level.index * 20;

    // 频率因素（频率排名越靠前，难度越低）
    if (word.frequencyRank != null) {
      difficulty += (1000 - word.frequencyRank!) / 100;
    }

    // 有搭配的词汇稍难
    if (word.collocations != null && word.collocations!.isNotEmpty) {
      difficulty += 10;
    }

    // 有例句的词汇更容易理解
    if (word.exampleSentence != null && word.exampleSentence!.isNotEmpty) {
      difficulty -= 5;
    }

    return difficulty.clamp(0, 100);
  }

  /// 创建词汇学习计划
  static Map<String, dynamic> createStudyPlan({
    required LanguageLevel targetLevel,
    required int weeksPerLevel,
    required int dailyMinutes,
  }) {
    final totalWords = getVocabularyCount(targetLevel);
    final wordsPerWeek = (totalWords / weeksPerLevel).ceil();
    final wordsPerDay = (wordsPerWeek / 7).ceil();

    return {
      'totalWords': totalWords,
      'wordsPerWeek': wordsPerWeek,
      'wordsPerDay': wordsPerDay,
      'estimatedTimePerWord': (dailyMinutes / wordsPerDay).toStringAsFixed(1),
      'totalStudyHours': ((totalWords * dailyMinutes) / wordsPerDay / 60).ceil(),
      'recommendations': getStudyRecommendations(LanguageLevel.A1),
    };
  }
}
