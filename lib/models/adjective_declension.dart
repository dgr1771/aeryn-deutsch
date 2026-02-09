/// 形容词变格模型
library;

import '../core/grammar_engine.dart';

/// 形容词变化类型
enum AdjectiveDeclensionType {
  weak,      // 弱变化 (定冠词后)
  strong,     // 强变化 (无冠词/零冠词后)
  mixed,      // 混合变化 (不定冠词/否定冠词/物主冠词后)
}

/// 形容词变位
class AdjectiveDeclension {
  final String adjective;       // 形容词原形
  final String? meaning;        // 释义
  final List<AdjectiveEnding> endings; // 各格各数各性的词尾

  const AdjectiveDeclension({
    required this.adjective,
    this.meaning,
    required this.endings,
  });

  /// 获取特定条件下的词尾
  AdjectiveEnding? getEnding({
    required GermanCase case_,
    required Number number,
    required GermanGender gender,
    required AdjectiveDeclensionType type,
    required bool hasArticle,
  }) {
    return endings.firstWhere(
      (e) =>
          e.case_ == case_ &&
          e.number == number &&
          e.gender == gender &&
          e.type == type &&
          e.hasArticle == hasArticle,
      orElse: () => AdjectiveEnding(
        case_: case_,
        number: number,
        gender: gender,
        type: type,
        hasArticle: hasArticle,
        ending: '',
      ),
    );
  }

  /// 获取弱变化词尾 (定冠词后)
  List<AdjectiveEnding> get weakEndings =>
      endings.where((e) => e.type == AdjectiveDeclensionType.weak).toList();

  /// 获取强变化词尾 (无冠词后)
  List<AdjectiveEnding> get strongEndings =>
      endings.where((e) => e.type == AdjectiveDeclensionType.strong).toList();

  /// 获取混合变化词尾
  List<AdjectiveEnding> get mixedEndings =>
      endings.where((e) => e.type == AdjectiveDeclensionType.mixed).toList();

  Map<String, dynamic> toJson() {
    return {
      'adjective': adjective,
      'meaning': meaning,
      'endings': endings.map((e) => e.toJson()).toList(),
    };
  }
}

/// 形容词词尾
class AdjectiveEnding {
  final GermanCase case_;
  final Number number;
  final GermanGender gender;
  final AdjectiveDeclensionType type;
  final bool hasArticle;     // 是否有冠词
  final String ending;       // 词尾 (如 -e, -en, -er, -es)

  const AdjectiveEnding({
    required this.case_,
    required this.number,
    required this.gender,
    required this.type,
    required this.hasArticle,
    required this.ending,
  });

  /// 获取完整形式 (形容词 + 词尾)
  String getFullForm(String adjective) {
    // 移除形容词可能已有的词尾
    final base = _removeEnding(adjective);
    return base + ending;
  }

  String _removeEnding(String word) {
    // 简化处理，实际可能需要更复杂的规则
    if (word.endsWith('e') || word.endsWith('er') || word.endsWith('es')) {
      return word.substring(0, word.length - 1);
    }
    return word;
  }

  Map<String, dynamic> toJson() {
    return {
      'case': case_.name,
      'number': number.name,
      'gender': gender.name,
      'type': type.name,
      'hasArticle': hasArticle,
      'ending': ending,
    };
  }
}

/// 形容词词尾规则
class AdjectiveEndingRule {
  final String name;
  final String description;
  final List<String> examples;
  final String pattern;

  const AdjectiveEndingRule({
    required this.name,
    required this.description,
    required this.examples,
    required this.pattern,
  });
}

/// 形容词变格规则集合
final List<AdjectiveEndingRule> adjectiveDeclensionRules = [
  AdjectiveEndingRule(
    name: '弱变化 (Schwache Deklination)',
    description: '在定冠词 (der/die/das) 或指示代词 (diese/diese/dieses) 后，形容词词尾为 -e 或 -en',
    examples: [
      'der gut_e Mann (好男人)',
      'die gut_en Frau (好女人)',
      'das gut_e Kind (好孩子)',
    ],
    pattern: '定冠词 + 形容词 + (-e/-en)',
  ),
  AdjectiveEndingRule(
    name: '强变化 (Starke Deklination)',
    description: '在无冠词或零冠词后，形容词词尾类似定冠词的变化',
    examples: [
      'gut_er Wein (好葡萄酒)',
      'gut_e Frau (好女人)',
      'gut_es Kind (好孩子)',
    ],
    pattern: '无冠词 + 形容词 + 强变化词尾',
  ),
  AdjectiveEndingRule(
    name: '混合变化 (Gemischte Deklination)',
    description: '在不定冠词、否定冠词 (kein) 或物主冠词 (mein/dein) 后，混合使用强、弱变化',
    examples: [
      'ein gut_er Mann (一个好男人)',
      'mein gut_es Buch (我的好书)',
      'kein gut_e Kind (没有好孩子)',
    ],
    pattern: '不定冠词 + 形容词 + 混合词尾',
  ),
];

/// 弱变化词尾表 (定冠词后)
final Map<GermanCase, Map<Number, Map<GermanGender, String>>> weakEndings = {
  GermanCase.nominativ: {
    Number.singular: {
      GermanGender.der: 'e',
      GermanGender.die: 'e',
      GermanGender.das: 'e',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.akkusativ: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'e',
      GermanGender.das: 'e',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.dativ: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.genitiv: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
};

/// 强变化词尾表 (无冠词后)
final Map<GermanCase, Map<Number, Map<GermanGender, String>>> strongEndings = {
  GermanCase.nominativ: {
    Number.singular: {
      GermanGender.der: 'er',
      GermanGender.die: 'e',
      GermanGender.das: 'es',
    },
    Number.plural: {
      GermanGender.der: 'e',
      GermanGender.die: 'e',
      GermanGender.das: 'e',
    },
  },
  GermanCase.akkusativ: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'e',
      GermanGender.das: 'es',
    },
    Number.plural: {
      GermanGender.der: 'e',
      GermanGender.die: 'e',
      GermanGender.das: 'e',
    },
  },
  GermanCase.dativ: {
    Number.singular: {
      GermanGender.der: 'em',
      GermanGender.die: 'er',
      GermanGender.das: 'em',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.genitiv: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'er',
      GermanGender.das: 'en',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
};

/// 混合变化词尾表 (不定冠词/否定冠词/物主冠词后)
final Map<GermanCase, Map<Number, Map<GermanGender, String>>> mixedEndings = {
  GermanCase.nominativ: {
    Number.singular: {
      GermanGender.der: 'er',
      GermanGender.die: 'e',
      GermanGender.das: 'es',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.akkusativ: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'e',
      GermanGender.das: 'es',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.dativ: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
  GermanCase.genitiv: {
    Number.singular: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
    Number.plural: {
      GermanGender.der: 'en',
      GermanGender.die: 'en',
      GermanGender.das: 'en',
    },
  },
};

/// 常用形容词示例
final List<String> commonAdjectives = [
  'gut',         // 好
  'schön',       // 美、漂亮
  'groß',        // 大
  'klein',       // 小
  'alt',         // 老
  'jung',        // 年轻
  'neu',         // 新
  'warm',        // 暖、热
  'kalt',        // 冷
  'teuer',       // 贵
  'billig',      // 便宜
  'interessant', // 有趣
  'wichtig',     // 重要
  'leicht',      // 容易、轻
  'schwer',      // 难、重
  'froh',        // 高兴
  'traurig',     // 悲伤
  'müde',        // 累
  'krank',       // 病
  'gesund',      // 健康
];

/// 变化类型标签
const Map<AdjectiveDeclensionType, String> declensionTypeLabels = {
  AdjectiveDeclensionType.weak: '弱变化 (定冠词后)',
  AdjectiveDeclensionType.strong: '强变化 (无冠词后)',
  AdjectiveDeclensionType.mixed: '混合变化 (不定冠词后)',
};
