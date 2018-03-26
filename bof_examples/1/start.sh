#!/bin/sh
if [ "$1" ];then
make -f ../Makefile "$1"
else
make -f ../Makefile
fi
