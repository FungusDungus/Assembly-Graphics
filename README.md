# Assembly-Graphics
Computer Architecture and Assembly Programming -> Game Contest


How to setup your workspace:
1. Download DOSBox using the following link: https://www.dosbox.com/download.php?main=1

2. Clone this repository and copy the path

3. Open DOSBox Options (should be on the device)

4. At the very bottom add under [autoexec] the following
   
   mount c "YOURPATH"
   
   c:
   
   set PATH=%PATH%;C:\8086\
  
5. Use buildrun batch script to compile, link, and run the code
