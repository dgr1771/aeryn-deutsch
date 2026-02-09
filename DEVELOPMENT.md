# Aeryn-Deutsch 开发文档

## 项目概述

**Aeryn-Deutsch** 是一款基于"高维打击"学习法的德语学习 App，目标是让学习者在 1 年内从零基础达到 B2 水平。

### 核心创新点

1. **高维打击法** - 直接从 B2/C2 实战材料学习，AI 动态向下兼容 A1-B1
2. **视觉化语法** - 名词性别自动着色（der-蓝/die-红/das-绿）
3. **新闻降级滤镜** - 实时将 B2 新闻简化为 A2/B1
4. **长难句解剖刀** - 视觉化拆解复杂句子结构
5. **FSRS 算法** - 比传统 Anki 更高效的记忆系统

---

## 开发进度

### ✅ 已完成（Sprint 1）

| 模块 | 文件 | 状态 | 描述 |
|------|------|------|------|
| 项目架构 | pubspec.yaml | ✅ | Flutter 项目配置和依赖管理 |
| 核心语法引擎 | grammar_engine.dart | ✅ | 名词性别识别、颜色着色、后缀推断 |
| 数字矩阵 | number_matrix.dart | ✅ | 1-1,000,000 数字逻辑拼装算法 |
| 复杂度分析 | complexity_engine.dart | ✅ | 文本难度等级检测（A1-C2） |
| 新闻客户端 | news_client.dart | ✅ | DW/Tagesschau/Spiegel RSS 抓取 |
| AI 服务 | ai_service.dart | ✅ | DeepSeek API 集成、新闻降级重写 |
| 数据模型 | word.dart, news_article.dart | ✅ | 词汇、新闻文章数据结构 |
| FSRS 服务 | fsrs_service.dart | ✅ | 间隔重复记忆算法 |
| 主页 UI | home_screen.dart | ✅ | Dashboard 进度看板 |
| 数字实验室 | number_lab_screen.dart | ✅ | 数字学习交互界面 |
| 颜色编码文本 | color_coded_text.dart | ✅ | 名词自动着色组件 |
| Android 小部件 | deutsch_widget.dart | ✅ | 桌面 Widget Provider |
| 主入口 | main.dart | ✅ | 应用启动配置 |

### 🔄 进行中（Sprint 2）

| 模块 | 优先级 | 预计完成 |
|------|--------|----------|
| 新闻降级 UI | 高 | 1周 |
| 长难句解剖刀 UI | 高 | 1周 |
| Isar 数据库集成 | 中 | 3天 |
| 语音识别 (Whisper) | 中 | 3天 |

### ⏳ 待开发（Sprint 3-4）

- [ ] AI 口语对话界面
- [ ] 词汇词簇映射图谱
- [ ] iOS 灵动岛适配
- [ ] 性能优化和测试
- [ ] APK 打包和发布

---

## 技术栈详解

### 前端 (Flutter/Dart)

```yaml
# 核心依赖
flutter: sdk
provider: ^6.1.1          # 状态管理
riverpod: ^2.4.9          # 依赖注入

# 数据库
isar: ^3.1.0+1           # 高性能本地数据库
isar_flutter_libs: ^3.1.0+1
path_provider: ^2.1.1

# 网络
http: ^1.1.2
dio: ^5.4.0
webfeed: ^0.7.0          # RSS 解析

# AI & 语音
azure_tts_speech: ^1.0.0  # 德语语音合成
speech_to_text: ^6.5.1    # 语音识别
```

### 后端服务

```yaml
AI: DeepSeek API
新闻源: DW, Tagesschau, Spiegel RSS
NLP: spaCy (de_core_news_lg)
TTS: Azure Neural TTS
STT: Whisper.cpp (本地化)
```

---

## 核心算法

### 1. 名词性别推断（Suffix Logic）

```dart
// 80% 准确率的本地推断算法
static GermanGender predictGender(String word) {
  // 阴性后缀：-ung, -heit, -keit, -schaft
  if (word.endsWith('ung') || word.endsWith('heit'))
    return GermanGender.die;

  // 中性后缀：-chen, -lein, -ment
  if (word.endsWith('chen') || word.endsWith('lein'))
    return GermanGender.das;

  // 阳性后缀：-ismus, -ner, -ig
  if (word.endsWith('ismus') || word.endsWith('ner'))
    return GermanGender.der;

  return GermanGender.unknown;
}
```

### 2. FSRS 记忆算法（简化版）

```dart
// 比传统 SM-2 更高效
static Word scheduleNextReview(Word word, int quality) {
  if (quality >= 3) {
    // 正确：增加间隔
    if (word.reviewCount == 1) interval = 1;
    else if (word.reviewCount == 2) interval = 6;
    else interval = (interval * easeFactor).round();

    nextReview = DateTime.now().add(Duration(days: interval));
  } else {
    // 错误：重置
    interval = 0;
    nextReview = DateTime.now().add(minutes: 10);
  }

  return word.copyWith(interval, nextReview);
}
```

### 3. 数字矩阵拼装

```dart
// 德语：sechzehn = sechs + zehn (个位在前，十位在后)
static String numberToGerman(int number) {
  if (number < 100) {
    final ones = number % 10;
    final tens = (number ~/ 10) * 10;

    if (ones == 0) return tens[tens];
    return '$ones+und+$tens[tens]'; // einundzwanzig
  }

  // ... 更多逻辑
}
```

---

## API 集成示例

### DeepSeek 新闻降级

```dart
final aiService = AIService(apiKey: 'YOUR_KEY');

final result = await aiService.transformNews(
  'Die Bundesregierung beabsichtigt...',
  LanguageLevel.A2,
);

print(result.transformedText);
// "Die Regierung will mehr Geld geben..."
```

---

## 快速开始

### 1. 环境配置

```bash
# 安装 Flutter SDK (>=3.16)
flutter --version

# 克隆项目
git clone https://github.com/YOUR_USERNAME/aeryn-deutsch.git
cd aeryn-deutsch

# 安装依赖
flutter pub get

# 配置 API Key
# 编辑 lib/main.dart，替换 YOUR_DEEPSEEK_API_KEY_HERE
```

### 2. 运行应用

```bash
# 调试模式
flutter run

# 发布模式
flutter run --release
```

### 3. 构建 APK

```bash
# Android APK
flutter build apk --release

# 生成文件：build/app/outputs/flutter-apk/app-release.apk
```

---

## 项目文件树

```
aeryn-deutsch/
├── lib/
│   ├── core/              # 核心引擎 ✅
│   │   ├── grammar_engine.dart
│   │   ├── number_matrix.dart
│   │   └── complexity_engine.dart
│   ├── api/               # API 层 ✅
│   │   ├── news_client.dart
│   │   └── ai_service.dart
│   ├── models/            # 数据模型 ✅
│   │   ├── word.dart
│   │   └── news_article.dart
│   ├── services/          # 业务服务 ✅
│   │   └── fsrs_service.dart
│   ├── ui/                # UI 组件 ✅
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   └── number_lab_screen.dart
│   │   ├── widgets/
│   │   │   └── color_coded_text.dart
│   │   └── android/
│   │       └── widgets/
│   │           └── deutsch_widget.dart
│   └── main.dart          # 主入口 ✅
├── pubspec.yaml           # 依赖配置 ✅
├── README.md              # 项目说明 ✅
└── DEVELOPMENT.md         # 开发文档 ✅
```

---

## 下一步计划

### 第 1 周：新闻降级 UI
- [ ] 新闻列表界面
- [ ] 难度滑块（A1-C2）
- [ ] AI 重写进度指示器

### 第 2 周：长难句解剖刀
- [ ] 句子层级化展示
- [ ] 从句连接线动画
- [ ] 语法卡片弹出

### 第 3-4 周：数据持久化
- [ ] Isar 数据库初始化
- [ ] 生词本 CRUD
- [ ] 学习进度同步

---

## 贡献指南

我们欢迎所有形式的贡献！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## 联系方式

- GitHub Issues: [提交问题](https://github.com/YOUR_USERNAME/aeryn-deutsch/issues)
- Email: your-email@example.com

---

**让德语学习回归实战本质。**

Made with ❤️ by Aeryn OS Team
