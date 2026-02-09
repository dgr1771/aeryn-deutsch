/// 扩充的形容词数据
///
/// 从20个扩充到100+个常用形容词
library;

/// 扩充的形容词列表（按字母排序）
final List<Map<String, dynamic>> expandedAdjectives = [
  // A
  {'word': 'alt', 'meaning': '老的', 'opposite': 'jung', 'example': 'Der Mann ist alt.'},
  {'word': 'attraktiv', 'meaning': '积极的', 'opposite': 'passiv', 'example': 'Er ist sehr aktiv.'},
  {'word': 'arm', 'meaning': '穷的', 'opposite': 'reich', 'example': 'Die Familie ist arm.'},
  {'word': 'ärgerlich', 'meaning': '严肃的', 'opposite': 'locker', 'example': 'Er ist sehr ärgerlich.'},

  // B
  {'word': 'beliebt', 'meaning': '受欢迎的', 'opposite': 'unbeliebt', 'example': 'Das Buch ist beliebt.'},
  {'word': 'berühmt', 'meaning': '著名的', 'opposite': 'unbekannt', 'example': 'Er ist ein berühmter Sänger.'},
  {'word': 'billig', 'meaning': '便宜的', 'opposite': 'teuer', 'example': 'Das Auto ist billig.'},
  {'word': 'bunt', 'meaning': '多彩的', 'opposite': 'einfarbig', 'example': 'Das Bild ist bunt.'},
  {'word': 'busy', 'meaning': '忙碌的', 'opposite': 'frei', 'example': 'Ich bin sehr beschäftigt.'},

  // C
  {'word': 'calm', 'meaning': '冷静的', 'opposite': 'nervös', 'example': 'Bleib ruhig!'},
  {'word': 'clever', 'meaning': '聪明的', 'opposite': 'dumm', 'example': 'Das Kind ist sehr clever.'},
  {'word': 'cold', 'meaning': '冷的', 'opposite': 'warm', 'example': 'Es ist sehr kalt.'},
  {'word': 'comfortable', 'meaning': '舒适的', 'opposite': 'uncomfortable', 'example': 'Das Sofa ist bequem.'},

  // D
  {'word': 'dumm', 'meaning': '笨的', 'opposite': 'schlau', 'example': 'Das war keine dumme Frage.'},
  {'word': 'dunkel', 'meaning': '黑暗的', 'opposite': 'hell', 'example': 'Es ist dunkel im Raum.'},
  {'word': 'durstig', 'meaning': '渴的', 'opposite': 'durstm', 'example': 'Ich bin durstig.'},
  {'word': 'dynamisch', 'meaning': '有活力的', 'opposite': 'statisch', 'example': 'Er ist ein dynamischer Lehrer.'},

  // E
  {'word': 'einfach', 'meaning': '简单的', 'opposite': 'schwierig', 'example': 'Die Aufgabe ist einfach.'},
  {'word': 'einzig', 'meaning': '唯一的', 'opposite': 'viele', 'example': 'Ich habe das einzige Ticket.'},
  {'word': 'elektrisch', 'meaning': '电的', 'opposite': 'manuell', 'example': 'Das ist ein elektrisches Gerät.'},
  {'word': 'emotionale', 'meaning': '情感的', 'opposite': 'rational', 'example': 'Sie ist eine emotionale Person.'},
  {'word': 'enthousiast', 'meaning': '热情的', 'opposite': 'gleichgültig', 'example': 'Sie arbeitet begeistigt.'},

  // F
  {'word': 'falsch', 'meaning': '错误的', 'opposite': 'richtig', 'example': 'Die Antwort ist falsch.'},
  {'word': 'fantastisch', 'meaning': '极好的', 'opposite': 'schlecht', 'example': 'Das ist fantastisch!'},
  {'word': 'fertig', 'meaning': '完成的', 'opposite': 'unfertig', 'example': 'Das Haus ist fertig.'},
  {'word': 'fleißig', 'meaning': '勤奋的', 'opposite': 'faul', 'example': 'Er ist ein fleißiger Schüler.'},
  {'word': 'frei', 'meaning': '自由的', 'opposite': 'beschäftigt', 'example': 'Ich bin heute frei.'},
  {'word': 'fröhlich', 'meaning': '高兴的', 'opposite': 'traurig', 'example': 'Sie ist fröhlich.'},

  // G
  {'word': 'gefährlich', 'meaning': '危险的', 'opposite': 'sicher', 'example': 'Das ist gefährlich.'},
  {'word': 'genug', 'meaning': '足够的', 'opposite': 'zu wenig', 'example': 'Das ist genug.'},
  {'word': 'gesund', 'meaning': '健康的', 'opposite': 'krank', 'example': 'Ich bin gesund.'},
  {'word': 'groß', 'meaning': '大的', 'opposite': 'klein', 'example': 'Das ist ein großes Haus.'},
  {'word': 'gut', 'meaning': '好的', 'opposite': 'schlecht', 'example': 'Das ist eine gute Idee.'},
  {'word': 'günstig', 'meaning': '优惠的', 'opposite': 'teuer', 'example': 'Der Preis ist günstig.'},

  // H
  {'word': 'hart', 'meaning': '困难的', 'opposite': 'leicht', 'example': 'Das war eine harte Aufgabe.'},
  {'word': 'haupt', 'meaning': '主要的', 'opposite': 'nebensächlich', 'example': 'Das ist das Hauptproblem.'},
  {'word': 'heimlich', 'meaning': '熟悉的', 'opposite': 'fremd', 'example': 'Das Gesicht wirkt vertraut.'},
  {'word': 'heiß', 'meaning': '热的', 'opposite': 'kalt', 'example': 'Es ist heute sehr heiß.'},
  {'word': 'hilfsbereit', 'meaning': '乐于助人的', 'opposite': 'egoistisch', 'example': 'Er ist sehr hilfsbereit.'},
  {'word': 'höflich', 'meaning': '礼貌的', 'opposite': 'unhöflich', 'example': 'Seien Sie so höflich!'},

  // I
  {'word': 'ideal', 'meaning': '理想的', 'opposite': 'schlecht', 'example': 'Das ist ideal.'},
  {'word': 'imaginär', 'meaning': '想象的', 'opposite': 'real', 'example': 'Das ist nur imaginär.'},
  {'word': 'interessant', 'meaning': '有趣的', 'opposite': 'langweilig', 'example': 'Das Buch ist sehr interessant.'},
  {'word': 'international', 'meaning': '国际的', 'opposite': 'national', 'example': 'Das ist eine internationale Konferenz.'},
  {'word': 'important', 'meaning': '重要的', 'opposite': 'unwichtig', 'example': 'Das ist sehr wichtig.'},

  // J
  {'word': 'jung', 'meaning': '年轻的', 'opposite': 'alt', 'example': 'Er ist noch jung.'},
  {'word': 'joyful', 'meaning': '快乐的', 'opposite': 'traurig', 'example': 'Sie ist eine fröhliche Person.'},

  // K
  {'word': 'kaputt', 'meaning': '坏了的', 'opposite': 'intakt', 'example': 'Mein Auto ist kaputt.'},
  {'word': 'kurz', 'meaning': '短的', 'opposite': 'lang', 'example': 'Der Weg ist kurz.'},
  {'word': 'kritisch', 'meaning': '关键的', 'opposite': 'unwichtig', 'example': 'Das ist eine kritische Situation.'},

  // L
  {'word': 'lang', 'meaning': '长的', 'opposite': 'kurz', 'example': 'Der Film war zu lang.'},
  {'word': 'langsam', 'meaning': '缓慢的', 'opposite': 'schnell', 'example': 'Er spricht zu langsam.'},
  {'word': 'legal', 'meaning': '合法的', 'opposite': 'illegal', 'example': 'Das ist legal.'},
  {'word': 'leicht', 'meaning': '容易的', 'opposite': 'schwer', 'example': 'Die Prüfung war leicht.'},
  {'word': 'lieb', 'meaning': '亲爱的', 'opposite': 'hässlich', 'example': 'Das ist ein liebes Kind.'},
  {'word': 'logisch', 'meaning': '逻辑的', 'opposite': 'unlogisch', 'example': 'Das ist logisch.'},
  {'word': 'laut', 'meaning': '大声的', 'opposite': 'leise', 'example': 'Sprich bitte lauter!'},

  // M
  {'word': 'modern', 'meaning': '现代的', 'opposite': 'altmodisch', 'example': 'Die Wohnung ist modern.'},
  {'word': 'möglich', 'meaning': '可能的', 'opposite': 'unmöglich', 'example': 'Das ist möglich.'},
  {'word': 'motiviert', 'meaning': '有动力的', 'opposite': 'demotiviert', 'example': 'Er ist sehr motiviert.'},
  {'word': 'müde', 'meaning': '累的', 'opposite': 'ausgeruht', 'example': 'Ich bin müde.'},
  {'word': 'musikalisch', 'meaning': '有音乐天赋的', 'opposite': 'unmusikalisch', 'example': 'Sie ist musikalisch.'},

  // N
  {'word': 'negativ', 'meaning': '消极的', 'opposite': 'positiv', 'example': 'Er hat eine negative Einstellung.'},
  {'word': 'neu', 'meaning': '新的', 'opposite': 'alt', 'example': 'Das ist ein neues Auto.'},
  {'word': 'neutral', 'meaning': '中立的', 'opposite': 'parteiisch', 'example': 'Er ist neutral.'},
  {'word': 'normal', 'meaning': '正常的', 'opposite': 'anormal', 'example': 'Das ist ganz normal.'},
  {'word': 'notwendig', 'meaning': '必要的', 'opposite': 'unnötig', 'example': 'Das ist notwendig.'},
  {'word': 'nummerisch', 'meaning': '数字的', 'opposite': 'mündlich', 'example': 'Er ist gut in Mathe.'},

  // O
  {'word': 'optimistisch', 'meaning': '乐观的', 'opposite': 'pessimistisch', 'example': 'Sie ist optimistisch.'},
  {'word': 'originell', 'meaning': '原始的', 'opposite': 'modern', 'example': 'Das ist die originale Form.'},

  // P
  {'word': 'passiv', 'meaning': '被动的', 'opposite': 'aktiv', 'example': 'Er ist passiv.'},
  {'word': 'perfekt', 'meaning': '完美的', 'opposite': 'unvollständig', 'example': 'Das ist perfekt.'},
  {'word': 'persönlich', 'meaning': '个人的', 'opposite': 'impersönlich', 'example': 'Das ist meine persönliche Meinung.'},
  {'word': 'positiv', 'meaning': '积极的', 'opposite': 'negativ', 'example': 'Sei positiv!'},
  {'word': 'praktisch', 'meaning': '实用的', 'opposite': 'theoretisch', 'example': 'Das ist sehr praktisch.'},
  {'word': 'privat', 'meaning': '私人的', 'opposite': 'öffentlich', 'example': 'Das ist privat.'},
  {'word': 'professionell', 'meaning': '专业的', 'opposite': 'amateurhaft', 'example': 'Er arbeitet professionell.'},
  {'word': 'pünktlich', 'meaning': '准时的', 'opposite': 'verspätet', 'example': 'Er ist immer pünktlich.'},

  // Q
  {'word': 'qualitativ', 'meaning': '质的', 'opposite': 'quantitativ', 'example': 'Das ist eine qualitative Verbesserung.'},
  {'word': 'quengend', 'meaning': '拥挤的', 'opposite': 'leer', 'example': 'Der Zug ist überfüllt.'},

  // R
  {'word': 'realistisch', 'meaning': '现实的', 'opposite': 'irreal', 'example': 'Das ist sehr realistisch.'},
  {'word': 'relevant', 'meaning': '相关的', 'opposite': 'irrelevant', 'example': 'Das ist sehr relevant.'},
  {'word': 'riskant', 'meaning': '有风险的', 'opposite': 'sicher', 'example': 'Das ist riskant.'},
  {'word': 'ruhig', 'meaning': '安静的', 'opposite': 'laut', 'example': 'Sei bitte ruhig!'},

  // S
  {'word': 'sicher', 'meaning': '安全的', 'opposite': 'gefährlich', 'example': 'Ich fühle mich sicher.'},
  {'word': 'schön', 'meaning': '美丽的', 'opposite': 'hässlich', 'example': 'Das ist ein schöner Tag.'},
  {'word': 'schnell', 'meaning': '快的', 'opposite': 'langsam', 'example': 'Er ist schnell.'},
  {'word': 'schwer', 'meaning': '困难的', 'opposite': 'leicht', 'example': 'Das ist schwer.'},
  {'word': 'stabil', 'meaning': '稳定的', 'opposite': 'instabil', 'example': 'Die Wirtschaft ist stabil.'},
  {'word': 'stark', 'meaning': '强壮的', 'opposite': 'schwach', 'example': 'Er ist körperlich stark.'},
  {'word': 'stressig', 'meaning': '紧张的', 'opposite': 'entspannt', 'example': 'Die Situation ist stressig.'},
  {'word': 'streng', 'meaning': '严格的', 'opposite': 'locker', 'example': 'Der Lehrer ist streng.'},
  {'word': 'studiert', 'meaning': '有学问的', 'opposite': 'ungebildet', 'example': 'Er wirkt studiert.'},
  {'word': 'successful', 'meaning': '成功的', 'opposite': 'erfolglos', 'example': 'Das war erfolgreich.'},

  // T
  {'word': 'taktvoll', 'meaning': '机智的', 'opposite': 'taktlos', 'example': 'Er ist taktvoll.'},
  {'word': 'teuer', 'meaning': '贵的', 'opposite': 'billig', 'example': 'Das Auto ist teuer.'},
  {'word': 'tief', 'meaning': '深的', 'opposite': 'flach', 'example': 'Das Wasser ist tief.'},
  {'word': 'tolerant', 'meaning': '宽容的', 'opposite': 'intolerant', 'example': 'Sei tolerant!'},
  {'word': 'traditionell', 'meaning': '传统的', 'opposite': 'modern', 'example': 'Das ist traditionell.'},
  {'word': 'typisch', 'meaning': '典型的', 'opposite': 'untypisch', 'example': 'Das ist typisch deutsch.'},
  {'word': 'täglich', 'meaning': '每天的', 'opposite': 'selten', 'example': 'Das ist mein täglicher Breakfast.'},

  // U
  {'word': 'üblich', 'meaning': '通常的', 'opposite': 'ungewöhnlich', 'example': 'Das ist üblich.'},
  {'word': 'überfüllt', 'meaning': '拥挤的', 'opposite': 'leer', 'example': 'Der Bus ist überfüllt.'},
  {'word': 'umfangreich', 'meaning': '大量的', 'opposite': 'gering', 'example': 'Das ist umfangreich.'},

  // V
  {'word': 'various', 'meaning': '各种各样的', 'opposite': 'einförmig', 'example': 'Es gibt verschiedene Möglichkeiten.'},
  {'word': 'verantwortlich', 'meaning': '负责任的', 'opposite': 'unverantwortlich', 'example': 'Er ist verantwortungsbewusst.'},
  {'word': 'verwandt', 'meaning': '相关的', 'opposite': 'unverwandt', 'example': 'Das ist verwandt.'},
  {'word': 'vollständig', 'meaning': '完整的', 'opposite': 'unvollständig', 'example': 'Das ist vollständig.'},
  {'word': 'vorbereit', 'meaning': '准备的', 'opposite': 'unvorbereit', 'example': 'Alles ist vorbereitet.'},

  // W
  {'word': 'wahr', 'meaning': '真实的', 'opposite': 'falsch', 'example': 'Das ist wahr.'},
  {'word': 'wichtig', 'meaning': '重要的', 'opposite': 'unwichtig', 'example': 'Das ist sehr wichtig.'},
  {'word': 'wissenschaftlich', 'meaning': '科学的', 'opposite': 'unwissenschaftlich', 'example': 'Das ist wissenschaftlich fundiert.'},
  {'word': 'wunderschön', 'meaning': '非常美的', 'opposite': 'hässlich', 'example': 'Das ist wunderschön!'},
  {'word': 'wütend', 'meaning': '生气的', 'opposite': 'zufrieden', 'example': 'Er ist wütend.'},

  // Z
  {'word': 'zeitlich', 'meaning': '及时的', 'opposite': 'verspätet', 'example': 'Er ist immer zeitlich.'},
  {'word': 'zufrieden', 'meaning': '满意的', 'opposite': 'unzufrieden', 'example': 'Ich bin zufrieden.'},
  {'word': 'zuverlässig', 'meaning': '可靠的', 'opposite': 'unzuverlässig', 'example': 'Er ist zuverlässig.'},
  {'word': 'zwangsläufig', 'meaning': '强制的', 'opposite': 'freiwillig', 'example': 'Das ist zwangsläufig.'},
];

/// 获取所有形容词
List<Map<String, dynamic>> getAllAdjectives() {
  // 直接使用扩充形容词列表
  final allAdjectives = List<Map<String, dynamic>>.from(expandedAdjectives);

  // 按字母排序
  allAdjectives.sort((a, b) => a['word'].compareTo(b['word']));

  return allAdjectives;
}
