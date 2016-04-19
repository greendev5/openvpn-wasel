rem @echo off
rem Copyright (C) 2008-2012 Alon Bar-Lev <alon.barlev@gmail.com>

@rem this stupid command needed for SetEnv.cmd to operate
setlocal ENABLEDELAYEDEXPANSION

cd /d %0\..
call msvc-env.bat

set PLATFORMS=Win32
set CONFIGURATIONS=Release

call "%VCHOME%\bin\vcvars32.bat"

msbuild /help > nul 2>&1
if errorlevel 1 set DO_VCBUILD=1

for %%p in (%PLATFORMS%) do (
	for %%c in (%CONFIGURATIONS%) do (
		rmdir /q /s %SOURCEBASE%\%%p\%%c > nul 2>&1

		if "%DO_VCBUILD%" NEQ "" (
			vcbuild /errfile:error.log /showenv "%SOLUTION%" /rebuild /platform:%%p "%%c|%%p"
			for %%f in (error.log) do if %%~zf GTR 0 goto error
		) else  (
			msbuild "%SOLUTION%" /p:Configuration="%%c" /p:Platform="%%p"
			if errorlevel 1 goto error
		)
	)
)

exit /b 0
goto end

:error
exit /b 1
goto end

:end

endlocal
