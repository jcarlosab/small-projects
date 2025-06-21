@echo off
setlocal EnableDelayedExpansion

:: Prompt user for the root directory
set /p rootPath=Enter the root directory path (e.g., F:\ruta\carpeta1): 
if not exist "!rootPath!\" (
    echo Invalid directory path. Exiting.
    pause
    exit /b
)

:: Output files
set "outputFile=FileList.txt"
set "similarityReport=SimilarFiles.txt"

:: Clear previous output files if they exist
if exist "%outputFile%" del "%outputFile%"
if exist "%similarityReport%" del "%similarityReport%"

:: Step 1: List all files recursively with their paths, excluding .sbi files
echo Generating file list...
dir "!rootPath!" /s /b /a-d | findstr /V /I "\.sbi$" > tempFileList.txt

:: Step 2: Process the list to format by folder
echo Processing file list...
:: Create a temporary sorted file list by directory
sort /+1 tempFileList.txt > sortedFileList.txt

:: Initialize variables
set "currentDir="
echo Folder Contents > "%outputFile%"

:: Read sorted file list and group by folder
for /f "delims=" %%F in (sortedFileList.txt) do (
    set "fullPath=%%F"
    set "fileName=%%~nxF"
    set "dirName=%%~dpF"
    :: Remove trailing backslash from directory path
    set "dirName=!dirName:~0,-1!"
    :: Check if directory changed
    if not "!dirName!"=="!currentDir!" (
        echo. >> "%outputFile%"
        echo !dirName! >> "%outputFile%"
        set "currentDir=!dirName!"
    )
    :: Write file name indented
    echo     !fileName! >> "%outputFile%"
    :: Store for duplicate comparison (without extension)
    set "baseName=%%~nF"
    echo !baseName!,!fullPath!,!dirName!>> tempForCompare.txt
)

:: Step 3: Compare file names for exact matches (ignoring extension)
echo Comparing files for identical names...
:: Create a temporary file to store comparisons
set "tempSimilar=tempSimilar.txt"
if exist "%tempSimilar%" del "%tempSimilar%"

:: Sort tempForCompare.txt by base name for duplicate checking
sort /+1 tempForCompare.txt > sortedForCompare.txt

:: Initialize variables for duplicate detection
set "prevBase="
set "prevPath="
set "prevDir="
set "first=1"
set "matchCount=0"
set "sameHeader=0"
set "diffHeader=0"

echo Duplicate Files > "%tempSimilar%"
for /f "tokens=1* delims=," %%A in (sortedForCompare.txt) do (
    for /f "tokens=1,2 delims=," %%C in ("%%B") do (
        set "base=%%A"
        set "fullPath=%%C"
        set "dir=%%D"
        if not "!first!"=="1" (
            if "!base!"=="!prevBase!" (
                :: Check if same or different folder
                if "!dir!"=="!prevDir!" (
                    :: Write same folder header if not yet written
                    if !sameHeader! EQU 0 (
                        echo. >> "%tempSimilar%"
                        echo Same Folder Duplicates: >> "%tempSimilar%"
                        set "sameHeader=1"
                    )
                    echo     !dir! >> "%tempSimilar%"
                    echo         !prevPath! >> "%tempSimilar%"
                    echo         !fullPath! >> "%tempSimilar%"
                ) else (
                    :: Write different folder header if not yet written
                    if !diffHeader! EQU 0 (
                        echo. >> "%tempSimilar%"
                        echo Different Folder Duplicates: >> "%tempSimilar%"
                        set "diffHeader=1"
                    )
                    echo     !prevDir! >> "%tempSimilar%"
                    echo         !prevPath! >> "%tempSimilar%"
                    echo     !dir! >> "%tempSimilar%"
                    echo         !fullPath! >> "%tempSimilar%"
                )
                set /a matchCount+=1
            ) else (
                :: Reset sameHeader for new base name if in same folder
                if "!dir!"=="!prevDir!" (
                    set "sameHeader=0"
                )
            )
        )
        set "prevBase=!base!"
        set "prevPath=!fullPath!"
        set "prevDir=!dir!"
        set "first=0"
    )
)

:: Step 4: Create similarity report
if !matchCount! GTR 0 (
    type "%tempSimilar%" > "%similarityReport%"
) else (
    echo No duplicate file names found. > "%similarityReport%"
)

:: Clean up temporary files
if exist "tempFileList.txt" del "tempFileList.txt"
if exist "sortedFileList.txt" del "sortedFileList.txt"
if exist "tempForCompare.txt" del "tempForCompare.txt"
if exist "sortedForCompare.txt" del "sortedForCompare.txt"
if exist "%tempSimilar%" del "%tempSimilar%"

:: Display results
echo File list saved to %outputFile%
echo Similarity report saved to %similarityReport%
echo.
echo Preview of %outputFile%:
type "%outputFile%" | more /e +0 +10
echo.
echo Preview of %similarityReport%:
type "%similarityReport%" | more /e +0 +10
echo.

pause