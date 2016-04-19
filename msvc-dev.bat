@echo off

setlocal
cd /d %0\..
call msvc-env.bat

set IDE=%VCHOME%\..\Common7\IDE\devenv.exe
start "" "%IDE%" "%SOLUTION%"

exit /b 0
goto end

:error
exit /b 1
goto end

:end

endlocal
