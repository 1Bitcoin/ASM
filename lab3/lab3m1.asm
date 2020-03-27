EXTRN X: byte
EXTRN work: far

STK SEGMENT para STACK 'STACK'
        db 100 dup(0)
STK ENDS

SC1 SEGMENT para public 'CODE'
    assume CS:SC1
main:
	mov ax, seg X; оператор seg возвращает адрес сегмента, в котором расположена указанная переменная
	mov ds, ax

    mov AH, 8 ;читаем символ с клавиатуры
    int 21h

    mov X, AL

	call work

	mov AX, 4c00h ; конец программы
    int 21h

SC1 ENDS
END MAIN