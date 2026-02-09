#!/bin/bash
# 全面的预推送检查脚本 - 检测配置和 Dart 代码错误
# 使用方法：./pre-push-check.sh

set -e

echo "🔍 Flutter 项目全面预检查"
echo "=========================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0
INFO=0

# 辅助函数
print_header() {
    echo ""
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
    ((INFO++))
}

# ============================================================================
# 1. Dart 依赖检查
# ============================================================================
print_header "📦 检查 Dart 依赖..."

if flutter pub get 2>&1 | grep -q "Got dependencies"; then
    print_success "依赖获取成功"
else
    print_error "依赖获取失败，请检查 pubspec.yaml"
fi

# 检查是否有冲突的依赖
if grep -q "package_info_plus.*9\.0\.0" .flutter-plugins-dependencies 2>/dev/null || \
   grep -q 'package_info_plus.*: [9-9]\.' pubspec.lock 2>/dev/null; then
    print_error "package_info_plus 9.x 与新 Flutter Gradle Plugin 不兼容"
    print_info "建议: 在 pubspec.yaml 中添加 package_info_plus: ^4.0.0"
else
    print_success "package_info_plus 版本安全"
fi

# ============================================================================
# 2. Dart 代码分析
# ============================================================================
print_header "🔬 分析 Dart 代码..."

echo "   运行 flutter analyze..."
ANALYZE_OUTPUT=$(flutter analyze --no-preamble 2>&1)
ANALYZE_EXIT=$?

if [ $ANALYZE_EXIT -eq 0 ]; then
    print_success "Dart 代码分析通过（无错误）"
else
    # 统计错误数量
    ERROR_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "error •" || true)
    WARNING_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "info •" || true)

    if [ $ERROR_COUNT -gt 0 ]; then
        print_error "发现 $ERROR_COUNT 个 Dart 编译错误"
        echo ""
        echo "前 10 个错误："
        echo "$ANALYZE_OUTPUT" | grep "error •" | head -10 | while read line; do
            echo "   $line"
        done
        echo ""
        print_info "运行 'flutter analyze' 查看所有错误"
    else
        print_success "Dart 代码分析通过（无编译错误）"
    fi

    if [ $WARNING_COUNT -gt 0 ]; then
        print_warning "发现 $WARNING_COUNT 个警告（建议修复）"
    fi
fi

# ============================================================================
# 3. 检查常见的 API 兼容性问题
# ============================================================================
print_header "🔍 检查 API 兼容性..."

# 检查已废弃的 API
DEPRECATED_APIS=(
    "Color.withValues"
    "withAlpha"
    "Color.fromRGBO"
)

API_FOUND=false
for api in "${DEPRECATED_APIS[@]}"; do
    if grep -r "$api" lib/ --include="*.dart" 2>/dev/null | grep -v ".g.dart" | head -1 > /dev/null; then
        if [ "$API_FOUND" = false ]; then
            print_warning "发现可能不兼容的 Flutter API"
            API_FOUND=true
        fi
        echo "   - $api"
    fi
done

if [ "$API_FOUND" = false ]; then
    print_success "未发现明显的不兼容 API"
fi

# ============================================================================
# 4. 检查语法错误（常见问题）
# ============================================================================
print_header "📝 检查常见语法错误..."

# 检查未闭合的大括号
print_info "检查大括号匹配..."
BRACE_ERRORS=0
for file in $(find lib -name "*.dart" -type f); do
    OPEN_BRACES=$(grep -o "{" "$file" | wc -l)
    CLOSE_BRACES=$(grep -o "}" "$file" | wc -l)
    if [ $OPEN_BRACES -ne $CLOSE_BRACES ]; then
        print_error "$file: 大括号不匹配 ({=$OPEN_BRACES, }=$CLOSE_BRACES)"
        ((BRACE_ERRORS++))
    fi
done

if [ $BRACE_ERRORS -eq 0 ]; then
    print_success "大括号匹配检查通过"
fi

# 检查重复的类定义
print_info "检查重复的类定义..."
DUPLICATE_CLASSES=$(grep -rh "^class " lib/ --include="*.dart" | sort | uniq -d | wc -l)
if [ $DUPLICATE_CLASSES -gt 0 ]; then
    print_warning "发现 $DUPLICATE_CLASSES 个可能重复的类定义"
    grep -rh "^class " lib/ --include="*.dart" | sort | uniq -d | head -5 | while read line; do
        echo "   - $line"
    done
else
    print_success "未发现重复的类定义"
fi

# ============================================================================
# 5. Android V2 Embedding 配置
# ============================================================================
print_header "📱 检查 Android V2 Embedding 配置..."

MA=$(find android/app/src/main -name "MainActivity.*" -type f -exec cat {} \; 2>/dev/null || echo "")
if echo "$MA" | grep -q "io.flutter.embedding.android.FlutterActivity"; then
    print_success "MainActivity 使用 V2 FlutterActivity"
else
    print_error "MainActivity 未使用 V2 FlutterActivity"
fi

if grep -q 'android:name="\${applicationName}"' android/app/src/main/AndroidManifest.xml 2>/dev/null; then
    print_success "AndroidManifest 包含 \${applicationName}"
else
    print_error "AndroidManifest 缺少 \${applicationName}"
fi

if grep -q 'flutterEmbedding' android/app/src/main/AndroidManifest.xml 2>/dev/null && \
   grep -A1 'flutterEmbedding' android/app/src/main/AndroidManifest.xml | grep -q 'android:value="2"'; then
    print_success "AndroidManifest 包含 flutterEmbedding=2"
else
    print_error "AndroidManifest 缺少 flutterEmbedding=2"
fi

# ============================================================================
# 6. Android SDK 版本
# ============================================================================
print_header "🔧 检查 Android SDK 版本..."

if grep -q 'compileSdk = 36' android/app/build.gradle.kts 2>/dev/null; then
    print_success "compileSdk = 36"
else
    print_error "compileSdk 不是 36（当前要求 SDK 36）"
fi

if grep -q 'targetSdk = 36' android/app/build.gradle.kts 2>/dev/null; then
    print_success "targetSdk = 36"
else
    print_warning "targetSdk 未设置为 36"
fi

# ============================================================================
# 7. Gradle 配置
# ============================================================================
print_header "🔨 检查 Gradle 配置..."

cd android
if ./gradlew tasks --dry-run >/dev/null 2>&1; then
    print_success "Gradle 配置语法正确"
else
    print_error "Gradle 配置有语法错误"
    print_info "运行 'cd android && ./gradlew tasks' 查看详细错误"
fi
cd ..

# ============================================================================
# 总结报告
# ============================================================================
echo ""
echo "=========================="
echo "📊 检查结果总结"
echo "=========================="
echo "  🔴 错误: $ERRORS"
echo "  🟡 警告: $WARNINGS"
echo "  🔵 信息: $INFO"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}❌ 发现 $ERRORS 个错误，必须修复后才能推送！${NC}"
    echo ""
    echo "常见修复方法："
    echo "  1. Dart 错误: flutter analyze 查看详情"
    echo "  2. 依赖问题: flutter pub get"
    echo "  3. 语法错误: 检查对应文件"
    echo ""
    echo "💡 提示: 跳过检查使用 'git push --no-verify'（不推荐）"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  有 $WARNINGS 个警告，建议修复后再推送${NC}"
    echo ""
    echo "警告通常不影响构建，但建议修复以提高代码质量。"
    exit 0
else
    echo -e "${GREEN}✅ 所有检查通过，可以安全推送！${NC}"
    exit 0
fi
