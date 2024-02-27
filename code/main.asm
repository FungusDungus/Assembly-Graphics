.model flat,stdcall
.stack 4096
.data
frame db 64000 DUP(50)

.code
main proc
      mov ah, 00h ; video mode
      mov al, 13h ; mode
      
      int 10h
      
      
      mov ah,0ch  ; pixel mode
      mov al,50  ; color
      mov bh,00h  ; page #
      mov cx,1  ; column
      mov dx,1  ; row
      
      int 10h
      
      ; exit on keystroke
      mov ah,1
      int 16h
      
      DONE:
      mov ah,0    ;clear key
      int 16h
      
      mov ax,3    ;reset to text mode
      int 10h
      
      mov ah,4ch  ;exit to DOS
      int  21h
      
main endp
end main
