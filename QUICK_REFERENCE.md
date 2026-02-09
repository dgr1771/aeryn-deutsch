# 🚀 命令速查卡（小白必备）

**遇到问题时，先查这个卡片**

---

## 🔍 快速诊断

### 问题：不确定 Flutter 安装了吗？
```bash
# 运行这个命令
flutter --version

# 如果显示 "Flutter 3.x.x"，说明安装了 ✅
# 如果显示 "command not found"，说明没安装 ❌
```

### 问题：项目在哪里？
```bash
# 查看当前位置
pwd

# 应该显示：
/home/dgr/deyu/aeryn-deutsch
```

### 问题：项目有损坏吗？
```bash
# 检查文件完整性
ls -la lib/core/

# 应该看到多个.dart文件
```

---

## 📋 必备命令速查

### 1️⃣ 基础命令

| 命令 | 作用 | 什么时候用 |
|------|------|----------|
| `ls` | 查看文件列表 | 想知道文件夹里有什么 |
| `pwd` | 查看当前位置 | 想知道自己在哪 |
| `cd 文件夹` | 进入文件夹 | 想去某个文件夹 |
| `cd ..` | 返回上一级 | 回到上级文件夹 |
| `nano 文件` | 编辑文件 | 修改文件内容 |
| `cp 文件 目标` | 复制文件 | 复制文件到其他地方 |
| `rm 文件` | 删除文件 | 删除不需要的文件 |

### 2️⃣ Flutter 命令

| 命令 | 作用 |
|------|------|
| `flutter --version` | 检查 Flutter 版本 |
| `flutter doctor` | 检查环境 |
| `flutter pub get` | 下载依赖包 |
| `flutter run` | 运行App（需要连接设备） |
| `flutter build apk` | 打包APK（安装包） |

### 3️⃣ 错误处理

| 问题 | 命令 | 说明 |
|------|------|------|
| 命令找不到 | `source ~/.bashrc` | 重新加载配置 |
| 下载慢 | `export PUB_HOSTED_URL=https://pub.flutter-io.cn` | 使用国内镜像 |
| 权限问题 | `sudo` | 在命令前加 sudo |
| 磁盘空间 | `df -h` | 查看磁盘空间 |

---

## 🚨 紧急救援

### 如果一切都不对：

```bash
# 1. 重置一切
cd /home/dgr/deyu/aeryn-deutsch

# 2. 重新下载依赖
rm -f pubspec.lock
flutter pub get

# 3. 检查环境
flutter doctor -v

# 4. 打包
flutter build apk --release
```

---

## 📞 快速联系我

### 遇到问题时请告诉我：

1. **你在第几步**？（例如：第3步）
2. **完整的错误信息**（复制红色的文字）
3. **你看到的画面**（简单描述）

### 我会这样帮你：

1. 用最简单的语言解释
2. 给你具体的命令
3. 确保你能完成

---

## 💾 Windows 路径速查

### WSL 和 Windows 的路径对应

| WSL路径 | Windows 路径 | 用途 |
|---------|-----------|------|
| `/home/dgr/` | `\\wsl$\Ubuntu\home\dgr\` | 你的主目录 |
| `/mnt/c/Users/` | `C:\Users\` | Windows 用户目录 |
| `/mnt/c/Users/67842/` | `C:\Users\67842\` | 你的桌面 |
| `/mnt/d/` | `D:\` | D盘 |

### 复制文件到 Windows

```bash
# 例如：复制APK到桌面
cp /home/dgr/deyu/aeryn-deutsch/xxx.apk /mnt/c/Users/67842/Desktop/
```

---

## ✅ 检查清单

### 在开始之前，确认这几点：

- [ ] 你知道自己在哪个目录（`pwd`）
- [ ] 你知道项目目录在哪里
- [ ] 你有 10GB 以上的磁盘空间
- [ ] 你的网络连接正常
- [ ] 你已经阅读了 STEP_BY_STEP.md

### 运行中检查：

- [ ] Flutter 已安装（`flutter --version`）
- [ ] 依赖包已下载（`flutter pub get`）
- [ ] 没有红色错误信息
- [ ] APK 文件已生成（`ls -lh build/app/outputs/`）

---

## 🎯 当前目标

### 你的第一个任务：

```
目标：生成 app-release.apk 文件
位置：/home/dgr/deyu/aeryn-deutsch/build/app/outputs/flutter-apk/

完成标志：
当运行 ls 命令能看到 app-release.apk 文件时，
说明成功！✅
```

---

## 🆘 需要帮助？

**现在就可以问我任何问题！**

例如：
- "我在第3步，卡住了"
- "这个错误是什么意思？"
- "我该输入什么命令？"

**我会一步步指导你！**

---

**记住**：一步一步来，不要着急！💪

（这个卡片随时可以查）
