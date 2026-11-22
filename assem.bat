@echo off & setlocal EnableExtensions EnableDelayedExpansion
cls

:: Set tool paths here
set LWTOOLS_PATH="C:\Coco\lwtools"
set TOOLSHED_PATH="C:\Coco\toolshed-2.2"
set MAME_PATH="C:\Coco\mame"
set VCC_PATH="C:\Program Files (x86)\VCC 2.1.9.1\VCC.exe"
set XROAR_PATH="C:\Coco\xroar-0.35.2-w64"
set XROAR_COMMAND="C:\Coco\xroar-0.35.2-w64\xroar.exe"

:: Set environment paths here
set DISKETTE_NAME=mm.dsk
set "DISKETTE_PATH=%USERPROFILE%\Documents\Color Computer\Assembly\Astro\disk\"
set "CODE_PATH=%USERPROFILE%/Documents/Color Computer/Assembly/Astro/src/"

:: Set filename to uppercase?
:: Set line below equal to FALSE if not worried about uppercase only files
set uppercase=TRUE
echo "Hello"
:: ///
:: /// NO NEED TO EDIT BELOW THIS LINE ///
:: ///
set filename=%1
if "%uppercase%" NEQ "TRUE" goto :start

:toupper
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do set filename=!filename:%%L=%%L!

:: Build paths for scripting
:start
set assembly_path="%CODE_PATH%%filename%.asm"
set binary_path="%CODE_PATH%%filename%.BIN"
set disk_path="%DISKETTE_PATH%%DISKETTE_NAME%"
set include_path="!%CODE_PATH:\=/%!"

echo %include_path%
:: Echo paths to console
echo.
echo  Compiling: %assembly_path%
::echo    Writing: %disk_path%
::echo  Launching: %binary_path%
echo.

:: Compile the source code to binary
cd %LWTOOLS_PATH%
lwasm %assembly_path% --6809 --list --symbols --6800compat --output=%binary_path% --format=decb --includedir=%include_path% 
::lwasm %assembly_path% --6809 --list --symbols --6800compat --output=%binary_path% --format=hex
if %ERRORLEVEL% neq 0 goto:done

:: Emulator left blank - exit script
if "%2" == "" goto:done

:: Copy binary file to disk image
echo.
echo    Writing: %disk_path%
echo HIIIII
cd %TOOLSHED_PATH%
echo decb copy -2 -b %binary_path% -r %disk_path%,%filename%.BIN
decb copy -2 -b %binary_path% -r %disk_path%,%filename%.BIN
if %ERRORLEVEL% == 248 (echo The target disk %disk_path% is full)
if %ERRORLEVEL% neq 0 goto:done
echo HIIIII2
:: Check which platform to test on
echo  Launching: %binary_path%
if "%2" == "vcc" goto:vcc
if "%2" == "xroar" goto:xroar

:: MAME/MESS executes here as default emulator
:: Use: coco,coco2,coco2b,coco3 on command line to select target platform
:mess
cd %MAME_PATH%
mame.exe %2 %3 -menu -skip_gameinfo -window -flop1 %disk_path% -autoboot_delay 1 -autoboot_command "\nLOADM\"%filename%\":EXEC\n"
cd %CODE_PATH%
goto:done

:: VCC executes here
:vcc
cd %CODE_PATH%
echo %filename%
%VCC_PATH% %filename%.BIN
goto:done

:: XRoar executes here
:xroar
cd %XROAR_PATH%
%XROAR_COMMAND% "%CODE_PATH%%filename%.BIN"

:: Change directory back to source path and exit
:done
cd %CODE_PATH%
:end