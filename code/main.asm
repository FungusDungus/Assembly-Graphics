.model flat,stdcall
.stack 4096
DATA SEGMENT PARA 'DATA'
; frame db 64000 DUP(50)
x_pos DW 160
y_pos DW 190
color DB 40
last_x DW ?
last_y Dw ?

DATA ENDS

CODE SEGMENT PARA 'CODE'
    
    calc_linear_pos MACRO CX, CD
        
        MOV AX, DX
        MOV BX, DX
        PUSH CX
        MOV CL, 8
        SHL AX, CL
        MOV CL, 6
        SHL BX, CL
        ADD BX, AX
        POP CX
        ADD BX, CX

    ENDM

    print_pixel PROC FAR 
    ASSUME CS:CODE, DS:DATA

        calc_linear_pos CX, DX
        MOV AL, 50

        MOV ES:[BX], AL

        PUSH CX
        PUSH DX
        MOV CX, last_x
        MOV DX, last_y
        calc_linear_pos CX, DX
        MOV AL, 0
        MOV ES:[BX], AL 
        POP DX
        POP CX
        
        RET

    print_pixel ENDP

    move_up_p PROC FAR
    ASSUME CS:CODE, DS:DATA

        MOV AX, y_pos
        MOV last_y, AX
        MOV AX, x_pos
        MOV last_x, AX
        DEC y_pos
        CMP y_pos, -1
        ; JE wrap_up
        JMP main_loop
                
        ; wrap_up:
        ;     ADD y_pos, 200
        ;     JMP main_loop
        RET
    move_up_p ENDP

    move_down_p PROC FAR
    ASSUME CS:CODE, DS:DATA

        MOV AX, y_pos
        MOV last_y, AX
        MOV AX, x_pos
        MOV last_x, AX
        INC y_pos
        CMP y_pos, 200
        ; JE wrap_down
        JMP main_loop

        ; wrap_down:
        ;     SUB y_pos, 200 
        ;     JMP main_loop
        RET

    move_down_p ENDP

    move_left_p PROC FAR
    ASSUME CS:CODE, DS:DATA

        MOV AX, y_pos
        MOV last_y, AX
        MOV AX, x_pos
        MOV last_x, AX
        DEC x_pos
        CMP x_pos, -1
        ; JE wrap_left
        JMP main_loop

        ; wrap_left:
        ;     ADD x_pos, 320
        ;     JMP main_loop

        RET
        
    move_left_p ENDP

    move_right_p PROC FAR  
    ASSUME CS:CODE, DS:DATA

        MOV AX, y_pos
        MOV last_y, AX
        MOV AX, x_pos
        MOV last_x, AX
        INC x_pos
        CMP x_pos, 320
        ; JE wrap_right
        JMP main_loop

        ; wrap_right:
        ;     SUB x_pos, 320
        ;     JMP main_loop
        RET
    move_right_p ENDP

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

        MOV AX, 0A000h
        MOV ES, AX

        main_loop: 

            MOV CX, x_pos
            MOV DX, y_pos
            CALL print_pixel

            ; get keyboard status
            mov ah, 1 
            int 16h

            ; if a key is pressed (ZF == 0) jump to get_keys
            ; else jump to main_loop
            JZ get_key
            JMP main_loop

            move_up:
                CALL move_up_p
            
            move_down:
                CALL move_down_p

            move_left:
                CALL move_left_p

            move_right:
                CALL move_right_p

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
