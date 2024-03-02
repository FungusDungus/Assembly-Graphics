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
      mov es, ax ; move video memory offset to segment register, memory for 320x200 video mode fits into a single segment
      
      
      
    ; tests
     mov si, 1
     new:
     mov bx, 0
     mov cx, 0
      
      
      l1:
      call vram_modify
      cmp bx, 320
      inc bx
      jb l1
      xor bx, bx
      cmp cx, 200
      inc cx
      jb l1
      inc si
      cmp si, 256
      jbe new
      mov si,1
      jmp new
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
