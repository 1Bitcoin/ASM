EXTRN	SCAN : NEAR
EXTRN	UB : NEAR ; unsigned bin 
EXTRN	SD : NEAR ; signed dec

SSTACK	SEGMENT PARA STACK 'STACK' ; 
	DB 64 DUP('0')

SSTACK	ENDS

DSEG	SEGMENT PARA PUBLIC 'DATA'
		MANAGER	DW UB, SD, SCAN
		X DW 10 ; стандартное число
		
		MENU 		DB	'	                    MENU', 10, 13
				DB	'0) Print menu again', 10, 13
				DB	'1) Input number', 10, 13
				DB	'2) Print number as unsigned bin', 10, 13 
				DB	'3) Print number as signed dec', 10, 13
				DB	'4) Exit', 10, 13, '$'
		ENTER_s	DB '> $' ; 
		NEW_LINE DB 10, 13, '$'; 
DSEG	ENDS

CSEG	SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSTACK

BEGIN:
	MOV  AX, DSEG
	MOV  DS, AX

PRINT_MENU:
	MOV  AH, 9 ; вывод меню
	MOV  DX, OFFSET MENU
	INT  21H
		
PRINT_ENTER:
	MOV  AH, 9
	MOV  DX, OFFSET ENTER_s 
	INT  21H
		
SCAN_MENU:
	MOV  AH, 8 ; сканируем выбор в меню
	INT  21H
	
	CMP  AL, '0' ;
	JB   SCAN_MENU ; сканируем снова
	CMP  AL, '4'; if >= 0 or <= 4
	JA   SCAN_MENU 
	
	MOV  BL, AL ; сохранить выбор в bl
	XOR  BH, BH ; очсистить bh
	
	MOV  AH, 2 ; вывести выбор
	MOV  DL, AL
	INT  21H
	
	MOV  AH, 9 ; print new line
	MOV  DX, OFFSET NEW_LINE
	INT  21H
		
PROCESS:
	SUB  BX, '0' ; получаем само число
	
	CMP  BX, 4 ; если 4 - закрываем прогу
	JE  EXIT
	
	CMP  BX, 0 ; если 0 - опять принтуем
	JE   PRINT_MENU
	
	CMP  BX, 1 ; если 1 - вводим число
	JE   INPUT_NUMBER
	
	SUB  BX, 2 ; 
	SHL  BX, 1 ; 
	
	PUSH X 
	PUSH SI
	CALL MANAGER[BX] ; номер функции вызова bx
	
	JMP  PRINT_ENTER ; сканируем след.выбор
		
INPUT_NUMBER:
	CALL MANAGER[4]
	
	MOV  X, AX  
	MOV  SI, DX
	
	JMP  PRINT_ENTER
		
EXIT:
	MOV  AH, 4CH ; закрываем программу
	INT  21H
		
CSEG ENDS
END BEGIN