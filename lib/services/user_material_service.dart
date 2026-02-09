/// 用户材料管理服务
library;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/user_material.dart';

/// 用户材料管理服务
class UserMaterialService {
  static const String _materialsKey = 'user_materials';
  static const String _foldersKey = 'user_folders';
  static const String _tagsKey = 'user_tags';

  SharedPreferences? _prefs;
  List<UserMaterial> _materials = [];
  List<MaterialFolder> _folders = [];
  List<MaterialTag> _tags = [];

  /// 初始化服务
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadMaterials();
    await _loadFolders();
    await _loadTags();

    // 创建默认文件夹
    if (_folders.isEmpty) {
      await _createDefaultFolders();
    }
  }

  /// 加载材料
  Future<void> _loadMaterials() async {
    if (_prefs == null) return;

    final materialsJson = _prefs!.getStringList(_materialsKey) ?? [];
    _materials = materialsJson
        .map((json) => UserMaterial.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存材料
  Future<void> _saveMaterials() async {
    if (_prefs == null) return;

    final materialsJson = _materials.map((m) => jsonEncode(m.toJson())).toList();
    await _prefs!.setStringList(_materialsKey, materialsJson);
  }

  /// 加载文件夹
  Future<void> _loadFolders() async {
    if (_prefs == null) return;

    final foldersJson = _prefs!.getStringList(_foldersKey) ?? [];
    _folders = foldersJson
        .map((json) => MaterialFolder.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存文件夹
  Future<void> _saveFolders() async {
    if (_prefs == null) return;

    final foldersJson = _folders.map((f) => jsonEncode(f.toJson())).toList();
    await _prefs!.setStringList(_foldersKey, foldersJson);
  }

  /// 加载标签
  Future<void> _loadTags() async {
    if (_prefs == null) return;

    final tagsJson = _prefs!.getStringList(_tagsKey) ?? [];
    _tags = tagsJson
        .map((json) {
          final map = jsonDecode(json) as Map<String, dynamic>;
          return MaterialTag(
            id: map['id'] as String,
            name: map['name'] as String,
            color: map['color'] as String?,
            usageCount: map['usageCount'] as int,
          );
        })
        .toList();
  }

  /// 保存标签
  Future<void> _saveTags() async {
    if (_prefs == null) return;

    final tagsJson = _tags.map((t) => jsonEncode(t.toJson())).toList();
    await _prefs!.setStringList(_tagsKey, tagsJson);
  }

  /// 创建默认文件夹
  Future<void> _createDefaultFolders() async {
    final defaultFolders = [
      MaterialFolder(
        id: 'folder_vocab',
        name: '词汇',
        color: '#4299e1',
        order: 1,
        createdAt: DateTime.now(),
      ),
      MaterialFolder(
        id: 'folder_grammar',
        name: '语法笔记',
        color: '#00c853',
        order: 2,
        createdAt: DateTime.now(),
      ),
      MaterialFolder(
        id: 'folder_reading',
        name: '阅读材料',
        color: '#ff9800',
        order: 3,
        createdAt: DateTime.now(),
      ),
      MaterialFolder(
        id: 'folder_listening',
        name: '听力材料',
        color: '#9c27b0',
        order: 4,
        createdAt: DateTime.now(),
      ),
      MaterialFolder(
        id: 'folder_flashcards',
        name: '抽认卡',
        color: '#f44336',
        order: 5,
        createdAt: DateTime.now(),
      ),
    ];

    _folders = defaultFolders;
    await _saveFolders();
  }

  // ========== 文件夹管理 ==========

  /// 获取所有文件夹
  List<MaterialFolder> getAllFolders() {
    return List.from(_folders);
  }

  /// 创建文件夹
  Future<void> createFolder({
    required String name,
    String? parentId,
    String? color,
  }) async {
    await initialize();

    final folder = MaterialFolder(
      id: 'folder_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      parentId: parentId,
      color: color ?? '#4299e1',
      order: _folders.length,
      createdAt: DateTime.now(),
    );

    _folders.add(folder);
    await _saveFolders();
  }

  /// 删除文件夹
  Future<void> deleteFolder(String folderId) async {
    await initialize();

    _folders.removeWhere((f) => f.id == folderId);

    // 删除文件夹内的材料
    _materials.removeWhere((m) => m.folderId == folderId);

    await _saveFolders();
    await _saveMaterials();
  }

  /// 更新文件夹
  Future<void> updateFolder({
    required String folderId,
    String? name,
    String? color,
  }) async {
    await initialize();

    final index = _folders.indexWhere((f) => f.id == folderId);
    if (index != -1) {
      final folder = _folders[index];
      _folders[index] = MaterialFolder(
        id: folder.id,
        name: name ?? folder.name,
        parentId: folder.parentId,
        color: color ?? folder.color,
        order: folder.order,
        createdAt: folder.createdAt,
      );
      await _saveFolders();
    }
  }

  // ========== 词汇管理 ==========

  /// 从CSV导入词汇
  Future<void> importVocabularyFromCSV({
    required String filePath,
    String? folderId,
    String? title,
  }) async {
    await initialize();

    try {
      final file = File(filePath);
      final csvContent = await file.readAsString();
      final lines = csvContent.split('\n');

      if (lines.isEmpty) {
        throw Exception('CSV文件为空');
      }

      // 解析CSV
      final vocabulary = <VocabularyEntry>[];
      final headers = lines[0].split(',').map((h) => h.trim()).toList();

      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final values = line.split(',');

        final entry = VocabularyEntry(
          id: 'vocab_${DateTime.now().millisecondsSinceEpoch}_$i',
          word: values.length > 0 ? values[0].trim() : '',
          article: values.length > 1 ? values[1].trim() : null,
          meaning: values.length > 2 ? values[2].trim() : '',
          example: values.length > 3 ? values[3].trim() : null,
          translation: values.length > 4 ? values[4].trim() : null,
          tags: values.length > 5 ? values[5].split('|').map((t) => t.trim()).toList() : null,
          notes: values.length > 6 ? values[6].trim() : null,
          createdAt: DateTime.now(),
        );

        if (entry.word.isNotEmpty && entry.meaning.isNotEmpty) {
          vocabulary.add(entry);
        }
      }

      // 创建材料
      final material = UserMaterial(
        id: 'material_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current_user', // TODO: 实际用户ID
        type: UserMaterialType.vocabulary,
        title: title ?? path.basename(filePath, '.csv'),
        description: '包含 ${vocabulary.length} 个词汇',
        format: MaterialFormat.csv,
        filePath: filePath,
        folderId: folderId,
        fileSize: await file.length(),
        createdAt: DateTime.now(),
        vocabulary: vocabulary,
      );

      _materials.add(material);
      await _saveMaterials();

      // 更新标签统计
      for (final entry in vocabulary) {
        if (entry.tags != null) {
          for (final tag in entry.tags!) {
            await _updateTagUsage(tag);
          }
        }
      }
    } catch (e) {
      throw Exception('导入词汇失败: $e');
    }
  }

  /// 导出词汇到CSV
  Future<String> exportVocabularyToCSV(String materialId) async {
    await initialize();

    final material = _materials.firstWhere(
      (m) => m.id == materialId,
      orElse: () => throw Exception('材料不存在'),
    );

    if (material.vocabulary == null) {
      throw Exception('该材料不包含词汇数据');
    }

    // 生成CSV内容
    final buffer = StringBuffer();
    buffer.writeln('word,article,meaning,example,translation,tags,notes');

    for (final entry in material.vocabulary!) {
      buffer.write(entry.word);
      buffer.write(',${entry.article ?? ''}');
      buffer.write(',${entry.meaning}');
      buffer.write(',${entry.example ?? ''}');
      buffer.write(',${entry.translation ?? ''}');
      buffer.write(',${entry.tags?.join('|') ?? ''}');
      buffer.write(',${entry.notes ?? ''}');
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// 添加单个词汇
  Future<void> addVocabulary({
    required String word,
    String? article,
    required String meaning,
    String? example,
    String? translation,
    String? folderId,
    List<String>? tags,
  }) async {
    await initialize();

    final entry = VocabularyEntry(
      id: 'vocab_${DateTime.now().millisecondsSinceEpoch}',
      word: word,
      article: article,
      meaning: meaning,
      example: example,
      translation: translation,
      tags: tags,
      createdAt: DateTime.now(),
    );

    // 查找或创建词汇材料
    var material = _materials.cast<UserMaterial?>().firstWhere(
      (m) => m?.type == UserMaterialType.vocabulary && m?.folderId == folderId,
      orElse: () => null,
    );

    if (material != null) {
      // 添加到现有材料
      final vocabList = List<VocabularyEntry>.from(material!.vocabulary ?? []);
      vocabList.add(entry);
      _materials[_materials.indexOf(material)] = UserMaterial(
        id: material.id,
        userId: material.userId,
        type: material.type,
        title: material.title,
        description: '包含 ${vocabList.length} 个词汇',
        format: material.format,
        folderId: material.folderId,
        createdAt: material.createdAt,
        lastModified: DateTime.now(),
        vocabulary: vocabList,
      );
    } else {
      // 创建新材料
      material = UserMaterial(
        id: 'material_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current_user',
        type: UserMaterialType.vocabulary,
        title: folderId != null ? '自定义词汇' : '词汇',
        format: MaterialFormat.json,
        folderId: folderId,
        createdAt: DateTime.now(),
        vocabulary: [entry],
      );
      _materials.add(material);
    }

    await _saveMaterials();

    // 更新标签
    if (tags != null) {
      for (final tag in tags) {
        await _updateTagUsage(tag);
      }
    }
  }

  // ========== 语法笔记管理 ==========

  /// 创建语法笔记
  Future<void> createGrammarNote({
    required String title,
    required String content,
    String? folderId,
    String? category,
    String? level,
    List<String>? tags,
  }) async {
    await initialize();

    final note = GrammarNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      category: category,
      level: level,
      tags: tags,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
    );

    final material = UserMaterial(
      id: 'material_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      type: UserMaterialType.grammarNote,
      title: title,
      description: content.substring(0, content.length > 100 ? 100 : content.length),
      format: MaterialFormat.markdown,
      folderId: folderId,
      createdAt: DateTime.now(),
      grammarNote: note,
      textContent: content,
    );

    _materials.add(material);
    await _saveMaterials();

    // 更新标签
    if (tags != null) {
      for (final tag in tags) {
        await _updateTagUsage(tag);
      }
    }
  }

  /// 更新语法笔记
  Future<void> updateGrammarNote({
    required String materialId,
    String? title,
    String? content,
    String? category,
    String? level,
    List<String>? tags,
  }) async {
    await initialize();

    final index = _materials.indexWhere((m) => m.id == materialId);
    if (index == -1) return;

    final material = _materials[index];
    final note = material.grammarNote;

    if (note != null) {
      final updatedNote = GrammarNote(
        id: note.id,
        title: title ?? note.title,
        content: content ?? note.content,
        tags: tags ?? note.tags,
        category: category ?? note.category,
        level: level ?? note.level,
        examples: note.examples,
        createdAt: note.createdAt,
        lastModified: DateTime.now(),
      );

      _materials[index] = UserMaterial(
        id: material.id,
        userId: material.userId,
        type: material.type,
        title: title ?? material.title,
        description: content != null && content.length > 100
            ? content.substring(0, 100)
            : material.description,
        format: material.format,
        folderId: material.folderId,
        createdAt: material.createdAt,
        lastModified: DateTime.now(),
        grammarNote: updatedNote,
        textContent: content ?? material.textContent,
      );

      await _saveMaterials();
    }
  }

  // ========== 搜索功能 ==========

  /// 搜索材料
  Future<List<MaterialSearchResult>> searchMaterials({
    required String query,
    UserMaterialType? type,
    String? folderId,
    List<String>? tags,
  }) async {
    await initialize();

    final results = <MaterialSearchResult>[];

    for (final material in _materials) {
      // 类型筛选
      if (type != null && material.type != type) continue;

      // 文件夹筛选
      if (folderId != null && material.folderId != folderId) continue;

      // 标签筛选
      if (tags != null && tags.isNotEmpty) {
        final materialTags = material.tags ?? [];
        if (!tags.any((tag) => materialTags.contains(tag))) continue;
      }

      // 文本搜索
      final relevance = _calculateRelevance(material, query);
      if (relevance > 0) {
        results.add(MaterialSearchResult(
          material: material,
          relevance: relevance,
          matchedText: _extractMatchedText(material, query),
        ));
      }
    }

    // 按相关度排序
    results.sort((a, b) => b.relevance.compareTo(a.relevance));

    return results;
  }

  /// 计算相关度
  double _calculateRelevance(UserMaterial material, String query) {
    double score = 0;
    final queryLower = query.toLowerCase();

    // 标题匹配（权重最高）
    if (material.title.toLowerCase().contains(queryLower)) {
      score += 1.0;
    }

    // 描述匹配
    if (material.description?.toLowerCase().contains(queryLower) ?? false) {
      score += 0.7;
    }

    // 标签匹配
    if (material.tags?.any((tag) => tag.toLowerCase().contains(queryLower)) ?? false) {
      score += 0.5;
    }

    // 内容匹配
    if (material.textContent?.toLowerCase().contains(queryLower) ?? false) {
      score += 0.3;
    }

    // 词汇内容搜索
    if (material.vocabulary != null) {
      for (final entry in material.vocabulary!) {
        if (entry.word.toLowerCase().contains(queryLower) ||
            entry.meaning.toLowerCase().contains(queryLower)) {
          score += 0.2;
          break;
        }
      }
    }

    // 语法笔记内容搜索
    if (material.grammarNote != null) {
      if (material.grammarNote!.content.toLowerCase().contains(queryLower) ||
          material.grammarNote!.title.toLowerCase().contains(queryLower)) {
        score += 0.3;
      }
    }

    return score;
  }

  /// 提取匹配的文本片段
  String? _extractMatchedText(UserMaterial material, String query) {
    if (material.vocabulary != null) {
      for (final entry in material.vocabulary!) {
        if (entry.word.toLowerCase().contains(query.toLowerCase())) {
          return entry.word;
        }
      }
    }

    if (material.grammarNote != null) {
      if (material.grammarNote!.title.toLowerCase().contains(query.toLowerCase())) {
        return material.grammarNote!.title;
      }
    }

    if (material.title.toLowerCase().contains(query.toLowerCase())) {
      return material.title;
    }

    return null;
  }

  // ========== 标签管理 ==========

  /// 更新标签使用次数
  Future<void> _updateTagUsage(String tagName) async {
    await initialize();

    final existingTag = _tags.cast<MaterialTag?>().firstWhere(
      (t) => t?.name == tagName,
      orElse: () => null,
    );

    if (existingTag != null) {
      final index = _tags.indexOf(existingTag!);
      _tags[index] = MaterialTag(
        id: existingTag.id,
        name: existingTag.name,
        color: existingTag.color,
        usageCount: existingTag.usageCount + 1,
      );
    } else {
      _tags.add(MaterialTag(
        id: 'tag_${DateTime.now().millisecondsSinceEpoch}',
        name: tagName,
        usageCount: 1,
      ));
    }

    await _saveTags();
  }

  /// 获取所有标签
  List<MaterialTag> getAllTags() {
    // 按使用次数排序
    final sortedTags = List<MaterialTag>.from(_tags);
    sortedTags.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return sortedTags;
  }

  // ========== 统计信息 ==========

  /// 获取统计信息
  Map<String, dynamic> getStatistics() {
    final vocabCount = _materials
        .where((m) => m.type == UserMaterialType.vocabulary)
        .fold<int>(0, (sum, m) => sum + (m.vocabulary?.length ?? 0));

    final grammarNoteCount = _materials
        .where((m) => m.type == UserMaterialType.grammarNote)
        .length;

    final totalSize = _materials.fold<int>(
      0,
      (sum, m) => sum + (m.fileSize ?? 0),
    );

    return {
      'totalMaterials': _materials.length,
      'totalFolders': _folders.length,
      'totalTags': _tags.length,
      'vocabularyCount': vocabCount,
      'grammarNoteCount': grammarNoteCount,
      'totalSize': totalSize,
      'totalSizeInMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
    };
  }

  // ========== 删除和更新 ==========

  /// 删除材料
  Future<void> deleteMaterial(String materialId) async {
    await initialize();

    _materials.removeWhere((m) => m.id == materialId);
    await _saveMaterials();
  }

  /// 更新访问记录
  Future<void> updateAccess(String materialId) async {
    await initialize();

    final index = _materials.indexWhere((m) => m.id == materialId);
    if (index != -1) {
      final material = _materials[index];
      _materials[index] = UserMaterial(
        id: material.id,
        userId: material.userId,
        type: material.type,
        title: material.title,
        description: material.description,
        format: material.format,
        filePath: material.filePath,
        folderId: material.folderId,
        tags: material.tags,
        fileSize: material.fileSize,
        createdAt: material.createdAt,
        lastModified: material.lastModified,
        lastAccessed: DateTime.now(),
        accessCount: (material.accessCount ?? 0) + 1,
        vocabulary: material.vocabulary,
        grammarNote: material.grammarNote,
        flashcards: material.flashcards,
        textContent: material.textContent,
      );
      await _saveMaterials();
    }
  }

  /// 获取文件夹内的材料
  List<UserMaterial> getMaterialsInFolder(String? folderId) {
    if (folderId == null) {
      // 返回根目录的材料（不在任何文件夹）
      return _materials.where((m) => m.folderId == null).toList();
    }
    return _materials.where((m) => m.folderId == folderId).toList();
  }

  /// 获取所有材料
  List<UserMaterial> getAllMaterials() {
    return List.from(_materials);
  }
}
