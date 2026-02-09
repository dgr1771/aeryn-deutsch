#!/bin/bash
# 使用 Docker 构建 Flutter APK
# 这样可以避免在 WSL 中配置完整的 Android SDK

set -e

echo "🐳 准备使用 Docker 构建 Flutter APK..."

echo "🔨 构建 APK (Release)..."
docker run --rm \
    -v "$(pwd):/workspace" \
    -w /workspace \
    ghcr.io/cirruslabs/flutter:3.19.0 \
    bash -c "
        echo '🔧 清理旧的构建...'
        flutter clean
        rm -rf build/

        echo '📥 获取依赖...'
        flutter pub get

        echo '🔨 构建 APK (Release)...'
        flutter build apk --release --target-platform android-arm,android-arm64,android-x64

        echo ''
        echo '✅ 构建完成！'
        echo '📱 APK 位置: build/app/outputs/flutter-apk/app-release.apk'
        ls -lh build/app/outputs/flutter-apk/app-release.apk
    "

echo ""
echo "🎉 成功！APK 文件已生成"
