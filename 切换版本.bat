@echo off
chcp 65001 >nul
cd /d "%~dp0"
rem ===== Redirect target used by option 4 (and by 更新并推送.bat) =====
set "JUMP=https://ysyz.dpdns.org/"
echo Pick the version to publish:
echo.
echo   1 = Egg version   (splash + content)
echo   2 = Title page    (splash text only)
echo   3 = Content only  (no splash, no counter)
echo   4 = Redirect      (old address - new domain: %JUMP%)
echo.
set /p V=Type 1, 2, 3 or 4 and press Enter: 
if "%V%"=="1" goto v1
if "%V%"=="2" goto v2
if "%V%"=="3" goto v3
if "%V%"=="4" goto v4
echo.
echo Invalid choice - cancelled.
pause
exit /b 1

:v1
python "..\_工具\生成网页.py" --脱敏 --部署版 --彩蛋 --输出 "%~dp0site\index.html" || goto buildfail
set NAME=Egg version
goto commit

:v2
python "..\_工具\生成网页.py" --纯开屏 --输出 "%~dp0site\index.html" || goto buildfail
set NAME=Title page
goto commit

:v3
python "..\_工具\生成网页.py" --脱敏 --部署版 --输出 "%~dp0site\index.html" || goto buildfail
set NAME=Content only
goto commit

:v4
python "..\_工具\生成网页.py" --跳转 "%JUMP%" --输出 "%~dp0site\index.html" || goto buildfail
set NAME=Redirect to %JUMP%
goto commit

:buildfail
echo.
echo Build failed. Check that this folder is inside the workspace and Python is installed.
pause
exit /b 1

:commit
echo.
echo Committing (%NAME%) ...
git add -A
git commit -m "切换版本 %V%"
if errorlevel 1 echo (no changes)
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo No remote configured yet. Run 首次上传.bat first ^(double-click it^).
  pause
  exit /b 1
)
echo Pushing ...
git push
if errorlevel 1 echo Push failed - check GitHub login / remote.
echo.
echo DONE - GitHub Pages will update in about a minute.
pause
