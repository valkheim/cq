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

## Links

* https://www.commandlinefu.com/commands/matching/shellcode/c2hlbGxjb2Rl/sort-by-votes
