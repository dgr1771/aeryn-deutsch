import 'dart:math';
import '../data/grammar_exercises.dart';

/// 语法操练引擎 - Grammar Exercise Engine
///
/// C2级别要求：完全掌握德语所有语法点
/// 包含3000+道分级练习题
class GrammarExerciseEngine {
  Random _random = Random();

  /// 获取指定等级和类型的练习题
  GrammarExercise generateExercise({
    required GrammarLevel level,
    required GrammarType type,
    int? seed,
  }) {
    if (seed != null) {
      _random = Random(seed);
    } else {
      _random = Random();
    }

    switch (type) {
      case GrammarType.kasus:
        return _generateKasusExercise(level);
      case GrammarType.verbConjugation:
        return _generateVerbConjugationExercise(level);
      case GrammarType.adjectiveEnding:
        return _generateAdjectiveEndingExercise(level);
      case GrammarType.subordinateClause:
        return _generateSubordinateClauseExercise(level);
      case GrammarType.passive:
        return _generatePassiveExercise(level);
      case GrammarType.konjunktiv:
        return _generateKonjunktivExercise(level);
      case GrammarType.preposition:
        return _generatePrepositionExercise(level);
      case GrammarType.sentenceStructure:
        return _generateSentenceStructureExercise(level);
    }
  }

  /// 生成格位练习
  GrammarExercise _generateKasusExercise(GrammarLevel level) {
    final exercises = _getKasusExercisesFromDatabase(level);
    if (exercises.isEmpty) {
      // 回退到内置题目
      return _generateFallbackKasusExercise(level);
    }
    final exercise = exercises[_random.nextInt(exercises.length)];

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.kasus,
      level: level,
      question: exercise['question'] as String,
      options: exercise['options'] as List<String>,
      correctAnswer: exercise['correct'] as String,
      explanation: exercise['explanation'] as String,
      grammarPoints: exercise['grammarPoints'] as List<String>,
    );
  }

  /// 从数据库获取格位练习
  List<Map<String, dynamic>> _getKasusExercisesFromDatabase(GrammarLevel level) {
    final levelStr = level.toString().split('.').last;
    return getKasusExercises(levelStr);
  }

  /// 回退方法：生成内置格位练习
  GrammarExercise _generateFallbackKasusExercise(GrammarLevel level) {
    final exercises = _getKasusExercises(level);
    final exercise = exercises[_random.nextInt(exercises.length)];

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.kasus,
      level: level,
      question: exercise['question'] as String,
      options: exercise['options'] as List<String>,
      correctAnswer: exercise['correct'] as String,
      explanation: exercise['explanation'] as String,
      grammarPoints: exercise['grammarPoints'] as List<String>,
    );
  }

  /// 生成动词变位练习
  GrammarExercise _generateVerbConjugationExercise(GrammarLevel level) {
    final verbs = _getVerbsByLevel(level);
    final verb = verbs[_random.nextInt(verbs.length)];
    final person = _random.nextInt(6); // 1-6人称
    final tenses = _getTenseByLevel(level);
    final moods = _getMoodByLevel(level);
    final tense = tenses[_random.nextInt(tenses.length)];
    final mood = moods[_random.nextInt(moods.length)];

    final question = _generateVerbQuestion(verb, person, tense, mood);
    final correct = _conjugateVerb(verb, person, tense, mood);

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.verbConjugation,
      level: level,
      question: question,
      correctAnswer: correct,
      explanation: _getVerbExplanation(verb, tense, mood),
      grammarPoints: ['动词变位', tense, mood],
    );
  }

  /// 生成形容词词尾练习
  GrammarExercise _generateAdjectiveEndingExercise(GrammarLevel level) {
    final templates = _getAdjectiveTemplates(level);
    final template = templates[_random.nextInt(templates.length)];

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.adjectiveEnding,
      level: level,
      question: template['question'] as String,
      options: template['options'] as List<String>,
      correctAnswer: template['correct'] as String,
      explanation: template['explanation'] as String,
      grammarPoints: template['grammarPoints'] as List<String>,
    );
  }

  /// 生成从句练习
  GrammarExercise _generateSubordinateClauseExercise(GrammarLevel level) {
    final mainClauses = [
      'Ich verstehe nicht',
      'Er weiß',
      'Sie fragt',
      'Wir hoffen',
      'Du musst sagen',
    ];

    final subConjunctions = _getSubConjunctions(level);
    final main = mainClauses[_random.nextInt(mainClauses.length)];
    final conjunction = subConjunctions[_random.nextInt(subConjunctions.length)];

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.subordinateClause,
      level: level,
      question: '"$main, ____ du morgen kommst?" (使用$conjunction)',
      correctAnswer: 'ob',
      options: ['ob', 'wenn', 'dass', 'weil'],
      explanation: '$conjunction引入间接问句或疑问从句',
      grammarPoints: ['从句', conjunction, 'Verbenendstellung'],
    );
  }

  /// 生成被动语态练习
  GrammarExercise _generatePassiveExercise(GrammarLevel level) {
    final activeTemplates = {
      GrammarLevel.A2: [
        {'active': 'Ich mache die Hausaufgaben', 'passive': 'Die Hausaufgaben werden gemacht'},
        {'active': 'Der Lehrer korrigiert den Test', 'passive': 'Der Test wird korrigiert'},
      ],
      GrammarLevel.B1: [
        {'active': 'Man baut ein neues Haus', 'passive': 'Ein neues Haus wird gebaut'},
        {'active': 'Der Arzt hat den Patienten untersucht', 'passive': 'Der Patient ist untersucht worden'},
      ],
      GrammarLevel.B2: [
        {'active': 'Die Regierung wird das Gesetz ändern', 'passive': 'Das Gesetz wird geändert werden'},
        {'active': 'Man hatte das Problem schon gelöst', 'passive': 'Das Problem war schon gelöst worden'},
      ],
      GrammarLevel.C1: [
        {'active': 'Er lässt sich die Haare schneiden', 'passive': 'Passiv mit lassen'},
        {'active': 'Das Buch liest sich gut', 'passive': 'Medianpassiv / Das Buch lässt sich gut lesen'},
      ],
    };

    final templates = activeTemplates[level] ?? activeTemplates[GrammarLevel.B2]!;
    final template = templates[_random.nextInt(templates.length)];

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.passive,
      level: level,
      question: '将下列句子改为被动语态: "${template['active']}"',
      correctAnswer: template['passive'],
      explanation: _getPassiveExplanation(level),
      grammarPoints: ['Passiv', 'werden + Partizip II'],
    );
  }

  /// 生成第二虚拟式练习
  GrammarExercise _generateKonjunktivExercise(GrammarLevel level) {
    if (level.index < GrammarLevel.B2.index) {
      // B2以下用基础礼貌表达
      return GrammarExercise(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: GrammarType.konjunktiv,
        level: level,
        question: '礼貌表达：我想要一杯咖啡',
        correctAnswer: 'Ich hätte gern einen Kaffee',
        explanation: '第二虚拟式用于礼貌表达，hätte是haben的Konjunktiv II',
        grammarPoints: ['Konjunktiv II', 'Höflichkeit'],
      );
    }

    // C1/C2：复杂的Konjunktiv用法
    final indirectSpeech = {
      'Er sagt: "Ich komme morgen"': 'Er sagt, dass er komme (或käme)',
      'Sie fragt: "Kannst du mir helfen?"': 'Sie fragt, ob ich ihr helfen könnte',
      'Er behauptet: "Ich habe das nicht getan"': 'Er behauptet, habe er das nicht getan',
    };

    final exercise = indirectSpeech.entries.elementAt(_random.nextInt(indirectSpeech.length));

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.konjunktiv,
      level: level,
      question: '改为间接引语: "${exercise.key}"',
      correctAnswer: exercise.value,
      explanation: '间接引语中使用Konjunktiv I，如果形式与直陈式相同则用Konjunktiv II',
      grammarPoints: ['Konjunktiv I/II', 'Indirekte Rede'],
    );
  }

  /// 生成介词练习
  GrammarExercise _generatePrepositionExercise(GrammarLevel level) {
    final prepExercises = {
      GrammarLevel.A2: [
        {
          'question': 'Ich denke ___ meine Familie (nachdenken + Akk)',
          'correct': 'an',
          'options': ['an', 'über', 'von', 'zu'],
          'explanation': 'nachdenken + an + Akkusativ',
        },
        {
          'question': 'Ich interessiere mich ___ Musik (interessieren + Akk)',
          'correct': 'für',
          'options': ['für', 'über', 'an', 'in'],
          'explanation': 'sich interessieren für + Akkusativ',
        },
      ],
      GrammarLevel.B1: [
        {
          'question': 'Wir stimmen ___ dem Vorschlag zu (stimmen + Dat)',
          'correct': 'zu',
          'options': ['zu', 'für', 'gegen', 'über'],
          'explanation': 'zustimmen + Dativ',
        },
        {
          'question': 'Er besteht ___ der Prüfung (bestehen + Dat)',
          'correct': 'auf',
          'options': ['auf', 'in', 'an', 'über'],
          'explanation': 'bestehen auf + Dativ',
        },
      ],
      GrammarLevel.B2: [
        {
          'question': 'Dieses Buch handelt ___ dem Krieg (handeln + Dat)',
          'correct': 'von',
          'options': ['von', 'über', 'an', 'in'],
          'explanation': 'handeln von + Dativ',
        },
      ],
    };

    final exercises = prepExercises[level] ?? prepExercises[GrammarLevel.B2]!;
    final exercise = exercises[_random.nextInt(exercises.length)];

    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.preposition,
      level: level,
      question: exercise['question'] as String,
      correctAnswer: exercise['correct'] as String,
      options: exercise['options'] as List<String>,
      explanation: exercise['explanation'] as String,
      grammarPoints: ['Präpositionen', 'Kasus'],
    );
  }

  /// 生成句法结构练习
  GrammarExercise _generateSentenceStructureExercise(GrammarLevel level) {
    if (level.index >= GrammarLevel.C1.index) {
      // C1/C2: 复杂的Schachtelsätze（套娃句）
      return GrammarExercise(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: GrammarType.sentenceStructure,
        level: level,
        question: '组合从句: "Der Mann (den ich gestern gesehen habe) sagt (dass er (wenn er Zeit hat) kommen wird)"',
        correctAnswer: 'Der Mann, den ich gestern gesehen habe, sagt, dass er kommen wird, wenn er Zeit hat.',
        explanation: 'C2级别的多重从句嵌套：关系从句 + dass从句 + wenn从句',
        grammarPoints: ['Schachtelsatz', 'Nebensätze', 'Relativsatz'],
      );
    }

    // B1/B2: 基础从句位置
    return GrammarExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: GrammarType.sentenceStructure,
      level: level,
      question: '完成句子: "Wenn ich Zeit ___, ich ___ dich besuchen."',
      correctAnswer: 'habe;werde',
      options: ['habe;werde', 'habe;komme', 'habe;kam', 'hat;werde'],
      explanation: 'wenn从句中动词在末位，主句用werden + 不定式构成将来时',
      grammarPoints: ['Wenn-Satz', 'Verbenendstellung', 'Futur'],
    );
  }

  // ==================== 私有辅助方法 ====================

  Map<String, dynamic> _getKasusExercises(GrammarLevel level) {
    final exercises = {
      GrammarLevel.A2: [
        {
          'question': 'Der Mann gibt ___ Frau einen Apfel (die)',
          'options': ['der', 'die', 'dem', 'den'],
          'correct': 'der',
          'explanation': 'geben + Dativ (人) + Akkusativ (物)。Frau作为接收者是Dativ，阴性Dativ冠词是der',
          'grammarPoints': ['Dativ', 'Akkusativ', 'Drei-4-Prinzip'],
        },
        {
          'question': 'Ich sehe ___ Hund (der)',
          'options': ['der', 'die', 'das', 'den'],
          'correct': 'den',
          'explanation': 'sehen + Akkusativ。阳性Akkusativ冠词是den',
          'grammarPoints': ['Akkusativ', 'Bestimmter Artikel'],
        },
      ],
      GrammarLevel.B1: [
        {
          'question': 'Ich helfe ___ Mann (der)',
          'options': ['der', 'die', 'dem', 'den'],
          'correct': 'dem',
          'explanation': 'helfen + Dativ。阳性Dativ冠词是dem',
          'grammarPoints': ['Dativ', 'Unregelmäßiges Verb'],
        },
        {
          'question': 'Wir gedenken ___ Opfer (das)',
          'options': ['der', 'die', 'dem', 'den'],
          'correct': 'der',
          'explanation': 'gedenken + Genitiv。中性Genitiv冠词是der',
          'grammarPoints': ['Genitiv', 'Gehobener Stil'],
        },
      ],
      GrammarLevel.B2: [
        {
          'question': 'Sie ist ___ Meinung (mein)',
          'options': ['meiner', 'meinen', 'meinem', 'mein'],
          'correct': 'meiner',
          'explanation': 'der Meinung sein + Dativ。mein在阴性Dativ中变为meiner',
          'grammarPoints': ['Possessivartikel', 'Dativ', 'Feste Wendung'],
        },
      ],
      GrammarLevel.C1: [
        {
          'question': 'Wegen ___ Wetters (das) blieben wir zu Hause',
          'options': ['des', 'dem', 'den', 'das'],
          'correct': 'des',
          'explanation': 'wegen + Genitiv。中性Genitiv冠词是des（加s）',
          'grammarPoints': ['Genitiv', 'Präposition', 'Kausal'],
        },
      ],
    };

    return exercises[level]?.elementAt(_random.nextInt(exercises[level]!.length))
        ?? exercises[GrammarLevel.B2]!.first;
  }

  List<String> _getVerbsByLevel(GrammarLevel level) {
    final verbMap = {
      GrammarLevel.A1: ['sein', 'haben', 'werden', 'kommen', 'gehen'],
      GrammarLevel.A2: ['sprechen', 'arbeiten', 'lernen', 'essen', 'trinken'],
      GrammarLevel.B1: ['verstehen', 'erklären', 'beschließen', 'gewinnen', 'sterben'],
      GrammarLevel.B2: ['bestehen', 'auffassen', 'mitmachen', 'stattfinden', 'zulassen'],
      GrammarLevel.C1: ['vermuten', 'aufgreifen', 'hervorheben', 'zurückführen', 'betrachten'],
      GrammarLevel.C2: ['problematisieren', 'spezifizieren', 'implementieren', 'optimieren', 'adaptieren'],
    };

    return verbMap[level] ?? verbMap[GrammarLevel.B2]!;
  }

  List<String> _getTenseByLevel(GrammarLevel level) {
    if (level.index <= GrammarLevel.A2.index) {
      return ['Präsens', 'Perfekt'];
    } else if (level.index <= GrammarLevel.B2.index) {
      return ['Präsens', 'Perfekt', 'Präteritum', 'Futur I'];
    } else {
      return ['Präsens', 'Perfekt', 'Präteritum', 'Plusquamperfekt', 'Futur I', 'Futur II'];
    }
  }

  List<String> _getMoodByLevel(GrammarLevel level) {
    if (level.index < GrammarLevel.B2.index) {
      return ['Indikativ'];
    } else {
      return ['Indikativ', 'Konjunktiv I', 'Konjunktiv II'];
    }
  }

  String _generateVerbQuestion(String verb, int person, String tense, String mood) {
    final pronouns = ['ich', 'du', 'er/sie/es', 'wir', 'ihr', 'sie/Sie'];
    return '请变位: "$verb" (${pronouns[person]}, $tense, $mood)';
  }

  String _conjugateVerb(String verb, int person, String tense, String mood) {
    // 简化版变位逻辑（实际应用中需要完整动词数据库）
    if (verb == 'sein' && tense == 'Präsens' && mood == 'Indikativ') {
      return ['bin', 'bist', 'ist', 'sind', 'seid', 'sind'][person];
    }
    if (verb == 'haben' && tense == 'Präsens' && mood == 'Indikativ') {
      return ['habe', 'hast', 'hat', 'haben', 'habt', 'haben'][person];
    }
    // 默认规则动词变位
    return '${verb}_${person}_$tense';
  }

  String _getVerbExplanation(String verb, String tense, String mood) {
    return '动词"$verb"的$tense时态，$mood语气';
  }

  List<Map<String, dynamic>> _getAdjectiveTemplates(GrammarLevel level) {
    return [
      {
        'question': 'Der ___ Mann (alt)',
        'correct': 'alte',
        'options': ['alter', 'alte', 'altes', 'alten'],
        'explanation': '定冠词+阳性+主格：形容词加弱变化词尾-e',
        'grammarPoints': ['Adjektivendigung', 'Schwache Deklination'],
      },
    ];
  }

  List<String> _getSubConjunctions(GrammarLevel level) {
    if (level.index <= GrammarLevel.A2.index) {
      return ['weil', 'dass', 'ob', 'wenn'];
    } else {
      return ['weil', 'dass', 'ob', 'wenn', 'obwohl', 'während', 'nachdem', 'sobald'];
    }
  }

  String _getPassiveExplanation(GrammarLevel level) {
    if (level.index <= GrammarLevel.A2.index) {
      return '被动语态 = werden + Partizip II (过程被动)';
    } else if (level.index <= GrammarLevel.B2.index) {
      return '被动语态 = werden/sein + Partizip II (过程被动/状态被动)';
    } else {
      return '高级被动：Medianpassiv (Das Buch liest sich gut) + 被动替代形式 (Es lässt sich machen)';
    }
  }

  /// 生成每日练习套餐
  ExercisePackage generateDailyPackage({
    required GrammarLevel userLevel,
    int exercisesPerDay = 20,
  }) {
    final exercises = <GrammarExercise>[];

    // 根据等级分配题型
    final types = _getTypesForLevel(userLevel);

    for (int i = 0; i < exercisesPerDay; i++) {
      final type = types[i % types.length];
      exercises.add(generateExercise(
        level: userLevel,
        type: type,
        seed: DateTime.now().millisecondsSinceEpoch + i,
      ));
    }

    return ExercisePackage(
      date: DateTime.now(),
      level: userLevel,
      exercises: exercises,
      estimatedMinutes: exercisesPerDay * 3,
    );
  }

  List<GrammarType> _getTypesForLevel(GrammarLevel level) {
    if (level.index <= GrammarLevel.A2.index) {
      return [
        GrammarType.kasus,
        GrammarType.verbConjugation,
        GrammarType.adjectiveEnding,
      ];
    } else if (level.index <= GrammarLevel.B2.index) {
      return [
        GrammarType.kasus,
        GrammarType.verbConjugation,
        GrammarType.adjectiveEnding,
        GrammarType.subordinateClause,
        GrammarType.passive,
        GrammarType.preposition,
      ];
    } else {
      return GrammarType.values;
    }
  }

  /// 评估用户答案
  ExerciseResult evaluateAnswer({
    required GrammarExercise exercise,
    required String userAnswer,
    required int timeSpentSeconds,
  }) {
    final correctAnswer = exercise.correctAnswer ?? '';
    final isCorrect = userAnswer.trim().toLowerCase() == correctAnswer.toLowerCase();

    // 计算难度调整后的得分
    double adjustedScore = isCorrect ? 100.0 : 0.0;

    if (isCorrect) {
      // 快速回答加分
      if (timeSpentSeconds < 10) {
        adjustedScore += 10;
      }
    } else {
      // 部分正确（相似度高）
      final correctAnswer = exercise.correctAnswer ?? '';
      final similarity = _calculateSimilarity(userAnswer, correctAnswer);
      if (similarity > 0.7) {
        adjustedScore = similarity * 50;
      }
    }

    return ExerciseResult(
      exerciseId: exercise.id,
      isCorrect: isCorrect,
      userAnswer: userAnswer,
      correctAnswer: exercise.correctAnswer ?? '',
      score: adjustedScore.clamp(0, 100),
      timeSpentSeconds: timeSpentSeconds,
      explanation: isCorrect ? null : exercise.explanation,
      grammarPoints: exercise.grammarPoints,
    );
  }

  double _calculateSimilarity(String a, String b) {
    // 简化的相似度计算（实际应用中可用更复杂的算法）
    if (a.toLowerCase() == b.toLowerCase()) return 1.0;
    if (a.toLowerCase().contains(b.toLowerCase()) || b.toLowerCase().contains(a.toLowerCase())) {
      return 0.8;
    }
    final wordsA = a.toLowerCase().split(' ');
    final wordsB = b.toLowerCase().split(' ');
    final common = wordsA.where((w) => wordsB.contains(w)).length;
    return common / (wordsA.length + wordsB.length - common);
  }
}

// ==================== 数据模型 ====================

enum GrammarLevel {
  A1, A2, B1, B2, C1, C2,
}

enum GrammarType {
  kasus,              // 格位
  verbConjugation,    // 动词变位
  adjectiveEnding,    // 形容词词尾
  subordinateClause,  // 从句
  passive,            // 被动语态
  konjunktiv,         // 虚拟式
  preposition,        // 介词
  sentenceStructure,  // 句法结构
}

class GrammarExercise {
  final String id;
  final GrammarType type;
  final GrammarLevel level;
  final String question;
  final String? correctAnswer;
  final List<String>? options;
  final String? explanation;
  final List<String>? grammarPoints;

  GrammarExercise({
    required this.id,
    required this.type,
    required this.level,
    required this.question,
    this.correctAnswer,
    this.options,
    this.explanation,
    this.grammarPoints,
  });

  bool get isMultipleChoice => options != null && options!.isNotEmpty;
}

class ExercisePackage {
  final DateTime date;
  final GrammarLevel level;
  final List<GrammarExercise> exercises;
  final int estimatedMinutes;

  ExercisePackage({
    required this.date,
    required this.level,
    required this.exercises,
    required this.estimatedMinutes,
  });

  int get totalExercises => exercises.length;
}

class ExerciseResult {
  final String exerciseId;
  final bool isCorrect;
  final String userAnswer;
  final String correctAnswer;
  final double score;
  final int timeSpentSeconds;
  final String? explanation;
  final List<String>? grammarPoints;

  ExerciseResult({
    required this.exerciseId,
    required this.isCorrect,
    required this.userAnswer,
    required this.correctAnswer,
    required this.score,
    required this.timeSpentSeconds,
    this.explanation,
    this.grammarPoints,
  });
}
