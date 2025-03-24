section .bss
    temp resb 16

section .data
    br equ 0xa
    singleBr db 0xa, 0
    singleBrSize equ $ - singleBr
    global br
    global singleBr
    global singleBrSize

    clearCode db 0x1b, '[2J', 0x1b, '[H', 0 ; "\033[2J\033[H"
    clearCodeSize equ $ - clearCode

section .text
    global print
    global _print
    global input
    global fflush
    global clear

print:
    ; Print a string without specifying the length
    ; Args:
    ;   rsi: pointer to the string to print (must be null-terminated)
    ; Used Registers:
    ;   rax, rcx, rdx, rsi, rdi
    mov rdi, rsi
    xor rax, rax
    mov rcx, -1
    repne scasb ; scan until the byte is equal to rax (rax=0)
    sub rdi, rsi
    mov rdx, rdi

    mov rax, 1
    mov rdi, 1
    syscall

    ret

_print:
    ; Print a string
    ; Args:
    ;   rsi: pointer to the string to print
    ;   rdx: length of the string to print
    ; Used Registers:
    ;   rax, rdx, rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    ret

input:
    ; Wait for a user input
    ; Args:
    ;   rsi: pointer to the buffer to store the input
    ; Used Registers:
    ;   rax, rsi, rdi
    mov rax, 0
    mov rdi, 0
    syscall

    mov byte [rsi + rax], 0 ; Adding null-terminator
    ret

fflush:
    ; Flush the a file descriptor
    ; Args:
    ;   rsi: the file descriptor to flush
    ; Used Registers:
    ;   rax, rdx, rsi, rdi
    mov rax, 0
    lea rdi, [temp]
    mov rdx, 16
    .loop:
        syscall
        test rax, rax
        jle .done
        jmp .loop
    
    .done ret

clear:
    ; Clear the terminal
    ; Used Registers:
    ;   rax, rdx, rdi, rsi
    mov rsi, clearCode
    mov rdx, clearCodeSize

    mov rax, 1
    mov rdi, 1
    syscall

    ret