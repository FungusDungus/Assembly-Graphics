; PACMAN GAME

.model small
.stack 1024
.data
arenacolor    EQU 54
pacmanx       DW 63
pacmany       DW 4
pacmanxdir    DB 2
pacmanydir    DB 0
pac_ani_frame DB 0

elapsed DB ?

.code

mov ax, @data
mov ds, ax

mov ah, 0
mov al, 13h
int 10h

mov ax, 0a000h
mov es, ax


gameloop:
mov ah, 2ch
int 21h
cmp dl, elapsed
je gameloop
mov elapsed, dl

;---------------;
;  Key Reading  ;
;---------------;

mov ah, 1
int 16h
jz spriteprocess
dec ah
int 16h


;------------------;
;  Key Processing  ;
;------------------;

; w
cmp al, 77h
jne s


s:
cmp al, 73h
jne a

a:
cmp al, 61h
jne d

d:
cmp al, 64h
jne e

; esc
e:
cmp al, 27
je done


;---------------------;
;  Sprite Processing  ;
;---------------------;

spriteprocess:
mov ax, pacmanx
add ax, pacmanxdir
mov bx, pacmany
add bx, pacmanydir




jmp gameloop


;---------------;
;  Termination  ;
;---------------;

done:

mov ax, 3   
int 10h

mov ah, 4ch 
int 21h

;--------------;
;  Procedures  ;
;--------------;

; uses and preserved: bx -> x val, ax -> y val | returns: cx -> pixel offset from 0a000h segment
coordtranslate proc
push bx
push ax
mov cl, 6
shl ax, cl
add bx, ax
mov cl, 2
shl ax, cl
add bx, ax
mov cx, bx
pop ax
pop bx
ret
coordtranslate endp

----------------

detectcollision proc

mov bx, pacmanx
mov ax, pacmany



detectcollision endp

----------------


END