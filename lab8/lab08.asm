.model small
  .STACK  100h
  .DATA
  .286

x  dd 4195835.0
y  dd 3145727.0
z  dd ?

BugMsg db 13,10,"Pentium NPU bug detected!", "$"
OkMsg db 13,10,"Your Pentium NPU is OK", "$"

  .CODE
begin:

  mov ax, DGROUP
  mov ds, ax

; Записываем в стек численных регистров
; значение x
  fld    x

; Делим содержимое верхушки стека
; на константу y
  fdiv   y

; Умножаем содержимое верхушки стека
; на эту же константу
  fmul   y

; В результате при отсутствии ошибки мы должны
; получить результат, равный x
  fcom   x

; Сохраняем регистр состояния сопроцессора в AX
  fstsw  ax

; Переписываем AH в регистр флагов
  sahf

; Проверяем равенство нулю
  jnz    bug

; Ошибки нет
  mov ah, 9
  mov dx, offset OkMsg
  int 21h
  jmp next

; Обнаружена ошибка
bug:

  mov ah, 9
  mov dx, offset BugMsg
  int 21h

; Завершаем работу программы и
; возвращаем управление операционной системе

next:

  mov ax, 4C00h
  int 21h
  
  END begin
