@echo off
setlocal EnableDelayedExpansion
title Baixar Musicas - yt-dlp
mode con: cols=80 lines=38 >nul 2>&1

REM ============================================================
REM  CORES (codigos ANSI - Windows 10 ou superior)
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
set "ARCO=  %ESC%[91m==========%ESC%[93m==========%ESC%[92m==========%ESC%[96m==========%ESC%[94m==========%ESC%[95m==========%ESC%[0m"
set "FUNDO_VERM=%ESC%[41m%ESC%[97m"

REM --- Creditos ---
set "AUTOR=Michael Brasil Tech"
set "CONTATO=(94) 99177-0707"

REM --- Pasta onde as musicas serao salvas ---
set "PASTA=%USERPROFILE%\Music\yt-dlp"

REM ============================================================
REM  VERIFICACAO DE REQUISITOS
REM ============================================================
call :atualizar_path
set "FALTA_YTDLP=0"
set "FALTA_FFMPEG=0"
set "FALTA_DENO=0"
where yt-dlp >nul 2>&1 || set "FALTA_YTDLP=1"
where ffmpeg >nul 2>&1 || set "FALTA_FFMPEG=1"
where deno >nul 2>&1 || set "FALTA_DENO=1"

if "%FALTA_YTDLP%%FALTA_DENO%%FALTA_FFMPEG%"=="000" goto requisitos_ok

cls
echo.
echo %FUNDO_VERM%                                                                %R%
echo %FUNDO_VERM%     ATENCAO: FALTAM PROGRAMAS PARA ESTE BAIXADOR FUNCIONAR     %R%
echo %FUNDO_VERM%                                                                %R%
echo.
echo %VERM%  Programas que voce precisa instalar:%R%
echo.
if "%FALTA_YTDLP%"=="1" (
    echo %VERM%   [X] yt-dlp %CINZA%- o programa que baixa os videos%R%
    echo       %AMAR%Comando:%R% %BRANCO%winget install yt-dlp.yt-dlp%R%
    echo.
) else (
    echo %VERDE%   [V] yt-dlp %CINZA%- ja instalado%R%
    echo.
)
if "%FALTA_DENO%"=="1" (
    echo %VERM%   [X] Deno %CINZA%- obrigatorio para o YouTube funcionar%R%
    echo       %AMAR%Comando:%R% %BRANCO%winget install DenoLand.Deno%R%
    echo.
) else (
    echo %VERDE%   [V] Deno %CINZA%- ja instalado%R%
    echo.
)
if "%FALTA_FFMPEG%"=="1" (
    echo %VERM%   [X] FFmpeg %CINZA%- converte o audio para MP3%R%
    echo       %AMAR%Comando:%R% %BRANCO%winget install Gyan.FFmpeg%R%
    echo.
) else (
    echo %VERDE%   [V] FFmpeg %CINZA%- ja instalado%R%
    echo.
)
echo %CINZA%  ----------------------------------------------------------------%R%
echo.

if exist "%~dp0instalar-yt-dlp.bat" (
    echo %AMAR%  O instalador automatico foi encontrado nesta pasta.%R%
    echo.
    choice /c SN /n /m "  Deseja instalar agora? [S/N]: "
    if errorlevel 2 goto sair_falta
    call "%~dp0instalar-yt-dlp.bat" /chamado
    goto pos_instalacao
) else (
    echo %AMAR%  Rode o arquivo %BRANCO%instalar-yt-dlp.bat%AMAR% ou digite os comandos acima%R%
    echo %AMAR%  no PowerShell. Depois abra este baixador de novo.%R%
)
goto sair_falta

:pos_instalacao
call :atualizar_path
where yt-dlp >nul 2>&1 || goto ainda_falta
where ffmpeg >nul 2>&1 || goto ainda_falta
where deno >nul 2>&1 || goto ainda_falta
goto requisitos_ok

:ainda_falta
echo.
echo %VERM%  Ainda falta algum programa. Feche esta janela, abra o%R%
echo %VERM%  baixar-musica.bat de novo ou reinicie o computador.%R%

:sair_falta
echo.
pause
exit /b 1

:requisitos_ok
if not exist "%PASTA%" mkdir "%PASTA%"

REM ============================================================
REM  MENU PRINCIPAL
REM ============================================================
:menu
cls
echo.
echo %ARCO%
echo        %NEG%%BRANCO%BAIXADOR DE MUSICAS%R%   %CINZA%-%R%   %VERM%You%BRANCO%Tube%R% %CINZA%para%R% %VERDE%MP3%R%
echo %ARCO%
echo.
echo   %CINZA%Pasta:%R%  %AMAR%%PASTA%%R%
echo   %CINZA%Status:%R% %VERDE%[V] yt-dlp%R%   %VERDE%[V] Deno%R%   %VERDE%[V] FFmpeg%R%
echo.
echo   %NEG%%BRANCO%BAIXAR%R%
echo     %VERDE%[1]%R%  Uma musica          %CINZA%cole o link e pronto%R%
echo     %CIANO%[2]%R%  Playlist inteira    %CINZA%baixa todas as faixas de uma vez%R%
echo.
echo   %NEG%%BRANCO%FERRAMENTAS%R%
echo     %AMAR%[3]%R%  Abrir pasta         %CINZA%ver as musicas baixadas%R%
echo     %AZUL%[4]%R%  Atualizar           %CINZA%use se o download der erro%R%
echo.
echo     %MAGENTA%[5]%R%  Sobre / Apoiar      %CINZA%conheca e apoie o projeto%R%
echo     %VERM%[6]%R%  Sair
echo.
echo %CINZA%  ----------------------------------------------------------------%R%
echo   %CINZA%by %AUTOR%%R%
echo.
choice /c 123456 /n /m "  Escolha uma opcao (1-6): "
if errorlevel 6 goto sair
if errorlevel 5 goto sobre
if errorlevel 4 goto atualizar
if errorlevel 3 goto abrir
if errorlevel 2 goto playlist
if errorlevel 1 goto musica

REM ============================================================
REM  UMA MUSICA
REM ============================================================
:musica
set "MODO=musica"
cls
echo.
echo %CIANO%  ==================  BAIXAR UMA MUSICA  ==================%R%
echo.
echo   %CINZA%Dica: clique com o botao direito para colar o link.%R%
echo   %CINZA%Deixe vazio e aperte Enter para voltar ao menu.%R%
echo.
set "URL="
set /p "URL=  %AMAR%Link:%R% "
if "!URL!"=="" goto menu
echo.
echo %AZUL%  Baixando, aguarde...%R%
echo.
yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --no-playlist -o "%PASTA%\%%(title)s.%%(ext)s" "!URL!"
set "CODIGO=!errorlevel!"
goto resultado

REM ============================================================
REM  PLAYLIST
REM ============================================================
:playlist
set "MODO=playlist"
cls
echo.
echo %CIANO%  ================  BAIXAR PLAYLIST INTEIRA  ================%R%
echo.
echo   %CINZA%Dica: clique com o botao direito para colar o link.%R%
echo   %CINZA%Deixe vazio e aperte Enter para voltar ao menu.%R%
echo.
set "URL="
set /p "URL=  %AMAR%Link da playlist:%R% "
if "!URL!"=="" goto menu
echo.
echo %AZUL%  Baixando a playlist, isso pode demorar...%R%
echo.
yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --yes-playlist -o "%PASTA%\%%(playlist_title)s\%%(playlist_index)03d - %%(title)s.%%(ext)s" "!URL!"
set "CODIGO=!errorlevel!"
goto resultado

REM ============================================================
REM  RESULTADO DO DOWNLOAD
REM ============================================================
:resultado
echo.
echo %CINZA%  ----------------------------------------------------------------%R%
if "!CODIGO!"=="0" (
    echo.
    echo %VERDE%  [OK] Download concluido com sucesso.%R%
    echo   %CINZA%Salvo em:%R% %AMAR%!PASTA!%R%
) else (
    echo.
    echo %FUNDO_VERM%  [ERRO] Algo deu errado no download.  %R%
    echo.
    echo %VERM%  Possiveis causas:%R%
    echo %VERM%   - Link errado ou video privado/removido%R%
    echo %VERM%   - yt-dlp desatualizado %CINZA%^(use a opcao 4 do menu^)%R%
    echo %VERM%   - Sem conexao com a internet%R%
)
echo.
echo %CINZA%  ----------------------------------------------------------------%R%
echo.
echo     %CIANO%[S]%R%  Baixar outra
echo     %CIANO%[M]%R%  Voltar ao menu principal
echo.
choice /c SM /n /m "  Escolha (S/M): "
if errorlevel 2 goto menu
goto !MODO!

REM ============================================================
REM  ABRIR PASTA
REM ============================================================
:abrir
start "" "%PASTA%"
goto menu

REM ============================================================
REM  ATUALIZAR
REM ============================================================
:atualizar
cls
echo.
echo %CIANO%  ==================  ATUALIZAR O YT-DLP  ==================%R%
echo.
yt-dlp -U
if errorlevel 1 (
    where winget >nul 2>&1 && winget upgrade --id yt-dlp.yt-dlp -e --source winget --accept-source-agreements --accept-package-agreements
)
echo.
echo %VERDE%  Verificacao de atualizacao concluida.%R%
echo.
pause
goto menu

REM ============================================================
REM  SOBRE / APOIE O PROJETO
REM ============================================================
:sobre
call :dedicatoria
pause
goto menu

:dedicatoria
cls
echo.
echo %ARCO%
echo                        %NEG%%BRANCO%D E D I C A T O R I A%R%
echo %ARCO%
echo.
echo   %CINZA%Este projeto foi criado com dedicacao por%R%
echo.
echo          %VERM%*%AMAR%*%VERDE%*%R%   %NEG%%MAGENTA%M I C H A E L   B R A S I L   T E C H%R%   %VERDE%*%AMAR%*%VERM%*%R%
echo.
echo   %CIANO%^>%R% Feito para deixar a tecnologia %VERDE%simples%R% e %AMAR%acessivel%R% a todos.
echo   %CIANO%^>%R% Instalar, %CIANO%colar o link%R% e %VERDE%ouvir%R%. Sem complicacao.
echo.
echo %CINZA%  ----------------------------------------------------------------%R%
echo.
echo   %NEG%%AMAR%Gostou?%R% Apoie o projeto e ajude a criar os proximos.
echo.
echo        %VERDE%+---------------------------------------------------+%R%
echo        %VERDE%^|%R%   %NEG%%BRANCO%Doacoes e ajuda nos projetos:%R%  %NEG%%VERDE%%CONTATO%%R%  %VERDE%^|%R%
echo        %VERDE%+---------------------------------------------------+%R%
echo.
echo   %CINZA%Qualquer valor faz diferenca.%R% %MAGENTA%Muito obrigado pelo apoio.%R%
echo.
echo %ARCO%
echo.
exit /b 0

REM ============================================================
REM  RECARREGA O PATH (reconhece programas recem instalados)
REM ============================================================
:atualizar_path
set "PATH_SYS="
set "PATH_USR="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "PATH_SYS=%%B"
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "PATH_USR=%%B"
call set "PATH=%LOCALAPPDATA%\MichaelTech\bin;%LOCALAPPDATA%\Microsoft\WindowsApps;%LOCALAPPDATA%\Microsoft\WinGet\Links;%PATH_SYS%;%PATH_USR%;%PATH%"
exit /b 0

REM ============================================================
REM  SAIR
REM ============================================================
:sair
call :dedicatoria
echo   %CINZA%Fechando em 5 segundos...%R%
timeout /t 5 >nul
endlocal
exit /b 0
