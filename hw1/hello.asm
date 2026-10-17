.model small

.data
Hello DB 'Hello world!',0dh,0ah,'$'     ; 字符串：Hello world! + 回车 + 换行 + '$'

.code
START:
    MOV  AX,@DATA          ; 数据段段地址 -> AX
    MOV  DS,AX             ; AX -> DS（DS 不能直接赋值，必须经 AX）

    LEA  DX,Hello           ; 取 Hello 的偏移地址 -> DX
    MOV  AH,9              ; DOS 功能号 9：打印以 '$' 结尾的字符串
    INT  21H               ; 调用 DOS 中断，输出字符串

    MOV  AX,4C00H          ; DOS 功能号 4C00：程序正常结束
    INT  21H               ; 退出，回到 DOS

    END START