# Aeryn-Deutsch 视觉设计指南

**版本**: v2.8.1
**设计理念**: 沉浸式学习、语法可视化、极简主义

---

## 🎨 核心设计原则

### 1. 沉浸式学习体验
- **无干扰**: 移除所有与德语学习无关的功能
- **专注**: 单一任务界面，避免多任务干扰
- **流畅**: 快速响应，无等待时间
- **无广告**: 付费用户享受纯净学习环境

### 2. 语法可视化
- **颜色编码**: 德语语法核心概念用颜色区分
- **视觉记忆**: 通过颜色强化名词性别记忆
- **即时反馈**: 语法错误用颜色高亮显示

### 3. 极简主义
- **留白**: 充足的空间让眼睛休息
- **层次**: 信息分层，重点突出
- **一致**: 统一的设计语言

---

## 🌈 配色方案

### 主题色（Primary Colors）

```dart
// 主色调 - 专业、专注
Color primaryColor = Color(0xFF667EEA);  // 紫蓝色

// 辅助色 - 高级感
Color secondaryColor = Color(0xFF764BA2);  // 深紫色

// 强调色 - 重要操作
Color accentColor = Color(0xFFF59E0B);  // 琥珀色
```

### 德语语法颜色（核心特色）

```dart
// 名词性别颜色 - 德语学习的视觉记忆系统
class GermanGenderColors {
  static const Color der = Color(0xFF3B82F6);  // 蓝色 - 阳性
  static const Color die = Color(0xFFEC4899);  // 粉色 - 阴性
  static const Color das = Color(0xFF10B981);  // 绿色 - 中性
}

// 使用示例：
// der Hund (阳性名词用蓝色)
// die Katze (阴性名词用粉色)
// das Kind (中性名词用绿色)
```

### 功能色（Functional Colors）

```dart
class FunctionalColors {
  // 成功/完成
  static const Color success = Color(0xFF10B981);  // 绿色

  // 警告/注意
  static const Color warning = Color(0xFFF59E0B);  // 琥珀色

  // 错误/危险
  static const Color error = Color(0xFFEF4444);    // 红色

  // 信息/提示
  static const Color info = Color(0xFF3B82F6);     // 蓝色

  // 进行中
  static const Color inProgress = Color(0xFF8B5CF6); // 紫色
}
```

### 中性色（Neutral Colors）

```dart
class NeutralColors {
  // 文本颜色
  static const Color textPrimary = Color(0xFF1F2937);     // 深灰
  static const Color textSecondary = Color(0xFF6B7280);   // 中灰
  static const Color textTertiary = Color(0xFF9CA3AF);    // 浅灰

  // 背景颜色
  static const Color background = Color(0xFFF9FAFB);      // 极浅灰
  static const Color surface = Color(0xFFFFFFFF);         // 白色

  // 边框颜色
  static const Color border = Color(0xFFE5E7EB);          // 浅灰边框
  static const Color divider = Color(0xFFF3F4F6);         // 分割线
}
```

### 亮色主题（Light Theme）

```dart
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF667EEA),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Color(0xFFF9FAFB),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
  ),
);
```

### 暗色主题（Dark Theme）

```dart
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF667EEA),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: Color(0xFF111827),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: Color(0xFF1F2937),
    foregroundColor: Colors.white,
  ),
);
```

---

## 📐 尺寸规范

### 间距系统（Spacing）

```dart
class Spacing {
  static const double xs = 4.0;   // 极小间距
  static const double sm = 8.0;   // 小间距
  static const double md = 16.0;  // 中等间距
  static const double lg = 24.0;  // 大间距
  static const double xl = 32.0;  // 超大间距
  static const double xxl = 48.0; // 特大间距
}
```

### 圆角系统（Border Radius）

```dart
class BorderRadius {
  static const double sm = 8.0;   // 小圆角（按钮、标签）
  static const double md = 12.0;  // 中圆角（卡片内元素）
  static const double lg = 16.0;  // 大圆角（卡片）
  static const double xl = 24.0;  // 超大圆角（对话框）
  static const double full = 999.0; // 完全圆角（标签、徽章）
}
```

### 阴影系统（Elevation）

```dart
class Elevation {
  static const double level0 = 0.0;   // 无阴影（平面元素）
  static const double level1 = 1.0;   // 极浅阴影（悬浮按钮）
  static const double level2 = 2.0;   // 浅阴影（卡片）
  static const double level4 = 4.0;   // 中阴影（弹出菜单）
  static const double level8 = 8.0;   // 深阴影（对话框、底部抽屉）
}
```

### 图标尺寸（Icon Sizes）

```dart
class IconSizes {
  static const double xs = 16.0;  // 极小图标（列表标记）
  static const double sm = 20.0;  // 小图标（按钮图标）
  static const double md = 24.0;  // 中图标（标准图标）
  static const double lg = 32.0;  // 大图标（功能入口）
  static const double xl = 48.0;  // 超大图标（空状态插图）
}
```

---

## 🔤 字体系统

### 字体家族

```dart
class FontFamily {
  static const String primary = 'NotoSans';  // 主要字体（支持中德英）
  static const String mono = 'RobotoMono';   // 等宽字体（代码、语法分析）
}
```

### 字体大小（Font Sizes）

```dart
class FontSizes {
  // 标题
  static const double h1 = 28.0;  // 一级标题（页面标题）
  static const double h2 = 24.0;  // 二级标题（区块标题）
  static const double h3 = 20.0;  // 三级标题（卡片标题）
  static const double h4 = 18.0;  // 四级标题（子标题）

  // 正文
  static const double bodyLarge = 16.0;  // 大正文（主要内容）
  static const double bodyMedium = 14.0; // 中正文（常规内容）
  static const double bodySmall = 12.0;  // 小正文（辅助信息）

  // 标签
  static const double labelLarge = 14.0;  // 大标签（按钮文本）
  static const double labelMedium = 12.0; // 中标签（表单标签）
  static const double labelSmall = 10.0;  // 小标签（说明文字）
}
```

### 字重（Font Weight）

```dart
class FontWeight {
  static const FontWeight light = FontWeight.w300;    // 细体（次要文本）
  static const FontWeight regular = FontWeight.w400;  // 常规（正文）
  static const FontWeight medium = FontWeight.w500;   // 中等（强调）
  static const FontWeight semibold = FontWeight.w600; // 半粗（小标题）
  static const FontWeight bold = FontWeight.w700;     // 粗体（标题）
}
```

---

## 🎯 组件设计规范

### 卡片（Card）

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.05),
        ],
      ),
    ),
    child: /* 内容 */,
  ),
)
```

### 按钮（Button）

```dart
// 主要按钮
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('主要操作'),
)

// 次要按钮
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    side: BorderSide(color: primaryColor),
  ),
  child: Text('次要操作'),
)

// 文本按钮
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  child: Text('文本操作'),
)
```

### 进度指示器（Progress Indicator）

```dart
// 圆形进度环
SizedBox(
  width: 120,
  height: 120,
  child: Stack(
    alignment: Alignment.center,
    children: [
      // 背景环
      CircularProgressIndicator(
        value: progress,
        strokeWidth: 8,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
      ),
      // 中心文字
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(level, style: TextStyle(fontSize: 32, fontWeight: bold)),
          Text('$progress%', style: TextStyle(fontSize: 14)),
        ],
      ),
    ],
  ),
)

// 线性进度条
LinearProgressIndicator(
  value: progress,
  backgroundColor: Colors.grey[200],
  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
  minHeight: 8,
)
```

### 输入框（Text Field）

```dart
TextField(
  decoration: InputDecoration(
    hintText: '请输入...',
    hintStyle: TextStyle(color: textSecondary),
    filled: true,
    fillColor: surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

---

## 🧩 布局系统

### 网格布局（Grid）

```dart
GridView.count(
  crossAxisCount: 3,  // 3列
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  childAspectRatio: 1.1,  // 宽高比
  children: [
    /* 网格项 */,
  ],
)
```

### 列表布局（List）

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(height: 1),
  itemBuilder: (context, index) {
    return ListTile(
      leading: Icon(Icons.icon),
      title: Text(items[index].title),
      subtitle: Text(items[index].subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => /* 点击事件 */,
    );
  },
)
```

### 卡片列表（Card List）

```dart
ListView(
  padding: EdgeInsets.all(16),
  children: [
    _buildCard(/* 卡片1 */),
    SizedBox(height: 12),
    _buildCard(/* 卡片2 */),
    SizedBox(height: 12),
    _buildCard(/* 卡片3 */),
  ],
)
```

---

## 🎭 动画与过渡

### 页面过渡

```dart
// 淡入淡出
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
)

// 滑动进入
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );
    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  },
)
```

### 状态变化动画

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  decoration: BoxDecoration(
    color: isActive ? primaryColor : secondaryColor,
    borderRadius: BorderRadius.circular(12),
  ),
  child: /* 内容 */,
)
```

---

## 📱 响应式设计

### 断点系统（Breakpoints）

```dart
class Breakpoints {
  static const double mobile = 375;   // 手机
  static const double tablet = 768;   // 平板
  static const double desktop = 1024; // 桌面
}
```

### 自适应布局

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 900) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

---

## 🌙 暗色模式适配

### 自动切换

```dart
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system,  // 跟随系统
)
```

### 手动切换

```dart
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
)
```

---

## ✨ 特殊效果

### 渐变背景

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF667EEA),
        Color(0xFF764BA2),
      ],
    ),
  ),
  child: /* 内容 */,
)
```

### 模糊效果

```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(
    color: Colors.white.withValues(alpha: 0.1),
    child: /* 内容 */,
  ),
)
```

### 语法高亮

```dart
RichText(
  text: TextSpan(
    children: [
      TextSpan(text: 'Der ', style: defaultStyle),
      TextSpan(
        text: 'Hund',
        style: defaultStyle.copyWith(color: GermanGenderColors.der),
      ),
      TextSpan(text: ' ist toll.', style: defaultStyle),
    ],
  ),
)
```

---

## 📊 数据可视化

### 进度环

```dart
CustomPaint(
  size: Size(120, 120),
  painter: ProgressRingPainter(
    progress: 0.75,
    color: primaryColor,
    backgroundColor: Colors.grey[200],
  ),
)
```

### 热力图

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 7,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
  ),
  itemBuilder: (context, index) {
    final activityLevel = getActivityLevel(index);
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: activityLevel),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  },
)
```

---

## 🎯 可访问性

### 语义标签

```dart
Semantics(
  label: '德语对话练习按钮',
  hint: '点击开始AI对话练习',
  button: true,
  child: ElevatedButton(
    onPressed: () => /* 点击事件 */,
    child: Text('开始对话'),
  ),
)
```

### 最小触摸目标

```dart
// 确保所有可点击元素至少为 48x48 像素
GestureDetector(
  onTap: () => /* 点击事件 */,
  child: Container(
    width: 48,
    height: 48,
    alignment: Alignment.center,
    child: Icon(Icons.icon),
  ),
)
```

---

## 📝 实际应用示例

### 首页进度环

```dart
Stack(
  alignment: Alignment.center,
  children: [
    SizedBox(
      width: 120,
      height: 120,
      child: CircularProgressIndicator(
        value: 0.75,
        strokeWidth: 8,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(
          GermanGenderColors.der,
        ),
      ),
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'B1',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: GermanGenderColors.der,
          ),
        ),
        Text(
          '75%',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  ],
)
```

### 语法高亮卡片

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '德语名词性别',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _buildGenderExample('der', 'Hund', '狗'),
        _buildGenderExample('die', 'Katze', '猫'),
        _buildGenderExample('das', 'Kind', '孩子'),
      ],
    ),
  ),
)

Widget _buildGenderExample(String article, String noun, String meaning) {
  Color? color;
  switch (article) {
    case 'der': color = GermanGenderColors.der; break;
    case 'die': color = GermanGenderColors.die; break;
    case 'das': color = GermanGenderColors.das; break;
  }

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black87),
        children: [
          TextSpan(
            text: '$article ',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '$noun ',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '($meaning)'),
        ],
      ),
    ),
  );
}
```

---

**版本**: v2.8.1
**最后更新**: 2026-02-09
**设计团队**: Aeryn OS Team
