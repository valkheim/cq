global _start
section .text

_start:
	jmp msg

goback:
	mov rdi, 1	; stdout
	pop rsi		; msg
	mov rdx, 6	; size
	mov rax, 1	; SYS_write
	syscall

	mov rdi, 0x0
	mov rax, 60
	syscall

msg:
	call goback
	db "Hello",  0x0a
