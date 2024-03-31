INCLUDE pacman.inc
.model flat,stdcall
.stack 4096

DATA SEGMENT PARA 'DATA'
time_passed DB ?
DATA ENDS

CODE SEGMENT PARA 'CODE'


main proc FAR
ASSUME CS:CODE, DS:DATA

   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   
   mov ax, 0a000h; video memory begins at segment 0a000h, actual address is this X 16
   mov es, ax ; es pointer now holds page offset
  

   
   GETTIME:
   
   mov ah, 2ch ; system time code
   int 21h ; interrupt used to get system time touches cx and dx
  
  
   mov ah, 1
   int 16h
   jz SKIP
   mov ah, 0
   int 16h
  
   SKIP:
   cmp dl, time_passed ;dl contains 1/100 of second time
   je GETTIME
   
   mov time_passed, dl
   
  
   cmp al, 77h ;w
   je w
   cmp al, 73h ;s
   je s
   cmp al, 61h ;a
   je a
   cmp al, 64h ;d
   je d
   cmp al, 27 ;esc
   je done
   
   w:
   s:
   a:
   d:

   
   jmp GETTIME
   
      
   ; exit on keystroke
   done:
   
   mov ax, 3    ;reset to text mode
   int 10h
   
   mov ah, 4ch  ;exit to DOS
   int 21h
      
main endp
end main

CODE ENDS

