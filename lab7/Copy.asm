.386
.MODEL FLAT,C

PUBLIC CopyStr
.CODE				
CopyStr:
	PUSH EBP
	MOV EBP,ESP
	PUSH ESI
	PUSH EDI

	MOV ESI, [EBP+8]   ;STR1 from
	MOV EDI, [EBP+12]  ;STR2 to
	MOV ECX, [EBP+16]  ;LEN первой строки

	MOV EAX, EDI
	CMP ESI, EDI        
	JAE M1				; если адрес первой строки больше или равен второй, перва€ строка позже чем втора€
	JMP M2				
M1:
	CLD					; установка флага DF = 0
	REP MOVSB			; в EDI кладетс€ ESI, оба регистра увеличиваютс€ на 1, 
						; это делаетс€ —’ раз, строка ESI полностью копируетс€ в EDI
	JMP EXIT
M2:
	STD					; установка DF в 1
	ADD ESI, ECX		; переход к концу строки
	DEC ESI				; стоим на последнем символе а не на нуле
	ADD EDI, ECX		; переход к концу строки
	DEC EDI				; стоим на последнем символе а не на нуле
	REP MOVSB			; в EDI кладетс€ ESI, оба регистра уменьшаетс€ на 1, 
						; это делаетс€ —’ раз, стрка ESI полностью копируетс€ в EDI

EXIT:
	POP EDI
	POP ESI
	POP EBP
	RET					; функци€ возвращает указатель на начало второй строки
END