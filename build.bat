if %1==pacman goto :pacman
if %1==snake goto :snake 
goto :error

:pacman
config -set cycles=100000
cd code
masm pacman.asm;
link pacman;
cd ..
config -set cycles=3000
goto :done

:snake
cd code
masm snake.asm:
link snake
cd ..
goto :done

:error
echo "Improper use of build. Use ^"build pacman^" or ^"build snake^""
goto :done

:done

