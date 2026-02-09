# 📝 B选项完整教程：从零开始运行Aeryn-Deutsch

**适合计算机小白的超详细步骤**

**创建时间**: 2026年2月7日
**你的环境**: WSL2 Linux (Windows Subsystem for Linux)

---

## 🎯 总体流程图（心里有数）

```
第1步: 下载 Flutter SDK (10分钟)
  ↓
第2步: 配置环境变量 (5分钟)
  ↓
第3步: 下载依赖包 (10分钟)
  ↓
第4步: 运行测试 (5分钟)
  ↓
第5步: 打包APK (10分钟)
  ↓
完成！可以在手机上安装使用
```

预计总时间：**40-50分钟**

---

## ⚠️ 开始之前的重要提示

### 请一定要：
1. **一步一步来**，不要跳步骤
2. **每一步都截图**，万一出错好排查
3. **遇到问题就问我**，不要自己瞎猜

### 不要担心：
- ✅ 看不懂代码没关系，我们只需要运行它
- ✅ 有错误很正常，我能帮你解决
- ✅ 可以随时问我为什么

---

## 第1步：下载 Flutter SDK

### 📍 现在的位置
你在：`/home/dgr/deyu/aeryn-deutsch`

### 📥 开始下载

```bash
# 1. 进入你的家目录
cd ~

# 2. 下载 Flutter（只需要这一条命令）
git clone https://github.com/flutter/flutter.git -b stable --depth 1
```

**等待下载完成**（可能需要5-10分钟，看网速）

**你会看到**：
```
Cloning into 'flutter'...
Checking connectivity... done
Receiving objects... 100% (XXXX/XXXX), done.
```

### ✅ 验证下载成功

```bash
# 查看是否有 flutter 文件夹
ls -la flutter/
```

**应该看到**：
```
drwxrwxr-x  10 user group 4096 ... flutter/
```

---

## 第2步：配置环境变量

### 📍 永久添加到 PATH

```bash
# 编辑配置文件
nano ~/.bashrc
```

**操作步骤**：
1. 文件打开后，按 `↓` 键（下箭头）滚动到最底部
2. 在最后面**粘贴**这两行：

```bash
# Flutter
export PATH="$HOME/flutter/bin:$PATH"
```

3. 按 `Ctrl + O`（保存），然后按 `Enter`（确认）
4. 按 `Ctrl + X`（退出）

### 🔄 让配置生效

```bash
# 重新加载配置
source ~/.bashrc

# 验证（应该显示版本号）
flutter --version
```

**成功的话会看到**：
```
Flutter 3.16.0 • channel stable
...
```

**如果报错说 `flutter: command not found`**，说明：
- Flutter可能还在下载中
- 或配置没生效，重新运行 `source ~/.bashrc`

---

## 第3步：安装依赖包

### 📍 回到项目目录

```bash
cd /home/dgr/deyu/aeryn-deutsch
```

### 📦 下载所有需要的包

```bash
# 下载依赖
flutter pub get
```

**这一步会需要 5-15 分钟**，会看到很多输出：

```
Downloading packages...
Got dependencies!
```

**可能遇到的问题**：

#### 问题1：下载很慢
**解决**：
```bash
# 使用国内镜像加速（临时）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
flutter pub get
```

#### 问题2：某些包下载失败
**解决**：没关系，继续下一步

---

## 第4步：检查环境

### 🔍 运行 Flutter Doctor

```bash
flutter doctor -v
```

**这会检查所有需要的工具**

**你会看到一些** ❌ **和** ✅ **：

```
[✓] Flutter (Channel stable)
[✓] Android toolchain - develop for Android devices
[✓] VS Code
[✗] Android Studio (not installed)
```

**只要前两个有 ✅ 就可以运行了！**

---

## 第5步：准备构建Android APK

### 📍 配置Android SDK

```bash
# 安装 Android SDK
flutter doctor --android-licenses
```

**会问你接受许可证，输入 `y` 然后按回车**

---

## 第6步：构建APK（生成安装包）

### 📍 在项目目录下运行

```bash
cd /home/dgr/deyu/aeryn-deutsch
```

### 📦 打包 APK

```bash
# 打包成 APK
flutter build apk --release
```

**这一步需要 10-20 分钟**

**你会看到**：
```
Building Flutter application...
Compiling Dart...
...
Built build/apk/app-release.apk (25.3MB)
```

### 📂 APK 文件位置

```bash
# 查看生成的文件
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

**文件位置**：
```
/home/dgr/deyu/aeryn-deutsch/build/app/outputs/flutter-apk/app-release.apk
```

---

## 📤 第7步：复制到Windows

### 📍 把 APK 复制到 Windows

```bash
# 复制到 Windows 桌面
cp /home/dgr/deyu/aeryn-deutsch/build/app/outputs/flutter-apk/app-release.apk /mnt/c/Users/67842/Desktop/
```

### 🎯 现在你可以在Windows里找到这个文件

**位置**：`C:\Users\67842\Desktop\app-release.apk`

---

## 📱 第8步：安装到手机

### 通过数据线传输到手机：
1. 用 USB 连接手机到电脑
2. 把 `app-release.apk` 复制到手机
3. 在手机上找到这个文件，点击安装

### 或者发送到手机：
1. 用微信/邮件发送给自己
2. 在手机上接收并安装

---

## 🎉 完成！

现在你可以在手机上：
- ✅ 查看新闻
- ✅ 练习数字
- ✅ 语法练习
- ✅ 口语训练
- ✅ 写作训练

---

## 🆘 如果遇到问题

### 常见问题1：`flutter: command not found`

**原因**：配置没生效

**解决**：
```bash
# 临时解决
export PATH="$HOME/flutter/bin:$PATH"
flutter --version
```

### 常见问题2：`git: command not found`

**原因**：没有安装 git

**解决**：
```bash
sudo apt update
sudo apt install git -y
```

### 常见问题3：下载失败

**原因**：网络问题

**解决**：
```bash
# 使用代理（如果你有）
export http_proxy=http://127.0.0.1:7890

# 或者使用镜像
export PUB_HOSTED_URL=https://pub.flutter-io.cn
```

### 常见问题4：打包失败

**解决**：发给我错误信息

---

## 📊 进度追踪表

打印这个表，每完成一项就打勾：

```
Flutter 下载完成 □
环境配置完成 □
依赖包下载完成 □
flutter doctor 检查 □
APK 打包成功 □
复制到 Windows □
安装到手机 □
```

---

## 🤝 需要帮助吗？

### 如果卡在某一步：

1. **告诉我你在第几步**
2. **复制错误信息**（红色的字）
3. **告诉我你看到了什么**

我会：
1. 用最简单的话解释
2. 给你解决命令
3. 确保你能完成

---

## 💡 温馨提示

### 不要着急
- ✅ 这是你第一次学习，慢一点很正常
- ✅ 每个人都是从不会到会
- ✅ 我会一直陪着你

### 相信自己
- ✅ 你已经迈出了第一步
- ✅ 计算机其实不难
- ✅ 遇到问题都可以解决

---

**准备好了吗？让我们开始第1步！**

准备好了就告诉我：**"开始"**，我会带你做第一步！💪
