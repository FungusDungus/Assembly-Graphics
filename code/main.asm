.model flat,stdcall
.stack 4096
.data

; the current page counter-intuitively denotes the page not being displayed but being written to
CurrentPageOffset dw 0a000h ; video memory begins at 0a000h

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
   cmp CurrentPageOffset, 0a000h
   je DispPage0
   DispPage1:
   mov cx, 3e80h
   jmp PerformDisp
   DispPage0:
   xor cx, cx
   PerformDisp:
   
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
   mov ax, 3eh ; upper start bits
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
   
   push ax
   mov ax, CurrentPageOffset
   cmp ax, 0a000h
   je SetPage1
   SetPage0:
   add ax, -64000
   jmp SetBase
   SetPage1:
   add ax, 64000
   SetBase:
   mov CurrentPageOffset, ax
   
   mov ax, 0a000h
   mov es,ax
   
   mov bx, 0 ; 0 index 0 - 319
   mov cx, 0 ; 0 indexed, 0 - 199
   mov ax, 320
   mul cx
   add bx, ax
   mov ax,50
   mov es:[bx], ax
   
   
   
   
   ;mov es, ax ; es pointer now holds page offset
   pop ax
   
   ; perform all updates to the new page here
    
    
    
   ; flip page to display the updates
  ; call toggle_page ;the page that is being displayed is not the one being written to
   
   ; VYSNC?
   ; block copying
   
   
   
   mov bx, 0
   mov cx, 600; 0 indexed
   mov ax, 320
   mul cx
   add bx, ax
   mov ax,90
   mov es:[bx], ax
   
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
