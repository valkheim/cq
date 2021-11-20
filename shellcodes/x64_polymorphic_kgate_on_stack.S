bits 64                                       

section .section exec write

global _start
_start:
  jmp locate_payload

post_locate_payload:
  pop rsi      ; get payload location
  mov rdx, rsi ; save payload location

search_egg:
  ;%define system_call int 0x80
  %define EGG 0x7f32
  %define XOR 0x7a3d
  %define system_call dw EGG
  mov rax, [rdx]
  cmp word ax, EGG        ; search egg
  jne not_found
  xor word [rdx], XOR

not_found:
  inc rdx
  cmp eax, 0xcafebabe ; end of payload marker
  jne search_egg      ; keep searching eggs
  jmp rsi             ; jmp to payload

locate_payload:
  call post_locate_payload

payload:

  ; void exit(int status);
  mov rdi, 42
  push 60 ; exit
  pop rax
  system_call

  dd 0xcafebabe
