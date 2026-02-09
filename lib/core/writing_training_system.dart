import '../api/ai_service.dart';
import '../core/grammar_engine.dart';
import 'dart:io';

/// 写作训练系统 - Writing Training System (C2级别)
///
/// 覆盖从简单邮件到学术论文的完整写作训练
/// 使用AI进行批改和反馈
class WritingTrainingSystem {
  final AIService _aiService;

  WritingTrainingSystem({required AIService aiService})
      : _aiService = aiService;

  /// 生成写作任务
  WritingTask generateTask({
    required WritingType type,
    required LanguageLevel level,
    String? specificTopic,
  }) {
    switch (type) {
      case WritingType.email:
        return _generateEmailTask(level, specificTopic);
      case WritingType.description:
        return _generateDescriptionTask(level, specificTopic);
      case WritingType.argumentation:
        return _generateArgumentationTask(level, specificTopic);
      case WritingType.academic:
        return _generateAcademicTask(level, specificTopic);
      case WritingType.creative:
        return _generateCreativeTask(level, specificTopic);
    }
  }

  /// 生成AI批改提示词
  String generateCorrectionPrompt({
    required WritingTask task,
    required String userText,
  }) {
    return '''
Du bist ein erfahrener Deutschlehrer und Korrektor auf ${task.level.toString()}-Niveau.

Der Schüler hat folgenden Text geschrieben:

AUFGABENSTELLUNG:
${task.title}
${task.description}

SCHÜLERTEXT:
$userText

Bitte korrigiere den Text und gib ein detailliertes Feedback. Rückgabe im JSON-Format:

{
  "correctedText": "Der korrigierte Text",
  "overallScore": 0-100,
  "grammarErrors": [
    {
      "original": "Original",
      "correction": "Korrektur",
      "explanation": "Erklärung",
      "rule": "Grammatikregel"
    }
  ],
  "vocabularyImprovements": [
    {
      "original": "einfaches Wort",
      "suggestion": "besseres Wort",
      "why": "Begründung"
    }
  ],
  "structureFeedback": "Feedback zum Aufbau",
  "strengths": ["Stärke 1", "Stärke 2"],
  "weaknesses": ["Schwäche 1", "Schwäche 2"],
  "nextSteps": ["Verbesserungsvorschlag 1", "Verbesserungsvorschlag 2"],
  "sampleSolution": "Eine Mustertextlösung"
}

WICHTIG:
- Sei konstruktiv und ermutigend
- Erkläre每一个 Fehler verständlich
- Schlage konkrete Verbesserungen vor
- Berücksichtige das Niveau ${task.level.toString}
''';
  }

  /// 调用AI批改
  Future<WritingEvaluation> evaluateText({
    required WritingTask task,
    required String userText,
  }) async {
    final prompt = generateCorrectionPrompt(
      task: task,
      userText: userText,
    );

    try {
      final response = await _aiService.callChatAPI(prompt);
      final evaluation = WritingEvaluation.fromJson(response);

      return evaluation;
    } catch (e) {
      // Fallback bei Fehler
      return WritingEvaluation.createFallback(task, userText);
    }
  }

  /// A1/A2: 简单邮件任务
  WritingTask _generateEmailTask(LanguageLevel level, String? topic) {
    final topics = {
      LanguageLevel.A1: [
        'Einladung zum Geburtstag',
        'Danke für den Besuch',
        'Nachricht: Ich komme zu spät',
      ],
      LanguageLevel.A2: [
        'Hotelreservation anfragen',
        'Im Restaurant reservieren',
        'Krankmeldung für die Arbeit',
      ],
    };

    final selectedTopic = topic ?? (topics[level]?[0]);

    return WritingTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: WritingType.email,
      level: level,
      title: 'E-Mail: $selectedTopic',
      description: _getEmailInstruction(level, selectedTopic!),
      targetLength: level == LanguageLevel.A1 ? 50 : 100,
      keyElements: _getEmailKeyElements(level),
      sampleStructure: _getEmailSampleStructure(level),
      evaluationCriteria: _getEmailEvaluationCriteria(level),
    );
  }

  /// B1: 描述性文章任务
  WritingTask _generateDescriptionTask(LanguageLevel level, String? topic) {
    final topics = [
      'Meine Heimatstadt beschreiben',
      'Ein besonderes Erlebnis',
      'Mein Lieblingsort',
      'Ein Fest in meinem Land',
    ];

    final selectedTopic = topic ?? topics.first;

    return WritingTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: WritingType.description,
      level: level,
      title: selectedTopic,
      description: '''
        Schreiben Sie einen beschreibenden Text über: "$selectedTopic"

        Struktur:
        1. Einleitung (Was beschreiben Sie?)
        2. Hauptteil (Details, Beispiele)
        3. Schluss (Warum ist es besonders?)
      ''',
      targetLength: 150,
      keyElements: [
        'Einleitende Formulierung',
        'Beschreibende Adjektive',
        'Temporale Angaben',
        'Persönliche Meinung',
      ],
      sampleStructure: '''
        Einleitung: "Ich möchte gerne [Thema] vorstellen."
        Hauptteil: Beschreibung mit Details
        Schluss: "Besonders gefällt mir..."
      ''',
      evaluationCriteria: [
        'Reichhaltigkeit der Beschreibung',
        'Grammatikalische Korrektheit',
        'Kohärenz',
        'Wortschatz',
      ],
    );
  }

  /// B2: 论证式文章任务
  WritingTask _generateArgumentationTask(LanguageLevel level, String? topic) {
    final topics = [
      'Sollte man in großen Städten Maut für Autos einführen?',
      'Homeoffice: Segen oder Fluch?',
      'Social Media: Gut oder schlecht für die Gesellschaft?',
      'Sollte die Schuluniform Pflicht werden?',
      'E-Autos: Die Zukunft der Mobilität?',
    ];

    final selectedTopic = topic ?? topics.first;

    return WritingTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: WritingType.argumentation,
      level: level,
      title: 'Erörterung: $selectedTopic',
      description: '''
        Schreiben Sie eine argumentierende Erörterung zum Thema:
        "$selectedTopic"

        Struktur:
        1. Einleitung (Thema vorstellen, These formulieren)
        2. Pro-Argumente (mindestens 2 mit Beispielen)
        3. Contra-Argumente (mindestens 2 mit Beispielen)
        4. Eigene Meinung mit Begründung
        5. Schluss (Fazit)

        Verwenden Sie:
        - Einleitende Formulierungen (Heutzutage, Viele Menschen diskutieren über...)
        - Pro/Contra-Formulierungen (Ein Vorteil ist..., Ein Nachteil ist...)
        - Schlussfolgerungen (Deshalb bin ich der Meinung, dass...)
      ''',
      targetLength: 250,
      keyElements: [
        'Klare These',
        'Ausgewogene Argumentation',
        'Beispiele',
        'Pro-Contra-Struktur',
        'Konnektoren',
      ],
      sampleStructure: '''
        Einleitung:
        "Heutzutage wird viel über [Thema] diskutiert.
         Einige sind der Meinung..., andere hingegen..."

        Pro-Argumente:
        "Ein wichtiges Argument für... ist..."
        "Ein weiterer Vorteil ist..."
        "Beispielsweise..."

        Contra-Argumente:
        "Demgegenüber steht jedoch..."
        "Kritiker merken an, dass..."
        "Ein Problem ist..."

        Eigene Meinung:
        "Meiner Meinung nach..."
        "Ich bin der Ansicht, dass..."
        "Aus meiner Sicht..."

        Schluss:
        "Zusammenfassend lässt sich sagen..."
      ''',
      evaluationCriteria: [
        'Argumentative Qualität',
        'Struktur',
        'Konnektoren',
        'Grammatik',
        'Wortschatz',
        'Kohärenz',
      ],
    );
  }

  /// C1/C2: 学术论文任务
  WritingTask _generateAcademicTask(LanguageLevel level, String? topic) {
    final topics = [
      'Die Auswirkungen von Remote Work auf die Arbeitswelt',
      'Künstliche Intelligenz im Bildungsbereich',
      'Nachhaltigkeit in der Modeindustrie',
      'Die Rolle sozialer Medien in Demokratien',
      'Globalisierung und kulturelle Identität',
    ];

    final selectedTopic = topic ?? topics.first;

    return WritingTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: WritingType.academic,
      level: level,
      title: 'Wissenschaftliche Arbeit: $selectedTopic',
      description: '''
        Schreiben Sie eine wissenschaftliche Arbeit über:
        "$selectedTopic"

        Anforderungen (${level.toString()}-Niveau):

        1. Titel und Abstract (100-150 Wörter)
        2. Einleitung (Forschungsfrage, These)
        3. Literaturübersicht (Stand der Forschung)
        4. Methodologie (Vorgehensweise)
        5. Ergebnisse und Analyse
        6. Diskussion
        7. Fazit und Ausblick

        Stil:
        - Akademisch-gehoben
        - Objektiv und neutral
        - Nominalisierungen verwenden
        - Passive und Funktionsverbgefüge
        - Fachbegriffe präzise

        Verwenden Sie:
        - Einleitende Formulierungen: "Die vorliegende Arbeit beschäftigt sich mit..."
        - Bezugnahme: "Wie [Autor] aufzeigt..."
        - Kontrast: "Im Gegensatz dazu steht..."
        - Schlussfolgerung: "Daraus lässt sich folgern..."
      ''',
      targetLength: level == LanguageLevel.C1 ? 800 : 1500,
      keyElements: [
        'Wissenschaftliche Fragestellung',
        'Theoretische Fundierung',
        'Empirische Belege',
        'Kritische Auseinandersetzung',
        'Akademischer Stil',
      ],
      sampleStructure: '''
        Abstract:
        "Die vorliegende Arbeit untersucht..."
        "Der Fokus liegt auf..."
        "Die Ergebnisse zeigen..."

        Einleitung:
        "In den letzten Jahren hat..."
        "Die Forschungsfrage lautet..."
        "Die These lautet..."

        Hauptteil:
        - Theoretischer Rahmen
        - Methodisches Vorgehen
        - Analyse und Diskussion

        Schluss:
        "Zusammenfassend lässt sich konstatieren..."
        "Für zukünftige Forschung ergibt sich..."
      ''',
      evaluationCriteria: [
        'Wissenschaftliche Qualität',
        'Argumentative Strenge',
        'Theoretische Fundierung',
        'Empirische Basis',
        'Akademischer Stil',
        'Zitation und Referenzierung',
      ],
    );
  }

  /// C2: 创意写作任务
  WritingTask _generateCreativeTask(LanguageLevel level, String? topic) {
    final topics = [
      'Eine Geschichte über ein Jahr im Leben eines...',
      'Ein Gedicht über... (自由主题)',
      'Ein dramatischer Dialog',
      'Eine Satire über...',
    ];

    final selectedTopic = topic ?? topics.first;

    return WritingTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: WritingType.creative,
      level: level,
      title: 'Kreatives Schreiben: $selectedTopic',
      description: '''
        Schreiben Sie einen kreativen Text: "$selectedTopic"

        Für C2-Niveau:
        - Nutzen Sie rhetorische Mittel (Metaphern, Ironie, etc.)
        - Experimentieren Sie mit Sprache
        - Zeigen Sie stilistische Vielfalt
        - Berücksichtigen Sie kulturelle Nuancen

        Stil: Frei, aber anspruchsvoll
      ''',
      targetLength: 500,
      keyElements: [
        'Kreativität',
        'Sprachliche Virtuosität',
        'Stilistische Originalität',
        'Emotionale Tiefe',
      ],
      evaluationCriteria: [
        'Originalität',
        'Sprachliche Beherrschung',
        'Stil',
        'Wirkung auf den Leser',
      ],
    );
  }

  // ==================== 辅助方法 ====================

  String _getEmailInstruction(LanguageLevel level, String topic) {
    if (level == LanguageLevel.A1) {
      return '''
        Schreiben Sie eine kurze E-Mail: "$topic"

        Struktur:
        1. Betreff
        2. Anrede
        3. Hauptteil (Satz oder 2)
        4. Gruß

        Beispiel:
        Betreff: Einladung
        Hallo [Name],
        ich lade dich zum Geburtstag ein.
        Am Samstag um 19 Uhr.
        Bis bald!
        [Dein Name]
      ''';
    } else {
      return '''
        Schreiben Sie eine formelle E-Mail: "$topic"

        Struktur:
        1. Betreff (klar und präzise)
        2. Höfliche Anrede
        3. Grund der E-Mail
        4. Anliegen/Frage
        5. Erwartete Antwort
        6. Höflicher Gruß

        Verwenden Sie:
        - "Sehr geehrte(r) Frau/Herr [Name]"
        - "Ich wende mich an Sie, weil..."
        - "Ich würde mich freuen, wenn..."
        - "Mit freundlichen Grüßen"
      ''';
    }
  }

  List<String> _getEmailKeyElements(LanguageLevel level) {
    if (level == LanguageLevel.A1) {
      return [
        'Betreff',
        'Anrede',
        'Klarer Inhalt',
        'Gruß',
      ];
    } else {
      return [
        'Klarer Betreff',
        'Höfliche Anrede',
        'Sachlicher Inhalt',
        'Höflicher Abschluss',
      ];
    }
  }

  String _getEmailSampleStructure(LanguageLevel level) {
    if (level == LanguageLevel.A1) {
      return '''
        Hallo Anna,

        ich lade dich zu meiner Party ein.
        Am Samstag um 19 Uhr.

        Bis bald!
        Maria
      ''';
    } else {
      return '''
        Betreff: Reservierung für zwei Personen

        Sehr geehrte Damen und Herren,

        ich möchte gerne einen Tisch für zwei Personen
        am Samstag, den 15. März um 19:00 Uhr reservieren.

        Ich würde mich über eine Bestätigung freuen.

        Mit freundlichen Grüßen
        Max Mustermann
      ''';
    }
  }

  List<String> _getEmailEvaluationCriteria(LanguageLevel level) {
    return [
      'Klarheit',
      'Struktur',
      'Grammatik',
      'Höflichkeit',
      'Angemessener Stil',
    ];
  }
}

// ==================== 数据模型 ====================

enum WritingType {
  email,         // 邮件
  description,   // 描述
  argumentation, // 论证
  academic,      // 学术
  creative,      // 创意
}

class WritingTask {
  final String id;
  final WritingType type;
  final LanguageLevel level;
  final String title;
  final String description;
  final int targetLength;
  final List<String> keyElements;
  final String? sampleStructure;
  final List<String>? evaluationCriteria;

  WritingTask({
    required this.id,
    required this.type,
    required this.level,
    required this.title,
    required this.description,
    required this.targetLength,
    required this.keyElements,
    this.sampleStructure,
    this.evaluationCriteria,
  });
}

class WritingEvaluation {
  final String correctedText;
  final double overallScore;
  final List<GrammarError> grammarErrors;
  final List<VocabularyImprovement> vocabularyImprovements;
  final String? structureFeedback;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> nextSteps;
  final String? sampleSolution;
  final DateTime timestamp;

  WritingEvaluation({
    required this.correctedText,
    required this.overallScore,
    required this.grammarErrors,
    required this.vocabularyImprovements,
    this.structureFeedback,
    required this.strengths,
    required this.weaknesses,
    required this.nextSteps,
    this.sampleSolution,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WritingEvaluation.fromJson(String json) {
    // TODO: Implement JSON parsing
    return WritingEvaluation(
      correctedText: '',
      overallScore: 0,
      grammarErrors: [],
      vocabularyImprovements: [],
      strengths: [],
      weaknesses: [],
      nextSteps: [],
    );
  }

  factory WritingEvaluation.createFallback(WritingTask task, String userText) {
    return WritingEvaluation(
      correctedText: userText,
      overallScore: 70.0,
      grammarErrors: [],
      vocabularyImprovements: [],
      strengths: ['Klar verständlich'],
      weaknesses: ['Könnte noch verbessert werden'],
      nextSteps: ['Übe weiter mit ähnlichen Aufgaben'],
    );
  }

  int get stars => (overallScore / 20).ceil();
}

class GrammarError {
  final String original;
  final String correction;
  final String explanation;
  final String rule;

  GrammarError({
    required this.original,
    required this.correction,
    required this.explanation,
    required this.rule,
  });
}

class VocabularyImprovement {
  final String original;
  final String suggestion;
  final String why;

  VocabularyImprovement({
    required this.original,
    required this.suggestion,
    required this.why,
  });
}
