section .data
    prime_msg db " - prime",10,0
    notprime_msg db " - not prime",10,0
    buffer db 10 dup(0)

section .text
    global _start

_start:
    mov ax, 29
    movzx eax, ax
    mov esi, buffer
    push eax
    call int_to_str
    call print_string
    pop eax
    push eax
    call is_prime
    cmp al, 1
    je .prime
    mov eax, notprime_msg
    call print_string
    jmp .exit
.prime:
    mov eax, prime_msg
    call print_string
.exit:
    mov eax,1
    xor ebx,ebx
    int 0x80

int_to_str:
    mov ecx,10
    mov edi,esi
    add edi,9
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

is_prime:
    cmp eax,2
    jl .not_prime
    je .prime
    mov ebx,2
.loop_check:
    mov edx,0
    div ebx
    cmp edx,0
    je .not_prime
    inc ebx
    mov eax,[esp]
    cmp ebx,eax
    jl .loop_check
.prime:
    mov al,1
    ret
.not_prime:
    mov al,0
    ret
