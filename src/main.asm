section .bss
    board resb 9
    boardSize equ $ - board
    inputBuffer resb 10
    inputBufferSize equ $ - inputBuffer

section .data
    extern br ; (from io.asm)
    extern singleBr ; (from io.asm)
    verticalBar db '|', 0
    empty db ' ', 0
    x db 'X', 0
    o db 'O', 0

    playerPrompt db 'Player ', 0
    playerPromptSize equ $ - playerPrompt
    movePrompt db ', enter your move (ex: A1): ', 0
    movePromptSize equ $ - movePrompt
    invalidMove db 'Invalid move!', br, 0
    invalidMoveSize equ $ - invalidMove
    winPrompt db ' wins!', 0
    winPromptSize equ $ - winPrompt
    tie db 'Its a tie!', 0
    tieSize equ $ - tie

    playerTurn db 'X', 0
    turn db 0

section .text
    extern exit
    extern print
    extern input
    extern strcmp
    global _start

_start:
    call initBoard

    .gameloop:
        mov rsi, board
        call printBoard ; print the board
        call promptUserTurn ; ask the user to input a move
        mov rsi, inputBuffer
        call getCoord

        mov rsi, board
        mov rdx, rax
        call validMove

        cmp rax, 1
        je .validMove

    .validMove:
        call placeCross

        mov rax, turn
        inc byte [rax]
        cmp byte [rax], 9
        jl .gameloop

    call exit

initBoard:
    ; initialize the baord
    mov rdi, board ; rdi = int board[9]
    mov rcx, 9

    .initBoardLoop:
        mov al, [empty]
        mov byte [rdi], al ; board[i] = '0'
        inc rdi
        loop .initBoardLoop

    ret

printVerticalBar:
    push rsi
    mov rsi, verticalBar
    mov rdx, 1
    call print
    pop rsi
    ret

printBoardRow:
    ; Args:
    ;   rsi: pointer to the row to print
    mov rcx, 3

    .printLoop:
        push rcx
        call printVerticalBar
        mov rdx, 1
        call print
        call printVerticalBar
        inc rsi
        pop rcx
        loop .printLoop

    ret

printBoard:
    ; Args:
    ;   rsi: pointer to the board
    mov rcx, 3

    .printLoop:
        push rcx
        call printBoardRow
        push rsi
        mov rsi, singleBr
        mov rdx, 1
        call print
        pop rsi
        pop rcx
        loop .printLoop

    ret

promptUserTurn:
    ; Returns:
    ;   inputBuffer: the input of the user ex: a3
    call .printPrompt

    mov rsi, inputBuffer
    mov rdx, inputBufferSize
    call input

    ; evaluates the input from the user
    ; input must be like a1
    mov al, byte [rsi]
    cmp al, 'A' ; check if the first char is [A-C]
    jl .invalidInput
    cmp al, 'C'
    jg .invalidInput

    inc rsi
    mov al, byte [rsi]
    cmp al, '1'
    jl .invalidInput
    cmp al, '3'
    jg .invalidInput

    ret

    .printPrompt:
        mov rsi, playerPrompt
        mov rdx, playerPromptSize
        call print
        mov rsi, playerTurn
        mov rdx, 1
        call print
        mov rsi, movePrompt
        mov rdx, movePromptSize
        call print
        ret

    .invalidInput:
        ; user input is invalid -> redo
        mov rsi, invalidMove
        mov rdx, invalidMoveSize
        call print
        jmp promptUserTurn

getCoord:
    ; Args:
    ;   rsi: pointer to the inputBuffer
    ; Returns:
    ;   rax: the index of the board
    mov rax, 0
    mov al, byte [rsi]
    sub al, 'A'
    mov bl, byte [rsi + 1]
    sub bl, '1'
    imul rax, 3
    add al, bl
    ret

placeCross:
    ; Args:
    ;   rsi: pointer to the board
    ;   rdx: the index of the board
    mov al, [x]
    mov byte [rsi + rdx], al
    ret

placeCircle:
    ; Args:
    ;   rsi: pointer to the board
    ;   rdx: the index of the board
    mov al, [o]
    mov byte [rsi + rdx], al
    ret

validMove:
    ; Args:
    ;   rsi: pointer to the board
    ;   rdx: the index of the board
    ; Returns:
    ;   rax: 1 if it is valid, 0 else
    mov rax, 1
    mov bl, byte [rsi + rdx]
    cmp bl, [empty]
    je .validMoveRet
    mov rax, 0

    .validMoveRet:
        ret