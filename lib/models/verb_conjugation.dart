/// 德语动词变位模型
library;

import '../core/grammar_engine.dart';

/// 时态
enum VerbTense {
  praesens,      // 现在时
  praeteritum,    // 过去时
  perfekt,       // 完成时
  plusquamperfekt, // 过去完成时
  futur1,        // 第一将来时
  futur2,        // 第二将来时
  konjunktiv1,   // 第一虚拟式
  konjunktiv2,   // 第二虚拟式
  imperativ,     // 命令式
}

/// 人称
enum Person {
  firstSingular,   // ich (我)
  secondSingular,  // du (你)
  thirdSingular,   // er/sie/es (他/她/它)
  firstPlural,     // wir (我们)
  secondPlural,    // ihr (你们)
  thirdPlural,     // sie/Sie (他们/您)
}

/// 动词类型
enum VerbType {
  regular,        // 规则动词 (weak)
  irregular,      // 不规则动词 (strong)
  mixed,          // 混合动词
  modal,          // 情态动词
  separable,      // 可分动词
  inseparable,    // 不可分动词
}

/// 动词变位
class VerbConjugation {
  final String infinitive;        // 不定式
  final String? partizip2;        // 第二分词
  final String? praeteritum;      // 过去时词干
  final VerbType type;            // 动词类型
  final String? meaning;          // 释义
  final String? example;          // 例句

  // 各时态变位
  final Map<VerbTense, Map<Person, String>> conjugations;

  const VerbConjugation({
    required this.infinitive,
    this.partizip2,
    this.praeteritum,
    required this.type,
    this.meaning,
    this.example,
    required this.conjugations,
  });

  /// 获取特定时态和人称的变位
  String getConjugation(VerbTense tense, Person person) {
    return conjugations[tense]?[person] ?? '';
  }

  /// 获取现在时变位
  Map<Person, String> get praesens =>
      conjugations[VerbTense.praesens] ?? {};

  /// 获取过去时变位
  Map<Person, String> get praeteritumConjugation =>
      conjugations[VerbTense.praeteritum] ?? {};

  /// 获取完成时变位
  Map<Person, String> get perfekt =>
      conjugations[VerbTense.perfekt] ?? {};

  /// 是否为规则动词
  bool get isRegular => type == VerbType.regular;

  /// 是否为不规则动词
  bool get isIrregular => type == VerbType.irregular;

  Map<String, dynamic> toJson() {
    return {
      'infinitive': infinitive,
      'partizip2': partizip2,
      'praeteritum': praeteritum,
      'type': type.name,
      'meaning': meaning,
      'example': example,
      'conjugations': conjugations.map(
        (tense, personMap) => MapEntry(
          tense.name,
          personMap.map((person, form) => MapEntry(
                person.name,
                form,
              )),
        ),
      ),
    };
  }

  factory VerbConjugation.fromJson(Map<String, dynamic> json) {
    return VerbConjugation(
      infinitive: json['infinitive'],
      partizip2: json['partizip2'],
      praeteritum: json['praeteritum'],
      type: VerbType.values.firstWhere((e) => e.name == json['type']),
      meaning: json['meaning'],
      example: json['example'],
      conjugations: (json['conjugations'] as Map<String, dynamic>).map(
        (tenseKey, personMap) => MapEntry(
          VerbTense.values.firstWhere((e) => e.name == tenseKey),
          (personMap as Map<String, dynamic>).map(
            (personKey, form) => MapEntry(
              Person.values.firstWhere((e) => e.name == personKey),
              form as String,
            ),
          ),
        ),
      ),
    );
  }
}

/// 人称代词
const Map<Person, String> personalPronouns = {
  Person.firstSingular: 'ich',
  Person.secondSingular: 'du',
  Person.thirdSingular: 'er/sie/es',
  Person.firstPlural: 'wir',
  Person.secondPlural: 'ihr',
  Person.thirdPlural: 'sie/Sie',
};

/// 人称代词（用于表格显示）
const Map<Person, String> personalPronounsShort = {
  Person.firstSingular: 'ich',
  Person.secondSingular: 'du',
  Person.thirdSingular: 'er',
  Person.firstPlural: 'wir',
  Person.secondPlural: 'ihr',
  Person.thirdPlural: 'sie',
};

/// 人称标签（中文）
const Map<Person, String> personLabels = {
  Person.firstSingular: '我 (第一人称单数)',
  Person.secondSingular: '你 (第二人称单数)',
  Person.thirdSingular: '他/她/它 (第三人称单数)',
  Person.firstPlural: '我们 (第一人称复数)',
  Person.secondPlural: '你们 (第二人称复数)',
  Person.thirdPlural: '他们/您 (第三人称复数)',
};

/// 时态标签（中文）
const Map<VerbTense, String> tenseLabels = {
  VerbTense.praesens: '现在时 (Präsens)',
  VerbTense.praeteritum: '过去时 (Präteritum)',
  VerbTense.perfekt: '完成时 (Perfekt)',
  VerbTense.plusquamperfekt: '过去完成时 (Plusquamperfekt)',
  VerbTense.futur1: '第一将来时 (Futur I)',
  VerbTense.futur2: '第二将来时 (Futur II)',
  VerbTense.konjunktiv1: '第一虚拟式 (Konjunktiv I)',
  VerbTense.konjunktiv2: '第二虚拟式 (Konjunktiv II)',
  VerbTense.imperativ: '命令式 (Imperativ)',
};

/// 动词类型标签
const Map<VerbType, String> verbTypeLabels = {
  VerbType.regular: '规则动词 (弱变化)',
  VerbType.irregular: '不规则动词 (强变化)',
  VerbType.mixed: '混合动词',
  VerbType.modal: '情态动词',
  VerbType.separable: '可分动词',
  VerbType.inseparable: '不可分动词',
};
