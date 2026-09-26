@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo [1/3] 正在重新生成页面（脱敏版）...
python "..\_工具\生成网页.py" --脱敏 --部署版 --输出 "%~dp0site\index.html"
if errorlevel 1 (
  echo.
  echo 生成失败：请确认本文件夹位于“违规证据整理”目录内，且本机已安装 Python。
  pause
  exit /b 1
)
echo [2/3] 提交变更...
git add -A
git commit -m "更新页面"
if errorlevel 1 echo （无新变更，继续）
echo [3/3] 推送到 GitHub...
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo 尚未配置远程仓库：首次使用请先按 README 的「首次上传」第 1-2 步配置 origin。
) else (
  git push
)
echo.
echo 完成。
pause
