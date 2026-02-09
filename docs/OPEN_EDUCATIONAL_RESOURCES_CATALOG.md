# Aeryn-Deutsch 开放教育资源 (OER) 目录

本文档列出了所有合法可用的开源德语学习资源，可作为Aeryn-Deutsch的知识库。

## 📚 资源概览

| 资源类型 | 数量 | 许可证 | 状态 |
|---------|------|--------|------|
| 开源教材 | 5+ | CC BY/CC BY-SA | ✅ 可用 |
| 语法数据集 | 8+ | 开源 | ✅ 可用 |
| 词汇数据库 | 6+ | 开源/CC | ✅ 可用 |
| 语料库 | 10+ | 学术许可 | ✅ 可用 |
| 音频资源 | 1+ | 免费 | ✅ 可用 |

---

## 🎓 核心开源教材

### 1. Deutsch im Blick (德语视界)
- **来源**: 德克萨斯大学奥斯汀分校 COERLL
- **许可**: Creative Commons Attribution (CC BY)
- **级别**: A1-A2 (初学者)
- **内容**:
  - 10章完整教材
  - 语法讲解 (Grimm Grammar)
  - 词汇表
  - 视频和音频
  - 练习题
- **网址**: https://coerll.utexas.edu/dib/
- **用途**: ✅ 可完全集成到app
- **集成方式**:
  - 下载词汇表为CSV
  - 提取语法规则
  - 导入练习题

### 2. Deutsche Welle (德国之声) 免费课程
- **来源**: 德国国际广播公司
- **许可**: 免费教育用途
- **级别**: A1-C1 (全级别)
- **内容**:
  - Nicos Weg (A1-B1)
  - Harry - gefangen in der Zeit
  - Langsam gesprochene Nachrichten
  - Top-Thema mit Vokabeln
  - 视频、音频、文本
- **网址**: https://learngerman.dw.com/
- **用途**: ✅ 可链接和引用
- **集成方式**:
  - 作为外部学习资源链接
  - 音频用于听力练习
  - 文本用于阅读理解

### 3. Goethe-Institut OER材料
- **来源**: 歌德学院
- **许可**: 部分OER许可
- **级别**: A1-C2
- **内容**:
  - 在线练习 (270+)
  - 语法练习
  - 词汇训练
  - 学习游戏
- **网址**: https://www.goethe.de/de/spr/ueb.html
- **用途**: ✅ 可免费使用
- **集成方式**:
  - 链接到官方练习
  - 参考教学大纲

---

## 📊 GitHub开源数据集

### 语法数据集

#### 1. German Nouns Database
- **仓库**: https://github.com/gambolputty/german-nouns
- **许可**: 开源
- **内容**: ~100,000个德语名词及语法属性
- **格式**: CSV
- **数据包含**:
  - 词性 (der/die/das)
  - 复数形式
  - 格变位
- **集成价值**: ⭐⭐⭐⭐⭐
  - 完全替代现有词汇库
  - 100倍规模扩充

#### 2. German Verbs Database
- **仓库**: https://github.com/viorelsfetea/german-verbs-database
- **许可**: 开源 (基于Wiktionary)
- **内容**: 德语动词变位数据库
- **格式**: CSV
- **数据包含**:
  - 动词不定式
  - 所有变位形式
  - 不规则变化
- **集成价值**: ⭐⭐⭐⭐⭐
  - 完整动词变位表
  - 替代手工录入

#### 3. Declension Dataset
- **仓库**: https://github.com/highsource/declension-dataset
- **许可**: 开源
- **内容**: 德语名词变格数据集
- **格式**: 结构化机器可读
- **集成价值**: ⭐⭐⭐⭐
  - 自动化语法检查
  - 冠词匹配验证

#### 4. German NLP Resources
- **仓库**: https://github.com/adbar/German-NLP
- **许可**: 开源集合
- **内容**: 德语NLP工具和资源列表
- **集成价值**: ⭐⭐⭐⭐
  - 扩展性工具
  - 高级功能集成

### 词汇数据库

#### 1. German Word Frequencies
- **仓库**: https://github.com/olastor/german-word-frequencies
- **许可**: 开源
- **内容**: 基于语料库的德语词频
- **格式**: 映射表
- **集成价值**: ⭐⭐⭐⭐⭐
  - 按频率排序学习
  - 重点词汇优先

#### 2. DAFlex CEFR-graded Lexicon
- **来源**: UCLouvain
- **许可**: 学术资源
- **内容**: 按CEFR分级的德语词汇
- **网址**: https://cental.uclouvain.be/cefrlex/daflex/
- **集成价值**: ⭐⭐⭐⭐⭐
  - 精确级别划分
  - 学习路径优化

---

## 🎓 CEFR语料库

### 1. European Language Grid - CEFR Corpus
- **内容**: ±500篇德语文本，按A1-C2标注
- **许可**: ELG许可
- **网址**: https://live.european-language-grid.eu/catalogue/corpus/9476
- **集成价值**: ⭐⭐⭐⭐⭐
  - 阅读理解材料
  - 难度分级标准

### 2. MERLIN Corpus
- **内容**: 2,290篇学习者文本 (A1-C1)
- **来源**: 标准化语言认证考试
- **许可**: LREC学术
- **集成价值**: ⭐⭐⭐⭐
  - 写作评估参考
  - 错误模式识别

### 3. Kolipsi Corpus Family
- **内容**: 德语和意大利语学习者语料库
- **许可**: 开放获取
- **集成价值**: ⭐⭐⭐
  - 学习者语言研究
  - 错误分析

### 4. UniversalCEFR Dataset
- **平台**: Hugging Face
- **内容**: 多语言CEFR标注数据集
- **网址**: https://huggingface.co/UniversalCEFR
- **集成价值**: ⭐⭐⭐⭐
  - 机器学习训练
  - 自动难度评估

---

## 🎯 OER平台资源

### OER Commons - German
- **网址**: https://oercommons.org/browse?f.keyword=german
- **许可**: Creative Commons
- **内容类型**:
  - 课程大纲
  - 练习材料
  - 评估工具
  - 多媒体资源
- **集成价值**: ⭐⭐⭐⭐

### University of Florida German Studies OER Guide
- **网址**: https://guides.uflib.ufl.edu/germanstudies/oer
- **内容**: 精选德语研究开放获取材料
- **分类**:
  - 语法教程
  - 阅读材料
  - 文化资源
  - 视听材料

---

## 📝 实施计划

### Phase 1: 核心数据集下载 (优先级: P0)

**目标**: 整合关键开源数据集

#### 1.1 词汇数据库 (2-3天)
```bash
# 下载German Nouns Database
wget https://github.com/gambolputty/german-nouns/raw/master/nouns.csv

# 下载German Verbs Database
wget https://github.com/viorelsfetea/german-verbs-database/raw/master/output/verbs.csv

# 下载词频数据
wget https://github.com/olastor/german-word-frequencies/raw/master/word-freq.csv
```

**集成步骤**:
1. 解析CSV文件
2. 数据清洗和去重
3. CEFR级别标注
4. 导入到 `lib/data/vocabulary_database.dart`
5. 创建API端点供UI调用

#### 1.2 语法数据集 (2-3天)
```bash
# 下载变格数据集
wget https://github.com/highsource/declension-dataset/raw/master/declensions.json

# 下载动词变位
wget https://github.com/viorelsfetea/german-verbs-database/raw/master/conjugations.json
```

**集成步骤**:
1. 解析JSON数据
2. 更新 `GermanGrammarRules` 类
3. 增强语法检查引擎
4. 添加更多语法规则

#### 1.3 Deutsch im Blick教材 (1-2天)
```bash
# 从COERLL下载词汇表
wget https://coerll.utexas.edu/dib/vocabulary.csv

# 下载语法规则
wget https://coerll.utexas.edu/dib/grammar-rules.json
```

**集成步骤**:
1. 提取结构化数据
2. 按章节组织
3. 添加到学习路径
4. 创建配套练习

### Phase 2: 高级功能集成 (优先级: P1)

#### 2.1 CEFR语料库集成 (3-4天)
- 从ELG下载CEFR标注文本
- 创建阅读理解模块
- 实现难度自动评估
- 添加分级推荐系统

#### 2.2 学习者语料库分析 (2-3天)
- 分析MERLIN corpus
- 识别常见错误模式
- 改进错误报告系统
- 优化写作评估算法

#### 2.3 DW内容整合 (2天)
- 创建DW内容浏览器
- 音频播放器集成
- 自动字幕显示
- 词汇高亮和注释

### Phase 3: 质量提升 (优先级: P2)

#### 3.1 数据质量验证 (2天)
- 交叉验证多个数据源
- 清理不一致数据
- 标注可信度
- 创建验证报告

#### 3.2 本地化适配 (2天)
- 中文翻译优化
- 文化注释添加
- 学习指南编写
- 用户手册制作

---

## 🔗 资源链接汇总

### 开源教材
- Deutsch im Blick: https://coerll.utexas.edu/dib/
- DW Learn German: https://learngerman.dw.com/
- Goethe-Institut OER: https://www.goethe.de/en/kul/wis/ser/kdz/oer.html

### GitHub数据集
- German Nouns: https://github.com/gambolputty/german-nouns
- German Verbs: https://github.com/viorelsfetea/german-verbs-database
- Declension Dataset: https://github.com/highsource/declension-dataset
- Word Frequencies: https://github.com/olastor/german-word-frequencies
- German NLP: https://github.com/adbar/German-NLP

### 语料库
- ELG CEFR Corpus: https://live.european-language-grid.eu/catalogue/corpus/9476
- UniversalCEFR: https://huggingface.co/UniversalCEFR
- DAFlex: https://cental.uclouvain.be/cefrlex/daflex/

### OER平台
- OER Commons German: https://oercommons.org/browse?f.keyword=german
- UF German Studies OER: https://guides.uflib.ufl.edu/germanstudies/oer

---

## 📋 许可证合规检查

### ✅ 完全可用 (可商用/修改)
- Deutsch im Blick (CC BY) - 需署名
- GitHub开源数据集 (各项目许可证)
- OER Commons (CC许可)

### ✅ 教育用途免费
- Deutsche Welle内容
- Goethe-Institut材料

### ⚠️ 需确认
- 部分语料库需查看具体许可
- 商业使用需联系版权方

### ❌ 不可用
- 付费教材 (Babbel, Rosetta Stone等)
- 大学课程录像 (Harvard, Yale等)
- Khan Academy专有内容

---

## 🎯 预期成果

### 数据规模提升
| 指标 | 当前 | 整合后 | 提升 |
|------|------|--------|------|
| 词汇量 | ~100 | 100,000+ | 1000x |
| 动词变位 | ~50 | 10,000+ | 200x |
| 名词变格 | ~100 | 100,000 | 1000x |
| 语法规则 | ~20 | 100+ | 5x |
| 阅读材料 | 0 | 500+ | ∞ |

### 功能提升
- ✅ 完整CEFR A1-C2覆盖
- ✅ 真实语料库驱动学习
- ✅ 基于频率的词汇学习
- ✅ 精确难度分级
- ✅ 专业语法检查
- ✅ 大规模题库

---

## 📞 联系方式

如有疑问或需要帮助整合这些资源，请查看:
- 本文档: `docs/OPEN_EDUCATIONAL_RESOURCES_CATALOG.md`
- 实施进度: 查看 `docs/INTEGRATION_PROGRESS.md` (待创建)
- 技术问题: GitHub Issues

---

**最后更新**: 2026-02-08
**维护者**: Aeryn-Deutsch 开发团队
**许可**: 本文档采用 CC BY 4.0 许可证
