INCLUDE pacman.inc
.model flat,stdcall
.stack 4096

DATA SEGMENT PARA 'DATA'
time_passed DB ?
direction_offset DW ?
snake_length DW ?
snake DW 2000 DUP(0)
fruit_pos DW ?
wrap_x DW ?
wrap_x_val DW ?
wrap_y DW ?
wrap_y_val DW ?
DATA ENDS

CODE SEGMENT PARA 'CODE'

rand_fruit_pos PROC FAR USES ax, bx, dx
ASSUME CS:CODE, DS:DATA
    mov ah, 0
    int 1ah

    mov ax, dx 
    mul snake_length
    mov dx, 0
    mov bx, 32000
    div bx
    shl dx, 1

    mov fruit_pos, dx

    RET
rand_fruit_pos ENDP


main proc FAR
ASSUME CS:CODE, DS:DATA

   mov ah, 0   ; video mode
   mov al, 13h ; mode
   int 10h
   
   
   mov ax, 0a000h; video memory begins at segment 0a000h, actual address is this X 16
   mov es, ax ; es pointer now holds page offset
  
   mov time_passed, 0
   mov direction_offset, -320
   mov snake_length, 4
   mov fruit_pos, 32050
   
   mov cx, 0
   mov ax, 32800; start pos
   
   INITIALSNAKE:
   mov bx, cx
   shl bx, 1
   mov snake[bx], ax
   mov bx, snake[bx]
   mov es:[bx], BYTE PTR 32h

   sub ax, direction_offset
   inc cx
   cmp cx, snake_length
   jb INITIALSNAKE
   
   GETTIME:
   mov ah, 2ch ; system time code
   int 21h ; interrupt used to get system time touches cx and dx
   cmp dl, time_passed ;dl contains 1/100 of second time
   
   je GETTIME
   
   mov time_passed, dl
   
   mov ah, 1
   int 16h
   jz move_player_intermediate
   mov ah, 0
   int 16h
   
   jmp skip_move_inter
   move_player_intermediate:
   jmp MOVEPLAYER
   skip_move_inter:
   
   cmp al, 77h ;w
   je w
   cmp al, 73h ;s
   je s
   cmp al, 61h ;a
   je a
   cmp al, 64h ;d
   je d
   cmp al, 65h ;e
   je done_intermediate
   jmp move_player_intermediate
   
   jmp skip_done
   done_intermediate:
   jmp done
   skip_done:
  
   w:
   cmp direction_offset, 320
   je move_player_intermediate
   mov wrap_x_val, 0
   mov wrap_y_val, -1
   mov direction_offset, -320
   jmp move_player_intermediate
   
   s:
   cmp direction_offset, -320
   je MOVEPLAYER  
   mov wrap_x_val, 0
   mov wrap_y_val, 1
   mov direction_offset, 320
   jmp MOVEPLAYER
   
   a:
   cmp direction_offset, 1
   je MOVEPLAYER
   mov wrap_x_val, -1
   mov wrap_y_val, 0
   mov direction_offset, -1
   jmp MOVEPLAYER
   
   d:
   cmp direction_offset, -1
   je MOVEPLAYER 
   mov wrap_x_val, 1
   mov wrap_y_val, 0
   mov direction_offset, 1
   jmp MOVEPLAYER
   
   MOVEPLAYER:
   
   mov bx, snake_length
   dec bx
   shl bx, 1; x 2
   mov ax, bx
   
   mov bx, snake[bx]
   mov es:[bx], BYTE PTR 0h ; clear end
   
   mov cx, snake_length
   dec cx
   
   mov bx, ax
   sub bx, 2
   
   ; do not make snake start at length 1
   COPY:
   
   mov ax, bx
   add ax, 2
   mov dx, snake[bx]
   mov bx, ax
   mov snake[bx], dx
   sub bx, 4
   dec cx
   cmp cx, 0
   ja COPY
   
   mov ax, snake[0]
   add ax, direction_offset
   mov snake[0], ax
   mov bx, ax
   mov al, es:[bx]
   cmp al, 32h ; collision detection
   je shutdown
   mov es:[bx], BYTE PTR 32h
   
   mov bx, fruit_pos
   mov es:[bx], BYTE PTR 5h
   
   mov bx, snake[0]
   mov al, es:[bx]
   cmp al, 5h ; fruit detection
   jne no_fruit
   
   mov bx, snake_length
   add snake_length, 1;
   dec bx
   shl bx, 1; x 2
   mov ax, snake[bx]
   sub ax, direction_offset
   add bx, 2
   
   mov snake[bx], ax

   mov bx, fruit_pos
   mov es:[bx], BYTE PTR 32h
   
   CALL rand_fruit_pos
   no_fruit:
   
   jmp GETTIME

   shutdown:

   jmp done
   
   done:
   
   mov ax, 0
   mov bx, 0
   mov cx, 0
   mov dx, 0
   mov ah, 1
   int 16h
   
   mov ax, 3    ;reset to text mode
   int 10h
   
   mov ah, 4ch  ;exit to DOS
   int 21h
      
main endp
end main

CODE ENDS
