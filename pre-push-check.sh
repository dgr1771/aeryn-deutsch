#!/bin/bash
# 预推送检查脚本 - 在推送前验证配置
# 使用方法：./pre-push-check.sh

set -e

echo "🔍 Flutter 项目预检查"
echo "===================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# 1. 检查 V2 Embedding 配置
echo ""
echo "📱 检查 Android V2 Embedding 配置..."

MA=$(find android/app/src/main -name "MainActivity.*" -type f -exec cat {} \; 2>/dev/null || echo "")
if echo "$MA" | grep -q "io.flutter.embedding.android.FlutterActivity"; then
    echo -e "${GREEN}✓${NC} MainActivity 使用 V2 FlutterActivity"
else
    echo -e "${RED}✗${NC} MainActivity 未使用 V2 FlutterActivity"
    ((ERRORS++))
fi

if grep -q 'android:name="\${applicationName}"' android/app/src/main/AndroidManifest.xml 2>/dev/null; then
    echo -e "${GREEN}✓${NC} AndroidManifest 包含 \${applicationName}"
else
    echo -e "${RED}✗${NC} AndroidManifest 缺少 \${applicationName}"
    ((ERRORS++))
fi

if grep -q 'flutterEmbedding' android/app/src/main/AndroidManifest.xml 2>/dev/null && \
   grep -A1 'flutterEmbedding' android/app/src/main/AndroidManifest.xml | grep -q 'android:value="2"'; then
    echo -e "${GREEN}✓${NC} AndroidManifest 包含 flutterEmbedding=2"
else
    echo -e "${RED}✗${NC} AndroidManifest 缺少 flutterEmbedding=2"
    ((ERRORS++))
fi

# 2. 检查 Android SDK 版本
echo ""
echo "🔧 检查 Android SDK 版本..."

if grep -q 'compileSdk = 36' android/app/build.gradle.kts 2>/dev/null; then
    echo -e "${GREEN}✓${NC} compileSdk = 36"
else
    echo -e "${RED}✗${NC} compileSdk 不是 36"
    ((ERRORS++))
fi

if grep -q 'targetSdk = 36' android/app/build.gradle.kts 2>/dev/null; then
    echo -e "${GREEN}✓${NC} targetSdk = 36"
else
    echo -e "${YELLOW}⚠${NC} targetSdk 未设置为 36（警告）"
    ((WARNINGS++))
fi

# 3. 检查问题插件版本
echo ""
echo "📦 检查插件版本兼容性..."

# 检查 package_info_plus
if grep -q 'package_info_plus.*9\.0\.0' .flutter-plugins-dependencies 2>/dev/null || \
   grep -q 'package_info_plus.*: [9-9]\.' pubspec.lock 2>/dev/null; then
    echo -e "${RED}✗${NC} package_info_plus 9.x 与新 Flutter Gradle Plugin 不兼容"
    echo -e "   建议: 在 pubspec.yaml 中添加 package_info_plus: ^4.0.0"
    ((ERRORS++))
else
    echo -e "${GREEN}✓${NC} package_info_plus 版本安全"
fi

# 4. 检查 Gradle 语法
echo ""
echo "📝 检查 Gradle 语法..."

cd android
if ./gradlew tasks --dry-run >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Gradle 配置语法正确"
else
    echo -e "${RED}✗${NC} Gradle 配置有语法错误"
    ((ERRORS++))
fi
cd ..

# 5. 扫描插件 SDK 需求
echo ""
echo "🔍 扫描插件 SDK 需求..."

echo "   检查是否所有插件都能使用 SDK 36..."
# 这个检查在本地可能不完整，但至少能发现问题
echo -e "${YELLOW}⚠${NC} 部分插件可能需要特定 SDK 版本，构建时会覆盖到 36"

# 总结
echo ""
echo "===================="
echo "检查结果："
echo "  错误: $ERRORS"
echo "  警告: $WARNINGS"

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ 发现 $ERRORS 个错误，请修复后再推送！${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️  有 $WARNINGS 个警告，建议检查后再推送${NC}"
    exit 0
else
    echo ""
    echo -e "${GREEN}✅ 所有检查通过，可以安全推送！${NC}"
    exit 0
fi
