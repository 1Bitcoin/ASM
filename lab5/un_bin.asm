PUBLIC UB

DSEG	SEGMENT PARA PUBLIC 'DATA'

	NEWLINE	DB 10, 13, '$'

DSEG	ENDS

CSEG	SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CSEG, DS:DSEG
		
UB 	PROC NEAR
	PUSH BP
	MOV  BP, SP ; регистры стека, SP - точка на вершине стека, поэтому мы настраиваем здесь стек
	
	MOV  BX, [BP + 6] ; в BX положить что-то, что находится в стеке под номером шесть (есть SI, X, BP), BX = X
	
	MOV CX, 16
		
; удалить все нули слева
UB_1:
	SHL BX, 1 ; bitwise left shift by 1 (* 2)
	JNC UB_2
	MOV DH, 1 ; remember 1
	JMP UB_4		

UB_2:
	LOOP UB_1
	INC CX
	
UB_3:
	MOV DH, 0 
	SHL BX, 1 ; битовое смещение влево на 1
	JNC UB_4 ; без переполнения, CF = 0, если 0
	MOV DH, 1 ; DH = 1 , if 1
UB_4:
	MOV  DL, '0' ; DL = 30
	ADD  DL, DH ; DL = 30 + DH                  
		
	MOV  AH, 2 ; print DL
	INT  21h
		
	DEC  CX 
	CMP CX, 0
	JA UB_3

UB_5:	        
	MOV AH, 9
	MOV DX, OFFSET NEWLINE
	INT 21H

	POP BP
	RET 4 ; дел x, si
UB ENDP
		
CSEG ENDS
END
