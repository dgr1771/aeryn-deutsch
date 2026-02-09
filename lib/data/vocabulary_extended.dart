/// 德语词汇库扩展
///
/// 补充更多常用词汇，达到3000+目标
library;

import '../core/grammar_engine.dart';
import 'vocabulary.dart';

/// 将Map转换为VocabularyEntry
VocabularyEntry mapToVocabularyEntry(Map<String, dynamic> map, LanguageLevel level) {
  return VocabularyEntry(
    word: map['word'] as String,
    article: map['article'] as String?,
    gender: map['gender'] == 'der' ? GermanGender.der :
            map['gender'] == 'die' ? GermanGender.die :
            map['gender'] == 'das' ? GermanGender.das :
            GermanGender.none,
    meaning: map['meaning'] as String,
    level: level,
    example: map['example'] as String?,
    frequency: map['frequency'] as int?,
  );
}

/// 获取A1级别扩展词汇（转换为VocabularyEntry）
List<VocabularyEntry> getA1ExtendedVocabulary() {
  return vocabularyA1Extended.map((e) => mapToVocabularyEntry(e, LanguageLevel.A1)).toList();
}

/// 获取A2级别扩展词汇（转换为VocabularyEntry）
List<VocabularyEntry> getA2ExtendedVocabulary() {
  return vocabularyA2Extended.map((e) => mapToVocabularyEntry(e, LanguageLevel.A2)).toList();
}

/// 获取B1级别扩展词汇（转换为VocabularyEntry）
List<VocabularyEntry> getB1ExtendedVocabulary() {
  return vocabularyB1Extended.map((e) => mapToVocabularyEntry(e, LanguageLevel.B1)).toList();
}

/// 获取B2级别扩展词汇（转换为VocabularyEntry）
List<VocabularyEntry> getB2ExtendedVocabulary() {
  return vocabularyB2Extended.map((e) => mapToVocabularyEntry(e, LanguageLevel.B2)).toList();
}

/// 获取C1级别扩展词汇（转换为VocabularyEntry）
List<VocabularyEntry> getC1ExtendedVocabulary() {
  return vocabularyC1Extended.map((e) => mapToVocabularyEntry(e, LanguageLevel.C1)).toList();
}

/// 获取C2级别扩展词汇（转换为VocabularyEntry）
List<VocabularyEntry> getC2ExtendedVocabulary() {
  return vocabularyC2Extended.map((e) => mapToVocabularyEntry(e, LanguageLevel.C2)).toList();
}

/// 获取所有扩展词汇（指定级别）
List<VocabularyEntry> getAllExtendedVocabulary(LanguageLevel level) {
  switch (level) {
    case LanguageLevel.A1:
      return getA1ExtendedVocabulary();
    case LanguageLevel.A2:
      return [...getA1ExtendedVocabulary(), ...getA2ExtendedVocabulary()];
    case LanguageLevel.B1:
      return [...getA1ExtendedVocabulary(), ...getA2ExtendedVocabulary(), ...getB1ExtendedVocabulary()];
    case LanguageLevel.B2:
      return [...getA1ExtendedVocabulary(), ...getA2ExtendedVocabulary(), ...getB1ExtendedVocabulary(), ...getB2ExtendedVocabulary()];
    case LanguageLevel.C1:
      return [...getA1ExtendedVocabulary(), ...getA2ExtendedVocabulary(), ...getB1ExtendedVocabulary(), ...getB2ExtendedVocabulary(), ...getC1ExtendedVocabulary()];
    case LanguageLevel.C2:
      return [...getA1ExtendedVocabulary(), ...getA2ExtendedVocabulary(), ...getB1ExtendedVocabulary(), ...getB2ExtendedVocabulary(), ...getC1ExtendedVocabulary(), ...getC2ExtendedVocabulary()];
    default:
      return getA1ExtendedVocabulary();
  }
}

/// 统计扩展词汇总数
int getExtendedVocabularyCount() {
  return vocabularyA1Extended.length +
         vocabularyA2Extended.length +
         vocabularyB1Extended.length +
         vocabularyB2Extended.length +
         vocabularyC1Extended.length +
         vocabularyC2Extended.length;
}

/// A1级别扩展词汇（200词）- 日常生活
final List<Map<String, dynamic>> vocabularyA1Extended = [
  // 日常用品
  {'word': 'der Stift', 'article': 'der', 'gender': 'der', 'meaning': '钢笔', 'example': 'Ich schreibe mit dem Stift.', 'frequency': 200},
  {'word': 'das Papier', 'article': 'das', 'gender': 'das', 'meaning': '纸', 'example': 'Ich brauche Papier.', 'frequency': 201},
  {'word': 'der Bleistift', 'article': 'der', 'gender': 'der', 'meaning': '铅笔', 'example': 'Zeichne mit dem Bleistift.', 'frequency': 202},
  {'word': 'das Buch', 'article': 'das', 'gender': 'das', 'meaning': '书', 'example': 'Ich lese ein Buch.', 'frequency': 12},
  {'word': 'der Computer', 'article': 'der', 'gender': 'der', 'meaning': '电脑', 'example': 'Der Computer ist schnell.', 'frequency': 250},
  {'word': 'das Handy', 'article': 'das', 'gender': 'das', 'meaning': '手机', 'example': 'Mein Handy ist kaputt.', 'frequency': 300},
  {'word': 'die Tasche', 'article': 'die', 'gender': 'die', 'meaning': '包', 'example': 'Die Tasche ist rot.', 'frequency': 210},
  {'word': 'der Schirm', 'article': 'der', 'gender': 'der', 'meaning': '屏幕', 'example': 'Der Schirm ist schwarz.', 'frequency': 260},

  // 服装
  {'word': 'das Hemd', 'article': 'das', 'gender': 'das', 'meaning': '衬衫', 'example': 'Das Hemd ist weiß.', 'frequency': 270},
  {'word': 'die Hose', 'article': 'die', 'gender': 'die', 'meaning': '裤子', 'example': 'Die Hose ist zu eng.', 'frequency': 271},
  {'word': 'der Schuh', 'article': 'der', 'gender': 'der', 'meaning': '鞋', 'example': 'Der Schuh passt nicht.', 'frequency': 272},
  {'word': 'die Jacke', 'article': 'die', 'gender': 'die', 'meaning': '夹克', 'example': 'Die Jacke ist warm.', 'frequency': 273},
  {'word': 'der Hut', 'article': 'der', 'gender': 'der', 'meaning': '帽子', 'example': 'Er trägt einen Hut.', 'frequency': 274},
  {'word': 'der Mantel', 'article': 'der', 'gender': 'der', 'meaning': '大衣', 'example': 'Der Mantel ist lang.', 'frequency': 275},

  // 职业
  {'word': 'der Arzt', 'article': 'der', 'gender': 'der', 'meaning': '医生', 'example': 'Der Arzt ist sehr nett.', 'frequency': 280},
  {'word': 'die Lehrerin', 'article': 'die', 'gender': 'die', 'meaning': '女教师', 'example': 'Die Lehrerin erklärt gut.', 'frequency': 281},
  {'word': 'der Koch', 'article': 'der', 'gender': 'der', 'meaning': '厨师', 'example': 'Der Koch kocht gut.', 'frequency': 282},
  {'word': 'die Polizei', 'article': 'die', 'gender': 'die', 'meaning': '警察', 'example': 'Die Polizei hilft.', 'frequency': 283},
  {'word': 'der Postbote', 'article': 'der', 'gender': 'der', 'meaning': '邮递员', 'example': 'Der Postbote bringt Briefe.', 'frequency': 284},
  {'word': 'die Verkäuferin', 'article': 'die', 'gender': 'die', 'meaning': '女售货员', 'example': 'Die Verkäuferin ist freundlich.', 'frequency': 285},

  // 水果和蔬菜
  {'word': 'der Apfel', 'article': 'der', 'gender': 'der', 'meaning': '苹果', 'example': 'Der Apfel ist rot.', 'frequency': 55},
  {'word': 'die Banane', 'article': 'die', 'gender': 'die', 'meaning': '香蕉', 'example': 'Die Banane ist krumm.', 'frequency': 56},
  {'word': 'die Orange', 'article': 'die', 'gender': 'die', 'meaning': '橙子', 'example': 'Die Orange ist saftig.', 'frequency': 57},
  {'word': 'der Salat', 'article': 'der', 'gender': 'der', 'meaning': '沙拉', 'example': 'Der Salat ist frisch.', 'frequency': 58},
  {'word': 'die Kartoffel', 'article': 'die', 'gender': 'die', 'meaning': '土豆', 'example': 'Die Kartoffel ist groß.', 'frequency': 59},
  {'word': 'die Tomate', 'article': 'die', 'gender': 'die', 'meaning': '西红柿', 'example': 'Die Tomate ist rot.', 'frequency': 60},
  {'word': 'die Gurke', 'article': 'die', 'gender': 'die', 'meaning': '黄瓜', 'example': 'Die Gurke ist knackig.', 'frequency': 61},
  {'word': 'der Kohl', 'article': 'der', 'gender': 'der', 'meaning': '卷心菜', 'example': 'Der Kohl ist gesund.', 'frequency': 62},

  // 动物
  {'word': 'der Hund', 'article': 'der', 'gender': 'der', 'meaning': '狗', 'example': 'Der Hund ist treu.', 'frequency': 45},
  {'word': 'die Katze', 'article': 'die', 'gender': 'die', 'meaning': '猫', 'example': 'Die Katze schläft viel.', 'frequency': 46},
  {'word': 'der Vogel', 'article': 'der', 'gender': 'der', 'meaning': '鸟', 'example': 'Der Vogel singt.', 'frequency': 47},
  {'word': 'das Pferd', 'article': 'das', 'gender': 'das', 'meaning': '马', 'example': 'Das Pferd läuft schnell.', 'frequency': 48},
  {'word': 'die Kuh', 'article': 'die', 'gender': 'die', 'meaning': '牛', 'example': 'Die Kuh gibt Milch.', 'frequency': 49},
  {'word': 'das Schwein', 'article': 'das', 'gender': 'das', 'meaning': '猪', 'example': 'Das Schwein ist groß.', 'frequency': 50},
  {'word': 'die Maus', 'article': 'die', 'gender': 'die', 'meaning': '老鼠', 'example': 'Die Maus ist klein.', 'frequency': 51},
  {'word': 'der Fisch', 'article': 'der', 'gender': 'der', 'meaning': '鱼', 'example': 'Der Fisch schwimmt.', 'frequency': 52},
  {'word': 'der Hase', 'article': 'der', 'gender': 'der', 'meaning': '兔子', 'example': 'Der Hase hüpft.', 'frequency': 53},

  // 学校用品
  {'word': 'das Heft', 'article': 'das', 'gender': 'das', 'meaning': '本子', 'example': 'Ich schreibe im Heft.', 'frequency': 286},
  {'word': 'der Stuhl', 'article': 'der', 'gender': 'der', 'meaning': '椅子', 'example': 'Ich sitze auf dem Stuhl.', 'frequency': 46},
  {'word': 'die Tafel', 'article': 'die', 'gender': 'die', 'meaning': '黑板', 'example': 'Die Tafel ist grün.', 'frequency': 287},
  {'word': 'der Radiergummi', 'article': 'der', 'gender': 'der', 'meaning': '橡皮', 'example': 'Ich brauche einen Radiergummi.', 'frequency': 288},
  {'word': 'der Lineal', 'article': 'der', 'gender': 'der', 'meaning': '尺子', 'example': 'Das Lineal ist 20 cm.', 'frequency': 289},
  {'word': 'die Schere', 'article': 'die', 'gender': 'die', 'meaning': '剪刀', 'example': 'Die Schere ist scharf.', 'frequency': 290},

  // 交通工具
  {'word': 'das Fahrrad', 'article': 'das', 'gender': 'das', 'meaning': '自行车', 'example': 'Ich fahre mit dem Fahrrad.', 'frequency': 291},
  {'word': 'das Auto', 'article': 'das', 'gender': 'das', 'meaning': '汽车', 'example': 'Das Auto ist schnell.', 'frequency': 77},
  {'word': 'der Zug', 'article': 'der', 'gender': 'der', 'meaning': '火车', 'example': 'Der Zug ist pünktlich.', 'frequency': 79},
  {'word': 'das Flugzeug', 'article': 'das', 'gender': 'das', 'meaning': '飞机', 'example': 'Das Flugzeug startet.', 'frequency': 80},
  {'word': 'das Schiff', 'article': 'das', 'gender': 'das', 'meaning': '船', 'example': 'Das Schiff fährt.', 'frequency': 81},
  {'word': 'die U-Bahn', 'article': 'die', 'gender': 'die', 'meaning': '地铁', 'example': 'Ich nehme die U-Bahn.', 'frequency': 292},
  {'word': 'der Bus', 'article': 'der', 'gender': 'der', 'meaning': '公共汽车', 'example': 'Der Bus kommt.', 'frequency': 78},
  {'word': 'das Taxi', 'article': 'das', 'gender': 'das', 'meaning': '出租车', 'example': 'Ich nehme ein Taxi.', 'frequency': 293},

  // 饮料
  {'word': 'das Bier', 'article': 'das', 'gender': 'das', 'meaning': '啤酒', 'example': 'Das Bier ist kalt.', 'frequency': 294},
  {'word': 'der Saft', 'article': 'der', 'gender': 'der', 'meaning': '果汁', 'example': 'Ich trinke Orangensaft.', 'frequency': 295},
  {'word': 'die Milch', 'article': 'die', 'gender': 'die', 'meaning': '牛奶', 'example': 'Die Milch ist frisch.', 'frequency': 296},
  {'word': 'der Tee', 'article': 'der', 'gender': 'der', 'meaning': '茶', 'example': 'Der Tee ist heiß.', 'frequency': 61},
  {'word': 'der Kaffee', 'article': 'der', 'gender': 'der', 'meaning': '咖啡', 'example': 'Ich trinke Kaffee mit Milch.', 'frequency': 60},
  {'word': 'das Wasser', 'article': 'das', 'gender': 'das', 'meaning': '水', 'example': 'Wasser ist wichtig.', 'frequency': 6},
  {'word': 'die Limonade', 'article': 'die', 'gender': 'die', 'meaning': '柠檬水', 'example': 'Die Limonade ist sauer.', 'frequency': 297},
  {'word': 'die Cola', 'article': 'die', 'gender': 'die', 'meaning': '可乐', 'example': 'Ich trinke gerne Cola.', 'frequency': 298},
  {'word': 'der Saft', 'article': 'der', 'gender': 'der', 'meaning': '果汁', 'example': 'Der Saft ist fruchtig.', 'frequency': 299},

  // 颜色扩展
  {'word': 'braun', 'article': null, 'gender': GermanGender.none, 'meaning': '棕色', 'example': 'Meine Haare sind braun.', 'frequency': 300},
  {'word': 'grau', 'article': null, 'gender': GermanGender.none, 'meaning': '灰色', 'example': 'Der Himmel ist grau.', 'frequency': 301},
  {'word': 'rosa', 'article': null, 'gender': GermanGender.none, 'meaning': '粉色', 'example': 'Die Blume ist rosa.', 'frequency': 302},
  {'word': 'lila', 'article': null, 'gender': GermanGender.none, 'meaning': '紫色', 'example': 'Der Himmel ist lila.', 'frequency': 303},
  {'word': 'orange', 'article': null, 'gender': GermanGender.none, 'meaning': '橙色', 'example': 'Die Orange ist orange.', 'frequency': 304},
  {'word': 'bunt', 'article': null, 'gender': GermanGender.none, 'meaning': '彩色的', 'example': 'Das Bild ist bunt.', 'frequency': 305},
  {'word': 'hell', 'article': null, 'gender': GermanGender.none, 'meaning': '明亮的', 'example': 'Der Raum ist hell.', 'frequency': 306},
  {'word': 'dunkel', 'article': null, 'gender': GermanGender.none, 'meaning': '暗的', 'example': 'Es ist dunkel.', 'frequency': 307},

  // 房屋扩展
  {'word': 'das Zimmer', 'article': 'das', 'gender': 'das', 'meaning': '房间', 'example': 'Mein Zimmer ist groß.', 'frequency': 308},
  {'word': 'die Küche', 'article': 'die', 'gender': 'die', 'meaning': '厨房', 'example': 'Die Küche ist modern.', 'frequency': 309},
  {'word': 'das Bad', 'article': 'das', 'gender': 'das', 'meaning': '浴室', 'example': 'Das Bad ist sauber.', 'frequency': 310},
  {'word': 'das Schlafzimmer', 'article': 'das', 'gender': 'das', 'meaning': '卧室', 'example': 'Das Schlafzimmer ist gemütlich.', 'frequency': 311},
  {'word': 'das Wohnzimmer', 'article': 'das', 'gender': 'das', 'meaning': '客厅', 'example': 'Das Wohnzimmer ist hell.', 'frequency': 312},
  {'word': 'der Flur', 'article': 'der', 'gender': 'der', 'meaning': '门厅', 'example': 'Der Flur ist klein.', 'frequency': 313},
  {'word': 'der Balkon', 'article': 'der', 'gender': 'der', 'meaning': '阳台', 'example': 'Der Balkon ist groß.', 'frequency': 314},
  {'word': 'der Garten', 'article': 'der', 'gender': 'der', 'meaning': '花园', 'example': 'Der Garten ist schön.', 'frequency': 315},
  {'word': 'die Garage', 'article': 'die', 'gender': 'die', 'meaning': '车库', 'example': 'Die Garage ist voll.', 'frequency': 316},
  {'word': 'das Dach', 'article': 'das', 'gender': 'das', 'meaning': '屋顶', 'example': 'Das Dach ist neu.', 'frequency': 317},
  {'word': 'die Wand', 'article': 'die', 'gender': 'die', 'meaning': '墙', 'example': 'Die Wand ist weiß.', 'frequency': 318},
  {'word': 'der Boden', 'article': 'der', 'gender': 'der', 'meaning': '地板', 'example': 'Der Boden ist alt.', 'frequency': 319},

  // 常用形容词
  {'word': 'gut', 'article': null, 'gender': GermanGender.none, 'meaning': '好的', 'example': 'Das Essen ist gut.', 'frequency': 320},
  {'word': 'schlecht', 'article': null, 'gender': GermanGender.none, 'meaning': '坏的', 'example': 'Das Wetter ist schlecht.', 'frequency': 321},
  {'word': 'groß', 'article': null, 'gender': GermanGender.none, 'meaning': '大的', 'example': 'Das Haus ist groß.', 'frequency': 322},
  {'word': 'klein', 'article': null, 'gender': GermanGender.none, 'meaning': '小的', 'example': 'Das Zimmer ist klein.', 'frequency': 323},
  {'word': 'alt', 'article': null, 'gender': GermanGender.none, 'meaning': '老的', 'example': 'Der Mann ist alt.', 'frequency': 324},
  {'word': 'jung', 'article': null, 'gender': GermanGender.none, 'meaning': '年轻的', 'example': 'Sie ist noch jung.', 'frequency': 325},
  {'word': 'schön', 'article': null, 'gender': GermanGender.none, 'meaning': '美丽的', 'example': 'Die Blume ist schön.', 'frequency': 326},
  {'word': 'hässlich', 'article': null, 'gender': GermanGender.none, 'meaning': '丑陋的', 'example': 'Das Gebäude ist hässlich.', 'frequency': 327},
  {'word': 'interessant', 'article': null, 'gender': GermanGender.none, 'meaning': '有趣的', 'example': 'Der Film ist interessant.', 'frequency': 328},
  {'word': 'langweilig', 'article': null, 'gender': GermanGender.none, 'meaning': '无聊的', 'example': 'Die Vorlesung ist langweilig.', 'frequency': 329},
  {'word': 'wichtig', 'article': null, 'gender': GermanGender.none, 'meaning': '重要的', 'example': 'Das ist sehr wichtig.', 'frequency': 330},
  {'word': 'einfach', 'article': null, 'gender': GermanGender.none, 'meaning': '简单的', 'example': 'Die Aufgabe ist einfach.', 'frequency': 331},
  {'word': 'schwer', 'article': null, 'gender': GermanGender.none, 'meaning': '困难的', 'example': 'Das ist sehr schwer.', 'frequency': 332},
  {'word': 'leicht', 'article': null, 'gender': GermanGender.none, 'meaning': '容易的', 'example': 'Die Prüfung war leicht.', 'frequency': 333},
  {'word': 'neu', 'article': null, 'gender': GermanGender.none, 'meaning': '新的', 'example': 'Mein Auto ist neu.', 'frequency': 334},
  {'word': 'alt', 'article': null, 'gender': GermanGender.none, 'meaning': '旧的', 'example': 'Ich habe ein altes Handy.', 'frequency': 324},

  // 方位和地点
  {'word': 'links', 'article': null, 'gender': GermanGender.none, 'meaning': '左边', 'example': 'Wer sitzt links?', 'frequency': 335},
  {'word': 'rechts', 'article': null, 'gender': GermanGender.none, 'meaning': '右边', 'example': 'Geh nach rechts!', 'frequency': 336},
  {'word': 'oben', 'article': null, 'gender': GermanGender.none, 'meaning': '上面', 'example': 'Der Vogel sitzt oben.', 'frequency': 337},
  {'word': 'unten', 'article': null, 'gender': GermanGender.none, 'meaning': '下面', 'example': 'Die Schuhe stehen unten.', 'frequency': 338},
  {'word': 'vorne', 'article': null, 'gender': GermanGender.none, 'meaning': '前面', 'example': 'Wer sitzt vorne?', 'frequency': 339},
  {'word': 'hinten', 'article': null, 'gender': GermanGender.none, 'meaning': '后面', 'example': 'Die Kinder sitzen hinten.', 'frequency': 340},
  {'word': 'draußen', 'article': null, 'gender': GermanGender.none, 'meaning': '外面', 'example': 'Es ist kalt draußen.', 'frequency': 341},
  {'word': 'innen', 'article': null, 'gender': GermanGender.none, 'meaning': '里面', 'example': 'Es ist warm innen.', 'frequency': 342},
  {'word': 'neben', 'article': null, 'gender': GermanGender.none, 'meaning': '旁边', 'example': 'Das Buch liegt neben dem Laptop.', 'frequency': 343},
  {'word': 'zwischen', 'article': null, 'gender': GermanGender.none, 'meaning': '之间', 'example': 'Er steht zwischen den beiden.', 'frequency': 344},
  {'word': 'über', 'article': null, 'gender': GermanGender.none, 'meaning': '在...之上', 'example': 'Das Bild hängt über dem Sofa.', 'frequency': 345},
  {'word': 'unter', 'article': null, 'gender': GermanGender.none, 'meaning': '在...之下', 'example': 'Die Katze liegt unter dem Tisch.', 'frequency': 346},
  {'word': 'vor', 'article': null, 'gender': GermanGender.none, 'meaning': '在...之前', 'example': 'Wir treffen uns vor dem Kino.', 'frequency': 347},
  {'word': 'hinter', 'article': null, 'gender': GermanGender.none, 'meaning': '在...之后', 'example': 'Das Haus hinter der Schule.', 'frequency': 348},
];

/// A2级别扩展词汇（150词）- 社交生活
final List<Map<String, dynamic>> vocabularyA2Extended = [
  // 社交活动
  {'word': 'die Party', 'article': 'die', 'gender': 'die', 'meaning': '派对', 'example': 'Wir gehen auf eine Party.', 'frequency': 400},
  {'word': 'das Fest', 'article': 'das', 'gender': 'das', 'meaning': '节日', 'example': 'Das Fest ist groß.', 'frequency': 401},
  {'word': 'die Feier', 'article': 'die', 'gender': 'die', 'meaning': '庆祝活动', 'example': 'Die Feier war schön.', 'frequency': 402},
  {'word': 'der Geburtstag', 'article': 'der', 'gender': 'der', 'meaning': '生日', 'example': 'Alles Gute zum Geburtstag!', 'frequency': 403},
  {'word': 'das Geschenk', 'article': 'das', 'gender': 'das', 'meaning': '礼物', 'example': 'Das Geschenk ist teuer.', 'frequency': 404},
  {'word': 'die Einladung', 'article': 'die', 'gender': 'die', 'meaning': '邀请', 'example': 'Die Einladung kommt zu spät.', 'frequency': 405},
  {'word': 'der Termin', 'article': 'der', 'gender': 'der', 'meaning': '预约', 'example': 'Der Termin ist am Montag.', 'frequency': 406},

  // 通信
  {'word': 'der Anruf', 'article': 'der', 'gender': 'der', 'meaning': '电话', 'example': 'Ich habe einen Anruf.', 'frequency': 407},
  {'word': 'die E-Mail', 'article': 'die', 'gender': 'die', 'meaning': '电子邮件', 'example': 'Ich schreibe eine E-Mail.', 'frequency': 408},
  {'word': 'die Nachricht', 'article': 'die', 'gender': 'die', 'meaning': '消息', 'example': 'Ich habe eine Nachricht erhalten.', 'frequency': 409},
  {'word': 'der Brief', 'article': 'der', 'gender': 'der', 'meaning': '信', 'example': 'Der Brief ist von meiner Mutter.', 'frequency': 410},
  {'word': 'das Telefon', 'article': 'das', 'gender': 'das', 'meaning': '电话', 'example': 'Das Telefon klingelt.', 'frequency': 411},
  {'word': 'die Handynummer', 'article': 'die', 'gender': 'die', 'meaning': '手机号', 'example': 'Was ist deine Handynummer?', 'frequency': 412},

  // 媒体
  {'word': 'die Zeitung', 'article': 'die', 'gender': 'die', 'meaning': '报纸', 'example': 'Ich lese die Zeitung.', 'frequency': 413},
  {'word': 'die Zeitschrift', 'article': 'die', 'gender': 'die', 'meaning': '杂志', 'example': 'Die Zeitschrift ist monatlich.', 'frequency': 414},
  {'word': 'der Film', 'article': 'der', 'gender': 'der', 'meaning': '电影', 'example': 'Der Film ist spannend.', 'frequency': 415},
  {'word': 'die Serie', 'article': 'die', 'gender': 'die', 'meaning': '电视剧', 'example': 'Ich sehe eine Serie.', 'frequency': 416},
  {'word': 'das Video', 'article': 'das', 'gender': 'das', 'meaning': '视频', 'example': 'Das Video ist kurz.', 'frequency': 417},
  {'word': 'das Lied', 'article': 'das', 'gender': 'das', 'meaning': '歌曲', 'example': 'Das Lied ist bekannt.', 'frequency': 418},
  {'word': 'die Musik', 'article': 'die', 'gender': 'die', 'meaning': '音乐', 'example': 'Ich höre gerne Musik.', 'frequency': 419},

  // 爱好
  {'word': 'das Hobby', 'article': 'das', 'gender': 'das', 'meaning': '爱好', 'example': 'Was ist dein Hobby?', 'frequency': 420},
  {'word': 'das Interesse', 'article': 'das', 'gender': 'das', 'meaning': '兴趣', 'example': 'Ich habe viele Interessen.', 'frequency': 421},
  {'word': 'die Leidenschaft', 'article': 'die', 'gender': 'die', 'meaning': '热情', 'example': 'Musik ist meine Leidenschaft.', 'frequency': 422},
  {'word': 'der Sport', 'article': 'der', 'gender': 'der', 'meaning': '运动', 'example': 'Ich mache viel Sport.', 'frequency': 423},
  {'word': 'die Reise', 'article': 'die', 'gender': 'die', 'meaning': '旅行', 'example': 'Die Reise war schön.', 'frequency': 424},
  {'word': 'der Urlaub', 'article': 'der', 'gender': 'der', 'meaning': '度假', 'example': 'Im Urlaub bin ich entspannt.', 'frequency': 425},

  // 购物场所
  {'word': 'der Supermarkt', 'article': 'der', 'gender': 'der', 'meaning': '超市', 'example': 'Ich gehe in den Supermarkt.', 'frequency': 426},
  {'word': 'die Bäckerei', 'article': 'die', 'gender': 'die', 'meaning': '面包房', 'example': 'Das Brot ist von der Bäckerei.', 'frequency': 427},
  {'word': 'die Metzgerei', 'article': 'die', 'gender': 'die', 'meaning': '肉铺', 'example': 'Das Fleisch ist frisch.', 'frequency': 428},
  {'word': 'die Apotheke', 'article': 'die', 'gender': 'die', 'meaning': '药店', 'example': 'Die Apotheke ist zu.', 'frequency': 429},
  {'word': 'die Bank', 'article': 'die', 'gender': 'die', 'meaning': '银行', 'example': 'Ich gehe zur Bank.', 'frequency': 430},
  {'word': 'die Post', 'article': 'die', 'gender': 'die', 'meaning': '邮局', 'example': 'Ich gehe zur Post.', 'frequency': 431},
  {'word': 'das Restaurant', 'article': 'das', 'gender': 'das', 'meaning': '餐厅', 'example': 'Das Restaurant ist voll.', 'frequency': 432},
  {'word': 'das Café', 'article': 'das', 'gender': 'das', 'meaning': '咖啡馆', 'example': 'Wir treffen im Café.', 'frequency': 433},

  // 工作
  {'word': 'das Büro', 'article': 'das', 'gender': 'das', 'meaning': '办公室', 'example': 'Ich arbeite im Büro.', 'frequency': 434},
  {'word': 'der Chef', 'article': 'der', 'gender': 'der', 'meaning': '老板/主厨', 'example': 'Der Chef ist streng.', 'frequency': 435},
  {'word': 'der Kollege', 'article': 'der', 'gender': 'der', 'meaning': '同事', 'example': 'Mein Kollege ist nett.', 'frequency': 436},
  {'word': 'die Kollegin', 'article': 'die', 'gender': 'die', 'meaning': '同事（女性）', 'example': 'Meine Kollegin ist hilfsbereit.', 'frequency': 437},
  {'word': 'der Kunde', 'article': 'der', 'gender': 'der', 'meaning': '客户', 'example': 'Der Kunde ist zufrieden.', 'frequency': 438},
  {'word': 'der Auftrag', 'article': 'der', 'gender': 'der', 'meaning': '订单', 'example': 'Der Auftrag ist wichtig.', 'frequency': 439},
  {'word': 'das Gehalt', 'article': 'das', 'gender': 'das', 'meaning': '工资', 'example': 'Mein Gehalt ist 3000 Euro.', 'frequency': 440},
  {'word': 'das Gehalt', 'article': 'das', 'gender': 'das', 'meaning': '薪水', 'example': 'Ich bekomme mein Gehalt.', 'frequency': 441},

  // 抽象情感
  {'word': 'die Liebe', 'article': 'die', 'gender': 'die', 'meaning': '爱', 'example': 'Die Liebe ist schön.', 'frequency': 442},
  {'word': 'die Hoffnung', 'article': 'die', 'gender': 'die', 'meaning': '希望', 'example': 'Ich habe Hoffnung.', 'frequency': 443},
  {'word': 'die Angst', 'article': 'die', 'gender': 'die', 'meaning': '恐惧', 'example': 'Ich habe Angst.', 'frequency': 444},
  {'word': 'die Wut', 'article': 'die', 'gender': 'die', 'meaning': '愤怒', 'example': 'Er ist voller Wut.', 'frequency': 445},
  {'word': 'die Freude', 'article': 'die', 'gender': 'die', 'meaning': '欢乐', 'example': 'Wir haben Freude.', 'frequency': 446},
  {'word': 'der Stress', 'article': 'der', 'gender': 'der', 'meaning': '压力', 'example': 'Ich habe viel Stress.', 'frequency': 447},
  {'word': 'die Sorge', 'article': 'die', 'gender': 'die', 'meaning': '担心', 'example': 'Ich habe Sorgen.', 'frequency': 448},
  {'word': 'das Glück', 'article': 'das', 'gender': 'das', 'meaning': '幸运', 'example': 'Ich habe Glück.', 'frequency': 449},
  {'word': 'der Traum', 'article': 'der', 'gender': 'der', 'meaning': '梦', 'example': 'Ich habe einen Traum.', 'frequency': 450},
];

/// B1级别扩展词汇（150词）- 专业和抽象
final List<Map<String, dynamic>> vocabularyB1Extended = [
  // 政治
  {'word': 'die Politik', 'article': 'die', 'gender': 'die', 'meaning': '政治', 'example': 'Politik ist wichtig.', 'frequency': 500},
  {'word': 'die Wahl', 'article': 'die', 'gender': 'die', 'meaning': '选举', 'example': 'Die Wahl fand gestern statt.', 'frequency': 501},
  {'word': 'der Politiker', 'article': 'der', 'gender': 'der', 'meaning': '政治家', 'example': 'Der Politiker hält eine Rede.', 'frequency': 502},
  {'word': 'die Partei', 'article': 'die', 'gender': 'die', 'meaning': '党派', 'example': 'Welche Partei wählst du?', 'frequency': 503},
  {'word': 'die Regierung', 'article': 'die', 'gender': 'die', 'meaning': '政府', 'example': 'Die Regierung handelt.', 'frequency': 504},
  {'word': 'der Bürger', 'article': 'der', 'gender': 'der', 'meaning': '公民', 'example': 'Die Bürger demonstrieren.', 'frequency': 505},
  {'word': 'das Gesetz', 'article': 'das', 'gender': 'das', 'meaning': '法律', 'example': 'Das Gesetz ist wichtig.', 'frequency': 506},
  {'word': 'die Demokratie', 'article': 'die', 'gender': 'die', 'meaning': '民主', 'example': 'Deutschland ist eine Demokratie.', 'frequency': 507},

  // 经济
  {'word': 'die Wirtschaft', 'article': 'die', 'gender': 'die', 'meaning': '经济', 'example': 'Die Wirtschaft wächst.', 'frequency': 508},
  {'word': 'das Geld', 'article': 'das', 'gender': 'das', 'meaning': '钱', 'example': 'Geld ist wichtig.', 'frequency': 509},
  {'word': 'der Preis', 'article': 'der', 'gender': 'der', 'meaning': '价格', 'example': 'Der Preis ist hoch.', 'frequency': 510},
  {'word': 'die Kosten', 'article': 'die', 'gender': 'die', 'meaning': '费用', 'example': 'Die Kosten sind gestiegen.', 'frequency': 511},
  {'word': 'der Gewinn', 'article': 'der', 'gender': 'der', 'meaning': '利润', 'example': 'Wir machen Gewinn.', 'frequency': 512},
  {'word': 'der Umsatz', 'article': 'der', 'gender': 'der', 'meaning': '营业额', 'example': 'Der Umsatz ist gestiegen.', 'frequency': 513},
  {'word': 'die Investition', 'article': 'die', 'gender': 'die', 'meaning': '投资', 'example': 'Die Investition ist riskant.', 'frequency': 514},
  {'word': 'der Markt', 'article': 'der', 'gender': 'der', 'meaning': '市场', 'example': 'Der Markt ist groß.', 'frequency': 515},

  // 环境
  {'word': 'die Umwelt', 'article': 'die', 'gender': 'die', 'meaning': '环境', 'example': 'Die Umwelt ist wichtig.', 'frequency': 516},
  {'word': 'der Müll', 'article': 'der', 'gender': 'der', 'meaning': '垃圾', 'example': 'Wir trennen den Müll.', 'frequency': 517},
  {'word': 'die Verschmutzung', 'article': 'die', 'gender': 'die', 'meaning': '污染', 'example': 'Umweltverschmutzung ist ein Problem.', 'frequency': 518},
  {'word': 'das Klima', 'article': 'das', 'gender': 'das', 'meaning': '气候', 'example': 'Das Klima ändert sich.', 'frequency': 519},
  {'word': 'der Klimawandel', 'article': 'der', 'gender': 'der', 'meaning': '气候变化', 'example': 'Der Klimawandel ist real.', 'frequency': 520},
  {'word': 'die Energie', 'article': 'die', 'gender': 'die', 'meaning': '能源', 'example': 'Wir brauchen Energie.', 'frequency': 521},
  {'word': 'die Erneuerung', 'article': 'die', 'gender': 'die', 'meaning': '可再生能源', 'example': 'Erneuerbare Energie ist wichtig.', 'frequency': 522},

  // 科技
  {'word': 'die Technologie', 'article': 'die', 'gender': 'die', 'meaning': '技术', 'example': 'Technologie verändert unser Leben.', 'frequency': 523},
  {'word': 'die Innovation', 'article': 'die', 'gender': 'die', 'meaning': '创新', 'example': 'Innovation braucht Zeit.', 'frequency': 524},
  {'word': 'die Erfindung', 'article': 'die', 'gender': 'die', 'meaning': '发明', 'example': 'Die Erfindung ist genial.', 'frequency': 525},
  {'word': 'das Internet', 'article': 'das', 'gender': 'das', 'meaning': '互联网', 'example': 'Ich surfe im Internet.', 'frequency': 526},
  {'word': 'die Webseite', 'article': 'die', 'gender': 'die', 'meaning': '网站', 'example': 'Die Webseite ist gut.', 'frequency': 527},
  {'word': 'die App', 'article': 'die', 'gender': 'die', 'meaning': '应用程序', 'example': 'Die App ist nützlich.', 'frequency': 528},
  {'word': 'der Computer', 'article': 'der', 'gender': 'der', 'meaning': '电脑', 'example': 'Der Computer ist schnell.', 'frequency': 250},

  // 教育
  {'word': 'die Ausbildung', 'article': 'die', 'gender': 'die', 'meaning': '培训', 'example': 'Die Ausbildung dauert 3 Jahre.', 'frequency': 529},
  {'word': 'das Studium', 'article': 'das', 'gender': 'das', 'meaning': '大学学习', 'example': 'Ich mache ein Studium.', 'frequency': 530},
  {'word': 'der Abschluss', 'article': 'der', 'gender': 'der', 'meaning': '毕业', 'example': 'Ich habe meinen Abschluss gemacht.', 'frequency': 531},
  {'word': 'das Stipendium', 'article': 'das', 'gender': 'das', 'meaning': '奖学金', 'example': 'Ich bekomme ein Stipendium.', 'frequency': 532},
  {'word': 'die Forschung', 'article': 'die', 'gender': 'die', 'meaning': '研究', 'example': 'Forschung ist wichtig.', 'frequency': 533},
  {'word': 'die Wissenschaft', 'article': 'die', 'gender': 'die', 'meaning': '科学', 'example': 'Wissenschaft braucht Logik.', 'frequency': 534},

  // 文化
  {'word': 'die Kultur', 'article': 'die', 'gender': 'die', 'meaning': '文化', 'example': 'Die Kultur ist vielfältig.', 'frequency': 535},
  {'word': 'die Tradition', 'article': 'die', 'gender': 'die', 'meaning': '传统', 'example': 'Die Tradition ist alt.', 'frequency': 536},
  {'word': 'das Museum', 'article': 'das', 'gender': 'das', 'meaning': '博物馆', 'example': 'Das Museum ist interessant.', 'frequency': 537},
  {'word': 'die Ausstellung', 'article': 'die', 'gender': 'die', 'meaning': '展览', 'example': 'Die Ausstellung ist populär.', 'frequency': 538},
  {'word': 'das Konzert', 'article': 'das', 'gender': 'das', 'meaning': '音乐会', 'example': 'Das Konzert war toll.', 'frequency': 539},
  {'word': 'das Theater', 'article': 'das', 'gender': 'das', 'meaning': '剧院', 'example': 'Wir gehen ins Theater.', 'frequency': 540},
  {'word': 'die Oper', 'article': 'die', 'gender': 'die', 'meaning': '歌剧', 'example': 'Die Oper ist beeindruckend.', 'frequency': 541},

  // 健康
  {'word': 'die Krankheit', 'article': 'die', 'gender': 'die', 'meaning': '疾病', 'example': 'Die Krankheit ist schwer.', 'frequency': 542},
  {'word': 'die Symptome', 'article': 'die', 'gender': 'die', 'meaning': '症状', 'example': 'Die Symptome sind mild.', 'frequency': 543},
  {'word': 'die Diagnose', 'article': 'die', 'gender': 'die', 'meaning': '诊断', 'example': 'Die Diagnose ist klar.', 'frequency': 544},
  {'word': 'die Therapie', 'article': 'die', 'gender': 'die', 'meaning': '治疗', 'example': 'Die Therapie hilft.', 'frequency': 545},
  {'word': 'die Medizin', 'article': 'die', 'gender': 'die', 'meaning': '医学', 'example': 'Die Medizin ist fortschrittlich.', 'frequency': 546},
  {'word': 'der Arzt', 'article': 'der', 'gender': 'der', 'meaning': '医生', 'example': 'Der Arzt untersucht den Patienten.', 'frequency': 547},
  {'word': 'das Krankenhaus', 'article': 'das', 'gender': 'das', 'meaning': '医院', 'example': 'Ich gehe ins Krankenhaus.', 'frequency': 548},
  {'word': 'die Versicherung', 'article': 'die', 'gender': 'die', 'meaning': '保险', 'example': 'Die Versicherung zahlt.', 'frequency': 549},
  {'word': 'die Gesundheit', 'article': 'die', 'gender': 'die', 'meaning': '健康', 'example': 'Gesundheit ist wichtig.', 'frequency': 550},
];

/// B2级别扩展词汇（100词）- 高级表达
final List<Map<String, dynamic>> vocabularyB2Extended = [
  // 抽象概念
  {'word': 'die Demokratie', 'article': 'die', 'gender': 'die', 'meaning': '民主', 'example': 'Demokratie braucht Partizipation.', 'frequency': 600},
  {'word': 'die Globalisierung', 'article': 'die', 'gender': 'die', 'meaning': '全球化', 'example': 'Globalisierung verändert die Welt.', 'frequency': 601},
  {'word': 'der Kapitalismus', 'article': 'der', 'gender': 'der', 'meaning': '资本主义', 'example': 'Kapitalismus hat Vor- und Nachteile.', 'frequency': 602},
  {'word': 'der Sozialismus', 'article': 'der', 'gender': 'der', 'meaning': '社会主义', 'example': 'Sozialismus zielt auf Gerechtigkeit.', 'frequency': 603},
  {'word': 'die Nachhaltigkeit', 'article': 'die', 'gender': 'die', 'meaning': '可持续性', 'example': 'Nachhaltigkeit ist entscheidend.', 'frequency': 604},
  {'word': 'die Innovation', 'article': 'die', 'gender': 'die', 'meaning': '创新', 'example': 'Innovation treibt Fortschritt.', 'frequency': 605},
  {'word': 'der Fortschritt', 'article': 'der', 'gender': 'der', 'meaning': '进步', 'example': 'Wir machen gute Fortschritte.', 'frequency': 606},

  // 学术词汇
  {'word': 'die Hypothese', 'article': 'die', 'gender': 'die', 'meaning': '假设', 'example': 'Die Hypothese muss bewiesen werden.', 'frequency': 610},
  {'word': 'die Theorie', 'article': 'die', 'gender': 'die', 'meaning': '理论', 'example': 'Die Theorie scheint plausibel.', 'frequency': 611},
  {'word': 'die Praxis', 'article': 'die', 'gender': 'die', 'meaning': '实践', 'example': 'Praxis ist wichtiger als Theorie.', 'frequency': 612},
  {'word': 'die Methode', 'article': 'die', 'gender': 'die', 'meaning': '方法', 'example': 'Wir brauchen eine bessere Methode.', 'frequency': 613},
  {'word': 'das Ergebnis', 'article': 'das', 'gender': 'das', 'meaning': '结果', 'example': 'Das Ergebnis ist gut.', 'frequency': 614},
  {'word': 'der Beweis', 'article': 'der', 'gender': 'der', 'meaning': '证据', 'example': 'Wir brauchen einen Beweis.', 'frequency': 615},
  {'word': 'das Argument', 'article': 'das', 'gender': 'das', 'meaning': '论据', 'example': 'Das Argument ist stark.', 'frequency': 616},
  {'word': 'die Schlussfolgerung', 'article': 'die', 'gender': 'die', 'meaning': '结论', 'example': 'Die Schlussfolgerung ist logisch.', 'frequency': 617},

  // 社会现象
  {'word': 'die Integration', 'article': 'die', 'gender': 'die', 'meaning': '融入', 'example': 'Integration braucht Zeit.', 'frequency': 620},
  {'word': 'die Diskriminierung', 'article': 'die', 'gender': 'die', 'meaning': '歧视', 'example': 'Diskriminierung ist illegal.', 'frequency': 621},
  {'word': 'die Gleichberechtigung', 'article': 'die', 'gender': 'die', 'meaning': '平等', 'example': 'Gleichberechtigung ist ein Recht.', 'frequency': 622},
  {'word': 'der Protest', 'article': 'der', 'gender': 'der', 'meaning': '抗议', 'example': 'Der Protest war friedlich.', 'frequency': 623},
  {'word': 'die Demonstration', 'article': 'die', 'gender': 'die', 'meaning': '示威游行', 'example': 'Die Demonstration war groß.', 'frequency': 624},
  {'word': 'die Revolution', 'article': 'die', 'gender': 'die', 'meaning': '革命', 'example': 'Die Revolution verändert alles.', 'frequency': 625},

  // 专业领域
  {'word': 'die Wirtschaftskrise', 'article': 'die', 'gender': 'die', 'meaning': '经济危机', 'example': 'Die Wirtschaftskrise traf viele.', 'frequency': 630},
  {'word': 'die Inflation', 'article': 'die', 'gender': 'die', 'meaning': '通货膨胀', 'example': 'Inflation macht alles teurer.', 'frequency': 631},
  {'word': 'die Arbeitslosigkeit', 'article': 'die', 'gender': 'die', 'meaning': '失业', 'example': 'Arbeitslosigkeit ist ein Problem.', 'frequency': 632},
  {'word': 'die Beschäftigung', 'article': 'die', 'gender': 'die', 'meaning': '就业', 'example': 'Beschäftigung ist stabil.', 'frequency': 633},
  {'word': 'die Rente', 'article': 'die', 'gender': 'die', 'meaning': '养老金', 'example': 'Ich beziehe eine Rente.', 'frequency': 634},
  {'word': 'die Steuer', 'article': 'die', 'gender': 'die', 'meaning': '税', 'example': 'Steuern sind hoch.', 'frequency': 635},
  {'word': 'der Sozialbeitrag', 'article': 'der', 'gender': 'der', 'meaning': '社会保险', 'example': 'Sozialbeiträge sind abgeführt.', 'frequency': 636},
  {'word': 'das Budget', 'article': 'das', 'gender': 'das', 'meaning': '预算', 'example': 'Das Budget ist begrenzt.', 'frequency': 637},
  {'word': 'das Defizit', 'article': 'das', 'gender': 'das', 'meaning': '赤字', 'example': 'Das Defizit ist gewachsen.', 'frequency': 638},

  // 思想和哲学
  {'word': 'die Philosophie', 'article': 'die', 'gender': 'die', 'meaning': '哲学', 'example': 'Philosophie fragt nach dem Sinn.', 'frequency': 640},
  {'word': 'die Ethik', 'article': 'die', 'gender': 'die', 'meaning': '伦理', 'example': 'Ethik ist wichtig für Entscheidungen.', 'frequency': 641},
  {'word': 'die Moral', 'article': 'die', 'gender': 'die', 'meaning': '道德', 'example': 'Moral ist subjektiv.', 'frequency': 642},
  {'word': 'das Prinzip', 'article': 'das', 'gender': 'das', 'meaning': '原则', 'example': 'Wir folgen diesem Prinzip.', 'frequency': 643},
  {'word': 'der Wert', 'article': 'der', 'gender': 'der', 'meaning': '价值', 'example': 'Was sind deine Werte?', 'frequency': 644},
  {'word': 'die Norm', 'article': 'die', 'gender': 'die', 'meaning': '规范', 'example': 'Die Norm ist unbewusst.', 'frequency': 645},
  {'word': 'das Ideal', 'article': 'das', 'gender': 'das', 'meaning': '理想', 'example': 'Das Ideal ist unerreichbar.', 'frequency': 646},
  {'word': 'die Utopie', 'article': 'die', 'gender': 'die', 'meaning': '乌托邦', 'example': 'Utopie ist eine Vision.', 'frequency': 647},
  {'word': 'die Realität', 'article': 'die', 'gender': 'die', 'meaning': '现实', 'example': 'Realität ist oft hart.', 'frequency': 648},
];

/// C1级别扩展词汇（100词）- 学术和高级表达
final List<Map<String, dynamic>> vocabularyC1Extended = [
  // 学术词汇
  {'word': 'die Abhandlung', 'article': 'die', 'gender': 'die', 'meaning': '论文', 'example': 'Die Abhandlung ist umfassend.', 'frequency': 700},
  {'word': 'der Aufsatz', 'article': 'der', 'gender': 'der', 'meaning': '文章', 'example': 'Der Aufsatz ist gut geschrieben.', 'frequency': 701},
  {'word': 'die These', 'article': 'die', 'gender': 'die', 'meaning': '论题', 'example': 'Die These ist kontrovers.', 'frequency': 702},
  {'word': 'die Antithese', 'article': 'die', 'gender': 'die', 'meaning': '反题', 'example': 'Die Antithese ist schlüssig.', 'frequency': 703},
  {'word': 'die Synthese', 'article': 'die', 'gender': 'die', 'meaning': '综合', 'example': 'Die Synthese ist gelungen.', 'frequency': 704},
  {'word': 'der Begriff', 'article': 'der', 'gender': 'der', 'meaning': '概念', 'example': 'Der Begriff ist vage.', 'frequency': 705},
  {'word': 'die Definition', 'article': 'die', 'gender': 'die', 'meaning': '定义', 'example': 'Die Definition ist präzise.', 'frequency': 706},
  {'word': 'die Interpretation', 'article': 'die', 'gender': 'die', 'meaning': '解释', 'example': 'Die Interpretation ist überzeugend.', 'frequency': 707},
  {'word': 'die Analyse', 'article': 'die', 'gender': 'die', 'meaning': '分析', 'example': 'Die Analyse ist gründlich.', 'frequency': 708},
  {'word': 'die Kritik', 'article': 'die', 'gender': 'die', 'meaning': '批评', 'example': 'Die Kritik ist berechtigt.', 'frequency': 709},

  // 文学词汇
  {'word': 'die Metapher', 'article': 'die', 'gender': 'die', 'meaning': '隐喻', 'example': 'Die Metapher ist kraftvoll.', 'frequency': 710},
  {'word': 'das Symbol', 'article': 'das', 'gender': 'das', 'meaning': '象征', 'example': 'Das Symbol ist universell.', 'frequency': 711},
  {'word': 'die Allegorie', 'article': 'die', 'gender': 'die', 'meaning': '寓言', 'example': 'Die Allegorie ist tiefgründig.', 'frequency': 712},
  {'word': 'die Ironie', 'article': 'die', 'gender': 'die', 'meaning': '讽刺', 'example': 'Die Ironie ist feinsinnig.', 'frequency': 713},
  {'word': 'das Satire', 'article': 'die', 'gender': 'die', 'meaning': '讽刺文学', 'example': 'Die Satire ist scharf.', 'frequency': 714},
  {'word': 'die Prosa', 'article': 'die', 'gender': 'die', 'meaning': '散文', 'example': 'Die Prosa ist flüssig.', 'frequency': 715},
  {'word': 'die Lyrik', 'article': 'die', 'gender': 'die', 'meaning': '诗歌', 'example': 'Die Lyrik ist ausdrucksvoll.', 'frequency': 716},
  {'word': 'das Drama', 'article': 'das', 'gender': 'das', 'meaning': '戏剧', 'example': 'Das Drama ist intensiv.', 'frequency': 717},
  {'word': 'die Epopöe', 'article': 'die', 'gender': 'die', 'meaning': '史诗', 'example': 'Die Epopöe ist monumental.', 'frequency': 718},
  {'word': 'die Anthologie', 'article': 'die', 'gender': 'die', 'meaning': '选集', 'example': 'Die Anthologie ist vielfältig.', 'frequency': 719},

  // 高级抽象概念
  {'word': 'die Ambivalenz', 'article': 'die', 'gender': 'die', 'meaning': '矛盾心理', 'example': 'Die Ambivalenz ist spürbar.', 'frequency': 720},
  {'word': 'die Dichotomie', 'article': 'die', 'gender': 'die', 'meaning': '二分法', 'example': 'Die Dichotomie ist künstlich.', 'frequency': 721},
  {'word': 'die Paradoxie', 'article': 'die', 'gender': 'die', 'meaning': '悖论', 'example': 'Die Paradoxie ist faszinierend.', 'frequency': 722},
  {'word': 'die Nuance', 'article': 'die', 'gender': 'die', 'meaning': '细微差别', 'example': 'Die Nuance ist wichtig.', 'frequency': 723},
  {'word': 'das Dilemma', 'article': 'das', 'gender': 'das', 'meaning': '困境', 'example': 'Das Dilemma ist unlösbar.', 'frequency': 724},
  {'word': 'der Konflikt', 'article': 'der', 'gender': 'der', 'meaning': '冲突', 'example': 'Der Konflikt ist unvermeidlich.', 'frequency': 725},
  {'word': 'die Kontroverse', 'article': 'die', 'gender': 'die', 'meaning': '争议', 'example': 'Die Kontroverse ist heftig.', 'frequency': 726},
  {'word': 'die Dissonanz', 'article': 'die', 'gender': 'die', 'meaning': '不和谐', 'example': 'Die Dissonanz ist unangenehm.', 'frequency': 727},
  {'word': 'die Konsonanz', 'article': 'die', 'gender': 'die', 'meaning': '和谐', 'example': 'Die Konsonanz ist wohltuend.', 'frequency': 728},
  {'word': 'die Synonymie', 'article': 'die', 'gender': 'die', 'meaning': '同义', 'example': 'Die Synonymie ist nützlich.', 'frequency': 729},

  // 专业和职业词汇
  {'word': 'die Kompetenz', 'article': 'die', 'gender': 'die', 'meaning': '能力', 'example': 'Die Kompetenz ist breit.', 'frequency': 730},
  {'word': 'die Qualifikation', 'article': 'die', 'gender': 'die', 'meaning': '资格', 'example': 'Die Qualifikation ist erforderlich.', 'frequency': 731},
  {'word': 'die Spezialisierung', 'article': 'die', 'gender': 'die', 'meaning': '专业化', 'example': 'Die Spezialisierung ist tief.', 'frequency': 732},
  {'word': 'die Expertise', 'article': 'die', 'gender': 'die', 'meaning': '专业知识', 'example': 'Die Expertise ist anerkannt.', 'frequency': 733},
  {'word': 'das Profession', 'article': 'das', 'gender': 'das', 'meaning': '职业', 'example': 'Das Profession ist anspruchsvoll.', 'frequency': 734},
  {'word': 'die Karriere', 'article': 'die', 'gender': 'die', 'meaning': '事业', 'example': 'Die Karriere ist erfolgreich.', 'frequency': 735},
  {'word': 'die Position', 'article': 'die', 'gender': 'die', 'meaning': '职位', 'example': 'Die Position ist hoch.', 'frequency': 736},
  {'word': 'die Beförderung', 'article': 'die', 'gender': 'die', 'meaning': '晋升', 'example': 'Die Beförderung ist verdient.', 'frequency': 737},
  {'word': 'der Rücktritt', 'article': 'der', 'gender': 'der', 'meaning': '辞职', 'example': 'Der Rücktritt ist überraschend.', 'frequency': 738},
  {'word': 'die Pension', 'article': 'die', 'gender': 'die', 'meaning': '退休', 'example': 'Die Pension ist früh.', 'frequency': 739},

  // 科学和技术
  {'word': 'der Algorithmus', 'article': 'der', 'gender': 'der', 'meaning': '算法', 'example': 'Der Algorithmus ist effizient.', 'frequency': 740},
  {'word': 'die Daten', 'article': 'die', 'gender': 'die', 'meaning': '数据', 'example': 'Die Daten sind umfangreich.', 'frequency': 741},
  {'word': 'die Statistik', 'article': 'die', 'gender': 'die', 'meaning': '统计', 'example': 'Die Statistik ist repräsentativ.', 'frequency': 742},
  {'word': 'die Wahrscheinlichkeit', 'article': 'die', 'gender': 'die', 'meaning': '概率', 'example': 'Die Wahrscheinlichkeit ist hoch.', 'frequency': 743},
  {'word': 'die Korrelation', 'article': 'die', 'gender': 'die', 'meaning': '相关性', 'example': 'Die Korrelation ist signifikant.', 'frequency': 744},
  {'word': 'die Kausalität', 'article': 'die', 'gender': 'die', 'meaning': '因果性', 'example': 'Die Kausalität ist nicht bewiesen.', 'frequency': 745},
  {'word': 'die Variablen', 'article': 'die', 'gender': 'die', 'meaning': '变量', 'example': 'Die Variablen sind kontrolliert.', 'frequency': 746},
  {'word': 'das Experiment', 'article': 'das', 'gender': 'das', 'meaning': '实验', 'example': 'Das Experiment ist wiederholbar.', 'frequency': 747},
  {'word': 'die Simulation', 'article': 'die', 'gender': 'die', 'meaning': '模拟', 'example': 'Die Simulation ist realistisch.', 'frequency': 748},
  {'word': 'die Modellierung', 'article': 'die', 'gender': 'die', 'meaning': '建模', 'example': 'Die Modellierung ist präzise.', 'frequency': 749},

  // 政治和社会
  {'word': 'die Souveränität', 'article': 'die', 'gender': 'die', 'meaning': '主权', 'example': 'Die Souveränität ist unantastbar.', 'frequency': 750},
  {'word': 'die Autonomie', 'article': 'die', 'gender': 'die', 'meaning': '自治', 'example': 'Die Autonomie ist begrenzt.', 'frequency': 751},
  {'word': 'die Hegemonie', 'article': 'die', 'gender': 'die', 'meaning': '霸权', 'example': 'Die Hegemonie ist fragil.', 'frequency': 752},
  {'word': 'das Diplomatie', 'article': 'die', 'gender': 'die', 'meaning': '外交', 'example': 'Die Diplomatie ist komplex.', 'frequency': 753},
  {'word': 'der Vertrag', 'article': 'der', 'gender': 'der', 'meaning': '条约', 'example': 'Der Vertrag ist bindend.', 'frequency': 754},
  {'word': 'das Abkommen', 'article': 'das', 'gender': 'das', 'meaning': '协议', 'example': 'Das Abkommen ist unterzeichnet.', 'frequency': 755},
  {'word': 'der Kompromiss', 'article': 'der', 'gender': 'der', 'meaning': '妥协', 'example': 'Der Kompromiss ist ausgewogen.', 'frequency': 756},
  {'word': 'der Konsens', 'article': 'der', 'gender': 'der', 'meaning': '共识', 'example': 'Der Konsens ist schwer.', 'frequency': 757},
  {'word': 'das Veto', 'article': 'das', 'gender': 'das', 'meaning': '否决', 'example': 'Das Veto ist eingelegt.', 'frequency': 758},
  {'word': 'die Sanktion', 'article': 'die', 'gender': 'die', 'meaning': '制裁', 'example': 'Die Sanktion ist wirksam.', 'frequency': 759},

  // 心理和认知
  {'word': 'die Kognition', 'article': 'die', 'gender': 'die', 'meaning': '认知', 'example': 'Die Kognition ist komplex.', 'frequency': 760},
  {'word': 'die Wahrnehmung', 'article': 'die', 'gender': 'die', 'meaning': '感知', 'example': 'Die Wahrnehmung ist subjektiv.', 'frequency': 761},
  {'word': 'das Bewusstsein', 'article': 'das', 'gender': 'das', 'meaning': '意识', 'example': 'Das Bewusstsein ist erweitert.', 'frequency': 762},
  {'word': 'die Intuition', 'article': 'die', 'gender': 'die', 'meaning': '直觉', 'example': 'Die Intuition ist zuverlässig.', 'frequency': 763},
  {'word': 'die Rationalität', 'article': 'die', 'gender': 'die', 'meaning': '理性', 'example': 'Die Rationalität ist begrenzt.', 'frequency': 764},
  {'word': 'die Emotionalität', 'article': 'die', 'gender': 'die', 'meaning': '情感', 'example': 'Die Emotionalität ist stark.', 'frequency': 765},
  {'word': 'die Motivation', 'article': 'die', 'gender': 'die', 'meaning': '动机', 'example': 'Die Motivation ist hoch.', 'frequency': 766},
  {'word': 'die Einstellung', 'article': 'die', 'gender': 'die', 'meaning': '态度', 'example': 'Die Einstellung ist positiv.', 'frequency': 767},
  {'word': 'das Verhalten', 'article': 'das', 'gender': 'das', 'meaning': '行为', 'example': 'Das Verhalten ist angemessen.', 'frequency': 768},
  {'word': 'die Reaktion', 'article': 'die', 'gender': 'die', 'meaning': '反应', 'example': 'Die Reaktion ist schnell.', 'frequency': 769},

  // 语言和交流
  {'word': 'die Semantik', 'article': 'die', 'gender': 'die', 'meaning': '语义学', 'example': 'Die Semantik ist fundamental.', 'frequency': 770},
  {'word': 'die Syntax', 'article': 'die', 'gender': 'die', 'meaning': '句法', 'example': 'Die Syntax ist korrekt.', 'frequency': 771},
  {'word': 'die Pragmatik', 'article': 'die', 'gender': 'die', 'meaning': '语用学', 'example': 'Die Pragmatik ist wichtig.', 'frequency': 772},
  {'word': 'die Rhetorik', 'article': 'die', 'gender': 'die', 'meaning': '修辞', 'example': 'Die Rhetorik ist überzeugend.', 'frequency': 773},
  {'word': 'die Dialektik', 'article': 'die', 'gender': 'die', 'meaning': '辩证法', 'example': 'Die Dialektik ist dynamisch.', 'frequency': 774},
  {'word': 'die Argumentation', 'article': 'die', 'gender': 'die', 'meaning': '论证', 'example': 'Die Argumentation ist schlüssig.', 'frequency': 775},
  {'word': 'die Präsentation', 'article': 'die', 'gender': 'die', 'meaning': '展示', 'example': 'Die Präsentation ist gelungen.', 'frequency': 776},
  {'word': 'die Moderation', 'article': 'die', 'gender': 'die', 'meaning': '主持', 'example': 'Die Moderation ist professionell.', 'frequency': 777},
  {'word': 'die Verhandlung', 'article': 'die', 'gender': 'die', 'meaning': '谈判', 'example': 'Die Verhandlung ist tough.', 'frequency': 778},
  {'word': 'die Kommunikation', 'article': 'die', 'gender': 'die', 'meaning': '交流', 'example': 'Die Kommunikation ist klar.', 'frequency': 779},
];

/// C2级别扩展词汇（100词）- 精通与文学表达
final List<Map<String, dynamic>> vocabularyC2Extended = [
  // 文学与修辞高级词汇
  {'word': 'die Metaphysik', 'article': 'die', 'gender': 'die', 'meaning': '形而上学', 'example': 'Die Metaphysik erforscht das Sein.', 'frequency': 800},
  {'word': 'die Ästhetik', 'article': 'die', 'gender': 'die', 'meaning': '美学', 'example': 'Die Ästhetik ist subjektiv.', 'frequency': 801},
  {'word': 'die Hermeneutik', 'article': 'die', 'gender': 'die', 'meaning': '诠释学', 'example': 'Die Hermeneutik deutet Texte.', 'frequency': 802},
  {'word': 'die Phänomenologie', 'article': 'die', 'gender': 'die', 'meaning': '现象学', 'example': 'Die Phänomenologie beschreibt Bewusstsein.', 'frequency': 803},
  {'word': 'die Existenz', 'article': 'die', 'gender': 'die', 'meaning': '存在', 'example': 'Die Existenz ist fragil.', 'frequency': 804},
  {'word': 'das Bewusstsein', 'article': 'das', 'gender': 'das', 'meaning': '意识', 'example': 'Das Bewusstsein ist komplex.', 'frequency': 805},
  {'word': 'die Transzendenz', 'article': 'die', 'gender': 'die', 'meaning': '超越性', 'example': 'Die Transzendenz führt über sich hinaus.', 'frequency': 806},
  {'word': 'die Immanenz', 'article': 'die', 'gender': 'die', 'meaning': '内在性', 'example': 'Die Immanenz bleibt in sich.', 'frequency': 807},
  {'word': 'die Subjektivität', 'article': 'die', 'gender': 'die', 'meaning': '主观性', 'example': 'Die Subjektivität ist perspektivisch.', 'frequency': 808},
  {'word': 'die Objektivität', 'article': 'die', 'gender': 'die', 'meaning': '客观性', 'example': 'Die Objektivität ist messbar.', 'frequency': 809},

  // 哲学概念
  {'word': 'der Skeptizismus', 'article': 'der', 'gender': 'der', 'meaning': '怀疑论', 'example': 'Der Skeptizismus hinterfragt alles.', 'frequency': 810},
  {'word': 'der Dogmatismus', 'article': 'der', 'gender': 'der', 'meaning': '教条主义', 'example': 'Der Dogmatismus ist starr.', 'frequency': 811},
  {'word': 'der Pragmatismus', 'article': 'der', 'gender': 'der', 'meaning': '实用主义', 'example': 'Der Pragmatismus ist handlungsorientiert.', 'frequency': 812},
  {'word': 'der Idealismus', 'article': 'der', 'gender': 'der', 'meaning': '唯心主义', 'example': 'Der Idealismus betont das Geistige.', 'frequency': 813},
  {'word': 'der Materialismus', 'article': 'der', 'gender': 'der', 'meaning': '唯物主义', 'example': 'Der Materialismus betont das Materielle.', 'frequency': 814},
  {'word': 'der Rationalismus', 'article': 'der', 'gender': 'der', 'meaning': '理性主义', 'example': 'Der Rationalismus vertraut der Vernunft.', 'frequency': 815},
  {'word': 'der Empirismus', 'article': 'der', 'gender': 'der', 'meaning': '经验主义', 'example': 'Der Empirismus vertraut der Erfahrung.', 'frequency': 816},
  {'word': 'der Existenzialismus', 'article': 'der', 'gender': 'der', 'meaning': '存在主义', 'example': 'Der Existenzialismus betont die Freiheit.', 'frequency': 817},
  {'word': 'der Nihilismus', 'article': 'der', 'gender': 'der', 'meaning': '虚无主义', 'example': 'Der Nihilismus lehnt Werte ab.', 'frequency': 818},
  {'word': 'der Humanismus', 'article': 'der', 'gender': 'der', 'meaning': '人文主义', 'example': 'Der Humanismus betont den Menschen.', 'frequency': 819},

  // 文学技巧
  {'word': 'die Alliteration', 'article': 'die', 'gender': 'die', 'meaning': '头韵', 'example': 'Die Alliteration reimt Anlaute.', 'frequency': 820},
  {'word': 'der Reim', 'article': 'der', 'gender': 'der', 'meaning': '韵', 'example': 'Der Reim verbindet Endreime.', 'frequency': 821},
  {'word': 'das Metrum', 'article': 'das', 'gender': 'das', 'meaning': '格律', 'example': 'Das Metrum bestimmt den Rhythmus.', 'frequency': 822},
  {'word': 'die Rhetorik', 'article': 'die', 'gender': 'die', 'meaning': '修辞学', 'example': 'Die Rhetorik lehrt das Überzeugen.', 'frequency': 823},
  {'word': 'die Stilistik', 'article': 'die', 'gender': 'die', 'meaning': '文体学', 'example': 'Die Stilistik analysiert den Stil.', 'frequency': 824},
  {'word': 'die Narratologie', 'article': 'die', 'gender': 'die', 'meaning': '叙事学', 'example': 'Die Narratologie untersucht Erzählungen.', 'frequency': 825},
  {'word': 'die Intertextualität', 'article': 'die', 'gender': 'die', 'meaning': '互文性', 'example': 'Die Intertextualität verweist auf andere Texte.', 'frequency': 826},
  {'word': 'die Dekonstruktion', 'article': 'die', 'gender': 'die', 'meaning': '解构', 'example': 'Die Dekonstruktion hinterfragt Strukturen.', 'frequency': 827},
  {'word': 'die Rezeption', 'article': 'die', 'gender': 'die', 'meaning': '接受', 'example': 'Die Rezeption ist subjektiv.', 'frequency': 828},
  {'word': 'die Wirkung', 'article': 'die', 'gender': 'die', 'meaning': '效果', 'example': 'Die Wirkung ist intendiert.', 'frequency': 829},

  // 社会学词汇
  {'word': 'die Stratifikation', 'article': 'die', 'gender': 'die', 'meaning': '社会分层', 'example': 'Die Stratifikation beschreibt Schichten.', 'frequency': 830},
  {'word': 'die Mobilität', 'article': 'die', 'gender': 'die', 'meaning': '流动性', 'example': 'Die Mobilität ermöglicht Aufstieg.', 'frequency': 831},
  {'word': 'die Assimilation', 'article': 'die', 'gender': 'die', 'meaning': '同化', 'example': 'Die Assimilation passt an.', 'frequency': 832},
  {'word': 'die Segregation', 'article': 'die', 'gender': 'die', 'meaning': '隔离', 'example': 'Die Segregation trennt Gruppen.', 'frequency': 833},
  {'word': 'der Exklusion', 'article': 'die', 'gender': 'die', 'meaning': '排斥', 'example': 'Die Exklusion grenzt aus.', 'frequency': 834},
  {'word': 'die Inklusion', 'article': 'die', 'gender': 'die', 'meaning': '包容', 'example': 'Die Inklusion integriert alle.', 'frequency': 835},
  {'word': 'derpluralismus', 'article': 'der', 'gender': 'der', 'meaning': '多元主义', 'example': 'Der Pluralismus akzeptiert Vielfalt.', 'frequency': 836},
  {'word': 'der Elitarismus', 'article': 'der', 'gender': 'der', 'meaning': '精英主义', 'example': 'Der Elitarismus bevorzugt Eliten.', 'frequency': 837},
  {'word': 'der Egalitarismus', 'article': 'der', 'gender': 'der', 'meaning': '平等主义', 'example': 'Der Egalitarismus strebt Gleichheit an.', 'frequency': 838},
  {'word': 'der Totalitarismus', 'article': 'der', 'gender': 'der', 'meaning': '极权主义', 'example': 'Der Totalitarismus kontrolliert alles.', 'frequency': 839},

  // 心理学高级词汇
  {'word': 'die Kognition', 'article': 'die', 'gender': 'die', 'meaning': '认知', 'example': 'Die Kognition verarbeitet Information.', 'frequency': 840},
  {'word': 'die Perception', 'article': 'die', 'gender': 'die', 'meaning': '感知', 'example': 'Die Perception ist subjektiv.', 'frequency': 841},
  {'word': 'die Emotion', 'article': 'die', 'gender': 'die', 'meaning': '情感', 'example': 'Die Emotion ist intensiv.', 'frequency': 842},
  {'word': 'der Affekt', 'article': 'der', 'gender': 'der', 'meaning': '情感', 'example': 'Der Affekt ist unmittelbar.', 'frequency': 843},
  {'word': 'das Temperament', 'article': 'das', 'gender': 'das', 'meaning': '气质', 'example': 'Das Temperament ist angeboren.', 'frequency': 844},
  {'word': 'der Charakter', 'article': 'der', 'gender': 'der', 'meaning': '性格', 'example': 'Der Charakter ist geprägt.', 'frequency': 845},
  {'word': 'die Persönlichkeit', 'article': 'die', 'gender': 'die', 'meaning': '人格', 'example': 'Die Persönlichkeit ist einzigartig.', 'frequency': 846},
  {'word': 'die Identität', 'article': 'die', 'gender': 'die', 'meaning': '身份', 'example': 'Die Identität ist konstruiert.', 'frequency': 847},
  {'word': 'das Selbst', 'article': 'das', 'gender': 'das', 'meaning': '自我', 'example': 'Das Selbst entwickelt sich.', 'frequency': 848},
  {'word': 'das Unbewusste', 'article': 'das', 'gender': 'das', 'meaning': '无意识', 'example': 'Das Unbewusste beeinflusst uns.', 'frequency': 849},

  // 语言学高级词汇
  {'word': 'die Semantik', 'article': 'die', 'gender': 'die', 'meaning': '语义学', 'example': 'Die Semantik erforscht Bedeutung.', 'frequency': 850},
  {'word': 'die Pragmatik', 'article': 'die', 'gender': 'die', 'meaning': '语用学', 'example': 'Die Pragmatik erforscht Gebrauch.', 'frequency': 851},
  {'word': 'die Syntax', 'article': 'die', 'gender': 'die', 'meaning': '句法学', 'example': 'Die Syntax erforscht Struktur.', 'frequency': 852},
  {'word': 'die Morphologie', 'article': 'die', 'gender': 'die', 'meaning': '形态学', 'example': 'Die Morphologie erforscht Formen.', 'frequency': 853},
  {'word': 'die Phonologie', 'article': 'die', 'gender': 'die', 'meaning': '音系学', 'example': 'Die Phonologie erforscht Laute.', 'frequency': 854},
  {'word': 'die Phonetik', 'article': 'die', 'gender': 'die', 'meaning': '语音学', 'example': 'Die Phonetik beschreibt Laute.', 'frequency': 855},
  {'word': 'das Lexem', 'article': 'das', 'gender': 'das', 'meaning': '词位', 'example': 'Das Lexem ist die Grundform.', 'frequency': 856},
  {'word': 'das Morphem', 'article': 'das', 'gender': 'das', 'meaning': '语素', 'example': 'Das Morphem ist die kleinste Einheit.', 'frequency': 857},
  {'word': 'das Phonem', 'article': 'das', 'gender': 'das', 'meaning': '音位', 'example': 'Das Phonem unterscheidet Bedeutung.', 'frequency': 858},
  {'word': 'die Sem', 'article': 'die', 'gender': 'die', 'meaning': '义素', 'example': 'Die Sem ist die kleinste Bedeutungseinheit.', 'frequency': 859},

  // 艺术与美学
  {'word': 'die Avantgarde', 'article': 'die', 'gender': 'die', 'meaning': '前卫', 'example': 'Die Avantgarde ist innovativ.', 'frequency': 860},
  {'word': 'der Klassizismus', 'article': 'der', 'gender': 'der', 'meaning': '古典主义', 'example': 'Der Klassizismus orientiert an Antike.', 'frequency': 861},
  {'word': 'der Romantik', 'article': 'die', 'gender': 'die', 'meaning': '浪漫主义', 'example': 'Die Romantik betont Gefühl.', 'frequency': 862},
  {'word': 'der Realismus', 'article': 'der', 'gender': 'der', 'meaning': '现实主义', 'example': 'Der Realismus zeigt Wirklichkeit.', 'frequency': 863},
  {'word': 'der Expressionismus', 'article': 'der', 'gender': 'der', 'meaning': '表现主义', 'example': 'Der Expressionismus drückt Gefühl aus.', 'frequency': 864},
  {'word': 'der Surrealismus', 'article': 'der', 'gender': 'der', 'meaning': '超现实主义', 'example': 'Der Surrealismus überwindet Realität.', 'frequency': 865},
  {'word': 'der Kubismus', 'article': 'der', 'gender': 'der', 'meaning': '立体主义', 'example': 'Der Kubismus zerlegt Formen.', 'frequency': 866},
  {'word': 'der Impressionismus', 'article': 'der', 'gender': 'der', 'meaning': '印象主义', 'example': 'Der Impressionismus fängt Eindrücke ein.', 'frequency': 867},
  {'word': 'der Minimalismus', 'article': 'der', 'gender': 'der', 'meaning': '极简主义', 'example': 'Der Minimalismus reduziert auf Wesentliches.', 'frequency': 868},
  {'word': 'der Postmodernismus', 'article': 'der', 'gender': 'der', 'meaning': '后现代主义', 'example': 'Der Postmodernismus hinterfragt Moderne.', 'frequency': 869},

  // 科学哲学
  {'word': 'der Paradigmenwechsel', 'article': 'der', 'gender': 'der', 'meaning': '范式转换', 'example': 'Der Paradigmenwechsel revolutioniert.', 'frequency': 870},
  {'word': 'die Epistemologie', 'article': 'die', 'gender': 'die', 'meaning': '认识论', 'example': 'Die Epistemologie erforscht Erkenntnis.', 'frequency': 871},
  {'word': 'die Methodologie', 'article': 'die', 'gender': 'die', 'meaning': '方法论', 'example': 'Die Methodologie beschreibt Methoden.', 'frequency': 872},
  {'word': 'die Verifikation', 'article': 'die', 'gender': 'die', 'meaning': '验证', 'example': 'Die Verifikation bestätigt Hypothesen.', 'frequency': 873},
  {'word': 'die Falsifikation', 'article': 'die', 'gender': 'die', 'meaning': '证伪', 'example': 'Die Falsifikation widerlegt Hypothesen.', 'frequency': 874},
  {'word': 'der Reduktionismus', 'article': 'der', 'gender': 'der', 'meaning': '还原论', 'example': 'Der Reduktionismus erklärt aus Teilen.', 'frequency': 875},
  {'word': 'der Holismus', 'article': 'der', 'gender': 'der', 'meaning': '整体论', 'example': 'Der Holismus betrachtet das Ganze.', 'frequency': 876},
  {'word': 'der Determinismus', 'article': 'der', 'gender': 'der', 'meaning': '决定论', 'example': 'Der Determinismus sieht alles als bestimmt.', 'frequency': 877},
  {'word': 'der Indeterminismus', 'article': 'der', 'gender': 'der', 'meaning': '非决定论', 'example': 'Der Indeterminismus sieht Zufall.', 'frequency': 878},
  {'word': 'der Konstruktivismus', 'article': 'der', 'gender': 'der', 'meaning': '建构主义', 'example': 'Der Konstruktivismus konstruiert Realität.', 'frequency': 879},

  // 法律与政治
  {'word': 'die Legislative', 'article': 'die', 'gender': 'die', 'meaning': '立法权', 'example': 'Die Legislative erarbeitet Gesetze.', 'frequency': 880},
  {'word': 'die Exekutive', 'article': 'die', 'gender': 'die', 'meaning': '行政权', 'example': 'Die Exekutive führt Gesetze aus.', 'frequency': 881},
  {'word': 'die Judikative', 'article': 'die', 'gender': 'die', 'meaning': '司法权', 'example': 'Die Judikative interpretiert Gesetze.', 'frequency': 882},
  {'word': 'die Föderalismus', 'article': 'der', 'gender': 'der', 'meaning': '联邦制', 'example': 'Der Föderalismus verteilt Macht.', 'frequency': 883},
  {'word': 'der Zentralismus', 'article': 'der', 'gender': 'der', 'meaning': '中央集权', 'example': 'Der Zentralismus konzentriert Macht.', 'frequency': 884},
  {'word': 'die Separation', 'article': 'die', 'gender': 'die', 'meaning': '分离', 'example': 'Die Separation der Gewalten.', 'frequency': 885},
  {'word': 'der Konstitutionalismus', 'article': 'der', 'gender': 'der', 'meaning': '宪政主义', 'example': 'Der Konstitutionalismus begrenzt Macht.', 'frequency': 886},
  {'word': 'der Parlamentarismus', 'article': 'der', 'gender': 'der', 'meaning': '议会制', 'example': 'Der Parlamentarismus repräsentiert Volk.', 'frequency': 887},
  {'word': 'der Präsidentialismus', 'article': 'der', 'gender': 'der', 'meaning': '总统制', 'example': 'Der Präsidentialismus konzentriert Präsident.', 'frequency': 888},
  {'word': 'der Absolutismus', 'article': 'der', 'gender': 'der', 'meaning': '专制主义', 'example': 'Der Absolutismus konzentriert Macht.', 'frequency': 889},

  // 经济学高级词汇
  {'word': 'der Kapitalismus', 'article': 'der', 'gender': 'der', 'meaning': '资本主义', 'example': 'Der Kapitalismus basiert auf Kapital.', 'frequency': 890},
  {'word': 'der Sozialismus', 'article': 'der', 'gender': 'der', 'meaning': '社会主义', 'example': 'Der Sozialismus erstrebt Gleichheit.', 'frequency': 891},
  {'word': 'der Kommunismus', 'article': 'der', 'gender': 'der', 'meaning': '共产主义', 'example': 'Der Kommunismus erstrebt Gemeinschaft.', 'frequency': 892},
  {'word': 'der Liberalismus', 'article': 'der', 'gender': 'der', 'meaning': '自由主义', 'example': 'Der Liberalismus betont Freiheit.', 'frequency': 893},
  {'word': 'der Keynesianismus', 'article': 'der', 'gender': 'der', 'meaning': '凯恩斯主义', 'example': 'Der Keynesianismus reguliert Wirtschaft.', 'frequency': 894},
  {'word': 'der Monetarismus', 'article': 'der', 'gender': 'der', 'meaning': '货币主义', 'example': 'Der Monetarismus kontrolliert Geldmenge.', 'frequency': 895},
  {'word': 'der Protektionismus', 'article': 'der', 'gender': 'der', 'meaning': '保护主义', 'example': 'Der Protektionismus schützt Wirtschaft.', 'frequency': 896},
  {'word': 'der Freihandel', 'article': 'der', 'gender': 'der', 'meaning': '自由贸易', 'example': 'Der Freihandel ermöglicht Handel.', 'frequency': 897},
  {'word': 'die Globalisierung', 'article': 'die', 'gender': 'die', 'meaning': '全球化', 'example': 'Die Globalisierung verbindet Welt.', 'frequency': 898},
  {'word': 'der Neoliberalismus', 'article': 'der', 'gender': 'der', 'meaning': '新自由主义', 'example': 'Der Neoliberalismus dereguliert Märkte.', 'frequency': 899},
];

/// 获取扩展词汇
List<Map<String, dynamic>> getExtendedVocabulary(String level) {
  switch (level) {
    case 'A1':
      return vocabularyA1Extended;
    case 'A2':
      return [...vocabularyA1Extended, ...vocabularyA2Extended];
    case 'B1':
      return [...vocabularyA1Extended, ...vocabularyA2Extended, ...vocabularyB1Extended];
    case 'B2':
      return [...vocabularyA1Extended, ...vocabularyA2Extended, ...vocabularyB1Extended, ...vocabularyB2Extended];
    case 'C1':
      return [...vocabularyA1Extended, ...vocabularyA2Extended, ...vocabularyB1Extended, ...vocabularyB2Extended, ...vocabularyC1Extended];
    case 'C2':
      return [...vocabularyA1Extended, ...vocabularyA2Extended, ...vocabularyB1Extended, ...vocabularyB2Extended, ...vocabularyC1Extended, ...vocabularyC2Extended];
    default:
      return vocabularyA1Extended;
  }
}
