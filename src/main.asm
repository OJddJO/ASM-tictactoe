section .bss
    board resb 9
    boardSize equ $ - board
    inputBuffer resb 10
    inputBufferSize equ $ - inputBuffer

section .data
    br equ 0xa ; do not use this to print a br use singleBr instead
    singleBr db 0xa, 0
    verticalBar db '|', 0
    empty db ' ', 0
    x db 'X', 0
    o db 'O', 0

    playerPrompt db 'Player ', 0
    playerPromptSize equ $ - playerPrompt
    movePrompt db ', enter your move: ', 0
    movePromptSize equ $ - movePrompt
    invalidMove db 'Invalid move!', br, 0
    invalidMoveSize equ $ - invalidMove
    winPrompt db ' wins!', 0
    winPromptSize equ $ - winPrompt
    tie db 'Its a tie!', 0
    tieSize equ $ - tie

    playerTurn db '1', 0
    turn equ 0

section .text
    extern exit
    extern print
    extern input
    extern strcmp
    global _start

_start:
    call initBoard
    mov rsi, board
    call printBoard
    call promptUserTurn
    mov rsi, inputBuffer
    mov rdx, inputBufferSize
    call print

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

    .evalInput:
        ; evaluates the input from the user
        ; input must be like a1
        mov rsi, inputBuffer
        mov al, byte [rsi]
        cmp al, 'a' ; check if the first char is [a-c]
        jl .invalidInput
        cmp al, 'c'
        jg .invalidInput

        inc rsi
        mov al, byte [rsi]
        cmp al, '1'
        jl .invalidInput
        cmp al, '2'
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
        ; user input is invalid redo
        mov rsi, invalidMove
        mov rdx, invalidMoveSize
        call print
        jmp promptUserTurn