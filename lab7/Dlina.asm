.386
.model flat, c

public StrLength

.code

StrLength:
	push ebp
	mov ebp, esp

	push edi
	mov edi, [ebp + 8] ; string
	mov al, 0 ; end of string

	cld ; DF = 0
	mov ecx, -1 ; FFFF
	repne scasb ; ищем конец строки и изменяем cx
	neg ecx 
	sub ecx, 2 ; get the actual len
	mov eax, ecx

	pop edi
	pop ebp
	ret
end