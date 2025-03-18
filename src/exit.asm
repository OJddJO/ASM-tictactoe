section .text
    global exit

exit:
    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall