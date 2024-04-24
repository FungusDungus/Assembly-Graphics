if %1==pacman goto :pacman
if %1==snake goto :snake
goto :error

:pacman
cd code
config -set cycles=50000
pacman
config -set cycles=3000
cd ..
goto :done

:snake
cd code
snake
cd ..
goto :done

:error
echo Improper use of run. Use "run pacman" or "run snake"
goto :done

:done
