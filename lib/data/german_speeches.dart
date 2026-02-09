/// 德国演讲数据
library;

import '../models/speech_learning.dart';

/// 德国知名演讲者数据库
final List<Speaker> germanSpeakers = [
  // 政治家
  Speaker(
    id: 'merkel',
    name: 'Angela Merkel',
    gender: 'female',
    title: '前德国总理',
    organization: '德国联邦政府',
    biography: '安格拉·默克尔（Angela Merkel）是德国物理学家和政治家，2005年至2021年担任德国总理。她是德国历史上第一位女总理，被誉为"铁娘子"。',
    notableWorks: [
      '欧盟稳定机制',
      '难民政策',
      '能源转型',
      '新冠疫情防控',
    ],
  ),

  Speaker(
    id: 'scholz',
    name: 'Olaf Scholz',
    gender: 'male',
    title: '德国总理',
    organization: '德国联邦政府',
    biography: '奥拉夫·肖尔茨（Olaf Scholz）是德国政治家和律师，2021年起担任德国总理。他曾担任汉堡市长和德国副总理兼财政部长。',
    notableWorks: [
      '数字欧元',
      '气候保护',
      '欧洲一体化',
    ],
  ),

  Speaker(
    id: 'steinmeier',
    name: 'Frank-Walter Steinmeier',
    gender: 'male',
    title: '德国总统',
    organization: '德国联邦总统府',
    biography: '弗兰克-瓦尔特·施泰因迈尔（Frank-Walter Steinmeier）是德国政治家，2017年起担任德国总统。他曾担任德国副总理和外交部长。',
  ),

  Speaker(
    id: 'baerbock',
    name: 'Annalena Baerbock',
    gender: 'female',
    title: '德国外交部长',
    organization: '德国联邦外交部',
    biography: '安娜莱娜·贝尔伯克（Annalena Baerbock）是德国政治家和律师，2021年起担任德国外交部长。她是联盟90/绿党领袖。',
    notableWorks: [
      '气候变化外交',
      '欧洲安全政策',
    ],
  ),

  // 企业家和商业领袖
  Speaker(
    id: 'hopp',
    name: 'Dietmar Hopp',
    gender: 'male',
    title: 'SAP联合创始人',
    organization: 'SAP SE',
    biography: '迪特马·霍普（Dietmar Hopp）是德国企业家和软件公司SAP的联合创始人。他是德国最富有的企业家之一，也是霍恩海姆俱乐部的创始人。',
    notableWorks: [
      'SAP软件',
      '霍芬海姆足球俱乐部',
      '慈善事业',
    ],
  ),

  Speaker(
    id: 'kaeser',
    name: 'Joe Kaeser',
    gender: 'male',
    title: '西门子前CEO',
    organization: 'Siemens AG',
    biography: '乔·凯撒（Joe Kaeser）是德国商业高管，2013年至2021年担任西门子股份公司首席执行官。他推动了西门子的数字化转型。',
    notableWorks: [
      '工业4.0',
      '数字化转型',
      '可持续发展',
    ],
  ),

  Speaker(
    id: 'fratscher',
    name: 'Veronika Grimm',
    gender: 'female',
    title: '经济学家',
    organization: '埃朗根-纽伦堡大学',
    biography: '维罗尼卡·格里姆（Veronika Grimm）是德国经济学家，专注于能源经济学和环境经济学。她是德国政府"能源专家委员会"成员。',
    notableWorks: [
      '能源转型',
      '气候经济学',
    ],
  ),

  // 科学家和学者
  Speaker(
    id: 'harari',
    name: 'Yuval Noah Harari',
    gender: 'male',
    title: '历史学家',
    organization: '耶路撒冷希伯来大学',
    biography: '尤瓦尔·诺亚·哈拉瑞（Yuval Noah Harari）是以色列历史学家和作家，虽然不是德国人，但在德国有巨大影响力。他的书《人类简史》在德国畅销。',
    notableWorks: [
      '人类简史',
      '21 Lessons for the 21st Century',
    ],
  ),

  Speaker(
    id: 'schaal',
    name: 'Sandra Schaal',
    gender: 'female',
    title: '心理学家',
    organization: '慕尼黑大学',
    biography: '桑德拉·沙尔（Sandra Schaal）是德国心理学家和神经科学家，专注于大脑学习和记忆研究。她在TEDx上发表了多次演讲。',
  ),

  Speaker(
    id: 'simrock',
    name: 'Katja Simrock',
    gender: 'female',
    title: '物理学家',
    organization: '马克斯·普朗克研究所',
    biography: '卡佳·西姆罗克（Katja Simrock）是德国量子物理学家，在马克斯·普朗克研究所从事量子计算研究。她经常就科学与技术伦理发表演讲。',
  ),

  Speaker(
    id: 'sutton',
    name: 'Philipp Sutton',
    gender: 'male',
    title: '气候科学家',
    organization: '波茨坦气候影响研究所',
    biography: '菲利普·萨顿（Philipp Sutton）是德国著名气候科学家，致力于气候变化研究。他在公众演讲中强调气候保护的紧迫性。',
  ),

  // 企业家和商界领袖
  Speaker(
    id: 'klatten',
    name: 'Susanne Klatten',
    gender: 'female',
    title: '企业家',
    organization: 'Continental AG、BMW',
    biography: '苏珊·克拉滕（Susanne Klatten）是德国最富有的女性之一，拥有BMW和Continental AG的大量股份。她在商业演讲中分享企业管理经验。',
  ),

  Speaker(
    id: 'zipse',
    name: 'Oliver Zipse',
    gender: 'male',
    title: 'BMW CEO',
    organization: 'BMW集团',
    biography: '奥利弗·齐普斯（Oliver Zipse）是宝马集团董事长。他在汽车行业演讲中讨论电动化转型和可持续发展。',
  ),

  Speaker(
    id: 'mayer',
    name: 'Christian Mayer',
    gender: 'male',
    title: '企业家',
    organization: 'FTAPI Software',
    biography: '克里斯蒂安·迈耶（Christian Mayer）是德国成功的企业家和天使投资人。他在科技和创业领域的演讲激励年轻创业者。',
  ),

  Speaker(
    id: 'humble',
    name: 'Jürgen Humble',
    gender: 'male',
    title: '软件架构师',
    organization: 'ThoughtWorks',
    biography: '于尔根·汉布尔（Jürgen Humble）是德国软件架构师，在敏捷开发和软件架构领域有重要影响力。他在技术会议上经常发表演讲。',
  ),

  // 文化和艺术家
  Speaker(
    id: 'grönemeyer',
    name: 'Herbert Grönemeyer',
    gender: 'male',
    title: '音乐家',
    organization: '独立艺术家',
    biography: '赫伯特·格伦迈耶（Herbert Grönemeyer）是德国最成功的音乐家之一。他不仅在音乐上有成就，也参与社会活动。',
    notableWorks: [
      'Männer',
      'Bochum',
      'Der Mond ist aufgegangen',
    ],
  ),

  Speaker(
    id: 'schweiger',
    name: 'Til Schweiger',
    gender: 'male',
    title: '演员、导演',
    organization: '独立电影制作人',
    biography: '蒂尔·施威格（Til Schweiger）是德国著名演员和电影制片人。他是德国电影界最成功的人物之一。',
    notableWorks: [
      'Knockin\' on Heaven\'s Door',
      'Barfuss',
      'Keinohrhasen',
    ],
  ),

  Speaker(
    id: 'nina',
    name: 'Nina Hagen',
    gender: 'female',
    title: '朋克音乐家',
    organization: '独立艺术家',
    biography: '妮娜·哈根（Nina Hagen）是德国朋克音乐女王，以其独特的嗓音和风格闻名。她也活跃于社会政治活动。',
    notableWorks: [
      'TV-Glotzer',
      'African Reggae',
      'New York / New York',
    ],
  ),

  Speaker(
    id: 'winkler',
    name: 'Nadja Winkler',
    gender: 'female',
    title: '记者、主持人',
    organization: '德国电视二台 (ZDF)',
    biography: '纳佳·温克勒（Nadja Winkler）是德国知名记者和电视主持人，主持多个新闻和时事节目。她的报道风格专业深入。',
  ),

  Speaker(
    id: 'reiberger',
    name: 'Caroline Reiberger',
    gender: 'female',
    title: '记者',
    organization: '南德意志报',
    biography: '卡罗琳·赖伯格（Caroline Reiberger）是德国调查记者，为《南德意志报》撰稿。她深入报道政治和社会问题。',
  ),

  // 体育明星
  Speaker(
    id: 'neuer',
    name: 'Manuel Neuer',
    gender: 'male',
    title: '足球运动员',
    organization: '拜仁慕尼黑、德国国家队',
    biography: '曼努埃尔·诺伊尔（Manuel Neuer）是德国著名足球运动员，担任门将。他是拜仁慕尼黑和德国国家队的队长，多次接受采访。',
    notableWorks: [
      '世界杯冠军 (2014)',
      '欧冠冠军多次',
    ],
  ),

  Speaker(
    id: 'muller',
    name: 'Thomas Müller',
    gender: 'male',
    title: '足球运动员',
    organization: '拜仁慕尼黑、德国国家队',
    biography: '托马斯·穆勒（Thomas Müller）是德国足球运动员，效力于拜仁慕尼黑。他以其幽默和直接的表达风格著称。',
    notableWorks: [
      '世界杯冠军 (2014)',
      '德甲冠军多次',
    ],
  ),

  Speaker(
    id: 'popp',
    name: 'Alexandra Popp',
    gender: 'female',
    title: '足球运动员',
    organization: '沃尔夫斯堡、德国女足国家队',
    biography: '亚历山德拉·波普（Alexandra Popp）是德国女子足球运动员，担任沃尔夫斯堡和德国国家女足队队长。她积极倡导女子体育发展。',
  ),

  // 社会活动家和历史人物
  Speaker(
    id: 'brandt',
    name: 'Willy Brandt',
    gender: 'male',
    title: '前德国总理',
    organization: '德国社会民主党 (SPD)',
    biography: '维利·勃兰特（Willy Brandt）是德国前总理（1969-1974），因其东方政策和诺贝尔和平奖而闻名。他的演讲充满激情和远见。',
    notableWorks: [
      '诺贝尔和平奖 (1971)',
      'Warschauer Kniefall',
    ],
  ),

  Speaker(
    id: 'hohn',
    name: 'Carla Hohn',
    gender: 'female',
    title: '环保活动家',
    organization: 'Fridays for Future Germany',
    biography: '卡拉·洪（Carla Hohn）是德国青年环保活动家，Fridays for Future运动的组织者之一。她积极呼吁气候行动。',
  ),

  Speaker(
    id: 'schweitzer',
    name: 'Albert Schweitzer',
    gender: 'male',
    title: '神学家、医生、音乐家',
    organization: '历史人物',
    biography: '阿尔伯特·施韦泽（Albert Schweitzer）是德国神学家、医生、音乐家和哲学家，因其在非洲的医疗工作和"敬畏生命"的伦理观获得诺贝尔和平奖。',
    notableWorks: [
      '诺贝尔和平奖 (1952)',
      '敬畏生命',
    ],
  ),

  Speaker(
    id: 'arendt',
    name: 'Hannah Arendt',
    gender: 'female',
    title: '政治理论家',
    organization: '历史人物',
    biography: '汉娜·阿伦特（Hannah Arendt）是德裔美籍政治理论家，以其关于极权主义和革命的理论而闻名。她的著作和演讲深刻影响现代政治思想。',
    notableWorks: [
      '极权主义的起源',
      '人的境况',
    ],
  ),
];

/// 演讲数据库
final List<Speech> germanSpeeches = [
  // Angela Merkel 的演讲
  Speech(
    id: 'merkel_newyear_2021',
    title: 'Neujahrsansprache 2021',
    speaker: germanSpeakers.firstWhere((s) => s.id == 'merkel'),
    type: SpeechType.political,
    difficulty: SpeechDifficulty.intermediate,
    topics: [SpeechTopic.politics, SpeechTopic.society],
    speechDate: DateTime(2021, 12, 31),
    event: '德国新年致辞',
    location: '柏林',
    duration: 900, // 15分钟
    transcript: '''Meine sehr geehrten Damen und Herren,
liebe Mitbürgerinnen und Mitbürger,

wir stehen vor einem neuen Jahr. Ein Jahr, das uns allen Hoffnung schenkt.
Die Corona-Pandemie hat uns viel abverlangt. Aber wir haben zusammengehalten.

Ich danke allen, die in diesem Jahr besonders gefordert waren:
den Ärztinnen und Ärzten,
den Pflegekräften,
den Lehrerinnen und Lehrern,
und allen, die unser Land am Laufen halten.

Das nächste Jahr wird ein Jahr der Hoffnung. Mit dem Impfen beginnt ein neuer Weg.
Ich bin zuversichtlich: Wir werden diese Krise besiegen.

Auf das Jahr 2021!''',
    summary: '默克尔总理2021年新年致辞，总结2020年并展望2021年。',
    segments: [
      SpeechSegment(
        id: 'merkel_2021_1',
        startTime: 0,
        endTime: 120,
        germanText: 'Meine sehr geehrten Damen und Herren, liebe Mitbürgerinnen und Mitbürger, wir stehen vor einem neuen Jahr.',
        translation: '女士们先生们，亲爱的同胞们，我们即将迎来新的一年。',
        keyVocabulary: ['die Ansprache', 'der Mitbürger', 'stehen vor'],
      ),
      SpeechSegment(
        id: 'merkel_2021_2',
        startTime: 120,
        endTime: 240,
        germanText: 'Die Corona-Pandemie hat uns viel abverlangt. Aber wir haben zusammengehalten.',
        translation: '新冠疫情对我们要求很高。但我们团结在一起。',
        keyVocabulary: ['die Pandemie', 'abverlangen', 'zusammenhalten'],
        grammarNote: 'zusammenhalten是可分动词，在主句中分开写：haben ... zusammengehalten',
      ),
      SpeechSegment(
        id: 'merkel_2021_3',
        startTime: 240,
        endTime: 360,
        germanText: 'Ich danke allen, die in diesem Jahr besonders gefordert waren.',
        translation: '我感谢今年特别受考验的所有人。',
        keyVocabulary: ['fordern', 'besonders'],
        grammarNote: 'die gefordert waren是关系从句，修饰allen',
      ),
    ],
    keyQuotes: [
      'Wir werden diese Krise besiegen.',
      'Wir haben zusammengehalten.',
    ],
    backgroundInfo: '这是默克尔作为总理的最后几次新年致辞之一，发生在新冠疫情最严重的时期。',
  ),

  Speech(
    id: 'merkel_covid_2020',
    title: 'Ansprache zur Corona-Pandemie',
    speaker: germanSpeakers.firstWhere((s) => s.id == 'merkel'),
    type: SpeechType.political,
    difficulty: SpeechDifficulty.intermediate,
    topics: [SpeechTopic.politics, SpeechTopic.society, SpeechTopic.science],
    speechDate: DateTime(2020, 3, 18),
    event: '关于新冠疫情的电视讲话',
    location: '柏林',
    duration: 1020, // 17分钟
    transcript: '''Meine sehr geehrten Damen und Herren,

das Coronavirus verändert unser Land rapide. Es ist eine Situation, die wir in Deutschland noch nicht erlebt haben.

Ich sage Ihnen ganz offen: Es ist schwer. Es ist ernst. Und es ist ernst, seit vielen Jahren nicht mehr so ernst.

Wir müssen verstehen, dass für manche von Ihnen diese Einschränkungen eine enorme Härte bedeuten. Aber ich möchte Sie bitten: Bitte halten Sie diese Regeln ein.

Wenn wir jetzt zusammenhalten, wenn wir alle unseren Beitrag leisten, dann retten wir Leben.

Das ist unser Ziel. Das ist unsere Verantwortung.''',
    summary: '默克尔总理就新冠疫情发表的电视讲话，呼吁民众遵守防疫措施。',
    segments: [
      SpeechSegment(
        id: 'merkel_covid_1',
        startTime: 0,
        endTime: 180,
        germanText: 'Das Coronavirus verändert unser Land rapide.',
        translation: '新冠病毒正在迅速改变我们的国家。',
        keyVocabulary: ['das Coronavirus', 'schnell/rapide', 'verändern'],
        grammarNote: 'rapide是副词，表示"迅速地"',
      ),
      SpeechSegment(
        id: 'merkel_covid_2',
        startTime: 180,
        endTime: 360,
        germanText: 'Es ist schwer. Es ist ernst. Und es ist ernst, seit vielen Jahren nicht mehr so ernst.',
        translation: '这很难。这很严重。这很严重，多年来没有这么严重过。',
        keyVocabulary: ['schwer', 'ernst'],
        grammarNote: '重复使用"ist"表示强调，这是政治演讲中常用的修辞手法',
        culturalNote: '默克尔以说话谨慎、准确著称，这个演讲中她使用了重复来强调严重性',
      ),
    ],
    keyQuotes: [
      'Seit vielen Jahren nicht mehr so ernst.',
      'Wenn wir jetzt zusammenhalten, dann retten wir Leben.',
    ],
    backgroundInfo: '这是默克尔最著名的一次演讲，她对德国民众坦诚地表达了疫情的严重性，被称为"哭泣的默克尔"。',
  ),

  // Olaf Scholz 的演讲
  Speech(
    id: 'scholz_coalition_2021',
    title: 'Regierungserklärung zur Koalition',
    speaker: germanSpeakers.firstWhere((s) => s.id == 'scholz'),
    type: SpeechType.political,
    difficulty: SpeechDifficulty.advanced,
    topics: [SpeechTopic.politics, SpeechTopic.economy, SpeechTopic.innovation],
    speechDate: DateTime(2021, 12, 15),
    event: '政府声明',
    location: '德国联邦议院',
    duration: 1800, // 30分钟
    transcript: '''Sehr geehrte Frau Präsidentin! Meine sehr geehrten Damen und Herren! Liebe Mitbürgerinnen und Mitbürger!

Deutschland steht am Anfang einer neuen Legislaturperiode. Wir wollen mehr Fortschritt.
Mehr Fortschritt ist unser Programm.

Wir wollen, dass Deutschland modernisiert wird. Dass wir die großen Herausforderungen unserer Zeit meistern:
den Klimawandel,
die Digitalisierung,
den sozialen Zusammenhalt.

Deshalb haben wir eine Koalition gebildet, die diese Fortschritte möglich macht.
Eine Koalition, die aus drei Parteien besteht: SPD, Bündnis 90/Die Grünen und FDP.

Dies ist eine Neuigkeit. Das ist eine Koalition, die neue Wege geht.

Wir wollen, dass Deutschland in den nächsten Jahren besser wird.
Dafür werden wir hart arbeiten.

Deutschland soll ein Land sein, in dem man gut leben kann.
In dem alle Chancen haben.
In dem Fortschritt möglich ist.

Das ist unser Ziel. Dafür arbeiten wir.''',
    summary: '肖尔茨总理就新的三党联盟（红绿灯联盟）发表政府声明。',
    segments: [
      SpeechSegment(
        id: 'scholz_coalition_1',
        startTime: 0,
        endTime: 150,
        germanText: 'Deutschland steht am Anfang einer neuen Legislaturperiode.',
        translation: '德国站在新立法期的开始。',
        keyVocabulary: ['die Legislaturperiode', 'der Anfang'],
      ),
      SpeechSegment(
        id: 'scholz_coalition_2',
        startTime: 150,
        endTime: 300,
        germanText: 'Wir wollen mehr Fortschritt. Mehr Fortschritt ist unser Programm.',
        translation: '我们想要更多进步。更多进步是我们的纲领。',
        keyVocabulary: ['der Fortschritt', 'das Programm'],
        grammarNote: '重复使用"Fortschritt"是为了强调',
      ),
    ],
    keyQuotes: [
      'Mehr Fortschritt ist unser Programm.',
      'Wir wollen, dass Deutschland besser wird.',
    ],
  ),

  // TEDx 演讲
  Speech(
    id: 'tedx_climate_2020',
    title: 'Climate Change and Our Future',
    speaker: germanSpeakers.firstWhere((s) => s.id == 'fratscher'),
    type: SpeechType.tedTalk,
    difficulty: SpeechDifficulty.advanced,
    topics: [SpeechTopic.environment, SpeechTopic.science],
    speechDate: DateTime(2020, 9, 15),
    event: 'TEDx Munich',
    location: '慕尼黑',
    duration: 1080, // 18分钟
    transcript: '''Hello everyone!

Today I want to talk about climate change. Not about whether it's real or not - it is real.
But about what we can do. What Germany is doing. And what we all can do together.

The energy transition in Germany is a huge project. We call it "Energiewende".
It started more than 20 years ago. And today we produce more than 40% of our electricity from renewable sources.

But is that enough? No, it's not enough.

We need to do more. We need to change how we live, how we work, how we travel.
Climate change is not just an environmental problem. It's a challenge for our entire society.

The good news is: We have the technology. We have the solutions.
We know what to do. We just need to do it.

So what can you do?
- Use less energy
- Buy sustainable products
- Support climate-friendly policies
- Talk to others about climate change

Every action counts. Together we can make a difference.

Thank you.''',
    summary: '经济学家Veronika Grimm在TEDx慕尼黑关于气候变化的演讲。',
    segments: [
      SpeechSegment(
        id: 'tedx_climate_1',
        startTime: 0,
        endTime: 180,
        germanText: 'The energy transition in Germany is a huge project. We call it "Energiewende".',
        translation: '德国的能源转型是一个巨大的项目。我们称之为"Energiewende"。',
        keyVocabulary: ['die Energiewende', 'der Übergang', 'das Projekt'],
        culturalNote: 'Energiewende是德国特有的词汇，指能源转型政策，从核能和化石燃料转向可再生能源',
      ),
      SpeechSegment(
        id: 'tedx_climate_2',
        startTime: 180,
        endTime: 360,
        germanText: 'Today we produce more than 40% of our electricity from renewable sources.',
        translation: '今天我们从可再生能源产生超过40%的电力。',
        keyVocabulary: ['der Strom', 'erneuerbar', 'die Energiequelle'],
        grammarNote: 'more than 40%表示"超过40%"',
      ),
    ],
    keyQuotes: [
      'Every action counts.',
      'Together we can make a difference.',
    ],
  ),

  // 商业演讲
  Speech(
    id: 'kaeser_digital_2019',
    title: 'The Future of German Industry',
    speaker: germanSpeakers.firstWhere((s) => s.id == 'kaeser'),
    type: SpeechType.business,
    difficulty: SpeechDifficulty.expert,
    topics: [SpeechTopic.technology, SpeechTopic.innovation, SpeechTopic.economy],
    speechDate: DateTime(2019, 11, 20),
    event: '工业4.0峰会',
    location: '柏林',
    duration: 1500, // 25分钟
    transcript: '''Guten Tag!

Es ist mir eine Freude, heute hier zu sein. Über die Zukunft der deutschen Industrie zu sprechen.

Wir stehen an einem entscheidenden Punkt. Die digitale Transformation verändert alles.
Was wir heute tun, bestimmt, wie wir morgen wettbewerbsfähig sind.

Industrie 4.0 ist kein Schlagwort mehr. Es ist Realität.
In unseren Fabriken arbeiten Menschen und Maschinen zusammen.
Daten fließen in Echtzeit.
Produkte werden individualisiert.

Das ist die Zukunft. Und diese Zukunft ist jetzt.

Aber wir müssen weitergehen. Digitalisierung ist kein Selbstzweck.
Es geht um Wertschöpfung. Es geht um Wettbewerbsfähigkeit.
Es geht um Arbeitsplätze.

Deshalb investiert Siemens massiv in Forschung und Entwicklung.
Wir arbeiten mit Startups zusammen.
Wir bilden unsere Mitarbeiter weiter.

Deutschland kann ein Vorreiter sein. Wenn wir zusammenarbeiten.
Wenn wir Innovationen vorantreiben. Wenn wir nicht zögern, sondern handeln.

Die Zukunft gehört denen, die sie gestalten.

Vielen Dank.''',
    summary: '西门子前CEO Joe Kaeser关于德国工业4.0和数字化转型的演讲。',
    segments: [
      SpeechSegment(
        id: 'kaeser_1',
        startTime: 0,
        endTime: 120,
        germanText: 'Die digitale Transformation verändert alles.',
        translation: '数字化转型正在改变一切。',
        keyVocabulary: ['die Transformation', 'verändern', 'alles'],
        grammarNote: 'verändert是及物动词，直接接宾语',
      ),
      SpeechSegment(
        id: 'kaeser_2',
        startTime: 120,
        endTime: 240,
        germanText: 'Industrie 4.0 ist kein Schlagwort mehr. Es ist Realität.',
        translation: '工业4.0不再是个口号。它是现实。',
        keyVocabulary: ['Industrie 4.0', 'das Schlagwort', 'die Realität'],
        culturalNote: 'Industrie 4.0是德国提出的一个概念，指第四次工业革命，强调智能制造',
      ),
      SpeechSegment(
        id: 'kaeser_3',
        startTime: 240,
        endTime: 360,
        germanText: 'Die Zukunft gehört denen, die sie gestalten.',
        translation: '未来属于那些创造未来的人。',
        keyVocabulary: ['die Zukunft', 'gehören', 'gestalten'],
        culturalNote: '这是德国著名哲学思想，强调行动和创造',
      ),
    ],
    keyQuotes: [
      'Die Zukunft gehört denen, die sie gestalten.',
      'Wir stehen an einem entscheidenden Punkt.',
    ],
  ),
];

/// 获取所有演讲
List<Speech> getAllSpeeches() {
  return germanSpeeches;
}

/// 根据难度获取演讲
List<Speech> getSpeechesByDifficulty(SpeechDifficulty difficulty) {
  return germanSpeeches.where((s) => s.difficulty == difficulty).toList();
}

/// 根据主题获取演讲
List<Speech> getSpeechesByTopic(SpeechTopic topic) {
  return germanSpeeches.where((s) => s.topics.contains(topic)).toList();
}

/// 根据演讲者获取演讲
List<Speech> getSpeechesBySpeaker(String speakerId) {
  return germanSpeeches.where((s) => s.speaker.id == speakerId).toList();
}

/// 根据性别获取演讲者
List<Speaker> getSpeakersByGender(String gender) {
  return germanSpeakers.where((s) => s.gender == gender).toList();
}

/// 获取最受欢迎的演讲者
List<Speaker> getPopularSpeakers({int limit = 10}) {
  return germanSpeakers.take(limit).toList();
}

/// 根据ID获取演讲
Speech? getSpeechById(String id) {
  try {
    return germanSpeeches.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
}

/// 根据ID获取演讲者
Speaker? getSpeakerById(String id) {
  try {
    return germanSpeakers.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
}
