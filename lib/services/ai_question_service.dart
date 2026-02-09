/// AI问题生成服务
///
/// 基于模板的问题生成系统，无需配置API即可使用
/// 可根据阅读材料、词汇和语法主题自动生成练习题
library;

import 'dart:async';
import 'dart:math';
import '../models/question.dart';
import '../models/word.dart';
import '../data/reading_materials.dart';
import '../core/grammar_engine.dart';

/// AI问题生成器接口
abstract class AIQuestionGenerator {
  /// 从阅读材料生成理解题
  Future<List<Question>> generateComprehensionQuestions(
    ReadingMaterialData material,
    int count,
  );

  /// 从词汇生成练习题
  Future<List<Question>> generateVocabularyQuestions(
    List<Word> words,
    int count,
  );

  /// 从语法主题生成练习题
  Future<List<Question>> generateGrammarQuestions(
    GrammarTopic topic,
    int count,
  );

  /// 生成混合问题集
  Future<QuestionSet> generateMixedQuestionSet({
    required String title,
    required LanguageLevel level,
    int comprehensionCount = 3,
    int vocabularyCount = 4,
    int grammarCount = 3,
  });
}

/// 基于模板的问题生成器实现
class TemplateQuestionGenerator implements AIQuestionGenerator {
  final Random _random = Random();

  /// 从阅读材料生成理解题
  @override
  Future<List<Question>> generateComprehensionQuestions(
    ReadingMaterialData material,
    int count,
  ) async {
    final questions = <Question>[];

    // 根据材料级别选择问题类型
    final level = material.level;

    // 生成事实性问题
    questions.addAll(_generateFactQuestions(material, 2));

    // 生成推理问题
    if (level.index >= LanguageLevel.A2.index) {
      questions.addAll(_generateInferenceQuestions(material, 1));
    }

    // 生成词汇理解问题
    questions.addAll(_generateVocabularyInContextQuestions(material, 2));

    // 生成主旨大意问题
    if (level.index >= LanguageLevel.B1.index) {
      questions.addAll(_generateMainIdeaQuestions(material, 1));
    }

    // 生成观点态度问题
    if (level.index >= LanguageLevel.B2.index) {
      questions.addAll(_generateOpinionQuestions(material, 1));
    }

    // 随机选择指定数量的问题
    if (questions.length > count) {
      questions.shuffle(_random);
      return questions.sublist(0, count);
    }

    return questions;
  }

  /// 生成事实性问题
  List<Question> _generateFactQuestions(
    ReadingMaterialData material,
    int count,
  ) {
    final questions = <Question>[];
    final sentences = material.content.split('.');
    sentences.removeWhere((s) => s.trim().isEmpty);

    // 从句子中提取关键词
    final keywords = _extractKeywords(material.content);

    for (int i = 0; i < count && i < sentences.length; i++) {
      final sentence = sentences[i].trim();
      if (sentence.isEmpty) continue;

      // 生成选择题
      final question = Question(
        id: 'comp_fact_${material.id}_$i',
        type: QuestionType.multipleChoice,
        difficulty: _mapLevelToDifficulty(material.level),
        question: 'Was ist im Text richtig?\\n\\n"$sentence"',
        options: _generateFactOptions(sentence, keywords),
        explanation: 'Diese Information steht explizit im Text.',
        points: 10,
        targetLevel: material.level,
        sourceId: material.id,
        sourceType: 'reading',
        tags: ['comprehension', 'factual'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成推理问题
  List<Question> _generateInferenceQuestions(
    ReadingMaterialData material,
    int count,
  ) {
    final questions = <Question>[];

    for (int i = 0; i < count; i++) {
      final question = Question(
        id: 'comp_inf_${material.id}_$i',
        type: QuestionType.multipleChoice,
        difficulty: _mapLevelToDifficulty(material.level,
            harder: true),
        question: 'Was kann man aus dem Text schließen?\\n\\n${material.summary ?? material.content}',
        options: _generateInferenceOptions(material),
        explanation: 'Die Antwort kann durch logisches Schlussfolgern aus dem Text abgeleitet werden.',
        points: 15,
        targetLevel: material.level,
        sourceId: material.id,
        sourceType: 'reading',
        tags: ['comprehension', 'inference'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成词汇语境问题
  List<Question> _generateVocabularyInContextQuestions(
    ReadingMaterialData material,
    int count,
  ) {
    final questions = <Question>[];
    final sentences = material.content.split('.');
    sentences.removeWhere((s) => s.trim().isEmpty);

    for (int i = 0; i < count && i < sentences.length; i++) {
      final sentence = sentences[i].trim();
      final words = sentence.split(' ');
      if (words.length < 3) continue;

      // 选择一个重要的词（排除最常见的词）
      final targetWordIndex = _random.nextInt(words.length);
      final targetWord = words[targetWordIndex].replaceAll(
        RegExp(r'[.,!?;:]'),
        '',
      );

      if (targetWord.length < 3) continue;

      final question = Question(
        id: 'comp_vocab_${material.id}_$i',
        type: QuestionType.multipleChoice,
        difficulty: _mapLevelToDifficulty(material.level),
        question: 'Was bedeutet "$targetWord" in diesem Kontext?\\n\\n"$sentence"',
        options: _generateVocabularyContextOptions(targetWord),
        explanation: 'Das Wort "$targetWord" bedeutet hier...',
        points: 12,
        targetLevel: material.level,
        sourceId: material.id,
        sourceType: 'reading',
        tags: ['comprehension', 'vocabulary'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成主旨大意问题
  List<Question> _generateMainIdeaQuestions(
    ReadingMaterialData material,
    int count,
  ) {
    final questions = <Question>[];

    final question = Question(
      id: 'comp_main_${material.id}_0',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Was ist die Hauptidea des Textes?\\n\\n${material.title}\\n\\n${material.content.substring(0, material.content.length > 200 ? 200 : material.content.length)}...',
      options: _generateMainIdeaOptions(material),
      explanation: 'Die Hauptidea bezieht sich auf das Hauptthema des Textes.',
      points: 15,
      targetLevel: material.level,
      sourceId: material.id,
      sourceType: 'reading',
      tags: ['comprehension', 'main_idea'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成观点问题
  List<Question> _generateOpinionQuestions(
    ReadingMaterialData material,
    int count,
  ) {
    final questions = <Question>[];

    final question = Question(
      id: 'comp_opin_${material.id}_0',
      type: QuestionType.openEnded,
      difficulty: QuestionDifficulty.difficult,
      question: 'Was ist deine Meinung zu diesem Text?\\n\\n${material.title}\\n\\n${material.content}',
      correctAnswer: null,
      explanation: 'Dies ist eine offene Frage. Es gibt keine richtige oder falsche Antwort.',
      hint: 'Stütze deine Meinung mit Beispielen aus dem Text.',
      points: 20,
      targetLevel: material.level,
      sourceId: material.id,
      sourceType: 'reading',
      tags: ['comprehension', 'opinion'],
    );
    questions.add(question);

    return questions;
  }

  /// 从词汇生成练习题
  @override
  Future<List<Question>> generateVocabularyQuestions(
    List<Word> words,
    int count,
  ) async {
    final questions = <Question>[];

    // 按级别分组
    final levelGroups = <LanguageLevel, List<Word>>{};
    for (final word in words) {
      levelGroups.putIfAbsent(word.level, () => []).add(word);
    }

    // 为每个级别生成不同类型的问题
    for (final entry in levelGroups.entries) {
      final level = entry.key;
      final levelWords = entry.value;

      // 词义选择题
      questions.addAll(_generateMeaningQuestions(levelWords, 2));

      // 词汇配对题
      if (level.index >= LanguageLevel.A2.index) {
        questions.addAll(_generateMatchingQuestions(levelWords, 1));
      }

      // 填空题
      if (level.index >= LanguageLevel.B1.index) {
        questions.addAll(_generateFillInBlanksQuestions(levelWords, 2));
      }

      // 同义词/反义词题
      if (level.index >= LanguageLevel.B2.index) {
        questions.addAll(_generateSynonymAntonymQuestions(levelWords, 1));
      }
    }

    // 随机选择指定数量的问题
    if (questions.length > count) {
      questions.shuffle(_random);
      return questions.sublist(0, count);
    }

    return questions;
  }

  /// 生成词义选择题
  List<Question> _generateMeaningQuestions(List<Word> words, int count) {
    final questions = <Question>[];

    for (int i = 0; i < count && i < words.length; i++) {
      final word = words[i];
      final distractors = _getDistractors(words, word, 3);

      final options = [
        QuestionOption(
          id: 'a',
          text: word.meaning,
          isCorrect: true,
        ),
        ...distractors.asMap().entries.map((entry) {
          final idx = entry.key;
          final distractor = entry.value;
          return QuestionOption(
            id: String.fromCharCode(98 + idx), // b, c, d
            text: distractor.meaning,
            isCorrect: false,
          );
        }),
      ];

      options.shuffle(_random);

      final question = Question(
        id: 'vocab_meaning_${word.word}',
        type: QuestionType.multipleChoice,
        difficulty: _mapLevelToDifficulty(word.level),
        question: 'Was bedeutet "${word.word}"${word.article != null ? " (${word.article})" : ""}?',
        options: options,
        explanation: word.exampleSentence != null
            ? 'Beispiel: ${word.exampleSentence}'
            : null,
        points: 10,
        targetLevel: word.level,
        relatedWords: [word],
        tags: ['vocabulary', 'meaning'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成配对题
  List<Question> _generateMatchingQuestions(List<Word> words, int count) {
    final questions = <Question>[];

    if (words.length < 4) return questions;

    final subset = words.sublist(0, 4.clamp(0, words.length));
    final germanWords = subset.map((w) => w.word).toList()..shuffle(_random);
    final meanings = subset.map((w) => w.meaning).toList()..shuffle(_random);

    final question = Question(
      id: 'vocab_match_${DateTime.now().millisecondsSinceEpoch}',
      type: QuestionType.matching,
      difficulty: QuestionDifficulty.medium,
      question: 'Ordne die deutschen Wörter den richtigen Bedeutungen zu.',
      options: null,
      correctAnswer: 'matching_exercise',
      explanation: 'Bitte ordne jedes Wort seiner Bedeutung zu.',
      hint: 'Es gibt mehrere Möglichkeiten',
      points: 15,
      targetLevel: subset.first.level,
      relatedWords: subset,
      tags: ['vocabulary', 'matching'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成填空题
  List<Question> _generateFillInBlanksQuestions(List<Word> words, int count) {
    final questions = <Question>[];

    final templateSentences = [
      'Ich _____ jeden Tag Deutsch.',
      'Das ist sehr _____.',
      'Können Sie mir _____?',
      'Er _____ sehr gut.',
      'Die _____ ist schön.',
      'Ich möchte _____.',
      'Das ist _____.',
      'Wir _____ nach Hause.',
    ];

    for (int i = 0; i < count && i < words.length; i++) {
      final word = words[i];
      final template = templateSentences[i % templateSentences.length];
      final sentence = template.replaceAll('_____', '_____');

      final options = [
        QuestionOption(id: 'a', text: word.word, isCorrect: true),
        ..._getDistractors(words, word, 3).asMap().entries.map((entry) {
          final idx = entry.key;
          final distractor = entry.value;
          return QuestionOption(
            id: String.fromCharCode(98 + idx),
            text: distractor.word,
            isCorrect: false,
          );
        }),
      ];

      options.shuffle(_random);

      final question = Question(
        id: 'vocab_fill_${word.word}_$i',
        type: QuestionType.fillInBlanks,
        difficulty: _mapLevelToDifficulty(word.level, harder: true),
        question: 'Ergänze den Satz:\\n\\n"$sentence"',
        options: options,
        explanation: '${word.word}: ${word.meaning}',
        points: 12,
        targetLevel: word.level,
        relatedWords: [word],
        tags: ['vocabulary', 'fill_in_blanks'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成同义词/反义词题
  List<Question> _generateSynonymAntonymQuestions(List<Word> words, int count) {
    final questions = <Question>[];

    for (int i = 0; i < count && i < words.length; i++) {
      final word = words[i];

      final question = Question(
        id: 'vocab_syn_${word.word}_$i',
        type: QuestionType.openEnded,
        difficulty: QuestionDifficulty.veryDifficult,
        question: 'Nenne ein Synonym oder Antonym für "${word.word}".',
        correctAnswer: null,
        explanation: 'Es gibt mehrere mögliche Antworten.',
        hint: 'Denk an Wörter mit ähnlicher oder gegensätzlicher Bedeutung.',
        points: 20,
        targetLevel: word.level,
        relatedWords: [word],
        tags: ['vocabulary', 'synonym_antonym'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 从语法主题生成练习题
  @override
  Future<List<Question>> generateGrammarQuestions(
    GrammarTopic topic,
    int count,
  ) async {
    final questions = <Question>[];

    // 根据语法主题生成不同类型的练习
    switch (topic) {
      case GrammarTopic.articles:
        questions.addAll(_generateArticleQuestions(count));
        break;
      case GrammarTopic.verbConjugation:
        questions.addAll(_generateVerbConjugationQuestions(count));
        break;
      case GrammarTopic.cases:
        questions.addAll(_generateCaseQuestions(count));
        break;
      case GrammarTopic.sentenceStructure:
        questions.addAll(_generateSentenceStructureQuestions(count));
        break;
      case GrammarTopic.prepositions:
        questions.addAll(_generatePrepositionQuestions(count));
        break;
      case GrammarTopic.adjectiveEndings:
        questions.addAll(_generateAdjectiveEndingQuestions(count));
        break;
      case GrammarTopic.tenses:
        questions.addAll(_generateTenseQuestions(count));
        break;
      default:
        questions.addAll(_generateGeneralGrammarQuestions(topic, count));
    }

    return questions;
  }

  /// 生成冠词练习
  List<Question> _generateArticleQuestions(int count) {
    final questions = <Question>[];

    final nouns = [
      {'word': 'Tisch', 'article': 'der', 'gender': 'masculine'},
      {'word': 'Katze', 'article': 'die', 'gender': 'feminine'},
      {'word': 'Buch', 'article': 'das', 'gender': 'neuter'},
      {'word': 'Haus', 'article': 'das', 'gender': 'neuter'},
      {'word': 'Frau', 'article': 'die', 'gender': 'feminine'},
      {'word': 'Mann', 'article': 'der', 'gender': 'masculine'},
    ];

    for (int i = 0; i < count && i < nouns.length; i++) {
      final noun = nouns[i];

      final question = Question(
        id: 'gramm_article_${noun['word']}_$i',
        type: QuestionType.multipleChoice,
        difficulty: QuestionDifficulty.easy,
        question: 'Welcher Artikel gehört zu "${noun['word']}"?',
        options: [
          QuestionOption(id: 'a', text: 'der', isCorrect: noun['article'] == 'der'),
          QuestionOption(id: 'b', text: 'die', isCorrect: noun['article'] == 'die'),
          QuestionOption(id: 'c', text: 'das', isCorrect: noun['article'] == 'das'),
        ],
        explanation: 'Der Artikel für "${noun['word']}" ist ${noun['article']}.',
        points: 10,
        targetLevel: LanguageLevel.A1,
        relatedGrammar: GrammarTopic.articles,
        tags: ['grammar', 'articles'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成动词变位练习
  List<Question> _generateVerbConjugationQuestions(int count) {
    final questions = <Question>[];

    final verbs = [
      {'verb': 'sein', 'ich': 'bin', 'du': 'bist', 'er': 'ist'},
      {'verb': 'haben', 'ich': 'habe', 'du': 'hast', 'er': 'hat'},
      {'verb': 'werden', 'ich': 'werde', 'du': 'wirst', 'er': 'wird'},
      {'verb': 'kommen', 'ich': 'komme', 'du': 'kommst', 'er': 'kommt'},
      {'verb': 'gehen', 'ich': 'gehe', 'du': 'gehst', 'er': 'geht'},
    ];

    for (int i = 0; i < count && i < verbs.length; i++) {
      final verb = verbs[i];
      final pronoun = ['ich', 'du', 'er'][_random.nextInt(3)];
      final correct = verb[pronoun] as String;

      final question = Question(
        id: 'gramm_verb_${verb['verb']}_$i',
        type: QuestionType.fillInBlanks,
        difficulty: QuestionDifficulty.easy,
        question: 'Konjugiere das Verb:\\n\\n$pronoun _____ (${verb['verb']})',
        options: [
          QuestionOption(id: 'a', text: correct, isCorrect: true),
          QuestionOption(
            id: 'b',
            text: verb['verb'] as String,
            isCorrect: false,
          ),
        ],
        explanation: 'Die korrekte Konjugation ist: $pronoun $correct',
        points: 10,
        targetLevel: LanguageLevel.A1,
        relatedGrammar: GrammarTopic.verbConjugation,
        tags: ['grammar', 'verb_conjugation'],
      );
      questions.add(question);
    }

    return questions;
  }

  /// 生成格练习
  List<Question> _generateCaseQuestions(int count) {
    final questions = <Question>[];

    final question = Question(
      id: 'gramm_case_nominativ',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Welcher Fall ist im Nominativ?\\n\\n"Der Hund spielt."',
      options: [
        QuestionOption(id: 'a', text: 'Der', isCorrect: true),
        QuestionOption(id: 'b', text: 'Den', isCorrect: false),
        QuestionOption(id: 'c', text: 'Dem', isCorrect: false),
        QuestionOption(id: 'd', text: 'Des', isCorrect: false),
      ],
      explanation: 'Der Nominativ ist der Grundfall (Wer? Was?).',
      points: 12,
      targetLevel: LanguageLevel.A2,
      relatedGrammar: GrammarTopic.cases,
      tags: ['grammar', 'cases'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成句子结构练习
  List<Question> _generateSentenceStructureQuestions(int count) {
    final questions = <Question> [];

    final question = Question(
      id: 'gramm_sentence_structure',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Was ist die richtige Wortstellung?\\n\\n"Ich / heute / gehe / ins Kino"',
      options: [
        QuestionOption(
          id: 'a',
          text: 'Ich gehe heute ins Kino.',
          isCorrect: true,
        ),
        QuestionOption(
          id: 'b',
          text: 'Heute ich gehe ins Kino.',
          isCorrect: false,
        ),
        QuestionOption(
          id: 'c',
          text: 'Ich heute gehe ins Kino.',
          isCorrect: false,
        ),
      ],
      explanation: 'Im Deutschen steht das Verb an der zweiten Position.',
      points: 12,
      targetLevel: LanguageLevel.A2,
      relatedGrammar: GrammarTopic.sentenceStructure,
      tags: ['grammar', 'sentence_structure'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成介词练习
  List<Question> _generatePrepositionQuestions(int count) {
    final questions = <Question>[];

    final question = Question(
      id: 'gramm_prep_in',
      type: QuestionType.fillInBlanks,
      difficulty: QuestionDifficulty.medium,
      question: 'Ergänze die Präposition:\\n\\n"Ich bin _____ Hause." (drinnen)',
      options: [
        QuestionOption(id: 'a', text: 'in', isCorrect: true),
        QuestionOption(id: 'b', text: 'an', isCorrect: false),
        QuestionOption(id: 'c', text: 'auf', isCorrect: false),
      ],
      explanation: 'Die Präposition "in" mit Dativ bedeutet "drinnen".',
      points: 12,
      targetLevel: LanguageLevel.A2,
      relatedGrammar: GrammarTopic.prepositions,
      tags: ['grammar', 'prepositions'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成形容词词尾练习
  List<Question> _generateAdjectiveEndingQuestions(int count) {
    final questions = <Question> [];

    final question = Question(
      id: 'gramm_adj_ending',
      type: QuestionType.fillInBlanks,
      difficulty: QuestionDifficulty.difficult,
      question: 'Was ist die richtige Endung?\\n\\n"Der gut__ Mann"',
      options: [
        QuestionOption(id: 'a', text: 'e', isCorrect: true),
        QuestionOption(id: 'b', text: 'er', isCorrect: false),
        QuestionOption(id: 'c', text: 'es', isCorrect: false),
      ],
      explanation: 'Nach dem bestimmten Artikel im Nominativ hat das Adjektiv die Endung -e.',
      points: 15,
      targetLevel: LanguageLevel.B1,
      relatedGrammar: GrammarTopic.adjectiveEndings,
      tags: ['grammar', 'adjective_endings'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成时态练习
  List<Question> _generateTenseQuestions(int count) {
    final questions = <Question>[];

    final question = Question(
      id: 'gramm_tense_perfect',
      type: QuestionType.multipleChoice,
      difficulty: QuestionDifficulty.medium,
      question: 'Was ist das Perfekt von "gehen"?\\n\\n"Ich _____ nach Hause."',
      options: [
        QuestionOption(id: 'a', text: 'bin gegangen', isCorrect: true),
        QuestionOption(id: 'b', text: 'habe gegangen', isCorrect: false),
        QuestionOption(id: 'c', text: 'ginge', isCorrect: false),
      ],
      explanation: 'Das Verb "gehen" bildet das Perfekt mit "sein".',
      points: 12,
      targetLevel: LanguageLevel.A2,
      relatedGrammar: GrammarTopic.tenses,
      tags: ['grammar', 'tenses'],
    );
    questions.add(question);

    return questions;
  }

  /// 生成通用语法问题
  List<Question> _generateGeneralGrammarQuestions(
    GrammarTopic topic,
    int count,
  ) {
    return [
      Question(
        id: 'gramm_general_${topic.name}',
        type: QuestionType.openEnded,
        difficulty: QuestionDifficulty.medium,
        question: 'Erkläre die grammatische Regel für ${topic.name}.',
        correctAnswer: null,
        explanation: 'Diese Frage erfordert eine grammatikalische Erklärung.',
        points: 20,
        targetLevel: LanguageLevel.B1,
        relatedGrammar: topic,
        tags: ['grammar', topic.name],
      ),
    ];
  }

  /// 生成混合问题集
  @override
  Future<QuestionSet> generateMixedQuestionSet({
    required String title,
    required LanguageLevel level,
    int comprehensionCount = 3,
    int vocabularyCount = 4,
    int grammarCount = 3,
  }) async {
    final questions = <Question>[];

    // 获取适合该级别的阅读材料
    final materials = readingMaterialsExpanded
        .where((m) => m.level == level)
        .toList();

    if (materials.isNotEmpty) {
      // 生成阅读理解题
      final comprehensionQuestions = await generateComprehensionQuestions(
        materials.first,
        comprehensionCount,
      );
      questions.addAll(comprehensionQuestions);
    }

    // 获取适合该级别的词汇
    final words = <Word>[]; // TODO: 从词汇管理器获取

    if (words.isNotEmpty) {
      // 生成词汇练习题
      final vocabularyQuestions =
          await generateVocabularyQuestions(words, vocabularyCount);
      questions.addAll(vocabularyQuestions);
    }

    // 生成语法练习题
    final grammarTopics = [
      GrammarTopic.articles,
      GrammarTopic.verbConjugation,
      GrammarTopic.cases,
    ];

    for (final topic in grammarTopics) {
      final grammarQuestions = await generateGrammarQuestions(topic, 1);
      questions.addAll(grammarQuestions);
    }

    return QuestionSet(
      id: 'mixed_${level.name}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: 'Gemischte Übungen für $level',
      questions: questions,
      targetLevel: level,
    );
  }

  // ==================== 辅助方法 ====================

  /// 从文本中提取关键词
  List<String> _extractKeywords(String text) {
    final words = text.toLowerCase().split(RegExp(r'[\s.,!?;:]+'));
    words.removeWhere((w) => w.length < 4);

    // 排除常用词
    final stopwords = {
      'der', 'die', 'das', 'ein', 'eine', 'ist', 'sind', 'haben',
      'mit', 'für', 'auf', 'von', 'zu', 'bei', 'nach', 'über',
    };

    final keywords = words.where((w) => !stopwords.contains(w)).toSet().toList();

    return keywords.take(10).toList();
  }

  /// 生成事实性问题选项
  List<QuestionOption> _generateFactOptions(
    String sentence,
    List<String> keywords,
  ) {
    final correct = QuestionOption(
      id: 'a',
      text: 'Die Aussage ist richtig.',
      isCorrect: true,
    );

    final distractors = [
      QuestionOption(
        id: 'b',
        text: 'Die Aussage ist falsch.',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'Das steht nicht im Text.',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'd',
        text: 'Das ist unklar.',
        isCorrect: false,
      ),
    ];

    final options = [correct, ...distractors];
    options.shuffle(_random);
    return options;
  }

  /// 生成推理问题选项
  List<QuestionOption> _generateInferenceOptions(ReadingMaterialData material) {
    final keywords = _extractKeywords(material.content);

    return [
      QuestionOption(
        id: 'a',
        text: 'Der Text informiert über ${keywords.first}.',
        isCorrect: true,
      ),
      QuestionOption(
        id: 'b',
        text: 'Der Text kritisiert ${keywords.first}.',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'Der Text wirbt für ${keywords.first}.',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'd',
        text: 'Der Text warnt vor ${keywords.first}.',
        isCorrect: false,
      ),
    ];
  }

  /// 生成词汇语境选项
  List<QuestionOption> _generateVocabularyContextOptions(String targetWord) {
    // 基于常见词义的通用选项
    return [
      QuestionOption(id: 'a', text: 'gut', isCorrect: false),
      QuestionOption(id: 'b', text: 'schlecht', isCorrect: false),
      QuestionOption(id: 'c', text: 'wichtig', isCorrect: false),
      QuestionOption(id: 'd', text: 'interessant', isCorrect: false),
    ];
  }

  /// 生成主旨大意选项
  List<QuestionOption> _generateMainIdeaOptions(ReadingMaterialData material) {
    return [
      QuestionOption(
        id: 'a',
        text: material.category,
        isCorrect: true,
      ),
      QuestionOption(
        id: 'b',
        text: 'Persönliche Erfahrungen',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'c',
        text: 'Politische Meinung',
        isCorrect: false,
      ),
      QuestionOption(
        id: 'd',
        text: 'Wissenschaftliche Analyse',
        isCorrect: false,
      ),
    ];
  }

  /// 获取干扰项（其他词汇）
  List<Word> _getDistractors(List<Word> words, Word target, int count) {
    final others = words.where((w) => w.word != target.word).toList();
    others.shuffle(_random);
    return others.take(count).toList();
  }

  /// 将语言级别映射为问题难度
  QuestionDifficulty _mapLevelToDifficulty(
    LanguageLevel level, {
    bool harder = false,
  }) {
    final baseIndex = level.index;
    final adjustedIndex = harder
        ? (baseIndex + 1).clamp(0, QuestionDifficulty.values.length - 1)
        : baseIndex;

    switch (adjustedIndex) {
      case 0: // A1
        return QuestionDifficulty.veryEasy;
      case 1: // A2
        return QuestionDifficulty.easy;
      case 2: // B1
        return QuestionDifficulty.medium;
      case 3: // B2
        return QuestionDifficulty.difficult;
      default: // C1, C2
        return QuestionDifficulty.veryDifficult;
    }
  }
}

/// AI问题服务（单例）
class AIQuestionService {
  static AIQuestionService? _instance;
  final AIQuestionGenerator _generator;

  AIQuestionService._internal(this._generator);

  /// 获取单例
  static AIQuestionService get instance {
    _instance ??= AIQuestionService._internal(
      TemplateQuestionGenerator(),
    );
    return _instance!;
  }

  /// 自定义生成器（用于测试）
  factory AIQuestionService.withGenerator(AIQuestionGenerator generator) {
    return AIQuestionService._internal(generator);
  }

  /// 从阅读材料生成问题
  Future<List<Question>> generateFromReading(
    ReadingMaterialData material, {
    int count = 5,
  }) async {
    return await _generator.generateComprehensionQuestions(material, count);
  }

  /// 从词汇生成问题
  Future<List<Question>> generateFromVocabulary(
    List<Word> words, {
    int count = 5,
  }) async {
    return await _generator.generateVocabularyQuestions(words, count);
  }

  /// 从语法主题生成问题
  Future<List<Question>> generateFromGrammar(
    GrammarTopic topic, {
    int count = 5,
  }) async {
    return await _generator.generateGrammarQuestions(topic, count);
  }

  /// 生成完整练习集
  Future<QuestionSet> generateExerciseSet({
    required String title,
    required LanguageLevel level,
    int comprehensionCount = 3,
    int vocabularyCount = 4,
    int grammarCount = 3,
  }) async {
    return await _generator.generateMixedQuestionSet(
      title: title,
      level: level,
      comprehensionCount: comprehensionCount,
      vocabularyCount: vocabularyCount,
      grammarCount: grammarCount,
    );
  }

  /// 生成快速测试（5题）
  Future<QuestionSet> generateQuickTest(LanguageLevel level) async {
    return await generateExerciseSet(
      title: 'Schnelltest - $level',
      level: level,
      comprehensionCount: 2,
      vocabularyCount: 2,
      grammarCount: 1,
    );
  }

  /// 生成完整测试（20题）
  Future<QuestionSet> generateFullTest(LanguageLevel level) async {
    return await generateExerciseSet(
      title: 'Vollständiger Test - $level',
      level: level,
      comprehensionCount: 8,
      vocabularyCount: 8,
      grammarCount: 4,
    );
  }
}
