# spawn tty shell


* `/usr/bin/script -qc /bin/bash /dev/null`
* `python -c 'import pty; pty.spawn("/bin/sh")'
* `/bin/sh -i`
* or
```
python -c 'import pty; pty.spawn("/bin/sh")'
CTRL-z
stty raw -echo
fg
reset
```
