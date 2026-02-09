/// 德语语法练习题库扩展
///
/// 补充更多练习题，逐步达到1000+道题目标
library;

/// A2级别 - 动词变位扩展题
final List<Map<String, dynamic>> verbExercisesA2 = [
  // 规则动词
  {
    'question': 'Wir ___ (fahren) morgen nach Berlin',
    'correct': 'fahren',
    'options': ['fahren', 'fahrt', 'fährst', 'führt'],
    'explanation': 'fahren第一人称复数保持原形',
    'grammarPoints': ['Verben', 'Plural', 'Ablaut'],
  },
  {
    'question': '___ (du) das Buch?',
    'correct': 'Liest',
    'options': ['Liest', 'Liest', 'Leest', 'Lese'],
    'explanation': 'lesen在du人称时发生元音变化e→ie',
    'grammarPoints': ['Verben', 'Vokalwechsel', 'e→ie'],
  },
  {
    'question': 'Er ___ (sehen) den Film nicht',
    'correct': 'sieht',
    'options': ['sieht', 'siehst', 'seht', 'siehe'],
    'explanation': 'sehen在第三人称单数时e→脱落',
    'grammarPoints': ['Verben', 'e-Ausfall'],
  },
  {
    'question': 'Ich ___ (schlafen) 8 Stunden',
    'correct': 'schlafe',
    'options': ['schlafe', 'schlief', 'schläft', 'schliefst'],
    'explanation': 'schlafen在ich人称时发生回变ä→a',
    'grammarPoints': ['Verben', 'Rückumlaut', 'Umlaut'],
  },
  {
    'question': 'Das Kind ___ (essen) gerne Gemüse',
    'correct': 'isst',
    'options': ['isst', 'isst', 'esse', 'ißt'],
    'explanation': 'essen在第三人称时e→i，加-t（双ss规则）',
    'grammarPoints': ['Verben', 'Vokalwechsel', 'Doppel-s'],
  },
  {
    'question': 'Wir ___ (laufen) jeden Tag 5 km',
    'correct': 'laufen',
    'options': ['laufen', 'laufen', 'läuft', 'liefen'],
    'explanation': 'laufen复数保持原形',
    'grammarPoints': ['Verben', 'Plural'],
  },
  {
    'question': '___ (ihr) viel Deutsch?',
    'correct': 'Sprecht',
    'options': ['Sprecht', 'Sprecht', 'Sprichst', 'Sprecht'],
    'explanation': 'sprechen在ihr人称时发生元音变化e→i',
    'grammarPoints': ['Verben', 'Vokalwechsel'],
  },
  {
    'question': 'Er ___ (trinken) zu viel Kaffee',
    'correct': 'trinkt',
    'options': ['trinkt', 'trinkst', 'trinken', 'tranke'],
    'explanation': 'trinken第三人称单数去掉词干-e加-t',
    'grammarPoints': ['Verben', 'Auslautverhärtung'],
  },
  {
    'question': '___ (du) mit dem Zug?',
    'correct': 'Fährst',
    'options': ['Fährst', 'Fährst', 'Fährst', 'Führe'],
    'explanation': 'fahren在du人称时ä→äu加-st',
    'grammarPoints': ['Verben', 'Umlaut', 'Diphthong'],
  },
  {
    'question': 'Ich ___ (finden] mein Buch',
    'correct': 'finde',
    'options': ['finde', 'finde', 'findest', 'findet'],
    'explanation': 'finden在ich人称时e→d（词尾软化规则）',
    'grammarPoints': ['Verben', 'Auslautverhärtung'],
  },
];

/// B1级别 - 复杂时态扩展题
final List<Map<String, dynamic>> verbExercisesB1 = [
  // 现在完成时
  {
    'question': 'Ich ___ (haben) das Buch gelesen',
    'correct': 'habe',
    'options': ['habe', 'habt', 'hat', 'haben'],
    'explanation': 'haben的现在完成时：ich->habe',
    'grammarPoints': ['Perfekt', 'Hilfsverb', 'Partizip'],
  },
  {
    'question': 'Er ___ (sein] gestern im Kino',
    'correct': 'war',
    'options': ['war', 'gewesen', 'ist', 'hatte'],
    'explanation': 'sein的过去时：er->war',
    'grammarPoints': ['Präteritum', 'Sein'],
  },
  {
    'question': 'Wir ___ (werden) nächste Woche nach Deutschland',
    'correct': 'werden',
    'options': ['werden', 'werden', 'wurden', 'werdet'],
    'explanation': 'werden第一人称复数将来时',
    'grammarPoints': ['Futur', 'Werden'],
  },
  {
    'question': '___ (du) schon in Berlin?',
    'correct': 'Warst',
    'options': ['Warst', 'War', 'Wart', 'Warest'],
    'explanation': 'sein过去时du人称：warst',
    'grammarPoints': ['Präteritum', 'Sein'],
  },
  {
    'question': 'Sie ___ (können] das gut',
    'correct': 'konnte',
    'options': ['konnte', 'konnte', 'könnt', 'konntet'],
    'explanation': 'können过去时：konnte',
    'grammarPoints': ['Präteritum', 'Modalverb'],
  },
  {
    'question': 'Ich ___ (müssen) heute arbeiten',
    'correct': 'musste',
    'options': ['musste', 'musste', 'muss', 'müsse'],
    'explanation': 'müssen过去时：musste',
    'grammarPoints': ['Präteritum', 'Modalverb'],
  },
  {
    'question': 'Er ___ (wollen] nach Hause gehen',
    'correct': 'wollte',
    'options': ['wollte', 'wollte', 'will', 'wollte'],
    'explanation': 'wollen过去时：wollte',
    'grammarPoints': ['Präteritum', 'Modalverb'],
  },
  {
    'question': '___ (ihr) den Film gesehen?',
    'correct': 'Habt',
    'options': ['Habt', 'Habt', 'Habt', 'Haben'],
    'explanation': 'haben现在完成时ihr人称：habt',
    'grammarPoints': ['Perfekt', 'Haben'],
  },
  {
    'question': 'Es ___ (regnen] gestern den ganzen Tag',
    'correct': 'regnete',
    'options': ['regnete', 'regnete', 'regnete', 'regnete'],
    'explanation': 'regnen过去时',
    'grammarPoints': ['Präteritum', 'Wetter'],
  },
  {
    'question': 'Wir ___ (lesen] das Buch',
    'correct': 'lasen',
    'options': ['lasen', 'lasen', 'lasen', 'lasen'],
    'explanation': 'lesen过去时：lasen（复数）',
    'grammarPoints': ['Präteritum', 'Unregelmäßig'],
  },
];

/// B1级别 - 从句扩展题
final List<Map<String, dynamic>> clauseExercisesB1 = [
  {
    'question': 'Weil es ___ (regnen), bleiben wir zu Hause',
    'correct': 'regnet',
    'options': ['regnet', 'regnen', 'regnete', 'regen'],
    'explanation': 'weil从句动词在末位',
    'grammarPoints': ['Weil-Satz', 'Verbenendstellung'],
  },
  {
    'question': 'Ich weiß nicht, ___ er ___ (kommen; wann)',
    'correct': 'wann;kommt',
    'options': ['wenn;kommt', 'wann;kam', 'wann;kommt', 'wann;kommen'],
    'explanation': 'wann引导时间从句，动词在末位',
    'grammarPoints': ['Wann-Satz', 'Temporal'],
  },
  {
    'question': '___ ich Zeit habe, rufe ich dich an',
    'correct': 'Wenn',
    'options': ['Wenn', 'Wann', 'Als', 'Bevor'],
    'explanation': '条件从句用wenn引导',
    'grammarPoints': ['Konditionalsatz', 'Wenn'],
  },
  {
    'question': 'Er geht nicht aus, ___ er krank ist',
    'correct': 'weil',
    'options': ['weil', 'dass', 'ob', 'wenn'],
    'explanation': '原因从句用weil引导',
    'grammarPoints': ['Kausalsatz', 'Weil'],
  },
  {
    'question': '___ ich ihn sehe, sage ich ihm Bescheid',
    'correct': 'Sobald',
    'options': ['Sobald', 'Wenn', 'Als', 'Bevor'],
    'explanation': 'sobald表示"一...就..."',
    'grammarPoints': ['Temporalsatz', 'Sobald'],
  },
  {
    'question': 'Es ist schön, ___ du hier bist',
    'correct': 'dass',
    'options': ['dass', 'ob', 'wenn', 'als'],
    'explanation': 'dass引导内容从句',
    'grammarPoints': ['Dass-Satz'],
  },
  {
    'question': 'Ich frage mich, ___ das stimmt',
    'correct': 'ob',
    'options': ['ob', 'dass', 'wenn', 'als'],
    'explanation': 'ob引导间接问句（是否）',
    'grammarPoints': ['Ob-Satz', 'Indirekte Frage'],
  },
  {
    'question': '___ du mir hilfst, bin ich dankbar',
    'correct': 'Wenn',
    'options': ['Wenn', 'Falls', 'Sobald', 'Bevor'],
    'explanation': '条件从句，falls也是"如果"的意思',
    'grammarPoints': ['Konditionalsatz', 'Falls'],
  },
  {
    'question': 'Er telefoniert, ___ er isst',
    'correct': 'während',
    'options': ['während', 'wenn', 'als', 'bevor'],
    'explanation': 'während表示同时进行',
    'grammarPoints': ['Temporalsatz', 'Während'],
  },
  {
    'question': '___ müde bin, gehe ich schlafen',
    'correct': 'Wenn',
    'options': ['Wenn', 'Als', 'Während', 'Nachdem'],
    'explanation': '当条件满足时发生',
    'grammarPoints': ['Konditionalsatz'],
  },
];

/// A1/A2 - 名词性别扩展题
final List<Map<String, dynamic>> genderExercisesA1 = [
  {
    'question': '___ Apfel ist rot',
    'correct': 'Der',
    'options': ['Der', 'Die', 'Das', 'Den'],
    'explanation': 'Apfel阳性，der Apfel',
    'grammarPoints': ['Genus', 'Maskulin', 'Obst'],
  },
  {
    'question': '___ Banane ist gelb',
    'correct': 'Die',
    'options': ['Der', 'Die', 'Das', 'Dem'],
    'explanation': 'Banane阴性，die Banane',
    'grammarPoints': ['Genus', 'Feminin', 'Obst'],
  },
  {
    'question': '___ Brot ist frisch',
    'correct': 'Das',
    'options': ['Der', 'Die', 'Das', 'Dem'],
    'explanation': 'Brot中性，das Brot',
    'grammarPoints': ['Genus', 'Neutrum', 'Essen'],
  },
  {
    'question': '___ Tisch ist aus Holz',
    'correct': 'Der',
    'options': ['Der', 'Die', 'Das', 'Den'],
    'explanation': 'Tisch阳性，der Tisch',
    'grammarPoints': ['Genus', 'Maskulin', 'Möbel'],
  },
  {
    'question': '___ Lampe gibt Licht',
    'correct': 'Die',
    'options': ['Der', 'Die', 'Das', 'Den'],
    'explanation': 'Lampe阴性，die Lampe',
    'grammarPoints': ['Genus', 'Feminin', 'Gegenstand'],
  },
  {
    'question': '___ Buch ist interessant',
    'correct': 'Das',
    'options': ['Der', 'Die', 'Das', 'Den'],
    'explanation': 'Buch中性，das Buch',
    'grammarPoints': ['Genus', 'Neutrum', 'Medium'],
  },
  {
    'question': '___ Zeitung liegt auf dem Tisch',
    'correct': 'Die',
    'options': ['Der', 'Die', 'Das', 'Den'],
    'explanation': 'Zeitung阴性，die Zeitung',
    'grammarPoints': ['Genus', 'Feminin', 'Medien'],
  },
  {
    'question': '___ Auto ist schnell',
    'correct': 'Das',
    'options': ['Der', 'Die', 'Das', 'Den'],
    'explanation': 'Auto中性，das Auto',
    'grammarPoints': ['Genus', 'Neutrum', 'Verkehr'],
  },
  {
    'question': '___ Hund spielt im Garten',
    'correct': 'Der',
    'options': ['Der', 'Die', 'Das', 'Dem'],
    'explanation': 'Hund阳性，der Hund',
    'grammarPoints': ['Genus', 'Maskulin', 'Tier'],
  },
  {
    'question': '___ Katze schläft',
    'correct': 'Die',
    'options': ['Der', 'Die', 'Das', 'Dem'],
    'explanation': 'Katze阴性，die Katze',
    'grammarPoints': ['Genus', 'Feminin', 'Tier'],
  },
];

/// B1级别 - 介词搭配扩展题
final List<Map<String, dynamic>> prepositionExercisesB1 = [
  {
    'question': 'Ich denke ___ meine Zukunft (nachdenken)',
    'correct': 'über',
    'options': ['über', 'an', 'von', 'bei'],
    'explanation': 'nachdenken über + Akkusativ',
    'grammarPoints': ['Präposition', 'Reflexiv'],
  },
  {
    'question': 'Er besteht ___ seiner Prüfung (bestehen)',
    'correct': 'auf',
    'options': ['auf', 'in', 'an', 'über'],
    'explanation': 'bestehen auf + Dativ',
    'grammarPoints': ['Präposition', 'Dativ'],
  },
  {
    'question': 'Wir diskutieren ___ das Problem (diskutieren)',
    'correct': 'über',
    'options': ['über', 'über', 'an', 'um'],
    'explanation': 'diskutieren über + Akkusativ',
    'grammarPoints': ['Präposition', 'Akkusativ'],
  },
  {
    'question': 'Ich freue mich ___ das Geschenk (freuen)',
    'correct': 'über',
    'options': ['über', 'auf', 'an', 'für'],
    'explanation': 'sich freuen über + Akkusativ（对某事高兴）',
    'grammarPoints': ['Präposition', 'Akkusativ'],
  },
  {
    'question': 'Er klagt ___ Kopfschmerzen (klagen)',
    'correct': 'über',
    'options': ['über', 'gegen', 'um', 'bei'],
    'explanation': 'sich klagen über + Akkusativ',
    'grammarPoints': ['Präposition', 'Akkusativ'],
  },
  {
    'question': 'Ich warte ___ deine Antwort (warten)',
    'correct': 'auf',
    'options': ['auf', 'für', 'an', 'über'],
    'explanation': 'warten auf + Akkusativ',
    'grammarPoints': ['Präposition', 'Akkusativ'],
  },
  {
    'question': 'Sie leidet ___ Migräne (leiden)',
    'correct': 'an',
    'options': ['an', 'unter', 'mit', 'von'],
    'explanation': 'leiden an + Dativ（患病）',
    'grammarPoints': ['Präposition', 'Dativ', 'Krankheit'],
  },
  {
    'question': 'Er arbeitet ___ einem Projekt (arbeiten)',
    'correct': 'an',
    'options': ['an', 'auf', 'in', 'für'],
    'explanation': 'arbeiten an + Dativ',
    'grammarPoints': ['Präposition', 'Dativ'],
  },
  {
    'question': 'Wir streiten ___ Geld (streiten)',
    'correct': 'um',
    'options': ['um', 'über', 'für', 'gegen'],
    'explanation': 'streiten um + Akkusativ',
    'grammarPoints': ['Präposition', 'Akkusativ'],
  },
  {
    'question': 'Ich habe ___ dich gedacht (denken)',
    'correct': 'an',
    'options': ['an', 'über', 'von', 'bei'],
    'explanation': 'denken an + Akkusativ',
    'grammarPoints': ['Präposition', 'Akkusativ'],
  },
];

/// B2级别 - 被动语态扩展题
final List<Map<String, dynamic>> passiveExercisesB2 = [
  {
    'active': 'Der Lehrer erklärt die Grammatik',
    'passive': 'Die Grammatik wird (vom Lehrer) erklärt',
    'explanation': 'Akkusativ对象作主语，von表示动作执行者',
    'grammarPoints': ['Passiv', 'Vorgangspassiv'],
  },
  {
    'active': 'Jemand hat das Fenster geöffnet',
    'passive': 'Das Fenster ist geöffnet worden',
    'explanation': '完成时被动：sein + Partizip II + worden',
    'grammarPoints': ['Passiv', 'Perfekt', 'Worden'],
  },
  {
    'active': 'Man baut viele Häuser',
    'passive': 'Es werden viele Häuser gebaut',
    'explanation': '无人称被动句用es作形式主语',
    'grammarPoints': ['Passiv', 'Man→Es'],
  },
  {
    'active': 'Die Regierung wird das Gesetz ändern',
    'passive': 'Das Gesetz wird geändert werden',
    'explanation': '将来时被动：werden + Partizip II + werden',
    'grammarPoints': ['Passiv', 'Futur'],
  },
  {
    'active': 'Man hatte das Problem schon gelöst',
    'passive': 'Das Problem war schon gelöst worden',
    'explanation': '过去完成时被动',
    'grammarPoints': ['Passiv', 'Plusquamperfekt'],
  },
  {
    'active': 'Er lässt sich die Haare schneiden',
    'passive': 'Passiv mit lassen',
    'explanation': 'sich + lassen + Infinitiv = 让别人做',
    'grammarPoints': ['Passiv', 'Ersatzform', 'Lassen'],
  },
  {
    'active': 'Das Buch liest sich gut',
    'passive': 'Medianpassiv / Das Buch lässt sich gut lesen',
    'explanation': '中介被动：主语具有某种特性',
    'grammarPoints': ['Passiv', 'Medianpassiv'],
  },
  {
    'active': 'Dieser Fehler kann vermieden werden',
    'passive': 'Passiv mit Modalverb',
    'explanation': 'können + 被动不定式',
    'grammarPoints': ['Passiv', 'Modalverb'],
  },
  {
    'active': 'Die Tür ist geöffnet',
    'passive': 'Zustandspassiv',
    'explanation': '状态被动：sein + Partizip II表示状态',
    'grammarPoints': ['Passiv', 'Zustandspassiv'],
  },
  {
    'active': 'Die Arbeit wurde von ihm erledigt',
    'passive': 'Von-Passiv',
    'explanation': 'von + Dativ表示动作执行者',
    'grammarPoints': ['Passiv', 'Von-Dativ'],
  },
];

/// C1级别 - 复杂句法扩展题
final List<Map<String, dynamic>> complexSentencesC1 = [
  {
    'question': '___ schwierig das Problem auch ___, lösen wir es gemeinsam.',
    'correct': 'so;sein mag',
    'options': ['wie;ist', 'so;sein mag', 'je;sei', 'um;sei'],
    'explanation': 'so + adj + auch + sein mag 表示"无论多么..."',
    'grammarPoints': ['Konzessivsatz', 'Struktur'],
  },
  {
    'question': 'Je ___ er arbeitet, desto ___ müde wird er.',
    'correct': 'mehr;mehr',
    'options': ['mehr;mehr', 'länger;mehr', 'mehr;desto', 'länger;desto'],
    'explanation': 'je...desto...表示"越...越..."',
    'grammarPoints': ['Komparativ', 'Korrelativ'],
  },
  {
    'question': 'Nicht nur hat er das Buch gelesen, ___ er es auch empfohlen.',
    'correct': 'sondern',
    'options': ['sondern', 'auch', 'sondern auch', 'und'],
    'explanation': 'nicht nur...sondern auch...表示"不仅...而且..."',
    'grammarPoints': ['Konnektoren', 'Kombination'],
  },
  {
    'question': 'Es dauerte nicht lange, ___ er aufwachte.',
    'correct': 'bis',
    'options': ['bevor', 'bis', 'nachdem', 'während'],
    'explanation': 'bis表示"直到...才..."',
    'grammarPoints': ['Temporalsatz', 'Grenze'],
  },
  {
    'question': '___ ich auch lese, ich kann nicht alles verstehen.',
    'correct': 'So viel',
    'options': ['Wie sehr', 'So viel', 'Wie viel', 'So sehr'],
    'explanation': 'so viel...auch...表示"无论多少..."',
    'grammarPoints': ['Konzessivsatz', 'Quantität'],
  },
  {
    'question': 'Er kennt sich ___ Computern aus.',
    'correct': 'gut mit',
    'options': ['gut mit', 'gut auf', 'gut in', 'gut für'],
    'explanation': 'sich auskennen in + Dativ',
    'grammarPoints': ['Reflexiv', 'Dativ', 'Fähigkeit'],
  },
  {
    'question': '___ er arm auch ___, ist er sehr großzügig.',
    'correct': 'So;sei mag',
    'options': ['Wie;ist', 'So;sei mag', 'Ob;sei', 'Wenn;ist'],
    'explanation': '让步从句结构',
    'grammarPoints': ['Konzessiv'],
  },
  {
    'question': 'Es ist an der Zeit, ___ wir gehen.',
    'correct': 'dass',
    'options': ['wenn', 'dass', 'ob', 'als'],
    'explanation': 'Es ist an der Zeit + dass',
    'grammarPoints': ['Modalsatz'],
  },
  {
    'question': '___ ich das Buch ___ ___, gib es dir zurück.',
    'correct': 'Wenn;gelesen habe;sofort',
    'options': ['Wenn;gelesen habe;sofort', 'Bevor;lese;sofort', 'Sobald;gelesen habe;sofort'],
    'explanation': '完成时态在从句中的用法',
    'grammarPoints': ['Temporal', 'Perfekt'],
  },
  {
    'question': '___ es regnet, ___ ich gegangen bin.',
    'correct': 'Während;war',
    'options': ['Während;war', 'Als;war', 'Wenn;war', 'Bevor;bin'],
    'explanation': '同时发生用während，先于发生用als',
    'grammarPoints': ['Temporal', 'Gleichzeitigkeit'],
  },
];

/// A2级别 - 形容词词尾练习
final List<Map<String, dynamic>> adjectiveExercisesA2 = [
  {
    'question': 'Der ___ Mann ist alt',
    'correct': 'alte',
    'options': ['alte', 'alter', 'altes', 'alten'],
    'explanation': '定冠词der后形容词加-e',
    'grammarPoints': ['Adjektivendungen', 'Bestimmter Artikel'],
  },
  {
    'question': 'Ein ___ Haus steht dort',
    'correct': 'neues',
    'options': ['neues', 'neuer', 'neue', 'neuem'],
    'explanation': '不定冠词ein后中性形容词加-es',
    'grammarPoints': ['Adjektivendungen', 'Unbestimmter Artikel'],
  },
  {
    'question': 'Die ___ Kinder spielen',
    'correct': 'kleinen',
    'options': ['kleinen', 'kleine', 'kleiner', 'kleines'],
    'explanation': '复数定冠词die后形容词加-en',
    'grammarPoints': ['Adjektivendungen', 'Plural'],
  },
  {
    'question': 'Ich habe ___ Zeit',
    'correct': 'viel',
    'options': ['viel', 'vieles', 'viele', 'vielen'],
    'explanation': '零冠词物质名词后形容词不加词尾',
    'grammarPoints': ['Adjektivendungen', 'Nullartikel'],
  },
  {
    'question': 'Das ___ Auto ist schnell',
    'correct': 'rote',
    'options': ['rote', 'roter', 'rotes', 'roten'],
    'explanation': '定冠词das后形容词加-e',
    'grammarPoints': ['Adjektivendungen', 'Bestimmter Artikel'],
  },
  {
    'question': 'Mit ___ Freund gehe ich aus',
    'correct': 'meinem',
    'options': ['meinem', 'meinen', 'meiner', 'mein'],
    'explanation': '介词mit后接第三格，阳性单数加-em',
    'grammarPoints': ['Adjektivendungen', 'Dativ'],
  },
  {
    'question': 'Die ___ Stadt ist schön',
    'correct': 'große',
    'options': ['große', 'großer', 'großes', 'großen'],
    'explanation': '定冠词die后形容词加-e',
    'grammarPoints': ['Adjektivendungen', 'Bestimmter Artikel'],
  },
  {
    'question': '___ Wasser ist kalt',
    'correct': 'Das',
    'options': ['Das', 'Der', 'Die', 'Den'],
    'explanation': 'Wasser是中性名词',
    'grammarPoints': ['Geschlecht', 'Neutrum'],
  },
  {
    'question': 'Er ist ___ Lehrer',
    'correct': 'ein',
    'options': ['ein', 'eine', 'einen', 'einem'],
    'explanation': '职业名称阳性用ein',
    'grammarPoints': ['Berufe', 'Unbestimmter Artikel'],
  },
  {
    'question': '___ Frau ist hier',
    'correct': 'Die',
    'options': ['Die', 'Der', 'Das', 'Den'],
    'explanation': 'Frau是阴性名词',
    'grammarPoints': ['Geschlecht', 'Femininum'],
  },
];

/// B1级别 - 形容词词尾进阶
final List<Map<String, dynamic>> adjectiveExercisesB1 = [
  {
    'question': 'Der Mann, den ich gesehen habe, ist ___',
    'correct': 'alt',
    'options': ['alt', 'alter', 'alte', 'alten'],
    'explanation': '关系从句后形容词强变化，无冠词加原形',
    'grammarPoints': ['Adjektivendungen', 'Relativsatz'],
  },
  {
    'question': 'Wegen ___ Wetters bleiben wir zu Hause',
    'correct': 'des schlechten',
    'options': ['des schlechten', 'den schlechten', 'dem schlechten', 'das schlechte'],
    'explanation': '介词wegen后接第二格，形容词加-en',
    'grammarPoints': ['Adjektivendungen', 'Genitiv'],
  },
  {
    'question': 'Die ___ Schüler lernen gut',
    'correct': 'fleißigen',
    'options': ['fleißigen', 'fleißige', 'fleißiger', 'fleißiges'],
    'explanation': '定冠词die后复数形容词加-en',
    'grammarPoints': ['Adjektivendungen', 'Plural'],
  },
  {
    'question': 'Sein ___ Vater ist Arzt',
    'correct': 'älterer',
    'options': ['älterer', 'älteren', 'älteres', 'ältere'],
    'explanation': '无冠词阳性形容词比较级加-er',
    'grammarPoints': ['Adjektivendungen', 'Komparation'],
  },
  {
    'question': 'Das ___ Buch liegt auf dem Tisch',
    'correct': 'interessante',
    'options': ['interessante', 'interessanten', 'interessanter', 'interessantes'],
    'explanation': '定冠词das后形容词加-e',
    'grammarPoints': ['Adjektivendungen', 'Bestimmter Artikel'],
  },
  {
    'question': 'Wir brauchen ___ Hilfe',
    'correct': 'deine',
    'options': ['deine', 'deiner', 'deinen', 'deinem'],
    'explanation': '物主代词阴性单数加-e',
    'grammarPoints': ['Possessivartikel', 'Adjektivendungen'],
  },
  {
    'question': 'In ___ Haus wohnen viele Menschen',
    'correct': 'dem großen',
    'options': ['dem großen', 'den großen', 'das große', 'der großen'],
    'explanation': '介词in后第三格，中性加-em',
    'grammarPoints': ['Adjektivendungen', 'Dativ'],
  },
  {
    'question': 'Alle ___ Studenten bestehen die Prüfung',
    'correct': 'deutschen',
    'options': ['deutschen', 'deutsche', 'deutscher', 'deutsches'],
    'explanation': '零冠词复数形容词加-en',
    'grammarPoints': ['Adjektivendungen', 'Plural'],
  },
  {
    'question': 'Er ist ___ Mann, den ich kenne',
    'correct': 'der klügste',
    'options': ['der klügste', 'der klügere', 'dem klügsten', 'den klügeren'],
    'explanation': '最高级定冠词后加-st(e)',
    'grammarPoints': ['Superlativ', 'Adjektivendungen'],
  },
  {
    'question': 'Mit ___ Auto fährt er zur Arbeit',
    'correct': 'seinem neuen',
    'options': ['seinem neuen', 'sein neuen', 'seine neue', 'sein neuer'],
    'explanation': '介词mit第三格，中性物主代词后加-em',
    'grammarPoints': ['Possessivartikel', 'Adjektivendungen'],
  },
];

/// B2级别 - 虚拟式II练习
final List<Map<String, dynamic>> konjunktivExercisesB2 = [
  {
    'question': 'Wenn ich ___ (sein) reich, ___ (kaufen) ich ein Schloss',
    'correct': 'wäre;würde kaufen',
    'options': ['wäre;würde kaufen', 'sei;kaufte', 'wäre;kaufte', 'sei;würde kaufen'],
    'explanation': '非真实条件句用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Irrealer Konditionalsatz'],
  },
  {
    'question': 'Ich ___ (wollen), dass du kommst',
    'correct': 'wollte',
    'options': ['wollte', 'wolle', 'wollte', 'würde wollen'],
    'explanation': '情态动词Konjunktiv II形式',
    'grammarPoints': ['Konjunktiv II', 'Modalverben'],
  },
  {
    'question': 'Er ___ (können) das Problem lösen',
    'correct': 'könnte',
    'options': ['könnte', 'könne', 'kann', 'würde können'],
    'explanation': 'können的Konjunktiv II形式',
    'grammarPoints': ['Konjunktiv II', 'Modalverben'],
  },
  {
    'question': 'Wenn ich es ___ (wissen), ___ (sagen) ich es dir',
    'correct': 'wüsste;würde',
    'options': ['wüsste;würde', 'wisse;sagte', 'wüsste;sagte', 'wisse;würde sagen'],
    'explanation': 'wissen的Konjunktiv II为wüsste',
    'grammarPoints': ['Konjunktiv II', 'Hilfsverb'],
  },
  {
    'question': 'Es ___ (sein) besser, wenn du___ (kommen) würdest',
    'correct': 'wäre;kämest',
    'options': ['wäre;kämest', 'sei;kommst', 'wäre;kommst', 'sei;kämen'],
    'explanation': 'sein和kommen的Konjunktiv II形式',
    'grammarPoints': ['Konjunktiv II', 'Irrealer Vergleich'],
  },
  {
    'question': 'Ich ___ (mögen) Tee, aber Kaffee ___ (trinken) ich lieber',
    'correct': 'möchte;tränke',
    'options': ['möchte;tränke', 'möge;trinke', 'möchte;würde trinken', 'möge;tränke'],
    'explanation': 'mögen的Konjunktiv II为möchte/möge',
    'grammarPoints': ['Konjunktiv II', 'Modalverben'],
  },
  {
    'question': 'Er sagt, er ___ (machen) das',
    'correct': 'mache',
    'options': ['mache', 'macht', 'würde machen', 'gemacht habe'],
    'explanation': '间接引语用Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Indirekte Rede'],
  },
  {
    'question': 'Wenn ich du ___ (sein), ___ (gehen) ich nicht',
    'correct': 'wäre;würde gehen',
    'options': ['wäre;würde gehen', 'sei;ginge', 'wäre;ginge', 'sei;würde gehen'],
    'explanation': '非现实假设用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Irrealer Satz'],
  },
  {
    'question': 'Sie ___ (dürfen) das nicht tun',
    'correct': 'dürfte',
    'options': ['dürfte', 'dürfe', 'darf', 'dürfte'],
    'explanation': 'dürfen的Konjunktiv II形式',
    'grammarPoints': ['Konjunktiv II', 'Modalverben'],
  },
  {
    'question': '___ (haben) du mehr Geld, ___ (kaufen) du ein Auto',
    'correct': 'Hättest;würdest kaufen',
    'options': ['Hättest;würdest kaufen', 'Habest;kaufest', 'Hättest;kaufest', 'Habest;würdest kaufen'],
    'explanation': 'haben的Konjunktiv II第二人称形式',
    'grammarPoints': ['Konjunktiv II', 'Irrealer Konditionalsatz'],
  },
];

/// C1级别 - 虚拟式高级应用
final List<Map<String, dynamic>> konjunktivExercisesC1 = [
  {
    'question': 'Er fragte, ob ich ___ (kommen) ___ (können)',
    'correct': 'kommen;könne',
    'options': ['kommen;könne', 'komme;kann', 'komme;könnte', 'kommen;könnte'],
    'explanation': '间接问句中用Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Indirekte Frage'],
  },
  {
    'question': 'Es wird behauptet, dass er das Geld ___ (stehlen)',
    'correct': 'gestohlen habe',
    'options': ['gestohlen habe', 'gestohlen hat', 'gestohlen hätte', 'stehlen würde'],
    'explanation': '被动语态的间接引语用完成时Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Passiv'],
  },
  {
    'question': 'Wäre ich doch ___ (sein) reich!',
    'correct': 'nur',
    'options': ['nur', 'doch', 'doch nur', 'bloß'],
    'explanation': '愿望句的省略形式',
    'grammarPoints': ['Konjunktiv II', 'Wunschsatz'],
  },
  {
    'question': 'Man ___ (sagen), dass es ___ (regnen) werde',
    'correct': 'sage;regnen',
    'options': ['sage;regnen', 'sagt;regnet', 'sage;regnete', 'sagte;werde regnen'],
    'explanation': '被动语态的间接引语用Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Passiv'],
  },
  {
    'question': 'Ich wünschte, ich ___ (haben) mehr Zeit',
    'correct': 'hätte',
    'options': ['hätte', 'habe', 'würde haben', 'hatte'],
    'explanation': '愿望句用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Wunschsatz'],
  },
  {
    'question': 'Er tut so, als ___ (wissen) er alles',
    'correct': 'wüsste',
    'options': ['wüsste', 'weiß', 'würde wissen', 'wisse'],
    'explanation': '比较从句用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Komparativsatz'],
  },
  {
    'question': '___ (sein) dein Vorschlag besser, ___ (akzeptieren) wir ihn',
    'correct': 'Wäre;würden wir akzeptieren',
    'options': ['Wäre;würden wir akzeptieren', 'Sei;akzeptieren wir', 'Wäre;akzeptieren wir', 'Sei;würden wir akzeptieren'],
    'explanation': '非真实条件句，sein用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Konditionalsatz'],
  },
  {
    'question': 'Er gab vor, krank zu ___ (sein)',
    'correct': 'sein',
    'options': ['sein', 'gewesen sein', 'werden', 'haben'],
    'explanation': '不定式结构中sein保持原形',
    'grammarPoints': ['Konjunktiv', 'Infinitiv'],
  },
  {
    'question': 'Wenn er doch nur ___ (kommen) ___ (haben)!',
    'correct': 'wäre;gekommen',
    'options': ['wäre;gekommen', 'sei;gekommen', 'wäre;käme', 'sei;wäre gekommen'],
    'explanation': '过去愿望句用Konjunktiv II完成时',
    'grammarPoints': ['Konjunktiv II', 'Perfekt'],
  },
  {
    'question': 'Sie deutete an, dass sie es ___ (tun) ___ (werden)',
    'correct': 'tun;werde',
    'options': ['tun;werde', 'tue;wird', 'tun;würde', 'tue;würde'],
    'explanation': '间接引语将来时用Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Futur'],
  },
];

/// B1级别 - 关系从句练习
final List<Map<String, dynamic>> relativeClauseExercisesB1 = [
  {
    'question': 'Das ist das Haus, ___ ich gebaut habe',
    'correct': 'das',
    'options': ['das', 'dem', 'der', 'den'],
    'explanation': '中性先行词在从句中作宾语用das',
    'grammarPoints': ['Relativpronomen', 'Akkusativ'],
  },
  {
    'question': 'Der Mann, ___ Auto gestohlen wurde, ist sehr ärgerlich',
    'correct': 'dessen',
    'options': ['dessen', 'dem', 'deren', 'der'],
    'explanation': '所属关系用dessen（第二格）',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Die Frau, ___ ich gesehen habe, ist meine Lehrerin',
    'correct': 'die',
    'options': ['die', 'der', 'den', 'dem'],
    'explanation': '阴性先行词作宾语用die',
    'grammarPoints': ['Relativpronomen', 'Akkusativ'],
  },
  {
    'question': 'Das Kind, ___ mother ist Arzt, geht zur Schule',
    'correct': 'dessen',
    'options': ['dessen', 'dem', 'deren', 'der'],
    'explanation': '阳性先行词的所属用dessen',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Die Stadt, ___ wir besuchen, ist sehr schön',
    'correct': 'die',
    'options': ['die', 'der', 'den', 'dem'],
    'explanation': '阴性先行词作宾语用die',
    'grammarPoints': ['Relativpronomen', 'Akkusativ'],
  },
  {
    'question': 'Der Schüler, ___ Buch auf dem Tisch liegt, ist sehr fleißig',
    'correct': 'dessen',
    'options': ['dessen', 'dem', 'deren', 'der'],
    'explanation': '中性名词的所属用dessen',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Die Kinder, ___ ich helfen muss, sind sehr klein',
    'correct': 'denen',
    'options': ['denen', 'die', 'der', 'dem'],
    'explanation': '复数第三格用denen',
    'grammarPoints': ['Relativpronomen', 'Dativ Plural'],
  },
  {
    'question': 'Der Mann, ___ ich treffe, ist mein Freund',
    'correct': 'den',
    'options': ['den', 'der', 'dem', 'dessen'],
    'explanation': '阳性先行词作宾语用den',
    'grammarPoints': ['Relativpronomen', 'Akkusativ'],
  },
  {
    'question': 'Die Frau, ___ wir helfen, ist sehr alt',
    'correct': 'der',
    'options': ['der', 'die', 'den', 'deren'],
    'explanation': '阴性先行词第三格用der',
    'grammarPoints': ['Relativpronomen', 'Dativ'],
  },
  {
    'question': 'Das Kind, ___ mit dem Kind spielt, ist meine Tochter',
    'correct': 'das',
    'options': ['das', 'dem', 'der', 'den'],
    'explanation': '中性先行词作主语用das',
    'grammarPoints': ['Relativpronomen', 'Nominativ'],
  },
];

/// B2级别 - 关系从句进阶
final List<Map<String, dynamic>> relativeClauseExercisesB2 = [
  {
    'question': 'Die Stadt, in ___ ich lebe, ist groß',
    'correct': 'der',
    'options': ['der', 'die', 'das', 'den'],
    'explanation': '介词in后阴性第三格用der',
    'grammarPoints': ['Relativpronomen', 'Präposition'],
  },
  {
    'question': 'Der Mann, mit ___ ich spreche, ist mein Vater',
    'correct': 'dem',
    'options': ['dem', 'den', 'der', 'dessen'],
    'explanation': '介词mit后阳性第三格用dem',
    'grammarPoints': ['Relativpronomen', 'Präposition'],
  },
  {
    'question': 'Das Buch, für ___ ich bezahlt habe, ist interessant',
    'correct': 'das',
    'options': ['das', 'dem', 'der', 'den'],
    'explanation': '介词für后中性第四格用das',
    'grammarPoints': ['Relativpronomen', 'Präposition'],
  },
  {
    'question': 'Die Leute, mit ___ wir arbeiten, sind sehr nett',
    'correct': 'denen',
    'options': ['denen', 'den', 'der', 'die'],
    'explanation': '介词mit后复数第三格用denen',
    'grammarPoints': ['Relativpronomen', 'Präposition'],
  },
  {
    'question': 'Das Haus, auf ___ Dach wir stehen, ist hoch',
    'correct': 'dessen',
    'options': ['dessen', 'dem', 'das', 'deren'],
    'explanation': '所属关系用dessen',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Die Frau, ___ Hund beißt, ist sehr ängstlich',
    'correct': 'deren',
    'options': ['deren', 'dessen', 'der', 'die'],
    'explanation': '阴性名词的所属用deren',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Die Kinder, ___ Eltern arbeiten, gehen zur Schule',
    'correct': 'deren',
    'options': ['deren', 'denen', 'die', 'der'],
    'explanation': '复数所属用deren',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Der Student, ___ Professor berühmt ist, studiert Chemie',
    'correct': 'dessen',
    'options': ['dessen', 'dem', 'der', 'den'],
    'explanation': '阳性所属用dessen',
    'grammarPoints': ['Relativpronomen', 'Genitiv'],
  },
  {
    'question': 'Die Stadt, durch ___ wir fahren, ist alt',
    'correct': 'die',
    'options': ['die', 'der', 'das', 'denen'],
    'explanation': '介词durch后阴性第四格用die',
    'grammarPoints': ['Relativpronomen', 'Präposition'],
  },
  {
    'question': 'Die Leute, ___ ich getroffen habe, sind sehr freundlich',
    'correct': 'die',
    'options': ['die', 'denen', 'den', 'der'],
    'explanation': '复数第四格用die',
    'grammarPoints': ['Relativpronomen', 'Akkusativ'],
  },
];

/// C2级别 - 高级语法与文体练习
final List<Map<String, dynamic>> grammarExercisesC2 = [
  // 高级虚拟式
  {
    'question': 'Er tat so, als ___ er alles wissen.',
    'correct': 'hätte',
    'options': ['hätte', 'hatte', 'wisse', 'wüsste'],
    'explanation': 'als从句用Konjunktiv II，hätte是haben的虚拟式',
    'grammarPoints': ['Konjunktiv II', 'Als-Satz'],
  },
  {
    'question': '___ ich nur mehr Zeit!',
    'correct': 'Wäre',
    'options': ['Wäre', 'Hätte', 'Wäre ich', 'Hätte ich'],
    'explanation': '愿望句省略wenn，使用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Wunschsatz'],
  },
  {
    'question': 'Es wird gesagt, dass er ___ (kommen) werde.',
    'correct': 'komme',
    'options': ['komme', 'kommt', 'käme', 'käme'],
    'explanation': '间接引语用Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Indirekte Rede'],
  },
  {
    'question': 'Er___ (sein) froh, wenn er gewönne.',
    'correct': 'wäre',
    'options': ['wäre', 'sei', 'wäre', 'würde sein'],
    'explanation': '非现实条件从句用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Irrealis'],
  },
  {
    'question': '___ er das getan, wäre er stolz.',
    'correct': 'Hätte',
    'options': ['Hätte', 'Hatte', 'Wäre', 'Wäre'],
    'explanation': '完成的条件句用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Perfekt Konditional'],
  },
  {
    'question': 'Die Tat, ___ (commit) er, war schwer.',
    'correct': 'die er beging',
    'options': ['die er beging', 'den er beging', 'die er begangen hatte', 'den er begangen hatte'],
    'explanation': '关系从句后置，完成时态',
    'grammarPoints': ['Relativsatz', 'Perfekt', 'Nachfeld'],
  },
  {
    'question': '___ (Wollen) Sie mir helfen?',
    'correct': 'Würden',
    'options': ['Würden', 'Wollen', 'Wollten', 'Wollt'],
    'explanation': '礼貌请求使用Konjunktiv II',
    'grammarPoints': ['Konjunktiv II', 'Höflichkeit'],
  },
  {
    'question': 'Er ___ (mögen) eigentlich doch nicht kommen.',
    'correct': 'möchte',
    'options': ['möchte', 'mag', 'möge', 'möchte'],
    'explanation': '表示意愿用möchte（Konjunktiv II形式）',
    'grammarPoints': ['Konjunktiv II', 'Modalverb'],
  },
  {
    'question': 'Wäre ich ___ (reich) ___ (kaufen) ich ein Schloss.',
    'correct': 'reich;würde kaufen',
    'options': ['reich;würde kaufen', 'reich;kaufte', 'reich;kaufte', 'reich;würde ich kaufen'],
    'explanation': '非现实条件句，werden会变成würde',
    'grammarPoints': ['Konjunktiv II', 'Konditionalsatz', 'Ersatzform'],
  },
  {
    'question': 'Es ist an der Zeit, dass wir ___ (gehen).',
    'correct': 'gingen',
    'options': ['gingen', 'gehen', 'gehen würden', 'gegangen sind'],
    'explanation': 'es ist an der Zeit + dass + Konjunktiv I',
    'grammarPoints': ['Konjunktiv I', 'Subjektiver Satz'],
  },
];

/// 获取扩展题库
List<Map<String, dynamic>> getExtendedExercises(String type, String level) {
  switch (type) {
    case 'verb':
      if (level == 'A2') return verbExercisesA2;
      if (level == 'B1') return verbExercisesB1;
      return [];
    case 'clause':
      if (level == 'B1') return clauseExercisesB1;
      return [];
    case 'gender':
      if (level == 'A1') return genderExercisesA1;
      return [];
    case 'preposition':
      if (level == 'B1') return prepositionExercisesB1;
      return [];
    case 'passive':
      if (level == 'B2') return passiveExercisesB2;
      return [];
    case 'complex':
      if (level == 'C1') return complexSentencesC1;
      return [];
    case 'adjective':
      if (level == 'A2') return adjectiveExercisesA2;
      if (level == 'B1') return adjectiveExercisesB1;
      return [];
    case 'konjunktiv':
      if (level == 'B2') return konjunktivExercisesB2;
      if (level == 'C1') return konjunktivExercisesC1;
      if (level == 'C2') return grammarExercisesC2;
      return [];
    case 'relative':
      if (level == 'B1') return relativeClauseExercisesB1;
      if (level == 'B2') return relativeClauseExercisesB2;
      return [];
    default:
      return [];
  }
}

/// 统计扩展题库数量
Map<String, int> getExtendedExerciseCount() {
  return {
    'verbA2': verbExercisesA2.length,
    'verbB1': verbExercisesB1.length,
    'clauseB1': clauseExercisesB1.length,
    'genderA1': genderExercisesA1.length,
    'prepositionB1': prepositionExercisesB1.length,
    'passiveB2': passiveExercisesB2.length,
    'complexC1': complexSentencesC1.length,
    'adjectiveA2': adjectiveExercisesA2.length,
    'adjectiveB1': adjectiveExercisesB1.length,
    'konjunktivB2': konjunktivExercisesB2.length,
    'konjunktivC1': konjunktivExercisesC1.length,
    'konjunktivC2': grammarExercisesC2.length,
    'relativeB1': relativeClauseExercisesB1.length,
    'relativeB2': relativeClauseExercisesB2.length,
  };
}

/// 获取扩展题库总数
int getTotalExtendedExerciseCount() {
  final counts = getExtendedExerciseCount();
  return counts.values.reduce((a, b) => a + b);
}
