# YT Downloader: Vídeos e Músicas (by Michael Tech)

Dois programas simples para **Windows 10/11** que baixam do YouTube com poucos cliques, sem precisar saber comandos.

| Projeto | O que faz | Onde salva |
|---|---|---|
| 🎵 **Baixador de Músicas** | Baixa músicas e playlists em **MP3**, com capa e nome do artista | `Músicas\yt-dlp` |
| 🎬 **Baixador de Vídeos** | Baixa vídeos e playlists em **MP4** (1080p, 720p, 480p ou máxima) | `Vídeos\yt-dlp` |

Os dois usam o [yt-dlp](https://github.com/yt-dlp/yt-dlp) e o [FFmpeg](https://ffmpeg.org). O instalador de cada projeto baixa esses programas automaticamente pelo `winget`.

---

## 📥 Como baixar

1. Clique no botão verde **`<> Code`** e depois em **Download ZIP**.
2. Extraia o ZIP numa pasta. Não rode os arquivos de dentro do ZIP.
3. Entre na pasta do projeto que você quer usar.

## 🎵 Baixador de Músicas (MP3)

Pasta: [`Baixador de Musicas`](Baixador%20de%20Musicas)

1. Dê dois cliques em **`instalar-yt-dlp.bat`**. Ele instala o yt-dlp e o FFmpeg.
2. No final, aperte **S** para abrir o baixador.
3. Nas próximas vezes, abra direto o **`baixar-musica.bat`**.

**No menu:** baixar uma música, baixar uma playlist inteira, abrir a pasta, atualizar o yt-dlp e ver a tela "Sobre".

## 🎬 Baixador de Vídeos (MP4)

Pasta: [`Baixador de Videos`](Baixador%20de%20Videos)

1. Dê dois cliques em **`1-INSTALAR-VIDEOS.bat`**.
2. Depois use o **`2-BAIXAR-VIDEOS.bat`**.

**Qualidades:**

| Opção | Formato | Observação |
|---|---|---|
| 1080p Full HD | H.264 + AAC | Recomendado. Abre em qualquer aparelho. |
| 720p HD | H.264 + AAC | Arquivo menor |
| 480p | H.264 + AAC | Leve, bom para celular |
| Máxima (até 4K) | VP9/AV1 | Arquivo grande. Use o [VLC](https://www.videolan.org/vlc/) para abrir. |

Depois de cada download, o programa confere se o arquivo veio com imagem e som.

> 💡 Se você já instalou o yt-dlp e o FFmpeg por um dos projetos, não precisa instalar de novo para usar o outro.

---

## ✅ Requisitos

- Windows 10 (versão 1809 ou mais nova) ou Windows 11
- Internet
- App **Instalador de Aplicativo** da Microsoft Store, que traz o `winget`. O instalador avisa se ele estiver faltando.

## 🛠️ Problemas comuns

| Problema | Solução |
|---|---|
| "O Windows protegeu o computador" | Clique em **Mais informações** e depois em **Executar assim mesmo**. |
| "winget não é reconhecido" | Instale ou atualize o **Instalador de Aplicativo** na Microsoft Store e reinicie o PC. |
| O download deu erro | Use a opção **Atualizar** no menu. O YouTube muda o site com frequência. |
| O vídeo só toca o som | Baixe em 1080p ou abra o arquivo no VLC. |
| Aparecem códigos como `[92m` na tela | O Windows é antigo demais para mostrar cores. Atualize o Windows. |

## ⚖️ Uso responsável

Baixe apenas conteúdo livre, seu, ou que você tenha permissão para baixar. Respeite os direitos autorais dos artistas e os termos de uso do YouTube.

## 💚 Apoie o projeto

Gostou? Doações e ajuda nos projetos:

**Michael Brasil Tech: (94) 99177-0707**

Qualquer valor faz diferença. Muito obrigado!
