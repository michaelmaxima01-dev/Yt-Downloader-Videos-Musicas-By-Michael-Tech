@echo off
setlocal
title INSTALADOR - BAIXADOR DE VIDEOS

set "WIN_MAJOR=10"
set "WIN_BUILD=99999"

REM ============================================================
REM  1) VERSAO DO WINDOWS (cores, curl e tar exigem Windows 10/11)
REM ============================================================
for /f "tokens=4,6 delims=[]. " %%a in ('ver') do (
    set "WIN_MAJOR=%%a"
    set "WIN_BUILD=%%b"
)
if %WIN_MAJOR% LSS 10 (
    echo.
    echo  [ERRO] Este instalador precisa do Windows 10 ou 11.
    echo.
    pause
    exit /b 1
)

REM ============================================================
REM  CORES (codigos ANSI)
REM ============================================================
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "R=%ESC%[0m"
set "VERM=%ESC%[91m"
set "VERDE=%ESC%[92m"
set "AMAR=%ESC%[93m"
set "AZUL=%ESC%[94m"
set "CIANO=%ESC%[96m"
set "BRANCO=%ESC%[97m"
set "CINZA=%ESC%[90m"
set "NEG=%ESC%[1m"
set "MAGENTA=%ESC%[95m"
set "ARCO=  %ESC%[94m==========%ESC%[96m==========%ESC%[94m==========%ESC%[96m==========%ESC%[94m==========%ESC%[96m==========%ESC%[0m"
set "FUNDO_VERM=%ESC%[41m%ESC%[97m"
set "LINHA=%CINZA%  ----------------------------------------------------------------%R%"

REM Pasta usada quando o programa e baixado direto do site oficial
set "PASTA_BIN=%LOCALAPPDATA%\MichaelTech\bin"

REM Links oficiais (plano B, quando o winget falhar)
set "URL_YTDLP=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
set "URL_DENO=https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip"
set "URL_FFMPEG=https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"

cls
echo.
echo %ARCO%
echo        %NEG%%BRANCO%INSTALADOR%R%  %NEG%%ESC%[46m%ESC%[30m BAIXADOR DE VIDEOS %R%   %CINZA%yt-dlp + Deno + FFmpeg%R%
echo %ARCO%
echo   %CINZA%by Michael Brasil Tech%R%
echo.
echo   %CINZA%Verificando o que o seu computador precisa...%R%
echo.

REM Windows 10 antigo (antes da versao 1809) nao tem curl/tar
if %WIN_BUILD% LSS 17763 (
    echo %FUNDO_VERM%  [ERRO] Seu Windows 10 esta desatualizado.  %R%
    echo.
    echo %VERM%  Atualize o Windows pelo Windows Update e tente de novo.%R%
    echo.
    pause
    exit /b 1
)
echo   %VERDE%[V]%R% Windows compativel %CINZA%- build %WIN_BUILD%%R%

REM ============================================================
REM  2) WINGET (opcional: se faltar, baixa direto do site oficial)
REM ============================================================
call :atualizar_path
set "TEM_WINGET=1"
where winget >nul 2>&1 || set "TEM_WINGET=0"
if "%TEM_WINGET%"=="1" (
    echo   %VERDE%[V]%R% winget encontrado
) else (
    echo   %AMAR%[?]%R% winget nao encontrado %CINZA%- vou baixar direto do site oficial%R%
)

REM ============================================================
REM  3) INTERNET
REM ============================================================
"%SystemRoot%\System32\curl.exe" -s -o nul --head --max-time 8 https://github.com >nul 2>&1
if errorlevel 1 (
    echo   %AMAR%[?]%R% Nao consegui confirmar a internet %CINZA%- vou tentar mesmo assim%R%
) else (
    echo   %VERDE%[V]%R% Conexao com a internet OK
)
echo.
echo %LINHA%

REM ============================================================
REM  PASSO 1 - yt-dlp
REM ============================================================
echo.
echo %CIANO%  [PASSO 1 de 3]%R% %NEG%yt-dlp%R% %CINZA%- o programa que faz os downloads%R%
echo.
where yt-dlp >nul 2>&1
if not errorlevel 1 (
    echo   %VERDE%[V] yt-dlp ja esta instalado. Pulando...%R%
    goto passo2
)
if "%TEM_WINGET%"=="1" (
    echo   %AZUL%Instalando o yt-dlp pelo winget, aguarde...%R%
    echo.
    winget install --id yt-dlp.yt-dlp -e --source winget --skip-dependencies --accept-source-agreements --accept-package-agreements
    call :atualizar_path
)
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo.
    echo   %AMAR%Plano B: baixando o yt-dlp direto do site oficial...%R%
    echo.
    call :baixar_exe "%URL_YTDLP%" "yt-dlp.exe"
)
call :resultado_passo yt-dlp

REM ============================================================
REM  PASSO 2 - Deno (o YouTube exige para o yt-dlp funcionar)
REM ============================================================
:passo2
echo.
echo %LINHA%
echo.
echo %CIANO%  [PASSO 2 de 3]%R% %NEG%Deno%R% %CINZA%- obrigatorio para baixar do YouTube%R%
echo.
where deno >nul 2>&1
if not errorlevel 1 (
    echo   %VERDE%[V] Deno ja esta instalado. Pulando...%R%
    goto passo3
)
if "%TEM_WINGET%"=="1" (
    echo   %AZUL%Instalando o Deno pelo winget, aguarde...%R%
    echo.
    winget install --id DenoLand.Deno -e --source winget --accept-source-agreements --accept-package-agreements
    call :atualizar_path
)
where deno >nul 2>&1
if errorlevel 1 (
    echo.
    echo   %AMAR%Plano B: baixando o Deno direto do site oficial...%R%
    echo.
    call :baixar_zip "%URL_DENO%" "deno.exe"
)
call :resultado_passo deno

REM ============================================================
REM  PASSO 3 - FFmpeg (pergunta antes)
REM ============================================================
:passo3
echo.
echo %LINHA%
echo.
echo %CIANO%  [PASSO 3 de 3]%R% %NEG%FFmpeg%R% %CINZA%- necessario para juntar video e audio em MP4%R%
echo.
where ffmpeg >nul 2>&1
if not errorlevel 1 (
    echo   %VERDE%[V] FFmpeg ja esta instalado. Pulando...%R%
    goto fim
)
<nul set /p "=  %AMAR%Deseja instalar o FFmpeg agora? [S/N]: %R%"
choice /c SN /n
if errorlevel 2 (
    echo.
    echo   %AMAR%Instalacao do FFmpeg pulada. Sem ele os videos podem vir sem som ou em outro formato.%R%
    goto fim
)
echo.
if "%TEM_WINGET%"=="1" (
    echo   %AZUL%Instalando o FFmpeg pelo winget, aguarde... pode demorar alguns minutos.%R%
    echo.
    winget install --id Gyan.FFmpeg -e --source winget --accept-source-agreements --accept-package-agreements
    call :atualizar_path
)
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo.
    echo   %AMAR%Plano B: baixando o FFmpeg direto do site oficial ^(cerca de 90 MB^)...%R%
    echo.
    call :baixar_zip "%URL_FFMPEG%" "ffmpeg.exe"
)
call :resultado_passo ffmpeg

REM ============================================================
REM  RESUMO FINAL
REM ============================================================
:fim
call :atualizar_path
echo.
echo %LINHA%
echo.
echo   %NEG%RESUMO:%R%
set "TUDO_OK=1"
where yt-dlp >nul 2>&1 && (echo   %VERDE%[V] yt-dlp%R%) || (echo   %VERM%[X] yt-dlp - nao instalado%R%& set "TUDO_OK=0")
where deno >nul 2>&1 && (echo   %VERDE%[V] Deno%R%) || (echo   %VERM%[X] Deno - nao instalado%R%& set "TUDO_OK=0")
where ffmpeg >nul 2>&1 && (echo   %VERDE%[V] FFmpeg%R%) || (echo   %VERM%[X] FFmpeg - nao instalado%R%& set "TUDO_OK=0")
echo.
echo %LINHA%
echo.
echo   %CINZA%Criado por%R% %NEG%%MAGENTA%Michael Brasil Tech%R%  %CINZA%-%R%  %AMAR%Gostou? Apoie:%R% %NEG%%VERDE%(94) 99177-0707%R%
echo.

REM Quando chamado pelo baixador, volta direto para ele
if /i "%~1"=="/chamado" (
    pause
    exit /b 0
)

if "%TUDO_OK%"=="0" goto fim_pause
if not exist "%~dp02-BAIXAR-VIDEOS.bat" goto fim_pause
<nul set /p "=  %AMAR%Tudo pronto. Abrir o Baixador de Videos agora? [S/N]: %R%"
choice /c SN /n
if errorlevel 2 goto fim_pause
start "" "%~dp02-BAIXAR-VIDEOS.bat"
exit /b 0

:fim_pause
echo.
pause
exit /b 0

REM ============================================================
REM  SUB-ROTINAS
REM ============================================================

REM Mostra se o passo deu certo (%1 = nome do comando)
:resultado_passo
call :atualizar_path
where %1 >nul 2>&1
if errorlevel 1 (
    echo.
    echo %FUNDO_VERM%  [ERRO] Nao foi possivel instalar: %1  %R%
    call :dicas_erro
) else (
    echo.
    echo   %VERDE%[OK] %1 instalado com sucesso.%R%
)
exit /b 0

REM Cria a pasta MichaelTech\bin e coloca no PATH do usuario (uma vez so)
:preparar_pasta_bin
if not exist "%PASTA_BIN%" mkdir "%PASTA_BIN%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=Join-Path $env:LOCALAPPDATA 'MichaelTech\bin'; $k=[Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment',$true); $p=[string]$k.GetValue('Path','',[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames); if(($p -split ';') -notcontains $d){ $n=(($p.TrimEnd(';')),$d -ne '') -join ';'; $k.SetValue('Path',$n,[Microsoft.Win32.RegistryValueKind]::ExpandString) }; $k.Close()" >nul 2>&1
set "PATH=%PASTA_BIN%;%PATH%"
exit /b 0

REM Baixa um .exe direto  (%1 = link   %2 = nome do arquivo)
:baixar_exe
call :preparar_pasta_bin
"%SystemRoot%\System32\curl.exe" -L --fail --retry 3 -# -o "%PASTA_BIN%\%~2" "%~1"
if errorlevel 1 if exist "%PASTA_BIN%\%~2" del "%PASTA_BIN%\%~2"
exit /b 0

REM Baixa um .zip, extrai e copia o programa para a pasta bin
REM (%1 = link   %2 = .exe que precisa existir dentro do zip)
REM Extracao: 1o tenta o tar do Windows; se nao existir ou falhar,
REM usa o PowerShell (.NET), que funciona ate em Windows "lite".
:baixar_zip
call :preparar_pasta_bin
set "TMPZ=%TEMP%\michaeltech-%RANDOM%%RANDOM%"
mkdir "%TMPZ%" >nul 2>&1
"%SystemRoot%\System32\curl.exe" -L --fail --retry 3 -# -o "%TMPZ%\pacote.zip" "%~1"
if errorlevel 1 goto baixar_zip_fim
echo   %CINZA%Extraindo...%R%
call :extrair_zip "%TMPZ%\pacote.zip" "%TMPZ%"
for /r "%TMPZ%" %%F in (%~2) do if exist "%%F" (
    copy /y "%%~dpF*.exe" "%PASTA_BIN%\" >nul
    if exist "%%~dpF*.dll" copy /y "%%~dpF*.dll" "%PASTA_BIN%\" >nul
)
:baixar_zip_fim
if exist "%TMPZ%\pacote.zip" del /q "%TMPZ%\pacote.zip"
if exist "%TMPZ%" rd /s /q "%TMPZ%"
exit /b 0

REM Extrai um zip  (%1 = arquivo .zip   %2 = pasta de destino)
:extrair_zip
set "MT_ZIP=%~1"
set "MT_DEST=%~2"
set "MT_TAR="
if exist "%SystemRoot%\System32\tar.exe" set "MT_TAR=%SystemRoot%\System32\tar.exe"
if not defined MT_TAR if exist "%SystemRoot%\Sysnative\tar.exe" set "MT_TAR=%SystemRoot%\Sysnative\tar.exe"
if defined MT_TAR (
    "%MT_TAR%" -xf "%MT_ZIP%" -C "%MT_DEST%" >nul 2>&1
    if not errorlevel 1 exit /b 0
)
echo   %CINZA%Usando o PowerShell para extrair...%R%
set "MT_DEST=%MT_DEST%\ps"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory($env:MT_ZIP, $env:MT_DEST)"
exit /b %errorlevel%

REM Recarrega o PATH do registro para reconhecer programas recem
REM instalados sem precisar fechar e abrir o terminal.
:atualizar_path
set "PATH_SYS="
set "PATH_USR="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "PATH_SYS=%%B"
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "PATH_USR=%%B"
call set "PATH=%LOCALAPPDATA%\MichaelTech\bin;%LOCALAPPDATA%\Microsoft\WindowsApps;%LOCALAPPDATA%\Microsoft\WinGet\Links;%PATH_SYS%;%PATH_USR%;%PATH%"
exit /b 0

:dicas_erro
echo.
echo %VERM%  Possiveis causas:%R%
echo %VERM%   - Sem internet ou rede bloqueando o download%R%
echo %VERM%   - Antivirus bloqueou o arquivo baixado%R%
echo %VERM%   - Windows sem as ferramentas de ZIP/PowerShell%R%
echo %VERM%   - A instalacao foi cancelada na janela de permissao%R%
echo.
echo   %AMAR%Tente:%R% reiniciar o PC e rodar este instalador de novo.
echo   %CINZA%Se continuar, mande um print para o suporte.%R%
exit /b 0
