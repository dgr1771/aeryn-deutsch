/// A1级别基础词汇补充
///
/// 包含日常生活必备词汇：数字、颜色、家庭、食物、时间、天气等
library;

import '../core/grammar_engine.dart';

/// 数字 (0-100, 基础数字)
final List<Map<String, dynamic>> vocabularyA1Numbers = [
  {'word': 'null', 'article': null, 'gender': GermanGender.none, 'meaning': '零', 'example': 'Das kostet null Euro.', 'frequency': 150, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'eins', 'article': null, 'gender': GermanGender.none, 'meaning': '一', 'example': 'Ich habe eins.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'zwei', 'article': null, 'gender': GermanGender.none, 'meaning': '二', 'example': 'Ich habe zwei Katzen.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'drei', 'article': null, 'gender': GermanGender.none, 'meaning': '三', 'example': 'Drei Äpfel, bitte.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'vier', 'article': null, 'gender': GermanGender.none, 'meaning': '四', 'example': 'Vier Personen.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'fünf', 'article': null, 'gender': GermanGender.none, 'meaning': '五', 'example': 'Fünf Minuten.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'sechs', 'article': null, 'gender': GermanGender.none, 'meaning': '六', 'example': 'Sechs Stühlen.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'sieben', 'article': null, 'gender': GermanGender.none, 'meaning': '七', 'example': 'Sieben Tage.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'acht', 'article': null, 'gender': GermanGender.none, 'meaning': '八', 'example': 'Acht Uhr.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'neun', 'article': null, 'gender': GermanGender.none, 'meaning': '九', 'example': 'Neun Euro.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'zehn', 'article': null, 'gender': GermanGender.none, 'meaning': '十', 'example': 'Zehn Schüler.', 'frequency': 120, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'elf', 'article': null, 'gender': GermanGender.none, 'meaning': '十一', 'example': 'Es ist elf Uhr.', 'frequency': 100, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'zwölf', 'article': null, 'gender': GermanGender.none, 'meaning': '十二', 'example': 'Zwölf Monate.', 'frequency': 100, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'dreizehn', 'article': null, 'gender': GermanGender.none, 'meaning': '十三', 'example': 'Ich bin dreizehn Jahre alt.', 'frequency': 90, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'vierzehn', 'article': null, 'gender': GermanGender.none, 'meaning': '十四', 'example': 'Vierzehn Tage.', 'frequency': 90, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'fünfzehn', 'article': null, 'gender': GermanGender.none, 'meaning': '十五', 'example': 'Fünfzehn Euro.', 'frequency': 90, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'zwanzig', 'article': null, 'gender': GermanGender.none, 'meaning': '二十', 'example': 'Ich bin zwanzig Jahre alt.', 'frequency': 90, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'dreißig', 'article': null, 'gender': GermanGender.none, 'meaning': '三十', 'example': 'Dreißig Grad.', 'frequency': 90, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'vierzig', 'article': null, 'gender': GermanGender.none, 'meaning': '四十', 'example': 'Vierzig Schüler.', 'frequency': 80, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'fünfzig', 'article': null, 'gender': GermanGender.none, 'meaning': '五十', 'example': 'Fünfzig Euro.', 'frequency': 80, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'sechzig', 'article': null, 'gender': GermanGender.none, 'meaning': '六十', 'example': 'Mein Großvater ist sechzig.', 'frequency': 70, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'siebzig', 'article': null, 'gender': GermanGender.none, 'meaning': '七十', 'example': 'Siebzig Seiten.', 'frequency': 70, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'achtzig', 'article': null, 'gender': GermanGender.none, 'meaning': '八十', 'example': 'Achtzig Kilometer.', 'frequency': 70, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'neunzig', 'article': null, 'gender': GermanGender.none, 'meaning': '九十', 'example': 'Neunzig Minuten.', 'frequency': 70, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'hundert', 'article': null, 'gender': GermanGender.none, 'meaning': '一百', 'example': 'Hundert Euro.', 'frequency': 70, 'level': 'A1', 'category': 'Zahlen'},

  // 数量词
  {'word': 'die Zahl', 'article': 'die', 'gender': GermanGender.die, 'meaning': '数字', 'example': 'Wie viel ist diese Zahl?', 'frequency': 200, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'wie viel', 'article': null, 'gender': GermanGender.none, 'meaning': '多少', 'example': 'Wie viel kostet das?', 'frequency': 300, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'wie viele', 'article': null, 'gender': GermanGender.none, 'meaning': '多少（复数）', 'example': 'Wie viele Bücher hast du?', 'frequency': 280, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'alle', 'article': null, 'gender': GermanGender.none, 'meaning': '所有的', 'example': 'Alle Schüler sind hier.', 'frequency': 250, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'viele', 'article': null, 'gender': GermanGender.none, 'meaning': '许多', 'example': 'Viele Menschen.', 'frequency': 260, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'wenige', 'article': null, 'gender': GermanGender.none, 'meaning': '少数', 'example': 'Wenige Leute.', 'frequency': 220, 'level': 'A1', 'category': 'Zahlen'},
  {'word': 'kein', 'article': null, 'gender': GermanGender.none, 'meaning': '没有/没有一个', 'example': 'Ich habe kein Auto.', 'frequency': 300, 'level': 'A1', 'category': 'Zahlen'},
];

/// 颜色
final List<Map<String, dynamic>> vocabularyA1Colors = [
  {'word': 'rot', 'article': null, 'gender': GermanGender.none, 'meaning': '红色', 'example': 'Das Auto ist rot.', 'frequency': 200, 'level': 'A1', 'category': 'Farben'},
  {'word': 'blau', 'article': null, 'gender': GermanGender.none, 'meaning': '蓝色', 'example': 'Der Himmel ist blau.', 'frequency': 200, 'level': 'A1', 'category': 'Farben'},
  {'word': 'grün', 'article': null, 'gender': GermanGender.none, 'meaning': '绿色', 'example': 'Das Gras ist grün.', 'frequency': 190, 'level': 'A1', 'category': 'Farben'},
  {'word': 'gelb', 'article': null, 'gender': GermanGender.none, 'meaning': '黄色', 'example': 'Die Sonne ist gelb.', 'frequency': 180, 'level': 'A1', 'category': 'Farben'},
  {'word': 'schwarz', 'article': null, 'gender': GermanGender.none, 'meaning': '黑色', 'example': 'Das Auto ist schwarz.', 'frequency': 190, 'level': 'A1', 'category': 'Farben'},
  {'word': 'weiß', 'article': null, 'gender': GermanGender.none, 'meaning': '白色', 'example': 'Die Wand ist weiß.', 'frequency': 190, 'level': 'A1', 'category': 'Farben'},
  {'word': 'grau', 'article': null, 'gender': GermanGender.none, 'meaning': '灰色', 'example': 'Der Himmel ist grau.', 'frequency': 180, 'level': 'A1', 'category': 'Farben'},
  {'word': 'orange', 'article': null, 'gender': GermanGender.none, 'meaning': '橙色', 'example': 'Ich mag orange.', 'frequency': 170, 'level': 'A1', 'category': 'Farben'},
  {'word': 'rosa', 'article': null, 'gender': GermanGender.none, 'meaning': '粉色', 'example': 'Die Blume ist rosa.', 'frequency': 170, 'level': 'A1', 'category': 'Farben'},
  {'word': 'braun', 'article': null, 'gender': GermanGender.none, 'meaning': '棕色', 'example': 'Die Haare sind braun.', 'frequency': 180, 'level': 'A1', 'category': 'Farben'},
  {'word': 'lila', 'article': null, 'gender': GermanGender.none, 'meaning': '紫色', 'example': 'Das Kleid ist lila.', 'frequency': 160, 'level': 'A1', 'category': 'Farben'},
  {'word': 'bunt', 'article': null, 'gender': GermanGender.none, 'meaning': '多彩的', 'example': 'Das Bild ist bunt.', 'frequency': 170, 'level': 'A1', 'category': 'Farben'},
  {'word': 'hell', 'article': null, 'gender': GermanGender.none, 'meaning': '浅色的/明亮的', 'example': 'Das Zimmer ist hell.', 'frequency': 200, 'level': 'A1', 'category': 'Farben'},
  {'word': 'dunkel', 'article': null, 'gender': GermanGender.none, 'meaning': '深色的/暗的', 'example': 'Es ist dunkel.', 'frequency': 200, 'level': 'A1', 'category': 'Farben'},
  {'word': 'die Farbe', 'article': 'die', 'gender': GermanGender.die, 'meaning': '颜色', 'example': 'Was ist deine Lieblingsfarbe?', 'frequency': 210, 'level': 'A1', 'category': 'Farben'},
];

/// 家庭成员
final List<Map<String, dynamic>> vocabularyA1Family = [
  {'word': 'die Familie', 'article': 'die', 'gender': GermanGender.die, 'meaning': '家庭', 'example': 'Ich habe eine große Familie.', 'frequency': 220, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Vater', 'article': 'der', 'gender': GermanGender.der, 'meaning': '父亲', 'example': 'Mein Vater heißt Hans.', 'frequency': 210, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Mutter', 'article': 'die', 'gender': GermanGender.die, 'meaning': '母亲', 'example': 'Meine Mutter ist Lehrerin.', 'frequency': 210, 'level': 'A1', 'category': 'Familie'},
  {'word': 'das Kind', 'article': 'das', 'gender': GermanGender.das, 'meaning': '孩子', 'example': 'Das Kind spielt.', 'frequency': 230, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Kinder', 'article': 'die', 'gender': GermanGender.die, 'meaning': '孩子们', 'example': 'Die Kinder spielen im Garten.', 'frequency': 220, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Sohn', 'article': 'der', 'gender': GermanGender.der, 'meaning': '儿子', 'example': 'Er ist mein Sohn.', 'frequency': 200, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Tochter', 'article': 'die', 'gender': GermanGender.die, 'meaning': '女儿', 'example': 'Sie ist meine Tochter.', 'frequency': 200, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Bruder', 'article': 'der', 'gender': GermanGender.der, 'meaning': '兄弟', 'example': 'Ich habe einen Bruder.', 'frequency': 210, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Schwester', 'article': 'die', 'gender': GermanGender.die, 'meaning': '姐妹', 'example': 'Meine Schwester studiert.', 'frequency': 210, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Großvater', 'article': 'der', 'gender': GermanGender.der, 'meaning': '祖父/外祖父', 'example': 'Mein Großvater ist 80 Jahre alt.', 'frequency': 190, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Großmutter', 'article': 'die', 'gender': GermanGender.die, 'meaning': '祖母/外祖母', 'example': 'Meine Großmutter kocht gut.', 'frequency': 190, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Onkel', 'article': 'der', 'gender': GermanGender.der, 'meaning': '叔叔/舅舅/伯伯', 'example': 'Mein Onkel wohnt in Berlin.', 'frequency': 180, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Tante', 'article': 'die', 'gender': GermanGender.die, 'meaning': '阿姨/姑姑/婶婶', 'example': 'Meine Tante kommt aus München.', 'frequency': 180, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Cousin', 'article': 'der', 'gender': GermanGender.der, 'meaning': '堂/表兄弟', 'example': 'Mein Cousin heißt Thomas.', 'frequency': 170, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Cousine', 'article': 'die', 'gender': GermanGender.die, 'meaning': '堂/表姐妹', 'example': 'Meine Cousine studiert Medizin.', 'frequency': 170, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Eltern', 'article': 'die', 'gender': GermanGender.die, 'meaning': '父母', 'example': 'Meine Eltern leben in Hamburg.', 'frequency': 220, 'level': 'A1', 'category': 'Familie'},
  {'word': 'der Ehemann', 'article': 'der', 'gender': GermanGender.der, 'meaning': '丈夫', 'example': 'Das ist mein Ehemann.', 'frequency': 180, 'level': 'A1', 'category': 'Familie'},
  {'word': 'die Ehefrau', 'article': 'die', 'gender': GermanGender.die, 'meaning': '妻子', 'example': 'Sie ist meine Ehefrau.', 'frequency': 180, 'level': 'A1', 'category': 'Familie'},
];

/// 食物和饮料
final List<Map<String, dynamic>> vocabularyA1Food = [
  {'word': 'das Essen', 'article': 'das', 'gender': GermanGender.das, 'meaning': '食物/吃饭', 'example': 'Das Essen ist fertig.', 'frequency': 240, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Brot', 'article': 'das', 'gender': GermanGender.das, 'meaning': '面包', 'example': 'Ich möchte ein Brot.', 'frequency': 230, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Wasser', 'article': 'das', 'gender': GermanGender.das, 'meaning': '水', 'example': 'Ich trinke Wasser.', 'frequency': 240, 'level': 'A1', 'category': 'Essen'},
  {'word': 'die Milch', 'article': 'die', 'gender': GermanGender.die, 'meaning': '牛奶', 'example': 'Die Milch ist frisch.', 'frequency': 220, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Kaffee', 'article': 'der', 'gender': GermanGender.der, 'meaning': '咖啡', 'example': 'Ich trinke gerne Kaffee.', 'frequency': 230, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Tee', 'article': 'der', 'gender': GermanGender.der, 'meaning': '茶', 'example': 'Möchten Sie Tee?', 'frequency': 220, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Saft', 'article': 'der', 'gender': GermanGender.der, 'meaning': '果汁', 'example': 'Ich trinke Orangensaft.', 'frequency': 210, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Bier', 'article': 'das', 'gender': GermanGender.das, 'meaning': '啤酒', 'example': 'Ein Bier, bitte.', 'frequency': 210, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Wein', 'article': 'der', 'gender': GermanGender.der, 'meaning': '葡萄酒', 'example': 'Der Wein ist rot.', 'frequency': 200, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Fleisch', 'article': 'das', 'gender': GermanGender.das, 'meaning': '肉', 'example': 'Ich esse kein Fleisch.', 'frequency': 220, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Gemüse', 'article': 'das', 'gender': GermanGender.das, 'meaning': '蔬菜', 'example': 'Gemüse ist gesund.', 'frequency': 210, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Obst', 'article': 'das', 'gender': GermanGender.das, 'meaning': '水果', 'example': 'Ich esse gerne Obst.', 'frequency': 210, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Apfel', 'article': 'der', 'gender': GermanGender.der, 'meaning': '苹果', 'example': 'Der Apfel ist rot.', 'frequency': 200, 'level': 'A1', 'category': 'Essen'},
  {'word': 'die Banane', 'article': 'die', 'gender': GermanGender.die, 'meaning': '香蕉', 'example': 'Ich mag Bananen.', 'frequency': 200, 'level': 'A1', 'category': 'Essen'},
  {'word': 'die Tomate', 'article': 'die', 'gender': GermanGender.die, 'meaning': '番茄', 'example': 'Die Tomate ist rot.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'die Kartoffel', 'article': 'die', 'gender': GermanGender.die, 'meaning': '土豆', 'example': 'Kartoffeln sind beliebt.', 'frequency': 200, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Salat', 'article': 'der', 'gender': GermanGender.der, 'meaning': '沙拉', 'example': 'Ich nehme einen Salat.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Käse', 'article': 'der', 'gender': GermanGender.der, 'meaning': '奶酪', 'example': 'Deutscher Käse ist berühmt.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Ei', 'article': 'das', 'gender': GermanGender.das, 'meaning': '鸡蛋', 'example': 'Ich esse ein Ei zum Frühstück.', 'frequency': 200, 'level': 'A1', 'category': 'Essen'},
  {'word': 'die Suppe', 'article': 'die', 'gender': GermanGender.die, 'meaning': '汤', 'example': 'Die Suppe ist heiß.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Frühstück', 'article': 'das', 'gender': GermanGender.das, 'meaning': '早餐', 'example': 'Zum Frühstück esse ich Brot.', 'frequency': 200, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Mittagessen', 'article': 'das', 'gender': GermanGender.das, 'meaning': '午餐', 'example': 'Das Mittagessen ist um 12 Uhr.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'das Abendessen', 'article': 'das', 'gender': GermanGender.das, 'meaning': '晚餐', 'example': 'Wir essen Abendessen um 19 Uhr.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'essen', 'article': null, 'gender': GermanGender.none, 'meaning': '吃', 'example': 'Ich esse gern.', 'frequency': 300, 'level': 'A1', 'category': 'Essen'},
  {'word': 'trinken', 'article': null, 'gender': GermanGender.none, 'meaning': '喝', 'example': 'Was möchtest du trinken?', 'frequency': 280, 'level': 'A1', 'category': 'Essen'},
  {'word': 'kochen', 'article': null, 'gender': GermanGender.none, 'meaning': '烹饪', 'example': 'Ich koche gerne.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
  {'word': 'dürsten', 'article': null, 'gender': GermanGender.none, 'meaning': '口渴', 'example': 'Ich habe Durst.', 'frequency': 180, 'level': 'A1', 'category': 'Essen'},
  {'word': 'der Hunger', 'article': 'der', 'gender': GermanGender.der, 'meaning': '饥饿', 'example': 'Ich habe Hunger.', 'frequency': 190, 'level': 'A1', 'category': 'Essen'},
];

/// 时间表达
final List<Map<String, dynamic>> vocabularyA1Time = [
  {'word': 'die Zeit', 'article': 'die', 'gender': GermanGender.die, 'meaning': '时间', 'example': 'Wie spät ist es?', 'frequency': 250, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'jetzt', 'article': null, 'gender': GermanGender.none, 'meaning': '现在', 'example': 'Ich komme jetzt.', 'frequency': 280, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'später', 'article': null, 'gender': GermanGender.none, 'meaning': '后来', 'example': 'Später gehen wir.', 'frequency': 240, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'früher', 'article': null, 'gender': GermanGender.none, 'meaning': '以前', 'example': 'Früher wohnte ich in Berlin.', 'frequency': 230, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'heute', 'article': null, 'gender': GermanGender.none, 'meaning': '今天', 'example': 'Heute ist Montag.', 'frequency': 260, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'morgen', 'article': null, 'gender': GermanGender.none, 'meaning': '明天', 'example': 'Morgen komme ich.', 'frequency': 250, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'gestern', 'article': null, 'gender': GermanGender.none, 'meaning': '昨天', 'example': 'Gestern war ich krank.', 'frequency': 250, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'die Uhr', 'article': 'die', 'gender': GermanGender.die, 'meaning': '钟/小时', 'example': 'Es ist 8 Uhr.', 'frequency': 240, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'die Minute', 'article': 'die', 'gender': GermanGender.die, 'meaning': '分钟', 'example': 'Warten Sie fünf Minuten.', 'frequency': 220, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'die Stunde', 'article': 'die', 'gender': GermanGender.die, 'meaning': '小时', 'example': 'Eine Stunde hat 60 Minuten.', 'frequency': 210, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Tag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '天/白天', 'example': 'Guten Tag!', 'frequency': 260, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'die Woche', 'article': 'die', 'gender': GermanGender.die, 'meaning': '周', 'example': 'Eine Woche hat sieben Tage.', 'frequency': 230, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Monat', 'article': 'der', 'gender': GermanGender.der, 'meaning': '月', 'example': 'Der Monat ist Januar.', 'frequency': 220, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'das Jahr', 'article': 'das', 'gender': GermanGender.das, 'meaning': '年', 'example': 'Das Jahr hat 12 Monate.', 'frequency': 230, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Montag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期一', 'example': 'Montag fängt die Arbeit an.', 'frequency': 200, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Dienstag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期二', 'example': 'Dienstag habe ich Deutsch.', 'frequency': 190, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Mittwoch', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期三', 'example': 'Mittwoch ist Mittwoch.', 'frequency': 190, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Donnerstag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期四', 'example': 'Donnerstag gehe ich schwimmen.', 'frequency': 190, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Freitag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期五', 'example': 'Freitag ist Wochenende.', 'frequency': 190, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Samstag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期六', 'example': 'Samitaning einkaufen.', 'frequency': 190, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Sonntag', 'article': 'der', 'gender': GermanGender.der, 'meaning': '星期日', 'example': 'Sonntag ruhe ich mich aus.', 'frequency': 190, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Januar', 'article': 'der', 'gender': GermanGender.der, 'meaning': '一月', 'example': 'Januar ist kalt.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Februar', 'article': 'der', 'gender': GermanGender.der, 'meaning': '二月', 'example': 'Februar hat 28 Tage.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der März', 'article': 'der', 'gender': GermanGender.der, 'meaning': '三月', 'example': 'März beginnt der Frühling.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der April', 'article': 'der', 'gender': GermanGender.der, 'meaning': '四月', 'example': 'April ist schön.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Mai', 'article': 'der', 'gender': GermanGender.der, 'meaning': '五月', 'example': 'Mai ist warm.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Juni', 'article': 'der', 'gender': GermanGender.der, 'meaning': '六月', 'example': 'Juni beginnt der Sommer.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Juli', 'article': 'der', 'gender': GermanGender.der, 'meaning': '七月', 'example': 'Juli ist sehr heiß.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der August', 'article': 'der', 'gender': GermanGender.der, 'meaning': '八月', 'example': 'August ist urlaubszeit.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der September', 'article': 'der', 'gender': GermanGender.der, 'meaning': '九月', 'example': 'September beginnt die Schule.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Oktober', 'article': 'der', 'gender': GermanGender.der, 'meaning': '十月', 'example': 'Oktober ist Herbst.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der November', 'article': 'der', 'gender': GermanGender.der, 'meaning': '十一月', 'example': 'November ist kalt.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
  {'word': 'der Dezember', 'article': 'der', 'gender': GermanGender.der, 'meaning': '十二月', 'example': 'Dezember ist Weihnachten.', 'frequency': 180, 'level': 'A1', 'category': 'Zeit'},
];

/// 天气
final List<Map<String, dynamic>> vocabularyA1Weather = [
  {'word': 'das Wetter', 'article': 'das', 'gender': GermanGender.das, 'meaning': '天气', 'example': 'Wie ist das Wetter?', 'frequency': 240, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'sonnig', 'article': null, 'gender': GermanGender.none, 'meaning': '晴朗的', 'example': 'Heute ist sonnig.', 'frequency': 210, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'warm', 'article': null, 'gender': GermanGender.none, 'meaning': '温暖的', 'example': 'Es ist warm heute.', 'frequency': 220, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'heiß', 'article': null, 'gender': GermanGender.none, 'meaning': '热的', 'example': 'Im Sommer ist es heiß.', 'frequency': 210, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'kalt', 'article': null, 'gender': GermanGender.none, 'meaning': '冷的', 'example': 'Im Winter ist es kalt.', 'frequency': 210, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'regnerisch', 'article': null, 'gender': GermanGender.none, 'meaning': '下雨的', 'example': 'Es ist regnerisch.', 'frequency': 200, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'bewölkt', 'article': null, 'gender': GermanGender.none, 'meaning': '多云的', 'example': 'Der Himmel ist bewölkt.', 'frequency': 190, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'windig', 'article': null, 'gender': GermanGender.none, 'meaning': '有风的', 'example': 'Es ist windig heute.', 'frequency': 180, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'die Sonne', 'article': 'die', 'gender': GermanGender.die, 'meaning': '太阳', 'example': 'Die Sonne scheint.', 'frequency': 210, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'der Regen', 'article': 'der', 'gender': GermanGender.der, 'meaning': '雨', 'example': 'Der Regen fällt.', 'frequency': 200, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'der Schnee', 'article': 'der', 'gender': GermanGender.der, 'meaning': '雪', 'example': 'Der Schnee ist weiß.', 'frequency': 200, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'der Wind', 'article': 'der', 'gender': GermanGender.der, 'meaning': '风', 'example': 'Der Wind weht.', 'frequency': 190, 'level': 'A1', 'category': 'Wetter'},
  {'word': 'die Wolke', 'article': 'die', 'gender': GermanGender.die, 'meaning': '云', 'example': 'Die Wolke ist groß.', 'frequency': 180, 'level': 'A1', 'category': 'Wetter'},
];

/// 房屋和房间
final List<Map<String, dynamic>> vocabularyA1House = [
  {'word': 'das Haus', 'article': 'das', 'gender': GermanGender.das, 'meaning': '房子', 'example': 'Das ist mein Haus.', 'frequency': 230, 'level': 'A1', 'category': 'Haus'},
  {'word': 'die Wohnung', 'article': 'die', 'gender': GermanGender.die, 'meaning': '公寓', 'example': 'Ich wohne in einer Wohnung.', 'frequency': 220, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Zimmer', 'article': 'das', 'gender': GermanGender.das, 'meaning': '房间', 'example': 'Mein Zimmer ist groß.', 'frequency': 230, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Schlafzimmer', 'article': 'das', 'gender': GermanGender.das, 'meaning': '卧室', 'example': 'Ich schlafe im Schlafzimmer.', 'frequency': 200, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Wohnzimmer', 'article': 'das', 'gender': GermanGender.das, 'meaning': '客厅', 'example': 'Das Wohnzimmer ist gemütlich.', 'frequency': 200, 'level': 'A1', 'category': 'Haus'},
  {'word': 'die Küche', 'article': 'die', 'gender': GermanGender.die, 'meaning': '厨房', 'example': 'In der Küche koche ich.', 'frequency': 200, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Bad', 'article': 'das', 'gender': GermanGender.das, 'meaning': '浴室', 'example': 'Das Bad ist sauber.', 'frequency': 200, 'level': 'A1', 'category': 'Haus'},
  {'word': 'der Tisch', 'article': 'der', 'gender': GermanGender.der, 'meaning': '桌子', 'example': 'Der Tisch ist aus Holz.', 'frequency': 220, 'level': 'A1', 'category': 'Haus'},
  {'word': 'der Stuhl', 'article': 'der', 'gender': GermanGender.der, 'meaning': '椅子', 'example': 'Ich sitze auf dem Stuhl.', 'frequency': 210, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Bett', 'article': 'das', 'gender': GermanGender.das, 'meaning': '床', 'example': 'Das Bett ist bequem.', 'frequency': 210, 'level': 'A1', 'category': 'Haus'},
  {'word': 'der Schreibtisch', 'article': 'der', 'gender': GermanGender.der, 'meaning': '书桌', 'example': 'Am Schreibtisch lerne ich.', 'frequency': 190, 'level': 'A1', 'category': 'Haus'},
  {'word': 'der Sessel', 'article': 'der', 'gender': GermanGender.der, 'meaning': '沙发椅', 'example': 'Ich sitze im Sessel.', 'frequency': 180, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Sofa', 'article': 'das', 'gender': GermanGender.das, 'meaning': '沙发', 'example': 'Das Sofa ist bequem.', 'frequency': 190, 'level': 'A1', 'category': 'Haus'},
  {'word': 'der Teppich', 'article': 'der', 'gender': GermanGender.der, 'meaning': '地毯', 'example': 'Der Teppich ist rot.', 'frequency': 180, 'level': 'A1', 'category': 'Haus'},
  {'word': 'das Fenster', 'article': 'das', 'gender': GermanGender.das, 'meaning': '窗户', 'example': 'Das Fenster ist offen.', 'frequency': 210, 'level': 'A1', 'category': 'Haus'},
  {'word': 'die Tür', 'article': 'die', 'gender': GermanGender.die, 'meaning': '门', 'example': 'Die Tür ist zu.', 'frequency': 210, 'level': 'A1', 'category': 'Haus'},
  {'word': 'die Lampe', 'article': 'die', 'gender': GermanGender.die, 'meaning': '灯', 'example': 'Die Lampe ist an.', 'frequency': 200, 'level': 'A1', 'category': 'Haus'},
  {'word': 'der Boden', 'article': 'der', 'gender': GermanGender.der, 'meaning': '地板', 'example': 'Der Boden ist sauber.', 'frequency': 190, 'level': 'A1', 'category': 'Haus'},
  {'word': 'die Decke', 'article': 'die', 'gender': GermanGender.die, 'meaning': '天花板', 'example': 'Die Decke ist weiß.', 'frequency': 180, 'level': 'A1', 'category': 'Haus'},
];

/// 基础形容词
final List<Map<String, dynamic>> vocabularyA1Adjectives = [
  {'word': 'groß', 'article': null, 'gender': GermanGender.none, 'meaning': '大的/高的', 'example': 'Das Haus ist groß.', 'frequency': 260, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'klein', 'article': null, 'gender': GermanGender.none, 'meaning': '小的', 'example': 'Das Zimmer ist klein.', 'frequency': 260, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'gut', 'article': null, 'gender': GermanGender.none, 'meaning': '好的', 'example': 'Das Essen ist gut.', 'frequency': 280, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'schlecht', 'article': null, 'gender': GermanGender.none, 'meaning': '坏的', 'example': 'Das Wetter ist schlecht.', 'frequency': 240, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'schön', 'article': null, 'gender': GermanGender.none, 'meaning': '美丽的', 'example': 'Du bist schön.', 'frequency': 270, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'hässlich', 'article': null, 'gender': GermanGender.none, 'meaning': '丑的', 'example': 'Das ist hässlich.', 'frequency': 210, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'neu', 'article': null, 'gender': GermanGender.none, 'meaning': '新的', 'example': 'Ich habe ein neues Auto.', 'frequency': 250, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'alt', 'article': null, 'gender': GermanGender.none, 'meaning': '旧的/老的', 'example': 'Das ist ein altes Haus.', 'frequency': 250, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'jung', 'article': null, 'gender': GermanGender.none, 'meaning': '年轻的', 'example': 'Er ist jung.', 'frequency': 240, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'lang', 'article': null, 'gender': GermanGender.none, 'meaning': '长的', 'example': 'Der Weg ist lang.', 'frequency': 230, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'kurz', 'article': null, 'gender': GermanGender.none, 'meaning': '短的', 'example': 'Der Film ist kurz.', 'frequency': 230, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'hoch', 'article': null, 'gender': GermanGender.none, 'meaning': '高的', 'example': 'Das Gebäude ist hoch.', 'frequency': 230, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'niedrig', 'article': null, 'gender': GermanGender.none, 'meaning': '低的', 'example': 'Der Preis ist niedrig.', 'frequency': 220, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'teuer', 'article': null, 'gender': GermanGender.none, 'meaning': '贵的', 'example': 'Das ist teuer.', 'frequency': 230, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'billig', 'article': null, 'gender': GermanGender.none, 'meaning': '便宜的', 'example': 'Das ist billig.', 'frequency': 230, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'stark', 'article': null, 'gender': GermanGender.none, 'meaning': '强壮的', 'example': 'Er ist stark.', 'frequency': 230, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'schwach', 'article': null, 'gender': GermanGender.none, 'meaning': '弱的', 'example': 'Ich bin schwach.', 'frequency': 220, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'schnell', 'article': null, 'gender': GermanGender.none, 'meaning': '快的', 'example': 'Das Auto ist schnell.', 'frequency': 250, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'langsam', 'article': null, 'gender': GermanGender.none, 'meaning': '慢的', 'example': 'Der Bus ist langsam.', 'frequency': 240, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'richtig', 'article': null, 'gender': GermanGender.none, 'meaning': '正确的', 'example': 'Das ist richtig.', 'frequency': 250, 'level': 'A1', 'category': 'Adjektive'},
  {'word': 'falsch', 'article': null, 'gender': GermanGender.none, 'meaning': '错误的', 'example': 'Das ist falsch.', 'frequency': 240, 'level': 'A1', 'category': 'Adjektive'},
];

/// 动物
final List<Map<String, dynamic>> vocabularyA1Animals = [
  {'word': 'das Tier', 'article': 'das', 'gender': GermanGender.das, 'meaning': '动物', 'example': 'Ich mag Tiere.', 'frequency': 210, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'der Hund', 'article': 'der', 'gender': GermanGender.der, 'meaning': '狗', 'example': 'Der Hund bellt.', 'frequency': 230, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'die Katze', 'article': 'die', 'gender': GermanGender.die, 'meaning': '猫', 'example': 'Die Katze schläft.', 'frequency': 230, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'der Vogel', 'article': 'der', 'gender': GermanGender.der, 'meaning': '鸟', 'example': 'Der Vogel singt.', 'frequency': 210, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'das Pferd', 'article': 'das', 'gender': GermanGender.das, 'meaning': '马', 'example': 'Das Pferd läuft.', 'frequency': 200, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'die Kuh', 'article': 'die', 'gender': GermanGender.die, 'meaning': '牛', 'example': 'Die Kuh gibt Milch.', 'frequency': 190, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'das Schwein', 'article': 'das', 'gender': GermanGender.das, 'meaning': '猪', 'example': 'Das Schwein ist groß.', 'frequency': 180, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'der Fisch', 'article': 'der', 'gender': GermanGender.der, 'meaning': '鱼', 'example': 'Der Fisch schwimmt.', 'frequency': 200, 'level': 'A1', 'category': 'Tiere'},
  {'word': 'die Maus', 'article': 'die', 'gender': GermanGender.die, 'meaning': '老鼠', 'example': 'Die Maus ist klein.', 'frequency': 190, 'level': 'A1', 'category': 'Tiere'},
];

/// 身体部位
final List<Map<String, dynamic>> vocabularyA1Body = [
  {'word': 'der Körper', 'article': 'der', 'gender': GermanGender.der, 'meaning': '身体', 'example': 'Mein Körper ist gesund.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'der Kopf', 'article': 'der', 'gender': GermanGender.der, 'meaning': '头', 'example': 'Mein Kopf tut weh.', 'frequency': 210, 'level': 'A1', 'category': 'Körper'},
  {'word': 'das Gesicht', 'article': 'das', 'gender': GermanGender.das, 'meaning': '脸', 'example': 'Das Gesicht ist schön.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'das Auge', 'article': 'das', 'gender': GermanGender.das, 'meaning': '眼睛', 'example': 'Die Augen sind blau.', 'frequency': 210, 'level': 'A1', 'category': 'Körper'},
  {'word': 'die Nase', 'article': 'die', 'gender': GermanGender.die, 'meaning': '鼻子', 'example': 'Meine Nase ist klein.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'der Mund', 'article': 'der', 'gender': GermanGender.der, 'meaning': '嘴', 'example': 'Ich öffne den Mund.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'das Ohr', 'article': 'das', 'gender': GermanGender.das, 'meaning': '耳朵', 'example': 'Das Ohr hört gut.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'das Haar', 'article': 'das', 'gender': GermanGender.das, 'meaning': '头发', 'example': 'Die Haare sind braun.', 'frequency': 210, 'level': 'A1', 'category': 'Körper'},
  {'word': 'die Hand', 'article': 'die', 'gender': GermanGender.die, 'meaning': '手', 'example': 'Ich wasche meine Hände.', 'frequency': 220, 'level': 'A1', 'category': 'Körper'},
  {'word': 'der Arm', 'article': 'der', 'gender': GermanGender.der, 'meaning': '手臂', 'example': 'Mein Arm tut weh.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'das Bein', 'article': 'das', 'gender': GermanGender.das, 'meaning': '腿', 'example': 'Ich habe lange Beine.', 'frequency': 210, 'level': 'A1', 'category': 'Körper'},
  {'word': 'der Fuß', 'article': 'der', 'gender': GermanGender.der, 'meaning': '脚', 'example': 'Mein Fuß ist groß.', 'frequency': 200, 'level': 'A1', 'category': 'Körper'},
  {'word': 'das Herz', 'article': 'das', 'gender': GermanGender.das, 'meaning': '心脏', 'example': 'Mein Herz schlägt.', 'frequency': 190, 'level': 'A1', 'category': 'Körper'},
];

/// 合并所有A1基础词汇
final List<Map<String, dynamic>> vocabularyA1EssentialsAll = [
  ...vocabularyA1Numbers,
  ...vocabularyA1Colors,
  ...vocabularyA1Family,
  ...vocabularyA1Food,
  ...vocabularyA1Time,
  ...vocabularyA1Weather,
  ...vocabularyA1House,
  ...vocabularyA1Adjectives,
  ...vocabularyA1Animals,
  ...vocabularyA1Body,
];
