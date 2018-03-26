# echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
#gcc main.c -o $(root)/bof -fno-stack-protector -z execstack -no-pie

root := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all:
	gcc main.c -o bof -fno-stack-protector -m32

disass:
	gcc -masm=intel -S main.c -fno-stack-protector -m32

disable-all:
	#                    canary                DEP       PIE    32bits
	gcc main.c -o bof -fno-stack-protector -z execstack -no-pie -m32

disass-all:
	gcc -masm=intel -S main.c -fno-stack-protector -z execstack -no-pie -m32

check:
	readelf -l bof | grep GNU_STACK
