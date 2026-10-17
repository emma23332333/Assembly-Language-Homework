; ascii2.asm  —— 用条件跳转实现
.model small
.code
START:
    MOV  AX,@DATA
    MOV  DS,AX

    MOV  BL,'a'
    MOV  CX,2          ; 外层：2 行

OUTER:
    PUSH CX
    MOV  CX,13        ; 内层：13 个字符

INNER:
    MOV  DL,BL
    MOV  AH,2
    INT  21H
    MOV  DL,' '
    MOV  AH,2
    INT  21H
    INC  BL

    DEC  CX
    JNZ  INNER        ; 条件跳转：CX≠0 就继续内层循环

    MOV  DL,0DH
    MOV  AH,2
    INT  21H
    MOV  DL,0AH
    MOV  AH,2
    INT  21H

    POP  CX
    DEC  CX
    JNZ  OUTER        ; 条件跳转：CX≠0 就继续外层

    MOV  AX,4C00H
    INT  21H
END START
