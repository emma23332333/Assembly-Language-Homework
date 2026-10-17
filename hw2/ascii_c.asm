main:
    push   rbp                        ; 函数开头：保存旧的栈基址
    mov    rbp, rsp                   ; rbp 指向当前栈顶，建立栈帧
    sub    rsp, 16                    ; 栈上腾 16 字节放局部变量
                                      ; 变量位置：[rbp-1]=c, [rbp-8]=row, [rbp-12]=col
    mov    BYTE PTR [rbp-1], 97       ; c = 97（97 就是字符 'a' 的 ASCII）
    mov    DWORD PTR [rbp-8], 0      ; row = 0
    jmp    .L2                        ; 直接跳到外层循环的判断处

.L5:                                  ; 外层循环体（每打印一行）
    mov    DWORD PTR [rbp-12], 0      ; col = 0
    jmp    .L3                        ; 跳到内层循环的判断处

.L4:                                  ; 内层循环体（每打印一个字符）
    movsx  eax, BYTE PTR [rbp-1]      ; 取 c，带符号扩展到 32 位
    mov    edi, eax                   ; putchar 的第 1 个参数 = c（64位调用约定）
    call   putchar                    ; putchar(c)
    mov    edi, 32                    ; 空格 ' ' 的 ASCII
    call   putchar                    ; putchar(' ')
    movzx  eax, BYTE PTR [rbp-1]      ; 再取 c（零扩展）
    add    eax, 1                     ; c + 1
    mov    BYTE PTR [rbp-1], al       ; 写回 c（即 c++）
    add    DWORD PTR [rbp-12], 1      ; col++

.L3:                                  ; 内层循环判断
    cmp    DWORD PTR [rbp-12], 12    ; col 与 12 比较
    jle    .L4                        ; 若 col ≤ 12（即 col < 13），跳回循环体
    mov    edi, 10                    ; 换行 '\n'
    call   putchar                    ; putchar('\n')，一行结束
    add    DWORD PTR [rbp-8], 1       ; row++

.L2:                                  ; 外层循环判断
    cmp    DWORD PTR [rbp-8], 1      ; row 与 1 比较
    jle    .L5                        ; 若 row ≤ 1（即 row < 2），跳回循环体
    mov    eax, 0                     ; return 0
    leave                             ; 函数尾声：撤销开头的栈帧
    ret                               ; 返回调用者
