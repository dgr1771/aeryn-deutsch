/// 词族与构词法数据
library;

import '../models/word_family.dart';
import '../models/word.dart';

/// 常用前缀
final List<PrefixInfo> commonPrefixes = [
  // 可分前缀
  PrefixInfo(
    prefix: 'ab',
    meaning: '离开、除去',
    example: 'abfahren (出发)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'an',
    meaning: '靠近、开始',
    example: 'anfangen (开始)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'auf',
    meaning: '向上、打开',
    example: 'aufstehen (起床)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'aus',
    meaning: '向外、结束',
    example: 'ausgehen (外出)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'ein',
    meaning: '进入、里面',
    example: 'einkaufen (购物)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'mit',
    meaning: '一起、携带',
    example: 'mitkommen (一起来)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'nach',
    meaning: '朝向、之后',
    example: 'nachkommen (追随)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'vor',
    meaning: '向前、之前',
    example: 'vorlesen (朗读)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'weg',
    meaning: '离开、掉落',
    example: 'weggehen (离开)',
    separable: true,
  ),
  PrefixInfo(
    prefix: 'zurück',
    meaning: '返回',
    example: 'zurückkommen (回来)',
    separable: true,
  ),

  // 不可分前缀
  PrefixInfo(
    prefix: 'be',
    meaning: '使...、及物化',
    example: 'beantworten (回答)',
    separable: false,
  ),
  PrefixInfo(
    prefix: 'ver',
    meaning: '改变、完成',
    example: 'verstehen (理解)',
    separable: false,
  ),
  PrefixInfo(
    prefix: 'ent',
    meaning: '除去、离开',
    example: 'entfernen (移除)',
    separable: false,
  ),
  PrefixInfo(
    prefix: 'er',
    meaning: '开始、结果',
    example: 'erzählen (讲述)',
    separable: false,
  ),
  PrefixInfo(
    prefix: 'ge',
    meaning: '共同、状态',
    example: 'gehören (属于)',
    separable: false,
  ),
  PrefixInfo(
    prefix: 'miss',
    meaning: '错误、失败',
    example: 'misslingen (失败)',
    separable: false,
  ),
  PrefixInfo(
    prefix: 'zer',
    meaning: '分离、破坏',
    example: 'zerstören (破坏)',
    separable: false,
  ),
];

/// 常用后缀
final List<SuffixInfo> commonSuffixes = [
  // 名词后缀
  SuffixInfo(
    suffix: 'ung',
    meaning: '表示动作、过程或结果（阴性）',
    example: 'die Antwortung (答复)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'heit',
    meaning: '表示状态、性质（阴性）',
    example: 'die Freiheit (自由)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'keit',
    meaning: '表示性质、状态（阴性）',
    example: 'die Möglichkeit (可能性)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'schaft',
    meaning: '表示集体、状态（阴性）',
    example: 'die Freundschaft (友谊)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'tion',
    meaning: '表示动作（阴性，外来词）',
    example: 'die Information (信息)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'ung',
    meaning: '动作名词化',
    example: 'die Übung (练习)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'ling',
    meaning: '从事...的人（阳性）',
    example: 'der Lehrling (学徒)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'ner',
    meaning: '从事...的人（阳性）',
    example: 'der Schüler (学生)',
    partOfSpeech: '名词',
  ),
  SuffixInfo(
    suffix: 'e',
    meaning: '阴性名词标记',
    example: 'die Lehrerin (女教师)',
    partOfSpeech: '名词',
  ),

  // 形容词后缀
  SuffixInfo(
    suffix: 'lich',
    meaning: '具有...性质的',
    example: 'freundlich (友好的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'ig',
    meaning: '具有...特征的',
    example: 'riskant (有风险的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'isch',
    meaning: '...语言的、...风格的',
    example: 'deutsch (德国的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'los',
    meaning: '无...的、缺乏...的',
    example: 'arbeitslos (失业的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'haft',
    meaning: '具有...性质的',
    example: 'fleißig (勤奋的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'bar',
    meaning: '可被...的',
    example: 'lesbar (可读的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'sam',
    meaning: '充满...的',
    example: 'langsamer (缓慢的)',
    partOfSpeech: '形容词',
  ),
  SuffixInfo(
    suffix: 'voll',
    meaning: '充满...的',
    example: 'hoffnungsvoll (充满希望的)',
    partOfSpeech: '形容词',
  ),

  // 动词后缀
  SuffixInfo(
    suffix: 'ieren',
    meaning: '动词化（外来词）',
    example: 'studieren (学习)',
    partOfSpeech: '动词',
  ),
  SuffixInfo(
    suffix: 'eln',
    meaning: '反复动作',
    example: 'lächeln (微笑)',
    partOfSpeech: '动词',
  ),
  SuffixInfo(
    suffix: 'ern',
    meaning: '反复动作',
    example: 'ändern (改变)',
    partOfSpeech: '动词',
  ),
];

/// 示例词族
final List<WordFamily> exampleWordFamilies = [
  // sprechen 词族
  WordFamily(
    id: 'family_sprechen',
    root: 'sprech',
    meaning: '说',
    etymology: '古高地德语 sprengan',
    words: [
      Word(
        word: 'sprechen',
        article: null,
        gender: GermanGender.none,
        meaning: '说、讲',
        example: 'Ich spreche Deutsch.',
        frequency: 500,
        level: 'A1',
        category: 'Kommunikation',
      ),
      Word(
        word: 'besprechen',
        article: null,
        gender: GermanGender.none,
        meaning: '讨论、商量',
        example: 'Wir besprechen das Problem.',
        frequency: 300,
        level: 'A2',
        category: 'Kommunikation',
      ),
      Word(
        word: 'entsprechen',
        article: null,
        gender: GermanGender.none,
        meaning: '符合、相应',
        example: 'Das entspricht meiner Erwartung.',
        frequency: 250,
        level: 'B1',
        category: 'Kommunikation',
      ),
      Word(
        word: 'versprechen',
        article: null,
        gender: GermanGender.none,
        meaning: '承诺、许诺',
        example: 'Ich verspreche dir Hilfe.',
        frequency: 280,
        level: 'A2',
        category: 'Kommunikation',
      ),
      Word(
        word: 'das Gespräch',
        article: 'das',
        gender: GermanGender.neuter,
        meaning: '对话、谈话',
        example: 'Wir führen ein Gespräch.',
        frequency: 400,
        level: 'A1',
        category: 'Kommunikation',
      ),
      Word(
        word: 'die Aussprache',
        article: 'die',
        gender: GermanGender.feminine,
        meaning: '发音',
        example: 'Die Aussprache ist wichtig.',
        frequency: 320,
        level: 'B1',
        category: 'Kommunikation',
      ),
    ],
    rules: [
      WordFamilyRule(
        id: 'rule_be_ver',
        name: 'be-前缀规则',
        description: 'be- + 动词 = 及物动词，表示"对...进行某动作"',
        type: RuleType.prefix,
        examples: ['sprechen → besprechen (讨论)'],
        pattern: r'be\w+',
      ),
      WordFamilyRule(
        id: 'rule_ent',
        name: 'ent-前缀规则',
        description: 'ent- + 动词 = 表示除去或离开',
        type: RuleType.prefix,
        examples: ['sprechen → entspricht (符合)'],
      ),
      WordFamilyRule(
        id: 'rule_ung',
        name: '-ung名词后缀',
        description: '动词 + -ung = 表示动作或结果的名词',
        type: RuleType.suffix,
        examples: ['sprechen → die Aussprache (发音)'],
      ),
    ],
  ),

  // lernen 词族
  WordFamily(
    id: 'family_lern',
    root: 'lern',
    meaning: '学习',
    etymology: '古高地德语 lernēn',
    words: [
      Word(
        word: 'lernen',
        article: null,
        gender: GermanGender.none,
        meaning: '学习',
        example: 'Ich lerne Deutsch.',
        frequency: 600,
        level: 'A1',
        category: 'Bildung',
      ),
      Word(
        word: 'der Schüler',
        article: 'der',
        gender: GermanGender.masculine,
        meaning: '学生',
        example: 'Der Schüler lernt fleißig.',
        frequency: 450,
        level: 'A1',
        category: 'Bildung',
      ),
      Word(
        word: 'die Lernung',
        article: 'die',
        gender: GermanGender.feminine,
        meaning: '学习过程',
        example: 'Die Lernung braucht Zeit.',
        frequency: 200,
        level: 'B2',
        category: 'Bildung',
      ),
      Word(
        word: 'lernfähig',
        article: null,
        gender: GermanGender.none,
        meaning: '有学习能力的',
        example: 'Das Kind ist lernfähig.',
        frequency: 180,
        level: 'B2',
        category: 'Bildung',
      ),
    ],
    rules: [
      WordFamilyRule(
        id: 'rule_er_noun',
        name: '-er名词后缀',
        description: '动词 + -er = 表示从事动作的人（阳性）',
        type: RuleType.suffix,
        examples: ['lernen → der Lerner (学习者)'],
      ),
      WordFamilyRule(
        id: 'rule_bar_adj',
        name: '-bar形容词后缀',
        description: '动词 + -bar = 可被...的',
        type: RuleType.suffix,
        examples: ['lernen → lernbar (可学习的)'],
      ),
    ],
  ),

  // arbeiten 词族
  WordFamily(
    id: 'family_arbeit',
    root: 'arbeit',
    meaning: '工作',
    etymology: '古高地德语 arabeit',
    words: [
      Word(
        word: 'arbeiten',
        article: null,
        gender: GermanGender.none,
        meaning: '工作',
        example: 'Ich arbeite zu Hause.',
        frequency: 650,
        level: 'A1',
        category: 'Arbeit',
      ),
      Word(
        word: 'die Arbeit',
        article: 'die',
        gender: GermanGender.feminine,
        meaning: '工作、劳动',
        example: 'Die Arbeit ist wichtig.',
        frequency: 700,
        level: 'A1',
        category: 'Arbeit',
      ),
      Word(
        word: 'der Arbeiter',
        article: 'der',
        gender: GermanGender.masculine,
        meaning: '工人',
        example: 'Der Arbeiter arbeitet hart.',
        frequency: 400,
        level: 'A1',
        category: 'Arbeit',
      ),
      Word(
        word: 'die Arbeitszeit',
        article: 'die',
        gender: GermanGender.feminine,
        meaning: '工作时间',
        example: 'Die Arbeitszeit ist 8 Stunden.',
        frequency: 350,
        level: 'A2',
        category: 'Arbeit',
      ),
      Word(
        word: 'arbeitslos',
        article: null,
        gender: GermanGender.none,
        meaning: '失业的',
        example: 'Er ist arbeitslos.',
        frequency: 300,
        level: 'B1',
        category: 'Arbeit',
      ),
      Word(
        word: 'die Arbeitslosigkeit',
        article: 'die',
        gender: GermanGender.feminine,
        meaning: '失业',
        example: 'Die Arbeitslosigkeit ist hoch.',
        frequency: 280,
        level: 'B2',
        category: 'Arbeit',
      ),
    ],
    rules: [
      WordFamilyRule(
        id: 'rule_compound',
        name: '复合词规则',
        description: '名词 + 名词 = 复合名词',
        type: RuleType.compounding,
        examples: ['Arbeit + Zeit = die Arbeitszeit (工作时间)'],
      ),
      WordFamilyRule(
        id: 'rule_los_adj',
        name: '-los形容词后缀',
        description: '名词 + -los = 无...的、缺乏...的',
        type: RuleType.suffix,
        examples: ['Arbeit + los = arbeitslos (失业的)'],
      ),
      WordFamilyRule(
        id: 'rule_keit',
        name: '-keit名词后缀',
        description: '形容词 + -keit = 抽象名词（阴性）',
        type: RuleType.suffix,
        examples: ['arbeitslos + keit = die Arbeitslosigkeit (失业)'],
      ),
    ],
  ),
];

/// 根据词根查找词族
WordFamily? findWordFamily(String root) {
  try {
    return exampleWordFamilies.firstWhere(
      (family) => family.root == root || family.words.any((w) => w.word == root),
    );
  } catch (e) {
    return null;
  }
}

/// 获取所有词族
List<WordFamily> getAllWordFamilies() {
  return exampleWordFamilies;
}
