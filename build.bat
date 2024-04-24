@echo off


if %1 == pacman goto :pacman
if %1 == snake goto :snake

goto :error


:snake
cd Code
masm snake.asm;
link snake;
cd ..
goto :return

:pacman
echo "I shouldn't be here"
goto :return

:error
echo "WRONGGGGGG"
goto :return

:return

