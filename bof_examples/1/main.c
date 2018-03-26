#include <string.h>

void copy(char *arg)
{
  char buffer[100];
  strcpy(buffer, arg);
}

int main( int argc, char** argv )
{
  if (argv[1])
    copy(argv[1]);
  return 0;
}
