EXTRN X: byte
EXTRN exit: far

STK SEGMENT para STACK 'STACK'
        db 100 dup(0)
STK ENDS

SC1 SEGMENT para public 'CODE'
        assume CS:SC1
main:
        mov AH, 8 ;читаем символ с клавиатуры
        int 21h

        mov X, AL

	jmp exit
SC1 ENDS
END MAIN