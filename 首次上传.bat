@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo  First-time upload: push this folder to your GitHub repo
echo ============================================================
echo.
echo Before this: create an EMPTY repo on github.com (Public, no README).
echo.
set /p REPO=Paste your repo URL (https://github.com/USER/REPO.git): 
if "%REPO%"=="" (
  echo.
  echo Nothing entered - cancelled.
  pause
  exit /b 1
)
echo.
echo Setting remote origin ...
git remote remove origin 2>nul
git remote add origin "%REPO%"
echo Pushing (a GitHub sign-in window may pop up - please sign in) ...
git push -u origin main
if errorlevel 1 (
  echo.
  echo First push failed. If the repo was created WITH a README (unrelated histories),
  echo overwriting the remote placeholder now ...
  git push -u origin main --force
  if errorlevel 1 (
    echo.
    echo Still failed. Please send a screenshot of the messages above to Hermes.
    pause
    exit /b 1
  )
  echo Force push OK ^(remote placeholder content replaced^).
)
echo.
echo ============================================================
echo  DONE. Next steps:
echo   1) Repo page -^> Settings -^> Pages -^> Source = "GitHub Actions"
echo   2) Wait 1 minute, then open: https://YOUR-USERNAME.github.io/YOUR-REPO/
echo ============================================================
pause
