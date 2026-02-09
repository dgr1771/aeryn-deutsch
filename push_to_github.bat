@echo off
chcp 65001 >nul
color 0A
title Aeryn-Deutsch GitHub 推送工具

echo ==========================================
echo    Aeryn-Deutsch GitHub 推送工具
echo ==========================================
echo.

REM 检查是否在项目目录
if not exist ".git" (
    echo ❌ 错误：当前目录不是Git仓库
    echo 请先导航到项目目录
    pause
    exit /b 1
)

echo ✅ Git仓库检查通过
echo.

REM 检查远程仓库
for /f "tokens=2" %%i in ('git remote get-url origin 2^>nul') do set remote=%%i
if defined remote (
    echo 📡 当前远程仓库: %remote%
) else (
    echo ⚠️  未配置远程仓库
    echo 正在配置远程仓库...
    set /p token="请输入GitHub Personal Access Token: "
    git remote add origin https://%token%@github.com/dgr1771/aeryn-deutsch.git
    echo ✅ 远程仓库已配置
    echo.
)

REM 显示即将推送的提交
echo 📝 准备推送的提交：
echo.
git log --oneline -5
echo.

REM 确认推送
set /p confirm="确认推送到GitHub？(Y/N): "
if /i not "%confirm%"=="Y" (
    echo ❌ 推送已取消
    pause
    exit /b 0
)

echo.
echo ==========================================
echo    开始推送到GitHub...
echo ==========================================
echo.

REM 执行推送
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo    ✅ 推送成功！
    echo ==========================================
    echo.
    echo 🌉 访问仓库: https://github.com/dgr1771/aeryn-deutsch
    echo.
    echo 📱 下一步：构建APK
    echo    1. 打开Android Studio
    echo    2. 打开此项目
    echo    3. Build → Flutter → Build APK
    echo.
) else (
    echo.
    echo ==========================================
    echo    ❌ 推送失败
    echo ==========================================
    echo.
    echo 请检查：
    echo 1. 网络连接是否正常
    echo 2. Token是否有效
    echo 3. 仓库URL是否正确
    echo.
)

pause
