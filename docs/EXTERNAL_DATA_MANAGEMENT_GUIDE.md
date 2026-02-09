# Aeryn-Deutsch 外部数据管理指南

本文档说明如何管理和使用外部教育资源数据。

## 📦 已包含的数据集

### 1. 德语名词库 (German Nouns)
- **文件**: `assets/external_data/german_nouns_sample.csv`
- **记录数**: 80+ 示例名词
- **完整数据源**: https://github.com/gambolputty/german-nouns (~100,000 名词)
- **包含字段**:
  - `word`: 德语单词
  - `article`: 冠词 (der/die/das)
  - `plural`: 复数形式
  - `genitive`: 属格形式
  - `meaning`: 中文释义
  - `cefr_level`: CEFR级别 (A1-C2)
  - `frequency_rank`: 词频排名

### 2. 德语动词库 (German Verbs)
- **文件**: `assets/external_data/german_verbs_sample.csv`
- **记录数**: 70+ 示例动词
- **完整数据源**: https://github.com/viorelsfetea/german-verbs-database
- **包含字段**:
  - `infinitive`: 不定式
  - `english`: 英语释义
  - `chinese`: 中文释义
  - `type`: 动词类型 (weak/strong/mixed/modal)
  - `ich/du/er/wir/ihr/sie`: 现在时变位
  - `prateritum_*`: 过去时变位
  - `perfect`: 完成时助动词
  - `cefr_level`: CEFR级别

### 3. 用户词汇库
- **文件**: `assets/sample_vocabulary.csv`
- **记录数**: 25 示例词汇
- **用途**: 用户自定义词汇导入示例

---

## 🔧 数据集成服务

### 服务类: `ExternalDataIntegrationService`

位置: `lib/services/external_data_integration_service.dart`

#### 主要功能:

1. **导入德语名词数据库**
```dart
final result = await ExternalDataIntegrationService.importGermanNouns();
print('导入了 ${result.recordsProcessed} 个名词');
```

2. **导入德语动词数据库**
```dart
final result = await ExternalDataIntegrationService.importGermanVerbs();
print('导入了 ${result.recordsProcessed} 个动词');
```

3. **导入词频数据**
```dart
final result = await ExternalDataIntegrationService.importWordFrequencies();
print('导入了 ${result.recordsProcessed} 个高频词');
```

4. **获取数据统计**
```dart
final stats = await ExternalDataIntegrationService.getDataStatistics();
print('总导入: ${stats['totalImports']}');
print('总记录: ${stats['totalRecords']}');
```

5. **导出用户词汇**
```dart
final csv = await ExternalDataIntegrationService.exportUserVocabularyToCSV();
// 保存到文件或分享
```

6. **导入用户词汇**
```dart
final count = await ExternalDataIntegrationService.importUserVocabularyFromCSV(csvData);
print('导入了 $count 个用户词汇');
```

---

## 📥 获取完整数据集

### 方法一: 使用预打包数据 (推荐)

对于生产环境，建议预下载完整数据集并打包到app中:

```bash
# 1. 创建assets/external_data/full目录
mkdir -p assets/external_data/full

# 2. 下载数据集
cd assets/external_data/full

# German Nouns (~100,000 nouns)
wget https://raw.githubusercontent.com/gambolputty/german-nouns/master/nouns.csv

# German Verbs
wget https://raw.githubusercontent.com/viorelsfetea/german-verbs-database/master/output/verbs.csv

# Word Frequencies
wget https://raw.githubusercontent.com/olastor/german-word-frequencies/master/word_frequencies_de.csv
```

### 方法二: 运行时下载

app首次运行时从GitHub下载完整数据集:

```dart
// 在ExternalDataIntegrationService中实现
Future<void> downloadFullDataset({
  required Function(String) onProgress,
  required Function() onComplete,
  required Function(String) onError,
}) async {
  try {
    for (final source in DataSource.values) {
      if (source == DataSource.userImported) continue;

      onProgress('正在下载 ${dataSources[source]!['description']}');
      final result = await _downloadAndProcessDataset(source);
      // 处理结果...
    }
    onComplete();
  } catch (e) {
    onError(e.toString());
  }
}
```

---

## 📊 数据模型

### GermanNoun

```dart
class GermanNoun {
  final String word;           // 单词
  final String article;        // der/die/das
  final String plural;         // 复数
  final String? genitive;      // 属格
  final List<String>? meanings; // 释义
  final String? cefrLevel;     // A1-C2
  final int? frequencyRank;    // 词频排名
}
```

### GermanVerb

```dart
class GermanVerb {
  final String infinitive;              // 不定式
  final String? english;                // 英语释义
  final String? chinese;                // 中文释义
  final String type;                    // weak/strong/mixed
  final Map<String, String> present;    // 现在时变位
  final Map<String, String>? prateritum; // 过去时变位
  final String? perfect;                // 完成时
  final String? cefrLevel;              // A1-C2
}
```

---

## 🔄 数据更新策略

### 自动更新检查

```dart
Future<bool> checkForUpdates() async {
  final lastUpdate = await _getLastUpdateDate();
  final now = DateTime.now();

  // 每30天检查一次
  if (now.difference(lastUpdate).inDays > 30) {
    return true;
  }
  return false;
}
```

### 增量更新

只更新有变化的数据，不重复下载:

```dart
Future<void> incrementalUpdate() async {
  // 1. 获取远程数据版本
  final remoteVersion = await _fetchRemoteVersion();

  // 2. 比较本地版本
  final localVersion = await _getLocalVersion();

  if (remoteVersion > localVersion) {
    // 3. 只下载更新的部分
    await _downloadUpdates(localVersion, remoteVersion);
  }
}
```

---

## 💾 数据存储

### SharedPreferences (元数据)

- 集成历史记录
- 数据版本信息
- 最后更新时间
- 导入统计

### 本地文件 (实际数据)

- `documents/external_data/`: 下载的CSV/JSON文件
- `documents/user_data/`: 用户导入的数据
- `cache/`: 临时缓存文件

### SQLite (未来)

考虑迁移到SQLite以提高查询性能:

```dart
// 未来实现
class VocabularyDatabase {
  Future<List<GermanNoun>> searchNouns(String query);
  Future<List<GermanVerb>> searchVerbs(String query);
  Future<List<GermanNoun>> getNounsByCEFR(String level);
}
```

---

## 🚀 性能优化

### 1. 懒加载

只在需要时加载数据:

```dart
List<GermanNoun>? _nounsCache;

Future<List<GermanNoun>> getNouns() async {
  if (_nounsCache != null) return _nounsCache!;
  _nounsCache = await _loadNouns();
  return _nounsCache!;
}
```

### 2. 分页加载

大量数据时分页处理:

```dart
Future<List<GermanNoun>> getNounsPaginated({
  required int page,
  required int pageSize,
}) async {
  final start = page * pageSize;
  final end = start + pageSize;
  return _allNouns.sublist(start, end);
}
```

### 3. 索引优化

对常用查询字段建立索引:

```dart
// 按CEFR级别索引
final Map<String, List<GermanNoun>> _nounsByCEFR = {};

// 按词频索引
final List<GermanNoun> _nounsByFrequency = [];
```

---

## 📈 数据质量

### 数据验证

```dart
bool validateNoun(GermanNoun noun) {
  // 检查必需字段
  if (noun.word.isEmpty) return false;
  if (!['der', 'die', 'das'].contains(noun.article)) return false;
  if (noun.plural.isEmpty) return false;

  // 检查CEFR级别
  if (noun.cefrLevel != null) {
    if (!['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].contains(noun.cefrLevel)) {
      return false;
    }
  }

  return true;
}
```

### 数据清洗

```dart
List<GermanNoun> cleanNounData(List<GermanNoun> nouns) {
  // 1. 去重
  final unique = <String, GermanNoun>{};
  for (final noun in nouns) {
    unique[noun.word.toLowerCase()] = noun;
  }

  // 2. 验证
  final valid = unique.values.where(validateNoun).toList();

  // 3. 排序
  valid.sort((a, b) =>
    (a.frequencyRank ?? 999999).compareTo(b.frequencyRank ?? 999999));

  return valid;
}
```

---

## 🔍 使用示例

### 示例1: 搜索词汇

```dart
Future<List<GermanNoun>> searchNouns(String query) async {
  final allNouns = await ExternalDataIntegrationService.loadGermanNouns();
  return allNouns.where((noun) =>
    noun.word.toLowerCase().contains(query.toLowerCase()) ||
    (noun.meanings?.any((m) => m.contains(query)) ?? false)
  ).toList();
}
```

### 示例2: 按级别学习

```dart
Future<List<GermanNoun>> getNounsByLevel(String level) async {
  final allNouns = await ExternalDataIntegrationService.loadGermanNouns();
  return allNouns.where((noun) => noun.cefrLevel == level).toList();
}
```

### 示例3: 随机测验

```dart
Future<List<GermanNoun>> getRandomQuizNouns(int count) async {
  final allNouns = await ExternalDataIntegrationService.loadGermanNouns();
  final shuffled = List<GermanNoun>.from(allNouns)..shuffle();
  return shuffled.take(count).toList();
}
```

---

## 📚 参考资料

### 数据源许可协议

1. **german-nouns**: 开源 (Wiktionary-based)
2. **german-verbs-database**: 开源 (Wiktionary-based)
3. **german-word-frequencies**: 开源许可
4. **Deutsch im Blick**: CC BY 4.0
5. **Deutsche Welle**: 免费教育使用

### 相关文档

- [开放教育资源目录](OPEN_EDUCATIONAL_RESOURCES_CATALOG.md)
- [个人知识库设计](PERSONAL_KNOWLEDGE_BASE_DESIGN.md)
- [质量保证指南](QUALITY_ASSURANCE_GUIDE.md)

---

**最后更新**: 2026-02-08
**维护者**: Aeryn-Deutsch 开发团队
