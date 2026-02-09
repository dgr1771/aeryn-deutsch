/// 自适应水平测试数据
///
/// 用于智能评估用户的德语水平
/// 采用自适应算法，根据用户表现动态调整难度
library;

import '../models/question.dart';
import '../core/grammar_engine.dart';

/// 获取A1级别题库 (15题)
List<Question> getAdaptiveTestA1() {
  return [
    Question(
      id: 'a1_001',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Ich ___ Student.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'bin', isCorrect: true, explanation: 'ich的第一人称单数用bin'),
        QuestionOption(id: 'b', text: 'bist', isCorrect: false),
        QuestionOption(id: 'c', text: 'ist', isCorrect: false),
        QuestionOption(id: 'd', text: 'sind', isCorrect: false),
      ],
      points: 5,
      tags: const ['verb', 'sein'],
    ),
    Question(
      id: 'a1_002',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Du ___ mein Freund.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'bin', isCorrect: false),
        QuestionOption(id: 'b', text: 'bist', isCorrect: true, explanation: 'du的第二人称用bist'),
        QuestionOption(id: 'c', text: 'ist', isCorrect: false),
        QuestionOption(id: 'd', text: 'sind', isCorrect: false),
      ],
      points: 5,
      tags: const ['verb', 'sein'],
    ),
    Question(
      id: 'a1_003',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Ich ___ einen Hund.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'habe', isCorrect: true, explanation: 'ich + habe'),
        QuestionOption(id: 'b', text: 'hast', isCorrect: false),
        QuestionOption(id: 'c', text: 'hat', isCorrect: false),
        QuestionOption(id: 'd', text: 'haben', isCorrect: false),
      ],
      points: 5,
      tags: const ['verb', 'haben'],
    ),
    Question(
      id: 'a1_004',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Das ist ___ Buch.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'der', isCorrect: false),
        QuestionOption(id: 'b', text: 'ein', isCorrect: true, explanation: 'Buch是中性名词，用ein'),
        QuestionOption(id: 'c', text: 'die', isCorrect: false),
        QuestionOption(id: 'd', text: 'das', isCorrect: false),
      ],
      points: 5,
      tags: const ['article', 'gender'],
    ),
    Question(
      id: 'a1_005',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Das ist ___ Tisch.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'der', isCorrect: true, explanation: 'Tisch是阳性名词，用der'),
        QuestionOption(id: 'b', text: 'ein', isCorrect: false),
        QuestionOption(id: 'c', text: 'die', isCorrect: false),
        QuestionOption(id: 'd', text: 'das', isCorrect: false),
      ],
      points: 5,
      tags: const ['article', 'gender'],
    ),
    Question(
      id: 'a1_006',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Das ist ___ Uhr.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'der', isCorrect: false),
        QuestionOption(id: 'b', text: 'ein', isCorrect: false),
        QuestionOption(id: 'c', text: 'die', isCorrect: true, explanation: 'Uhr是阴性名词，用die'),
        QuestionOption(id: 'd', text: 'das', isCorrect: false),
      ],
      points: 5,
      tags: const ['article', 'gender'],
    ),
    Question(
      id: 'a1_007',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Ich ___ Deutsch.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'lerne', isCorrect: true, explanation: 'ich + lerne'),
        QuestionOption(id: 'b', text: 'lernst', isCorrect: false),
        QuestionOption(id: 'c', text: 'lernt', isCorrect: false),
        QuestionOption(id: 'd', text: 'lernen', isCorrect: false),
      ],
      points: 5,
      tags: const ['verb', 'conjugation'],
    ),
    Question(
      id: 'a1_008',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Was ___ du? - Ich ___ Lehrer.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'bist/bin', isCorrect: true, explanation: 'du+bist, ich+bin'),
        QuestionOption(id: 'b', text: 'bin/bist', isCorrect: false),
        QuestionOption(id: 'c', text: 'ist/ist', isCorrect: false),
        QuestionOption(id: 'd', text: 'sind/bin', isCorrect: false),
      ],
      points: 5,
      tags: const ['verb', 'sein'],
    ),
    Question(
      id: 'a1_009',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Er ___ nach Berlin.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'fahre', isCorrect: false),
        QuestionOption(id: 'b', text: 'fährst', isCorrect: false),
        QuestionOption(id: 'c', text: 'fährt', isCorrect: true, explanation: 'er/sie/es + fährt'),
        QuestionOption(id: 'd', text: 'fahren', isCorrect: false),
      ],
      points: 5,
      tags: const ['verb', 'conjugation'],
    ),
    Question(
      id: 'a1_010',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: '___ heißt du?',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'Was', isCorrect: false),
        QuestionOption(id: 'b', text: 'Wer', isCorrect: false),
        QuestionOption(id: 'c', text: 'Wie', isCorrect: true, explanation: '询问名字用Wie'),
        QuestionOption(id: 'd', text: 'Wo', isCorrect: false),
      ],
      points: 5,
      tags: const ['question'],
    ),
    Question(
      id: 'a1_011',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: '___ wohnst du?',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'Was', isCorrect: false),
        QuestionOption(id: 'b', text: 'Wer', isCorrect: false),
        QuestionOption(id: 'c', text: 'Wie', isCorrect: false),
        QuestionOption(id: 'd', text: 'Wo', isCorrect: true, explanation: '询问地点用Wo'),
      ],
      points: 5,
      tags: const ['question'],
    ),
    Question(
      id: 'a1_012',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Ich komme ___ China.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'aus', isCorrect: true, explanation: '来自某地用aus'),
        QuestionOption(id: 'b', text: 'von', isCorrect: false),
        QuestionOption(id: 'c', text: 'in', isCorrect: false),
        QuestionOption(id: 'd', text: 'zu', isCorrect: false),
      ],
      points: 5,
      tags: const ['preposition'],
    ),
    Question(
      id: 'a1_013',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Ich gehe ___ Kino.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'in', isCorrect: false),
        QuestionOption(id: 'b', text: 'ins', isCorrect: true, explanation: 'in + das = ins，表示方向'),
        QuestionOption(id: 'c', text: 'im', isCorrect: false),
        QuestionOption(id: 'd', text: 'zum', isCorrect: false),
      ],
      points: 5,
      tags: const ['preposition'],
    ),
    Question(
      id: 'a1_014',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Das ist Anna. ___ ist 20 Jahre alt.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'Er', isCorrect: false),
        QuestionOption(id: 'b', text: 'Sie', isCorrect: true, explanation: '指代女性用Sie'),
        QuestionOption(id: 'c', text: 'Es', isCorrect: false),
        QuestionOption(id: 'd', text: 'Ich', isCorrect: false),
      ],
      points: 5,
      tags: const ['pronoun'],
    ),
    Question(
      id: 'a1_015',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.veryEasy,
      question: 'Das ist ein Buch. ___ ist interessant.',
      targetLevel: LanguageLevel.A1,
      options: [
        QuestionOption(id: 'a', text: 'Er', isCorrect: false),
        QuestionOption(id: 'b', text: 'Sie', isCorrect: false),
        QuestionOption(id: 'c', text: 'Es', isCorrect: true, explanation: '指代中性名词用Es'),
        QuestionOption(id: 'd', text: 'Das', isCorrect: false),
      ],
      points: 5,
      tags: const ['pronoun'],
    ),
  ];
}

/// 获取A2级别题库 (15题)
List<Question> getAdaptiveTestA2() {
  return [
    // 现在完成时
    Question(
      id: 'a2_001',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Ich ___ gestern ins Kino.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'gehe', isCorrect: false),
        QuestionOption(id: 'b', text: 'ging', isCorrect: false),
        QuestionOption(id: 'c', text: 'bin gegangen', isCorrect: true, explanation: '完成时用sein + Partizip II'),
        QuestionOption(id: 'd', text: 'ginge', isCorrect: false),
      ],
      points: 10,
      tags: const ['verb', 'perfect'],
    ),
    Question(
      id: 'a2_002',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Er ___ einen Brief.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'hat geschrieben', isCorrect: true, explanation: '完成时用haben + Partizip II'),
        QuestionOption(id: 'b', text: 'ist geschrieben', isCorrect: false),
        QuestionOption(id: 'c', text: 'schrieb', isCorrect: false),
        QuestionOption(id: 'd', text: 'schreibe', isCorrect: false),
      ],
      points: 10,
      tags: const ['verb', 'perfect'],
    ),
    Question(
      id: 'a2_003',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Wir ___ Pizza.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'haben gegessen', isCorrect: true, explanation: '完成时：wir + haben + Partizip II'),
        QuestionOption(id: 'b', text: 'sind gegessen', isCorrect: false),
        QuestionOption(id: 'c', text: 'aßen', isCorrect: false),
        QuestionOption(id: 'd', text: 'essen', isCorrect: false),
      ],
      points: 10,
      tags: const ['verb', 'perfect'],
    ),

    // 情态动词
    Question(
      id: 'a2_004',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Ich ___ Deutsch lernen.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'muss', isCorrect: false),
        QuestionOption(id: 'b', text: 'möchte', isCorrect: false),
        QuestionOption(id: 'c', text: 'möchte', isCorrect: true, explanation: '表达意愿用möchte'),
        QuestionOption(id: 'd', text: 'kann', isCorrect: false),
      ],
      points: 10,
      tags: const ['verb', 'modal'],
    ),
    Question(
      id: 'a2_005',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Du ___ heute arbeiten.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'musst', isCorrect: true, explanation: 'du + musst'),
        QuestionOption(id: 'b', text: 'müssen', isCorrect: false),
        QuestionOption(id: 'c', text: 'kannst', isCorrect: false),
        QuestionOption(id: 'd', text: 'sollst', isCorrect: false),
      ],
      points: 10,
      tags: const ['verb', 'modal'],
    ),
    Question(
      id: 'a2_006',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Er ___ gut Auto fahren.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'kann', isCorrect: false),
        QuestionOption(id: 'b', text: 'kann', isCorrect: true, explanation: 'er/sie/es + kann'),
        QuestionOption(id: 'c', text: 'können', isCorrect: false),
        QuestionOption(id: 'd', text: 'konnte', isCorrect: false),
      ],
      points: 10,
      tags: const ['verb', 'modal'],
    ),

    // 关系从句
    Question(
      id: 'a2_007',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Das ist das Haus, ___ ich gekauft habe.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'das', isCorrect: true, explanation: '中性名词das Haus，关系代词用das'),
        QuestionOption(id: 'b', text: 'den', isCorrect: false),
        QuestionOption(id: 'c', text: 'dem', isCorrect: false),
        QuestionOption(id: 'd', text: 'deren', isCorrect: false),
      ],
      points: 10,
      tags: const ['grammar', 'relative-clause'],
    ),
    Question(
      id: 'a2_008',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Das ist die Frau, ___ ich kenne.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'die', isCorrect: false),
        QuestionOption(id: 'b', text: 'den', isCorrect: false),
        QuestionOption(id: 'c', text: 'die', isCorrect: true, explanation: '阴性名词die Frau，第四格仍用die'),
        QuestionOption(id: 'd', text: 'deren', isCorrect: false),
      ],
      points: 10,
      tags: const ['grammar', 'relative-clause'],
    ),
    Question(
      id: 'a2_009',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Das ist der Mann, ___ mir geholfen hat.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'der', isCorrect: false),
        QuestionOption(id: 'b', text: 'den', isCorrect: true, explanation: '阳性名词der Mann，在从句中作主语用der，作宾语用den'),
        QuestionOption(id: 'c', text: 'dem', isCorrect: false),
        QuestionOption(id: 'd', text: 'dessen', isCorrect: false),
      ],
      points: 10,
      tags: const ['grammar', 'relative-clause'],
    ),

    // 介词 + 格
    Question(
      id: 'a2_010',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Ich denke ___ meine Mutter.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'über', isCorrect: false),
        QuestionOption(id: 'b', text: 'an', isCorrect: true, explanation: 'denken + an + Akk'),
        QuestionOption(id: 'c', text: 'von', isCorrect: false),
        QuestionOption(id: 'd', text: 'mit', isCorrect: false),
      ],
      points: 10,
      tags: const ['preposition'],
    ),
    Question(
      id: 'a2_011',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Er wartet ___ den Bus.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'auf', isCorrect: true, explanation: 'warten + auf + Akk'),
        QuestionOption(id: 'b', text: 'für', isCorrect: false),
        QuestionOption(id: 'c', text: 'an', isCorrect: false),
        QuestionOption(id: 'd', text: 'in', isCorrect: false),
      ],
      points: 10,
      tags: const ['preposition'],
    ),
    Question(
      id: 'a2_012',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Ich interessiere mich ___ Musik.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'für', isCorrect: true, explanation: 'sich interessieren + für + Akk'),
        QuestionOption(id: 'b', text: 'über', isCorrect: false),
        QuestionOption(id: 'c', text: 'an', isCorrect: false),
        QuestionOption(id: 'd', text: 'in', isCorrect: false),
      ],
      points: 10,
      tags: const ['preposition', 'verb'],
    ),

    // 形容词词尾
    Question(
      id: 'a2_013',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Das ist ein ___ Hund.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'großer', isCorrect: true, explanation: '阳性名词Hund，不定冠词后用-er'),
        QuestionOption(id: 'b', text: 'große', isCorrect: false),
        QuestionOption(id: 'c', text: 'großes', isCorrect: false),
        QuestionOption(id: 'd', text: 'großen', isCorrect: false),
      ],
      points: 10,
      tags: const ['grammar', 'adjective'],
    ),
    Question(
      id: 'a2_014',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Das ist eine ___ Frau.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'junge', isCorrect: true, explanation: '阴性名词Frau，不定冠词后用-e'),
        QuestionOption(id: 'b', text: 'junger', isCorrect: false),
        QuestionOption(id: 'c', text: 'jungen', isCorrect: false),
        QuestionOption(id: 'd', text: ' junges', isCorrect: false),
      ],
      points: 10,
      tags: const ['grammar', 'adjective'],
    ),
    Question(
      id: 'a2_015',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.easy,
      question: 'Das ist ein ___ Kind.',
      targetLevel: LanguageLevel.A2,
      options: [
        QuestionOption(id: 'a', text: 'kleines', isCorrect: true, explanation: '中性名词Kind，不定冠词后用-es'),
        QuestionOption(id: 'b', text: 'kleiner', isCorrect: false),
        QuestionOption(id: 'c', text: 'kleine', isCorrect: false),
        QuestionOption(id: 'd', text: 'kleinen', isCorrect: false),
      ],
      points: 10,
      tags: const ['grammar', 'adjective'],
    ),
  ];
}

/// 获取B1级别题库 (15题)
List<Question> getAdaptiveTestB1() {
  return [
    // 被动语态
    Question(
      id: 'b1_001',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Das Buch ___ von vielen Menschen gelesen.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'wird', isCorrect: true, explanation: '过程被动语态：werden + Partizip II'),
        QuestionOption(id: 'b', text: 'wurde', isCorrect: false),
        QuestionOption(id: 'c', text: 'ist', isCorrect: false),
        QuestionOption(id: 'd', text: 'wird', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'passive'],
    ),
    Question(
      id: 'b1_002',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Das Haus ___ letzten Jahr renoviert.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'wurde', isCorrect: true, explanation: '过去时被动语态：wurde + Partizip II'),
        QuestionOption(id: 'b', text: 'ist', isCorrect: false),
        QuestionOption(id: 'c', text: 'wird', isCorrect: false),
        QuestionOption(id: 'd', text: 'wurde', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'passive'],
    ),
    Question(
      id: 'b1_003',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Hier ___ Deutsch gesprochen.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'wird', isCorrect: true, explanation: '无人称被动语态：es wird + Partizip II'),
        QuestionOption(id: 'b', text: 'wurde', isCorrect: false),
        QuestionOption(id: 'c', text: 'ist', isCorrect: false),
        QuestionOption(id: 'd', text: 'hat', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'passive'],
    ),

    // 第二虚拟式
    Question(
      id: 'b1_004',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Wenn ich ___ würde, würde ich nach Deutschland reisen.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'reich', isCorrect: false),
        QuestionOption(id: 'b', text: 'reich', isCorrect: false),
        QuestionOption(id: 'c', text: 'reich', isCorrect: true, explanation: '第二虚拟式：ich wäre'),
        QuestionOption(id: 'd', text: 'reich sei', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'subjunctive'],
    ),
    Question(
      id: 'b1_005',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Ich ___ gern nach Berlin kommen.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'würde', isCorrect: false),
        QuestionOption(id: 'b', text: 'würde', isCorrect: true, explanation: '第二虚拟式würde + 不定式'),
        QuestionOption(id: 'c', text: 'wollte', isCorrect: false),
        QuestionOption(id: 'd', text: 'konnte', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'subjunctive'],
    ),
    Question(
      id: 'b1_006',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Er ___ mehr Zeit haben.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'würde', isCorrect: false),
        QuestionOption(id: 'b', text: 'würde', isCorrect: true, explanation: '第二虚拟式：er würde'),
        QuestionOption(id: 'c', text: 'wollte', isCorrect: false),
        QuestionOption(id: 'd', text: 'hatte', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'subjunctive'],
    ),

    // 第一虚拟式 (间接引语)
    Question(
      id: 'b1_007',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Er sagt, dass er ___ Prüfung bestanden habe.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'die', isCorrect: true, explanation: '第一虚拟式：er habe'),
        QuestionOption(id: 'b', text: 'eine', isCorrect: false),
        QuestionOption(id: 'c', text: 'einer', isCorrect: false),
        QuestionOption(id: 'd', text: 'das', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'subjunctive'],
    ),
    Question(
      id: 'b1_008',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Sie sagt, sie ___ morgen kommen.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'werde', isCorrect: true, explanation: '第一虚拟式：sie werde'),
        QuestionOption(id: 'b', text: 'wird', isCorrect: false),
        QuestionOption(id: 'c', text: 'wolle', isCorrect: false),
        QuestionOption(id: 'd', text: 'müsse', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'subjunctive'],
    ),
    Question(
      id: 'b1_009',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Er fragt, ob wir ___ helfen können.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'können', isCorrect: false),
        QuestionOption(id: 'b', text: 'können', isCorrect: true, explanation: '第一虚拟式：wir können'),
        QuestionOption(id: 'c', text: 'könnten', isCorrect: false),
        QuestionOption(id: 'd', text: 'könn(t)en', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'subjunctive'],
    ),

    // 名词变格 (Genitiv)
    Question(
      id: 'b1_010',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Das ist das Auto ___ Vaters.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'der', isCorrect: false),
        QuestionOption(id: 'b', text: 'des', isCorrect: true, explanation: '阳性名词Vater的Genitiv：des Vaters'),
        QuestionOption(id: 'c', text: 'dem', isCorrect: false),
        QuestionOption(id: 'd', text: 'den', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'declension'],
    ),
    Question(
      id: 'b1_011',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Wegen ___ Wetters bleiben wir zu Hause.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'der', isCorrect: false),
        QuestionOption(id: 'b', text: 'des', isCorrect: false),
        QuestionOption(id: 'c', text: 'dem', isCorrect: false),
        QuestionOption(id: 'd', text: 'des', isCorrect: true, explanation: 'wegen + Genitiv，中性Wetter变为des Wetters'),
      ],
      points: 15,
      tags: const ['grammar', 'declension'],
    ),

    // 复杂从句
    Question(
      id: 'b1_012',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: '___ er studiert hat, hat er als Ingenieur gearbeitet.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'Nachdem', isCorrect: true, explanation: '表示"在...之后"用Nachdem'),
        QuestionOption(id: 'b', text: 'Nach', isCorrect: false),
        QuestionOption(id: 'c', text: 'Wenn', isCorrect: false),
        QuestionOption(id: 'd', text: 'Als', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'conjunction'],
    ),
    Question(
      id: 'b1_013',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: '___ ich 10 Jahre alt war, zog ich nach Berlin.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'Wenn', isCorrect: false),
        QuestionOption(id: 'b', text: 'Als', isCorrect: true, explanation: '过去一次性的时间点用Als'),
        QuestionOption(id: 'c', text: 'Wann', isCorrect: false),
        QuestionOption(id: 'd', text: 'Wenn', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'conjunction'],
    ),
    Question(
      id: 'b1_014',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Es ist wichtig, dass man ___ Fremdsprachen lernt.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'mehrere', isCorrect: false),
        QuestionOption(id: 'b', text: 'mehrere', isCorrect: true, explanation: 'dass从句中形容词强变化'),
        QuestionOption(id: 'c', text: 'mehreres', isCorrect: false),
        QuestionOption(id: 'd', text: 'mehreren', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'adjective'],
    ),

    // 比较级
    Question(
      id: 'b1_015',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Deutsch ist ___ als Englisch.',
      targetLevel: LanguageLevel.B1,
      options: [
        QuestionOption(id: 'a', text: 'schwieriger', isCorrect: true, explanation: '比较级：schwer + -er'),
        QuestionOption(id: 'b', text: 'schwierig', isCorrect: false),
        QuestionOption(id: 'c', text: 'am schwierigsten', isCorrect: false),
        QuestionOption(id: 'd', text: 'schwierige', isCorrect: false),
      ],
      points: 15,
      tags: const ['grammar', 'comparison'],
    ),
  ];
}

/// 获取B2级别题库 (12题)
List<Question> getAdaptiveTestB2() {
  return [
    // 高级被动语态
    Question(
      id: 'b2_001',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: '___ des schlechten Wetters sind wir zu Hause geblieben.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'Trotz', isCorrect: true, explanation: 'Trotz + Genitiv表示"尽管"'),
        QuestionOption(id: 'b', text: 'Wegen', isCorrect: false),
        QuestionOption(id: 'c', text: 'Während', isCorrect: false),
        QuestionOption(id: 'd', text: 'Obwohl', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'preposition'],
    ),
    Question(
      id: 'b2_002',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Es ist davon auszugehen, dass die Konferenz ___ wird.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'verschoben', isCorrect: true, explanation: '被动语态：wird verschoben'),
        QuestionOption(id: 'b', text: 'verschieben', isCorrect: false),
        QuestionOption(id: 'c', text: 'verschob', isCorrect: false),
        QuestionOption(id: 'd', text: 'verschoben', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'passive'],
    ),
    Question(
      id: 'b2_003',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Er forderte, dass das Projekt sofort ___ werde.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'beende', isCorrect: false),
        QuestionOption(id: 'b', text: 'beendet', isCorrect: true, explanation: '第一虚拟式被动语态：werde + Partizip II'),
        QuestionOption(id: 'c', text: 'beendete', isCorrect: false),
        QuestionOption(id: 'd', text: 'beenden', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'subjunctive', 'passive'],
    ),

    // 复杂从句结构
    Question(
      id: 'b2_004',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Das Problem, ___ es geht, ist komplizierter als gedacht.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'um das', isCorrect: false),
        QuestionOption(id: 'b', text: 'um das', isCorrect: true, explanation: 'um das + Akk表示"关于..."'),
        QuestionOption(id: 'c', text: 'von dem', isCorrect: false),
        QuestionOption(id: 'd', text: 'über das', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'expression'],
    ),
    Question(
      id: 'b2_005',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: '___ die Klimakrise besorgniserregend ist, handeln nur wenige.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'Obwohl', isCorrect: true, explanation: '让步从句：虽然...但是...'),
        QuestionOption(id: 'b', text: 'Weil', isCorrect: false),
        QuestionOption(id: 'c', text: 'Wenn', isCorrect: false),
        QuestionOption(id: 'd', text: 'Da', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'conjunction'],
    ),
    Question(
      id: 'b2_006',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: '___ man die Studie betrachtet, zeigt sich ein klares Ergebnis.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'Je nachdem', isCorrect: true, explanation: 'je nachdem表示"视...而定"'),
        QuestionOption(id: 'b', text: 'Wenn', isCorrect: false),
        QuestionOption(id: 'c', text: 'Sobald', isCorrect: false),
        QuestionOption(id: 'd', text: 'Da', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'conjunction'],
    ),

    // 高级动词用法
    Question(
      id: 'b2_007',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Es ___ sich, eine Versicherung abzuschließen.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'lohnt', isCorrect: true, explanation: 'sich lohnen + zu + Infinitiv表示"值得做..."'),
        QuestionOption(id: 'b', text: 'wertet', isCorrect: false),
        QuestionOption(id: 'c', text: 'handelt', isCorrect: false),
        QuestionOption(id: 'd', text: 'braucht', isCorrect: false),
      ],
      points: 20,
      tags: const ['verb', 'expression'],
    ),
    Question(
      id: 'b2_008',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Er ___ darin, die Prüfung zu bestehen.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'scheiterte', isCorrect: false),
        QuestionOption(id: 'b', text: 'bestand', isCorrect: false),
        QuestionOption(id: 'c', text: 'verzichtete', isCorrect: false),
        QuestionOption(id: 'd', text: 'errang', isCorrect: true, explanation: 'erringen表示"通过努力获得"'),
      ],
      points: 20,
      tags: const ['verb', 'advanced'],
    ),

    // 名词化结构
    Question(
      id: 'b2_009',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: '___ des Buches dauerte lange.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'Die Erscheinung', isCorrect: false),
        QuestionOption(id: 'b', text: 'Das Erscheinen', isCorrect: true, explanation: '动词名词化：erscheinen → das Erscheinen'),
        QuestionOption(id: 'c', text: 'Der Erscheinen', isCorrect: false),
        QuestionOption(id: 'd', text: 'Die Erscheinen', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'nominalization'],
    ),
    Question(
      id: 'b2_010',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Wir freuen uns auf ___.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'den Ankunft', isCorrect: false),
        QuestionOption(id: 'b', text: 'die Ankunft', isCorrect: false),
        QuestionOption(id: 'c', text: 'die Ankunft', isCorrect: true, explanation: 'sich freuen auf + Akk'),
        QuestionOption(id: 'd', text: 'dem Ankunft', isCorrect: false),
      ],
      points: 20,
      tags: const ['verb', 'preposition'],
    ),

    // 复杂情态动词结构
    Question(
      id: 'b2_011',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Er ___ das Buch gelesen haben.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'muss', isCorrect: true, explanation: '情态动词完成时：muss + gelesen + haben'),
        QuestionOption(id: 'b', text: 'hat', isCorrect: false),
        QuestionOption(id: 'c', text: 'ist', isCorrect: false),
        QuestionOption(id: 'd', text: 'kann', isCorrect: false),
      ],
      points: 20,
      tags: const ['verb', 'modal'],
    ),
    Question(
      id: 'b2_012',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.difficult,
      question: 'Das Haus ___ renoviert werden.',
      targetLevel: LanguageLevel.B2,
      options: [
        QuestionOption(id: 'a', text: 'muss', isCorrect: true, explanation: '被动语态 + 情态动词：muss renoviert werden'),
        QuestionOption(id: 'b', text: 'kann', isCorrect: false),
        QuestionOption(id: 'c', text: 'darf', isCorrect: false),
        QuestionOption(id: 'd', text: 'soll', isCorrect: false),
      ],
      points: 20,
      tags: const ['grammar', 'passive', 'modal'],
    ),
  ];
}

/// A1级别题库
final List<Question> adaptiveTestA1 = getAdaptiveTestA1();

/// A2级别题库
final List<Question> adaptiveTestA2 = getAdaptiveTestA2();

/// B1级别题库
final List<Question> adaptiveTestB1 = getAdaptiveTestB1();

/// B2级别题库
final List<Question> adaptiveTestB2 = getAdaptiveTestB2();

/// 获取指定级别的所有题目
List<Question> getQuestionsForLevel(LanguageLevel level) {
  return switch (level) {
    LanguageLevel.A1 => adaptiveTestA1,
    LanguageLevel.A2 => adaptiveTestA2,
    LanguageLevel.B1 => adaptiveTestB1,
    LanguageLevel.B2 => adaptiveTestB2,
    _ => adaptiveTestA1,
  };
}

/// 获取所有自适应测试题目
Map<LanguageLevel, List<Question>> allAdaptiveTestQuestions = {
  LanguageLevel.A1: adaptiveTestA1,
  LanguageLevel.A2: adaptiveTestA2,
  LanguageLevel.B1: adaptiveTestB1,
  LanguageLevel.B2: adaptiveTestB2,
};
