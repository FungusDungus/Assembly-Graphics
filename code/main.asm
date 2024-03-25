.model flat,stdcall
INCLUDE pacman.inc
.stack 4096
.data
.code

main proc
   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   ; preload first page
   ; make this a procedure
   

   
   mov ax, 0a000h; video memory begins at segment 0a000h, actual address is this X 16
   mov es, ax ; es pointer now holds page offset
   
   ; mov dx, 3c4h
   ; mov ax, 04h
   ; out dx, ax
   
   ; mov dx, 3c5h
   ; mov ax, 06h
   ; out dx, ax
   
   ; mov dx, 3d4h
   ; mov ax, 14h
   ; out dx, ax
   
   ; mov dx, 3d5h
   ; mov ax, 0h
   ; out dx, ax

   ; mov dx, 3d4h
   ; mov ax, 17h
   ; out dx, ax 
   
   ; mov dx, 3d5h
   ; mov ax, 0e3h
   ; out dx, ax 
   
   
   ; mov dx, 3c4h
   ; mov ax, 02h
   ; out dx, ax
   
   ; mov dx, 3c5h
   ; mov ax, 11111111b
   ; out dx, ax
   
   
   
   ; mov ax, 90
   ; mov bx, 0
   ; mov es:[bx], ax
   
   
   
   ; perform all updates to the new page here
   
   
   
   ;mov ax, 90; color
   ;mov bx, 0 ; offset from memory: Real formula is width x y coord + xcoord
   ;mov es:[bx], ax  ; setting the color 
   
   pacmanSHOW 0, 0
   pacmanSHOW 303,0
   pacmanSHOW 0, 183
   pacmanSHOW 303,183
   ; mov ah, 0
   ; mov al, 0
   ; mov cx, 64000
   ; mov di, 0
   ; cld
   ; L1:
   ; rep stosw
   ; mov cx, 64000
   ; inc ah
   ; inc al
   ; cmp ah, 255
   ; jb L1
   ; mov ah, 0
   ; mov al, 0
   ; jmp L1
   
   ;VSYNC?
 ;end tests
      
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
