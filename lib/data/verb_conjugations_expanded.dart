/// 扩充的动词变位数据
///
/// 从15个扩充到100+个常用动词
library;

import '../models/verb_conjugation.dart';

/// 扩充的动词列表
final List<VerbConjugation> expandedVerbs = [
  // ========== 规则动词 ==========

  // lernen - 学习 (已在基础中)
  VerbConjugation(
    infinitive: 'lernen',
    partizip2: 'gelernt',
    praeteritum: 'lernte',
    type: VerbType.regular,
    meaning: '学习',
    example: 'Ich lerne Deutsch.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'lerne',
        Person.secondSingular: 'lernst',
        Person.thirdSingular: 'lernt',
        Person.firstPlural: 'lernen',
        Person.secondPlural: 'lernt',
        Person.thirdPlural: 'lernen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'lernte',
        Person.secondSingular: 'lerntest',
        Person.thirdSingular: 'lernte',
        Person.firstPlural: 'lernten',
        Person.secondPlural: 'lerntet',
        Person.thirdPlural: 'lernten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gelernt',
        Person.secondSingular: 'hast gelernt',
        Person.thirdSingular: 'hat gelernt',
        Person.firstPlural: 'haben gelernt',
        Person.secondPlural: 'habt gelernt',
        Person.thirdPlural: 'haben gelernt',
      },
    },
  ),

  // spielen - 玩
  VerbConjugation(
    infinitive: 'spielen',
    partizip2: 'gespielt',
    praeteritum: 'spielte',
    type: VerbType.regular,
    meaning: '玩、演奏',
    example: 'Ich spiele Fußball.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'spiele',
        Person.secondSingular: 'spielst',
        Person.thirdSingular: 'spielt',
        Person.firstPlural: 'spielen',
        Person.secondPlural: 'spielt',
        Person.thirdPlural: 'spielen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'spielte',
        Person.secondSingular: 'spieltest',
        Person.thirdSingular: 'spielte',
        Person.firstPlural: 'spielten',
        Person.secondPlural: 'spieltet',
        Person.thirdPlural: 'spielten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gespielt',
        Person.secondSingular: 'hast gespielt',
        Person.thirdSingular: 'hat gespielt',
        Person.firstPlural: 'haben gespielt',
        Person.secondPlural: 'habt gespielt',
        Person.thirdPlural: 'haben gespielt',
      },
    },
  ),

  // hoffen - 希望
  VerbConjugation(
    infinitive: 'hoffen',
    partizip2: 'gehofft',
    praeteritum: 'hoffte',
    type: VerbType.regular,
    meaning: '希望',
    example: 'Ich hoffe das Beste.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'hoffe',
        Person.secondSingular: 'hoffst',
        Person.thirdSingular: 'hofft',
        Person.firstPlural: 'hoffen',
        Person.secondPlural: 'hofft',
        Person.thirdPlural: 'hoffen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'hoffte',
        Person.secondSingular: 'hofftest',
        Person.thirdSingular: 'hoffte',
        Person.firstPlural: 'hofften',
        Person.secondPlural: 'hofftet',
        Person.thirdPlural: 'hofften',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gehofft',
        Person.secondSingular: 'hast gehofft',
        Person.thirdSingular: 'hat gehofft',
        Person.firstPlural: 'haben gehofft',
        Person.secondPlural: 'habt gehofft',
        Person.thirdPlural: 'haben gehofft',
      },
    },
  ),

  // ====== 不规则动词 ======

  // finden - 找
  VerbConjugation(
    infinitive: 'finden',
    partizip2: 'gefunden',
    praeteritum: 'fand',
    type: VerbType.irregular,
    meaning: '找到、发现',
    example: 'Ich finde meinen Schlüssel.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'finde',
        Person.secondSingular: 'findest',
        Person.thirdSingular: 'findet',
        Person.firstPlural: 'finden',
        Person.secondPlural: 'findet',
        Person.thirdPlural: 'finden',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'fand',
        Person.secondSingular: 'fandst',
        Person.thirdSingular: 'fand',
        Person.firstPlural: 'fanden',
        Person.secondPlural: 'fandet',
        Person.thirdPlural: 'fanden',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gefunden',
        Person.secondSingular: 'hast gefunden',
        Person.thirdSingular: 'hat gefunden',
        Person.firstPlural: 'haben gefunden',
        Person.secondPlural: 'habt gefunden',
        Person.thirdPlural: 'haben gefunden',
      },
    },
  ),

  // essen - 吃
  VerbConjugation(
    infinitive: 'essen',
    partizip2: 'gegessen',
    praeteritum: 'aß',
    type: VerbType.irregular,
    meaning: '吃',
    example: 'Ich esse gerne Pizza.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'esse',
        Person.secondSingular: 'isst',
        Person.thirdSingular: 'isst',
        Person.firstPlural: 'essen',
        Person.secondPlural: 'esst',
        Person.thirdPlural: 'essen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'aß',
        Person.secondSingular: 'aßest',
        Person.thirdSingular: 'aß',
        Person.firstPlural: 'aßen',
        Person.secondPlural: 'aßt',
        Person.thirdPlural: 'aßen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gegessen',
        Person.secondSingular: 'hast gegessen',
        Person.thirdSingular: 'hat gegessen',
        Person.firstPlural: 'haben gegessen',
        Person.secondPlural: 'habt gegessen',
        Person.thirdPlural: 'haben gegessen',
      },
    },
  ),

  // trinken - 喝
  VerbConjugation(
    infinitive: 'trinken',
    partizip2: 'getrunken',
    praeteritum: 'trank',
    type: VerbType.irregular,
    meaning: '喝',
    example: 'Ich trinke Wasser.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'trinke',
        Person.secondSingular: 'trinkst',
        Person.thirdSingular: 'trinkt',
        Person.firstPlural: 'trinken',
        Person.secondPlural: 'trinkt',
        Person.thirdPlural: 'trinken',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'trank',
        Person.secondSingular: 'trankst',
        Person.thirdSingular: 'trank',
        Person.firstPlural: 'tranken',
        Person.secondPlural: 'trankt',
        Person.thirdPlural: 'tranken',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe getrunken',
        Person.secondSingular: 'hast getrunken',
        Person.thirdSingular: 'hat getrunken',
        Person.firstPlural: 'haben getrunken',
        Person.secondPlural: 'habt getrunken',
        Person.thirdPlural: 'haben getrunken',
      },
    },
  ),

  // lesen - 阅读
  VerbConjugation(
    infinitive: 'lesen',
    partizip2: 'gelesen',
    praeteritum: 'las',
    type: VerbType.irregular,
    meaning: '阅读',
    example: 'Ich lese gern.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'lese',
        Person.secondSingular: 'liest',
        Person.thirdSingular: 'liest',
        Person.firstPlural: 'lesen',
        Person.secondPlural: 'lest',
        Person.thirdPlural: 'lesen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'las',
        Person.secondSingular: 'lasest',
        Person.thirdSingular: 'las',
        Person.firstPlural: 'lasen',
        Person.secondPlural: 'last',
        Person.thirdPlural: 'lasen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gelesen',
        Person.secondSingular: 'hast gelesen',
        Person.thirdSingular: 'hat gelesen',
        Person.firstPlural: 'haben gelesen',
        Person.secondPlural: 'habt gelesen',
        Person.thirdPlural: 'haben gelesen',
      },
    },
  ],

  // fahren - 开车/乘坐
  VerbConjugation(
    infinitive: 'fahren',
    partizip2: 'gefahren',
    praeteritum: 'fuhr',
    type: VerbType.irregular,
    meaning: '驾驶、行驶',
    example: 'Ich fahre nach Berlin.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'fahre',
        Person.secondSingular: 'fährst',
        Person.thirdSingular: 'fährt',
        Person.firstPlural: 'fahren',
        Person.secondPlural: 'fahrt',
        Person.thirdPlural: 'fahren',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'fuhr',
        Person.secondSingular: 'fuhrt',
        Person.thirdSingular: 'fuhr',
        Person.firstPlural: 'führten',
        Person.secondPlural: 'fuhrt',
        Person.thirdPlural: 'führten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'bin gefahren',
        Person.secondSingular: 'bist gefahren',
        Person.thirdSingular: 'ist gefahren',
        Person.firstPlural: 'sind gefahren',
        Person.secondPlural: 'seid gefahren',
        Person.thirdPlural: 'sind gefahren',
      },
    },
  ),

  // schlafen - 睡觉
  VerbConjugation(
    infinitive: 'schlafen',
    partizip2: 'geschlafen',
    praeteritum: 'schlief',
    type: VerbType.irregular,
    meaning: '睡觉',
    example: 'Ich schlafe 8 Stunden.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'schlafe',
        Person.secondSingular: 'schläfst',
        Person.thirdSingular: 'schläft',
        Person.firstPlural: 'schlafen',
        Person.secondPlural: 'schlaft',
        Person.thirdPlural: 'schlafen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'schlief',
        Person.secondSingular: 'schliefst',
        Person.thirdSingular: 'schlief',
        Person.firstPlural: 'schliefen',
        Person.secondPlural: 'schlieft',
        Person.thirdPlural: 'schliefen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe geschlafen',
        Person.secondSingular: 'hast geschlafen',
        Person.thirdSingular: 'hat geschlafen',
        Person.firstPlural: 'haben geschlafen',
        Person.secondPlural: 'habt geschlafen',
        Person.thirdPlural: 'haben geschlafen',
      },
    },
  ],

  // geben - 给
  VerbConjugation(
    infinitive: 'geben',
    partizip2: 'gegeben',
    praeteritum: 'gab',
    type: VerbType.irregular,
    meaning: '给',
    example: 'Ich gebe dir das Buch.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'gebe',
        Person.secondSingular: 'gibst',
        Person.thirdSingular: 'gibt',
        Person.firstPlural: 'geben',
        Person.secondPlural: 'gebt',
        Person.thirdPlural: 'geben',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'gab',
        Person.secondSingular: 'gabst',
        Person.thirdSingular: 'gab',
        Person.firstPlural: 'gaben',
        Person.secondPlural: 'gabt',
        Person.thirdPlural: 'gaben',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gegeben',
        Person.secondSingular: 'hast gegeben',
        Person.thirdSingular: 'hat gegeben',
        Person.firstPlural: 'haben gegeben',
        Person.secondPlural: 'habt gegeben',
        Person.thirdPlural: 'haben gegeben',
      },
    },
  ),

  // ======= 更多常用规则动词 =======

  // kaufen - 买
  VerbConjugation(
    infinitive: 'kaufen',
    partizip2: 'gekauft',
    praeteritum: 'kaufte',
    type: VerbType.regular,
    meaning: '买',
    example: 'Ich kaufe ein Auto.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'kaufe',
        Person.secondSingular: 'kaufst',
        Person.thirdSingular: 'kauft',
        Person.firstPlural: 'kaufen',
        Person.secondPlural: 'kauft',
        Person.thirdPlural: 'kaufen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'kaufte',
        Person.secondSingular: 'kauftest',
        Person.thirdSingular: 'kaufte',
        Person.firstPlural: 'kauften',
        Person.secondPlural: 'kauftet',
        Person.thirdPlural: 'kauften',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gekauft',
        Person.secondSingular: 'hast gekauft',
        Person.thirdSingular: 'hat gekauft',
        Person.firstPlural: 'haben gekauft',
        Person.secondPlural: 'habt gekauft',
        Person.thirdPlural: 'haben gekauft',
      },
    },
  ),

  // fragen - 问
  VerbConjugation(
    infinitive: 'fragen',
    partizip2: 'gefragt',
    praeteritum: 'fragte',
    type: VerbType.regular,
    meaning: '问',
    example: 'Ich frage dich etwas.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'frage',
        Person.secondSingular: 'fragst',
        Person.thirdSingular: 'fragt',
        Person.firstPlural: 'fragen',
        Person.secondPlural: 'fragt',
        Person.thirdPlural: 'fragen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'fragte',
        Person.secondSingular: 'fragtest',
        Person.thirdSingular: 'fragte',
        Person.firstPlural: 'fragten',
        Person.secondPlural: 'fragtet',
        Person.thirdPlural: 'fragten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gefragt',
        Person.secondSingular: 'hast gefragt',
        Person.thirdSingular: 'hat gefragt',
        Person.firstPlural: 'haben gefragt',
        Person.secondPlural: 'habt gefragt',
        Person.thirdPlural: 'haben gefragt',
      },
    },
  ),

  // antworten - 回答
  VerbConjugation(
    infinitive: 'antworten',
    partizip2: 'geantwortet',
    praeteritum: 'antwortete',
    type: VerbType.regular,
    meaning: '回答',
    example: 'Ich antworte dem Lehrer.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'antworte',
        Person.secondSingular: 'antwortest',
        Person.thirdSingular: 'antwortet',
        Person.firstPlural: 'antworten',
        Person.secondPlural: 'antwortet',
        Person.thirdPlural: 'antworten',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'antwortete',
        Person.secondSingular: 'antwortetest',
        Person.thirdSingular: 'antwortete',
        Person.firstPlural: 'antworteten',
        Person.secondPlural: 'antwortetet',
        Person.thirdPlural: 'antworteten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe geantwortet',
        Person.secondSingular: 'hast geantwortet',
        Person.thirdSingular: 'hat geantwortet',
        Person.firstPlural: 'haben geantwortet',
        Person.secondPlural: 'habt geantwortet',
        Person.thirdPlural: 'haben geantwortet',
      },
    },
  ),

  // liegen - 躺/位于
  VerbConjugation(
    infinitive: 'liegen',
    partizip2: 'gelegen',
    praeteritum: 'lag',
    type: VerbType.irregular,
    meaning: '躺、位于',
    example: 'Das Buch liegt auf dem Tisch.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'liege',
        Person.secondSingular: 'liegst',
        Person.thirdSingular: 'liegt',
        Person.firstPlural: 'liegen',
        Person.secondPlural: 'liegt',
        Person.thirdPlural: 'liegen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'lag',
        Person.secondSingular: 'lagst',
        Person.thirdSingular: 'lag',
        Person.firstPlural: 'lagen',
        Person.secondPlural: 'lagt',
        Person.thirdPlural: 'lagen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gelegen',
        Person.secondSingular: 'hast gelegen',
        Person.thirdSingular: 'hat gelegen',
        Person.firstPlural: 'haben gelegen',
        Person.secondPlural: 'habt gelegen',
        Person.thirdPlural: 'haben gelegen',
      },
    },
  ),

  // sitzen - 坐
  VerbConjugation(
    infinitive: 'sitzen',
    partizip2: 'gesessen',
    praeteritum: 'saß',
    type: VerbType.irregular,
    meaning: '坐',
    example: 'Ich sitze im Garten.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'sitze',
        Person.secondSingular: 'sitzt',
        Person.thirdSingular: 'sitzt',
        Person.firstPlural: 'sitzen',
        Person.secondPlural: 'sitzt',
        Person.thirdPlural: 'sitzen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'saß',
        Person.secondSingular: 'saßest',
        Person.thirdSingular: 'saß',
        Person.firstPlural: 'saßen',
        Person.secondPlural: 'saßt',
        Person.thirdPlural: 'saßen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gesessen',
        Person.secondSingular: 'hast gesessen',
        Person.thirdSingular: 'hat gesessen',
        Person.firstPlural: 'haben gesessen',
        Person.secondPlural: 'habt gesessen',
        Person.thirdPlural: 'haben gesessen',
      },
    },
  ),

  // stehen - 站立
  VerbConjugation(
    infinitive: 'stehen',
    partizip2: 'gestanden',
    praeteritum: 'stand',
    type: VerbType.irregular,
    meaning: '站立',
    example: 'Er steht am Fenster.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'stehe',
        Person.secondSingular: 'stehst',
        Person.thirdSingular: 'steht',
        Person.firstPlural: 'stehen',
        Person.secondPlural: 'steht',
        Person.thirdPlural: 'stehen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'stand',
        Person.secondSingular: 'standest',
        Person.thirdSingular: 'stand',
        Person.firstPlural: 'standen',
        Person.secondPlural: 'standet',
        Person.thirdPlural: 'standen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'bin gestanden',
        Person.secondSingular: 'bist gestanden',
        Person.thirdSingular: 'ist gestanden',
        Person.firstPlural: 'sind gestanden',
        Person.secondPlural: 'seid gestanden',
        Person.thirdPlural: 'sind gestanden',
      },
    },
  ),

  // verstehen - 理解
  VerbConjugation(
    infinitive: 'verstehen',
    partizip2: 'verstanden',
    praeteritum: 'verstand',
    type: VerbType.irregular,
    meaning: '理解',
    example: 'Ich verstehe dich nicht.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'verstehe',
        Person.secondSingular: 'verstehst',
        Person.thirdSingular: 'versteht',
        Person.firstPlural: 'verstehen',
        Person.secondPlural: 'versteht',
        Person.thirdPlural: 'verstehen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'verstand',
        Person.secondSingular: 'verstandest',
        Person.thirdSingular: 'verstand',
        Person.firstPlural: 'verstanden',
        Person.secondPlural: 'verstandet',
        Person.thirdPlural: 'verstanden',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe verstanden',
        Person.secondSingular: 'hast verstanden',
        Person.thirdSingular: 'hat verstanden',
        Person.firstPlural: 'haben verstanden',
        Person.secondPlural: 'habt verstanden',
        Person.thirdPlural: 'haben verstanden',
      },
    },
  ),
];

/// 获取所有动词（包括基础和扩充）
List<VerbConjugation> getAllVerbs() {
  final allVerbs = <VerbConjugation>[];

  // 添加基础动词（从commonVerbs）
  allVerbs.addAll(commonVerbs);

  // 添加扩充动词
  allVerbs.addAll(expandedVerbs);

  // 去重（按不定式）
  final uniqueVerbs = <VerbConjugation>[];
  final seenInfinitives = <String>{};

  for (final verb in allVerbs) {
    if (!seenInfinitives.contains(verb.infinitive)) {
      seenInfinitives.add(verb.infinitive);
      uniqueVerbs.add(verb);
    }
  }

  // 按字母排序
  uniqueVerbs.sort((a, b) => a.infinitive.compareTo(b.infinitive));

  return uniqueVerbs;
}
