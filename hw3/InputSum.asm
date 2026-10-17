
; ============================================================
; InputSum.asm —— 输入数字并求和
; 用户输入 1~100 的整数 n，计算 1+2+...+n
; 输入功能：INT 21H，AH=01H
; ============================================================

.model small
.stack 100h

.data
msg1 DB 'Please input a number (1-100): $'
msg2 DB 0DH,0AH,'The sum is: $'

.code
START:
    MOV AX,@DATA
    MOV DS,AX                 ; 初始化数据段

    ; ---------- 输出输入提示 ----------
    LEA DX,msg1
    MOV AH,09H
    INT 21H

    ; ---------- 读取十进制整数 ----------
    MOV BX,0                  ; BX 保存输入的数字

READ_LOOP:
    MOV AH,01H
    INT 21H                   ; AL = 输入字符

    CMP AL,0DH                ; 是否按下回车？
    JE READ_DONE

    SUB AL,'0'                ; ASCII 字符转换为数字 0~9
    MOV AH,0
    MOV SI,AX                 ; 暂存当前数字

    MOV AX,BX
    MOV CX,10
    MUL CX                    ; AX = BX * 10
    MOV BX,AX
    ADD BX,SI                 ; BX = BX * 10 + 当前数字

    JMP READ_LOOP

READ_DONE:
    ; ---------- 计算 1+2+...+n ----------
    MOV CX,BX                 ; CX = 用户输入的 n
    MOV AX,0                  ; AX 保存累加结果
    MOV BX,1                  ; BX = 当前加数

SUM_LOOP:
    ADD AX,BX
    INC BX
    LOOP SUM_LOOP

    ; ---------- 输出求和结果 ----------
    LEA DX,msg2
    MOV AH,09H
    INT 21H

    CALL PRINT_DEC

    ; ---------- 返回 DOS ----------
    MOV AX,4C00H
    INT 21H

; ============================================================
; 子程序：将 AX 中的无符号整数转换为十进制并输出
; ============================================================

PRINT_DEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX,10
    XOR CX,CX                 ; CX 保存数字位数

DIV_LOOP:
    XOR DX,DX
    DIV BX                    ; AX = 商，DX = 余数
    PUSH DX
    INC CX
    CMP AX,0
    JNE DIV_LOOP

PRINT_LOOP:
    POP DX
    ADD DL,'0'                ; 数字转换为 ASCII 字符
    MOV AH,02H
    INT 21H
    LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DEC ENDP

END START
