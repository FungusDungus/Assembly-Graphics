# Assembly-Graphics
Computer Architecture and Assembly Programming -> Game Contest

How to run:

1. Download and install DOS-Box using the following link:

   https://www.dosbox.com/download.php?main=1

2. Download the code as a zipped folder, then extract the folder and copy the filepath
   
3. Open dosbox and use commands:
   
   "mount c %filepath%"
   "c:"

4. Use build and run scripts to build and run the programs (build snake, build pacman, run snake, run pacman)


Known issues:
Snake  -> termination is unpredictable: you may have to restart DOSBox in case of a bad termination.

Pacman -> being chased by a ghost in very close proximity while eating a pellet causes the ghost sprite to be partially kept in memory, due to the pellet eating involving memory movs rather than xors causing the
xor on the mov to redraw the ghost rather than removing it.
