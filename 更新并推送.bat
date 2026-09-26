@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo [1/3] Rebuild page (desensitized) ...
python "..\_工具\生成网页.py" --脱敏 --部署版 --输出 "%~dp0site\index.html"
if errorlevel 1 (
  echo.
  echo Rebuild FAILED. Check: this folder must stay inside the workspace, Python installed.
  pause
  exit /b 1
)
echo [2/3] Commit changes ...
git add -A
git commit -m "更新页面"
if errorlevel 1 echo (no new changes)
echo [3/3] Push to GitHub ...
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo No remote configured yet. See README - "首次上传" step 1-2.
) else (
  git push
  if errorlevel 1 echo Push failed - check GitHub login / remote url.
)
echo.
echo Done.
pause
