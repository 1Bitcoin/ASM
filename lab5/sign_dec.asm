PUBLIC SD

DSEG	SEGMENT PARA PUBLIC 'DATA'

	NEWLINE	DB 10, 13, '$'

DSEG	ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CSEG
				
SD 	PROC NEAR
	PUSH BP
	MOV  BP, SP
	
	MOV  CX, [BP + 4] ; SI 
	MOV  BX, [BP + 6] ; X
	
	CMP  CL, 0
	JE   SD_SKIP_NEG
	
	MOV  AH, 2
	MOV  DL, '-'
	INT  21H
	
	NEG  BX
		
SD_SKIP_NEG:
	PUSH  BX
	PUSH  CX
	
	CALL  UD
	
	POP BP
	RET 4 ; дел x, si
SD ENDP

; unsign dec 
UD	PROC NEAR 
	PUSH BP
	MOV BP, SP 
	MOV AX, [BP + 6] ; AX = X
		
UD_1:
        XOR CX, CX 
        MOV BX, 10 ; базис
UD_2:
        XOR DX, DX 
        DIV BX 
        ADD DX, '0' 
        PUSH DX
        INC CX 
        CMP AX, 0 
        JNE UD_2 

        MOV AH, 2 
UD_3:
        POP DX 
        INT 21H
        LOOP UD_3
		 
		MOV  AH, 9
		MOV  DX, OFFSET NEWLINE
		INT  21H
		
		POP BP
		RET 4 ; дел x, si
UD ENDP		
		
CSEG ENDS
END