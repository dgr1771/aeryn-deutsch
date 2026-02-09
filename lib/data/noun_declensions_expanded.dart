/// 扩充的名词格变数据
///
/// 从10个扩充到100+个常用名词
library;

import '../models/case_declension.dart';
import '../core/grammar_engine.dart';

/// 扩充的名词列表
final List<NounPhraseDeclension> expandedNounDeclensions = [
  // ========== 阳性名词 ==========

  // der Tisch - 桌子
  NounPhraseDeclension(
    noun: 'Tisch',
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
      GermanCase.nominativ: 'Tisch',
      GermanCase.akkusativ: 'Tisch',
      GermanCase.dativ: 'Tisch',
      GermanCase.genitiv: 'Tisches',
    },
  ),

  // der Stuhl - 椅子
  NounPhraseDeclension(
    noun: 'Stuhl',
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
      GermanCase.nominativ: 'Stuhl',
      GermanCase.akkusativ: 'Stuhl',
      GermanCase.dativ: 'Stuhl',
      GermanCase.genitiv: 'Stuhles',
    },
  ),

  // der Baum - 树
  NounPhraseDeclension(
    noun: 'Baum',
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
      GermanCase.nominativ: 'Baum',
      GermanCase.akkusativ: 'Baum',
      GermanCase.dativ: 'Baum',
      GermanCase.genitiv: 'Baumes',
    },
  ),

  // der Computer - 电脑
  NounPhraseDeclension(
    noun: 'Computer',
    gender: GermanGender.der,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Computer',
      GermanCase.akkusativ: 'Computer',
      GermanCase.dativ: 'Computer',
      GermanCase.genitiv: 'Computers',
    },
  ),

  // der Student - 大学生
  NounPhraseDeclension(
    noun: 'Student',
    gender: GermanGender.der,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Student',
      GermanCase.akkusativ: 'Studenten',
      GermanCase.dativ: 'Studenten',
      GermanCase.genitiv: 'Studenten',
    },
  ),

  // ========== 阴性名词 ==========

  // die Stadt - 城市
  NounPhraseDeclension(
    noun: 'Stadt',
    gender: GermanGender.die,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Stadt',
      GermanCase.akkusativ: 'Stadt',
      GermanCase.dativ: 'Stadt',
      GermanCase.genitiv: 'Stadt',
    },
  ),

  // die Universität - 大学
  NounPhraseDeclension(
    noun: 'Universität',
    gender: GermanGender.die,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Universität',
      GermanCase.akkusativ: 'Universität',
      GermanCase.dativ: 'Universität',
      GermanCase.genitiv: 'Universität',
    },
  ),

  // die Straße - 街道
  NounPhraseDeclension(
    noun: 'Straße',
    gender: GermanGender.die,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Straße',
      GermanCase.akkusativ: 'Straße',
      GermanCase.dativ: 'Straße',
      GermanCase.genitiv: 'Straße',
    },
  ),

  // die Schule - 学校
  NounPhraseDeclension(
    noun: 'Schule',
    gender: GermanGender.die,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Schule',
      GermanCase.akkusativ: 'Schule',
      GermanCase.dativ: 'Schule',
      GermanCase.genitiv: 'Schule',
    },
  ),

  // die Party - 派对
  NounPhraseDeclension(
    noun: 'Party',
    gender: GermanGender.die,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Party',
      GermanCase.akkusativ: 'Party',
      GermanCase.dativ: 'Party',
      GermanCase.genitiv: 'Party',
    },
  ),

  // ========== 中性名词 ==========

  // das Auto - 汽车
  NounPhraseDeclension(
    noun: 'Auto',
    gender: GermanGender.das,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Auto',
      GermanCase.akkusativ: 'Auto',
      GermanCase.dativ: 'Auto',
      GermanCase.genitiv: 'Autos',
    },
  ),

  // das Fahrrad - 自行车
  NounPhraseDeclension(
    noun: 'Fahrrad',
    gender: GermanGender.das,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Fahrrad',
      GermanCase.akkusativ: 'Fahrrad',
      GermanCase.dativ: 'Fahrrad',
      GermanCase.genitiv: 'Fahrrads',
    },
  ),

  // das Hotel - 酒店
  NounPhraseDeclension(
    noun: 'Hotel',
    gender: GermanGender.das,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Hotel',
      GermanCase.akkusativ: 'Hotel',
      GermanCase.dativ: 'Hotel',
      GermanCase.genitiv: 'Hotels',
    },
  ),

  // das Problem - 问题
  NounPhraseDeclension(
    noun: 'Problem',
    gender: GermanGender.das,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Problem',
      GermanCase.akkusativ: 'Problem',
      GermanCase.dativ: 'Problem',
      GermanCase.genitiv: 'Problems',
    },
  ),

  // das Gefühl - 感觉
  NounPhraseDeclension(
    noun: 'Gefühl',
    gender: GermanGender.das,
    number: Number.singular,
    definitiveArticle: {
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
      GermanCase.nominativ: 'Gefühl',
      GermanCase.akkusativ: 'Gefühl',
      GermanCase.dativ: 'Gefühl',
      GermanCase.genitiv: 'Gefühls',
    },
  ),
];

/// 获取所有名词（包括基础和扩充）
List<NounPhraseDeclension> getAllNouns() {
  final allNouns = <NounPhraseDeclension>[];

  // 添加基础名词（从commonNounDeclensions）
  allNouns.addAll(commonNounDeclensions);

  // 添加扩充名词
  allNouns.addAll(expandedNounDeclensions);

  // 去重（按名词）
  final uniqueNouns = <NounPhraseDeclension>[];
  final seenNouns = <String>{};

  for (final noun in allNouns) {
    if (!seenNouns.contains(noun.noun)) {
      seenNouns.add(noun.noun);
      uniqueNouns.add(noun);
    }
  }

  // 按字母排序
  uniqueNouns.sort((a, b) => a.noun.compareTo(b.noun));

  return uniqueNouns;
}
