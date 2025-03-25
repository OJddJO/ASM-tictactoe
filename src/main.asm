; import exit.asm
extern exit
; import io.asm
extern br
extern singleBr
extern print
extern _print
extern input
extern fflush
extern clear

section .bss
    temp resb 64
    board resb 9
    boardSize equ $ - board
    inputBuffer resb 10
    inputBufferSize equ $ - inputBuffer

section .data
    verticalBar db '|', 0
    empty db ' ', 0
    x db 'X', 0
    o db 'O', 0

    playerPrompt db 'Player ', 0
    movePrompt db ', enter your move (ex: A1): ', 0
    invalidMove db 'Invalid move!', br, 0
    winPrompt db ' wins!', br, 0
    tie db 'Its a tie!', 0
    boardHeader db '  1  2  3', br, 0
    letter db 'A', 0

    playerTurn db 'X', 0
    turn db 0

section .text
    global _start

initBoard:
    ; initialize the baord
    mov rdi, board ; rdi = int board[9]
    mov rcx, 9
    mov al, [empty]
    rep stosb
    ret

printVerticalBar:
    ; Prints a vertical bar
    push rsi
    mov rsi, verticalBar
    call print
    pop rsi
    ret

printBoard:
    ; Prints the board
    mov rsi, boardHeader
    call print

    mov rsi, board
    mov rcx, 3

    .printLoop:
        push rcx

        push rsi
        mov rsi, letter
        call print
        inc byte [rsi]
        pop rsi

        call .printBoardRow

        push rsi
        mov rsi, singleBr
        call print
        pop rsi

        pop rcx
        loop .printLoop

    mov byte [letter] , 'A'
    ret

    .printBoardRow:
        ; Prints a row of the board
        ; Args:
        ;   rsi: pointer to the row to print
        mov rcx, 3

        .printRowLoop:
            push rcx
            call printVerticalBar
            mov rdx, 1
            call _print
            call printVerticalBar
            inc rsi
            pop rcx
            loop .printRowLoop

        ret

promptUserTurn:
    ; Ask the user to enter coordinates
    ; Returns:
    ;   inputBuffer: the input of the user ex: a3
    mov rsi, playerPrompt
    call print
    mov rsi, playerTurn
    call print
    mov rsi, movePrompt
    call print

    mov rsi, inputBuffer
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

    .invalidInput:
        ; user input is invalid -> redo
        mov rsi, invalidMove
        call print
        jmp promptUserTurn

getCoord:
    ; Get the index on the board based on the input
    ; Returns:
    ;   rax: the index of the board
    movzx rax, byte [inputBuffer]
    sub al, 'A'
    imul rax, 3
    movzx rbx, byte [inputBuffer + 1]
    sub bl, '1'
    add rax, rbx
    ret

placePlayer:
    ; Place the symbol corresponding to the current player
    ; Args:
    ;   rdx: the index of the board
    mov rsi, board
    mov al, [playerTurn]
    mov byte [rsi + rdx], al
    ret

isValidMove:
    ; Checks if the square is empty
    ; Args:
    ;   rdx: the index of the board
    ; Returns:
    ;   rax: 1 if it is valid, 0 else
    mov rsi, board
    mov rax, 1
    mov bl, byte [rsi + rdx]
    cmp bl, [empty]
    je .validMoveRet
        mov rax, 0
    .validMoveRet:
        ret

changeCurrentTurn:
    ; Change the player turn
    mov al, [playerTurn]
    cmp al, 'X'
    je .isCross
        mov byte [playerTurn], 'X' ; if the current player isn't cross
        ret

    .isCross: ; if the current player is cross
        mov byte [playerTurn], 'O'
        ret

checkWinner:
    ; Check if there is a winner
    xor rax, rax
    mov r9b, 'X'

    .checkSymbol:
        mov r8b, r9b
        mov rdi, 0 ; check rows
        call checkLines
        cmp rax, 1
        je printWin
        mov rdi, 1 ; check cols
        call checkLines
        cmp rax, 1
        je printWin
        call checkDiags
        cmp rax, 1
        je printWin

        cmp r9b, 'X'
        je .checkO

    ret

    .checkO:
        mov r9b, 'O'
        jmp .checkSymbol

checkLines:
    ; Check if one of the lines is filled with a single symbol
    ; Args:
    ;   rdi: 0 if the lines to check are rows, 1 if cols
    ;   r8b: the symbol to check
    ; Returns:
    ;   rax: 1 if one of the line is filled with a single symbol, 0 else
    mov rcx, 3
    mov rsi, 0
    mov r9, 1
    sub r9, rdi ; r9 = 0 if cols else r9 = 1
    .checkLoop:
        push rcx
        call checkLine
        cmp rax, 1
        pop rcx
        je .lineFilled
        inc rsi ; rsi + 1
        add rsi, r9
        add rsi, r9
        loop .checkLoop
    mov rax, 0
    ret

    .lineFilled:
        mov rax, 1
        ret

checkLine:
    ; Check if the line is filled with a single symbol
    ; Args:
    ;   rsi: index of the line
    ;   rdi: 0 if the lines to check are rows, 1 if cols
    ;   r8b: the symbol to check
    ; Returns:
    ;   rax: 1 if the line is filled with a single symbol, 0 else
    mov rdx, board
    mov rcx, 3
    .checkLoop:
        cmp byte [rdx + rsi], r8b
        jne .notSame

        inc rdx ; if it is the same char as the previous one
        add rdx, rdi
        add rdx, rdi
        loop .checkLoop

    mov rax, 1 
    ret

    .notSame:
        mov rax, 0
        ret

checkDiags:
    ; Check if one of the two diagonals is filled with a single symbol
    ; Args:
    ;   r8b: the symbol to check
    ; Returns:
    ;   rax: 1 if one of the diagonal is filled, else 0
    mov sil, r8b
    mov rdi, 1
    call _print

    mov rdx, board
    mov rcx, 3
    mov rsi, 0
    .checkFirstDiagLoop:
        cmp byte [rdx + rsi], r8b
        jne .notFirstDiag
        add rdx, 3
        inc rsi
        loop .checkFirstDiagLoop
    mov rax, 1
    ret

    .notFirstDiag:
        mov rdx, board
        mov rcx, 3
        mov rsi, 2
        .checkSecondDiagLoop:
            cmp byte [rdx + rsi], r8b
            jne .noWinner
            add rdx, 3
            dec rsi
            loop .checkSecondDiagLoop
        mov rax, 1
        ret

    .noWinner:
        mov rax, 0
        ret

printWin:
    ; Print the winner and exit the program
    ; Args:
    ;   r8b: the symbol of the winner
    mov rsi, playerPrompt
    call print
    mov rsi, temp
    mov byte [rsi], r8b
    mov rdx, 1
    call _print
    mov rsi, winPrompt
    call print
    call exit

_start:
    ; Entry Point
    call initBoard

    call clear ; clear the terminal
    .gameloop:
        call printBoard ; print the board
        call checkWinner

    .playerInput:
        call promptUserTurn ; ask the user to input a move
        call getCoord

        mov rdx, rax
        call isValidMove
        cmp rax, 1
        je .validMove ; if it is valid continue
        mov rsi, invalidMove ; else
        call print
        jmp .playerInput

    .validMove:
        call placePlayer
        call changeCurrentTurn
        call clear

        inc byte [turn]
        cmp byte [turn], 9
        jl .gameloop

    mov rsi, tie
    call print
    call exit