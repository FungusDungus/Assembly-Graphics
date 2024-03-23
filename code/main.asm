.model flat,stdcall
.stack 4096
.data
frame db 64000 DUP(50)
x_pos DW 100
y_pos DW 100

.code
main proc
    mov ah, 00h ; video mode
    mov al, 13h ; mode

    int 10h

    main_loop: 

        mov ah,0ch  ; pixel mode
        mov al,50  ; color
        mov bh,00h  ; page #
        mov cx, x_pos; column
        mov dx, y_pos; row

        int 10h

        ; get keyboard status
        mov ah,1 
        int 16h
        
        ; if a key is pressed (ZF == 0) jump to get_keys
        ; else jump to main_loop
        JZ get_key
        JMP main_loop

    move_down:
        inc y_pos
        jmp main_loop

    move_up:
        dec y_pos
        jmp main_loop

    move_left:
        dec x_pos
        jmp main_loop
    
    move_right:
        inc x_pos
        jmp main_loop

    get_key:
        
        ; get keystroke and store the ASCII value in AL
        mov ah,0    
        int 16h

        ; if key pressed is 'w' jump to move_up
        CMP AL, 77h
        JE move_up

        ; if key pressed is 's' jump to move_down
        CMP al, 73h 
        JE move_down

        ; if key pressed is 'a' jump to move_left
        CMP AL, 61h
        JE move_left

        ; if key pressed is 'd' jump to move_right
        CMP AL, 64h
        JE move_right

        ; if key pressed is 'q' jump to done
        CMP AL, 71h
        JE done
        
        ; else jump to main_loop
        jmp main_loop

    done:      
        mov ax,3    ;reset to text mode
        int 10h

        mov ah,4ch  ;exit to DOS
        int  21h

    main endp
    end main
