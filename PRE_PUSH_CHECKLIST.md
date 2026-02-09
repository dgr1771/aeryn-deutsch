# 推送前验证清单

**在推送到GitHub Actions前，请务必完成以下检查**

---

## ✅ 必须检查的项目

### 1. Android配置文件

- [ ] **MainActivity.kt** 正确实现V2 embedding
  ```kotlin
  package com.aeryn.deutsch

  import io.flutter.embedding.android.FlutterActivity
  import io.flutter.embedding.engine.FlutterEngine
  import io.flutter.plugins.GeneratedPluginRegistrant

  class MainActivity: FlutterActivity() {
      override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
          GeneratedPluginRegistrant.registerWith(flutterEngine)
      }
  }
  ```

- [ ] **AndroidManifest.xml** 配置正确
  - ✅ 没有 `android:name` 在 `<application>` 标签
  - ✅ 有 `<meta-data android:name="flutterEmbedding" android:value="2" />`
  - ✅ Activity使用 `android:name=".MainActivity"`

- [ ] **build.gradle.kts** SDK版本正确
  ```kotlin
  compileSdk = 34
  minSdk = 21
  targetSdk = 34
  ```

### 2. 依赖配置

- [ ] **pubspec.yaml** 依赖版本正确
  ```yaml
  environment:
    sdk: '>=3.2.0 <4.0.0'

  dependencies:
    sqflite: ^2.3.3+1  # 必须是2.3.3+1，不能用2.4.2
    path: ^1.9.0       # 必须是1.9.0，不能用1.9.1
    audio_session: ^0.1.18
  ```

### 3. 本地测试（如果有完整环境）

```bash
# 执行以下命令确保无错误
flutter clean
flutter pub get
flutter analyze
```

---

## 📋 当前项目状态

### ✅ 已完成的配置

1. ✅ MainActivity正确实现V2 embedding
2. ✅ AndroidManifest.xml配置正确
3. ✅ build.gradle.kts SDK版本为34
4. ✅ 依赖版本已修复（sqflite、path）
5. ✅ 包名统一为com.aeryn.deutsch
6. ✅ GitHub Actions工作流配置完成

### 🔄 GitHub Actions状态

最新提交：`e135858 - fix: 移除可能导致问题的taskAffinity配置`

查看构建：https://github.com/dgr1771/aeryn-deutsch/actions

---

## 🚨 常见问题快速修复

### 问题1: "deprecated version of Android embedding"

**检查**：
1. MainActivity是否继承FlutterActivity并实现configureFlutterEngine
2. AndroidManifest.xml是否有flutterEmbedding=2
3. 是否没有设置application的android:name

### 问题2: 依赖冲突

**sqflite冲突**：使用 `^2.3.3+1`
**path冲突**：使用 `^1.9.0`

### 问题3: SDK版本问题

确保：
- compileSdk = 34
- targetSdk = 34
- minSdk = 21

---

## 📊 当前配置摘要

| 配置项 | 当前值 | 状态 |
|--------|--------|------|
| SDK版本 | >=3.2.0 <4.0.0 | ✅ |
| sqflite | ^2.3.3+1 | ✅ |
| path | ^1.9.0 | ✅ |
| compileSdk | 34 | ✅ |
| minSdk | 21 | ✅ |
| targetSdk | 34 | ✅ |
| MainActivity | FlutterActivity + configureFlutterEngine | ✅ |
| flutterEmbedding | 2 | ✅ |
| 包名 | com.aeryn.deutsch | ✅ |

---

## 🎯 下一步

1. 访问 https://github.com/dgr1771/aeryn-deutsch/actions
2. 查看最新构建状态
3. 如果成功，下载APK并测试
4. 如果失败，根据错误信息修复

---

**所有配置已按标准完成，应该可以成功构建！** ✅

更新日期: 2026-02-09
