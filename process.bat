@echo off
setlocal enabledelayedexpansion

REM Check if FFmpeg exists
if not exist "ffmpeg-master-latest-win64-gpl-shared\bin\ffmpeg.exe" (
    echo FFmpeg not found. Please ensure FFmpeg is properly installed.
    pause
    exit /b
)

echo Processing all MP3 files in input directory...

REM Count total MP3 files
set count=0
for %%f in (input\*.mp3) do (
    set /a count+=1
)

if !count! equ 0 (
    echo No MP3 files found in input directory.
    pause
    exit /b
)

echo Found !count! MP3 files.

REM Process each MP3 file
set index=0
for %%f in (input\*.mp3) do (
    set /a index+=1
    echo [!index!/!count!] Processing: %%~nf.mp3
    
    REM Use a solid color background with the existing background.png if available
    if exist "input\background.png" (
        REM Combine the existing background image with the audio to create a video
        "ffmpeg-master-latest-win64-gpl-shared\bin\ffmpeg.exe" -y -loop 1 -i "input\background.png" -i "%%f" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest "output\%%~nf.mp4"
    ) else (
        REM Create a simple black background video with the audio
        "ffmpeg-master-latest-win64-gpl-shared\bin\ffmpeg.exe" -y -f lavfi -i color=black:s=1280x720 -i "%%f" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest "output\%%~nf.mp4"
    )
    
    if !errorlevel! neq 0 (
        echo Error processing file: %%~nf.mp3
    ) else (
        echo Successfully processed: %%~nf.mp4
    )
)

echo.
echo Processing complete. Check the output folder for results.
pause
