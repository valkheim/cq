printf "SYS_$1" | gcc -include sys/syscall.h -E - | tail -n 1
