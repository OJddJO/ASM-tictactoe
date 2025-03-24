section .bss
    temp resb 16

section .data
    br equ 0xa ; do not use this to print a br use singleBr instead
    singleBr db 0xa, 0
    global br
    global singleBr

    clearCode db 0x1b, '[2J', 0x1b, '[H', 0 ; "\033[2J\033[H"
    clearCodeSize equ $ - clearCode

section .text
    global print
    global _print
    global input
    global flushStdin
    global clear

print:
    ; Print a string without specifying the length
    ; Args:
    ;   rsi: pointer to the string to print (must be null-terminated)
    mov rdi, rsi
    xor rax, rax
    mov rcx, -1
    repne scasb ; scan until the byte is equal to rax (rax=0)
    sub rdi, rsi
    mov rdx, rdi

_print:
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

flushStdin:
    ; Flush the stdin
    push rsi
    push rdi
    push rdx
    mov rax, 0
    mov rsi, 0
    lea rdi, [temp]
    mov rdx, 16
    .loop:
        syscall
        test rax, rax
        jle .done
        jmp .loop
    
    .done:
        mov qword [rdi], 0
        pop rdx
        pop rdi
        pop rsi
        ret

clear:
    ; Clear the terminal
    push rsi
    push rdx
    push rdi
    mov rsi, clearCode
    mov rdx, clearCodeSize
    call _print
    pop rdi
    pop rdx
    pop rsi
    ret