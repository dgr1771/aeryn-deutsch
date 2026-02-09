/// 德语格变表模型
library;

import '../core/grammar_engine.dart';

/// 冠词类型
enum ArticleType {
  definite,   // 定冠词 (der/die/das)
  indefinite, // 不定冠词 (ein/eine)
  negative,   // 否定冠词 (kein/keine)
  possessive, // 物主冠词 (mein/dein/...)
}

/// 格变
class Declension {
  final String word;              // 词语
  final GermanGender gender;      // 性别
  final ArticleType articleType;  // 冠词类型
  final String? meaning;          // 释义

  // 各格各数的变化
  final Map<GermanCase, Map<Number, String>> declensions;

  const Declension({
    required this.word,
    required this.gender,
    required this.articleType,
    this.meaning,
    required this.declensions,
  });

  /// 获取特定格和数的变化
  String getDeclension(GermanCase case_, Number number) {
    return declensions[case_]?[number] ?? '';
  }

  /// 获取单数变化
  Map<GermanCase, String> get singularDeclension {
    return {
      for (final case_ in GermanCase.values)
        case_: getDeclension(case_, Number.singular),
    };
  }

  /// 获取复数变化
  Map<GermanCase, String> get pluralDeclension {
    return {
      for (final case_ in GermanCase.values)
        case_: getDeclension(case_, Number.plural),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'gender': gender.name,
      'articleType': articleType.name,
      'meaning': meaning,
      'declensions': declensions.map(
        (case_, numberMap) => MapEntry(
          case_.name,
          numberMap.map((number, form) => MapEntry(
                number.name,
                form,
              )),
        ),
      ),
    };
  }

  factory Declension.fromJson(Map<String, dynamic> json) {
    return Declension(
      word: json['word'],
      gender: GermanGender.values.firstWhere((e) => e.name == json['gender']),
      articleType: ArticleType.values.firstWhere((e) => e.name == json['articleType']),
      meaning: json['meaning'],
      declensions: (json['declensions'] as Map<String, dynamic>).map(
        (caseKey, numberMap) => MapEntry(
          GermanCase.values.firstWhere((e) => e.name == caseKey),
          (numberMap as Map<String, dynamic>).map(
            (numberKey, form) => MapEntry(
              Number.values.firstWhere((e) => e.name == numberKey),
              form as String,
            ),
          ),
        ),
      ),
    );
  }
}

/// 格的标签（中文）
const Map<GermanCase, String> caseLabels = {
  GermanCase.nominativ: '第一格 (Nominativ) - 主格',
  GermanCase.akkusativ: '第四格 (Akkusativ) - 宾格',
  GermanCase.dativ: '第三格 (Dativ) - 间接格',
  GermanCase.genitiv: '第二格 (Genitiv) - 所有格',
};

/// 格的简短标签
const Map<GermanCase, String> caseShortLabels = {
  GermanCase.nominativ: 'Nom',
  GermanCase.akkusativ: 'Akk',
  GermanCase.dativ: 'Dat',
  GermanCase.genitiv: 'Gen',
};

/// 格的功能说明
const Map<GermanCase, String> caseFunctions = {
  GermanCase.nominativ: '做主语，在句首，回答"谁/什么"的问题',
  GermanCase.akkusativ: '做直接宾语，回答"谁/什么"的问题',
  GermanCase.dativ: '做间接宾语，回答"谁/什么"的问题',
  GermanCase.genitiv: '表示所有关系，回答"谁的"的问题',
};

/// 数的标签
const Map<Number, String> numberLabels = {
  Number.singular: '单数 (Singular)',
  Number.plural: '复数 (Plural)',
};

/// 冠词类型标签
const Map<ArticleType, String> articleTypeLabels = {
  ArticleType.definite: '定冠词 (der/die/das)',
  ArticleType.indefinite: '不定冠词 (ein/eine)',
  ArticleType.negative: '否定冠词 (kein/keine)',
  ArticleType.possessive: '物主冠词 (mein/dein/...)',
};

/// 名词短语变位（名词 + 冠词）
class NounPhraseDeclension {
  final String noun;              // 名词
  final GermanGender gender;      // 性别
  final Number number;            // 数

  // 定冠词变化
  final Map<GermanCase, String> definiteArticle;

  // 不定冠词变化（仅单数）
  final Map<GermanCase, String>? indefiniteArticle;

  // 否定冠词变化
  final Map<GermanCase, String> negativeArticle;

  // 名词本身的变化（如复数词尾）
  final Map<GermanCase, String> nounForm;

  const NounPhraseDeclension({
    required this.noun,
    required this.gender,
    required this.number,
    required this.definiteArticle,
    this.indefiniteArticle,
    required this.negativeArticle,
    required this.nounForm,
  });

  /// 获取完整短语（冠词 + 名词）
  String getPhrase(GermanCase case_, ArticleType articleType) {
    final article = switch (articleType) {
      ArticleType.definite => definiteArticle[case_],
      ArticleType.indefinite => indefiniteArticle?[case_],
      ArticleType.negative => negativeArticle[case_],
      ArticleType.possessive => null, // 物主冠词需要单独处理
    };

    final noun = nounForm[case_];

    if (article == null) return noun;
    return '$article $noun';
  }

  Map<String, dynamic> toJson() {
    return {
      'noun': noun,
      'gender': gender.name,
      'number': number.name,
      'definiteArticle': definiteArticle,
      'indefiniteArticle': indefiniteArticle,
      'negativeArticle': negativeArticle,
      'nounForm': nounForm,
    };
  }

  factory NounPhraseDeclension.fromJson(Map<String, dynamic> json) {
    return NounPhraseDeclension(
      noun: json['noun'],
      gender: GermanGender.values.firstWhere((e) => e.name == json['gender']),
      number: Number.values.firstWhere((e) => e.name == json['number']),
      definiteArticle: Map<GermanCase, String>.from(
        json['definiteArticle'].map(
          (key, value) => MapEntry(
            GermanCase.values.firstWhere((e) => e.name == key),
            value as String,
          ),
        ),
      ),
      indefiniteArticle: json['indefiniteArticle'] != null
          ? Map<GermanCase, String>.from(
              json['indefiniteArticle'].map(
                (key, value) => MapEntry(
                  GermanCase.values.firstWhere((e) => e.name == key),
                  value as String,
                ),
              ),
            )
          : null,
      negativeArticle: Map<GermanCase, String>.from(
        json['negativeArticle'].map(
          (key, value) => MapEntry(
            GermanCase.values.firstWhere((e) => e.name == key),
            value as String,
          ),
        ),
      ),
      nounForm: Map<GermanCase, String>.from(
        json['nounForm'].map(
          (key, value) => MapEntry(
            GermanCase.values.firstWhere((e) => e.name == key),
            value as String,
          ),
        ),
      ),
    );
  }
}
