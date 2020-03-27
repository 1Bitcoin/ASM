PUBLIC X
PUBLIC work

SD1 SEGMENT para 'DATA'
	X db '0'
SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:SD1
work proc far
	mov AH, 2

	mov DL, X ;вывод исходного символа
	int 21h
	
	mov DL, 32 ;пробел
	int 21h

    sub X, 32 ; вычитаем 32 из кода символа (lower -> upper)

    mov DL, X ; помещаем в DL X, для вывода буквы
    int 21h

    ret

WORK endp
SC1 ENDS
END
