.model flat,stdcall
.stack 4096
.data

; the current page counter-intuitively denotes the page not being displayed but being written to
CurrentPage dw 0

.code

; for convenience:
; x, y, color
m_vram macro x, y, color
mov bx, x
mov cx, y
mov si, color
call vram_modify
endm

; bx: x pos
; cx: y pos
; si: color
; es: 0a000h, beginning of vram in memory
vram_modify proc
   push bx
   mov ax, 320
   mul cx
   add bx, ax ; at this point the offset from es segment is in bx
   mov es:[bx], si ; move the color
   pop bx
   ret
vram_modify endp

toggle_page proc
   push ax
   push dx
   push cx
   mov ax, [CurrentPage]
   cmp ax, 0
   je DispPage0
   DispPage1:
   dec [CurrentPage]
   mov cx, 3e80h
   jmp PerformDisp
   DispPage0:
   inc [CurrentPage]
   xor cx, cx
   PerformDisp:
   
   xor ax, ax
   
   mov dx, 3d4h
      
   mov ax, 0dh
   out dx, ax
   
   
   inc dx
   mov ax, 00h; lower start bits
   out dx,ax
   
   
   dec dx
   mov ax, 0ch
   out dx, ax
   
   
   inc dx
   mov ax, 7dh; upper start bits
   out dx,ax
   
   pop cx
   pop dx
   pop ax
   ret
   
toggle_page endp


main proc
   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   ; preload first page
   ; make this a procedure
   

   
   mov ax, 0a000h; video memory begins at 0a000h
   mov es, ax ; es pointer now holds page offset
   
   ; perform all updates to the new page here
   
   
   ; tests
   
   mov ax, 5
   mov bx, 60
   mov es:[bx], ax   
   mov ax, 90
   mov bx, 0
   mov es:[bx], ax
   mov bx, 5
   mov es:[bx], ax
 
   
   mov ax,es
   add ax, 4000
   mov es,ax
   
   mov dx, 03c4h
   mov ax, 04h
   out dx, ax
   
   inc dx
   mov ax, 06h
   out dx, ax
   
   mov dx, 03d4h
   mov ax, 14h
   out dx, ax
   
   inc dx
   mov dx, 0h
   out dx, ax
   
   dec dx
   mov ax, 17h
   out dx,ax
   
   inc dx
   mov ax, 0e3h
   out dx, ax
  
   
   mov ax, 5
   mov bx, 60
   mov es:[bx], ax   
   mov ax, 90
   mov bx, 0
   mov es:[bx], ax
   mov bx, 5
   mov es:[bx], ax
    
   
   mov dx, 3d4h
      
   mov ax, 0dh
   out dx, ax
   
   
   inc dx
   mov ax, 80h; lower start bits
   out dx,ax
   
   
   dec dx
   mov ax, 0ch
   out dx, ax
   
   
   inc dx
   mov ax, 3eh; upper start bits
   out dx,ax
   
   
   
   L1:
   
   ; mov bx, 0
   ; mov cx, 0; 0 indexed
   ; mov ax, 320
   ; mul cx
   ; add bx, ax
   ; cmp [CurrentPage], 0
   ; je Color
   ; add bx, 64000
   ; Color:
   ; mov ax,90
   ; mov es:[bx], ax
    
    
   ; flip page to display the updates
   ;the page that is being displayed is not the one being written to
   
   ; mov bx, 319
   ; mov cx, 199; 0 indexed
   ; mov ax, 320
   ; mul cx
   ; add bx, ax
   ; cmp [CurrentPage], 0
   ; je Color1
   ; add bx, 64000
   ; Color1:
   ; mov ax,5
   ; mov es:[bx], ax

   ;call toggle_page
   cmp cx,50000
   inc cx
   jne done
   
   jmp L1
   
   ; VYSNC?
   ; block copying
   
 ; tests
  ; mov si, 1
  ; new:
  ; mov bx, 0
  ; mov cx, 0
   
   
   ; l1:
   ; call vram_modify
   ; cmp bx, 320
   ; inc bx
   ; jb l1
   ; xor bx, bx
   ; cmp cx, 200
   ; inc cx
   ; jb l1
   ; inc si
   ; cmp si, 256
   ; jbe new
   ; mov si,1
   ; jmp new
 ; end tests
      
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
