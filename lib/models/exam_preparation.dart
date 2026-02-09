/// 德语考试备考模型
library;

import '../models/word.dart';
import '../models/question.dart';

/// 考试类型
enum ExamType {
  testDaF,
  goetheZertifikat,
  telc,
  dsh,
}

/// 考试级别
enum ExamLevel {
  A1,
  A2,
  B1,
  B2,
  C1,
  C2,
}

/// TestDaF部分
enum TestDaFSection {
  reading,      // 阅读理解
  listening,    // 听力理解
  writing,      // 写作
  speaking,     // 口语
}

/// Goethe部分
enum GoetheSection {
  lesen,        // 阅读
  hoeren,       // 听力
  schreiben,    // 写作
  sprechen,     // 口语
}

/// 考试部分
class ExamSection {
  final String id;
  final String name;
  final String description;
  final int duration;        // 时长（分钟）
  final int maxScore;         // 满分
  final int passScore;        // 及格分

  const ExamSection({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.maxScore,
    required this.passScore,
  });

  /// 获取及格率
  double get passRate => passScore / maxScore;
}

/// 考试
class Exam {
  final String id;
  final String name;
  final ExamType type;
  final ExamLevel level;
  final String description;
  final List<ExamSection> sections;
  final int totalDuration;    // 总时长（分钟）
  final int totalScore;       // 总分

  const Exam({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    required this.description,
    required this.sections,
    required this.totalDuration,
    required this.totalScore,
  });

  /// 获取及格所需总分
  int get minPassScore {
    return sections.fold(0, (sum, section) => sum + section.passScore);
  }
}

/// 模拟测试
class MockExam {
  final String id;
  final Exam exam;
  final List<Question> questions;
  final DateTime createdAt;

  const MockExam({
    required this.id,
    required this.exam,
    required this.questions,
    required this.createdAt,
  });

  /// 计算得分
  int calculateScore(Map<String, String> answers) {
    int score = 0;
    for (final question in questions) {
      final userAnswer = answers[question.id];
      if (userAnswer != null && question.isAnswerCorrect(userAnswer)) {
        score += question.points;
      }
    }
    return score;
  }

  /// 是否通过
  bool isPassed(Map<String, String> answers) {
    final score = calculateScore(answers);
    return score >= exam.minPassScore;
  }
}

/// 备考计划
class StudyPlan {
  final String id;
  final Exam exam;
  final DateTime targetDate;    // 目标考试日期
  final int studyDays;          // 学习天数
  final List<DailyTask> dailyTasks;
  final List<StudyResource> resources;

  const StudyPlan({
    required this.id,
    required this.exam,
    required this.targetDate,
    required this.studyDays,
    required this.dailyTasks,
    required this.resources,
  });

  /// 获取当前进度
  double getProgress(DateTime currentDate) {
    final remainingDays = targetDate.difference(currentDate).inDays;
    if (remainingDays >= studyDays) return 0.0;
    return 1.0 - (remainingDays / studyDays);
  }
}

/// 每日任务
class DailyTask {
  final String id;
  final String title;
  final String description;
  final List<String> taskIds;   // 关联的任务ID
  final int estimatedMinutes;

  const DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.taskIds,
    required this.estimatedMinutes,
  });
}

/// 学习资源
class StudyResource {
  final String id;
  final String title;
  final String type;            // reading, grammar, vocabulary, etc.
  final String url;
  final String? description;
  final ExamLevel level;

  const StudyResource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    this.description,
    required this.level,
  });
}

/// 考试标签
const Map<ExamType, String> examTypeLabels = {
  ExamType.testDaF: 'TestDaF',
  ExamType.goetheZertifikat: 'Goethe-Zertifikat',
  ExamType.telc: 'Telc Deutsch',
  ExamType.dsh: 'DSH',
};

/// 级别标签
const Map<ExamLevel, String> examLevelLabels = {
  ExamLevel.A1: 'A1 - 入门级',
  ExamLevel.A2: 'A2 - 基础级',
  ExamLevel.B1: 'B1 - 进阶级',
  ExamLevel.B2: 'B2 - 高级',
  ExamLevel.C1: 'C1 - 精通级',
  ExamLevel.C2: 'C2 - 大师级',
};

/// TestDaF部分标签
const Map<TestDaFSection, String> testDaFSectionLabels = {
  TestDaFSection.reading: 'Leseverstehen (阅读理解)',
  TestDaFSection.listening: 'Hörverstehen (听力理解)',
  TestDaFSection.writing: 'Schriftlicher Ausdruck (写作)',
  TestDaFSection.speaking: 'Mündlicher Ausdruck (口语)',
};

/// Goethe部分标签
const Map<GoetheSection, String> goetheSectionLabels = {
  GoetheSection.lesen: 'Lesen (阅读)',
  GoetheSection.hoeren: 'Hören (听力)',
  GoetheSection.schreiben: 'Schreiben (写作)',
  GoetheSection.sprechen: 'Sprechen (口语)',
};
