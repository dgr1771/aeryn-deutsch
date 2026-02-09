# Aeryn-Deutsch 🎓🇩🇪

**从A1到C2的专业德语学习解决方案**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-2.8.0-purple.svg)](https://github.com/aeryn-deutsch)

---

## ✨ 简介

**Aeryn-Deutsch** 是一款专业的德语学习移动应用，旨在帮助学习者从零基础（A1）达到接近母语者水平（C2）。应用采用AI技术、科学记忆方法和真实德语素材，提供完整的德语学习生态系统。

### 🎯 核心特性

- 🤖 **AI对话练习** - 混合AI引擎，50+真实场景，实时语法纠错
- 📚 **100K+词汇库** - A1-C2全覆盖，FSRS科学记忆算法
- 🎙️ **25位德国演讲者** - 真实演讲素材，从政治家到学者
- 🍅 **番茄时钟** - 25分钟学习+5分钟休息，科学时间管理（NEW!）
- 📊 **智能学习追踪** - 个性化学习路径，详细数据分析
- ✍️ **写作批改** - 基于规则的自动批改系统
- 🎧 **听力训练** - 12个分级听力材料，多种题型

### 💎 订阅方案

| 方案 | 价格 | AI调用/月 | 特点 |
|------|------|-----------|------|
| 🆓 免费版 | €0 | 规则引擎 | 核心功能免费，无广告 |
| 📅 月度 | €10/月 | 100次 | 灵活短期 |
| 📆 季度 | €20/季 | 200次 | 节省33% |
| 📅 年度 | €70/年 | 500次 | 节省42%，最受欢迎 |
| 👨‍👩‍👧‍👦 家庭组 | €150/年 | 500次 | 5人共享，每人€2.5/月 |

🎁 **7天免费试用**所有高级功能！

---

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.x 或更高版本
- Dart 3.x 或更高版本
- iOS 12.0+ 或 Android 7.0+

### 安装步骤

1. **克隆仓库**
```bash
git clone https://github.com/aeryn-deutsch/aeryn-deutsch.git
cd aeryn-deutsch
```

2. **安装依赖**
```bash
flutter pub get
```

3. **配置环境**

创建 `lib/config/env.dart`:
```dart
class Env {
  static const String openAIKey = String.fromEnvironment('OPENAI_KEY');
  static const String claudeKey = String.fromEnvironment('CLAUDE_KEY');
  static const String geminiKey = String.fromEnvironment('GEMINI_KEY');
}
```

4. **运行应用**

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web（开发用）
flutter run -d chrome
```

### 构建发布版本

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
flutter build appbundle --release
```

---

## 📁 项目结构

```
aeryn-deutsch/
├── lib/                    # 源代码
│   ├── main.dart          # 应用入口
│   ├── models/            # 数据模型
│   ├── services/          # 业务服务
│   ├── ui/                # 用户界面
│   │   ├── screens/      # 页面
│   │   └── widgets/      # 组件
│   └── data/             # 数据文件
├── assets/               # 资源文件
│   ├── audio/           # 音频文件
│   ├── images/          # 图片
│   └── fonts/           # 字体
├── docs/                # 文档
│   ├── C2_LEARNING_PATHWAY.md
│   ├── BETA_TEST_PLAN.md
│   ├── TEST_CASES.md
│   ├── PRIVACY_POLICY.md
│   └── TERMS_OF_SERVICE.md
├── test/                 # 测试文件
└── app_demo.html        # HTML演示
```

---

## 🎨 核心功能

### 1. 词汇学习系统 📚
- Flashcard翻转学习
- FSRS算法智能复习
- A1-C2分级词汇（100K+词）
- 中文/德语搜索
- 学习进度追踪

**文件**: `lib/ui/screens/vocabulary_screen.dart`

### 2. 语法学习系统 📖
- 动词变位表（100+动词）
- 名词格变表（四格）
- 形容词变格表（100+形容词）
- 词族系统（前缀+后缀）
- 句子剖析

**文件**: `lib/ui/screens/grammar_screen.dart`

### 3. AI对话系统 🤖
- 混合AI引擎（规则+付费）
- 50+对话场景
- 实时语法纠错
- 对话质量评分
- 7天免费试用

**文件**: `lib/ui/screens/ai_conversation_screen.dart`

### 4. 演讲学习系统 🎙️
- 25位德国演讲者
- 真实演讲素材
- 完整转录文本
- 中德对照翻译
- 重点词汇注释

**文件**: `lib/ui/screens/speech_learning_screen.dart`

### 5. 番茄时钟系统 🍅 🆕
- 25分钟学习+5分钟休息
- 圆形进度条
- 学习统计
- 连续天数追踪
- 可自定义配置

**文件**: `lib/ui/screens/pomodoro_screen.dart`

### 6. 订阅付费系统 💳
- 5种订阅方案
- 7天免费试用
- 配额管理
- 自动续费
- 无广告体验

**文件**: `lib/ui/screens/subscription_screen.dart`

---

## 📊 技术架构

### 状态管理
- Provider / Riverpod
- SharedPreferences（本地存储）
- flutter_secure_storage（安全存储）

### AI集成
- OpenAI API (GPT-4)
- Anthropic API (Claude)
- Google AI API (Gemini)
- 本地规则引擎（NLP）

### 算法
- FSRS（自由交替重复调度算法）
- 间隔重复记忆系统
- 语法规则引擎
- **灵动岛支持**: iOS 系统级集成

---

## 🏗 技术栈

| 层级 | 技术 | 用途 |
|------|------|------|
| **Frontend** | Flutter (Dart) | 跨平台 UI |
| **Logic** | Rust (via FFI) | 高性能语法解析 |
| **NLP** | spaCy (de_core_news_lg) | 德语语法分析 |
| **AI** | DeepSeek API | 新闻重写、语法解释 |
| **STT/TTS** | Whisper.cpp + Azure TTS | 语音识别与合成 |
| **Storage** | Isar/SQLite | 本地数据库 |
| **News API** | DW + Tagesschau RSS | 新闻源 |

---

## 📁 项目结构

```
aeryn-deutsch/
├── lib/
│   ├── core/              # 核心语法引擎
│   │   ├── grammar_engine.dart
│   │   ├── noun_colorizer.dart
│   │   ├── number_matrix.dart
│   │   └── complexity_engine.dart
│   ├── api/               # API 接口层
│   │   ├── news_client.dart
│   │   ├── ai_service.dart
│   │   └── deepseek_client.dart
│   ├── ui/                # UI 组件
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── news_screen.dart
│   │   │   ├── scalpel_screen.dart
│   │   │   └── number_lab_screen.dart
│   │   ├── widgets/
│   │   │   ├── color_coded_text.dart
│   │   │   ├── grammar_insight_panel.dart
│   │   │   └── word_card.dart
│   │   └── android/
│   │       └── widgets/
│   ├── models/            # 数据模型
│   │   ├── word.dart
│   │   ├── grammar_rule.dart
│   │   └── news_article.dart
│   └── services/          # 业务服务
│       ├── fsrs_service.dart
│       ├── vocabulary_service.dart
│       └── progress_tracker.dart
├── android/               # Android 原生代码
│   └── app/src/main/
├── ios/                   # iOS 原生代码
├── assets/                # 资源文件
│   ├── fonts/
│   ├── audio/
│   └── data/
└── rust_bridge/           # Rust FFI 层
```

---

## 🎯 开发路线图

### Sprint 1 (第1-2周): 核心骨架 ✅
- [x] 项目架构搭建
- [ ] 名词性别自动着色引擎
- [ ] 数字矩阵算法
- [ ] 基础数据模型

### Sprint 2 (第3-4周): AI 注入 🔄
- [ ] 新闻降级滤镜
- [ ] DeepSeek API 集成
- [ ] 长难句解剖刀 UI
- [ ] MVP Beta 版本发布

### Sprint 3 (第5-6周): 全功能优化 ⏳
- [ ] FSRS 复习系统
- [ ] AI 语音对话
- [ ] 词簇映射图谱

### Sprint 4 (第7-8周): 系统集成 ⏳
- [ ] Android 桌面小部件
- [ ] iOS 灵动岛适配
- [ ] 性能优化

---

## 🚦 快速开始

### 环境要求
- Flutter SDK >= 3.16
- Dart SDK >= 3.2
- Rust Toolchain (可选，用于 FFI)
- Android Studio / Xcode

### 安装步骤

```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/aeryn-deutsch.git
cd aeryn-deutsch

# 2. 安装依赖
flutter pub get

# 3. 运行 App
flutter run

# 4. 构建 Android APK
flutter build apk --release
```

---

## 🤝 贡献指南

我们欢迎所有形式的贡献！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🌟 致谢

- Deutsche Welle - 开放课程资源
- Tagesschau - 新闻源
- spaCy - NLP 引擎
- FSRS - 记忆算法

---

<div align="center">

**从多邻国的围墙中突围，让德语学习回归实战本质。**

Made with ❤️ by Aeryn OS Team

</div>
