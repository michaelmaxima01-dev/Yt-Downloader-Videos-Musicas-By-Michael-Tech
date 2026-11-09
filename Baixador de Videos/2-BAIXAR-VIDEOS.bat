@echo off
setlocal EnableDelayedExpansion
title BAIXADOR DE VIDEOS - MP4
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
set "ARCO=  %ESC%[94m==========%ESC%[96m==========%ESC%[94m==========%ESC%[96m==========%ESC%[94m==========%ESC%[96m==========%ESC%[0m"
set "FUNDO_VERM=%ESC%[41m%ESC%[97m"

REM --- Creditos ---
set "AUTOR=Michael Brasil Tech"
set "CONTATO=(94) 99177-0707"

REM --- Pasta onde os videos serao salvos ---
set "PASTA=%USERPROFILE%\Videos\yt-dlp"

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
    echo %VERM%   [X] FFmpeg %CINZA%- junta o video com o audio em MP4%R%
    echo       %AMAR%Comando:%R% %BRANCO%winget install Gyan.FFmpeg%R%
    echo.
) else (
    echo %VERDE%   [V] FFmpeg %CINZA%- ja instalado%R%
    echo.
)
echo %CINZA%  ----------------------------------------------------------------%R%
echo.

if exist "%~dp01-INSTALAR-VIDEOS.bat" (
    echo %AMAR%  O instalador automatico foi encontrado nesta pasta.%R%
    echo.
    choice /c SN /n /m "  Deseja instalar agora? [S/N]: "
    if errorlevel 2 goto sair_falta
    call "%~dp01-INSTALAR-VIDEOS.bat" /chamado
    goto pos_instalacao
) else (
    echo %AMAR%  Rode o arquivo %BRANCO%1-INSTALAR-VIDEOS.bat%AMAR% ou digite os comandos acima%R%
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
echo %VERM%  2-BAIXAR-VIDEOS.bat de novo ou reinicie o computador.%R%

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
echo        %NEG%%BRANCO%BAIXADOR DE%R% %NEG%%ESC%[46m%ESC%[30m V I D E O S %R%   %CINZA%-%R%   %VERM%You%BRANCO%Tube%R% %CINZA%para%R% %NEG%%CIANO%MP4%R%
echo %ARCO%
echo.
echo   %CINZA%Pasta:%R%  %AMAR%%PASTA%%R%
echo   %CINZA%Status:%R% %VERDE%[V] yt-dlp%R%   %VERDE%[V] Deno%R%   %VERDE%[V] FFmpeg%R%
echo.
echo   %NEG%%BRANCO%BAIXAR%R%
echo     %VERDE%[1]%R%  Um video            %CINZA%escolha a qualidade e cole o link%R%
echo     %CIANO%[2]%R%  Playlist inteira    %CINZA%baixa todos os videos de uma vez%R%
echo.
echo   %NEG%%BRANCO%FERRAMENTAS%R%
echo     %AMAR%[3]%R%  Abrir pasta         %CINZA%ver os videos baixados%R%
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
if errorlevel 2 goto video_playlist
if errorlevel 1 goto video

REM ============================================================
REM  UM VIDEO
REM ============================================================
:video
set "MODO=video"
call :escolher_qualidade
if "!QUAL!"=="" goto menu
call :tela_link "BAIXAR UM VIDEO  -  !QUAL_NOME!" "%CIANO%" "Link do video"
if "!URL!"=="" goto menu
echo %AZUL%  Baixando o video em !QUAL_NOME!, aguarde...%R%
echo.
if exist "%TEMP%\baixador-video-info.txt" del "%TEMP%\baixador-video-info.txt"
yt-dlp -f "!QUAL!" -S "!RES!" --merge-output-format mp4 --add-metadata --no-playlist --print-to-file "after_move:%%(vcodec)s|%%(height)s|%%(acodec)s" "%TEMP%\baixador-video-info.txt" -o "%PASTA%\%%(title)s.%%(ext)s" "!URL!"
set "CODIGO=!errorlevel!"
call :conferir_video
goto resultado

REM ============================================================
REM  PLAYLIST DE VIDEOS
REM ============================================================
:video_playlist
set "MODO=video_playlist"
call :escolher_qualidade
if "!QUAL!"=="" goto menu
call :tela_link "BAIXAR PLAYLIST DE VIDEOS  -  !QUAL_NOME!" "%CIANO%" "Link da playlist"
if "!URL!"=="" goto menu
echo %AZUL%  Baixando a playlist em !QUAL_NOME!, isso pode demorar bastante...%R%
echo.
if exist "%TEMP%\baixador-video-info.txt" del "%TEMP%\baixador-video-info.txt"
yt-dlp -f "!QUAL!" -S "!RES!" --merge-output-format mp4 --add-metadata --yes-playlist --print-to-file "after_move:%%(vcodec)s|%%(height)s|%%(acodec)s" "%TEMP%\baixador-video-info.txt" -o "%PASTA%\%%(playlist_title)s\%%(playlist_index)03d - %%(title)s.%%(ext)s" "!URL!"
set "CODIGO=!errorlevel!"
call :conferir_video
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
    call :mostrar_conferencia
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
echo     %CIANO%[S]%R%  Baixar outro
echo     %CIANO%[A]%R%  Abrir a pasta
echo     %CIANO%[M]%R%  Voltar ao menu principal
echo.
choice /c SAM /n /m "  Escolha (S/A/M): "
if errorlevel 3 goto menu
if errorlevel 2 (
    start "" "!PASTA!"
    goto menu
)
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
echo %AZUL%  ==================  ATUALIZAR O YT-DLP  ==================%R%
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
REM  SUB-ROTINA: tela para colar o link
REM  %1 = titulo   %2 = cor   %3 = texto do campo
REM ============================================================
:tela_link
cls
echo.
echo %~2  ==================  %~1  ==================%R%
echo.
echo   %CINZA%Dica: clique com o botao direito para colar o link.%R%
echo   %CINZA%Deixe vazio e aperte Enter para voltar ao menu.%R%
echo.
set "URL="
set /p "URL=  %AMAR%%~3:%R% "
echo.
exit /b 0

REM ============================================================
REM  SUB-ROTINA: escolher a qualidade do video
REM  1080p / 720p / 480p = video H.264 + audio AAC (abre em tudo)
REM  RES escolhe a resolucao mais proxima (funciona tambem em Shorts)
REM ============================================================
:escolher_qualidade
set "QUAL="
set "RES="
set "QUAL_NOME="
cls
echo.
echo %CIANO%  ==================  QUALIDADE DO VIDEO  ==================%R%
echo.
echo     %VERDE%[1]%R%  1080p Full HD   %CINZA%recomendado - abre em qualquer aparelho%R%
echo     %CIANO%[2]%R%  720p HD         %CINZA%arquivo menor - abre em qualquer aparelho%R%
echo     %AMAR%[3]%R%  480p            %CINZA%bem leve, bom para celular%R%
echo     %MAGENTA%[4]%R%  Maxima ate 4K   %CINZA%arquivo grande - %VERM%precisa do VLC para abrir%R%
echo     %VERM%[5]%R%  Voltar
echo.
choice /c 12345 /n /m "  Escolha a qualidade (1-5): "
if errorlevel 5 exit /b 0
if errorlevel 4 (
    set "QUAL=bv*+ba[ext=m4a]/bv*+ba/b"
    set "RES=res,fps"
    set "QUAL_NOME=qualidade maxima"
    exit /b 0
)
if errorlevel 3 (
    set "QUAL=bv*[vcodec*=avc1]+ba[ext=m4a]/bv*+ba/b"
    set "RES=res:480,fps"
    set "QUAL_NOME=480p"
    exit /b 0
)
if errorlevel 2 (
    set "QUAL=bv*[vcodec*=avc1]+ba[ext=m4a]/bv*+ba/b"
    set "RES=res:720,fps"
    set "QUAL_NOME=720p"
    exit /b 0
)
set "QUAL=bv*[vcodec*=avc1]+ba[ext=m4a]/bv*+ba/b"
set "RES=res:1080,fps"
set "QUAL_NOME=1080p"
exit /b 0

REM ============================================================
REM  SUB-ROTINA: confere se o arquivo baixado tem VIDEO
REM  (le o que o yt-dlp gravou: codec de video | altura | codec de audio)
REM ============================================================
:conferir_video
set "VC="
set "VH="
set "AC="
set "SEM_VIDEO=0"
set "TOTAL=0"
if not exist "%TEMP%\baixador-video-info.txt" exit /b 0
for /f "usebackq tokens=1-3 delims=|" %%a in ("%TEMP%\baixador-video-info.txt") do (
    set /a TOTAL+=1
    set "VC=%%a"
    set "VH=%%b"
    set "AC=%%c"
    if /i "%%a"=="none" set /a SEM_VIDEO+=1
)
exit /b 0

:mostrar_conferencia
if "!VC!"=="" exit /b 0
echo.
if !SEM_VIDEO! GTR 0 (
    echo %FUNDO_VERM%  [ATENCAO] !SEM_VIDEO! arquivo^(s^) veio sem imagem, so com audio.  %R%
    echo %VERM%  Tente de novo escolhendo a qualidade 1080p.%R%
    exit /b 0
)
set "VC_NOME=!VC!"
set "VC_OK=0"
if /i "!VC:~0,4!"=="avc1" (
    set "VC_NOME=H.264"
    set "VC_OK=1"
)
if /i "!VC:~0,4!"=="av01" set "VC_NOME=AV1"
if /i "!VC:~0,3!"=="vp9" set "VC_NOME=VP9"
if /i "!VC:~0,4!"=="vp09" set "VC_NOME=VP9"
set "AC_NOME=!AC!"
if /i "!AC:~0,4!"=="mp4a" set "AC_NOME=AAC"
if /i "!AC:~0,4!"=="opus" set "AC_NOME=Opus"
if !TOTAL! GTR 1 (
    echo   %CINZA%Conferido:%R% %VERDE%!TOTAL! videos com imagem e som%R%
) else (
    echo   %CINZA%Conferido:%R% %VERDE%[V] Video !VH!p !VC_NOME!%R%  %CINZA%+%R%  %VERDE%[V] Audio !AC_NOME!%R%
)
if "!VC_OK!"=="0" echo   %AMAR%Este formato pode nao abrir no player do Windows. Use o VLC.%R%
exit /b 0

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
