CODE=$(for op in $(objdump -d "$1" | grep "^ " | cut -f2); do echo -n "\x$op" ; done)
echo "$CODE"
echo "Length: $(echo "$CODE" | grep -o "x" | wc -l)"
