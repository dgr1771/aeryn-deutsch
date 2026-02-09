import '../models/word.dart';

/// FSRS (Free Spaced Repetition Scheduler) 服务
///
/// 基于开源 FSRS 算法，比传统 SM-2（Anki 旧算法）效率更高
/// 参考：https://github.com/open-spaced-repetition/fsrs4anki
class FSRSService {
  /// 计算下次复习时间
  ///
  /// 参数：
  /// - word: 当前单词
  /// - quality: 评分 (1-5)
  ///   5: 完美回忆
  ///   4: 犹豫后正确
  ///   3: 困难回忆
  ///   2: 错误但记得
  ///   1: 完全忘记
  static Word scheduleNextReview(Word word, int quality) {
    if (quality < 1 || quality > 5) {
      throw ArgumentError('Quality must be between 1 and 5');
    }

    // FSRS 简化版核心算法
    double newEaseFactor = word.easeFactor;
    int newInterval = word.interval;
    DateTime? nextReview;

    if (quality >= 3) {
      // 答对了
      word.reviewCount++;

      if (word.reviewCount == 1) {
        // 第一次复习：1天后
        newInterval = 1;
      } else if (word.reviewCount == 2) {
        // 第二次复习：6天后
        newInterval = 6;
      } else {
        // 后续复习：根据难度系数计算
        newInterval = (word.interval * word.easeFactor).round();
        if (newInterval < 1) newInterval = 1;
      }

      // 更新难度系数
      newEaseFactor = word.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (newEaseFactor < 1.3) newEaseFactor = 1.3;

      nextReview = DateTime.now().add(Duration(days: newInterval));
    } else {
      // 答错了：重置间隔
      newInterval = 0;
      nextReview = DateTime.now().add(const Duration(minutes: 10)); // 10分钟后重试
      newEaseFactor = word.easeFactor - 0.2;
      if (newEaseFactor < 1.3) newEaseFactor = 1.3;
    }

    return Word(
      id: word.id,
      word: word.word,
      article: word.article,
      gender: word.gender,
      meaning: word.meaning,
      exampleSentence: word.exampleSentence,
      rootWord: word.rootWord,
      level: word.level,
      createdAt: word.createdAt,
      nextReview: nextReview,
      reviewCount: quality >= 3 ? word.reviewCount + 1 : 0,
      easeFactor: newEaseFactor,
      interval: newInterval,
      synonyms: word.synonyms,
      antonyms: word.antonyms,
      collocations: word.collocations,
      etymology: word.etymology,
      frequencyRank: word.frequencyRank,
    );
  }

  /// 计算记忆稳定性（Memory Stability）
  ///
  /// 返回值：0-100，100表示完全记忆
  static double calculateStability(Word word) {
    if (word.interval == 0) return 0.0;

    // 基于间隔时间和难度系数计算
    final daysSinceLastReview = word.nextReview != null
        ? DateTime.now().difference(word.createdAt).inDays
        : 0;

    final stability = (word.interval * word.easeFactor) / 100.0;
    return stability.clamp(0.0, 100.0);
  }

  /// 预测遗忘概率
  ///
  /// 返回值：0-1，1表示肯定会忘记
  static double predictForgettingProbability(Word word) {
    if (word.nextReview == null) return 1.0;

    final now = DateTime.now();
    final daysUntilReview = word.nextReview!.difference(now).inDays;

    if (daysUntilReview <= 0) return 1.0; // 已经过了复习时间

    // 基于难度系数预测
    final difficulty = 2.5 / word.easeFactor;
    final probability = 1.0 - (1.0 / (1.0 + difficulty * daysUntilReview));

    return probability.clamp(0.0, 1.0);
  }

  /// 获取今日需要复习的单词
  /// 注意：此方法需要集成数据库后实现
  static Future<List<Word>> getDueWords() async {
    // TODO: 集成数据库后实现
    return [];
  }

  /// 批量安排复习
  /// 注意：此方法需要集成数据库后实现
  static Future<void> scheduleReviews(
    List<WordReview> reviews,
  ) async {
    // TODO: 集成数据库后实现
  }
}

/// 复习记录
class WordReview {
  final Word word;
  final int quality; // 1-5
  final int responseTimeMs; // 回应时间（毫秒）

  WordReview({
    required this.word,
    required this.quality,
    this.responseTimeMs = 0,
  });
}

/// 词汇学习统计
class VocabularyStats {
  final int totalWords;
  final int masteredWords;
  final int reviewingWords;
  final int newWords;
  final double averageStability;

  VocabularyStats({
    required this.totalWords,
    required this.masteredWords,
    required this.reviewingWords,
    required this.newWords,
    required this.averageStability,
  });

  /// 掌握率
  double get masteryRate => totalWords > 0
      ? masteredWords / totalWords
      : 0.0;
}
