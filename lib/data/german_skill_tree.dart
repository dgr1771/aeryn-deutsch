/// 德语技能树预设数据
///
/// 基于CEFR标准和德语语言特点设计
library;

import '../core/learning_path/skill_tree.dart';
import '../core/grammar_engine.dart';

/// 德语技能树工厂
class GermanSkillTreeFactory {
  /// 创建A1级别技能树
  static SkillTree createA1Tree() {
    final nodes = <String, SkillNode>{};

    // ===== 词汇模块 =====

    nodes['a1_vocab_greetings'] = SkillNode(
      id: 'a1_vocab_greetings',
      name: '问候与介绍',
      description: '学习基本的问候语和自我介绍',
      type: SkillType.vocabulary,
      level: LanguageLevel.A1,
      vocabularyIds: ['hallo', 'guten_tag', 'auf_wiedersehen', 'danke', 'bitte'],
      masteryThreshold: 0.85,
      minPracticeCount: 8,
    );

    nodes['a1_vocab_numbers'] = SkillNode(
      id: 'a1_vocab_numbers',
      name: '数字1-100',
      description: '学习数字、时间、日期',
      type: SkillType.vocabulary,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings'],
      vocabularyIds: ['eins', 'zwei', 'drei', /* ... */],
      masteryThreshold: 0.85,
      minPracticeCount: 10,
    );

    nodes['a1_vocab_colors'] = SkillNode(
      id: 'a1_vocab_colors',
      name: '颜色与形状',
      description: '学习基本颜色和形状词汇',
      type: SkillType.vocabulary,
      level: LanguageLevel.A1,
      vocabularyIds: ['rot', 'blau', 'grün', /* ... */],
      masteryThreshold: 0.80,
      minPracticeCount: 5,
    );

    nodes['a1_vocab_family'] = SkillNode(
      id: 'a1_vocab_family',
      name: '家庭与称谓',
      description: '学习家庭成员和称谓',
      type: SkillType.vocabulary,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings'],
      vocabularyIds: ['vater', 'mutter', 'schwester', /* ... */],
      masteryThreshold: 0.80,
      minPracticeCount: 6,
    );

    // ===== 语法模块 =====

    nodes['a1_gram_articles'] = SkillNode(
      id: 'a1_gram_articles',
      name: '冠词der/die/das',
      description: '掌握德语三种冠词的用法',
      type: SkillType.grammar,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings', 'a1_vocab_colors'],
      exerciseIds: ['article_1', 'article_2', 'article_3'],
      masteryThreshold: 0.85,
      minPracticeCount: 10,
    );

    nodes['a1_gram_present'] = SkillNode(
      id: 'a1_gram_present',
      name: '动词现在时',
      description: '学习规则动词和不规则动词的变位',
      type: SkillType.grammar,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings'],
      exerciseIds: ['verb_present_1', 'verb_present_2'],
      masteryThreshold: 0.80,
      minPracticeCount: 8,
    );

    nodes['a1_gram_sentence'] = SkillNode(
      id: 'a1_gram_sentence',
      name: '基本句型结构',
      description: '学习陈述句、疑问句的语序',
      type: SkillType.grammar,
      level: LanguageLevel.A1,
      prerequisites: ['a1_gram_present'],
      exerciseIds: ['word_order_1', 'word_order_2'],
      masteryThreshold: 0.75,
      minPracticeCount: 7,
    );

    nodes['a1_gram_seinhaben'] = SkillNode(
      id: 'a1_gram_seinhaben',
      name: 'sein和haben',
      description: '掌握两个最重要的不规则动词',
      type: SkillType.grammar,
      level: LanguageLevel.A1,
      prerequisites: ['a1_gram_present'],
      exerciseIds: ['sein_haben_1', 'sein_haben_2'],
      masteryThreshold: 0.90,
      minPracticeCount: 12,
    );

    // ===== 阅读模块 =====

    nodes['a1_read_basic'] = SkillNode(
      id: 'a1_read_basic',
      name: '基础阅读',
      description: '阅读简短的通知、标志、邮件',
      type: SkillType.reading,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings', 'a1_gram_present'],
      readingIds: ['read_sign_1', 'read_email_1'],
      masteryThreshold: 0.75,
      minPracticeCount: 5,
    );

    // ===== 听力模块 =====

    nodes['a1_listen_numbers'] = SkillNode(
      id: 'a1_listen_numbers',
      name: '数字听力',
      description: '听懂数字、时间、价格',
      type: SkillType.listening,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_numbers'],
      masteryThreshold: 0.80,
      minPracticeCount: 8,
    );

    nodes['a1_listen_dialog'] = SkillNode(
      id: 'a1_listen_dialog',
      name: '简单对话',
      description: '听懂日常问候、购物对话',
      type: SkillType.listening,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings', 'a1_gram_present'],
      masteryThreshold: 0.75,
      minPracticeCount: 6,
    );

    // ===== 口语模块 =====

    nodes['a1_speak_greet'] = SkillNode(
      id: 'a1_speak_greet',
      name: '问候与自我介绍',
      description: '能够进行简单的问候和自我介绍',
      type: SkillType.speaking,
      level: LanguageLevel.A1,
      prerequisites: ['a1_vocab_greetings', 'a1_gram_present'],
      masteryThreshold: 0.80,
      minPracticeCount: 10,
    );

    nodes['a1_speak_pron'] = SkillNode(
      id: 'a1_speak_pron',
      name: '基础发音',
      description: '掌握德语字母和基本发音规则',
      type: SkillType.pronunciation,
      level: LanguageLevel.A1,
      masteryThreshold: 0.75,
      minPracticeCount: 15,
    );

    return SkillTree(nodes: nodes);
  }

  /// 创建A2级别技能树
  static SkillTree createA2Tree() {
    final a1Tree = createA1Tree();
    final nodes = Map<String, SkillNode>.from(a1Tree.nodes);

    // ===== 词汇扩展 =====

    nodes['a2_vocab_daily'] = SkillNode(
      id: 'a2_vocab_daily',
      name: '日常生活词汇',
      description: '学习日常生活中的常用词汇',
      type: SkillType.vocabulary,
      level: LanguageLevel.A2,
      prerequisites: ['a1_vocab_family', 'a1_vocab_colors'],
      vocabularyIds: ['kleidung', 'essen', 'wohnen', /* ... */],
      masteryThreshold: 0.75,
      minPracticeCount: 10,
    );

    nodes['a2_vocab_work'] = SkillNode(
      id: 'a2_vocab_work',
      name: '工作与职业',
      description: '学习职场相关词汇',
      type: SkillType.vocabulary,
      level: LanguageLevel.A2,
      prerequisites: ['a1_vocab_greetings'],
      vocabularyIds: ['beruf', 'arbeitsplatz', 'kollege', /* ... */],
      masteryThreshold: 0.75,
      minPracticeCount: 8,
    );

    // ===== 语法扩展 =====

    nodes['a2_gram_perfect'] = SkillNode(
      id: 'a2_gram_perfect',
      name: '现在完成时',
      description: '学习完成时的构成和用法',
      type: SkillType.grammar,
      level: LanguageLevel.A2,
      prerequisites: ['a1_gram_seinhaben', 'a1_gram_present'],
      exerciseIds: ['perfect_1', 'perfect_2', 'perfect_3'],
      masteryThreshold: 0.80,
      minPracticeCount: 10,
    );

    nodes['a2_gram_accusative'] = SkillNode(
      id: 'a2_gram_accusative',
      name: '第四格',
      description: '掌握第四格的用法',
      type: SkillType.grammar,
      level: LanguageLevel.A2,
      prerequisites: ['a1_gram_articles'],
      exerciseIds: ['accusative_1', 'accusative_2'],
      masteryThreshold: 0.80,
      minPracticeCount: 8,
    );

    nodes['a2_gram_dative'] = SkillNode(
      id: 'a2_gram_dative',
      name: '第三格',
      description: '掌握第三格的用法',
      type: SkillType.grammar,
      level: LanguageLevel.A2,
      prerequisites: ['a2_gram_accusative'],
      exerciseIds: ['dative_1', 'dative_2'],
      masteryThreshold: 0.75,
      minPracticeCount: 10,
    );

    nodes['a2_gram_prepositions'] = SkillNode(
      id: 'a2_gram_prepositions',
      name: '介词',
      description: '学习常用介词和格的配合',
      type: SkillType.grammar,
      level: LanguageLevel.A2,
      prerequisites: ['a2_gram_accusative', 'a2_gram_dative'],
      exerciseIds: ['prep_1', 'prep_2', 'prep_3'],
      masteryThreshold: 0.75,
      minPracticeCount: 12,
    );

    nodes['a2_gram_adj_end'] = SkillNode(
      id: 'a2_gram_adj_end',
      name: '形容词词尾',
      description: '掌握形容词变格',
      type: SkillType.grammar,
      level: LanguageLevel.A2,
      prerequisites: ['a1_gram_articles'],
      exerciseIds: ['adj_end_1', 'adj_end_2'],
      masteryThreshold: 0.70,
      minPracticeCount: 15,
    );

    // ===== 阅读扩展 =====

    nodes['a2_read_text'] = SkillNode(
      id: 'a2_read_text',
      name: '短文阅读',
      description: '阅读简短的文章和故事',
      type: SkillType.reading,
      level: LanguageLevel.A2,
      prerequisites: ['a2_vocab_daily', 'a2_gram_perfect'],
      readingIds: ['read_text_1', 'read_text_2'],
      masteryThreshold: 0.70,
      minPracticeCount: 8,
    );

    // ===== 口语扩展 =====

    nodes['a2_speak_daily'] = SkillNode(
      id: 'a2_speak_daily',
      name: '日常对话',
      description: '能够进行日常生活中的对话',
      type: SkillType.speaking,
      level: LanguageLevel.A2,
      prerequisites: ['a1_speak_greet', 'a2_gram_perfect'],
      masteryThreshold: 0.75,
      minPracticeCount: 12,
    );

    return SkillTree(nodes: nodes);
  }

  /// 创建B1级别技能树
  static SkillTree createB1Tree() {
    final a2Tree = createA2Tree();
    final nodes = Map<String, SkillNode>.from(a2Tree.nodes);

    // ===== B1核心技能 =====

    nodes['b1_gram_subj_sätze'] = SkillNode(
      id: 'b1_gram_subj_sätze',
      name: '从句',
      description: '学习名词从句、关系从句等',
      type: SkillType.grammar,
      level: LanguageLevel.B1,
      prerequisites: ['a2_gram_prepositions'],
      exerciseIds: ['nebensatz_1', 'nebensatz_2'],
      masteryThreshold: 0.75,
      minPracticeCount: 15,
    );

    nodes['b1_gram_passive'] = SkillNode(
      id: 'b1_gram_passive',
      name: '被动语态',
      description: '掌握被动态的构成和用法',
      type: SkillType.grammar,
      level: LanguageLevel.B1,
      prerequisites: ['a2_gram_perfect'],
      exerciseIds: ['passive_1', 'passive_2'],
      masteryThreshold: 0.75,
      minPracticeCount: 12,
    );

    nodes['b1_read_article'] = SkillNode(
      id: 'b1_read_article',
      name: '文章阅读',
      description: '阅读新闻、博客文章',
      type: SkillType.reading,
      level: LanguageLevel.B1,
      prerequisites: ['a2_read_text', 'b1_gram_subj_sätze'],
      readingIds: ['article_1', 'article_2'],
      masteryThreshold: 0.70,
      minPracticeCount: 10,
    );

    nodes['b1_write_text'] = SkillNode(
      id: 'b1_write_text',
      name: '写作基础',
      description: '能够写简单的邮件和短文',
      type: SkillType.writing,
      level: LanguageLevel.B1,
      prerequisites: ['b1_gram_subj_sätze'],
      masteryThreshold: 0.70,
      minPracticeCount: 10,
    );

    nodes['b1_speak_opinion'] = SkillNode(
      id: 'b1_speak_opinion',
      name: '表达观点',
      description: '能够表达简单的观点和意见',
      type: SkillType.speaking,
      level: LanguageLevel.B1,
      prerequisites: ['a2_speak_daily'],
      masteryThreshold: 0.70,
      minPracticeCount: 12,
    );

    return SkillTree(nodes: nodes);
  }

  /// 创建B2级别技能树
  static SkillTree createB2Tree() {
    final b1Tree = createB1Tree();
    final nodes = Map<String, SkillNode>.from(b1Tree.nodes);

    // ===== B2高级技能 =====

    nodes['b2_gram_konjunktiv'] = SkillNode(
      id: 'b2_gram_konjunktiv',
      name: '虚拟式',
      description: '学习Konjunktiv I和II',
      type: SkillType.grammar,
      level: LanguageLevel.B2,
      prerequisites: ['b1_gram_subj_sätze'],
      exerciseIds: ['konj_1', 'konj_2'],
      masteryThreshold: 0.70,
      minPracticeCount: 15,
    );

    nodes['b2_read_complex'] = SkillNode(
      id: 'b2_read_complex',
      name: '复杂文本阅读',
      description: '阅读专业文章、文学作品',
      type: SkillType.reading,
      level: LanguageLevel.B2,
      prerequisites: ['b1_read_article', 'b2_gram_konjunktiv'],
      readingIds: ['complex_1', 'complex_2'],
      masteryThreshold: 0.65,
      minPracticeCount: 12,
    );

    nodes['b2_write_formal'] = SkillNode(
      id: 'b2_write_formal',
      name: '正式写作',
      description: '能够写正式的邮件和报告',
      type: SkillType.writing,
      level: LanguageLevel.B2,
      prerequisites: ['b1_write_text'],
      masteryThreshold: 0.65,
      minPracticeCount: 15,
    );

    return SkillTree(nodes: nodes);
  }

  /// 创建完整技能树（A1-B2）
  static SkillTree createCompleteTree() {
    return createB2Tree();
  }

  /// 获取指定级别和类型的技能
  static List<SkillNode> getSkillsByLevelAndType(
    LanguageLevel level,
    SkillType type,
  ) {
    final tree = createCompleteTree();
    return tree.nodes.values
        .where((node) => node.level == level && node.type == type)
        .toList();
  }
}
