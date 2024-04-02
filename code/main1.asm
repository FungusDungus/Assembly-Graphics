.model small
.stack 1024

DATA SEGMENT PARA 'DATA'
time_passed DB ?
DATA ENDS

CODE SEGMENT PARA 'CODE'

; dh x, dl y

pacman_00 proc FAR
ASSUME CS:CODE, DS:DATA
   
mov ax, @code
mov ds, ax

mov ax, 0
mov ax, dl
add ax, 4
mov cx, 320
mul cx

add ax, 104
mov dl, dh
add ax, dl

mov di, ax

mov si, offset pacman_00_data
mov cx, 0




pacman_00_L:
mov ax, ds:[si]
xor ax, ES:[DI]
mov es:[di], ax
inc si
inc di
inc cx
cmp cx, 64
jb pacman_00_L

ret


pacman_00 endp

pacman_00_data:
   DB 0,0,44,44,44,44,0,0
   DB 0,44,44,44,44,44,44,0
   DB 44,44,44,44,44,44,44,44
   DB 44,44,44,44,44,44,44,44
   DB 44,44,44,44,44,44,44,44
   DB 44,44,44,44,44,44,44,44
   DB 0,44,44,44,44,44,44,0
   DB 0,0,44,44,44,44,0,0
main proc FAR
ASSUME CS:CODE, DS:DATA

   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   
   mov ax, 0a000h; video memory begins at segment 0a000h, actual address is this X 16
   mov es, ax ; es pointer now holds page offset
  
   mov dh, 20
   mov dl, 20
   call pacman_00
   
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

