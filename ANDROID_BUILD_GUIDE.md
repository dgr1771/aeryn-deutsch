# Aeryn-Deutsch Android打包指南

**版本**: 1.0.0
**更新日期**: 2026-02-09

---

## 📱 准备工作

### 1. 环境要求

确保您的开发环境满足以下要求：

- **Flutter SDK**: 3.19.0 或更高版本
- **Android SDK**: API 33-34 (Android 13-14)
- **Gradle**: 8.0 或更高版本
- **Java**: JDK 11 或更高版本

### 2. 检查环境

```bash
# 检查Flutter环境
flutter doctor -v

# 检查Android许可证
flutter doctor --android-licenses
```

---

## 🔧 当前配置

### 应用信息

- **应用名称**: Aeryn-Deutsch
- **包名**: `com.aeryn.deutsch`
- **版本**: 1.0.0 (versionCode: 1)
- **最低SDK**: API 21 (Android 5.0)
- **目标SDK**: API 34 (Android 14)

### 已完成功能

✅ **自适应水平测试系统**
- A1级别：15题（基础语法）
- A2级别：15题（完成时、情态动词、关系从句）
- B1级别：15题（被动语态、虚拟式、复杂从句）
- B2级别：12题（高级语法、复杂结构）

✅ **核心学习功能**
- 词汇学习（Flashcard）
- 语法学习（颜色编码系统）
- AI对话练习
- 演讲学习
- 番茄时钟
- 订阅管理

---

## 📦 构建步骤

### 方式1：构建APK（推荐用于测试）

```bash
# 清理之前的构建
flutter clean

# 获取依赖
flutter pub get

# 构建Release APK（所有架构）
flutter build apk --release

# 构建特定架构APK（体积更小）
flutter build apk --release --split-per-abi

# 构建Debug APK（用于开发测试）
flutter build apk --debug
```

**输出位置**:
- Release APK: `build/app/outputs/flutter-apk/app-release.apk`
- 分架构APK: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- Debug APK: `build/app/outputs/flutter-apk/app-debug.apk`

### 方式2：构建App Bundle（推荐用于发布）

```bash
# 构建App Bundle
flutter build appbundle --release

# 输出位置
# build/app/outputs/bundle/release/app-release.aab
```

---

## 🎯 签名配置

### Debug签名（当前使用）

当前应用使用debug签名配置，仅用于测试：

```kotlin
// android/app/build.gradle.kts
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
    }
}
```

⚠️ **警告**: Debug签名的APK不能用于发布到Google Play！

### Release签名（生产环境）

#### 1. 生成密钥库

```bash
keytool -genkey -v -keystore ~/aeryn-deutsch.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias aeryn-deutsch
```

#### 2. 创建密钥属性文件

创建 `android/key.properties`:

```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=aeryn-deutsch
storeFile=/path/to/aeryn-deutsch.jks
```

#### 3. 更新build.gradle.kts

```kotlin
// 读取密钥配置
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 4. 添加到.gitignore

```
android/key.properties
*.jks
```

---

## 🚀 构建命令速查

```bash
# 1. 清理
flutter clean

# 2. 获取依赖
flutter pub get

# 3. 运行测试（可选）
flutter test

# 4. 构建APK
flutter build apk --release

# 5. 构建App Bundle
flutter build appbundle --release

# 6. 安装到设备
flutter install
```

---

## 📱 安装与测试

### 安装到Android设备

```bash
# 通过USB连接设备
flutter install

# 或手动安装APK
adb install build/app/outputs/flutter-apk/app-release.apk

# 卸载应用
adb uninstall com.aeryn.deutsch
```

### 查看设备日志

```bash
# 查看Flutter日志
flutter logs

# 查看Android日志
adb logcat | grep aeryn

# 查看特定标签日志
adb logcat -s flutter:aeryn
```

---

## 🔍 常见问题

### 1. SDK版本不匹配

**错误**: `Failed to find target with hash string 'android-XX'`

**解决方案**:
```bash
# 通过Android Studio安装缺失的SDK
# 或手动下载SDK Platform
```

### 2. Gradle构建失败

**解决方案**:
```bash
# 清理Gradle缓存
cd android
./gradlew clean

# 删除.gradle目录
rm -rf .gradle

# 重新构建
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### 3. 依赖冲突

**解决方案**:
```bash
# 升级依赖
flutter pub upgrade

# 查看过期依赖
flutter pub outdated

# 更新特定依赖
flutter pub upgrade package_name
```

### 4. 签名问题

**解决方案**:
```bash
# 验证密钥库
keytool -list -v -keystore aeryn-deutsch.jks

# 检查APK签名
apksigner verify --print-certs app-release.apk
```

---

## 📊 应用信息汇总

### 技术栈
- **框架**: Flutter 3.x
- **语言**: Dart
- **状态管理**: Riverpod
- **本地存储**: SharedPreferences, SQLite
- **网络**: Dio, HTTP

### 主要依赖
```
cupertino_icons: ^1.0.6
provider: ^6.1.5+1
riverpod: ^2.6.1
flutter_riverpod: ^2.6.1
shared_preferences: ^2.2.2
http: ^1.1.2
dio: ^5.4.0
flutter_tts: ^3.8.5
speech_to_text: ^6.6.0
```

### 权限要求
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

---

## ✅ 构建检查清单

### 构建前
- [ ] Flutter版本符合要求
- [ ] Android SDK已安装
- [ ] Gradle配置正确
- [ ] 依赖已更新
- [ ] 版本号已更新

### 构建中
- [ ] 无编译错误
- [ ] 无警告（或警告已确认）
- [ ] 资源文件正常

### 构建后
- [ ] APK/AAB文件生成
- [ ] 签名配置正确
- [ ] 应用信息正确
- [ ] 功能测试通过
- [ ] 性能测试通过

---

## 🎉 下一步

1. **安装测试**
   - 将APK安装到测试设备
   - 进行功能测试
   - 验证所有核心功能

2. **真机测试**
   - 在不同Android版本测试
   - 测试不同屏幕尺寸
   - 验证性能表现

3. **准备发布**
   - 准备应用图标
   - 制作应用截图
   - 编写应用描述
   - 准备隐私政策

4. **发布到Google Play**
   - 创建开发者账号
   - 上传应用Bundle
   - 填写商店信息
   - 提交审核

---

## 📞 技术支持

如有问题，请参考：
- [Flutter官方文档](https://flutter.dev/docs)
- [Android打包指南](https://flutter.dev/docs/deployment/android)
- [Google Play发布指南](https://play.google.com/console)

---

**版本**: 1.0.0
**更新日期**: 2026-02-09
**制作**: Aeryn OS Team
