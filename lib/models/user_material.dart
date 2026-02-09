/// 用户自定义学习材料模型
library;

/// 材料类型
enum UserMaterialType {
  vocabulary,      // 词汇表
  grammarNote,     // 语法笔记
  reading,         // 阅读材料
  audio,           // 音频
  video,           // 视频
  flashcard,       // 抽认卡
  exercise,        // 练习题
  other,           // 其他
}

/// 材料格式
enum MaterialFormat {
  csv,             // CSV文件
  json,            // JSON文件
  markdown,        // Markdown文件
  txt,             // 文本文件
  pdf,             // PDF文件
  mp3,             // MP3音频
  mp4,             // MP4视频
  anki,            // Anki牌组
  quizlet,         // Quizlet
  image,           // 图片
}

/// 文件夹
class MaterialFolder {
  final String id;
  final String name;
  final String? parentId;               // 父文件夹ID
  final String? color;                 // 文件夹颜色（用于UI）
  final int order;                     // 排序
  final DateTime createdAt;

  MaterialFolder({
    required this.id,
    required this.name,
    this.parentId,
    this.color,
    required this.order,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'color': color,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MaterialFolder.fromJson(Map<String, dynamic> json) {
    return MaterialFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      color: json['color'] as String?,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// 词汇条目
class VocabularyEntry {
  final String id;
  final String word;                    // 德语单词
  final String? article;                // 冠词（der/die/das）
  final String meaning;                 // 中文释义
  final String? example;                // 例句（德语）
  final String? translation;            // 例句翻译
  final List<String>? synonyms;         // 同义词
  final List<String>? antonyms;         // 反义词
  final String? partOfSpeech;           // 词性
  final String? difficultyLevel;        // 难度级别 (A1/A2/B1/B2)
  final List<String>? tags;             // 标签
  final String? mnemonic;               // 助记符
  final String? notes;                  // 备注
  final DateTime createdAt;

  VocabularyEntry({
    required this.id,
    required this.word,
    this.article,
    required this.meaning,
    this.example,
    this.translation,
    this.synonyms,
    this.antonyms,
    this.partOfSpeech,
    this.difficultyLevel,
    this.tags,
    this.mnemonic,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'article': article,
      'meaning': meaning,
      'example': example,
      'translation': translation,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'partOfSpeech': partOfSpeech,
      'difficultyLevel': difficultyLevel,
      'tags': tags,
      'mnemonic': mnemonic,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VocabularyEntry.fromJson(Map<String, dynamic> json) {
    return VocabularyEntry(
      id: json['id'] as String,
      word: json['word'] as String,
      article: json['article'] as String?,
      meaning: json['meaning'] as String,
      example: json['example'] as String?,
      translation: json['translation'] as String?,
      synonyms: (json['synonyms'] as List<dynamic?>?)?.cast<String>(),
      antonyms: (json['antonyms'] as List<dynamic?>?)?.cast<String>(),
      partOfSpeech: json['partOfSpeech'] as String?,
      difficultyLevel: json['difficultyLevel'] as String?,
      tags: (json['tags'] as List<dynamic?>?)?.cast<String>(),
      mnemonic: json['mnemonic'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// 语法笔记
class GrammarNote {
  final String id;
  final String title;
  final String content;                 // Markdown格式
  final List<String>? tags;
  final String? category;               // 分类：动词变位、名词格变等
  final String? level;                  // A1/A2/B1/B2
  final List<String>? examples;         // 示例
  final DateTime createdAt;
  final DateTime? lastModified;

  GrammarNote({
    required this.id,
    required this.title,
    required this.content,
    this.tags,
    this.category,
    this.level,
    this.examples,
    required this.createdAt,
    this.lastModified,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'category': category,
      'level': level,
      'examples': examples,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  factory GrammarNote.fromJson(Map<String, dynamic> json) {
    return GrammarNote(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic?>?)?.cast<String>(),
      category: json['category'] as String?,
      level: json['level'] as String?,
      examples: (json['examples'] as List<dynamic?>?)?.cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
    );
  }
}

/// 抽认卡
class Flashcard {
  final String id;
  final String front;                   // 正面（问题）
  final String back;                    // 背面（答案）
  final String? hint;                   // 提示
  final String? notes;                  // 笔记
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? nextReview;           // 下次复习时间
  final int? intervalDays;             // 复习间隔（天）
  final double? easeFactor;             // 难度因子（FSRS算法）

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.hint,
    this.notes,
    this.tags,
    required this.createdAt,
    this.nextReview,
    this.intervalDays,
    this.easeFactor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'hint': hint,
      'notes': notes,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'nextReview': nextReview?.toIso8601String(),
      'intervalDays': intervalDays,
      'easeFactor': easeFactor,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      hint: json['hint'] as String?,
      notes: json['notes'] as String?,
      tags: (json['tags'] as List<dynamic?>?)?.cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      nextReview: json['nextReview'] != null
          ? DateTime.parse(json['nextReview'] as String)
          : null,
      intervalDays: json['intervalDays'] as int?,
      easeFactor: (json['easeFactor'] as num?)?.toDouble(),
    );
  }
}

/// 用户材料
class UserMaterial {
  final String id;
  final String userId;                  // 用户ID
  final UserMaterialType type;
  final String title;
  final String? description;
  final MaterialFormat format;
  final String? filePath;               // 文件路径（本地）
  final String? folderId;               // 所属文件夹
  final List<String>? tags;
  final int? fileSize;                 // 文件大小（字节）
  final DateTime createdAt;
  final DateTime? lastModified;
  final DateTime? lastAccessed;
  final int? accessCount;              // 访问次数

  // 动态内容（根据类型不同）
  final List<VocabularyEntry>? vocabulary;
  final GrammarNote? grammarNote;
  final List<Flashcard>? flashcards;
  final String? textContent;            // 文本内容

  UserMaterial({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    required this.format,
    this.filePath,
    this.folderId,
    this.tags,
    this.fileSize,
    required this.createdAt,
    this.lastModified,
    this.lastAccessed,
    this.accessCount,
    this.vocabulary,
    this.grammarNote,
    this.flashcards,
    this.textContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'title': title,
      'description': description,
      'format': format.name,
      'filePath': filePath,
      'folderId': folderId,
      'tags': tags,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'lastAccessed': lastAccessed?.toIso8601String(),
      'accessCount': accessCount,
      'vocabulary': vocabulary?.map((v) => v.toJson()).toList(),
      'grammarNote': grammarNote?.toJson(),
      'flashcards': flashcards?.map((f) => f.toJson()).toList(),
      'textContent': textContent,
    };
  }

  factory UserMaterial.fromJson(Map<String, dynamic> json) {
    return UserMaterial(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: UserMaterialType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      title: json['title'] as String,
      description: json['description'] as String?,
      format: MaterialFormat.values.firstWhere(
        (e) => e.name == json['format'],
      ),
      filePath: json['filePath'] as String?,
      folderId: json['folderId'] as String?,
      tags: (json['tags'] as List<dynamic?>?)?.cast<String>(),
      fileSize: json['fileSize'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
      lastAccessed: json['lastAccessed'] != null
          ? DateTime.parse(json['lastAccessed'] as String)
          : null,
      accessCount: json['accessCount'] as int?,
      vocabulary: (json['vocabulary'] as List<dynamic?>?)
          ?.map((v) => VocabularyEntry.fromJson(v as Map<String, dynamic>))
          .toList(),
      grammarNote: json['grammarNote'] != null
          ? GrammarNote.fromJson(json['grammarNote'] as Map<String, dynamic>)
          : null,
      flashcards: (json['flashcards'] as List<dynamic?>?)
          ?.map((f) => Flashcard.fromJson(f as Map<String, dynamic>))
          .toList(),
      textContent: json['textContent'] as String?,
    );
  }
}

/// 材料搜索结果
class MaterialSearchResult {
  final UserMaterial material;
  final double relevance;              // 相关度评分 (0-1)
  final String? matchedText;            // 匹配的文本片段

  MaterialSearchResult({
    required this.material,
    required this.relevance,
    this.matchedText,
  });
}

/// 标签
class MaterialTag {
  final String id;
  final String name;
  final String? color;                 // 标签颜色
  final int usageCount;                // 使用次数

  MaterialTag({
    required this.id,
    required this.name,
    this.color,
    required this.usageCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'usageCount': usageCount,
    };
  }
