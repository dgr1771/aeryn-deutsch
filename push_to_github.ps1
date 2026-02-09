# Aeryn-Deutsch GitHub 推送脚本
# 使用方法：在Windows PowerShell中运行此脚本

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Aeryn-Deutsch GitHub 推送工具" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在项目目录中
if (!(Test-Path ".git")) {
    Write-Host "❌ 错误：当前目录不是Git仓库" -ForegroundColor Red
    Write-Host "请先导航到项目目录，例如：" -ForegroundColor Yellow
    Write-Host "cd C:\path\to\aeryn-deutsch" -ForegroundColor White
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "✅ Git仓库检查通过" -ForegroundColor Green
Write-Host ""

# 检查远程仓库
$remote = git remote get-url origin 2>$null
if ($remote) {
    Write-Host "📡 当前远程仓库: $remote" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  未配置远程仓库" -ForegroundColor Yellow
    Write-Host "正在添加远程仓库..." -ForegroundColor White
    $token = Read-Host "请输入GitHub Personal Access Token"
    git remote add origin "https://${token}@github.com/dgr1771/aeryn-deutsch.git"
    Write-Host "✅ 远程仓库已添加" -ForegroundColor Green
    Write-Host ""
}

# 显示即将推送的提交
Write-Host "📝 准备推送的提交：" -ForegroundColor Cyan
Write-Host ""
git log --oneline -5
Write-Host ""

# 显示统计信息
$files = git ls-files | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "📊 项目统计：" -ForegroundColor Cyan
Write-Host "   - 文件数: $files" -ForegroundColor White
Write-Host "   - 版本: 1.0.0" -ForegroundColor White
Write-Host "   - 包名: com.aeryn.deutsch" -ForegroundColor White
Write-Host ""

# 确认推送
$confirm = Read-Host "确认推送到GitHub？(Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "❌ 推送已取消" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 0
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "开始推送到GitHub..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 执行推送
$result = git push -u origin main 2>&1
$exitCode = $LASTEXITCODE

Write-Host ""

if ($exitCode -eq 0) {
    Write-Host "==================================" -ForegroundColor Green
    Write-Host "✅ 推送成功！" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌉 访问仓库: https://github.com/dgr1771/aeryn-deutsch" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📱 下一步：构建APK" -ForegroundColor Yellow
    Write-Host "   1. 打开Android Studio" -ForegroundColor White
    Write-Host "   2. 打开此项目" -ForegroundColor White
    Write-Host "   3. Build → Flutter → Build APK" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "==================================" -ForegroundColor Red
    Write-Host "❌ 推送失败" -ForegroundColor Red
    Write-Host "==================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "错误信息：" -ForegroundColor Yellow
    Write-Host $result -ForegroundColor White
    Write-Host ""
    Write-Host "常见问题解决方案：" -ForegroundColor Cyan
    Write-Host "1. 身份验证失败：确认使用Token而非密码" -ForegroundColor White
    Write-Host "2. 权限不足：确认Token有repo权限" -ForegroundColor White
    Write-Host "3. 仓库不存在：确认仓库URL正确" -ForegroundColor White
    Write-Host ""
}

Read-Host "按回车键退出"
