.model flat,stdcall
.stack 4096
.data
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

main proc
      mov ah, 0   ; video mode
      mov al, 13h ; mode
      int 10h
      
      ; video memory begins at 0a000h
      mov ax, 0a000h
      mov es, ax ; move to segment register, video memory fits into a single paragraph
      
      ; tests
      mov bx, 0
      mov cx, 0
      mov si, 1
      
      l1:
      call vram_modify
      inc si
      cmp si, 256
      jbe cont
      mov si,1
      cont:
      cmp bx, 320
      inc bx
      jb l1
      xor bx, bx
      cmp cx, 200
      inc cx
      jb l1
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
