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
      mov cx,160
      mov dx,100
      mov al,4
      int 10h

	STOP:
		MOV AX, 4C00H
		INT 21H 
CODE ENDS 
	END START
