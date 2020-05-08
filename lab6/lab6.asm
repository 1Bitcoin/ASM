.model tiny
.186


CODE SEGMENT
	assume cs:code, ds:code
	org 100h
 
 main: 	
	jmp inizial                     ;�� ������ ���������
	int9_true dd ?
	installed dw 8888                   ;��������������, ����������� ����� ��� ���
 
 
int9_fake proc    
	push ax
	push bx
	push cx
	push dx

	push es
	push ds
	pushf
    
	xor bx,bx
	xor dx,dx

	; ������� ������� ���������� ����������, ����� ���� BIOS �����������
	; ���������� ���������� �, ���� ��� ���� ������� �������, ��������� ���
	; � ������������ �����
	call cs:int9_true

	push 0040h
	pop ds                              ; DS = ���������� ����� ������� ������ BIOS

	mov di,ds:001Ah                     ; ����� ������ ������ ����������
	cmp di,ds:001Ch                     ; ���� �� ����� ������ ������,   
	je quit                             ; ����� ����, � ��� ������ ������
	                             	    ; (��������, ���� ���������� ������ ��
	                             	    ; ���������� �������),
	mov ax,[di]                         ; �����: ������� ������ �� ������
	                             	    ; ������

	;========= ������ ����� 'a' �� 's' � ������� � ������ �������� ===========
	cmp al,'a'                          ; ���� ��� �� ������� a
	jne check_big_a                     ; ��������� �� �

	mov ds:001Ch,di                     ; ���������� ������ ������ ������ ������, �.�. ����� ����
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'s'
	int 16h                             ; � ������� � ����� ����� s
	jmp quit

	check_big_a:
	cmp al,'A'                          ; ���� ��� �� ������� A
	jne check_s                         ; ��������� �� s

	mov ds:001Ch,di                     ; ���������� ������ ������ ������ ������, �.�. ����� ����
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'S' 
	int 16h                             ; � ������� � ����� ����� S
	jmp quit

	check_s: 
	cmp al,'s'                          ; ���� ��� �� ������� s
	jne check_big_s                     ; ��������� �� S

	mov ds:001Ch,di                     ; ���������� ������ ������ ������ ������, �.�. ����� ����
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'a'
	int 16h                             ; � ������� � ����� ����� a
	jmp quit

	check_big_s:
	cmp al,'S'                          ; ���� ��� �� ������� S
	jne quit                            ; �����

	mov ds:001Ch,di                     ; ���������� ������ ������ ������ ������, �.�. ����� ����
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'A'   
	int 16h                             ; � ������� � ����� ����� A

	quit:   
	        pop ds
	        pop es

	        pop dx
	        pop cx
	        pop bx
	        pop ax

	        iret                              
int9_fake endp 
 
inizial:                          	    ; ����� �������� ���������
	mov ax,3509h                        ; �������� � ES:BX ������ 09
	int 21h                             ; ����������
	cmp es:installed,8888               ; ��������� ����, ��������� �� ��� ���������
	je uninstall                        ; ���� ��������� - ���������

	mov word ptr cs:int9_true,bx        ; ��������� ������ ������ 09
	mov word ptr cs:int9_true+2,es      ; ����������

	mov ax,2509h                        ; ������������� ����� ������ �� 09
	mov dx,offset int9_fake             ; ����������
	int 21h

	mov dx,offset installed_msg         ; ������� ��� ��� ��
	mov ah,9h
	int 21h

	mov dx,offset inizial            ; �������� � ������ ����������
	int 27h                             ; � �������
  
uninstall:                                  ; �������� ��������� �� ������
	push es
	push ds
	mov dx,word ptr es:int9_true        ; ���������� ������ ����������
	mov ds,word ptr es:int9_true+2      ; �� �����
	mov ax,2509h			    ; DS:DX
	int 21h
	pop ds
	pop es

	mov ah,49h                          ; ����������� ������
	int 21h

	mov dx,offset uninstalled_msg
	mov ah,9h
	int 21h
	jmp exit                            ; ������� �� ���������
 
exit:                                	     ; �����
	mov ah,4Ch
	int 21h

installed_msg db 'Installed$'
uninstalled_msg db 'Uninstalled$'
 
CODE ends
end main