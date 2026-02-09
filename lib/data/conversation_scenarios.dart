/// 德语对话场景数据
library;

import '../models/conversation.dart';
import 'package:flutter/material.dart';

/// 所有对话场景
class ConversationScenarios {
  /// 获取所有场景
  static List<ConversationScenario> getAllScenarios() {
    return [
      // A1级别场景
      ...getA1Scenarios(),
      // A2级别场景
      ...getA2Scenarios(),
      // B1级别场景
      ...getB1Scenarios(),
      // B2级别场景
      ...getB2Scenarios(),
    ];
  }

  /// A1级别场景
  static List<ConversationScenario> getA1Scenarios() {
    return [
      ConversationScenario(
        id: 'a1_greeting',
        name: '日常问候',
        description: '学习基本的问候和自我介绍',
        level: 'A1',
        category: 'daily',
        icon: Icons.waving_hand,
        color: Colors.blue,
        keyPhrases: [
          'Hallo',
          'Guten Tag',
          'Wie geht es Ihnen?',
          'Ich heiße...',
          'Freut mich',
        ],
        introduction: 'Willkommen! In diesem Szenario üben wir grundlegende Begrüßungen und Vorstellungen. Lassen Sie uns anfangen!',
        prompts: [
          DialoguePrompt(
            german: 'Guten Tag! Ich heiße Müller. Und Sie?',
            chinese: '您好！我是穆勒先生。您呢？',
            hint: '回答你的名字',
            grammar: '动词"sein"的变位',
          ),
          DialoguePrompt(
            german: 'Wie geht es Ihnen heute?',
            chinese: '您今天好吗？',
            hint: '回答你很好',
            grammar: '日常问候表达',
          ),
          DialoguePrompt(
            german: 'Freut mich, Sie kennenzulernen.',
            chinese: '很高兴认识您。',
            hint: '回应这个问候',
            grammar: '反身动词"kennenlernen"',
          ),
        ],
      ),
      ConversationScenario(
        id: 'a1_shopping_basic',
        name: '购物基础',
        description: '在商店购物的基本对话',
        level: 'A1',
        category: 'shopping',
        icon: Icons.shopping_cart,
        color: Colors.green,
        keyPhrases: [
          'Wie viel kostet...',
          'Ich suche...',
          'Kann ich...',
          'Zu teuer',
          'Geld',
        ],
        introduction: 'Willkommen im Geschäft! Was möchten Sie kaufen? Ich helfe Ihnen gern.',
        prompts: [
          DialoguePrompt(
            german: 'Guten Tag! Kann ich Ihnen helfen?',
            chinese: '您好！需要帮助吗？',
            hint: '说你想要买东西',
            grammar: '情态动词"können"',
          ),
          DialoguePrompt(
            german: 'Was kostet das?',
            chinese: '这个多少钱？',
            hint: '说价格',
            grammar: '询问价格',
          ),
          DialoguePrompt(
            german: 'Das ist zu teuer. Haben Sie etwas Billigeres?',
            chinese: '太贵了。有便宜点的吗？',
            hint: '回应顾客',
            grammar: '形容词比较级',
          ),
        ],
      ),
      ConversationScenario(
        id: 'a1_directions',
        name: '问路',
        description: '询问和指路的基本对话',
        level: 'A1',
        category: 'travel',
        icon: Icons.directions,
        color: Colors.purple,
        keyPhrases: [
          'Wo ist...',
          'Links',
          'Rechts',
          'Geradeaus',
          'Die Straße',
        ],
        introduction: 'Sie suchen einen Ort. Lassen Sie uns nach dem Weg fragen!',
        prompts: [
          DialoguePrompt(
            german: 'Entschuldigung, wo ist der Bahnhof?',
            chinese: '请问，火车站在哪里？',
            hint: '指路',
            grammar: '疑问词"wo"',
          ),
          DialoguePrompt(
            german: 'Gehen Sie geradeaus und dann die zweite Straße links.',
            chinese: '直走，然后在第二条街左转。',
            hint: '确认方向',
            grammar: '命令式和方位词',
          ),
        ],
      ),
    ];
  }

  /// A2级别场景
  static List<ConversationScenario> getA2Scenarios() {
    return [
      ConversationScenario(
        id: 'a2_restaurant',
        name: '在餐厅',
        description: '餐厅点餐和交流',
        level: 'A2',
        category: 'restaurant',
        icon: Icons.restaurant,
        color: Colors.orange,
        keyPhrases: [
          'Die Speisekarte',
          'Ich möchte...',
          'Zum Frühstück',
          'Die Rechnung',
          'Bedienung',
        ],
        introduction: 'Guten Appetit! Sie sind in einem deutschen Restaurant. Lassen Sie uns bestellen.',
        prompts: [
          DialoguePrompt(
            german: 'Haben Sie schon gewählt?',
            chinese: '您选好了吗？',
            hint: '点餐',
            grammar: '完成时态',
          ),
          DialoguePrompt(
            german: 'Ich hätte gerne das Schnitzel mit Pommes.',
            chinese: '我要炸猪排配薯条。',
            hint: '确认订单',
            grammar: '虚拟式"würde"',
          ),
          DialoguePrompt(
            german: 'Die Rechnung, bitte!',
            chinese: '请结账！',
            hint: '结账',
            grammar: '结账用语',
          ),
        ],
      ),
      ConversationScenario(
        id: 'a2_hotel',
        name: '酒店住宿',
        description: '酒店入住和退房对话',
        level: 'A2',
        category: 'travel',
        icon: Icons.hotel,
        color: Colors.teal,
        keyPhrases: [
          'Einchecken',
          'Reservierung',
          'Zimmerschlüssel',
          'Frühstück',
          'Auschecken',
        ],
        introduction: 'Willkommen im Hotel! Haben Sie eine Reservierung?',
        prompts: [
          DialoguePrompt(
            german: 'Ja, ich habe eine Reservierung auf den Namen Müller.',
            chinese: '是的，我预订了，名字是穆勒。',
            hint: '确认预订',
            grammar: '介词"auf"',
          ),
          DialoguePrompt(
            german: 'Hier ist Ihr Zimmerschlüssel. Sie sind im zweiten Stock, Zimmer 23.',
            chinese: '这是您的钥匙。您在二楼，23号房间。',
            hint: '询问设施',
            grammar: '楼层和房间号表达',
          ),
        ],
      ),
      ConversationScenario(
        id: 'a2_doctor',
        name: '看病',
        description: '医生就诊对话',
        level: 'A2',
        category: 'daily',
        icon: Icons.local_hospital,
        color: Colors.red,
        keyPhrases: [
          'Was haben Sie für Beschwerden?',
          'Kopfweh',
          'Fieber',
          'Rezept',
          'Apotheke',
        ],
        introduction: 'Guten Tag! Was fehlt Ihnen denn heute?',
        prompts: [
          DialoguePrompt(
            german: 'Ich habe seit gestern Kopfweh und leichtes Fieber.',
            chinese: '我从昨天开始头痛，还有轻微发烧。',
            hint: '询问病情',
            grammar: '身体部位和症状',
          ),
          DialoguePrompt(
            german: 'Machen Sie bitte den Mund auf. Sagen Sie "Aaah".',
            chinese: '请张开嘴。说"啊"。',
            hint: '配合检查',
            grammar: '命令式',
          ),
        ],
      ),
    ];
  }

  /// B1级别场景
  static List<ConversationScenario> getB1Scenarios() {
    return [
      ConversationScenario(
        id: 'b1_job_interview',
        name: '求职面试',
        description: '工作面试场景',
        level: 'B1',
        category: 'work',
        icon: Icons.work,
        color: Colors.indigo,
        keyPhrases: [
          'Stellenbeschreibung',
          'Qualifikationen',
          'Erfahrung',
          'Teamarbeit',
          'Gehalt',
        ],
        introduction: 'Willkommen zum Vorstellungsgespräch! Erzählen Sie mir bitte etwas über sich selbst.',
        prompts: [
          DialoguePrompt(
            german: 'Ich habe einen Abschluss in Betriebswirtschaftslehre und zwei Jahre Berufserfahrung.',
            chinese: '我有企业管理的学位和两年的工作经验。',
            hint: '继续询问',
            grammar: '职业表达',
          ),
          DialoguePrompt(
            german: 'Warum möchten Sie bei uns arbeiten?',
            chinese: '您为什么想在我们这里工作？',
            hint: '回答动机',
            grammar: '从句结构',
          ),
        ],
      ),
      ConversationScenario(
        id: 'b1_bank',
        name: '银行事务',
        description: '在银行办理业务',
        level: 'B1',
        category: 'daily',
        icon: Icons.account_balance,
        color: Colors.brown,
        keyPhrases: [
          'Konto eröffnen',
          'Überweisung',
          'Kreditkarte',
          'Zinsen',
          'Versicherung',
        ],
        introduction: 'Guten Tag! Wie kann ich Ihnen bei Ihrem Bankanliegen helfen?',
        prompts: [
          DialoguePrompt(
            german: 'Ich möchte ein Girokonto eröffnen. Was muss ich dafür tun?',
            chinese: '我想开一个活期账户。需要做什么？',
            hint: '说明要求',
            grammar: '银行术语',
          ),
          DialoguePrompt(
            german: 'Sie brauchen nur Ihren Personalausweis und eine Meldebescheinigung.',
            chinese: '您只需要身份证和居住证明。',
            hint: '询问费用',
            grammar: '物质名词',
          ),
        ],
      ),
      ConversationScenario(
        id: 'b1_discussion',
        name: '讨论观点',
        description: '表达和讨论观点',
        level: 'B1',
        category: 'study',
        icon: Icons.forum,
        color: Colors.cyan,
        keyPhrases: [
          'Ich meine, dass...',
          'Meiner Meinung nach...',
          'Ich bin anderer Meinung',
          'Das stimme ich zu',
          'Das bezweifele ich',
        ],
        introduction: 'Lassen Sie uns über ein interessantes Thema diskutieren! Was denken Sie über...?',
        prompts: [
          DialoguePrompt(
            german: 'Meiner Meinung nach sollten wir mehr Umweltschutzmaßnahmen ergreifen.',
            chinese: '我认为我们应该采取更多环保措施。',
            hint: '回应观点',
            grammar: '表达观点的句式',
          ),
          DialoguePrompt(
            german: 'Da stimme ich Ihnen voll und ganz zu, aber...',
            chinese: '我完全同意您，但是...',
            hint: '提出不同意见',
            grammar: '连词和转折',
          ),
        ],
      ),
    ];
  }

  /// B2级别场景
  static List<ConversationScenario> getB2Scenarios() {
    return [
      ConversationScenario(
        id: 'b2_presentation',
        name: '工作演示',
        description: '职业演讲和展示',
        level: 'B2',
        category: 'work',
        icon: Icons.slideshow,
        color: Colors.deepPurple,
        keyPhrases: [
          'Geschäftsbericht',
          'Strategie',
          'Marktanalyse',
          'Ziele',
          'Erfolge',
        ],
        introduction: 'Meine Damen und Herren, herzlich willkommen zu unserer heutigen Präsentation!',
        prompts: [
          DialoguePrompt(
            german: 'Heute möchte ich Ihnen unsere Quartalsergebnisse und die künftige Strategie vorstellen.',
            chinese: '今天我想向您介绍我们的季度成果和未来战略。',
            hint: '继续演讲',
            grammar: '商务德语',
          ),
          DialoguePrompt(
            german: 'Haben Sie Fragen zu den präsentierten Zahlen?',
            chinese: '对这些数字有问题吗？',
            hint: '提问',
            grammar: '间接疑问句',
          ),
        ],
      ),
      ConversationScenario(
        id: 'b2_debate',
        name: '正式辩论',
        description: '高级话题辩论',
        level: 'B2',
        category: 'study',
        icon: Icons.gavel,
        color: Colors.amber,
        keyPhrases: [
          'Pro und Contra',
          'Argument',
          'Gegenargument',
          'Kompromiss',
          'Lösung',
        ],
        introduction: 'Wilkommen zu unserer Debatte! Das Thema heute: "Soll die digitale Bildung in Schulen Pflicht sein?"',
        prompts: [
          DialoguePrompt(
            german: 'Aus meiner Sicht ist digitale Bildung unverzichtbar für die Zukunft unserer Kinder.',
            chinese: '在我看来，数字教育对我们孩子的未来是不可或缺的。',
            hint: '反驳',
            grammar: '高级论证表达',
          ),
          DialoguePrompt(
            german: 'Ich sehe Ihren Punkt, aber ich mache mir Sorgen um die soziale Isolation.',
            chinese: '我理解您的观点，但我担心社会隔离问题。',
            hint: '寻找妥协',
            grammar: '让步和反驳',
          ),
        ],
      ),
    ];
  }

  /// 根据级别获取场景
  static List<ConversationScenario> getScenariosByLevel(String level) {
    switch (level) {
      case 'A1':
        return getA1Scenarios();
      case 'A2':
        return getA2Scenarios();
      case 'B1':
        return getB1Scenarios();
      case 'B2':
        return getB2Scenarios();
      default:
        return getAllScenarios();
    }
  }

  /// 根据类别获取场景
  static List<ConversationScenario> getScenariosByCategory(String category) {
    return getAllScenarios().where((s) => s.category == category).toList();
  }
}
