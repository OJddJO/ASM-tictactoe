section .bss
    board resb 9
    boardSize equ $ - board

section .data
    br equ 0xa
    verticalBar db '│', 0
    horizontalBar db '─', 0
    cross db '┼', 0
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

section .text
    extern exit
    extern print
    extern input
    extern strcmp
    global _start

_start:
    call initBoard
    call printBoard

    call exit

initBoard:
    ; initialize the baord
    mov rdi, board ; rdi = int board[9]
    mov rcx, 9

    .initBoardLoop:
        mov byte [rdi], 0 ; board[i] = 0
        inc rdi
        loop .initBoardLoop

    .initBoardEnd:
        ret

printBoard:
    mov rdi, board
    mov rcx, 3
    .printBoardRow:
        mov rsi, rdi
        mov rdx, 3
        call printRow
        add rdi, 3
        loop .printBoardRow
    ret

printRow:
    mov rsi, verticalBar
    call print
    mov rsi, rdi
    mov rcx, 3
    .printRowLoop:
        mov al, byte [rsi]
        call printChar
        inc rsi
        loop .printRowLoop
    mov rsi, verticalBar
    call print
    mov rsi, br
    call print
    ret

printChar:
    mov rax, 1
    mov rdi, 1
    syscall
    ret