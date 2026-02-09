/// 水平测试数据
///
/// 用于快速评估用户的德语水平
library;

import '../models/question.dart';
import '../models/word.dart';
import '../core/grammar_engine.dart';

/// 水平测试题目
///
/// 包含20道题，覆盖A1-B2水平
final List<Question> placementTestQuestions = [
  // ========== A1 水平题目 (1-5) ==========
  Question(
    id: 'placement_001',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.veryEasy,
    question: 'Ich ___ Student.',
    targetLevel: LanguageLevel.A1,
    options: [
      QuestionOption(
        id: 'a',
        text: 'bin',
        isCorrect: true,
        explanation: 'ich用bin',
      ),
      QuestionOption(id: 'b', text: 'bist', isCorrect: false),
      QuestionOption(id: 'c', text: 'ist', isCorrect: false),
      QuestionOption(id: 'd', text: 'sind', isCorrect: false),
    ],
    points: 5,
  ),

  Question(
    id: 'placement_002',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.veryEasy,
    question: 'Das ist ___ Buch.',
    targetLevel: LanguageLevel.A1,
    options: [
      QuestionOption(id: 'a', text: 'der', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'ein',
        isCorrect: true,
        explanation: 'Buch是中性名词，用ein',
      ),
      QuestionOption(id: 'c', text: 'die', isCorrect: false),
      QuestionOption(id: 'd', text: 'das', isCorrect: false),
    ],
    points: 5,
  ),

  Question(
    id: 'placement_003',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.veryEasy,
    question: 'Wie heißt du? - Ich ___ Anna.',
    targetLevel: LanguageLevel.A1,
    options: [
      QuestionOption(id: 'a', text: 'heiße', isCorrect: true, explanation: 'heißen的变位'),
      QuestionOption(id: 'b', text: 'heißt', isCorrect: false),
      QuestionOption(id: 'c', text: 'heißen', isCorrect: false),
      QuestionOption(id: 'd', text: 'heiß', isCorrect: false),
    ],
    points: 5,
  ),

  Question(
    id: 'placement_004',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.veryEasy,
    question: 'Ich habe ___ Hund.',
    targetLevel: LanguageLevel.A1,
    options: [
      QuestionOption(
        id: 'a',
        text: 'einen',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'b',
        text: 'ein',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'eine',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'd',
        text: 'einen',
        isCorrect: true,
        explanation: 'Hund是阳性名词，Akkusativ用einen',
      ),
    ],
    points: 5,
  ),

  Question(
    id: 'placement_005',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.veryEasy,
    question: 'Was machst du? - Ich ___ Deutsch.',
    targetLevel: LanguageLevel.A1,
    options: [
      QuestionOption(id: 'a', text: 'lerne', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'lernst',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'lernt',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'd',
        text: 'lerne',
        isCorrect: true,
        explanation: 'ich用lernst',
      ),
    ],
    points: 5,
  ),

  // ========== A2 水平题目 (6-10) ==========
  Question(
    id: 'placement_006',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.easy,
    question: 'Ich ___ gestern ins Kino.',
    targetLevel: LanguageLevel.A2,
    options: [
      QuestionOption(
        id: 'a',
        text: 'gehe',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'b',
        text: 'ging',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'bin gegangen',
        isCorrect: true,
        explanation: '完成时用sein + gegangen',
      ),
      QuestionOption(id: 'd', text: 'ginge', isCorrect: false),
    ],
    points: 10,
  ),

  Question(
    id: 'placement_007',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.easy,
    question: 'Kannst du mir helfen? - Ja, ich ___ dir helfen.',
    targetLevel: LanguageLevel.A2,
    options: [
      QuestionOption(id: 'a', text: 'kannst', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'kann',
        isCorrect: true,
        explanation: 'ich + kann',
      ),
      QuestionOption(id: 'c', text: 'könnt', isCorrect: false),
      QuestionOption(id: 'd', text: 'können', isCorrect: false),
    ],
    points: 10,
  ),

  Question(
    id: 'placement_008',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.easy,
    question: 'Das ist das Haus, ___ ich gekauft habe.',
    targetLevel: LanguageLevel.A2,
    options: [
      QuestionOption(id: 'a', text: 'das', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'das',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'das',
        isCorrect: true,
        explanation: '关系从句，中性名词用das',
      ),
      QuestionOption(id: 'd', text: 'deren', isCorrect: false),
    ],
    points: 10,
  ),

  Question(
    id: 'placement_009',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.easy,
    question: 'Ich ___ Deutsch, seit ich 10 Jahre alt bin.',
    targetLevel: LanguageLevel.A2,
    options: [
      QuestionOption(id: 'a', text: 'lerne', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'lerne',
        isCorrect: true,
        explanation: '自从...以来，用现在时',
      ),
      QuestionOption(id: 'c', text: 'lernte', isCorrect: false),
      QuestionOption(id: 'd', text: 'habe gelernt', isCorrect: false),
    ],
    points: 10,
  ),

  Question(
    id: 'placement_010',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.easy,
    question: 'Er ___ mir das Buch geben.',
    targetLevel: LanguageLevel.A2,
    options: [
      QuestionOption(id: 'a', text: 'wollte', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'wollte',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'wollte',
        isCorrect: true,
        explanation: 'wollen + Dativ (人) + Akkusativ (物)',
      ),
      QuestionOption(id: 'd', text: 'würde', isCorrect: false),
    ],
    points: 10,
  ),

  // ========== B1 水平题目 (11-15) ==========
  Question(
    id: 'placement_011',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.medium,
    question: 'Wenn ich ___ würde, würde ich nach Deutschland reisen.',
    targetLevel: LanguageLevel.B1,
    options: [
      QuestionOption(id: 'a', text: 'reich', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'reich',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'reich',
        isCorrect: true,
        explanation: '第二虚拟式：wäre',
      ),
      QuestionOption(id: 'd', text: 'reich sei', isCorrect: false),
    ],
    points: 15,
  ),

  Question(
    id: 'placement_012',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.medium,
    question: 'Das Haus ___ letzten Jahres renoviert.',
    targetLevel: LanguageLevel.B1,
    options: [
      QuestionOption(
        id: 'a',
        text: 'wurde',
        isCorrect: true,
        explanation: '过程被动：werden + Partizip II',
      ),
      QuestionOption(id: 'b', text: 'ist', isCorrect: false),
      QuestionOption(id: 'c', text: 'wird', isCorrect: false),
      QuestionOption(id: 'd', text: 'wurde', isCorrect: false),
    ],
    points: 15,
  ),

  Question(
    id: 'placement_013',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.medium,
    question:
        '___ er studiert hat, hat er als Ingenieur gearbeitet.',
    targetLevel: LanguageLevel.B1,
    options: [
      QuestionOption(
        id: 'a',
        text: 'Nachdem',
        isCorrect: true,
        explanation: 'Nachdem引导时间从句',
      ),
      QuestionOption(id: 'b', text: 'Nach', isCorrect: false),
      QuestionOption(id: 'c', text: 'Wenn', isCorrect: false),
      QuestionOption(id: 'd', text: 'Als', isCorrect: false),
    ],
    points: 15,
  ),

  Question(
    id: 'placement_014',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.medium,
    question:
        'Es ist wichtig, dass man ___ Fremdsprachen lernt.',
    targetLevel: LanguageLevel.B1,
    options: [
      QuestionOption(id: 'a', text: 'mehrere', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'mehrere',
        isCorrect: true,
        explanation: 'dass从句后形容词词尾变化',
      ),
      QuestionOption(id: 'c', text: 'mehreres', isCorrect: false),
      QuestionOption(id: 'd', text: 'mehreren', isCorrect: false),
    ],
    points: 15,
  ),

  Question(
    id: 'placement_015',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.medium,
    question:
        'Er sagte, dass er ___ Prüfung bestanden habe.',
    targetLevel: LanguageLevel.B1,
    options: [
      QuestionOption(
        id: 'a',
        text: 'die',
        isCorrect: true,
        explanation: '第一虚拟式：habe (间接引语)',
      ),
      QuestionOption(id: 'b', text: 'eine', isCorrect: false),
      QuestionOption(id: 'c', text: 'einer', isCorrect: false),
      QuestionOption(id: 'd', text: 'das', isCorrect: false),
    ],
    points: 15,
  ),

  // ========== B2 水平题目 (16-20) ==========
  Question(
    id: 'placement_016',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.difficult,
    question:
        '___ des schlechten Wetters sind wir zu Hause geblieben.',
    targetLevel: LanguageLevel.B2,
    options: [
      QuestionOption(
        id: 'a',
        text: 'Trotz',
        isCorrect: true,
        explanation: 'Trotz + Genitiv',
      ),
      QuestionOption(id: 'b', text: 'Wegen', isCorrect: false),
      QuestionOption(id: 'c', text: 'Während', isCorrect: false),
      QuestionOption(id: 'd', text: 'Obwohl', isCorrect: false),
    ],
    points: 20,
  ),

  Question(
    id: 'placement_017',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.difficult,
    question:
        'Er forderte, dass das Projekt sofort ___ werde.',
    targetLevel: LanguageLevel.B2,
    options: [
      QuestionOption(
        id: 'a',
        text: 'beende',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'b',
        text: 'beendet',
        isCorrect: true,
        explanation: '第一虚拟式被动式：werde + Partizip II',
      ),
      QuestionOption(id: 'c', text: 'beendete', isCorrect: false),
      QuestionOption(id: 'd', text: 'beenden', isCorrect: false),
    ],
    points: 20,
  ),

  Question(
    id: 'placement_018',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.difficult,
    question:
        'Das Problem, ___ es geht, ist komplizierter als gedacht.',
    targetLevel: LanguageLevel.B2,
    options: [
      QuestionOption(id: 'a', text: 'um das', isCorrect: false),
      QuestionOption(
        id: 'b',
        text: 'um das',
        isCorrect: true,
        explanation: 'um das + Akk (关于...)',
      ),
      QuestionOption(id: 'c', text: 'von dem', isCorrect: false),
      QuestionOption(id: 'd', text: 'über das', isCorrect: false),
    ],
    points: 20,
  ),

  Question(
    id: 'placement_019',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.difficult,
    question:
        '___ die Klimakrise besorgniserregend ist, handeln nur wenige.',
    targetLevel: LanguageLevel.B2,
    options: [
      QuestionOption(
        id: 'a',
        text: 'Obwohl',
        isCorrect: true,
        explanation: '让步从句：Obwohl',
      ),
      QuestionOption(id: 'b', text: 'Weil', isCorrect: false),
      QuestionOption(id: 'c', text: 'Wenn', isCorrect: false),
      QuestionOption(id: 'd', text: 'Da', isCorrect: false),
    ],
    points: 20,
  ),

  Question(
    id: 'placement_020',
    type: QuestionType.multipleChoice,
    difficulty: QuestionDifficulty.difficult,
    question:
        'Es ist davon auszugehen, dass die Konferenz ___ wird.',
    targetLevel: LanguageLevel.B2,
    options: [
      QuestionOption(
        id: 'a',
        text: 'verschoben',
        isCorrect: true,
        explanation: '被动语态：wird verschoben (推迟)',
      ),
      QuestionOption(id: 'b', text: 'verschieben', isCorrect: false),
      QuestionOption(id: 'c', text: 'verschob', isCorrect: false),
      QuestionOption(id: 'd', text: 'verschoben', isCorrect: false),
    ],
    points: 20,
  ),
];

/// 根据分数评估水平
///
/// 0-25: A1
/// 26-50: A2
/// 51-75: B1
/// 76-100: B2
LanguageLevel assessLevelFromScore(int score) {
  if (score <= 25) return LanguageLevel.A1;
  if (score <= 50) return LanguageLevel.A2;
  if (score <= 75) return LanguageLevel.B1;
  return LanguageLevel.B2;
}

/// 水平测试结果
class PlacementTestResult {
  final int score;              // 得分 (0-100)
  final int correctAnswers;     // 正确题数
  final int totalQuestions;     // 总题数
  final LanguageLevel level;    // 评估级别
  final List<String> weakTopics; // 弱项主题
  final List<String> strongTopics; // 强项主题

  const PlacementTestResult({
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.level,
    this.weakTopics = const [],
    this.strongTopics = const [],
  });

  /// 从答案列表创建结果
  factory PlacementTestResult.fromAnswers(Map<String, String> answers) {
    int correct = 0;
    final weak = <String>[];
    final strong = <String>[];

    for (final question in placementTestQuestions) {
      final userAnswer = answers[question.id];
      if (userAnswer != null && question.isAnswerCorrect(userAnswer)) {
        correct++;
      } else {
        // 记录错误题目所属级别
        final levelStr = question.targetLevel.name;
        if (!weak.contains(levelStr)) {
          weak.add(levelStr);
        }
      }
    }

    final score = (correct / placementTestQuestions.length * 100).round();
    final level = assessLevelFromScore(score);

    return PlacementTestResult(
      score: score,
      correctAnswers: correct,
      totalQuestions: placementTestQuestions.length,
      level: level,
      weakTopics: weak,
      strongTopics: strong,
    );
  }

  /// 获取详细反馈
  String get feedback {
    return switch (level) {
      LanguageLevel.A1 =>
        '您的基础还需要巩固。建议从A1级别开始系统学习，重点掌握基础语法和常用词汇。',
      LanguageLevel.A2 =>
        '您已经具备基础德语能力。建议继续A2级别的学习，扩展词汇量，掌握日常交流场景。',
      LanguageLevel.B1 =>
        '您已达到中级水平！建议进入B1级别，开始学习更复杂的语法结构和表达方式。',
      LanguageLevel.B2 =>
        '您的德语水平很好！可以开始B2级别的学习，向高级德语迈进。',
      _ => '继续努力！',
    };
  }
}
