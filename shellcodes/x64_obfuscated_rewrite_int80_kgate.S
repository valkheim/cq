bits 64

section .section exec write

global _start
_start:
	jmp locate_payload

post_locate_payload:
	pop rsi			; save payload location
	mov rdx, rsi		; //

search_egg:
	mov rax, [rdx]
	cmp word ax, 0x7dca	; search egg
	jne not_found
	;%define system_call int 0x80
	%define system_call dw 0x7dca
	add ax, 0x0303		; 0x7dca + 0x0303 = 0x80cd (int 0x80)
	mov [rdx], eax		; write instruction -> segfault

not_found:
	inc rdx
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
