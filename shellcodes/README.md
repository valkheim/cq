## Assemble / link 

```
nasm -f elf32 test.S
ld -m elf_i386 -o test test.o
```

```
nasm -f elf64 test.S
ld -o test test.o
```

## Dump section / payload

```
objcopy --dump-section .text=payload.bin payload
```

## Convention

### int 80

```
mov  rax,4     ; system call number (sys_write)
mov  rbx,1     ; file descriptor (stdout)
mov  rcx,hello ; message to write
mov  rdx,12    ; message length
int  0x80      ; call kernel
```

## syscall

```
%rdi, %rsi, %rdx, %rcx, %r8 and %r9
```

```
mov  rax,4     ; system call number (sys_write)
mov  rdi,1     ; file descriptor (stdout)
mov  rsi,hello ; message to write
mov  rdx,12    ; message length
syscall        ; call kernel
```

## Links

* https://www.commandlinefu.com/commands/matching/shellcode/c2hlbGxjb2Rl/sort-by-votes
* https://github.com/yrp604/rappel REPL for ASM, showing instructions side-effects
