section .text
    global print
    global input

print:
    ; Args:
    ;   rsi: pointer to the string to print
    ;   rdx: length of the string to print
    mov rax, 1
    mov rdi, 1
    syscall
    ret

input:
    ; Args:
    ;   rsi: pointer to the buffer to store the input
    ;   rdx: length of the buffer
    mov rax, 0
    mov rdi, 0
    syscall
    ret