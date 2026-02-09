/// 演讲学习模型
library;

/// 演讲类型
enum SpeechType {
  political,       // 政治演讲
  academic,        // 学术演讲
  business,        // 商业演讲
  motivational,    // 励志演讲
  cultural,        // 文化演讲
  historical,      // 历史演讲
  tedTalk,         // TED演讲
  commencement,     // 毕业演讲
}

/// 演讲难度
enum SpeechDifficulty {
  beginner,        // 初级（语速慢、词汇简单）
  intermediate,    // 中级（语速适中、词汇中等）
  advanced,        // 高级（语速快、词汇复杂）
  expert,          // 专家（专业术语、抽象概念）
}

/// 演讲主题
enum SpeechTopic {
  leadership,      // 领导力
  technology,      // 科技
  science,         // 科学
  environment,     // 环境
  education,       // 教育
  society,         // 社会
  politics,        // 政治
  economy,         // 经济
  culture,         // 文化
  history,         // 历史
  innovation,      // 创新
  philosophy,      // 哲学
}

/// 演讲者信息
class Speaker {
  final String id;
  final String name;
  final String gender;                  // male/female
  final String? title;                 // 头衔/职位
  final String? organization;          // 所属组织
  final String? biography;             // 简介
  final String? imageUrl;              // 照片URL
  final List<String>? notableWorks;    // 代表作/成就

  Speaker({
    required this.id,
    required this.name,
    required this.gender,
    this.title,
    this.organization,
    this.biography,
    this.imageUrl,
    this.notableWorks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'title': title,
      'organization': organization,
      'biography': biography,
      'imageUrl': imageUrl,
      'notableWorks': notableWorks,
    };
  }

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      title: json['title'] as String?,
      organization: json['organization'] as String?,
      biography: json['biography'] as String?,
      imageUrl: json['imageUrl'] as String?,
      notableWorks: (json['notableWorks'] as List<dynamic?>?)?.cast<String>(),
    );
  }
}

/// 演讲片段（用于分段学习）
class SpeechSegment {
  final String id;
  final int startTime;                 // 开始时间（秒）
  final int endTime;                   // 结束时间（秒）
  final String germanText;             // 德语文本
  final String? translation;           // 中文翻译
  final List<String>? keyVocabulary;   // 重点词汇
  final String? grammarNote;           // 语法注释
  final String? culturalNote;          // 文化注释

  SpeechSegment({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.germanText,
    this.translation,
    this.keyVocabulary,
    this.grammarNote,
    this.culturalNote,
  });

  int get duration => endTime - startTime;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'germanText': germanText,
      'translation': translation,
      'keyVocabulary': keyVocabulary,
      'grammarNote': grammarNote,
      'culturalNote': culturalNote,
    };
  }

  factory SpeechSegment.fromJson(Map<String, dynamic> json) {
    return SpeechSegment(
      id: json['id'] as String,
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int,
      germanText: json['germanText'] as String,
      translation: json['translation'] as String?,
      keyVocabulary: (json['keyVocabulary'] as List<dynamic?>?)?.cast<String>(),
      grammarNote: json['grammarNote'] as String?,
      culturalNote: json['culturalNote'] as String?,
    );
  }
}

/// 演讲
class Speech {
  final String id;
  final String title;
  final Speaker speaker;
  final SpeechType type;
  final SpeechDifficulty difficulty;
  final List<SpeechTopic> topics;
  final DateTime? speechDate;           // 演讲日期
  final String? event;                  // 活动名称
  final String? location;               // 地点
  final int duration;                   // 时长（秒）
  final String? audioUrl;               // 音频URL
  final String? videoUrl;               // 视频URL
  final String transcript;              // 完整转录文本
  final String? summary;                // 内容摘要
  final List<SpeechSegment> segments;   // 分段（用于学习）
  final List<String>? keyQuotes;        // 经典语录
  final String? backgroundInfo;         // 背景信息

  Speech({
    required this.id,
    required this.title,
    required this.speaker,
    required this.type,
    required this.difficulty,
    required this.topics,
    this.speechDate,
    this.event,
    this.location,
    required this.duration,
    this.audioUrl,
    this.videoUrl,
    required this.transcript,
    this.summary,
    required this.segments,
    this.keyQuotes,
    this.backgroundInfo,
  });

  int get minutes => duration ~/ 60;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'speaker': speaker.toJson(),
      'type': type.name,
      'difficulty': difficulty.name,
      'topics': topics.map((t) => t.name).toList(),
      'speechDate': speechDate?.toIso8601String(),
      'event': event,
      'location': location,
      'duration': duration,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'transcript': transcript,
      'summary': summary,
      'segments': segments.map((s) => s.toJson()).toList(),
      'keyQuotes': keyQuotes,
      'backgroundInfo': backgroundInfo,
    };
  }

  factory Speech.fromJson(Map<String, dynamic> json) {
    return Speech(
      id: json['id'] as String,
      title: json['title'] as String,
      speaker: Speaker.fromJson(json['speaker'] as Map<String, dynamic>),
      type: SpeechType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      difficulty: SpeechDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),
      topics: (json['topics'] as List<dynamic>)
          .map((t) => SpeechTopic.values.firstWhere((e) => e.name == t))
          .toList(),
      speechDate: json['speechDate'] != null
          ? DateTime.parse(json['speechDate'] as String)
          : null,
      event: json['event'] as String?,
      location: json['location'] as String?,
      duration: json['duration'] as int,
      audioUrl: json['audioUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      transcript: json['transcript'] as String,
      summary: json['summary'] as String?,
      segments: (json['segments'] as List<dynamic>)
          .map((s) => SpeechSegment.fromJson(s as Map<String, dynamic>))
          .toList(),
      keyQuotes: (json['keyQuotes'] as List<dynamic?>?)?.cast<String>(),
      backgroundInfo: json['backgroundInfo'] as String?,
    );
  }
}

/// 演讲学习进度
class SpeechProgress {
  final String speechId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<String> completedSegments;  // 已完成学习的片段ID
  final List<String> favoriteSegments;   // 收藏的片段ID
  final Map<String, String> notes;        // 个人笔记 {segmentId: note}
  final int listenCount;                  // 听的次数
  final int? lastPosition;                // 最后播放位置（秒）

  SpeechProgress({
    required this.speechId,
    required this.startedAt,
    this.completedAt,
    required this.completedSegments,
    required this.favoriteSegments,
    required this.notes,
    required this.listenCount,
    this.lastPosition,
  });

  double get completionRate {
    // TODO: 需要知道总片段数
    return completedSegments.length / 10; // 假设10个片段
  }

  Map<String, dynamic> toJson() {
    return {
      'speechId': speechId,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'completedSegments': completedSegments,
      'favoriteSegments': favoriteSegments,
      'notes': notes,
      'listenCount': listenCount,
      'lastPosition': lastPosition,
    };
  }

  factory SpeechProgress.fromJson(Map<String, dynamic> json) {
    return SpeechProgress(
      speechId: json['speechId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      completedSegments: (json['completedSegments'] as List<dynamic>).cast<String>(),
      favoriteSegments: (json['favoriteSegments'] as List<dynamic>).cast<String>(),
      notes: Map<String, String>.from(json['notes'] as Map),
      listenCount: json['listenCount'] as int,
      lastPosition: json['lastPosition'] as int?,
    );
  }
}

/// 演讲学习统计
class SpeechStatistics {
  final int totalSpeechesListened;       // 听过的演讲总数
  final int totalListeningMinutes;       // 总听力时长（分钟）
  final Map<SpeechDifficulty, int> speechesByDifficulty;  // 各难度演讲数
  final Map<SpeechTopic, int> speechesByTopic;            // 各主题演讲数
  final List<String> favoriteSpeakers;   // 最喜欢的演讲者
  final int totalSegmentsCompleted;      // 完成的片段总数

  SpeechStatistics({
    required this.totalSpeechesListened,
    required this.totalListeningMinutes,
    required this.speechesByDifficulty,
    required this.speechesByTopic,
    required this.favoriteSpeakers,
    required this.totalSegmentsCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalSpeechesListened': totalSpeechesListened,
      'totalListeningMinutes': totalListeningMinutes,
      'speechesByDifficulty': speechesByDifficulty.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'speechesByTopic': speechesByTopic.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'favoriteSpeakers': favoriteSpeakers,
      'totalSegmentsCompleted': totalSegmentsCompleted,
    };
  }
}
