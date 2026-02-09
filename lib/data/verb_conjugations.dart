/// 德语动词变位数据
library;

import '../models/verb_conjugation.dart';

/// 常用动词变位数据
///
/// 包含最常用的德语动词及其变位
final List<VerbConjugation> commonVerbs = [
  // ========== 规则动词 (弱变化) ==========

  // machen - 做/制作
  VerbConjugation(
    infinitive: 'machen',
    partizip2: 'gemacht',
    praeteritum: 'machte',
    type: VerbType.regular,
    meaning: '做、制作',
    example: 'Ich mache meine Hausaufgaben.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'mache',
        Person.secondSingular: 'machst',
        Person.thirdSingular: 'macht',
        Person.firstPlural: 'machen',
        Person.secondPlural: 'macht',
        Person.thirdPlural: 'machen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'machte',
        Person.secondSingular: 'machtest',
        Person.thirdSingular: 'machte',
        Person.firstPlural: 'machten',
        Person.secondPlural: 'machtet',
        Person.thirdPlural: 'machten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gemacht',
        Person.secondSingular: 'hast gemacht',
        Person.thirdSingular: 'hat gemacht',
        Person.firstPlural: 'haben gemacht',
        Person.secondPlural: 'habt gemacht',
        Person.thirdPlural: 'haben gemacht',
      },
    },
  ),

  // arbeiten - 工作
  VerbConjugation(
    infinitive: 'arbeiten',
    partizip2: 'gearbeitet',
    praeteritum: 'arbeitete',
    type: VerbType.regular,
    meaning: '工作',
    example: 'Ich arbeite zu Hause.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'arbeite',
        Person.secondSingular: 'arbeitest',
        Person.thirdSingular: 'arbeitet',
        Person.firstPlural: 'arbeiten',
        Person.secondPlural: 'arbeitet',
        Person.thirdPlural: 'arbeiten',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'arbeitete',
        Person.secondSingular: 'arbeitetest',
        Person.thirdSingular: 'arbeitete',
        Person.firstPlural: 'arbeiteten',
        Person.secondPlural: 'arbeitetet',
        Person.thirdPlural: 'arbeiteten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gearbeitet',
        Person.secondSingular: 'hast gearbeitet',
        Person.thirdSingular: 'hat gearbeitet',
        Person.firstPlural: 'haben gearbeitet',
        Person.secondPlural: 'habt gearbeitet',
        Person.thirdPlural: 'haben gearbeitet',
      },
    },
  ),

  // ========== 不规则动词 (强变化) ==========

  // sein - 是 (最重要)
  VerbConjugation(
    infinitive: 'sein',
    partizip2: 'gewesen',
    praeteritum: 'war',
    type: VerbType.irregular,
    meaning: '是',
    example: 'Ich bin Student.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'bin',
        Person.secondSingular: 'bist',
        Person.thirdSingular: 'ist',
        Person.firstPlural: 'sind',
        Person.secondPlural: 'seid',
        Person.thirdPlural: 'sind',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'war',
        Person.secondSingular: 'warst',
        Person.thirdSingular: 'war',
        Person.firstPlural: 'waren',
        Person.secondPlural: 'wart',
        Person.thirdPlural: 'waren',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'bin gewesen',
        Person.secondSingular: 'bist gewesen',
        Person.thirdSingular: 'ist gewesen',
        Person.firstPlural: 'sind gewesen',
        Person.secondPlural: 'seid gewesen',
        Person.thirdPlural: 'sind gewesen',
      },
    },
  ),

  // haben - 有 (最重要)
  VerbConjugation(
    infinitive: 'haben',
    partizip2: 'gehabt',
    praeteritum: 'hatte',
    type: VerbType.irregular,
    meaning: '有',
    example: 'Ich habe ein Auto.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'habe',
        Person.secondSingular: 'hast',
        Person.thirdSingular: 'hat',
        Person.firstPlural: 'haben',
        Person.secondPlural: 'habt',
        Person.thirdPlural: 'haben',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'hatte',
        Person.secondSingular: 'hattest',
        Person.thirdSingular: 'hatte',
        Person.firstPlural: 'hatten',
        Person.secondPlural: 'hattet',
        Person.thirdPlural: 'hatten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gehabt',
        Person.secondSingular: 'hast gehabt',
        Person.thirdSingular: 'hat gehabt',
        Person.firstPlural: 'haben gehabt',
        Person.secondPlural: 'habt gehabt',
        Person.thirdPlural: 'haben gehabt',
      },
    },
  ),

  // werden - 成为/将来时助词
  VerbConjugation(
    infinitive: 'werden',
    partizip2: 'geworden',
    praeteritum: 'wurde',
    type: VerbType.irregular,
    meaning: '成为、将会',
    example: 'Ich werde Arzt.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'werde',
        Person.secondSingular: 'wirst',
        Person.thirdSingular: 'wird',
        Person.firstPlural: 'werden',
        Person.secondPlural: 'werdet',
        Person.thirdPlural: 'werden',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'wurde',
        Person.secondSingular: 'wurdest',
        Person.thirdSingular: 'wurde',
        Person.firstPlural: 'wurden',
        Person.secondPlural: 'wurdet',
        Person.thirdPlural: 'wurden',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'bin geworden',
        Person.secondSingular: 'bist geworden',
        Person.thirdSingular: 'ist geworden',
        Person.firstPlural: 'sind geworden',
        Person.secondPlural: 'seid geworden',
        Person.thirdPlural: 'sind geworden',
      },
    },
  ),

  // gehen - 走/去
  VerbConjugation(
    infinitive: 'gehen',
    partizip2: 'gegangen',
    praeteritum: 'ging',
    type: VerbType.irregular,
    meaning: '走、去',
    example: 'Ich gehe zur Schule.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'gehe',
        Person.secondSingular: 'gehst',
        Person.thirdSingular: 'geht',
        Person.firstPlural: 'gehen',
        Person.secondPlural: 'geht',
        Person.thirdPlural: 'gehen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'ging',
        Person.secondSingular: 'gingst',
        Person.thirdSingular: 'ging',
        Person.firstPlural: 'gingen',
        Person.secondPlural: 'gingt',
        Person.thirdPlural: 'gingen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'bin gegangen',
        Person.secondSingular: 'bist gegangen',
        Person.thirdSingular: 'ist gegangen',
        Person.firstPlural: 'sind gegangen',
        Person.secondPlural: 'seid gegangen',
        Person.thirdPlural: 'sind gegangen',
      },
    },
  ),

  // ========== 情态动词 ==========

  // können - 能够
  VerbConjugation(
    infinitive: 'können',
    partizip2: 'gekonnt',
    praeteritum: 'konnte',
    type: VerbType.modal,
    meaning: '能够、可以',
    example: 'Ich kann Deutsch sprechen.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'kann',
        Person.secondSingular: 'kannst',
        Person.thirdSingular: 'kann',
        Person.firstPlural: 'können',
        Person.secondPlural: 'könnt',
        Person.thirdPlural: 'können',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'konnte',
        Person.secondSingular: 'konntest',
        Person.thirdSingular: 'konnte',
        Person.firstPlural: 'konnten',
        Person.secondPlural: 'konntet',
        Person.thirdPlural: 'konnten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gekonnt',
        Person.secondSingular: 'hast gekonnt',
        Person.thirdSingular: 'hat gekonnt',
        Person.firstPlural: 'haben gekonnt',
        Person.secondPlural: 'habt gekonnt',
        Person.thirdPlural: 'haben gekonnt',
      },
    },
  ),

  // müssen - 必须
  VerbConjugation(
    infinitive: 'müssen',
    partizip2: 'gemusst',
    praeteritum: 'musste',
    type: VerbType.modal,
    meaning: '必须',
    example: 'Ich muss lernen.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'muss',
        Person.secondSingular: 'musst',
        Person.thirdSingular: 'muss',
        Person.firstPlural: 'müssen',
        Person.secondPlural: 'müsst',
        Person.thirdPlural: 'müssen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'musste',
        Person.secondSingular: 'musstest',
        Person.thirdSingular: 'musste',
        Person.firstPlural: 'mussten',
        Person.secondPlural: 'musstet',
        Person.thirdPlural: 'mussten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gemusst',
        Person.secondSingular: 'hast gemusst',
        Person.thirdSingular: 'hat gemusst',
        Person.firstPlural: 'haben gemusst',
        Person.secondPlural: 'habt gemusst',
        Person.thirdPlural: 'haben gemusst',
      },
    },
  ),

  // wollen - 想要
  VerbConjugation(
    infinitive: 'wollen',
    partizip2: 'gewollt',
    praeteritum: 'wollte',
    type: VerbType.modal,
    meaning: '想要',
    example: 'Ich will nach Deutschland.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'will',
        Person.secondSingular: 'willst',
        Person.thirdSingular: 'will',
        Person.firstPlural: 'wollen',
        Person.secondPlural: 'wollt',
        Person.thirdPlural: 'wollen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'wollte',
        Person.secondSingular: 'wolltest',
        Person.thirdSingular: 'wollte',
        Person.firstPlural: 'wollten',
        Person.secondPlural: 'wolltet',
        Person.thirdPlural: 'wollten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gewollt',
        Person.secondSingular: 'hast gewollt',
        Person.thirdSingular: 'hat gewollt',
        Person.firstPlural: 'haben gewollt',
        Person.secondPlural: 'habt gewollt',
        Person.thirdPlural: 'haben gewollt',
      },
    },
  ),

  // sollen - 应该
  VerbConjugation(
    infinitive: 'sollen',
    partizip2: 'gesollt',
    praeteritum: 'sollte',
    type: VerbType.modal,
    meaning: '应该',
    example: 'Ich soll lernen.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'soll',
        Person.secondSingular: 'sollst',
        Person.thirdSingular: 'soll',
        Person.firstPlural: 'sollen',
        Person.secondPlural: 'sollt',
        Person.thirdPlural: 'sollen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'sollte',
        Person.secondSingular: 'solltest',
        Person.thirdSingular: 'sollte',
        Person.firstPlural: 'sollten',
        Person.secondPlural: 'solltet',
        Person.thirdPlural: 'sollten',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gesollt',
        Person.secondSingular: 'hast gesollt',
        Person.thirdSingular: 'hat gesollt',
        Person.firstPlural: 'haben gesollt',
        Person.secondPlural: 'habt gesollt',
        Person.thirdPlural: 'haben gesollt',
      },
    },
  ),

  // dürfen - 允许
  VerbConjugation(
    infinitive: 'dürfen',
    partizip2: 'gedurft',
    praeteritum: 'durfte',
    type: VerbType.modal,
    meaning: '允许',
    example: 'Darf ich hier rauchen?',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'darf',
        Person.secondSingular: 'darfst',
        Person.thirdSingular: 'darf',
        Person.firstPlural: 'dürfen',
        Person.secondPlural: 'dürft',
        Person.thirdPlural: 'dürfen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'durfte',
        Person.secondSingular: 'durftest',
        Person.thirdSingular: 'durfte',
        Person.firstPlural: 'durften',
        Person.secondPlural: 'durftet',
        Person.thirdPlural: 'durften',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gedurft',
        Person.secondSingular: 'hast gedurft',
        Person.thirdSingular: 'hat gedurft',
        Person.firstPlural: 'haben gedurft',
        Person.secondPlural: 'habt gedurft',
        Person.thirdPlural: 'haben gedurft',
      },
    },
  ),

  // ========== 更多常用强变化动词 ==========

  // sprechen - 说
  VerbConjugation(
    infinitive: 'sprechen',
    partizip2: 'gesprochen',
    praeteritum: 'sprach',
    type: VerbType.irregular,
    meaning: '说、讲',
    example: 'Ich spreche Deutsch.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'spreche',
        Person.secondSingular: 'sprichst',
        Person.thirdSingular: 'spricht',
        Person.firstPlural: 'sprechen',
        Person.secondPlural: 'sprecht',
        Person.thirdPlural: 'sprechen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'sprach',
        Person.secondSingular: 'sprachst',
        Person.thirdSingular: 'sprach',
        Person.firstPlural: 'sprachen',
        Person.secondPlural: 'spracht',
        Person.thirdPlural: 'sprachen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gesprochen',
        Person.secondSingular: 'hast gesprochen',
        Person.thirdSingular: 'hat gesprochen',
        Person.firstPlural: 'haben gesprochen',
        Person.secondPlural: 'habt gesprochen',
        Person.thirdPlural: 'haben gesprochen',
      },
    },
  ),

  // sehen - 看
  VerbConjugation(
    infinitive: 'sehen',
    partizip2: 'gesehen',
    praeteritum: 'sah',
    type: VerbType.irregular,
    meaning: '看、看见',
    example: 'Ich sehe dich.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'sehe',
        Person.secondSingular: 'siehst',
        Person.thirdSingular: 'sieht',
        Person.firstPlural: 'sehen',
        Person.secondPlural: 'seht',
        Person.thirdPlural: 'sehen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'sah',
        Person.secondSingular: 'sahst',
        Person.thirdSingular: 'sah',
        Person.firstPlural: 'sahen',
        Person.secondPlural: 'saht',
        Person.thirdPlural: 'sahen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'habe gesehen',
        Person.secondSingular: 'hast gesehen',
        Person.thirdSingular: 'hat gesehen',
        Person.firstPlural: 'haben gesehen',
        Person.secondPlural: 'habt gesehen',
        Person.thirdPlural: 'haben gesehen',
      },
    },
  ),

  // kommen - 来
  VerbConjugation(
    infinitive: 'kommen',
    partizip2: 'gekommen',
    praeteritum: 'kam',
    type: VerbType.irregular,
    meaning: '来',
    example: 'Ich komme aus China.',
    conjugations: {
      VerbTense.praesens: {
        Person.firstSingular: 'komme',
        Person.secondSingular: 'kommst',
        Person.thirdSingular: 'kommt',
        Person.firstPlural: 'kommen',
        Person.secondPlural: 'kommt',
        Person.thirdPlural: 'kommen',
      },
      VerbTense.praeteritum: {
        Person.firstSingular: 'kam',
        Person.secondSingular: 'kamst',
        Person.thirdSingular: 'kam',
        Person.firstPlural: 'kamen',
        Person.secondPlural: 'kamt',
        Person.thirdPlural: 'kamen',
      },
      VerbTense.perfekt: {
        Person.firstSingular: 'bin gekommen',
        Person.secondSingular: 'bist gekommen',
        Person.thirdSingular: 'ist gekommen',
        Person.firstPlural: 'sind gekommen',
        Person.secondPlural: 'seid gekommen',
        Person.thirdPlural: 'sind gekommen',
      },
    },
  ),

  // lernen - 学习 (规则)
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
];

/// 根据不定式查找动词
VerbConjugation? findVerb(String infinitive) {
  try {
    return commonVerbs.firstWhere(
      (verb) => verb.infinitive.toLowerCase() == infinitive.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}

/// 获取动词列表（按字母排序）
List<VerbConjugation> getVerbsSorted() {
  final verbs = List<VerbConjugation>.from(commonVerbs);
  verbs.sort((a, b) => a.infinitive.compareTo(b.infinitive));
  return verbs;
}

/// 按类型获取动词
List<VerbConjugation> getVerbsByType(VerbType type) {
  return commonVerbs.where((verb) => verb.type == type).toList();
}
