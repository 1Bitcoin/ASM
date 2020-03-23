PUBLIC X
PUBLIC work

SD1 SEGMENT para 'DATA'
	X db '0'
SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:SD1
work:
    sub X, 32 ; вычитаем 32 из кода символа
    mov DL, X ; помещаем в DL X, для вывода буквы

    mov AH, 2 ; вывод заглавного варианта буквы
    int 21h

    mov AX, 4c00h ; конец программы
    int 21h

SC1 ENDS
END WORK
