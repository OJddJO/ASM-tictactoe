section .data
    br equ 0xa ; do not use this to print a br use singleBr instead
    singleBr db 0xa, 0
    global br
    global singleBr
    clearCode db 0x1b, '[2J', 0x1b, '[H', 0 ; "\033[2J\033[H"
    clearCodeSize equ $ - clearCode

section .text
    global print
    global input
    global clearTerm

print:
    ; Print a string
    ; Args:
    ;   rsi: pointer to the string to print
    ;   rdx: length of the string to print
    mov rax, 1
    mov rdi, 1
    syscall
    ret

input:
    ; Wait for a user input
    ; Args:
    ;   rsi: pointer to the buffer to store the input
    ;   rdx: length of the buffer
    mov rax, 0
    mov rdi, 0
    syscall

    mov byte [rsi + rax], 0 ; Adding null-terminator
    ret

clearTerm:
    ; Clear the terminal
    push rsi
    push rdx
    mov rsi, clearCode
    mov rdx, clearCodeSize
    call print
    pop rdx
    pop rsi
    ret