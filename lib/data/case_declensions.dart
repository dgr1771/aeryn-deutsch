/// 德语格变数据
library;

import '../models/case_declension.dart';
import '../core/grammar_engine.dart';

/// 定冠词变位表
final Map<GermanGender, Map<GermanCase, Map<Number, String>>> definiteArticles = {
  GermanGender.der: {
    GermanCase.nominativ: {Number.singular: 'der', Number.plural: 'die'},
    GermanCase.akkusativ: {Number.singular: 'den', Number.plural: 'die'},
    GermanCase.dativ: {Number.singular: 'dem', Number.plural: 'den'},
    GermanCase.genitiv: {Number.singular: 'des', Number.plural: 'der'},
  },
  GermanGender.die: {
    GermanCase.nominativ: {Number.singular: 'die', Number.plural: 'die'},
    GermanCase.akkusativ: {Number.singular: 'die', Number.plural: 'die'},
    GermanCase.dativ: {Number.singular: 'der', Number.plural: 'den'},
    GermanCase.genitiv: {Number.singular: 'der', Number.plural: 'der'},
  },
  GermanGender.das: {
    GermanCase.nominativ: {Number.singular: 'das', Number.plural: 'die'},
    GermanCase.akkusativ: {Number.singular: 'das', Number.plural: 'die'},
    GermanCase.dativ: {Number.singular: 'dem', Number.plural: 'den'},
    GermanCase.genitiv: {Number.singular: 'des', Number.plural: 'der'},
  },
};

/// 不定冠词变位表（仅单数）
final Map<GermanGender, Map<GermanCase, String>> indefiniteArticles = {
  GermanGender.der: {
    GermanCase.nominativ: 'ein',
    GermanCase.akkusativ: 'einen',
    GermanCase.dativ: 'einem',
    GermanCase.genitiv: 'eines',
  },
  GermanGender.die: {
    GermanCase.nominativ: 'eine',
    GermanCase.akkusativ: 'eine',
    GermanCase.dativ: 'einer',
    GermanCase.genitiv: 'einer',
  },
  GermanGender.das: {
    GermanCase.nominativ: 'ein',
    GermanCase.akkusativ: 'ein',
    GermanCase.dativ: 'einem',
    GermanCase.genitiv: 'eines',
  },
};

/// 否定冠词变位表
final Map<GermanGender, Map<GermanCase, Map<Number, String>>> negativeArticles = {
  GermanGender.der: {
    GermanCase.nominativ: {Number.singular: 'kein', Number.plural: 'keine'},
    GermanCase.akkusativ: {Number.singular: 'keinen', Number.plural: 'keine'},
    GermanCase.dativ: {Number.singular: 'keinem', Number.plural: 'keinen'},
    GermanCase.genitiv: {Number.singular: 'keines', Number.plural: 'keiner'},
  },
  GermanGender.die: {
    GermanCase.nominativ: {Number.singular: 'keine', Number.plural: 'keine'},
    GermanCase.akkusativ: {Number.singular: 'keine', Number.plural: 'keine'},
    GermanCase.dativ: {Number.singular: 'keiner', Number.plural: 'keinen'},
    GermanCase.genitiv: {Number.singular: 'keiner', Number.plural: 'keiner'},
  },
  GermanGender.das: {
    GermanCase.nominativ: {Number.singular: 'kein', Number.plural: 'keine'},
    GermanCase.akkusativ: {Number.singular: 'kein', Number.plural: 'keine'},
    GermanCase.dativ: {Number.singular: 'keinem', Number.plural: 'keinen'},
    GermanCase.genitiv: {Number.singular: 'keines', Number.plural: 'keiner'},
  },
};

/// 常用名词的格变示例
final List<NounPhraseDeclension> commonNounDeclensions = [
  // ========== 阳性名词 ==========

  // der Mann - 男人
  NounPhraseDeclension(
    noun: 'Mann',
    gender: GermanGender.der,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'der',
      GermanCase.akkusativ: 'den',
      GermanCase.dativ: 'dem',
      GermanCase.genitiv: 'des',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'ein',
      GermanCase.akkusativ: 'einen',
      GermanCase.dativ: 'einem',
      GermanCase.genitiv: 'eines',
    },
    negativeArticle: {
      GermanCase.nominativ: 'kein',
      GermanCase.akkusativ: 'keinen',
      GermanCase.dativ: 'keinem',
      GermanCase.genitiv: 'keines',
    },
    nounForm: {
      GermanCase.nominativ: 'Mann',
      GermanCase.akkusativ: 'Mann',
      GermanCase.dativ: 'Mann',
      GermanCase.genitiv: 'Mannes',
    },
  ),

  // der Tag - 天
  NounPhraseDeclension(
    noun: 'Tag',
    gender: GermanGender.der,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'der',
      GermanCase.akkusativ: 'den',
      GermanCase.dativ: 'dem',
      GermanCase.genitiv: 'des',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'ein',
      GermanCase.akkusativ: 'einen',
      GermanCase.dativ: 'einem',
      GermanCase.genitiv: 'eines',
    },
    negativeArticle: {
      GermanCase.nominativ: 'kein',
      GermanCase.akkusativ: 'keinen',
      GermanCase.dativ: 'keinem',
      GermanCase.genitiv: 'keines',
    },
    nounForm: {
      GermanCase.nominativ: 'Tag',
      GermanCase.akkusativ: 'Tag',
      GermanCase.dativ: 'Tag',
      GermanCase.genitiv: 'Tages',
    },
  ),

  // der Hund - 狗
  NounPhraseDeclension(
    noun: 'Hund',
    gender: GermanGender.der,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'der',
      GermanCase.akkusativ: 'den',
      GermanCase.dativ: 'dem',
      GermanCase.genitiv: 'des',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'ein',
      GermanCase.akkusativ: 'einen',
      GermanCase.dativ: 'einem',
      GermanCase.genitiv: 'eines',
    },
    negativeArticle: {
      GermanCase.nominativ: 'kein',
      GermanCase.akkusativ: 'keinen',
      GermanCase.dativ: 'keinem',
      GermanCase.genitiv: 'keines',
    },
    nounForm: {
      GermanCase.nominativ: 'Hund',
      GermanCase.akkusativ: 'Hund',
      GermanCase.dativ: 'Hund',
      GermanCase.genitiv: 'Hundes',
    },
  ),

  // ========== 阴性名词 ==========

  // die Frau - 女人/妻子
  NounPhraseDeclension(
    noun: 'Frau',
    gender: GermanGender.die,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'die',
      GermanCase.akkusativ: 'die',
      GermanCase.dativ: 'der',
      GermanCase.genitiv: 'der',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'eine',
      GermanCase.akkusativ: 'eine',
      GermanCase.dativ: 'einer',
      GermanCase.genitiv: 'einer',
    },
    negativeArticle: {
      GermanCase.nominativ: 'keine',
      GermanCase.akkusativ: 'keine',
      GermanCase.dativ: 'keiner',
      GermanCase.genitiv: 'keiner',
    },
    nounForm: {
      GermanCase.nominativ: 'Frau',
      GermanCase.akkusativ: 'Frau',
      GermanCase.dativ: 'Frau',
      GermanCase.genitiv: 'Frau',
    },
  ),

  // die Zeit - 时间
  NounPhraseDeclension(
    noun: 'Zeit',
    gender: GermanGender.die,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'die',
      GermanCase.akkusativ: 'die',
      GermanCase.dativ: 'der',
      GermanCase.genitiv: 'der',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'eine',
      GermanCase.akkusativ: 'eine',
      GermanCase.dativ: 'einer',
      GermanCase.genitiv: 'einer',
    },
    negativeArticle: {
      GermanCase.nominativ: 'keine',
      GermanCase.akkusativ: 'keine',
      GermanCase.dativ: 'keiner',
      GermanCase.genitiv: 'keiner',
    },
    nounForm: {
      GermanCase.nominativ: 'Zeit',
      GermanCase.akkusativ: 'Zeit',
      GermanCase.dativ: 'Zeit',
      GermanCase.genitiv: 'Zeit',
    },
  ),

  // die Hand - 手
  NounPhraseDeclension(
    noun: 'Hand',
    gender: GermanGender.die,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'die',
      GermanCase.akkusativ: 'die',
      GermanCase.dativ: 'der',
      GermanCase.genitiv: 'der',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'eine',
      GermanCase.akkusativ: 'eine',
      GermanCase.dativ: 'einer',
      GermanCase.genitiv: 'einer',
    },
    negativeArticle: {
      GermanCase.nominativ: 'keine',
      GermanCase.akkusativ: 'keine',
      GermanCase.dativ: 'keiner',
      GermanCase.genitiv: 'keiner',
    },
    nounForm: {
      GermanCase.nominativ: 'Hand',
      GermanCase.akkusativ: 'Hand',
      GermanCase.dativ: 'Hand',
      GermanCase.genitiv: 'Hand',
    },
  ),

  // ========== 中性名词 ==========

  // das Kind - 孩子
  NounPhraseDeclension(
    noun: 'Kind',
    gender: GermanGender.das,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'das',
      GermanCase.akkusativ: 'das',
      GermanCase.dativ: 'dem',
      GermanCase.genitiv: 'des',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'ein',
      GermanCase.akkusativ: 'ein',
      GermanCase.dativ: 'einem',
      GermanCase.genitiv: 'eines',
    },
    negativeArticle: {
      GermanCase.nominativ: 'kein',
      GermanCase.akkusativ: 'kein',
      GermanCase.dativ: 'keinem',
      GermanCase.genitiv: 'keines',
    },
    nounForm: {
      GermanCase.nominativ: 'Kind',
      GermanCase.akkusativ: 'Kind',
      GermanCase.dativ: 'Kind',
      GermanCase.genitiv: 'Kindes',
    },
  ),

  // das Buch - 书
  NounPhraseDeclension(
    noun: 'Buch',
    gender: GermanGender.das,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'das',
      GermanCase.akkusativ: 'das',
      GermanCase.dativ: 'dem',
      GermanCase.genitiv: 'des',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'ein',
      GermanCase.akkusativ: 'ein',
      GermanCase.dativ: 'einem',
      GermanCase.genitiv: 'eines',
    },
    negativeArticle: {
      GermanCase.nominativ: 'kein',
      GermanCase.akkusativ: 'kein',
      GermanCase.dativ: 'keinem',
      GermanCase.genitiv: 'keines',
    },
    nounForm: {
      GermanCase.nominativ: 'Buch',
      GermanCase.akkusativ: 'Buch',
      GermanCase.dativ: 'Buch',
      GermanCase.genitiv: 'Buches',
    },
  ),

  // das Haus - 房子
  NounPhraseDeclension(
    noun: 'Haus',
    gender: GermanGender.das,
    number: Number.singular,
    definiteArticle: {
      GermanCase.nominativ: 'das',
      GermanCase.akkusativ: 'das',
      GermanCase.dativ: 'dem',
      GermanCase.genitiv: 'des',
    },
    indefiniteArticle: {
      GermanCase.nominativ: 'ein',
      GermanCase.akkusativ: 'ein',
      GermanCase.dativ: 'einem',
      GermanCase.genitiv: 'eines',
    },
    negativeArticle: {
      GermanCase.nominativ: 'kein',
      GermanCase.akkusativ: 'kein',
      GermanCase.dativ: 'keinem',
      GermanCase.genitiv: 'keines',
    },
    nounForm: {
      GermanCase.nominativ: 'Haus',
      GermanCase.akkusativ: 'Haus',
      GermanCase.dativ: 'Haus',
      GermanCase.genitiv: 'Hauses',
    },
  ),

  // ========== 复数示例 ==========

  // die Kinder - 孩子们 (复数)
  NounPhraseDeclension(
    noun: 'Kinder',
    gender: GermanGender.das,
    number: Number.plural,
    definiteArticle: {
      GermanCase.nominativ: 'die',
      GermanCase.akkusativ: 'die',
      GermanCase.dativ: 'den',
      GermanCase.genitiv: 'der',
    },
    negativeArticle: {
      GermanCase.nominativ: 'keine',
      GermanCase.akkusativ: 'keine',
      GermanCase.dativ: 'keinen',
      GermanCase.genitiv: 'keiner',
    },
    nounForm: {
      GermanCase.nominativ: 'Kinder',
      GermanCase.akkusativ: 'Kinder',
      GermanCase.dativ: 'Kindern',
      GermanCase.genitiv: 'Kinder',
    },
  ),

  // die Bücher - 书 (复数)
  NounPhraseDeclension(
    noun: 'Bücher',
    gender: GermanGender.das,
    number: Number.plural,
    definiteArticle: {
      GermanCase.nominativ: 'die',
      GermanCase.akkusativ: 'die',
      GermanCase.dativ: 'den',
      GermanCase.genitiv: 'der',
    },
    negativeArticle: {
      GermanCase.nominativ: 'keine',
      GermanCase.akkusativ: 'keine',
      GermanCase.dativ: 'keinen',
      GermanCase.genitiv: 'keiner',
    },
    nounForm: {
      GermanCase.nominativ: 'Bücher',
      GermanCase.akkusativ: 'Bücher',
      GermanCase.dativ: 'Büchern',
      GermanCase.genitiv: 'Bücher',
    },
  ),
];

/// 根据名词查找格变
NounPhraseDeclension? findNounDeclension(String noun) {
  try {
    return commonNounDeclensions.firstWhere(
      (n) => n.noun.toLowerCase() == noun.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}

/// 获取名词列表（按字母排序）
List<NounPhraseDeclension> getNounsSorted() {
  final nouns = List<NounPhraseDeclension>.from(commonNounDeclensions);
  nouns.sort((a, b) => a.noun.compareTo(b.noun));
  return nouns;
}

/// 按性别获取名词
List<NounPhraseDeclension> getNounsByGender(GermanGender gender) {
  return commonNounDeclensions.where((n) => n.gender == gender).toList();
}

/// 按数获取名词
List<NounPhraseDeclension> getNounsByNumber(Number number) {
  return commonNounDeclensions.where((n) => n.number == number).toList();
}
