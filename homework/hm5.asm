section .data
    width   db 32
    height  db 16
    star    db '*'
    space   db '*'
    corner  db '*'
    horiz   db '*'
    vert    db '*'
    newline db 10

section .bss
    buffer resb 8192
    pos    resq 1

section .text
    global _start

_start:
    movzx rsi, byte [width]
    movzx rdi, byte [height]
    xor rbx, rbx
    mov [pos], rbx

    call draw_top_bottom

    mov rcx, rdi
    sub rcx, 2
    xor rdx, rdx

.middle_loop:
    cmp rdx, rcx
    je .draw_bottom
    call draw_middle
    inc rdx
    jmp .middle_loop

.draw_bottom:
    call draw_top_bottom

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, [pos]
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

draw_top_bottom:
    mov rax, [pos]
    mov byte [buffer + rax], '*'
    inc rax
    mov rcx, rsi
    sub rcx, 2
.draw_hloop:
    mov byte [buffer + rax], '*'
    inc rax
    dec rcx
    jnz .draw_hloop
    mov byte [buffer + rax], '*'
    inc rax
    mov byte [buffer + rax], 10
    inc rax
    mov [pos], rax
    ret

draw_middle:
    mov rax, [pos]
    mov byte [buffer + rax], '*'
    inc rax

    movzx rcx, byte [width]
    sub rcx, 2
    mov r8, rcx
    mov r9, rdx
    xor r10, r10

.inner_loop:
    cmp r10, r8
    jge .end_inner

    mov r11, r9
    cmp r10, r11
    je .print_star

    mov r12, r8
    dec r12
    sub r12, r9
    cmp r10, r12
    je .print_star

    mov byte [buffer + rax], ' '
    inc rax
    inc r10
    jmp .inner_loop

.print_star:
    mov byte [buffer + rax], '*'
    inc rax
    inc r10
    jmp .inner_loop

.end_inner:
    mov byte [buffer + rax], '*'
    inc rax
    mov byte [buffer + rax], 10
    inc rax
    mov [pos], rax
    ret

