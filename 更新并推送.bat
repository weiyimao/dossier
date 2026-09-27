@echo off
chcp 65001 >nul
cd /d "%~dp0"
rem ===== GitHub page is only a redirect entry now; change JUMP to change the target =====
set "JUMP=https://ysyz.dpdns.org/"
echo [1/3] Rebuild page (redirect to %JUMP%) ...
python "..\_工具\生成网页.py" --跳转 "%JUMP%" --输出 "%~dp0site\index.html"
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
  echo No remote configured yet. Please run 首次上传.bat first ^(double-click it^).
) else (
  git push
  if errorlevel 1 echo Push failed - check GitHub login / remote url.
)
echo.
echo Done.
pause
