config -set cycles=100000
cd Code
masm main.asm;
link main;
cd ..
config -set cycles=3000
