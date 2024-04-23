if %1==pacman goto :pacman
if %1==snake (goto :snake) else (echo "Improper use of run. Use ^"run pacman^" or ^"run snake^"")

:pacman
cd code
config -set cycles=50000
pacman
config -set cycles=3000
cd ..
exit /b 0

:snake
cd code
snake
cd ..
exit /b 0
