/// 大规模阅读材料库
///
/// 包含50+篇分级阅读材料，覆盖A1-C2所有级别
library;

import '../core/grammar_engine.dart';

/// 阅读材料数据类
class ReadingMaterialData {
  final String id;
  final String title;
  final String content;
  final String category;
  final LanguageLevel level;
  final int wordCount;
  final int unknownWordRatio;
  final String? summary; // 材料摘要

  const ReadingMaterialData({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.level,
    required this.wordCount,
    required this.unknownWordRatio,
    this.summary,
  });
}

/// 大规模阅读材料库
final List<ReadingMaterialData> readingMaterialsExpanded = [
  // ==================== A1 级别 (15篇) ====================

  ReadingMaterialData(
    id: 'a1_life_001',
    title: 'Mein Tag',
    category: 'Alltag',
    level: LanguageLevel.A1,
    wordCount: 58,
    unknownWordRatio: 18,
    content: 'Ich stehe um 7 Uhr auf. Dann frühstücke ich. '
        'Um 8 Uhr gehe ich zur Arbeit. '
        'Ich arbeite bis 17 Uhr. '
        'Nach der Arbeit kaufe ich im Supermarkt ein. '
        'Abends koche ich das Abendessen. '
        'Um 22 Uhr gehe ich schlafen.',
    summary: '描述日常作息',
  ),

  ReadingMaterialData(
    id: 'a1_life_002',
    title: 'Meine Wohnung',
    category: 'Wohnen',
    level: LanguageLevel.A1,
    wordCount: 62,
    unknownWordRatio: 20,
    content: 'Ich wohne in einer kleinen Wohnung. '
        'Die Wohnung hat drei Zimmer: ein Wohnzimmer, ein Schlafzimmer und eine Küche. '
        'Im Wohnzimmer gibt es einen Sofa, einen Tisch und einen Fernseher. '
        'Die Küche ist modern. '
        'Ich habe auch einen Balkon. '
        'Von dem Balkon sehe ich den Park.',
    summary: '介绍公寓房间',
  ),

  ReadingMaterialData(
    id: 'a1_food_001',
    title: 'Deutsches Frühstück',
    category: 'Essen',
    level: LanguageLevel.A1,
    wordCount: 55,
    unknownWordRatio: 22,
    content: 'Was isst man in Deutschland zum Frühstück? '
        'Viele Deutsche essen Brötchen mit Butter und Marmelade. '
        'Manchmal auch Käse oder Wurst. '
        'Dazu trinkt man Kaffee oder Tee. '
        'Am Wochenende frühstückt die Familie länger zusammen. '
        'Das ist eine schöne Tradition.',
    summary: '德国早餐文化',
  ),

  ReadingMaterialData(
    id: 'a1_hobby_001',
    title: 'Meine Hobbys',
    category: 'Freizeit',
    level: LanguageLevel.A1,
    wordCount: 60,
    unknownWordRatio: 19,
    content: 'Ich habe viele Hobbys. '
        'Am Wochenende spiele ich gerne Fußball. '
        'Im Sommer gehe ich schwimmen. '
        'Im Winter fahre ich Ski. '
        'Abends lese ich ein Buch oder höre Musik. '
        'Manchmal schaue ich fern. '
        'Sport ist sehr wichtig für mich.',
    summary: '个人兴趣爱好',
  ),

  ReadingMaterialData(
    id: 'a1_season_001',
    title: 'Die vier Jahreszeiten',
    category: 'Natur',
    level: LanguageLevel.A1,
    wordCount: 65,
    unknownWordRatio: 21,
    content: 'In Deutschland gibt es vier Jahreszeiten. '
        'Im Frühling blühen die Blumen. '
        'Der Sommer ist warm und schön. '
        'Im Herbst fallen die Blätter. '
        'Der Winter ist kalt und es schneit. '
        'Jede Jahreszeit hat ihre eigene Schönheit. '
        'Ich mag den Sommer am liebsten.',
    summary: '四季特点',
  ),

  ReadingMaterialData(
    id: 'a1_shopping_001',
    title: 'Einkaufen',
    category: 'Alltag',
    level: LanguageLevel.A1,
    wordCount: 52,
    unknownWordRatio: 20,
    content: 'Heute geht einkaufen. '
        'Ich brauche Brot, Milch, Eier und Obst. '
        'Der Supermarkt ist in der Stadtmitte. '
        'Das Brot kostet 2 Euro 50. '
        'Die Äpfel kosten 3 Euro. '
        'Ich bezahle an der Kasse mit Karte.',
    summary: '购物场景',
  ),

  ReadingMaterialData(
    id: 'a1_transport_001',
    title: 'Mit dem Bus zur Arbeit',
    category: 'Verkehr',
    level: LanguageLevel.A1,
    wordCount: 48,
    unknownWordRatio: 18,
    content: 'Ich fahre jeden Tag mit dem Bus zur Arbeit. '
        'Die Bushaltestelle ist vor meinem Haus. '
        'Um 7 Uhr kommt der Bus. '
        'Die Fahrt dauert 20 Minuten. '
        'Der Bus ist immer pünktlich. '
        'Das ist sehr praktisch.',
    summary: '乘坐公交车',
  ),

  ReadingMaterialData(
    id: 'a1_weather_001',
    title: 'Wie ist das Wetter?',
    category: 'Wetter',
    level: LanguageLevel.A1,
    wordCount: 50,
    unknownWordRatio: 17,
    content: 'Wie ist das Wetter heute? '
        'Es ist warm und die Sonne scheint. '
        'Die Temperatur ist 22 Grad. '
        'Morgen wird es regnen. '
        'Dann ziehe ich einen Regenschirm an. '
        'Das deutsche Wetter ist oft wechselhaft.',
    summary: '天气情况',
  ),

  ReadingMaterialData(
    id: 'a1_study_001',
    title: 'Deutsch lernen',
    category: 'Lernen',
    level: LanguageLevel.A1,
    wordCount: 54,
    unknownWordRatio: 19,
    content: 'Ich lerne Deutsch. '
        'Die Sprache ist interessant, aber nicht leicht. '
        'Ich habe drei Mal die Woche Unterricht. '
        'Zu Hause lerne ich Vokabeln. '
        'Ich mache auch Grammatikübungen. '
        'Mein Lehrer ist sehr nett und geduldig.',
    summary: '学习德语',
  ),

  ReadingMaterialData(
    id: 'a1_health_001',
    title: 'Zum Arzt',
    category: 'Gesundheit',
    level: LanguageLevel.A1,
    wordCount: 56,
    unknownWordRatio: 20,
    content: 'Ich fühle mich nicht gut. '
        'Ich habe Kopfschmerzen und Fieber. '
        'Deshalb gehe ich zum Arzt. '
        'Die Praxis ist voll. '
        'Ich muss warten. '
        'Der Arzt untersucht mich und verschreibt Medikamente. '
        'In einer Woche gehe ich wieder hin.',
    summary: '看医生',
  ),

  ReadingMaterialData(
    id: 'a1_festival_001',
    title: 'Weihnachten in Deutschland',
    category: 'Kultur',
    level: LanguageLevel.A1,
    wordCount: 68,
    unknownWordRatio: 23,
    content: 'Weihnachten ist das wichtigste Fest in Deutschland. '
        'Die Familien feiern zusammen. '
        'Am Abend gibt es ein großes Essen. '
        'Die Kinder besuchen den Weihnachtsmarkt. '
        'Sie essen Lebkuchen und trinken Glühwein. '
        'Am 24. Dezember schenken wir uns Geschenke. '
        'Das ist ein schönes Fest.',
    summary: '德国圣诞节',
  ),

  ReadingMaterialData(
    id: 'a1_animal_001',
    title: 'Meine Katze',
    category: 'Tiere',
    level: LanguageLevel.A1,
    wordCount: 52,
    unknownWordRatio: 18,
    content: 'Ich habe eine Katze. '
        'Sie heißt Mieze und ist drei Jahre alt. '
        'Mieze ist schwarz und weiß. '
        'Sie ist sehr verspielt und liebt es zu spielen. '
        'Ich füttere sie zweimal am Tag. '
        'Sie schläft gerne auf dem Sofa.',
    summary: '我的猫',
  ),

  ReadingMaterialData(
    id: 'a1_city_001',
    title: 'Meine Stadt',
    category: 'Stadt',
    level: LanguageLevel.A1,
    wordCount: 60,
    unknownWordRatio: 21,
    content: 'Ich lebe in einer mittelgroßen Stadt. '
        'Hier gibt es viele Geschäfte und Restaurants. '
        'Im Zentrum gibt es einen Marktplatz. '
        'Am Wochenende trifft man sich dort. '
        'Die Stadt hat auch ein Museum und ein Theater. '
        'Ich mag meine Stadt sehr gerne.',
    summary: '我的城市',
  ),

  ReadingMaterialData(
    id: 'a1_music_001',
    title: 'Musik hören',
    category: 'Musik',
    level: LanguageLevel.A1,
    wordCount: 48,
    unknownWordRatio: 19,
    content: 'Ich höre gerne Musik. '
        'Meine Lieblingsbands sind Rammstein und Die Ärzte. '
        'Ich höre auch klassische Musik. '
        'Beethoven und Mozart sind genial. '
        'Am Wochenende gehe ich manchmal in Konzerte. '
        'Musik macht mich glücklich.',
    summary: '听音乐',
  ),

  ReadingMaterialData(
    id: 'a1_sport_001',
    title: 'Sport treiben',
    category: 'Sport',
    level: LanguageLevel.A1,
    wordCount: 55,
    unknownWordRatio: 20,
    content: 'Sport ist gesund. '
        'Ich gehe dreimal die Woche in den Sportclub. '
        'Dort trainiere ich Kraft und Ausdauer. '
        'Manchmal jogge ich auch im Park. '
        'Im Sommer spiele ich Tennis mit Freunden. '
        'Bewegung ist wichtig für den Körper.',
    summary: '做运动',
  ),

  // ==================== A2 级别 (12篇) ====================

  ReadingMaterialData(
    id: 'a2_travel_001',
    title: 'Eine Reise nach Hamburg',
    category: 'Reise',
    level: LanguageLevel.A2,
    wordCount: 85,
    unknownWordRatio: 35,
    content: 'Letztes Jahr habe ich eine Reise nach Hamburg gemacht. '
        'Hamburg ist eine tolle Stadt im Norden von Deutschland. '
        'Der Hafen ist das Wahrzeichen der Stadt. '
        'Ich habe eine Hafenrundfahrt gemacht und war im Hamburger Dom. '
        'Am Abend habe ich in der Reeperbahn gegessen. '
        'Das Fischbrötchen war köstlich. '
        'Ich habe auch den Planten un Blomen besucht. '
        'Das ist ein sehr schöner Park. '
        'Ich möchte bald wieder nach Hamburg reisen.',
    summary: '汉堡之旅',
  ),

  ReadingMaterialData(
    id: 'a2_work_001',
    title: 'Mein erster Arbeitstag',
    category: 'Arbeit',
    level: LanguageLevel.A2,
    wordCount: 92,
    unknownWordRatio: 38,
    content: 'Heute war mein erster Tag in der neuen Firma. '
        'Ich war nervös, aber auch aufgeregt. '
        'Mein Chef hat mich begrüßt und mir das Büro gezeigt. '
        'Dann habe ich meine Kollegen kennengelernt. '
        'Sie sind alle sehr freundlich. '
        'Am Vormittag habe ich viele E-Mails beantwortet. '
        'Mittags habe ich mit meinen Kollegen in der Kantine gegessen. '
        'Am Nachmittag hat mich meine Kollegin Sabine eingearbeitet. '
        'Sie hat mir das Firmenprogramm erklärt. '
        'Ich denke, ich werde mich hier gut eingewöhnen.',
    summary: '第一天上班',
  ),

  ReadingMaterialData(
    id: 'a2_study_001',
    title: 'An der Universität',
    category: 'Bildung',
    level: LanguageLevel.A2,
    wordCount: 88,
    unknownWordRatio: 40,
    content: 'Ich studiere an der Universität München. '
        'Meine Fächer sind Informatik und Wirtschaft. '
        'Die Universität ist sehr groß und hat viele Gebäude. '
        'Meine Vorlesungen finden meistens im Hauptgebäude statt. '
        'Die Bibliothek ist mein Lieblingsort. '
        'Dort lerne ich für meine Prüfungen. '
        'In der Mensa esse ich mittags mit meinen Freunden. '
        'Das Essen ist günstig und schmeckt gut. '
        'Das Studentenleben ist anstrengend, aber auch sehr interessant.',
    summary: '大学生活',
  ),

  ReadingMaterialData(
    id: 'a2_technology_001',
    title: 'Smartphones im Alltag',
    category: 'Technologie',
    level: LanguageLevel.A2,
    wordCount: 78,
    unknownWordRatio: 36,
    content: 'Heutzutage hat fast jeder ein Smartphone. '
        'Wir nutzen es den ganzen Tag: '
        'zum Telefonieren, Schreiben von Nachrichten, Surfen im Internet. '
        'Wir können damit Fotos machen und Videos aufnehmen. '
        'Viele Apps machen unser Leben einfacher. '
        'Wir können damit einkaufen, Tickets buchen und Freunde treffen. '
        'Aber man sollte nicht zu viel Zeit am Handy verbringen. '
        'Es ist auch wichtig, mit echten Menschen zu sprechen.',
    summary: '智能手机的日常使用',
  ),

  ReadingMaterialData(
    id: 'a2_culture_001',
    title: 'Deutsche Essenstraditionen',
    category: 'Kultur',
    level: LanguageLevel.A2,
    wordCount: 82,
    unknownWordRatio: 37,
    content: 'Deutsche Küche ist bekannt für Fleisch und Kartoffeln. '
        'Ein typisches Gericht ist Schnitzel mit Pommes. '
        'Bratwurst ist sehr beliebt. '
        'Es gibt sie überall: auf der Straße, im Fest, zu Hause. '
        'Auch deutsches Brot ist berühmt. '
        'Es gibt viele Sorten: Vollkornbrot, Laugengebäck, Brötchen. '
        'Zum Frühstück essen Deutsche gerne Brötchen mit Marmelade oder Honig. '
        'Kaffee am Morgen ist auch ein wichtiges Ritual.',
    summary: '德国饮食传统',
  ),

  ReadingMaterialData(
    id: 'a2_environment_001',
    title: 'Mülltrennung ist wichtig',
    category: 'Umwelt',
    level: LanguageLevel.A2,
    wordCount: 75,
    unknownWordRatio: 34,
    content: 'In Deutschland ist Mülltrennung sehr wichtig. '
        'Jeder Haushalt hat verschiedene Tonnen: '
        'für Papier, Plastik, Bioabfall und Restmüll. '
        'Die Müllabfuhr kommt einmal pro Woche. '
        'Die Deutschen sind sehr umweltbewusst. '
        'Viele kaufen im Supermarkt ein, ohne Plastiktüten zu benutzen. '
        'Auch Flaschenpfand ist ein wichtiges System. '
        'Wenn man Pfandflaschen zurückbringt, bekommt man Geld zurück. '
        'Das ist gut für die Umwelt.',
    summary: '垃圾分类的重要性',
  ),

  ReadingMaterialData(
    id: 'a2_history_001',
    title: 'Die Berliner Mauer',
    category: 'Geschichte',
    level: LanguageLevel.A2,
    wordCount: 95,
    unknownWordRatio: 42,
    content: 'Die Berliner Mauer war eine wichtige Grenze in der deutschen Geschichte. '
        'Sie wurde 1961 gebaut und teilte Berlin in Ost und West. '
        'Viele Menschen versuchten, über die Mauer zu fliehen. '
        'Einige sind dabei gestorben. '
        'Die Mauer stand 28 Jahre lang. '
        'Am 9. November 1989 fiel die Mauer. '
        'Das war ein historischer Tag für Deutschland und die Welt. '
        'Heute kann man noch Teile der Mauer in Berlin sehen. '
        'Sie sind ein Museum und eine Gedenkstätte.',
    summary: '柏林墙的历史',
  ),

  ReadingMaterialData(
    id: 'a2_social_001',
    title: 'Ein Besuch bei Freunden',
    category: 'Soziales',
    level: LanguageLevel.A2,
    wordCount: 72,
    unknownWordRatio: 33,
    content: 'Am Samstag habe ich meine Freunde Julia und Thomas besucht. '
        'Sie haben kürzlich eine neue Wohnung bezogen. '
        'Die Wohnung ist sehr schön und groß. '
        'Wir haben Kaffee und Kuchen gegessen. '
        'Dann haben wir uns lange unterhalten. '
        'Wir haben über unsere Arbeit, Hobbys und Urlaubspläne gesprochen. '
        'Am Abend haben wir zusammen gekocht. '
        'Es war ein schöner Tag mit guten Freunden.',
    summary: '拜访朋友',
  ),

  ReadingMaterialData(
    id: 'a2_media_001',
    title: 'Zeitung lesen',
    category: 'Medien',
    level: LanguageLevel.A2,
    wordCount: 68,
    unknownWordRatio: 35,
    content: 'Jeden Morgen lese ich die Zeitung. '
        'In Deutschland gibt es viele Zeitungen: '
        'die Bild, die Süddeutsche, die Frankfurter Allgemeine. '
        'Die Bild ist eine Boulevardzeitung mit vielen Bildern. '
        'Die Süddeutsche ist eine seriöse Zeitung. '
        'Ich lese sowohl die Online-Version als auch die Print-Ausgabe. '
        'Die Nachrichten helfen mir, über das Tagesgeschehen informiert zu bleiben.',
    summary: '阅读报纸',
  ),

  ReadingMaterialData(
    id: 'a2_money_001',
    title: 'Geld sparen',
    category: 'Finanzen',
    level: LanguageLevel.A2,
    wordCount: 78,
    unknownWordRatio: 36,
    content: 'Ich möchte Geld sparen. '
        'Deshalb habe ich einen Sparplan erstellt. '
        'Zuerst habe ich alle monatlichen Ausgaben notiert. '
        'Dann habe ich überlegt, wo ich sparen kann. '
        'Ich koche jetzt öfter zu Hause. '
        'Ich kaufe weniger Kleidung. '
        'Ich vergleiche die Preise, bevor ich etwas kaufe. '
        'Jeden Monat überweise ich einen Betrag auf mein Sparkonto. '
        'So kann ich meine finanziellen Ziele erreichen.',
    summary: '省钱计划',
  ),

  ReadingMaterialData(
    id: 'a2_language_001',
    title: 'Deutsch als Fremdsprache',
    category: 'Sprache',
    level: LanguageLevel.A2,
    wordCount: 85,
    unknownWordRatio: 39,
    content: 'Deutsch ist eine wichtige Sprache in Europa. '
        'Es wird von über 100 Millionen Menschen gesprochen. '
        'Die deutsche Grammatik ist nicht einfach. '
        'Es gibt vier Fälle: Nominativ, Genitiv, Dativ und Akkusativ. '
        'Auch die Artikel sind schwierig: der, die, das. '
        'Aber mit Übung kann man die Sprache lernen. '
        'Ich habe vor sechs Monaten angefangen, Deutsch zu lernen. '
        'Jetzt kann ich schon einfache Gespräche führen.',
    summary: '德语作为外语',
  ),

  ReadingMaterialData(
    id: 'a2_fashion_001',
    title: 'Deutsche Mode',
    category: 'Mode',
    level: LanguageLevel.A2,
    wordCount: 70,
    unknownWordRatio: 34,
    content: 'Deutsche Mode ist schlicht und funktional. '
        'Die Deutschen tragen gerne praktische Kleidung. '
        'Jeans und T-Shirts sind sehr beliebt. '
        'Für die Arbeit tragen viele Anzug oder Kostüm. '
        'Im Winter sind Jacken und Schals wichtig, weil es kalt ist. '
        'Deutsche Marken wie Adidas und Puma sind weltweit bekannt. '
        'Auf der Berlin Fashion Week kann man neue Trends sehen.',
    summary: '德国时尚',
  ),

  // ==================== B1 级别 (12篇) ====================

  ReadingMaterialData(
    id: 'b1_society_001',
    title: 'Integration in Deutschland',
    category: 'Gesellschaft',
    level: LanguageLevel.B1,
    wordCount: 125,
    unknownWordRatio: 55,
    content: 'Integration ist ein wichtiges Thema in der deutschen Gesellschaft. '
        'Deutschland ist ein Einwanderungsland mit vielen verschiedenen Kulturen. '
        'Jedes Jahr kommen Menschen aus aller Welt nach Deutschland. '
        'Sie arbeiten, studieren oder suchen Asyl. '
        'Die Integration ist nicht immer einfach. '
        'Es gibt sprachliche Barrieren und kulturelle Unterschiede. '
        'Der Deutschkurs ist der erste Schritt zur Integration. '
        'Aber Sprache allein reicht nicht. '
        'Wichtig sind auch Kontakte zu Einheimischen, interkultureller Austausch und gegenseitiger Respekt. '
        'Viele Vereine und Initiativen helfen bei der Integration. '
        'Es ist eine Aufgabe für die ganze Gesellschaft.',
    summary: '德国社会融合',
  ),

  ReadingMaterialData(
    id: 'b1_economy_001',
    title: 'Die deutsche Wirtschaft',
    category: 'Wirtschaft',
    level: LanguageLevel.B1,
    wordCount: 118,
    unknownWordRatio: 58,
    content: 'Die deutsche Wirtschaft ist die größte in Europa. '
        'Sie ist bekannt für ihre Stärke im Export. '
        'Besonders wichtig ist die Automobilindustrie. '
        'Marken wie BMW, Mercedes und Volkswagen sind weltweit bekannt. '
        'Aber auch Maschinenbau, Chemie und Pharmazie sind bedeutende Sektoren. '
        'Deutschland ist ein starkes Industrieland. '
        'Die Wirtschaft ist abhängig von qualifizierten Arbeitskräften. '
        'Das duale Berufsausbildungssystem ist ein wichtiges Merkmal. '
        'Es kombiniert praktische Arbeit im Betrieb mit theoretischem Unterricht in der Berufsschule. '
        'Doch die Wirtschaft steht vor Herausforderungen: '
        'Digitalisierung, Klimawandel und globaler Wettbewerb erfordern Anpassung.',
    summary: '德国经济概览',
  ),

  ReadingMaterialData(
    id: 'b1_education_001',
    title: 'Das deutsche Bildungssystem',
    category: 'Bildung',
    level: LanguageLevel.B1,
    wordCount: 132,
    unknownWordRatio: 62,
    content: 'Das deutsche Bildungssystem ist komplex, aber auch sehr gut. '
        'Es beginnt mit der Grundschule, die vier Jahre dauert. '
        'Dann entscheiden die Lehrer und Eltern über die weitere Schullaufbahn. '
        'Es gibt drei Arten von Schulen: Hauptschule, Realschule und Gymnasium. '
        'Das Gymnasium führt zum Abitur und ermöglicht das Studium. '
        'Nach der Schule können Jugendliche eine Berufsausbildung machen. '
        'Das duale System ist sehr erfolgreich: '
        'Man lernt sowohl im Betrieb als auch in der Schule. '
        'Die Universitäten in Deutschland sind forschungsstark. '
        'Viele internationale Studenten kommen zum Studieren nach Deutschland. '
        'Das Studium ist in vielen Fächern gebührenfrei.',
    summary: '德国教育体系',
  ),

  ReadingMaterialData(
    id: 'b1_health_001',
    title: 'Gesund leben in Deutschland',
    category: 'Gesundheit',
    level: LanguageLevel.B1,
    wordCount: 105,
    unknownWordRatio: 52,
    content: 'Die Deutschen achten viel auf ihre Gesundheit. '
        'Das beginnt mit einer ausgewogenen Ernährung. '
        'Viele Leute kaufen Bio-Produkte im Supermarkt. '
        'Auch vegetarische und vegane Ernährung werden immer beliebter. '
        'Sport ist ein weiterer wichtiger Aspekt. '
        'Viele Deutschen sind in einem Sportverein angemeldet. '
        'Fußball ist der beliebteste Sport. '
        'Aber auch Joggen, Schwimmen und Yoga sind populär. '
        'Regelmäßige Gesundheitsuntersuchungen sind selbstverständlich. '
        'Das deutsche Gesundheitssystem ist eines der besten der Welt. '
        'Versicherung ist Pflicht und ermöglicht den Zugang zu guter medizinischer Versorgung.',
    summary: '健康的生活方式',
  ),

  ReadingMaterialData(
    id: 'b1_digital_001',
    title: 'Digitalisierung im Alltag',
    category: 'Technologie',
    level: LanguageLevel.B1,
    wordCount: 98,
    unknownWordRatio: 50,
    content: 'Die Digitalisierung hat unseren Alltag stark verändert. '
        'Fast alles ist heute digital verfügbar: '
        'Bankgeschäfte, Einkaufen, Kommunikation, Arbeit. '
        'Das Homeoffice hat während der Corona-Pandemie eine neue Bedeutung bekommen. '
        'Viele Menschen arbeiten jetzt von zu Hause. '
        'Videokonferenzen haben persönliche Meetings ersetzt. '
        'Das hat viele Vorteile: keine Fahrtzeit, flexible Arbeitszeiten. '
        'Aber es gibt auch Nachteile: '
        'Isolation, fehlende soziale Kontakte, Schwierigkeiten bei der Trennung von Arbeit und Freizeit. '
        'Digitale Kompetenz ist heute eine wichtige Fähigkeit.',
    summary: '日常生活的数字化',
  ),

  ReadingMaterialData(
    id: 'b1_culture_001',
    title: 'Deutsche Literatur',
    category: 'Kultur',
    level: LanguageLevel.B1,
    wordCount: 92,
    unknownWordRatio: 48,
    content: 'Deutschland hat eine lange und reiche literarische Tradition. '
        'Berühmte deutsche Autoren sind Goethe, Schiller und Thomas Mann. '
        'Goethes "Faust" ist eines der bedeutendsten Werke der Weltliteratur. '
        'Im 20. Jahrhundert prägten Schriftsteller wie Kafka, Brecht und Hesse die Literatur. '
        'Auch die deutsche Philosophie ist einflussreich: '
        'Kant, Hegel, Nietzsche und Heidegger sind weltweit bekannt. '
        'Heute ist die deutsche Literatur vielfältig und international. '
        'Jedes Jahr finden viele Literaturfestivals und Buchmessen statt. '
        'Die Frankfurter Buchmesse ist die weltweit wichtigste Buchmesse.',
    summary: '德国文学',
  ),

  ReadingMaterialData(
    id: 'b1_architecture_001',
    title: 'Deutsche Baukunst',
    category: 'Kultur',
    level: LanguageLevel.B1,
    wordCount: 88,
    unknownWordRatio: 45,
    content: 'Deutsche Architektur ist vielfältig und beeindruckend. '
        'Vom gotischen Kölner Dom bis zum modernen Reichstag in Berlin. '
        'Der Kölner Dom ist eines der größten gotischen Bauwerke der Welt. '
        'Schloss Neuschwanstein ist ein Märchenschloss aus dem 19. Jahrhundert. '
        'Die Baudenkmäler in Deutschland sind zahllos und bedeutend. '
        'Moderne deutsche Architektur ist ebenfalls innovativ. '
        'Architekten wie Walter Gropius und Mies van der Rohe haben den Bauhaus-Stil begründet. '
        'Dieser Stil beeinflusst die Architektur weltweit bis heute. '
        'Nachhaltiges Bauen wird immer wichtiger.',
    summary: '德国建筑',
  ),

  ReadingMaterialData(
    id: 'b1_climate_001',
    title: 'Klimaschutz in Deutschland',
    category: 'Umwelt',
    level: LanguageLevel.B1,
    wordCount: 115,
    unknownWordRatio: 56,
    content: 'Klimaschutz ist eine der wichtigsten politischen Aufgaben in Deutschland. '
        'Das Land hat sich zu hohen CO2-Reduktionszielen verpflichtet. '
        'Bis 2045 soll Deutschland klimaneutral sein. '
        'Ein wichtiger Schritt ist der Ausbau erneuerbarer Energien. '
        'Windkraft und Solarenergie sollen Kohle und Atomkraft ersetzen. '
        'Auch die Verkehrswende ist eine große Herausforderung. '
        'Mehr Elektroautos und eine bessere Bahn-Infrastruktur sind geplant. '
        'Viele Deutsche engagieren sich privat für den Klimaschutz. '
        'Sie verzichten auf Flugreisen, kaufen regionale Produkte oder fahren weniger Auto. '
        'Aber es gibt auch Kritik an den hohen Kosten und Auswirkungen auf die Wirtschaft.',
    summary: '德国的气候保护',
  ),

  ReadingMaterialData(
    id: 'b1_media_001',
    title: 'Medienlandschaft in Deutschland',
    category: 'Medien',
    level: LanguageLevel.B1,
    wordCount: 95,
    unknownWordRatio: 47,
    content: 'Die Medienlandschaft in Deutschland ist vielfältig. '
        'Es gibt öffentlich-rechtliche Sender wie ARD und ZDF. '
        'Diese sind unabhängig und finanzieren sich über Gebühren. '
        'Privatsender wie RTL und Sat.1 finanzieren sich durch Werbung. '
        'Auch das Radio ist beliebt: Deutschlandfunk und diverse private Sender. '
        'Die Printmedien haben mit sinkenden Auflagen zu kämpfen. '
        'Viele Zeitungen bieten inzwischen Online-Abonnements an. '
        'Digitale Medien und soziale Netzwerke gewinnen immer mehr an Bedeutung. '
        'Doch traditionelle Medien bleiben wichtig für die demokratische Meinungsbildung.',
    summary: '德国媒体格局',
  ),

  ReadingMaterialData(
    id: 'b1_tourism_001',
    title: 'Tourismus in Deutschland',
    category: 'Reise',
    level: LanguageLevel.B1,
    wordCount: 108,
    unknownWordRatio: 53,
    content: 'Deutschland ist ein beliebtes Reiseland. '
        'Jährlich besuchen Millionen Touristen das Land. '
        'Die beliebtesten Ziele sind Berlin, München und Hamburg. '
        'Berlin bietet eine Mischung aus Geschichte und moderner Kultur. '
        'München ist bekannt für das Oktoberfest und die bayerische Gastfreundschaft. '
        'Die Schwarzwald-Region zieht Naturliebhaber an. '
        'Der Rhein mit seinen Burgen und Weinbergen ist romantisch. '
        'Auch die Neuschwanstein-Burg zieht viele Besucher an. '
        'Die Deutschen selbst reisen gerne: im Urlaub in den Süden oder in die Berge. '
        'Tourismus ist ein wichtiger Wirtschaftsfaktor für Deutschland.',
    summary: '德国旅游业',
  ),

  ReadingMaterialData(
    id: 'b1_science_001',
    title: 'Forschung und Innovation',
    category: 'Wissenschaft',
    level: LanguageLevel.B1,
    wordCount: 102,
    unknownWordRatio: 51,
    content: 'Deutschland ist ein Land der Erfinder und Entdecker. '
        'Von Gutenberg bis Einstein haben deutsche Wissenschaftler die Welt verändert. '
        'Heute ist Deutschland führend in vielen Bereichen: '
        'Ingenieurwesen, Chemie, Medizin und Informatik. '
        'Die Max-Planck-Gesellschaft und die Fraunhofer-Gesellschaft sind renommierte Forschungseinrichtungen. '
        'Die deutschen Universitäten arbeiten eng mit der Industrie zusammen. '
        'Besonders im Bereich künstliche Intelligenz und erneuerbare Energien wird viel geforscht. '
        'Deutschland gibt viel Geld für Bildung und Forschung aus. '
        'Das ist wichtig für die Innovationsfähigkeit des Landes.',
    summary: '科研与创新',
  ),

  ReadingMaterialData(
    id: 'b1_family_001',
    title: 'Familienmodelle im Wandel',
    category: 'Gesellschaft',
    level: LanguageLevel.B1,
    wordCount: 98,
    unknownWordRatio: 49,
    content: 'Die traditionelle Familie hat sich in Deutschland gewandelt. '
        'Früher waren Vater, Mutter und Kinder die Norm. '
        'Heute gibt es viele verschiedene Familienmodelle: '
        'Alleinerziehende, Patchwork-Familien, gleichgeschlechtliche Paare mit Kindern. '
        'Die Gesellschaft hat sich toleranter entwickelt. '
        'Auch die Rolle der Väter hat sich verändert. '
        'Väter nehmen heute mehr Elternzeit und kümmern sich um die Kinder. '
        'Die Geburtenrate ist in Deutschland niedrig. '
        'Das führt zu Diskussionen über Familienpolitik und Vereinbarkeit von Familie und Beruf.',
    summary: '家庭模式的变化',
  ),

  // ==================== B2 级别 (8篇) ====================

  ReadingMaterialData(
    id: 'b2_politics_001',
    title: 'Das politische System Deutschlands',
    category: 'Politik',
    level: LanguageLevel.B2,
    wordCount: 168,
    unknownWordRatio: 75,
    content: 'Deutschland ist eine föderale parlamentarische Demokratie. '
        'Das politische System basiert auf dem Grundgesetz von 1949. '
        'Das Parlament heißt Bundestag und wird alle vier Jahre gewählt. '
        'Die Regierung wird vom Bundeskanzler oder der Bundeskanzlerin geführt. '
        'Der Bundespräsident hat vorwiegend repräsentative Aufgaben. '
        'Deutschland besteht aus 16 Bundesländern, die eigene Regierungen haben. '
        'Der Bundesrat vertritt die Interessen der Länder bei der Gesetzgebung. '
        'Das Wahlrecht ist ab 18 Jahren allgemeines, unmittelbares, freies, gleiches und geheimes Wahlrecht. '
        'Es gibt mehrere Parteien: CDU/CSU, SPD, Grüne, FDP, AfD und Die Linke. '
        'Regierungen sind meist Koalitionen aus zwei oder mehr Parteien. '
        'Das politische System ist stabil und hat sich in der Bundesrepublik bewährt. '
        'Die föderale Struktur ermöglicht regionale Vielfalt und politische Teilhabe.',
    summary: '德国政治体系',
  ),

  ReadingMaterialData(
    id: 'b2_economy_001',
    title: 'Globalisierung und deutsche Wirtschaft',
    category: 'Wirtschaft',
    level: LanguageLevel.B2,
    wordCount: 155,
    unknownWordRatio: 72,
    content: 'Die deutsche Wirtschaft ist stark in die globale Wirtschaft integriert. '
        'Deutschland ist einer der größten Exporteure der Welt. '
        'Die Globalisierung bringt Chancen und Herausforderungen. '
        'Einerseits ermöglicht sie den Zugang zu neuen Märkten. '
        'Deutsche Unternehmen verkaufen ihre Produkte weltweit. '
        'Andererseits konkurrieren sie jetzt mit Billiganbietern aus Asien. '
        'Einige Industrien haben die Produktion ins Ausland verlagert. '
        'Das führt zu Arbeitsplatzverlusten in Deutschland. '
        'Die Digitalisierung und Automatisierung verändern die Arbeitswelt. '
        'Viele Jobs werden in Zukunft wegfallen, andere entstehen neu. '
        'Weiterbildung und lebenslanges Lernen werden immer wichtiger. '
        'Die Industrie 4.0 ist ein deutsches Konzept für die vierte industrielle Revolution. '
        'Sie verbindet digitale Technologien mit industrieller Produktion.',
    summary: '全球化与德国经济',
  ),

  ReadingMaterialData(
    id: 'b2_social_001',
    title: 'Soziale Ungleichheit',
    category: 'Gesellschaft',
    level: LanguageLevel.B2,
    wordCount: 142,
    unknownWordRatio: 68,
    content: 'Soziale Ungleichheit ist auch in Deutschland ein Thema. '
        'Obwohl Deutschland ein wohlhabendes Land ist, gibt es Unterschiede in Einkommen und Vermögen. '
        'Die Schere zwischen Arm und Reich geht langsam auseinander. '
        'Besonders in großen Städten ist die Wohnungsnot spürbar. '
        'Mietpreise steigen, während kleine Einkommen stagnieren. '
        'Das Sozialsystem in Deutschland ist gut ausgebaut, '
        'doch es reicht nicht immer aus, allen zu helfen. '
        'Die Diskussion über Mindestlohn, Grundsicherung und sozialen Wohnungsbau ist kontrovers. '
        'Gleichzeitig fordert die Globalisierung Flexibilität von den Arbeitnehmern. '
        'Prekäre Beschäftigung, befristete Verträge und Leiharbeit nehmen zu. '
        'Die Balance zwischen wirtschaftlicher Freiheit und sozialer Gerechtigkeit bleibt eine Herausforderung.',
    summary: '社会不平等',
  ),

  ReadingMaterialData(
    id: 'b2_migration_001',
    title: 'Flucht und Migration',
    category: 'Gesellschaft',
    level: LanguageLevel.B2,
    wordCount: 138,
    unknownWordRatio: 70,
    content: 'Flucht und Migration prägen die aktuelle politische Diskussion in Deutschland. '
        'Seit 2015 sind viele Flüchtlinge aus Syrien, Irak und Afghanistan nach Deutschland gekommen. '
        'Die Gründe für Flucht sind vielfältig: Krieg, Verfolgung, Armut, Klimawandel. '
        'Deutschland hat 2015 viele Flüchtlinge aufgenommen. '
        'Die Integration war eine große Herausforderung für Gesellschaft und Behörden. '
        'Sprachkurse, Wohnraumbeschaffung und Schulintegration mussten organisiert werden. '
        'Die öffentliche Meinung ist gespalten. '
        'Einige begrüßen die Willkommenskultur, andere fürchten um die kulturelle Identität. '
        'Europäische Lösungen wie eine faire Verteilung der Flüchtlinge werden diskutiert. '
        'Auch die wirtschaftlichen Aspekte der Migration werden kontrovers debattiert.',
    summary: '难民与移民',
  ),

  ReadingMaterialData(
    id: 'b2_tech_001',
    title: 'Künstliche Intelligenz',
    category: 'Technologie',
    level: LanguageLevel.B2,
    wordCount: 128,
    unknownWordRatio: 65,
    content: 'Künstliche Intelligenz (KI) verändert die Welt grundlegend. '
        'Deutschland will in diesem Bereich führend werden. '
        'Die Bundesregierung hat eine Strategie für KI entwickelt. '
        'Deutsche Forscher leisten wichtige Beiträge zur KI-Forschung. '
        'Anwendungen finden sich in vielen Bereichen: '
        'Medizin, Industrie, Verkehr, Finanzen. '
        'Selbstfahrende Autos sind ein Beispiel für KI im Verkehr. '
        'Doch es gibt auch ethische Fragen: '
        'Wie gehen wir mit Arbeitsplatzverlusten um? '
        'Wie schützen wir persönliche Daten? '
        'Wer haftet bei Fehlern von KI-Systemen? '
        'Die Regulierung von KI ist eine internationale Herausforderung. '
        'Europa arbeitet an einem KI-Gesetz, das Innovation ermöglicht, aber Risiken begrenzt.',
    summary: '人工智能',
  ),

  ReadingMaterialData(
    id: 'b2_european_001',
    title: 'Deutschland und die EU',
    category: 'Politik',
    level: LanguageLevel.B2,
    wordCount: 115,
    unknownWordRatio: 60,
    content: 'Deutschland ist eines der Gründermitglieder der Europäischen Union. '
        'Die EU ist ein Erfolg in der europäischen Geschichte. '
        'Sie hat Frieden und Wohlstand gebracht. '
        'Deutschland ist das bevölkerungsreichste und wirtschaftsstärkste Land der EU. '
        'Deshalb hat es viel Einfluss auf die europäische Politik. '
        'Der Euro als gemeinsame Währung stabilisiert die Wirtschaft. '
        'Der Binnenmarkt ermöglicht freien Handel und Bewegungsfreiheit. '
        'Doch die EU steht vor Herausforderungen: '
        'Brexit, Populismus, wirtschaftliche Ungleichgewichte. '
        'Deutsche Politiker engagieren sich für eine Reform der EU. '
        'Die Vision einer "Vereinigten Staaten von Europa" wird debattiert. '
        'Europas Rolle in der Welt verändert sich durch neue Mächte wie China und Indien.',
    summary: '德国与欧盟',
  ),

  ReadingMaterialData(
    id: 'b2_culture_001',
    title: 'Kulturelle Identität',
    category: 'Kultur',
    level: LanguageLevel.B2,
    wordCount: 122,
    unknownWordRatio: 62,
    content: 'Die kulturelle Identität Deutschlands ist vielschichtig. '
        'Sie geprägt von der Geschichte, aber auch von der Moderne. '
        'Die deutsche Kultur ist nicht einheitlich, sondern regional unterschiedlich. '
        'Bayern haben andere Traditionen als die Sachsen oder Rheinländer. '
        'Die deutsche Sprache verbindet das Land, '
        'doch es gibt viele Dialekte und regionale Besonderheiten. '
        'Deutsche Kultur ist auch durch die Verantwortung für die Geschichte geprägt. '
        'Der Holocaust und der Zweite Weltkrieg haben die nationale Identität verändert. '
        'Heute versteht sich Deutschland als weltoffene und demokratische Nation. '
        'Die Diskussion über deutsche Leitkultur oder multikulturelle Gesellschaft ist kontrovers. '
        'Kulturelle Bildung und kulturelle Teilhabe sind wichtige gesellschaftliche Aufgaben.',
    summary: '文化认同',
  ),

  ReadingMaterialData(
    id: 'b2_future_001',
    title: 'Die Zukunft der Arbeit',
    category: 'Arbeit',
    level: LanguageLevel.B2,
    wordCount: 135,
    unknownWordRatio: 67,
    content: 'Die Arbeitswelt der Zukunft wird anders aussehen als heute. '
        'Digitalisierung und KI werden viele Berufe verändern. '
        'Manche Jobs werden verschwinden, andere entstehen neu. '
        'Homeoffice und flexible Arbeitszeiten werden zur Normalität. '
        'Das klassische 40-Stunden-Arbeitswoche könnte sich auflösen. '
        'Lebenslanges Lernen wird notwendig, um mit dem technologischen Wandel Schritt zu halten. '
        'Die Grenzen zwischen Arbeit und Privatleben verschwimmen. '
        'Das bringt Chancen für mehr Flexibilität und Autonomie. '
        'Aber es birgt auch Risiken: Stress, Überlastung, soziale Isolation. '
        'Gewerkschaften und Arbeitgeber müssen neue Wege der Zusammenarbeit finden. '
        'Die Arbeitsgesetze müssen an die neue Realität angepasst werden.',
    summary: '工作的未来',
  ),

  // ==================== C1 级别 (5篇) ====================

  ReadingMaterialData(
    id: 'c1_philosophy_001',
    title: 'Aufklärung und deutsche Philosophie',
    category: 'Philosophie',
    level: LanguageLevel.C1,
    wordCount: 185,
    unknownWordRatio: 95,
    content: 'Die deutsche Philosophie hat das westliche Denken tief geprägt. '
        'Immanuel Kants kritische Philosophie revolutionierte die Erkenntnistheorie. '
        'Sein kategorischer Imperativ ist bis heute ein ethischer Maßstab. '
        'Hegel entwickelte das System des deutschen Idealismus. '
        'Marx und Engels wandten die philosophische Methode auf die Ökonomie an. '
        'Im 20. Jahrhundert prägten Nietzsche und Heidegger das philosophische Denken. '
        'Die Frankfurter Schule mit Adorno und Horkheimer analysierte die Aufklärung kritisch. '
        'Heute ist die deutsche Philosophie international und interdisziplinär. '
        'Wichtige Themen sind die Ethik der Künstlichen Intelligenz, '
        'die politische Philosophie in einer globalisierten Welt '
        'und die Frage nach dem Sinn menschlichen Existenz. '
        'Das kritische Denken bleibt die wichtigste Tradition der deutschen Philosophie.',
    summary: '启蒙运动与德国哲学',
  ),

  ReadingMaterialData(
    id: 'c1_science_001',
    title: 'Wissenschaftsethik',
    category: 'Wissenschaft',
    level: LanguageLevel.C1,
    wordCount: 168,
    unknownWordRatio: 88,
    content: 'Wissenschaftsethik ist ein wichtiges Feld in der modernen Forschung. '
        'Mit der wachsenden Macht der Wissenschaft stellen sich neue ethische Fragen. '
        'Die Genforschung ermöglicht Eingriffe in das menschliche Erbgut. '
        'Wie weit darf man gehen? '
        'Die Stammzellenforschung bietet Heilungschancen, wirft aber ethische Fragen auf. '
        'Auch bei der Künstlichen Intelligenz gibt es ethische Herausforderungen. '
        'Algorithmen können diskriminieren, Entscheidungen opak bleiben. '
        'Wer ist verantwortlich, wenn eine KI einen Fehler macht? '
        'Tierversuche sind notwendig für die medizinische Forschung. '
        'Aber wie kann man das Leid der Tiere minimieren? '
        'Wissenschaftliche Integrität ist ein weiterer wichtiger Aspekt. '
        'Die Ergebnisse müssen reproduzierbar sein, Fälschung muss verhindert werden.',
    summary: '科学伦理',
  ),

  ReadingMaterialData(
    id: 'c1_literature_001',
    title: 'Literaturtheorie',
    category: 'Kultur',
    level: LanguageLevel.C1,
    wordCount: 152,
    unknownWordRatio: 82,
    content: 'Die Literaturtheorie hat sich im 20. Jahrhundert stark gewandelt. '
        'Der Strukturalismus von Levi-Strauss und Barthes revolutionierte die Textanalyse. '
        'Der Poststrukturalismus hinterfragte die festen Strukturen. '
        'Derridas Konzept der Dekonstruktion zeigte die Instabilität der Bedeutung. '
        'In Deutschland beeinflusste die Frankfurter Schule die Literaturkritik. '
        'Adorno und Benjamin entwickelten Theorien über Kunst und Gesellschaft. '
        'Heute sind Gender Studies, Postkoloniale Studien und Cultural Studies wichtig. '
        'Die Literaturwissenschaft ist interdisziplinär geworden. '
        'Sie verbindet sich mit Soziologie, Psychologie, Geschichte und Philosophie. '
        'Digitale Methoden wie "Digital Humanities" eröffnen neue Forschungsperspektiven. '
        'Die Frage, was Literatur ist, wird immer komplexer.',
    summary: '文学理论',
  ),

  ReadingMaterialData(
    id: 'c1_globalization_001',
    title: 'Globalisierung und kultureller Wandel',
    category: 'Gesellschaft',
    level: LanguageLevel.C1,
    wordCount: 175,
    unknownWordRatio: 90,
    content: 'Die Globalisierung hat zu einer tiefgreifenden kulturellen Veränderung geführt. '
        'Kulturelle Grenzen verschwimmen in einer vernetzten Welt. '
        'Der kulturelle Austausch nimmt zu, aber auch die Homogenisierung der Kultur ist spürbar. '
        'Westliche Konsumkultur verbreitet sich weltweit. '
        'Gleichzeitig entstehen neue hybride Kulturformen. '
        'Die deutsche Kultur ist Teil dieses globalen Prozesses. '
        'Die amerikanische Popkultur beeinflusst das deutsche Kulturleben. '
        'Migration macht Deutschland zur multikulturellen Gesellschaft. '
        'Die Frage nach der nationalen Identität wird neu gestellt. '
        'Kosmopolitismus versus nationale Identität ist eine wichtige Debatte. '
        'Das Internet beschleunigt den kulturellen Wandel. '
        'Soziale Medien schaffen neue Formen der Kommunikation und Gemeinschaftsbildung. '
        'Die Zivilgesellschaft organisiert sich zunehmend online.',
    summary: '全球化与文化变迁',
  ),

  ReadingMaterialData(
    id: 'c1_economy_001',
    title: 'Wirtschaftspolitische Herausforderungen',
    category: 'Wirtschaft',
    level: LanguageLevel.C1,
    wordCount: 162,
    unknownWordRatio: 85,
    content: 'Die Wirtschaftspolitik steht vor komplexen Herausforderungen im 21. Jahrhundert. '
        'Nach der Finanzkrise von 2008 hat sich das wirtschaftliche Denken verändert. '
        'Die Niedrigzinspolitik der Zentralbanken hat neue Probleme geschaffen. '
        'Die Ungleichheit in vielen Industrieländern ist gewachsen. '
        'Der Klimawandel erfordert eine Umgestaltung der Wirtschaft. '
        'Deutschland muss seine Industrie transformieren. '
        'Die Automobilindustrie muss sich auf Elektromobilität umstellen. '
        'Die Energiewende ist ein Mammutprojekt mit vielen Unsicherheiten. '
        'Der demografische Wandel belastet die sozialen Sicherungssysteme. '
        'Digitalisierung und Globalisierung erhöhen den Wettbewerbsdruck. '
        'Die Politik muss zwischen verschiedenen Zielen abwägen: '
        'Wachstum versus Nachhaltigkeit, Effizienz versus soziale Sicherheit, '
        'nationaler Schutz versus internationale Kooperation.',
    summary: '经济政策挑战',
  ),

  // ==================== C2 级别 (3篇) ====================

  ReadingMaterialData(
    id: 'c2_philosophy_001',
    title: 'Existenzphilosophie und Postmoderne',
    category: 'Philosophie',
    level: LanguageLevel.C2,
    wordCount: 245,
    unknownWordRatio: 135,
    content: 'Die Existenzphilosophie des 20. Jahrhunderts stellt die menschliche Existenz in den Mittelpunkt. '
        'Heideggers "Sein und Zeit" analysiert die Struktur des Daseins. '
        'Sartre betonte die absolute Freiheit und Verantwortung des Menschen. '
        'Camus thematisierte die Absurdität des menschlichen Daseins. '
        'Die Postmoderne hinterfragte die großen metanarrative der Moderne. '
        'Lyotard erklärte das "Ende der großen Erzählungen". '
        'Derridas Dekonstruktion zeigte die Instabilität aller Bedeutung. '
        'Foucault analysierte die Macht-Wissens-Komplexe in der Gesellschaft. '
        'In Deutschland verband sich diese Tradition mit der Kritischen Theorie. '
        'Habermas entwickelte die Theorie des kommunikativen Handelns. '
        'Honneth arbeitete zur Theorie der Anerkennung. '
        'Die Gegenwartsphilosophie beschäftigt sich mit新技术、生物伦理、环境哲学. '
        'Die Diskussion um Posthumanismus und Transhumanismus wird immer wichtiger. '
        'Was bedeutet es, Mensch zu sein in einer Zeit technischer Umwälzungen?',
    summary: '存在哲学与后现代主义',
  ),

  ReadingMaterialData(
    id: 'c2_science_001',
    title: 'Paradigmenwechsel in der Wissenschaft',
    category: 'Wissenschaft',
    level: LanguageLevel.C2,
    wordCount: 228,
    unknownWordRatio: 125,
    content: 'Wissenschaftliche Revolutionen verändern fundamental, wie wir die Welt verstehen. '
        'Von der kopernikanischen Wende bis zur Quantenmechanik: '
        'Paradigmenwechsel sind selten, aber tiefgreifend. '
        'Aktuell erleben wir mehrere solcher Umwälzungen gleichzeitig. '
        'Die Künstliche Intelligenz verändert, was wir unter "Intelligenz" verstehen. '
        'Die Epigenetik revolutioniert unser Verständnis von Vererbung. '
        'Die Neurowissenschaften hinterfragen traditionelle Konzepte von Bewusstsein und freiem Willen. '
        'In der Kosmologie entdecken wir dunkle Materie und dunkle Energie. '
        'Diese Entdeckungen zeigen die Grenzen unseres aktuellen Wissens. '
        'Interdisziplinarität ist unverzichtbar geworden. '
        'Die traditionellen Fachgrenzen verschwimmen. '
        'Doch mit neuen Möglichkeiten kommen auch neue Verantwortungen. '
        'Die Wissenschaft muss sich den ethischen und gesellschaftlichen Konsequenzen stellen. '
        'Die Frage nach der Verantwortung des Wissenschaftlers wird dringlicher.',
    summary: '科学范式的转变',
  ),

  ReadingMaterialData(
    id: 'c2_art_001',
    title: 'Kunst im digitalen Zeitalter',
    category: 'Kunst',
    level: LanguageLevel.C2,
    wordCount: 195,
    unknownWordRatio: 115,
    content: 'Die Kunst hat sich im digitalen Zeitalter radikal verändert. '
        'Digitale Technologien ermöglichen neue Formen des künstlerischen Ausdrucks. '
        'Digitale Kunst, Generative Art, NFTs und KI-generierte Werke brechen traditionelle Grenzen. '
        'Die Rolle des Künstlers wird neu definiert. '
        'Ist der Programmierer einer KI der Künstler? '
        'Die Frage nach der Autorschaft und Originalität wird komplex. '
        'Die Kunstrezeption verändert sich durch digitale Plattformen. '
        'Instagram und TikTok sind zu neuen Ausstellungsflächen geworden. '
        'Die Demokratisierung der Kunst ist einerseits positiv. '
        'Andererseits droht die Kommerzialisierung und der Verlust der kritischen Distanz. '
        'Die Kunsttheorie muss auf diese Entwicklungen reagieren. '
        'Wichtig ist dabei die Balance zwischen technologischer Neuerung und künstlerischer Integrität.',
    summary: '数字时代的艺术',
  ),
];

/// 按级别获取材料
List<ReadingMaterialData> getReadingMaterialsByLevel(LanguageLevel level) {
  return readingMaterialsExpanded.where((m) => m.level == level).toList();
}

/// 按类别获取材料
List<ReadingMaterialData> getReadingMaterialsByCategory(String category) {
  return readingMaterialsExpanded.where((m) => m.category == category).toList();
}

/// 获取所有材料
List<ReadingMaterialData> getAllReadingMaterials() {
  return readingMaterialsExpanded;
}
