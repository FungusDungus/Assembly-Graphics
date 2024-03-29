.model flat,stdcall
INCLUDE pacman.inc
INCLUDE arena.inc
.stack 4096
.data
time_passed DB 0
.code

main proc

   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   
   mov ax, 0a000h; video memory begins at segment 0a000h, actual address is this X 16
   mov es, ax ; es pointer now holds page offset
   
   
   arenaSHOW 0,0
   mov bx,0
   mov ah, 2ch ; system time code
   L1:
   int 21h ; interrupt used to get system time touches cx and dx
   cmp dl, time_passed
   je L1
   
   mov time_passed, dl
   add bx, 1
   
   ;pacmanSHOW 0, bx
   ;pacmanSHOW 10, bx
   cmp bx, 183
   je done
   jmp L1
   
      
   ; exit on keystroke
   done:
   mov ah,1
   int 16h
   
   mov ah,0    ;clear key
   int 16h
   
   mov ax,3    ;reset to text mode
   int 10h
   
   mov ah,4ch  ;exit to DOS
   int  21h
      
main endp
end main
