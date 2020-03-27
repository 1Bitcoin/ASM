STK SEGMENT para STACK 'STACK'
		db 100 dup(0)
STK ENDS

SD1 SEGMENT para 'DATA'
	number_row db (0)
	i db (0)
	buf_number db (0)

	row db (0)
	copy_row db (0)
	column db (0)

	sum db (0)
	sum_buf db (0)
	matrix db 9*9 dup('$')

	input_row_msg db 'Input row: ', 10, 13, 24h
	input_column_msg db 'Input column: ', 10, 13, 24h


SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:SD1, SS:STK

input_row proc
	mov dx, offset input_row_msg
	mov ah, 9
	int 21h

	mov ah, 01h
	int 21h

	sub al, '0'

	mov ds:row, al

	call print_endline

	ret

input_row endp

input_column proc
	mov dx, offset input_column_msg
	mov ah, 9
	int 21h

	mov ah, 01h
	int 21h

	sub al, '0'

	mov ds:column, al

	call print_endline

	ret

input_column endp


print_endline proc

	mov ah, 02

	mov dl, 13   ;возврат каретки
	int 21h

	mov dl, 10   ;перевод строки
	int 21h

	ret

print_endline endp

input_matrix proc

	mov al, ds:row
	mov bl, ds:column

	mul bl

	mov ah, 0
	mov cx, ax
	mov si, 0

metka1:
	mov ah, 01h
	int 21h

    cmp al, 13
    JE metka1

    cmp al, 32
    JE metka1

	sub al, '0'

	mov matrix[si], al
	inc si

	loop metka1

	call print_endline

	ret

input_matrix endp

output_matrix proc
	mov al, ds:row   ; число повторений внешнего цикла

	mov ah, 0
	mov cx, ax
	mov si, 0

label_1:    
    mov bx, cx; cx ---> bx, сохраняем число повторений внешнего цикла

    mov al, ds:column
    mov ah, 0
	mov cx, ax; число повторений внутреннего цикла

label_2:    
	mov ah, 02h
	add matrix[si], '0'
	mov dl, matrix[si]
	int 21h

	mov dl, 32 ;пробел
	int 21h

	inc si

    loop label_2

    mov cx, bx; bx ---> cx, восстанавливаем число повторений внешнего цикла
    call print_endline; с новой строки

    loop label_1 ;
 
    ret             

output_matrix endp

setup_segment_data proc
	mov ax, SD1
	mov ds, ax

	ret

setup_segment_data endp

find_max_row proc
	call print_endline

	mov ds:i, 0
	mov al, ds:row; число повторений внешнего цикла

	mov ah, 0
	mov cx, ax
	mov si, 0 

label_1:    
    mov bx, cx; cx ---> bx, сохраняем число повторений внешнего цикла

    mov al, ds:column
    mov ah, 0
	mov cx, ax; число повторений внутреннего цикла

label_2:  
	mov ah, matrix[si] 
	add sum_buf, ah

	inc si

    loop label_2

    inc i

    mov ah, ds:sum_buf
    cmp ah, sum
    JA swap

    mov sum_buf, 0

    next:
    	mov sum_buf, 0
	    mov cx, bx; bx ---> cx, восстанавливаем число повторений внешнего цикла

	    loop label_1
	 
	    ret    

    swap:
    	mov ah, ds:i 
    	mov ds:number_row, ah
    	dec ds:number_row
    	mov ah, ds:sum_buf
    	xchg ah, sum
    	jmp next         

    ret

find_max_row endp

replace_row proc
	
	mov al, ds:column   ; число повторений цикла

	mov ah, 0
	mov cx, ax

	mov i, 0
	
	mov al, ds:row
	mov ds:copy_row, al
	dec ds:copy_row

label_1:  
	mov al, ds:copy_row
	mul ds:column
	add al, i
	mov si, ax

	mov al, matrix[si]
	mov buf_number, al

	mov al, ds:number_row
	mul ds:column
	add al, i
	mov si, ax

	mov al, buf_number
	mov matrix[si], al

	inc i
    loop label_1 
 
	ret

replace_row endp

main:

	call setup_segment_data
	call input_row
	call input_column
	call input_matrix
	call find_max_row

	call replace_row 
    call output_matrix

	mov ax, 4c00h ; конец программы
	int 21h

SC1 ENDS
END MAIN
