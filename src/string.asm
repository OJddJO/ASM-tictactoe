section .text
    global strcmp

strcmp:
    ; Args:
    ;   rsi: pointer to the first string
    ;   rdi: pointer to the second string
    ; Returns:
    ;   rax: 0 if the strings are equal, 1 if the first string is greater, -1 if the second string is greater
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
        mov rax, 1
        ret
    .strcmpEq:
        xor rax, rax
        ret
