STACK SEGMENT PARA STACK
   DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT 
	MSG DB  "Hello, World!", "$"; DB: DEFINE BYTE
								; $: terminates the string
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA 
	; INIT SEGMENT REGS	
	START:
		mov ah, 00h
      mov al, 13h
      int 10h
      
      mov ah,0ch
      mov al,4
      mov bh,00h
      mov ah,0ch
      mov cx,160
      mov dx,120
      
      int 10h

	STOP:
		MOV AX, 4C00H
		INT 10H 
CODE ENDS 
	END START
