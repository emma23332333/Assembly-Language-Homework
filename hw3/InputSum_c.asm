.LC0:
        .string "Please input a number (1-100): " ; 输入提示
.LC1:
        .string "%d"                            ; scanf 使用的整数格式
.LC2:
        .string "The sum is: %d\n"              ; 输出

; ---------- main 函数 ----------
"main":
        push    rbp
        mov     rbp, rsp    ; 保存原来的栈帧指针，并建立当前函数的栈帧
        sub     rsp, 16     ; 在栈上分配 16 字节的局部变量空间
        mov     DWORD PTR [rbp-8], 0    ; sum = 0
        
        mov     edi, OFFSET FLAT:.LC0       ; 将输入提示字符串的地址放入 EDI，作为 printf 的参数
        mov     eax, 0        ; 清零 EAX，表示没有使用向量寄存器传递浮点参数
        call    "printf"        ; 调用 printf，输出输入提示
        
        lea     rax, [rbp-12]       ; 取局部变量 n 的地址，存入 RAX
        mov     rsi, rax        ; 将 n 的地址放入 RSI，作为 scanf 的第二个参数
        mov     edi, OFFSET FLAT:.LC1        ; 将格式字符串 "%d" 的地址放入 EDI，作为 scanf 的第一个参数
        
        mov     eax, 0        ; 清零 EAX
        call    __isoc23_scanf        ; 调用 scanf，读取用户输入的整数并保存到 n 中
        mov     DWORD PTR [rbp-4], 1        ; i = 1，初始化循环变量
        jmp     .L2        ; 先跳到循环条件判断处，再决定是否执行循环体


; ---------- 循环体：sum += i；i++ ----------
.L3:
        mov     eax, DWORD PTR [rbp-4]        ; 将 i 的值读取到 EAX
        add     DWORD PTR [rbp-8], eax
        add     DWORD PTR [rbp-4], 1
; ---------- 循环条件判断 ----------
.L2:
        mov     eax, DWORD PTR [rbp-12]        ; 将用户输入的 n 读取到 EAX
        cmp     DWORD PTR [rbp-4], eax        ; 判断 i <= n
        jle     .L3
        ; 如果 i <= n，则跳回 .L3，继续执行循环体
        ; 如果 i > n，则不跳转，结束循环

; ---------- 输出求和结果 ----------
        mov     eax, DWORD PTR [rbp-8]        ; 将 sum 的值读取到 EAX
        mov     esi, eax        ; 将 sum 作为 printf 的第二个参数
        mov     edi, OFFSET FLAT:.LC2        ; 将输出格式字符串 "The sum is: %d\n" 的地址放入 EDI
        mov     eax, 0
        call    "printf"

        mov     eax, 0        ; 设置返回值为 0，相当于 return 0
        leave
        ret
