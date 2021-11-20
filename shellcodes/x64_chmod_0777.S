bits 64
section .my exec write
global _start

%define PATH "/tmp/flag"
%strlen LEN PATH

_start:
  ; chmod("/tmp/flag", 0777)
  ; mov [path+LEN], byte 0x00
  mov rdi, path
  mov rsi, 0x1ff
  mov rax, 0x5a
  syscall

path:
  db PATH, 0x00
