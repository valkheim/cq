
int main(void)
{
  void (*f)(void) = 0x7ffe29df3a36;
  f();
  //void *ptr = (void *)0x7ffe29df3a36;  // a random memory address
  //goto *ptr;                      // jump there -- probably crash
}
