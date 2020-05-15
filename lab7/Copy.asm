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
	MOV ECX, [EBP+16]  ;LEN ������ ������

	MOV EAX, EDI
	CMP ESI, EDI        
	JAE M1				; ���� ����� ������ ������ ������ ��� ����� ������, ������ ������ ����� ��� ������
	JMP M2				
M1:
	CLD					; ��������� ����� DF = 0
	REP MOVSB			; � EDI �������� ESI, ��� �������� ������������� �� 1, 
						; ��� �������� �� ���, ������ ESI ��������� ���������� � EDI
	JMP EXIT
M2:
	STD					; ��������� DF � 1
	ADD ESI, ECX		; ������� � ����� ������
	DEC ESI				; ����� �� ��������� ������� � �� �� ����
	ADD EDI, ECX		; ������� � ����� ������
	DEC EDI				; ����� �� ��������� ������� � �� �� ����
	REP MOVSB			; � EDI �������� ESI, ��� �������� ����������� �� 1, 
						; ��� �������� �� ���, ����� ESI ��������� ���������� � EDI

EXIT:
	POP EDI
	POP ESI
	POP EBP
	RET					; ������� ���������� ��������� �� ������ ������ ������
END