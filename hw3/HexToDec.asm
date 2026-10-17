
; ============================================================
; DecToHex.asm
; ============================================================

.model small
.stack 100h

.data
msg1 DB 'Please input a Dec number: $'
msg2 DB 0DH,0AH,'The Hex number: $'

.code
START:
    MOV AX,@DATA
    MOV DS,AX                 ; 初始化数据段

    ; ---------- 输出输入提示 ----------
    LEA DX,msg1
    MOV AH,09H
    INT 21H

    ; ---------- 读取十进制字符 ----------
    MOV BX,0                  ; BX 保存转换结果，初始为 0

READ_LOOP:
    MOV AH,01H
    INT 21H                   ; 读取一个字符，AL = 输入字符

    CMP AL,0DH                ; 是否按下回车？
    JE READ_DONE              ; 是则结束输入

    SUB AL,'0'                ; 将字符转换为 0~9 的数值
    MOV AH,0
    PUSH AX                   ; 暂存当前数字

    ; result = result * 10 + digit
    MOV AX,BX
    MOV CX,10
    MUL CX                    ; DX:AX = BX * 10
    MOV BX,AX

    POP AX                    ; 取回当前数字
    ADD BX,AX                 ; 累加当前十进制位

    JMP READ_LOOP

READ_DONE:
    ; ---------- 输出结果提示 ----------
    LEA DX,msg2
    MOV AH,09H
    INT 21H

    ; ---------- 输出十六进制结果 ----------
    CALL PRINT_HEX

    ; ---------- 返回 DOS ----------
    MOV AX,4C00H
    INT 21H

; ============================================================
; 子程序：将 BX 中的 0~255 转换为十六进制并输出
; ============================================================

PRINT_HEX PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV AX,BX
    MOV CL,16
    DIV CL                    ; AL = 高位，AH = 低位

    MOV BH,AL                 ; 保存高位
    MOV BL,AH                 ; 保存低位

    ; ---------- 输出高位 ----------
    CMP BH,0
    JE OUTPUT_LOW

    MOV DL,BH
    CALL HEX_TO_CHAR

OUTPUT_LOW:
    ; ---------- 输出低位 ----------
    MOV DL,BL
    CALL HEX_TO_CHAR

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_HEX ENDP

; ============================================================
; 子程序：将 DL 中的 0~15 转换为十六进制字符并输出
; ============================================================

HEX_TO_CHAR PROC
    CMP DL,9
    JBE HEX_DIGIT             ; 0~9

    ADD DL,7                  ; 10~15 转换为 A~F

HEX_DIGIT:
    ADD DL,'0'                ; 转换为 ASCII 字符
    MOV AH,02H
    INT 21H
    RET
HEX_TO_CHAR ENDP

END START
