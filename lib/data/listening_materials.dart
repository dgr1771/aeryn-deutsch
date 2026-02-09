/// 听力训练材料数据
library;

import '../models/listening_material.dart';

/// A1级听力材料
final List<ListeningMaterial> a1Materials = [
  // 对话：自我介绍
  ListeningMaterial(
    id: 'A1_001',
    title: 'Begrüßung und Vorstellung',
    level: ListeningLevel.A1,
    type: ListeningType.dialogue,
    topic: '见面问候',
    content: '''Anna: Hallo! Ich heiße Anna. Wie heißt du?
Max: Hallo Anna! Ich heiße Max. Wie alt bist du?
Anna: Ich bin 20 Jahre alt. Und du?
Max: Ich bin 22 Jahre alt. Woher kommst du?
Anna: Ich komme aus China. Und du?
Max: Ich komme aus Deutschland. Freut mich!
Anna: Freut mich auch!''',
    duration: 45,
    questions: [
      ListeningQuestion(
        id: 'A1_001_Q1',
        type: QuestionType.multipleChoice,
        question: 'Wie heißt das Mädchen?',
        options: ['Anna', 'Max', 'Maria', 'Hans'],
        correctAnswer: 'Anna',
        startTime: 0,
        endTime: 5,
      ),
      ListeningQuestion(
        id: 'A1_001_Q2',
        type: QuestionType.multipleChoice,
        question: 'Wie alt ist Anna?',
        options: ['22', '20', '21', '23'],
        correctAnswer: '20',
        startTime: 8,
        endTime: 12,
      ),
      ListeningQuestion(
        id: 'A1_001_Q3',
        type: QuestionType.multipleChoice,
        question: 'Woher kommt Max?',
        options: ['China', 'Österreich', 'Deutschland', 'Schweiz'],
        correctAnswer: 'Deutschland',
        startTime: 18,
        endTime: 22,
      ),
    ],
    vocabulary: 'sich vorstellen - 自我介绍\nWie heißt du? - 你叫什么名字？\nWie alt bist du? - 你多大了？\nWoher kommst du? - 你来自哪里？\nFreut mich! - 很高兴认识你！',
  ),

  // 独白：家庭介绍
  ListeningMaterial(
    id: 'A1_002',
    title: 'Meine Familie',
    level: ListeningLevel.A1,
    type: ListeningType.monologue,
    topic: '家庭',
    content: '''Das ist meine Familie. Ich habe einen Vater und eine Mutter. Mein Vater heißt Peter und ist 45 Jahre alt. Er ist Arzt. Meine Mutter heißt Maria und ist 42 Jahre alt. Sie ist Lehrerin. Ich habe auch eine Schwester. Sie heißt Lisa und ist 12 Jahre alt. Sie geht zur Schule. Ich habe keine Brüder. Ich liebe meine Familie.''',
    duration: 50,
    questions: [
      ListeningQuestion(
        id: 'A1_002_Q1',
        type: QuestionType.multipleChoice,
        question: 'Was ist der Vater von Beruf?',
        options: ['Lehrer', 'Arzt', 'Ingenieur', 'Koch'],
        correctAnswer: 'Arzt',
        startTime: 15,
        endTime: 20,
      ),
      ListeningQuestion(
        id: 'A1_002_Q2',
        type: QuestionType.trueFalse,
        question: 'Die Mutter ist 45 Jahre alt.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Falsch',
        startTime: 22,
        endTime: 28,
      ),
      ListeningQuestion(
        id: 'A1_002_Q3',
        type: QuestionType.multipleChoice,
        question: 'Wie heißt die Schwester?',
        options: ['Anna', 'Maria', 'Lisa', 'Sarah'],
        correctAnswer: 'Lisa',
        startTime: 33,
        endTime: 38,
      ),
    ],
    vocabulary: 'der Vater - 父亲\ndie Mutter - 母亲\nder Bruder - 兄弟\ndie Schwester - 姐妹\nvon Beruf sein - 从事...职业',
  ),

  // 公告：火车站
  ListeningMaterial(
    id: 'A1_003',
    title: 'Bahnhofsansage',
    level: ListeningLevel.A1,
    type: ListeningType.announcement,
    topic: '交通出行',
    content: '''Achtung, bitte achtung! Der Zug nach München fährt heute von Gleis 5. Abfahrt ist 14 Uhr 30. Der Zug nach Hamburg fährt von Gleis 8. Abfahrt ist 15 Uhr. Der Zug nach Berlin ist 10 Minuten verspätet. Wir bitten um Entschuldigung.''',
    duration: 35,
    questions: [
      ListeningQuestion(
        id: 'A1_003_Q1',
        type: QuestionType.multipleChoice,
        question: 'Von welchem Gleis fährt der Zug nach München?',
        options: ['Gleis 3', 'Gleis 5', 'Gleis 8', 'Gleis 10'],
        correctAnswer: 'Gleis 5',
        startTime: 8,
        endTime: 15,
      ),
      ListeningQuestion(
        id: 'A1_003_Q2',
        type: QuestionType.multipleChoice,
        question: 'Wann fährt der Zug nach Hamburg?',
        options: ['14:30', '15:00', '15:30', '16:00'],
        correctAnswer: '15:00',
        startTime: 20,
        endTime: 26,
      ),
      ListeningQuestion(
        id: 'A1_003_Q3',
        type: QuestionType.trueFalse,
        question: 'Der Zug nach Berlin ist pünktlich.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Falsch',
        startTime: 27,
        endTime: 32,
      ),
    ],
    vocabulary: 'der Bahnhof - 火车站\nder Gleis - 站台\ndie Abfahrt - 出发\nverspätet - 晩点\nbitte - 请',
  ),
];

/// A2级听力材料
final List<ListeningMaterial> a2Materials = [
  // 对话：点餐
  ListeningMaterial(
    id: 'A2_001',
    title: 'Im Restaurant',
    level: ListeningLevel.A2,
    type: ListeningType.dialogue,
    topic: '餐厅点餐',
    content: '''Kellner: Guten Abend! Haben Sie sich schon entschieden?
Gast: Ja, ich hätte gerne das Schnitzel mit Kartoffelsalat.
Kellner: Möchten Sie dazu etwas trinken?
Gast: Ja, ein Glas Wasser, bitte.
Kellner: Und als Vorspeise?
Gast: Ich nehme die Tomatensuppe.
Kellner: Very gut. Ich bringe Ihnen gleich die Karte.
Gast: Danke. Was kostet das Schnitzel?
Kellner: Das kostet 15 Euro 50.
Gast: In Ordnung. Ich nehme es.
Kellner: Very gut. Ich komme gleich zurück.''',
    duration: 75,
    questions: [
      ListeningQuestion(
        id: 'A2_001_Q1',
        type: QuestionType.multipleChoice,
        question: 'Was möchte der Gast als Hauptgericht bestellen?',
        options: [
          'Das Schnitzel mit Kartoffelsalat',
          'Die Tomatensuppe',
          'Das Steak mit Pommes',
          'Den Salat',
        ],
        correctAnswer: 'Das Schnitzel mit Kartoffelsalat',
        startTime: 10,
        endTime: 18,
      ),
      ListeningQuestion(
        id: 'A2_001_Q2',
        type: QuestionType.multipleChoice,
        question: 'Was kostet das Schnitzel?',
        options: ['12 Euro 50', '15 Euro 50', '18 Euro', '20 Euro'],
        correctAnswer: '15 Euro 50',
        startTime: 45,
        endTime: 52,
      ),
      ListeningQuestion(
        id: 'A2_001_Q3',
        type: QuestionType.fillInBlank,
        question: 'Der Gast bestellt ein _____ Wasser.',
        options: ['Glas', 'Flasche', 'Tasse', 'Krug'],
        correctAnswer: 'Glas',
        startTime: 19,
        endTime: 24,
      ),
    ],
    vocabulary: 'sich entscheiden - 做决定\ndas Hauptgericht - 主菜\ndie Vorspeise - 前菜\nkosten - 花费\ndie Karte - 菜单',
  ),

  // 采访：业余爱好
  ListeningMaterial(
    id: 'A2_002',
    title: 'Hobbys',
    level: ListeningLevel.A2,
    type: ListeningType.interview,
    topic: '业余爱好',
    content: '''Interviewer: Hallo Lisa, was machst du gerne in deiner Freizeit?
Lisa: Hallo! Ich habe viele Hobbys. Am liebsten lese ich Bücher, besonders Romane und Krimis. Ich gehe auch gerne spazieren und höre Musik.
Interviewer: Das klingt interessant. Hörst du lieber deutsche oder englische Musik?
Lisa: Ich höre beide. Aber ich mag auch klassische Musik, besonders Mozart und Bach.
Interviewer: Und was machst du am Wochenende?
Lisa: Am Wochenende treffe ich oft Freunde. Wir gehen ins Kino oder machen Ausflüge. Manchmal koche ich auch gerne.''',
    duration: 90,
    questions: [
      ListeningQuestion(
        id: 'A2_002_Q1',
        type: QuestionType.multipleChoice,
        question: 'Was liest Lisa am liebsten?',
        options: ['Krimis und Romane', 'Science Fiction', 'Sachbücher', 'Comics'],
        correctAnswer: 'Krimis und Romane',
        startTime: 12,
        endTime: 20,
      ),
      ListeningQuestion(
        id: 'A2_002_Q2',
        type: QuestionType.trueFalse,
        question: 'Lisa hört nur deutsche Musik.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Falsch',
        startTime: 32,
        endTime: 40,
      ),
      ListeningQuestion(
        id: 'A2_002_Q3',
        type: QuestionType.shortAnswer,
        question: 'Was macht Lisa am Wochenende mit Freunden? (Nennen Sie zwei Aktivitäten)',
        correctAnswer: 'ins Kino gehen, Ausflüge machen',
        startTime: 55,
        endTime: 75,
        explanation: 'Lisa geht am Wochenende oft ins Kino oder macht Ausflüge mit Freunden.',
      ),
    ],
    vocabulary: 'die Freizeit - 业余时间\ndas Hobby - 爱好\nspazieren gehen - 散步\nder Ausflug - 短途旅行\nkochen - 烹饪',
  ),

  // 独白：描述一天
  ListeningMaterial(
    id: 'A2_003',
    title: 'Mein Tagesablauf',
    level: ListeningLevel.A2,
    type: ListeningType.monologue,
    topic: '日常作息',
    content: '''Ich stehe jeden Tag um 7 Uhr auf. Nach dem Aufstehen frühstücke ich. Um 8 Uhr gehe ich zur Arbeit. Ich arbeite in einem Büro. Um 12 Uhr habe ich Mittagspause. Ich esse meistens in der Kantine. Nach der Arbeit, um 17 Uhr, gehe ich manchmal einkaufen oder zum Sport. Um 19 Uhr koche ich Abendessen. Nach dem Abendessen sehe ich fern oder lese ein Buch. Um 23 Uhr gehe ich ins Bett.''',
    duration: 65,
    questions: [
      ListeningQuestion(
        id: 'A2_003_Q1',
        type: QuestionType.multipleChoice,
        question: 'Wann steht der Sprecher auf?',
        options: ['6 Uhr', '7 Uhr', '8 Uhr', '9 Uhr'],
        correctAnswer: '7 Uhr',
        startTime: 0,
        endTime: 5,
      ),
      ListeningQuestion(
        id: 'A2_003_Q2',
        type: QuestionType.trueFalse,
        question: 'Der Sprecher isst immer zu Hause.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Falsch',
        startTime: 20,
        endTime: 25,
      ),
      ListeningQuestion(
        id: 'A2_003_Q3',
        type: QuestionType.fillInBlank,
        question: 'Der Sprecher geht um _____ Uhr ins Bett.',
        options: ['22', '23', '24', '21'],
        correctAnswer: '23',
        startTime: 52,
        endTime: 58,
      ),
    ],
    vocabulary: 'aufstehen - 起床\nfrühstücken - 吃早餐\ndie Mittagspause - 午休\ndie Kantine - 食堂\nins Bett gehen - 上床睡觉',
  ),
];

/// B1级听力材料
final List<ListeningMaterial> b1Materials = [
  // 讲座：环境保护
  ListeningMaterial(
    id: 'B1_001',
    title: 'Umweltschutz',
    level: ListeningLevel.B1,
    type: ListeningType.lecture,
    topic: '环境保护',
    content: '''Guten Tag zusammen! Heute möchte ich über ein wichtiges Thema sprechen: Umweltschutz. Unsere Erde ist bedroht, und wir müssen etwas tun. Es gibt viele Möglichkeiten, umweltfreundlich zu leben.

Erstens: Energie sparen. Wir können LEDs verwenden und Geräte ausschalten, wenn wir sie nicht brauchen.

Zweitens: Müll trennen. Papier, Plastik und Glas sollten getrennt entsorgt werden. Das ist wichtig für das Recycling.

Drittens: Öffentliche Verkehrsmittel nutzen. Anstatt mit dem Auto zur Arbeit zu fahren, können wir mit dem Bus oder der Bahn fahren. Das verringert den CO2-Ausstoß.

Viertens: Weniger Fleisch essen. Die Fleischproduktion belastet die Umwelt sehr. Vegetarisches Essen ist besser für das Klima.

Denken Sie daran: Jeder kleine Schritt hilft! Vielen Dank für Ihre Aufmerksamkeit.''',
    duration: 120,
    questions: [
      ListeningQuestion(
        id: 'B1_001_Q1',
        type: QuestionType.multipleChoice,
        question: 'Was ist NICHT eine der im Text erwähnten Maßnahmen?',
        options: [
          'Energie sparen',
          'Mehr Fleisch essen',
          'Müll trennen',
          'Öffentliche Verkehrsmittel nutzen',
        ],
        correctAnswer: 'Mehr Fleisch essen',
        startTime: 0,
        endTime: 80,
      ),
      ListeningQuestion(
        id: 'B1_001_Q2',
        type: QuestionType.shortAnswer,
        question: 'Nennen Sie zwei Gründe, warum öffentliche Verkehrsmittel besser sind als das Auto.',
        correctAnswer: 'CO2-Ausstoß verringern, umweltfreundlicher',
        startTime: 45,
        endTime: 60,
        explanation: 'Öffentliche Verkehrsmittel verringern den CO2-Ausstoß und sind umweltfreundlicher als Autos.',
      ),
      ListeningQuestion(
        id: 'B1_001_Q3',
        type: QuestionType.trueFalse,
        question: 'Die Fleischproduktion belastet die Umwelt.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Richtig',
        startTime: 65,
        endTime: 72,
      ),
    ],
    vocabulary: 'der Umweltschutz - 环境保护\numweltfreundlich - 环保的\ndas Recycling - 回收利用\nder CO2-Ausstoß - 二氧化碳排放\ndie Fleischproduktion - 肉类生产',
    culturalNote: 'Deutschland legt großen Wert auf Umweltschutz. Das Recycling-System (Grüner Punkt) ist weltweit bekannt.',
  ),

  // 新闻：天气预报
  ListeningMaterial(
    id: 'B1_002',
    title: 'Wetterbericht',
    level: ListeningLevel.B1,
    type: ListeningType.news,
    topic: '天气预报',
    content: '''Guten Abend und willkommen zur Wetterschau. Hier ist die Wettervorhersage für morgen.

Im Norden Deutschlands erwartet uns wechselhaftes Wetter. In Hamburg und Bremen kann es regnen, die Temperaturen liegen zwischen 12 und 15 Grad.

Im Westen, in Nordrhein-Westfalen, ist es überwiegend bewölkt, aber meist trocken. Die Höchsttemperaturen erreichen 16 bis 18 Grad.

Im Süden, in Bayern und Baden-Württemberg, scheint zeitweise die Sonne. Es bleibt freundlich und mild mit Temperaturen bis zu 20 Grad.

Im Osten, in Berlin und Brandenburg, ist es wechselnd bewölkt. Einige Regenschauer sind möglich, die Temperaturen liegen bei 14 bis 17 Grad.

In der Nacht kühlt es auf 8 bis 11 Grad ab. Ich wünsche Ihnen einen schönen Abend!''',
    duration: 85,
    questions: [
      ListeningQuestion(
        id: 'B1_002_Q1',
        type: QuestionType.multipleChoice,
        question: 'Wie ist das Wetter im Süden?',
        options: [
          'Es regnet den ganzen Tag',
          'Es scheint zeitweise die Sonne',
          'Es ist sehr kalt',
          'Es ist stürmisch',
        ],
        correctAnswer: 'Es scheint zeitweise die Sonne',
        startTime: 38,
        endTime: 50,
      ),
      ListeningQuestion(
        id: 'B1_002_Q2',
        type: QuestionType.fillInBlank,
        question: 'Im Norden liegen die Temperaturen zwischen _____ und _____ Grad.',
        correctAnswer: '12 und 15',
        startTime: 15,
        endTime: 23,
      ),
      ListeningQuestion(
        id: 'B1_002_Q3',
        type: QuestionType.trueFalse,
        question: 'Im Westen bleibt es trocken.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Richtig',
        startTime: 24,
        endTime: 32,
      ),
    ],
    vocabulary: 'wechselhaft - 变化无常的\nüberwiegend - 主要的\nbewölkt - 多云的\nmild - 温和的\nder Regenschauer - 阵雨',
  ),

  // 对话：租房
  ListeningMaterial(
    id: 'B1_003',
    title: 'Wohnungssuche',
    level: ListeningLevel.B1,
    type: ListeningType.dialogue,
    topic: '租房',
    content: '''Vermieter: Guten Tag! Sie interessieren sich für die Wohnung?
Mieter: Ja, guten Tag! Könnten Sie mir bitte mehr darüber erzählen?
Vermieter: Natürlich. Die Wohnung hat 70 Quadratmeter, drei Zimmer, eine Küche und ein Bad.
Mieter: Wie hoch ist die Miete?
Vermieter: Die Kaltmiete beträgt 800 Euro pro Monat. Dazu kommen noch Nebenkosten von etwa 150 Euro.
Mieter: Und was ist mit der Kaution?
Vermieter: Die Kaution beträgt drei Kaltmieten, also 2400 Euro.
Mieter: Verstehe. Gibt es einen Balkon?
Vermieter: Ja, es gibt einen großen Balkon nach Süden.
Mieter: Das klingt gut. Wann kann ich die Wohnung besichtigen?
Vermieter: Morgen um 15 Uhr wäre möglich.
Mieter: Very gut, danke schön!''',
    duration: 95,
    questions: [
      ListeningQuestion(
        id: 'B1_003_Q1',
        type: QuestionType.multipleChoice,
        question: 'Wie hoch ist die Kaltmiete?',
        options: ['700 Euro', '800 Euro', '900 Euro', '1000 Euro'],
        correctAnswer: '800 Euro',
        startTime: 25,
        endTime: 32,
      ),
      ListeningQuestion(
        id: 'B1_003_Q2',
        type: QuestionType.multipleChoice,
        question: 'Wie hoch ist die Kaution?',
        options: ['1500 Euro', '2100 Euro', '2400 Euro', '3000 Euro'],
        correctAnswer: '2400 Euro',
        startTime: 40,
        endTime: 48,
      ),
      ListeningQuestion(
        id: 'B1_003_Q3',
        type: QuestionType.fillInBlank,
        question: 'Der Balkon geht nach _____.',
        options: ['Norden', 'Osten', 'Süden', 'Westen'],
        correctAnswer: 'Süden',
        startTime: 60,
        endTime: 68,
      ),
    ],
    vocabulary: 'die Miete - 租金\ndie Kaltmiete - 冷租（不含水电费）\ndie Nebenkosten - 附加费用\ndie Kaution - 押金\nbesichtigen - 参观',
    culturalNote: 'In Deutschland ist es üblich, drei Kaltmieten als Kaution zu zahlen.',
  ),
];

/// B2级听力材料
final List<ListeningMaterial> b2Materials = [
  // 讲座：数字化教育
  ListeningMaterial(
    id: 'B2_001',
    title: 'Digitalisierung im Bildungsbereich',
    level: ListeningLevel.B2,
    type: ListeningType.lecture,
    topic: '数字化教育',
    content: '''Meine sehr geehrten Damen und Herren,

heute möchte ich über ein Thema sprechen, das unsere Gesellschaft tiefgreifend verändert: die Digitalisierung im Bildungsbereich. In den letzten Jahren haben wir einen rasanten Wandel erlebt, der nicht ohne Auswirkungen auf unser Bildungssystem bleibt.

Lassen Sie mich zunächst die Chancen aufzeigen. Digitale Medien ermöglichen individuelles Lernen. Jeder Schüler kann in seinem eigenen Tempo lernen. Schwächere Schüler werden gefördert, stärkere können zusätzliche Herausforderungen finden. Zudem ermöglicht die Digitalisierung ortsunabhängiges Lernen. Vorlesungen können online abgerufen werden, was besonders für Berufstätige attraktiv ist.

Ein weiterer wichtiger Aspekt ist die Vorbereitung auf die Arbeitswelt. Digitale Kompetenzen sind heute unverzichtbar. Wer die digitalen Tools nicht beherrscht, hat auf dem Arbeitsmarkt Nachteile.

Aber wir müssen auch kritisch die Risiken betrachten. Eine Gefahr ist die digitale Spaltung. Nicht alle Schüler haben zu Hause Zugang zu digitalen Geräten. Dies könnte zu ungleichen Bildungschancen führen.

Zudem gibt es Bedenken bezüglich der Konzentration. Permanente Ablenkung durch soziale Medien und Smartphones kann das Lernen beeinträchtigen.

Ein weiteres Problem ist der Datenschutz. Schülerdaten müssen geschützt werden. Wir dürfen nicht vergessen, dass digitale Systeme auch datenschutzrechtliche Fragen aufwerfen.

Zusammenfassend lässt sich sagen: Die Digitalisierung ist unausweichlich, aber sie muss gut gestaltet werden. Wir brauchen eine_balance zwischen traditionellem und digitalem Lernen. Nur so können wir die Chancen nutzen und die Risiken minimieren.

Vielen Dank für Ihre Aufmerksamkeit. Gerne beantworte ich jetzt Ihre Fragen.''',
    duration: 180,
    questions: [
      ListeningQuestion(
        id: 'B2_001_Q1',
        type: QuestionType.shortAnswer,
        question: 'Nennen Sie drei Chancen der Digitalisierung im Bildungsbereich.',
        correctAnswer: 'individuelles Lernen, ortsunabhängiges Lernen, Vorbereitung auf die Arbeitswelt, digitale Kompetenzen',
        startTime: 20,
        endTime: 75,
        explanation: 'Der Vortragende nennt individuelle Lernmöglichkeiten, ortsunabhängiges Lernen und die Vermittlung digitaler Kompetenzen als Chancen.',
      ),
      ListeningQuestion(
        id: 'B2_001_Q2',
        type: QuestionType.multipleChoice,
        question: 'Was ist NICHT als Risiko der Digitalisierung erwähnt?',
        options: [
          'Digitale Spaltung',
          'Konzentrationsprobleme',
          'Datenschutz',
          'Hohe Kosten',
        ],
        correctAnswer: 'Hohe Kosten',
        startTime: 80,
        endTime: 130,
      ),
      ListeningQuestion(
        id: 'B2_001_Q3',
        type: QuestionType.trueFalse,
        question: 'Der Vortragende ist generell gegen die Digitalisierung.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Falsch',
        startTime: 140,
        endTime: 155,
      ),
    ],
    vocabulary: 'tiefgreifend - 深刻的\nunausweichlich - 不可避免的\ndie digitale Spaltung - 数字鸿沟\ndie Kompetenz - 能力\nunverzichtbar - 不可或缺的',
    culturalNote: 'Die Digitalisierung an deutschen Schulen wird stark diskutiert. Es gibt sowohl Befürworter als auch Kritiker.',
  ),

  // 采访：职业规划
  ListeningMaterial(
    id: 'B2_002',
    title: 'Berufliche Entwicklung',
    level: ListeningLevel.B2,
    type: ListeningType.interview,
    topic: '职业发展',
    content: '''Interviewer: Herr Müller, Sie haben erfolgreich den Berufsweg vom Azubi bis zum Abteilungsleiter gemacht. Können Sie uns Ihre Erfahrungen mitteilen?

Herr Müller: Gerne. Nach meinem Abitur habe ich zunächst eine Ausbildung zum Industriekaufmann gemacht. Das war eine gute Entscheidung, weil ich praktische Erfahrungen sammeln konnte.

Interviewer: Und wie ging es danach weiter?

Herr Müller: Nach der Ausbildung habe ich zunächst drei Jahre in meinem Beruf gearbeitet. Dann habe ich mich entschieden, ein BWL-Studium im dualen System zu beginnen. Das bedeutete, dass ich tagsüber gearbeitet habe und abends studiert habe. Das war anstrengend, aber lohnenswert.

Interviewer: Was hat Ihnen geholfen, so erfolgreich zu sein?

Herr Müller: Ich denke, Kontinuität ist wichtig. Man muss dranbleiben. Zudem habe ich immer Weiterbildungsmöglichkeiten genutzt. Zuletzt habe ich ein MBA-Programm absolviert.

Interviewer: Welche Tipps geben Sie jungen Menschen?

Herr Müller: Wichtig ist, dass man seine Ziele kennt. Man sollte wissen, was man will. Dann braucht man Geduld und Ausdauer. Nichts kommt von nichts. Und man sollte Netzwerke pflegen. Viele Möglichkeiten ergeben sich durch Kontakte.''',
    duration: 150,
    questions: [
      ListeningQuestion(
        id: 'B2_002_Q1',
        type: QuestionType.multipleChoice,
        question: 'Welche Ausbildung hat Herr Müller gemacht?',
        options: [
          'Kaufmann im Groß- und Außenhandel',
          'Industriekaufmann',
          'Bankkaufmann',
          'Informatikkaufmann',
        ],
        correctAnswer: 'Industriekaufmann',
        startTime: 15,
        endTime: 25,
      ),
      ListeningQuestion(
        id: 'B2_002_Q2',
        type: QuestionType.fillInBlank,
        question: 'Herr Müller hat ein BWL-Studium im _____ System absolviert.',
        options: ['Online', 'Dualen', 'Teilzeit', 'Vollzeit'],
        correctAnswer: 'Dualen',
        startTime: 40,
        endTime: 55,
      ),
      ListeningQuestion(
        id: 'B2_002_Q3',
        type: QuestionType.shortAnswer,
        question: 'Nennen Sie drei Tipps, die Herr Müller jungen Menschen gibt.',
        correctAnswer: 'Ziele kennen, Geduld und Ausdauer, Netzwerke pflegen, Kontinuität',
        startTime: 75,
        endTime: 130,
        explanation: 'Herr Müller empfiehlt, Ziele zu kennen, Geduld zu haben, Kontinuität zu bewahren und Netzwerke zu pflegen.',
      ),
    ],
    vocabulary: 'der Azubi - 学徒\ndie Ausbildung - 培训\nduales System - 双元制\ndie Weiterbildung - 继续教育\ndas Netzwerk - 人脉网络',
    culturalNote: 'Das duale Studium ist in Deutschland sehr beliebt. Es kombiniert theoretisches Studium mit praktischer Arbeit.',
  ),

  // 新闻：经济报道
  ListeningMaterial(
    id: 'B2_003',
    title: 'Wirtschaftsnachrichten',
    level: ListeningLevel.B2,
    type: ListeningType.news,
    topic: '经济新闻',
    content: '''Guten Tag und willkommen zu den Wirtschaftsnachrichten.

Die deutsche Wirtschaft ist im letzten Quartal um 0,3 Prozent gewachsen. Das ist besser als erwartet. Experten gehen davon aus, dass das Wirtschaftswachstum im nächsten Jahr weiter zunehmen wird.

Auf dem Arbeitsmarkt gibt es positive Nachrichten. Die Arbeitslosigkeit ist auf 5,2 Prozent gesunken. Das ist der niedrigste Stand seit fünf Jahren. Besonders stark war die Beschäftigung im Dienstleistungssektor.

Die Inflationsrate liegt derzeit bei 2,1 Prozent. Das ist leicht gestiegen, bleibt aber im Zielbereich der Europäischen Zentralbank. Experten erwarten, dass die Inflation im nächsten Jahr stabil bleiben wird.

Auf den Finanzmärkten verzeichnet der DAX leichte Gewinne. Er steht derzeit bei 16.500 Punkten. Der Euro wird gegenüber dem Dollar leicht gehandelt, bei 1,08 Dollar.

Die Automobilindustrie meldet Rekordumsätze. Grund dafür ist die starke Nachfrage nach Elektrofahrzeugen. Die deutschen Hersteller haben ihre Produktion im vergangenen Jahr um 15 Prozent gesteigert.

Das waren die Wirtschaftsnachrichten für heute. Ich wünsche Ihnen einen schönen Tag.''',
    duration: 115,
    questions: [
      ListeningQuestion(
        id: 'B2_003_Q1',
        type: QuestionType.multipleChoice,
        question: 'Um wie viel Prozent ist die deutsche Wirtschaft gewachsen?',
        options: ['0,1%', '0,2%', '0,3%', '0,4%'],
        correctAnswer: '0,3%',
        startTime: 12,
        endTime: 20,
      ),
      ListeningQuestion(
        id: 'B2_003_Q2',
        type: QuestionType.trueFalse,
        question: 'Die Arbeitslosigkeit ist gestiegen.',
        options: ['Richtig', 'Falsch'],
        correctAnswer: 'Falsch',
        startTime: 30,
        endTime: 38,
      ),
      ListeningQuestion(
        id: 'B2_003_Q3',
        type: QuestionType.fillInBlank,
        question: 'Die Inflationsrate liegt bei _____ Prozent.',
        options: ['1,8', '2,0', '2,1', '2,3'],
        correctAnswer: '2,1',
        startTime: 45,
        endTime: 52,
      ),
      ListeningQuestion(
        id: 'B2_003_Q4',
        type: QuestionType.shortAnswer,
        question: 'Warum hat die Automobilindustrie Rekordumsätze?',
        correctAnswer: 'Starke Nachfrage nach Elektrofahrzeugen',
        startTime: 75,
        endTime: 90,
        explanation: 'Die Automobilindustrie meldet Rekordumsätze wegen der starken Nachfrage nach Elektrofahrzeugen.',
      ),
    ],
    vocabulary: 'das Quartal - 季度\ndie Arbeitslosigkeit - 失业率\ndie Inflationsrate - 通胀率\nder DAX - 德国股指\ndie Nachfrage - 需求',
    culturalNote: 'Die deutsche Wirtschaft ist die größte in Europa. Der DAX ist der wichtigste deutsche Aktienindex.',
  ),
];

/// 获取所有听力材料
List<ListeningMaterial> getAllListeningMaterials() {
  return [
    ...a1Materials,
    ...a2Materials,
    ...b1Materials,
    ...b2Materials,
  ];
}

/// 根据等级获取听力材料
List<ListeningMaterial> getMaterialsByLevel(ListeningLevel level) {
  switch (level) {
    case ListeningLevel.A1:
      return a1Materials;
    case ListeningLevel.A2:
      return a2Materials;
    case ListeningLevel.B1:
      return b1Materials;
    case ListeningLevel.B2:
      return b2Materials;
  }
}

/// 根据类型获取听力材料
List<ListeningMaterial> getMaterialsByType(ListeningType type) {
  final allMaterials = getAllListeningMaterials();
  return allMaterials.where((m) => m.type == type).toList();
}

/// 根据ID获取听力材料
ListeningMaterial? getMaterialById(String id) {
  final allMaterials = getAllListeningMaterials();
  try {
    return allMaterials.firstWhere((m) => m.id == id);
  } catch (e) {
    return null;
  }
}
