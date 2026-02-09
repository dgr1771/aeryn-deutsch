import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

/// 口语输出系统 - Oral Production System (C2级别)
///
/// 覆盖场景：
/// - 学术讨论（5星流利度）
/// - 医疗描述（5星流利度）
/// - 政治讨论（5星流利度）
/// - 冲突解决（5星流利度）
class OralProductionSystem {
  final Random _random = Random();

  /// 生成C2级别的口语任务
  OralTask generateC2Task({required ScenarioType scenarioType}) {
    switch (scenarioType) {
      case ScenarioType.academic:
        return _generateAcademicTaskC2();
      case ScenarioType.medical:
        return _generateMedicalTaskC2();
      case ScenarioType.political:
        return _generatePoliticalTaskC2();
      case ScenarioType.conflict:
        return _generateConflictTaskC2();
      case ScenarioType.casual:
        return _generateCasualTaskC2();
      case ScenarioType.professional:
        return _generateProfessionalTaskC2();
    }
  }

  /// C2级别：学术讨论任务（目标5星流利度）
  OralTask _generateAcademicTaskC2() {
    final topics = [
      'Epistemologische Implikationen der KI im wissenschaftlichen Erkenntnisprozess',
      'Postkoloniale Theorie im Kontext der globalen Migration',
      'Die ETHikalgorithmischer Governance in demokratischen Gesellschaften',
      'Interdisziplinäre Perspektiven auf die Klimakrise',
      'Quantenmechanik und philosophisches Verständnis der Realität',
    ];

    final topic = topics[_random.nextInt(topics.length)];

    return OralTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioType: ScenarioType.academic,
      level: CEFRLevel.C2,
      title: 'Akademische Keynote: $topic',
      description: '你将在国际学术会议上发表15分钟的主旨演讲',
      targetLengthMinutes: 15,
      context: '''
        Sie halten eine Hauptrede auf einer internationalen Konferenz.
        Das Publikum besteht aus führenden Experten Ihres Fachgebiets.

        Anforderungen:
        1. Theoretische Fundierung (引用相关理论)
        2. Methodologische Reflexion (方法论反思)
        3. Empirische Evidenz (实证证据)
        4. Kritische Auseinandersetzung (批判性讨论)
        5. Ausblick und Implikationen (展望与启示)

        Stilhöhe: Akademisch-gehoben
        Register: Fachsprachlich präzise
      ''',
      keyVocabulary: _getAcademicVocabularyC2(),
      grammarFocus: [
        'Nominalisierungen',
        'Funktionsverbgefüge',
        'Passiversatzformen',
        'Komplexer Hypotaxe',
        'Modalisierungen',
      ],
      targetSample: '''
        "Es lässt sich konstatieren, dass die epistemologischen Implikationen
        künstlicher Intelligenz auf den wissenschaftlichen Erkenntnisprozess
        eine weitreichende Paradigmenverschiebung initiieren. Die etablierten
        Methoden der Wissensgenerierung, die auf einem cartesianischen
        Verständnis von Rationalität basieren, werden durch die algorithmische
        Verarbeitung komplexer Datenmengen fundamental infrage gestellt..."
      ''',
      evaluationCriteria: [
        'Präzision der Fachterminologie',
        'Logische Kohärenz',
        'Argumentative Strenge',
        'Rhetorische Wirksamkeit',
        'Interaktive Kompetenz (Q&A)',
      ],
      c2Requirements: C2Requirements(
        nativeLikeFluency: true,
        abstractReasoning: true,
        specializedVocabulary: true,
        complexSyntax: true,
        culturalNuance: true,
      ),
    );
  }

  /// C2级别：医疗描述任务（目标5星流利度）
  OralTask _generateMedicalTaskC2() {
    return OralTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioType: ScenarioType.medical,
      level: CEFRLevel.C2,
      title: 'Ärztliche Konsultation: Komplexe Symptomatik',
      description: '你需要向专科医生准确描述复杂的症状',
      targetLengthMinutes: 5,
      context: '''
        Sie sind bei einem Facharzt. Beschreiben Sie Ihre Symptome
        so präzise, dass der Arzt eine fundierte Diagnose stellen kann.

        Erforderliche Elemente:
        1. Anamnese (病史)
        2. Symptome mit Lokalisation und Qualität
        3. Schmerzskala und -charakter
        4. Begleiterscheinungen
        5. Vorerkrankungen und Medikation
      ''',
      keyVocabulary: _getMedicalVocabularyC2(),
      grammarFocus: [
        'Perfekt (Vergangenheit)',
        'Modalverben (Möglichkeiten ausdrücken)',
        'Vergleiche (Metaphern für Schmerz)',
      ],
      targetSample: '''
        "Ich leide seit etwa drei Wochen unter persistierenden okzipitalen
        Kopfschmerzen, die sich paroxysmal verstärken. Die Schmerzintensität
        bewegt sich auf der visuellen Analogskala zwischen 6 und 8.
        Begleitet wird dies von Übelkeit, insbesondere morgens,
        sowie Photophobie und Phonophobie. Ich habe keine relevanten
        Vorerkrankungen und nehme derzeit keine Medikamente..."
      ''',
      evaluationCriteria: [
        'Medizinische Präzision',
        'Temporale Exaktheit',
        'Deskriptive Qualität',
        'Verständlichkeit',
      ],
      c2Requirements: C2Requirements(
        nativeLikeFluency: true,
        specializedVocabulary: true,
        preciseExpression: true,
      ),
    );
  }

  /// C2级别：政治讨论任务（目标5星流利度）
  OralTask _generatePoliticalTaskC2() {
    final topics = [
      'Die Zukunft der europäischen Integration',
      'Klimagerechtigkeit und globale Verantwortung',
      'Digitalisierung und demokratische Partizipation',
      'Migrationspolitik und Menschenrechte',
      'Energiewende und wirtschaftliche Transformation',
    ];

    final topic = topics[_random.nextInt(topics.length)];

    return OralTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioType: ScenarioType.political,
      level: CEFRLevel.C2,
      title: 'Politische Debatte: $topic',
      description: '参加政治辩论节目，就"$topic"进行深入讨论',
      targetLengthMinutes: 10,
      context: '''
        Sie sind Gast in einer politischen Diskussionssendung.
        Sie werden mit Gegenargumenten konfrontiert und müssen
        Ihre Position verteidigen sowie überzeugend reagieren.

        Erforderliche Fähigkeiten:
        1. These klar formulieren
        2. Argumente logisch strukturieren
        3. Gegenargumente adressieren
        4. Kompromisse vorschlagen
        5. Rhetorisch überzeugend bleiben
      ''',
      keyVocabulary: _getPoliticalVocabularyC2(),
      grammarFocus: [
        'Konjunktiv II (Höflichkeit)',
        'Nominalisierungen',
        'Fokuspartikeln',
        'Konnektoren (Gegenüberstellung)',
      ],
      targetSample: '''
        "Meiner festen Überzeugung nach muss die Energiewende nicht nur
        als technische Notwendigkeit, sondern als gesellschaftliche
        Transformationschance begriffen werden. Zwar mögen die kurzfristigen
        ökonomischen Belastungen erheblich sein, jedoch ist langfristig
        eine nachhaltige Wirtschaftsweise ohne Alternative. Man könnte
        einwenden, dass die Wettbewerbsfähigkeit leidet, aber diesem
        Argument ist entgegenzuhalten, dass..."
      ''',
      evaluationCriteria: [
        'Überzeugungskraft',
        'Argumentative Qualität',
        'Reaktionsfähigkeit',
        'Sprachliche Nuancierung',
        'Rhetorische Mittel',
      ],
      c2Requirements: C2Requirements(
        nativeLikeFluency: true,
        abstractReasoning: true,
        persuasiveAbility: true,
        culturalKnowledge: true,
      ),
    );
  }

  /// C2级别：冲突解决任务（目标5星流利度）
  OralTask _generateConflictTaskC2() {
    final scenarios = [
      {
        'title': 'Mietstreitigkeit',
        'context': 'Ihr Vermieter hat die Miete unrechtmäßig um 25% erhöhen. Sie müssen rechtssicher argumentieren.',
      },
      {
        'title': 'Arbeitsrechtlicher Konflikt',
        'context': 'Ihr Arbeitgeber verweigert Ihnen den bezahlten Urlaub, den Sie gesetzlich haben.',
      },
      {
        'title': 'Diskriminierungsvorwurf',
        'context': 'Sie wurden bei einer Bewerbung diskriminiert und möchten rechtliche Schritte einleiten.',
      },
    ];

    final scenario = scenarios[_random.nextInt(scenarios.length)];

    return OralTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioType: ScenarioType.conflict,
      level: CEFRLevel.C2,
      title: 'Konfliktlösung: ${scenario['title']}',
      description: scenario['context'] as String,
      targetLengthMinutes: 8,
      context: '''
        Sie müssen in einem formellen Gespräch Ihre Rechte wahrnehmen.
        Das Ziel ist eine deeskalierende, aber bestimmte Lösung.

        Strategie:
        1. Sachlichkeit bewahren
        2. Rechtliche Position klären
        3. Lösungsvorschläge machen
        4. Konsequenzen andeuten (falls nötig)
        5. Kompromissbereitschaft signalisieren
      ''',
      keyVocabulary: _getConflictVocabularyC2(),
      grammarFocus: [
        'Konjunktiv II (Höflichkeit und Distanz)',
        'Passiv (Sachlichkeit)',
        'Nominalisierungen',
      ],
      targetSample: '''
        "Ich möchte das Missverständnis klären. Laut Mietpreisbundesgesetz
        ist eine Mieterhöhung von 25% innerhalb von drei Jahren unzulässig,
        solange keine Modernisierung durchgeführt wurde. Ich gehe davon
        aus, dass dies einem Irrtum entspringt, da andernfalls
        rechtliche Schritte unvermeidbar wären. Es wäre im Interesse
        beider Parteien, eine einvernehmliche Lösung zu finden..."
      ''',
      evaluationCriteria: [
        'Rechtliche Korrektheit',
        'Bestimmtheit',
        'Höflichkeit',
        'Deeskalierende Strategie',
        'Lösungsorientierung',
      ],
      c2Requirements: C2Requirements(
        nativeLikeFluency: true,
        formalRegister: true,
        preciseExpression: true,
        emotionalControl: true,
      ),
    );
  }

  /// C2级别：日常闲聊任务
  OralTask _generateCasualTaskC2() {
    final topics = [
      'Kulturelle Unterschiede zwischen Deutschland und China',
      'Ihr persönliches Sprachlernprozess',
      'Deutsche Mentalität und Stereotypen',
      'Humor und Witz in unterschiedlichen Kulturen',
    ];

    final topic = topics[_random.nextInt(topics.length)];

    return OralTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioType: ScenarioType.casual,
      level: CEFRLevel.C2,
      title: 'Gespräch: $topic',
      description: '与德国朋友深入探讨"$topic"',
      targetLengthMinutes: 5,
      context: '''
        Sie führen ein intensives Gespräch mit deutschen Freunden.
        Die Konversation soll natürlich, aber intellektuell anregend sein.

        Stil: Umgangssprache mit bildungssprachlichen Elementen
        Ziel: Kultureller Austausch auf Augenhöhe
      ''',
      keyVocabulary: _getCasualVocabularyC2(),
      grammarFocus: [
        'Umgangssprachliche Redemittel',
        'Ellipsen',
        'Idiomatische Ausdrücke',
      ],
      targetSample: '''
        "Also, ich habe das Gefühl, dass die Deutschen gerne
        direkt sind, was anfangs etwas ungewohnt war. Aber inzwischen
        schätze ich das richtig, weil man immer weiß, woran man ist.
        Bei uns ist das anders, da wird viel mehr um den heißen Brei
        herumgeredet. Aber eine Sache frage ich mich schon: Warum
        ist das eigentlich so..."
      ''',
      evaluationCriteria: [
        'Natürlichkeit',
        'Humor',
        'Kulturelle Sensibilität',
        'Interesse am Gegenüber',
      ],
      c2Requirements: C2Requirements(
        nativeLikeFluency: true,
        culturalKnowledge: true,
        socialNuance: true,
      ),
    );
  }

  /// C2级别：专业场景（工作/商务）
  OralTask _generateProfessionalTaskC2() {
    return OralTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioType: ScenarioType.professional,
      level: CEFRLevel.C2,
      title: 'Verhandlungsgeschick: Gehaltsverhandlung',
      description: '作为高级经理，你需要与新雇主谈判薪酬待遇',
      targetLengthMinutes: 10,
      context: '''
        Sie sind im Endauswahlverfahren für eine C-Level-Position.
        Jetzt verhandeln Sie Ihr Gehalt und weitere Konditionen.

        Ausgangslage:
        - Angebot: 120.000€ Jahresgehalt
        - Ihre Zielvorstellung: 150.000€ + Bonus + Aktienoptionen
        - Sie müssen überzeugend argumentieren
      ''',
      keyVocabulary: _getProfessionalVocabularyC2(),
      grammarFocus: [
        'Förmlich-distanzielle Ausdrucksweise',
        'Konjunktiv II (Höfliche Forderungen)',
        'Nominalisierungen',
      ],
      targetSample: '''
        "Zunächst möchte ich mein Interesse an dieser Position betonen.
        Die Aufgabenstellung entspricht genau meiner Expertise. Was
        das Gehalt betrifft, so ist das Angebot sicher marktüblich,
        aber ich darf darauf hinweisen, dass meine Erfahrung und
        meine Erfolge in vergleichbaren Positionen einen höheren
        Wert darstellen. Es wäre im beiderseitigen Interesse, wenn
        wir eine Lösung finden könnten, die meiner Leistung
        gerecht wird..."
      ''',
      evaluationCriteria: [
        'Verhandlungsgeschick',
        'Selbstpräsentation',
        'Fachliche Kompetenz',
        'Überzeugungskraft',
      ],
      c2Requirements: C2Requirements(
        nativeLikeFluency: true,
        formalRegister: true,
        persuasiveAbility: true,
      ),
    );
  }

  // ==================== C2级别词汇库 ====================

  List<String> _getAcademicVocabularyC2() {
    return [
      // 抽象名词
      'die Epistemologie', 'die Paradigmenverschiebung', 'die Relevanz',
      'die Implikation', 'die Korrelation', 'die Kausalität',
      'die Methodologie', 'theoretisch', 'empirisch', 'hypothetisch',

      // 学术动词
      'konstatieren', 'postulieren', 'inferieren', 'verifizieren',
      'reflektieren', 'analysieren', 'synthetisieren', 'evaluieren',

      // 连接词
      'demnach', 'folglich', 'hingegen', 'insofern', 'insoweit',
      'gemäß', 'angesichts', 'hinsichtlich',
    ];
  }

  List<String> _getMedicalVocabularyC2() {
    return [
      // 症状描述
      'persistent', 'paroxysmal', 'okzipital', 'temporär',
      'die Photophobie', 'die Phonophobie', 'die Übelkeit',
      'die Anamnese', 'die Symptomatik', 'die Pathogenese',

      // 医学术语
      'diagnostizieren', 'therapieren', 'symptomatisch', 'ätiologisch',
      'die Prognose', 'die Manifestation', 'die Komorbidität',
    ];
  }

  List<String> _getPoliticalVocabularyC2() {
    return [
      // 政治术语
      'die Partizipation', 'die Transformation', 'nachhaltig',
      'gerechtig', 'souverän', 'föderal', 'supranational',

      // 表达观点
      'manifestieren', 'articulieren', 'postulieren',
      'infrage stellen', 'argumentieren', 'kontern',

      // 连接词
      'zwar... aber...', 'einerseits... andererseits...',
      'in Anbetracht', 'angesichts', 'im Hinblick auf',
    ];
  }

  List<String> _getConflictVocabularyC2() {
    return [
      // 法律术语
      'rechtswidrig', 'unzulässig', 'vertragsgemäß', 'kündigungsrecht',
      'die Abmahnung', 'die Schlichtung', 'die Klage',

      // 表达立场
      'festhalten', 'bestehen auf', 'bestreiten', 'zurückweisen',
      'anfordern', 'einräumen', 'kompromissbereit',

      // 礼貌但坚定
      'Ich möchte darauf hinweisen', 'Es wäre zu erwarten',
      'Ich gehe davon aus', 'Dagegen ist einzuwenden',
    ];
  }

  List<String> _getCasualVocabularyC2() {
    return [
      // 日常高级表达
      'ehrlich gesagt', 'im Grunde', 'im Endeffekt',
      'eigentlich', 'sowieso', 'auf jeden Fall', 'auf keinen Fall',

      // 地道习语
      'um den heißen Brei herumreden',
      'den Nagel auf den Kopf treffen',
      'auf dem Schlauch stehen',
      'ins Schwarze treffen',
    ];
  }

  List<String> _getProfessionalVocabularyC2() {
    return [
      // 商务术语
      'das Honorar', 'die Vergütung', 'das Aktienpaket',
      'der Performancebonus', 'die Zielvereinbarung', 'die KPI',

      // 表达能力
      'expansiv', 'profitabel', 'nachhaltig wachsen',
      'Synergien heben', 'Optimierungspotenzial', 'Skaleneffekte',

      // 谈判用语
      'in Verhandlung treten', 'eine Einigung erzielen',
      'Kompromisse schließen', 'Vorschläge unterbreiten',
    ];
  }
}

// ==================== 数据模型 ====================

enum ScenarioType {
  academic,      // 学术讨论
  medical,       // 医疗场景
  political,     // 政治讨论
  conflict,      // 冲突解决
  casual,        // 日常闲聊
  professional,  // 专业场景
}

enum CEFRLevel {
  A1, A2, B1, B2, C1, C2,
}

class OralTask {
  final String id;
  final ScenarioType scenarioType;
  final CEFRLevel level;
  final String title;
  final String description;
  final String context;
  final int targetLengthMinutes;
  final List<String> keyVocabulary;
  final List<String> grammarFocus;
  final String? targetSample;
  final List<String>? evaluationCriteria;
  final C2Requirements? c2Requirements;

  OralTask({
    required this.id,
    required this.scenarioType,
    required this.level,
    required this.title,
    required this.description,
    required this.context,
    required this.targetLengthMinutes,
    required this.keyVocabulary,
    required this.grammarFocus,
    this.targetSample,
    this.evaluationCriteria,
    this.c2Requirements,
  });
}

class C2Requirements {
  final bool nativeLikeFluency;      // 母语者般的流利度
  final bool abstractReasoning;       // 抽象推理能力
  final bool specializedVocabulary;   // 专业词汇
  final bool complexSyntax;           // 复杂句法
  final bool culturalNuance;          // 文化细微差别
  final bool preciseExpression;       // 精确表达
  final bool persuasiveAbility;       // 说服能力
  final bool formalRegister;          // 正式语域
  final bool culturalKnowledge;       // 文化知识
  final bool socialNuance;            // 社交细微差别
  final bool emotionalControl;        // 情绪控制

  C2Requirements({
    this.nativeLikeFluency = false,
    this.abstractReasoning = false,
    this.specializedVocabulary = false,
    this.complexSyntax = false,
    this.culturalNuance = false,
    this.preciseExpression = false,
    this.persuasiveAbility = false,
    this.formalRegister = false,
    this.culturalKnowledge = false,
    this.socialNuance = false,
    this.emotionalControl = false,
  });
}

/// 口语评估结果
class OralEvaluation {
  final String taskId;            // 任务ID
  final String userTranscript;     // 用户语音识别结果
  final String targetTranscript;   // 目标文本
  final double overallScore;       // 总分 (0-100)
  final int starRating;            // 星级 (1-5)
  final double pronunciationScore; // 发音得分
  final double grammarScore;        // 语法得分
  final double vocabularyScore;     // 词汇得分
  final double fluencyScore;        // 流利度得分
  final double contentScore;        // 内容得分
  final String feedback;            // AI反馈
  final List<String> improvements;  // 改进建议

  OralEvaluation({
    required this.taskId,
    required this.userTranscript,
    required this.targetTranscript,
    required this.overallScore,
    required this.starRating,
    required this.pronunciationScore,
    required this.grammarScore,
    required this.vocabularyScore,
    required this.fluencyScore,
    required this.contentScore,
    required this.feedback,
    required this.improvements,
  });
}
