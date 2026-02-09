/// 考试数据
library;

import '../models/exam_preparation.dart';

/// TestDaF考试定义
final Exam testDaFExam = Exam(
  id: 'testdaf_b2',
  name: 'TestDaF',
  type: ExamType.testDaF,
  level: ExamLevel.B2,
  description: 'TestDaF是德语标准化考试，用于证明德语水平，主要用于申请德国大学。',
  sections: [
    ExamSection(
      id: 'reading',
      name: '阅读理解',
      description: '3篇文章，学术题材',
      duration: 60,
      maxScore: 25,
      passScore: 15,
    ),
    ExamSection(
      id: 'listening',
      name: '听力理解',
      description: '3-4段录音，学术题材',
      duration: 40,
      maxScore: 25,
      passScore: 15,
    ),
    ExamSection(
      id: 'writing',
      name: '写作',
      description: '1个图表描述任务',
      duration: 60,
      maxScore: 25,
      passScore: 15,
    ),
    ExamSection(
      id: 'speaking',
      name: '口语',
      description: '7个任务',
      duration: 30,
      maxScore: 25,
      passScore: 15,
    ),
  ],
  totalDuration: 190,
  totalScore: 100,
);

/// Goethe-Zertifikat B2考试定义
final Exam goetheB2Exam = Exam(
  id: 'goethe_b2',
  name: 'Goethe-Zertifikat B2',
  type: ExamType.goetheZertifikat,
  level: ExamLevel.B2,
  description: 'Goethe-Zertifikat B2证明德语B2水平，是国际公认的德语证书。',
  sections: [
    ExamSection(
      id: 'lesen',
      name: '阅读',
      description: '阅读文章和简短邮件',
      duration: 65,
      maxScore: 75,
      passScore: 45,
    ),
    ExamSection(
      id: 'hoeren',
      name: '听力',
      description: '听日常对话和公告',
      duration: 40,
      maxScore: 25,
      passScore: 15,
    ),
    ExamSection(
      id: 'schreiben',
      name: '写作',
      description: '写私人邮件和参与讨论',
      duration: 75,
      maxScore: 75,
      passScore: 45,
    ),
    ExamSection(
      id: 'sprechen',
      name: '口语',
      description: '日常对话、主题演讲、讨论',
      duration: 15,
      maxScore: 75,
      passScore: 45,
    ),
  ],
  totalDuration: 195,
  totalScore: 250,
);

/// Goethe-Zertifikat B1考试定义
final Exam goetheB1Exam = Exam(
  id: 'goethe_b1',
  name: 'Goethe-Zertifikat B1',
  type: ExamType.goetheZertifikat,
  level: ExamLevel.B1,
  description: 'Goethe-Zertifikat B1证明德语B1水平，适合日常交流场景。',
  sections: [
    ExamSection(
      id: 'lesen',
      name: '阅读',
      description: '阅读简单文章',
      duration: 65,
      maxScore: 75,
      passScore: 45,
    ),
    ExamSection(
      id: 'hoeren',
      name: '听力',
      description: '听日常对话和公告',
      duration: 40,
      maxScore: 25,
      passScore: 15,
    ),
    ExamSection(
      id: 'schreiben',
      name: '写作',
      description: '写邮件和参与讨论',
      duration: 60,
      maxScore: 75,
      passScore: 45,
    ),
    ExamSection(
      id: 'sprechen',
      name: '口语',
      description: '日常对话',
      duration: 15,
      maxScore: 75,
      passScore: 45,
    ),
  ],
  totalDuration: 180,
  totalScore: 250,
);

/// DSH考试定义
final Exam dshExam = Exam(
  id: 'dsh',
  name: 'DSH',
  type: ExamType.dsh,
  level: ExamLevel.B2,
  description: 'DSH是德国大学入学德语考试，测试学术德语能力。',
  sections: [
    ExamSection(
      id: 'reading',
      name: '阅读理解',
      description: '学术文章阅读',
      duration: 75,
      maxScore: 100,
      passScore: 57,
    ),
    ExamSection(
      id: 'listening',
      name: '听力理解',
      description: '学术讲座听力',
      duration: 50,
      maxScore: 100,
      passScore: 57,
    ),
    ExamSection(
      id: 'writing',
      name: '写作',
      description: '学术文章写作',
      duration: 75,
      maxScore: 100,
      passScore: 57,
    ),
    ExamSection(
      id: 'grammar',
      name: '语法与词汇',
      description: '科学语言结构',
      duration: 30,
      maxScore: 100,
      passScore: 57,
    ),
  ],
  totalDuration: 230,
  totalScore: 400,
);

/// 所有可用考试
final List<Exam> availableExams = [
  testDaFExam,
  goetheB2Exam,
  goetheB1Exam,
  dshExam,
];

/// 根据类型和级别获取考试
Exam? getExam(ExamType type, ExamLevel level) {
  try {
    return availableExams.firstWhere(
      (exam) => exam.type == type && exam.level == level,
    );
  } catch (e) {
    return null;
  }
}

/// TestDaF备考资源
final List<StudyResource> testDaFResources = [
  StudyResource(
    id: 'testdaf_reading_1',
    title: 'TestDaF阅读技巧',
    type: 'reading',
    url: 'https://www.testdaf.de/fuer-testteilnehmer/teil-1/',
    description: '官方阅读理解技巧指导',
    level: ExamLevel.B2,
  ),
  StudyResource(
    id: 'testdaf_listening_1',
    title: 'TestDaF听力技巧',
    type: 'listening',
    url: 'https://www.testdaf.de/fuer-testteilnehmer/teil-2/',
    description: '官方听力理解技巧指导',
    level: ExamLevel.B2,
  ),
  StudyResource(
    id: 'testdaf_writing_1',
    title: 'TestDaF写作技巧',
    type: 'writing',
    url: 'https://www.testdaf.de/fuer-testteilnehmer/teil-3/',
    description: '官方写作技巧指导',
    level: ExamLevel.B2,
  ),
  StudyResource(
    id: 'testdaf_speaking_1',
    title: 'TestDaF口语技巧',
    type: 'speaking',
    url: 'https://www.testdaf.de/fuer-testteilnehmer/teil-4/',
    description: '官方口语技巧指导',
    level: ExamLevel.B2,
  ),
];

/// Goethe备考资源
final List<StudyResource> goetheResources = [
  StudyResource(
    id: 'goethe_b2_lesen',
    title: 'Goethe B2阅读训练',
    type: 'reading',
    url: 'https://www.goethe.de/inr/exam-training',
    description: '官方阅读训练材料',
    level: ExamLevel.B2,
  ),
  StudyResource(
    id: 'goethe_b2_hoeren',
    title: 'Goethe B2听力训练',
    type: 'listening',
    url: 'https://www.goethe.de/inr/exam-training',
    description: '官方听力训练材料',
    level: ExamLevel.B2,
  ),
  StudyResource(
    id: 'goethe_b2_schreiben',
    title: 'Goethe B2写作训练',
    type: 'writing',
    url: 'https://www.goethe.de/inr/exam-training',
    description: '官方写作训练材料',
    level: ExamLevel.B2,
  ),
  StudyResource(
    id: 'goethe_b2_sprechen',
    title: 'Goethe B2口语训练',
    type: 'speaking',
    url: 'https://www.goethe.de/inr/exam-training',
    description: '官方口语训练材料',
    level: ExamLevel.B2,
  ),
];

/// 获取备考资源
List<StudyResource> getExamResources(ExamType type, ExamLevel level) {
  if (type == ExamType.testDaF && level == ExamLevel.B2) {
    return testDaFResources;
  } else if (type == ExamType.goetheZertifikat) {
    return goetheResources;
  }
  return [];
}

/// 生成备考计划
StudyPlan generateStudyPlan({
  required Exam exam,
  required DateTime targetDate,
  required int dailyMinutes,
}) {
  final now = DateTime.now();
  final studyDays = targetDate.difference(now).inDays;

  // 生成每日任务
  final dailyTasks = <DailyTask>[];
  for (int i = 0; i < studyDays; i++) {
    final dayNum = i + 1;
    dailyTasks.add(DailyTask(
      id: 'day_$dayNum',
      title: '第$dayNum天学习任务',
      description: '复习词汇 + 练习听力 + 阅读文章',
      taskIds: ['vocab', 'listening', 'reading'],
      estimatedMinutes: dailyMinutes,
    ));
  }

  return StudyPlan(
    id: 'plan_${exam.id}_${targetDate.millisecondsSinceEpoch}',
    exam: exam,
    targetDate: targetDate,
    studyDays: studyDays,
    dailyTasks: dailyTasks,
    resources: getExamResources(exam.type, exam.level),
  );
}
