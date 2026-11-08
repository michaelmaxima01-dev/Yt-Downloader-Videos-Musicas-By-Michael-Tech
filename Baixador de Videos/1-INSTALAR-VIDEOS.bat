@echo off
setlocal
title INSTALADOR - BAIXADOR DE VIDEOS

set "WIN_MAJOR=10"
set "WIN_BUILD=99999"

REM ============================================================
REM  1) VERSAO DO WINDOWS (winget e cores exigem Windows 10/11)
REM ============================================================
for /f "tokens=4,6 delims=[]. " %%a in ('ver') do (
    set "WIN_MAJOR=%%a"
    set "WIN_BUILD=%%b"
)
if %WIN_MAJOR% LSS 10 (
    echo.
    echo  [ERRO] Este instalador precisa do Windows 10 ou 11.
    echo  Sua versao do Windows nao tem o winget.
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

cls
echo.
echo %ARCO%
echo        %NEG%%BRANCO%INSTALADOR%R%  %NEG%%ESC%[46m%ESC%[30m BAIXADOR DE VIDEOS %R%   %CINZA%yt-dlp + FFmpeg%R%
echo %ARCO%
echo   %CINZA%by Michael Brasil Tech%R%
echo.
echo   %CINZA%Verificando o que o seu computador precisa...%R%
echo.

REM Windows 10 antigo (antes da versao 1809) nao suporta winget
if %WIN_BUILD% LSS 17763 (
    echo %FUNDO_VERM%  [ERRO] Seu Windows 10 esta desatualizado para o winget.  %R%
    echo.
    echo %VERM%  Atualize o Windows pelo Windows Update e tente de novo.%R%
    echo.
    pause
    exit /b 1
)
echo   %VERDE%[V]%R% Windows compativel %CINZA%- build %WIN_BUILD%%R%

REM ============================================================
REM  2) WINGET (vem com o "Instalador de Aplicativo" da Store)
REM ============================================================
call :atualizar_path
where winget >nul 2>&1
if errorlevel 1 goto sem_winget
echo   %VERDE%[V]%R% winget encontrado

REM ============================================================
REM  3) INTERNET
REM ============================================================
curl -s -o nul --head --max-time 8 https://github.com >nul 2>&1
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
echo %CIANO%  [PASSO 1 de 2]%R% %NEG%yt-dlp%R%
echo.
where yt-dlp >nul 2>&1
if not errorlevel 1 (
    echo   %VERDE%[V] yt-dlp ja esta instalado. Pulando...%R%
    goto passo2
)
echo   %AZUL%Instalando o yt-dlp, aguarde...%R%
echo.
winget install --id yt-dlp.yt-dlp -e --source winget --accept-source-agreements --accept-package-agreements
call :atualizar_path
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo.
    echo %FUNDO_VERM%  [ERRO] Nao foi possivel instalar o yt-dlp.  %R%
    call :dicas_erro
) else (
    echo.
    echo   %VERDE%[OK] yt-dlp instalado com sucesso.%R%
)

REM ============================================================
REM  PASSO 2 - FFmpeg (pergunta antes)
REM ============================================================
:passo2
echo.
echo %LINHA%
echo.
echo %CIANO%  [PASSO 2 de 2]%R% %NEG%FFmpeg%R% %CINZA%- necessario para juntar video e audio em MP4%R%
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
echo   %AZUL%Instalando o FFmpeg, aguarde... pode demorar alguns minutos.%R%
echo.
winget install --id Gyan.FFmpeg -e --source winget --accept-source-agreements --accept-package-agreements
call :atualizar_path
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo.
    echo %FUNDO_VERM%  [ERRO] Nao foi possivel instalar o FFmpeg.  %R%
    call :dicas_erro
) else (
    echo.
    echo   %VERDE%[OK] FFmpeg instalado com sucesso.%R%
)

REM ============================================================
REM  RESUMO FINAL
REM ============================================================
:fim
echo.
echo %LINHA%
echo.
echo   %NEG%RESUMO:%R%
where yt-dlp >nul 2>&1 && (echo   %VERDE%[V] yt-dlp%R%) || (echo   %VERM%[X] yt-dlp - nao instalado%R%)
where ffmpeg >nul 2>&1 && (echo   %VERDE%[V] FFmpeg%R%) || (echo   %VERM%[X] FFmpeg - nao instalado%R%)
echo.
echo %LINHA%
echo.
echo   %CINZA%Criado por%R% %NEG%%MAGENTA%Michael Brasil Tech%R%  %CINZA%-%R%  %AMAR%Gostou? Apoie:%R% %NEG%%VERDE%(94) 99177-0707%R%
echo.

REM Quando chamado pelo 2-BAIXAR-VIDEOS.bat, volta direto para ele
if /i "%~1"=="/chamado" (
    pause
    exit /b 0
)

where yt-dlp >nul 2>&1 || goto fim_pause
where ffmpeg >nul 2>&1 || goto fim_pause
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
REM  SEM WINGET
REM ============================================================
:sem_winget
echo.
echo %FUNDO_VERM%                                                                %R%
echo %FUNDO_VERM%     ATENCAO: O WINGET NAO FOI ENCONTRADO NESTE COMPUTADOR      %R%
echo %FUNDO_VERM%                                                                %R%
echo.
echo %VERM%  O winget vem no aplicativo "Instalador de Aplicativo" da Microsoft.%R%
echo.
echo   %AMAR%Como resolver:%R%
echo    1. Instale ou atualize o %BRANCO%Instalador de Aplicativo%R% na Microsoft Store
echo    2. Reinicie o computador
echo    3. Rode este instalador de novo
echo.
<nul set /p "=  %AMAR%Abrir a pagina da Microsoft Store agora? [S/N]: %R%"
choice /c SN /n
if errorlevel 2 goto fim_pause
start "" "ms-windows-store://pdp/?productid=9NBLGGH4NNS1"
goto fim_pause

REM ============================================================
REM  SUB-ROTINAS
REM ============================================================

REM Recarrega o PATH do registro para reconhecer programas recem
REM instalados sem precisar fechar e abrir o terminal.
:atualizar_path
set "PATH_SYS="
set "PATH_USR="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "PATH_SYS=%%B"
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "PATH_USR=%%B"
call set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%LOCALAPPDATA%\Microsoft\WinGet\Links;%PATH_SYS%;%PATH_USR%;%PATH%"
exit /b 0

:dicas_erro
echo.
echo %VERM%  Possiveis causas:%R%
echo %VERM%   - Sem internet ou rede bloqueando o download%R%
echo %VERM%   - A instalacao foi cancelada na janela de permissao%R%
echo %VERM%   - O winget esta desatualizado%R%
echo.
echo   %AMAR%Tente:%R% atualizar o %BRANCO%Instalador de Aplicativo%R% na Microsoft Store,
echo   reiniciar o PC e rodar este instalador de novo.
exit /b 0
