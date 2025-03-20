section .text
    global strcmp

strcmp:
    ; Args:
    ;   rsi: pointer to the first string
    ;   rdi: pointer to the second string
    ; Returns:
    ;   rax: 0 if the strings are the same
    .strcmpLoop:
        mov al, byte [rsi]
        mov bl, byte [rdi]
        cmp al, bl
        jne .strcmpNeq
        cmp al, 0
        je .strcmpEq
        inc rsi
        inc rdi
        jmp .strcmpLoop

    .strcmpNeq:
        xor rax, rax
        ret

    .strcmpEq:
        mov rax, 1
        ret
