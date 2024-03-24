.model flat,stdcall
.stack 4096
DATA SEGMENT PARA 'DATA'
; frame db 64000 DUP(50)
x_pos DW 160
y_pos DW 190

DATA ENDS

CODE SEGMENT PARA 'CODE'

    print_pixel MACRO x_pos:REQ, y_pos:REQ
        MOV AH, 0Ch
        MOV AL, 50
        MOV BH, 00h
        MOV CX, x_pos
        MOV DX, y_pos
        INT 10h
    ENDM

    main proc FAR
    ASSUME CS:CODE, DS:DATA
        PUSH DS
        SUB AX, AX
        PUSH AX
        MOV AX, DATA
        MOV DS, AX
        POP AX
        POP AX

        mov ah, 00h ; video mode
        mov al, 13h ; mode

        int 10h

        main_loop: 

            print_pixel x_pos, y_pos

            ; get keyboard status
            mov ah, 1 
            int 16h

            ; if a key is pressed (ZF == 0) jump to get_keys
            ; else jump to main_loop
            JZ get_key
            JMP main_loop

            move_up:
                DEC y_pos
                CMP y_pos, -1
                JE wrap_up
                JMP main_loop
            
            wrap_up:
                ADD y_pos, 200
                JMP main_loop

            move_down:
                INC y_pos
                CMP y_pos, 200
                JE wrap_down
                JMP main_loop

            wrap_down:
                SUB y_pos, 200 
                JMP main_loop

            move_left:
                DEC x_pos
                CMP x_pos, -1
                JE wrap_left
                JMP main_loop

            wrap_left:
                ADD x_pos, 320
                JMP main_loop

            move_right:
                INC x_pos
                CMP x_pos, 320
                JE wrap_right
                JMP main_loop

            wrap_right:
                SUB x_pos, 320
                JMP main_loop

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

CODE ENDS
