.model tiny
.186


CODE SEGMENT
	assume cs:code, ds:code
	org 100h
 
 main: 	
	jmp inizial                     ;на запуск программы
	int9_true dd ?
	installed dw 8888                   ;индентификатор, установлена прога или нет
 
 
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

	; —начала вызовем предыдущий обработчик, чтобы дать BIOS возможность
	; обработать прерывание и, если это было нажатие клавиши, поместить код
	; в клавиатурный буфер
	call cs:int9_true

	push 0040h
	pop ds                              ; DS = сегментный адрес области данных BIOS

	mov di,ds:001Ah                     ; адрес головы буфера клавиатуры
	cmp di,ds:001Ch                     ; если он равен адресу хвоста,   
	je quit                             ; буфер пуст, и нам делать нечего
	                             	    ; (например, если прерывание пришло по
	                             	    ; отпусканию клавиши),
	mov ax,[di]                         ; иначе: считать символ из головы
	                             	    ; буфера

	;========= замена буквы 'a' на 's' в верхнем и нижнем регистре ===========
	cmp al,'a'                          ; если это не клавиша a
	jne check_big_a                     ; проверить на ј

	mov ds:001Ch,di                     ; установить адреса хвоста равным голове, т.е. буфер пуст
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'s'
	int 16h                             ; и заносим в буфер букву s
	jmp quit

	check_big_a:
	cmp al,'A'                          ; если это не клавиша A
	jne check_s                         ; проверить на s

	mov ds:001Ch,di                     ; установить адреса хвоста равным голове, т.е. буфер пуст
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'S' 
	int 16h                             ; и заносим в буфер букву S
	jmp quit

	check_s: 
	cmp al,'s'                          ; если это не клавиша s
	jne check_big_s                     ; проверить на S

	mov ds:001Ch,di                     ; установить адреса хвоста равным голове, т.е. буфер пуст
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'a'
	int 16h                             ; и заносим в буфер букву a
	jmp quit

	check_big_s:
	cmp al,'S'                          ; если это не клавиша S
	jne quit                            ; выйти

	mov ds:001Ch,di                     ; установить адреса хвоста равным голове, т.е. буфер пуст
	xor ax,ax
	mov ah,5h
	xor cx,cx
	mov cl,'A'   
	int 16h                             ; и заносим в буфер букву A

	quit:   
	        pop ds
	        pop es

	        pop dx
	        pop cx
	        pop bx
	        pop ax

	        iret                              
int9_fake endp 
 
inizial:                          	    ; старт основной программы
	mov ax,3509h                        ; получаем в ES:BX вектор 09
	int 21h                             ; прерывани€
	cmp es:installed,8888               ; провер€ем того, загружена ли уже программа
	je uninstall                        ; если загружена - выгружаем

	mov word ptr cs:int9_true,bx        ; запомнием старый вектор 09
	mov word ptr cs:int9_true+2,es      ; прерывани€

	mov ax,2509h                        ; устанавливаем новый вектор на 09
	mov dx,offset int9_fake             ; прерывание
	int 21h

	mov dx,offset installed_msg         ; выводим что все ок
	mov ah,9h
	int 21h

	mov dx,offset inizial            ; остаемс€ в пам€ти резидентом
	int 27h                             ; и выходим
  
uninstall:                                  ; выгрузка программы из пам€ти
	push es
	push ds
	mov dx,word ptr es:int9_true        ; возвращаем вектор прерывани€
	mov ds,word ptr es:int9_true+2      ; на место
	mov ax,2509h			    ; DS:DX
	int 21h
	pop ds
	pop es

	mov ah,49h                          ; освобождаем пам€ть
	int 21h

	mov dx,offset uninstalled_msg
	mov ah,9h
	int 21h
	jmp exit                            ; выходим из программы
 
exit:                                	     ; выход
	mov ah,4Ch
	int 21h

installed_msg db 'Installed$'
uninstalled_msg db 'Uninstalled$'
 
CODE ends
end main