if %1==pacman goto :pacman
if %1==snake (goto :snake) else (echo "Improper use of build. Use ^"build pacman^" or ^"build snake^"")

:pacman
config -set cycles=100000
cd code
masm pacman.asm;
link pacman;
cd ..
config -set cycles=3000
exit /b 0

:snake
cd code
masm snake.asm:
link snake
cd ..
exit /b 0
