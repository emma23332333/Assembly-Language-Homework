.model small
.code
START:
    MOV  AX,@DATA
    MOV  DS,AX

    MOV  BL,'a'        ; BL = 当前要打印的字符，从 'a' 开始
    MOV  CX,2          ; 外层循环：共 2 行

OUTER:
    PUSH CX            ; 保存外层 CX（行数），因为内层要重写 CX
    MOV  CX,13         ; 内层循环：每行打印 13 个字符

INNER:
    MOV  DL,BL
    MOV  AH,2
    INT  21H           ; 打印当前字符

    MOV  DL,' '
    MOV  AH,2
    INT  21H           ; 打印一个空格

    INC  BL            ; 字符推进到下一个
    LOOP INNER         ; 内层：CX 减 1，非 0 就回到 INNER

    MOV  DL,0DH        ; DL = 0DH（回车符 CR）
    MOV  AH,2
    INT  21H
    MOV  DL,0AH        ; DL = 0AH（换行符 LF）
    MOV  AH,2
    INT  21H

    POP  CX            ;  恢复外层 CX（行数）
    LOOP OUTER         ; 外层：CX 减 1，非 0 就回到 OUTER

    MOV  AX,4C00H
    INT  21H
END START
