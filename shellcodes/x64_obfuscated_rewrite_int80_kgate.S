bits 64

section .section exec write

global _start
_start:
	jmp locate_payload

post_locate_payload:
	pop rsi			; save payload location
	mov edx, esi

search_egg:
        ;%define system_call int 0x80
        %define EGG 0x7dca
        %define SHIFT 0x0303
        %define system_call dw EGG
        mov rax, [rdx]
        cmp word ax, EGG        ; search egg
        jne not_found
        add ax, SHIFT           ; 0x7dca + 0x0303 = 0x80cd (int 0x80)
        mov [rdx], eax          ; rewrite instruction

not_found:
	inc edx
	cmp eax, 0xcafebabe	; end of payload marker
	jne search_egg		; keep searching eggs
	jmp rsi			; jmp to payload

locate_payload:
	call post_locate_payload

payload:

	mov rbx, 42
    	mov rax, 0x1
    	system_call

	dd 0xcafebabe	; end of payload
