section .data
    msg_in db "Input: ",0
    msg_res db "Result: ",0
    newline db 10,0
    buffer db 20 dup(0)

section .text
    global _start

_start:
    mov ax, 6

    push ax
    mov eax, msg_in
    call print_string
    pop ax
    movzx eax, ax
    mov esi, buffer
    call int_to_str
    call print_string
    mov eax, newline
    call print_string

    mov ax, 6
    call factorial_iter

    push dx
    push ax
    mov eax, msg_res
    call print_string
    pop ax
    pop dx

    movzx eax, ax
    mov esi, buffer
    call int_to_str
    call print_string
    mov eax, newline
    call print_string

    mov eax,1
    xor ebx,ebx
    int 0x80

factorial_iter:
    mov cx, ax
    mov ax, 1
    mov dx, 0
.loop:
    cmp cx, 1
    jbe .done
    mul cx
    dec cx
    jnz .loop
.done:
    ret

int_to_str:
    mov ecx,10
    mov edi,esi
    add edi,19
    mov byte [edi],0
.convert:
    xor edx,edx
    div ecx
    add dl,'0'
    dec edi
    mov [edi],dl
    test eax,eax
    jnz .convert
    mov esi,edi
    ret

print_string:
    cmp eax,0
    jne .use_eax
    mov eax,esi
.use_eax:
    push eax
    call strlen
    pop ebx
    mov eax,4
    mov ecx,ebx
    mov ebx,1
    int 0x80
    ret

strlen:
    mov edi,eax
    xor ecx,ecx
.loop:
    cmp byte [edi],0
    je .done
    inc edi
    inc ecx
    jmp .loop
.done:
    mov edx,ecx
    ret
