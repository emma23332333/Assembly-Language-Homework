; ============================================================
; exchange.asm —— 十六进制转十进制
; ============================================================

.model small
.stack 100h

.data
msg1 DB 'Please input a Hex number: $'
msg2 DB 0DH,0AH,'The Dec number: $'

.code
START:
    MOV AX,@DATA
    MOV DS,AX                 ; 初始化数据段

    ; ---------- 输出输入提示 ----------
    LEA DX,msg1
    MOV AH,09H
    INT 21H

    ; ---------- 读取十六进制字符 ----------
    MOV BX,0                  ; BX 保存转换结果，初始为 0

READ_LOOP:
    MOV AH,01H
    INT 21H                   ; 读取一个字符，AL = 输入字符

    CMP AL,0DH                ; 是否按下回车？
    JE READ_DONE              ; 是则结束输入

    CALL CHAR_TO_DIGIT        ; 将字符转换为 0~15 的数值

    ; result = result * 16 + digit
    PUSH AX                   ; 暂存当前数字
    MOV AX,BX
    MOV CX,16
    MUL CX                    ; DX:AX = BX * 16
    MOV BX,AX
    POP AX                    ; 取回当前数字

    MOV AH,0
    ADD BX,AX                 ; 累加当前十六进制位

    JMP READ_LOOP

READ_DONE:
    ; ---------- 输出结果提示 ----------
    LEA DX,msg2
    MOV AH,09H
    INT 21H

    ; ---------- 输出十进制结果 ----------
    CALL PRINT_DEC

    ; ---------- 返回 DOS ----------
    MOV AX,4C00H
    INT 21H

; ============================================================
; 子程序：将 AL 中的十六进制字符转换为数值
; ============================================================

CHAR_TO_DIGIT PROC
    CMP AL,'9'
    JBE DIGIT_NUM             ; '0'~'9'

    CMP AL,'a'
    JAE DIGIT_LOWER           ; 'a'~'f'

    CMP AL,'A'
    JAE DIGIT_UPPER           ; 'A'~'F'

DIGIT_NUM:
    SUB AL,'0'
    RET

DIGIT_LOWER:
    SUB AL,'a'-10
    RET

DIGIT_UPPER:
    SUB AL,'A'-10
    RET
CHAR_TO_DIGIT ENDP

; ============================================================
; 子程序：将 BX 中的 0~255 转换为十进制并输出
; ============================================================


PRINT_DEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV AX,BX
    MOV CL,100
    DIV CL                    ; AL = 百位，AH = 余数
    MOV BL,AL                 ; 保存百位

    MOV AL,AH
    MOV AH,0
    MOV CL,10
    DIV CL                    ; AL = 十位，AH = 个位

    MOV BH,AL                 ; 保存十位
    MOV CH,AH                 ; 保存个位

    ; 输出百位（如果百位不为 0）
    CMP BL,0
    JE CHECK_TENS

    MOV DL,BL
    ADD DL,'0'
    MOV AH,02H
    INT 21H

CHECK_TENS:
    ; 如果有百位，十位即使为 0 也必须输出
    CMP BL,0
    JNE OUTPUT_TENS

    ; 没有百位且十位为 0，则省略十位
    CMP BH,0
    JE OUTPUT_ONES

OUTPUT_TENS:
    MOV DL,BH
    ADD DL,'0'
    MOV AH,02H
    INT 21H

OUTPUT_ONES:
    MOV DL,CH
    ADD DL,'0'
    MOV AH,02H
    INT 21H

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DEC ENDP


END START