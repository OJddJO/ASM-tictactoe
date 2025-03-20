section .bss
    board resb 9
    boardSize equ $ - board

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
    invalidMove db 'Invalid move!', 0
    invalidMoveSize equ $ - invalidMove
    win db ' wins!', 0
    winSize equ $ - win
    tie db 'Its a tie!', 0
    tieSize equ $ - tie

    turn equ 49

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


