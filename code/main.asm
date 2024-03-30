INCLUDE pacman.inc
.model flat,stdcall
.stack 4096
.data
time_passed DB 0
player_pos DB 0
.code


main proc

   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   
   mov ax, 0a000h; video memory begins at segment 0a000h, actual address is this X 16
   mov es, ax ; es pointer now holds page offset
   
   GETTIME:
   
   mov ah, 2ch ; system time code
   int 21h ; interrupt used to get system time touches cx and dx
   cmp dl, time_passed ;dl contains 1/100 of second time
   
   je GETTIME
   
   mov ah, 0
   int 16h
   cmp al, 77 ;w
   je w
   cmp al, 73 ;s
   je s
   cmp al, 61 ;a
   je a
   cmp al, 64 ;d
   je d
   cmp al, 27 ;esc
   je done
   jmp MOVEPLAYER
   
   w:
   sub player_pos, 320
   jmp MOVEPLAYER
   s:
   add player_pos, 320
   jmp MOVEPLAYER
   a:
   dec player_pos
   jmp MOVEPLAYER
   d:
   inc player_pos
   jmp MOVEPLAYER
   
   MOVEPLAYER:
   ; mov ax, 0
   ; mov ah, 06h
   ; mov bh, 0
   ; int 10h
   ;pacmanSHOW player_x, player_y
   mov bx, player_pos
   mov es:[bx], BYTE PTR 32h
   
   jmp GETTIME
   
      
   ; exit on keystroke
   done:
   
   mov ax,3    ;reset to text mode
   int 10h
   
   mov ah,4ch  ;exit to DOS
   int  21h
      
main endp
end main
