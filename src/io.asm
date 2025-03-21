section .data
    br equ 0xa ; do not use this to print a br use singleBr instead
    singleBr db 0xa, 0
    global br
    global singleBr

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

    mov rdi, rsi
    mov rcx, rdx ; counter for the clear buffer loop
    .clearBuffer:
        mov byte [rdi], al
        inc rdi
        loop .clearBuffer

    mov rax, 0
    mov rdi, 0
    syscall

    mov byte [rsi + rax], 0 ; Adding null-terminator
    ret