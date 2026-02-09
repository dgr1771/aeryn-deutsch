/// 写作练习任务数据
library;

import '../models/writing_practice.dart';

/// A1级写作任务
final List<WritingTask> a1Tasks = [
  WritingTask(
    id: 'A1_001',
    title: 'Sich vorstellen',
    type: WritingTaskType.email,
    level: WritingLevel.A1,
    prompt: 'Schreiben Sie eine kurze E-Mail an einen neuen Freund. Stellen Sie sich vor.',
    context: 'Sie haben einen neuen Brieffreud namens Thomas.',
    minWords: 30,
    maxWords: 50,
    suggestedMinutes: 15,
    keyPoints: [
      'Name und Alter',
      'Herkunft (Woher kommst du?)',
      'Wohnort',
      'Hobbys',
      'Familie',
    ],
    usefulVocabulary: [
      'heißen - 叫做',
      'kommen aus - 来自',
      'wohnen - 居住',
      'Hobbys - 爱好',
      'Familie - 家庭',
    ],
    usefulPhrases: [
      'Ich heiße...',
      'Ich komme aus...',
      'Ich wohne in...',
      'Meine Hobbys sind...',
      'Ich habe eine Schwester/einen Bruder...',
    ],
  ),

  WritingTask(
    id: 'A1_002',
    title: 'Einladung',
    type: WritingTaskType.email,
    level: WritingLevel.A1,
    prompt: 'Schreiben Sie eine E-Mail an Ihre Freundin. Laden Sie sie zu Ihrer Geburtstagsparty ein.',
    context: 'Sie feiern nächsten Samstag Geburtstag.',
    minWords: 40,
    maxWords: 60,
    suggestedMinutes: 15,
    keyPoints: [
      'Anrede',
      'Einladung',
      'Zeit und Ort',
      'Rückmeldung',
    ],
    usefulVocabulary: [
      'einladen - 邀请',
      'Geburtstag - 生日',
      'Party - 派对',
      'Samstag - 周六',
      'Uhr - 点钟',
    ],
    usefulPhrases: [
      'Ich lade dich herzlich ein...',
      'Am Samstag feiere ich Geburtstag.',
      'Die Party beginnt um ... Uhr.',
      'Ich hoffe, du kannst kommen.',
      'Bitte gib mir Bescheid.',
    ],
  ),

  WritingTask(
    id: 'A1_003',
    title: 'Tagesablauf',
    type: WritingTaskType.description,
    level: WritingLevel.A1,
    prompt: 'Beschreiben Sie Ihren Tagesablauf.',
    context: 'Schreiben Sie, was Sie an einem normalen Tag machen.',
    minWords: 50,
    maxWords: 80,
    suggestedMinutes: 20,
    keyPoints: [
      'Aufstehen',
      'Frühstück',
      'Arbeit/Schule',
      'Mittagessen',
      'Abend',
      'Schlafen',
    ],
    usefulVocabulary: [
      'aufstehen - 起床',
      'frühstücken - 吃早餐',
      'arbeiten - 工作',
      'zu Mittag essen - 吃午饭',
      'ins Bett gehen - 睡觉',
    ],
    usefulPhrases: [
      'Ich stehe um ... Uhr auf.',
      'Um ... Uhr frühstücke ich.',
      'Dann gehe ich zur Arbeit/Schule.',
      'Am Abend...',
      'Um ... Uhr gehe ich ins Bett.',
    ],
  ),
];

/// A2级写作任务
final List<WritingTask> a2Tasks = [
  WritingTask(
    id: 'A2_001',
    title: 'Urlaub',
    type: WritingTaskType.email,
    level: WritingLevel.A2,
    prompt: 'Schreiben Sie eine E-Mail an Ihre Freundin. Erzählen Sie von Ihrem Urlaub.',
    context: 'Sie waren letzte Woche am Meer.',
    minWords: 80,
    maxWords: 120,
    suggestedMinutes: 25,
    keyPoints: [
      'Wo waren Sie?',
      'Wie lange?',
      'Mit wem?',
      'Was haben Sie gemacht?',
      'Wie war das Wetter?',
      'Gefühl',
    ],
    usefulVocabulary: [
      'der Urlaub - 假期',
      'am Meer - 在海边',
      'das Hotel - 酒店',
      'das Wetter - 天气',
      'sonnig - 晴朗的',
      'schwimmen - 游泳',
    ],
    usefulPhrases: [
      'Letzte Woche war ich im Urlaub.',
      'Ich war ... Tage in...',
      'Ich habe mit meinem Partner/ meiner Familie verreist.',
      'Wir haben viel geschwommen und gesonnen.',
      'Das Wetter war schön.',
      'Es hat mir sehr gefallen.',
    ],
  ),

  WritingTask(
    id: 'A2_002',
    title: 'Beschwerde',
    type: WritingTaskType.email,
    level: WritingLevel.A2,
    prompt: 'Schreiben Sie eine Beschwerde-E-Mail an einen Online-Shop.',
    context: 'Sie haben vor zwei Wochen ein Kleid bestellt, aber es ist noch nicht angekommen.',
    minWords: 80,
    maxWords: 100,
    suggestedMinutes: 20,
    keyPoints: [
      'Bestellung',
      'Problem',
      'Erwartung',
      'Lösung',
    ],
    usefulVocabulary: [
      'bestellen - 订购',
      'ankommen - 到达',
      'die Bestellung - 订单',
      'die Bestellnummer - 订单号',
      'nicht rechtzeitig - 不及时',
      'erstatten - 退款',
    ],
    usefulPhrases: [
      'Ich schreibe Ihnen, weil...',
      'Ich habe vor zwei Wochen ein Kleid bestellt.',
      'Meine Bestellnummer ist...',
      'Leider ist das Paket noch nicht angekommen.',
      'Ich möchte bitte mein Geld zurück erstattet bekommen.',
      'Bitte geben Sie mir Bescheid.',
    ],
  ),

  WritingTask(
    id: 'A2_003',
    title: 'Mein Traumjob',
    type: WritingTaskType.essay,
    level: WritingLevel.A2,
    prompt: 'Schreiben Sie einen kurzen Aufsatz über Ihren Traumjob.',
    context: 'Welcher Beruf ist Ihr Traumjob und warum?',
    minWords: 100,
    maxWords: 150,
    suggestedMinutes: 30,
    keyPoints: [
      'Welcher Beruf?',
      'Warum dieser Beruf?',
      'Was muss man können?',
      'Vorteile',
      'Pläne',
    ],
    usefulVocabulary: [
      'der Traumjob - 梦想工作',
      'der Beruf - 职业',
      'interessant - 有趣的',
      'hart arbeiten - 努力工作',
      'viel Geld verdienen - 赚很多钱',
      'helfen - 帮助',
    ],
    usefulPhrases: [
      'Mein Traumjob ist...',
      'Ich möchte ... werden.',
      'Dieser Beruf ist sehr interessant, weil...',
      'Man muss ... können.',
      'Ein großer Vorteil ist...',
      'In Zukunft möchte ich...',
    ],
  ),
];

/// B1级写作任务
final List<WritingTask> b1Tasks = [
  WritingTask(
    id: 'B1_001',
    title: 'Bewerbung',
    type: WritingTaskType.email,
    level: WritingLevel.B1,
    prompt: 'Schreiben Sie eine Bewerbung für eine Praktikumsstelle.',
    context: 'Sie bewerben sich für ein Praktikum bei der Firma "TechWorld".',
    minWords: 120,
    maxWords: 150,
    suggestedMinutes: 30,
    keyPoints: [
      'Anrede',
      'Warum diese Firma?',
      'Qualifikationen',
      'Erfahrung',
      'Zeitlicher Rahmen',
      'Schluss',
    ],
    usefulVocabulary: [
      'sich bewerben - 申请',
      'das Praktikum - 实习',
      'Qualifikation - 资格',
      'Erfahrung - 经验',
      'motiviert - 有动力的',
      'Team - 团队',
    ],
    usefulPhrases: [
      'Hiermit möchte ich mich um ein Praktikum bewerben.',
      'Ich habe Ihre Anzeige auf... gelesen.',
      'Ich bin besonders an Ihrer Firma interessiert, weil...',
      'Ich verfüge über Erfahrung in...',
      'Ich bin motiviert und lerne gerne.',
      'Gerne stehe ich für ein persönliches Gespräch zur Verfügung.',
    ],
  ),

  WritingTask(
    id: 'B1_002',
    title: 'Klarna um Umweltprobleme',
    type: WritingTaskType.argumentation,
    level: WritingLevel.B1,
    prompt: 'Schreiben Sie eine Erörterung zum Thema "Umweltschutz im Alltag".',
    context: 'Diskutieren Sie Vor- und Nachteile von umweltfreundlichem Verhalten.',
    minWords: 150,
    maxWords: 200,
    suggestedMinutes: 40,
    keyPoints: [
      'Einleitung',
      'Argumente für Umweltschutz',
      'Gegenargumente (Zeit, Geld)',
      'Eigene Meinung',
      'Schlussfolgerung',
    ],
    usefulVocabulary: [
      'der Umweltschutz - 环境保护',
      'umweltfreundlich - 环保的',
      'das Argument - 论点',
      'der Vorteil - 优点',
      'der Nachteil - 缺点',
      'die Schlussfolgerung - 结论',
    ],
    usefulPhrases: [
      'Heute diskutieren viele Menschen über...',
      'Ein wichtiges Argument für... ist...',
      'Andererseits muss man beachten, dass...',
      'Kritiker sagen, dass...',
      'Meiner Meinung nach ist es wichtig, weil...',
      'Zusammenfassend lässt sich sagen...',
    ],
  ),

  WritingTask(
    id: 'B1_003',
    title: 'Ein Auslandjahr',
    type: WritingTaskType.essay,
    level: WritingLevel.B1,
    prompt: 'Schreiben Sie einen Aufsatz über die Vor- und Nachteile eines Auslandsjahres.',
    context: 'Immer mehr junge Menschen verbringen ein Jahr im Ausland.',
    minWords: 150,
    maxWords: 200,
    suggestedMinutes: 35,
    keyPoints: [
      'Einleitung',
      'Vorteile',
      'Nachteile',
      'Erfahrung',
      'Empfehlung',
    ],
    usefulVocabulary: [
      'das Ausland - 国外',
      'die Erfahrung - 经验',
      'selbstständig - 独立的',
      'die Kultur - 文化',
      'die Sprache - 语言',
      'das Heimweh - 思乡',
    ],
    usefulPhrases: [
      'Ein Auslandsjahr bietet viele Vorteile.',
      'Man kann eine neue Sprache lernen.',
      'Ein weiterer wichtiger Punkt ist...',
      'Natürlich gibt es auch Nachteile.',
      'Man kann Heimweh bekommen.',
      'Ich denke, ein Auslandsjahr ist eine gute Erfahrung.',
    ],
  ),
];

/// B2级写作任务
final List<WritingTask> b2Tasks = [
  WritingTask(
    id: 'B2_001',
    title: 'Globalisierung',
    type: WritingTaskType.argumentation,
    level: WritingLevel.B2,
    prompt: 'Schreiben Sie eine Erörterung zum Thema "Globalisierung - Fluch oder Segen?".',
    context: 'Die Globalisierung verändert unsere Welt. Diskutieren Sie Auswirkungen.',
    minWords: 200,
    maxWords: 250,
    suggestedMinutes: 45,
    keyPoints: [
      'Einleitung (Definition)',
      'Wirtschaftliche Aspekte',
      'Kulturelle Aspekte',
      'Soziale Aspekte',
      'Umweltaspekte',
      'Fazit',
    ],
    usefulVocabulary: [
      'die Globalisierung - 全球化',
      'der Handel - 贸易',
      'die Auswirkung - 影响',
      'der Arbeitsmarkt - 劳动力市场',
      'kultureller Austausch - 文化交流',
      'nachhaltig - 可持续的',
    ],
    usefulPhrases: [
      'Die Globalisierung ist eines der wichtigsten Themen unserer Zeit.',
      'Dieser Aufsatz diskutiert die verschiedenen Aspekte der Globalisierung.',
      'Aus wirtschaftlicher Sicht...',
      'Ein wesentlicher Vorteil ist...',
      'Demgegenüber stehen jedoch auch...',
      'Abschließend bleibt festzustellen...',
    ],
  ),

  WritingTask(
    id: 'B2_002',
    title: 'Social Media',
    type: WritingTaskType.argumentation,
    level: WritingLevel.B2,
    prompt: 'Schreiben Sie eine kritische Auseinandersetzung mit dem Thema "Social Media und Gesellschaft".',
    context: 'Soziale Medien verändern, wie wir kommunizieren und Informationen konsumieren.',
    minWords: 200,
    maxWords: 300,
    suggestedMinutes: 50,
    keyPoints: [
      'Einleitung',
      'Veränderung der Kommunikation',
      'Informationsvermittlung',
      'Demokratie und politische Partizipation',
      'Risiken und Gefahren',
      'Fazit und Ausblick',
    ],
    usefulVocabulary: [
      'die sozialen Medien - 社交媒体',
      'die Kommunikation - 交流',
      'die Desinformation - 虚假信息',
      'die Demokratie - 民主',
      'die Partizipation - 参与',
      'die Manipulation - 操纵',
    ],
    usefulPhrases: [
      'Soziale Medien haben unsere Gesellschaft grundlegend verändert.',
      'Einerseits ermöglichen sie..., andererseits...',
      'Ein kritischer Aspekt ist...',
      'Es lässt sich nicht leugnen, dass...',
      'Vor allem junge Menschen sind von... betroffen.',
      'Zusammenfassend bleibt festzuhalten...',
    ],
  ),

  WritingTask(
    id: 'B2_003',
    title: 'Bericht über ein Projekt',
    type: WritingTaskType.report,
    level: WritingLevel.B2,
    prompt: 'Schreiben Sie einen Projektbericht über ein fiktives Gemeinschaftsprojekt.',
    context: 'Sie haben ein Projekt zur Nachbarschaftshilfe organisiert.',
    minWords: 200,
    maxWords: 250,
    suggestedMinutes: 40,
    keyPoints: [
      'Einleitung',
      'Ziele des Projekts',
      'Durchführung',
      'Ergebnisse',
      'Herausforderungen',
      'Fazit und Empfehlungen',
    ],
    usefulVocabulary: [
      'das Projekt - 项目',
      'die Nachbarschaftshilfe - 邻里互助',
      'durchführen - 执行',
      'das Ergebnis - 结果',
      'die Herausforderung - 挑战',
      'empfehlen - 推荐',
    ],
    usefulPhrases: [
      'Dieser Bericht dokumentiert das Projekt...',
      'Das Ziel war es...',
      'Das Projekt wurde im Zeitraum von... durchgeführt.',
      'Die Ergebnisse zeigen, dass...',
      'Während der Durchführung traten folgende Herausforderungen auf...',
      'Zusammenfassend kann gesagt werden...',
    ],
  ),
];

/// 写作模板
final List<WritingTemplate> writingTemplates = [
  // 邮件模板
  WritingTemplate(
    id: 'template_email',
    title: 'E-Mail schreiben',
    type: WritingTaskType.email,
    level: WritingLevel.A2,
    description: 'Struktur einer formellen E-Mail',
    structure: [
      'Betreffzeile (kurz und präzise)',
      'Anrede (Sehr geehrte Frau/Sehr geehrter Herr...)',
      'Einleitung (Warum schreiben Sie?)',
      'Hauptteil (Was ist das Anliegen?)',
      'Schluss (Was erwarten Sie?)',
      'Grußformel (Mit freundlichen Grüßen)',
      'Unterschrift',
    ],
    usefulPhrases: [
      'Ich schreibe Ihnen, weil...',
      'Ich möchte Sie bitten,...',
      'Könnten Sie mir bitte...?',
      'Ich würde mich freuen, wenn...',
      'Bitte geben Sie mir Bescheid.',
      'Vielen Dank im Voraus.',
    ],
    example: '''Betreff: Anfrage für...

Sehr geehrte Frau Müller,

ich schreibe Ihnen, weil ich mich für...

Könnten Sie mir bitte weitere Informationen schicken?

Mit freundlichen Grüßen
[Name]''',
  ),

  // 议论文模板
  WritingTemplate(
    id: 'template_argumentation',
    title: 'Erörterung schreiben',
    type: WritingTaskType.argumentation,
    level: WritingLevel.B1,
    description: 'Struktur einer Erörterung',
    structure: [
      'Einleitung (Thema vorstellen, These aufstellen)',
      'Gegenargumente darstellen und widerlegen',
      'Eigene Argumente (Pro-Argumente)',
      'Gewichtung der Argumente',
      'Schlussfolgerung (Fazit)',
    ],
    usefulPhrases: [
      'Heute wird oft diskutiert, ob...',
      'Dieser Aufsatz beschäftigt sich mit...',
      'Ein Argument gegen... ist...',
      'Demgegenüber steht jedoch...',
      'Aus diesem Grund bin ich der Meinung, dass...',
      'Zusammenfassend lässt sich sagen...',
    ],
    example: '''Einleitung:
Heute wird oft diskutiert, ob...

Gegenargumente:
Kritiker führen an, dass...
Dieses Argument ist jedoch nicht stichhaltig, weil...

Eigene Argumente:
Ein wichtiges Pro-Argument ist...
Zusätzlich zeigt sich, dass...

Schlussfolgerung:
Zusammenfassend bin ich der Meinung, dass...''',
  ),

  // 描述文模板
  WritingTemplate(
    id: 'template_description',
    title: 'Beschreibung schreiben',
    type: WritingTaskType.description,
    level: WritingLevel.A2,
    description: 'Struktur einer Beschreibung',
    structure: [
      'Einleitung (Was wird beschrieben?)',
      'Allgemeiner Eindruck',
      'Details (von oben nach unten, von links nach rechts)',
      'Persönlicher Eindruck',
    ],
    usefulPhrases: [
      'Ich möchte... beschreiben.',
      'Auffällig ist...',
      'Im Vordergrund sieht man...',
      'Besonders interessant finde ich...',
      'Mein Gesamteindruck ist...',
    ],
  ),
];

/// 获取所有写作任务
List<WritingTask> getAllWritingTasks() {
  return [
    ...a1Tasks,
    ...a2Tasks,
    ...b1Tasks,
    ...b2Tasks,
  ];
}

/// 根据等级获取写作任务
List<WritingTask> getTasksByLevel(WritingLevel level) {
  switch (level) {
    case WritingLevel.A1:
      return a1Tasks;
    case WritingLevel.A2:
      return a2Tasks;
    case WritingLevel.B1:
      return b1Tasks;
    case WritingLevel.B2:
      return b2Tasks;
  }
}

/// 根据类型获取写作任务
List<WritingTask> getTasksByType(WritingTaskType type) {
  final allTasks = getAllWritingTasks();
  return allTasks.where((t) => t.type == type).toList();
}

/// 根据ID获取写作任务
WritingTask? getTaskById(String id) {
  final allTasks = getAllWritingTasks();
  try {
    return allTasks.firstWhere((t) => t.id == id);
  } catch (e) {
    return null;
  }
}

/// 获取所有模板
List<WritingTemplate> getAllTemplates() {
  return writingTemplates;
}
