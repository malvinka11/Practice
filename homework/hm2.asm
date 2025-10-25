section .data
    buffer db 12 dup(0)

section .text
    global _start

_start:
    mov eax, 1234512345
    mov esi, buffer
    call int2string

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 12
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

int2string:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov ebx, esi
    mov ecx, 0
    mov edx, 0
    cmp eax, 0
    jge .convert
    neg eax
    mov byte [esi], '-'
    inc esi

.convert:
    mov edi, esi
.loop:
    mov edx, 0
    mov ebx, 10
    div ebx
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz .loop

.write_digits:
    pop dx
    mov [esi], dl
    inc esi
    loop .write_digits

    mov byte [esi], 0

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
