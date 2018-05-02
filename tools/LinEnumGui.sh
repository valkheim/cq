#!/bin/sh

e='echo -en'
M0(){ TPUT 3 5; $e "System infos";}
M1(){ TPUT 4 5; $e "Groups and users";}
M2(){ TPUT 5 5; $e "Sensitive files";}
M3(){ TPUT 6 5; $e "Environment";}
M4(){ TPUT 7 5; $e "Jobs/cron";}
M5(){ TPUT 8 5; $e "Network";}
M6(){ TPUT 9 5; $e "Services";}
M7(){ TPUT 10 5; $e "Softwares";}
M8(){ TPUT 11 5; $e "EXIT";}
LM=8

scan() {
  echo -e "=== $1"
}

F0() {
  scan "Kernel information:\n$(uname -a 2> /dev/null)\n"
  scan "Kernel information (continued):\n$(cat /proc/version 2> /dev/null)\n"
  scan "Specific release information:\n$(cat /etc/*-release 2> /dev/null)\n"
  scan "Hostname:\n$(hostname 2> /dev/null)\n"
}

F1() {
  scan "Current user/group info:\n$(id 2> /dev/null)\n"
  scan "Last logged users:\n$(lastlog 2>/dev/null |grep -v "Never" 2>/dev/null)\n"
  scan "Logged on users:\n$(w | tail -n -1 2>/dev/null)\n"
  scan "Group memberships:\n$(for i in $(cut -d":" -f1 /etc/passwd 2>/dev/null);do id $i;done 2>/dev/null)\n"
  scan "adm users:\n$(echo -e "$grpinfo" | grep "(adm)")\n"
  scan "Password hashes in /etc/passwd:\n$(grep -v '^[^:]*:[x]' /etc/passwd 2>/dev/null)\n"
  scan "/etc/passwd:\n$(cat /etc/passwd 2>/dev/null)\n"
  scan "/etc/shadow:\n$(cat /etc/shadow 2>/dev/null)\n"
  scan "/etc/master.passwd (/etc/shadow BSD variant):\n$(cat /etc/master.passwd 2>/dev/null)\n"
  scan "Super user accounts (uid 0):\n$(grep -v -E "^#" /etc/passwd 2>/dev/null| awk -F: '$3 == 0 { print $1}' 2>/dev/null)\n"
  scan "Sudoers config:\n$(grep -v -e '^$' /etc/sudoers 2>/dev/null |grep -v "#" 2>/dev/null)\n"
  scan "Sudo without password:\n$(if (echo '' | sudo -S -l 2>/dev/null);then echo "OK";else echo "KO";fi)\n"
  sudopwnage=`echo '' | sudo -S -l 2>/dev/null | grep -w 'nmap\|perl\|'awk'\|'find'\|'bash'\|'sh'\|'man'\|'more'\|'less'\|'vi'\|'emacs'\|'vim'\|'nc'\|'netcat'\|python\|ruby\|lua\|irb' | xargs -r ls -la 2>/dev/null;`
  scan "Possible sudo pwnage:\n$(if [ "$sudopwnage" ];then echo "$sudopwn";else echo "KO";fi)\n"
  scan "Accounts that have recently used sudo:\n$(find /home -name .sudo_as_admin_successful 2>/dev/null)\n"
  scan "Root directory:\n$(ls -ahl /root/ 2>/dev/null)\n"
  scan "Home directory permissions:\n$(ls -ahl /home/ 2>/dev/null)\n"
  scan "Ssh root login policy:\n$(grep "PermitRootLogin " /etc/ssh/sshd_config 2>/dev/null | grep -v "#")\n"
}

F2() {
  scan "Files not owned by user but writable by group:\n$(find / -writable ! -user \`whoami\` -type f ! -path "/proc/*" ! -path "/sys/*" -exec ls -al {} \; 2>/dev/null)\n"
  scan "Files owned by our user:\n$(find / -user \`whoami\` -type f ! -path "/proc/*" ! -path "/sys/*" -exec ls -al {} \; 2>/dev/null)\n"
  scan "Hidden files:\n$(find / -name ".*" -type f ! -path "/proc/*" ! -path "/sys/*" -exec ls -al {} \; 2>/dev/null)\n"
  scan "World-readable files within /home:\n$(find /home/ -perm -4 -type f -exec ls -al {} \; 2>/dev/null)\n"
  sshfiles=$(find / \( -name "id_dsa*" -o -name "id_rsa*" -o -name "known_hosts" -o -name "authorized_hosts*" -o -name "authorized_keys" \) -exec ls -la {} 2>/dev/null \;)
  scan "SSH keys/host information found:\n"$sshfiles"\n"
  scan ".htpasswd:\n$(find / -name .htpasswd -print -exec cat {} \; 2>/dev/null)\n"
  scan "Usual www dir contents:\n$(ls -alhR /var/www/ 2>/dev/null; ls -alhR /srv/www/htdocs/ 2>/dev/null; ls -alhR /usr/local/www/apache2/data/ 2>/dev/null; ls -alhR /opt/lampp/htdocs/ 2>/dev/null)\n"
  scan "Useful file locations:\n$(which nc 2>/dev/null ; which netcat 2>/dev/null ; which wget 2>/dev/null ; which nmap 2>/dev/null ; which gcc 2>/dev/null; which curl 2>/dev/null)\n"
  scan "SUID files:\n$(find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \;)\n"
  scan "GUID files:\n$(find / -perm -2000 -type f -exec ls -la {} 2>/dev/null \;)\n"
  scan "Dockerfiles:\n$(find / -name Dockerfile -exec ls -l {} 2>/dev/null \;)\n"
  scan "docker-compose files:\n$(find / -name docker-compose.yml -exec ls -l {} 2>/dev/null \;)\n"
  scan "World-writeable files (excluding */proc/* and /sys/*):\n$(find / ! -path "*/proc/*" ! -path "/sys/*" -perm -2 -type f -exec ls -la {} 2>/dev/null \;)\n"
  scan ".rhosts files:\n$(find /home /usr/home -iname *.rhosts -exec ls -la {} 2>/dev/null \; -exec cat {} 2>/dev/null \;)\n"
  scan "NFS config details:\n$(ls -la /etc/exports 2>/dev/null; cat /etc/exports 2>/dev/null)\n"
  scan "fstab:\n$(cat /etc/fstab 2>/dev/null)\n"
  scan "User/root history:\n$(ls -la ~/.*_history /root/.*_history 2>/dev/null)\n"
  scan "Mails:\n$(ls -la /var/mail /var/mail/root 2>/dev/null)\n"
  scan "Advices\n  Double check *.conf, *.log, *.ini, *.php, ...\n"
}

F3() {
  scan "env:\n$(env 2>/dev/null | grep -v 'LS_COLORS' 2>/dev/null)\n"
  scan "SELinux:\n$(sestatus 2>/dev/null)\n"
  scan "\$PATH:\n$(echo $PATH 2>/dev/null)\n"
  scan "Shells:\n$(cat /etc/shells 2>/dev/null | grep -v '#' | grep -v -e '^$')\n"
  scan "umask (oct/sym):\n$(umask -S 2>/dev/null & umask 2>/dev/null)\n"
  scan "Password and storage infos (/etc/logins.defs):\n$(grep "^PASS_MAX_DAYS\|^PASS_MIN_DAYS\|^PASS_WARN_AGE\|^ENCRYPT_METHOD" /etc/login.defs 2>/dev/null)\n"
}

F4() {
  scan "Cron jobs:\n$(ls -la /etc/cron* 2>/dev/null)\n"
  scan "Crontab value:\n$(cat /etc/crontab 2>/dev/null)\n"
  scan "World-writeable cron jobs and file contents:\n$(find /etc/cron* -perm -0002 -type f -exec ls -la {} \; -exec cat {} 2>/dev/null \;)\n"
  scan "/var/spool/cron/crontabs:\n$(ls -la /var/spool/cron/crontabs 2>/dev/null)\n"
  scan "Anacron:\n$(ls -la /etc/anacrontab 2>/dev/null; cat /etc/anacrontab 2>/dev/null)\n"
  scan "/var/spool/anacron:\n$(ls -la /var/spool/anacron 2>/dev/null)\n"
  scan "Jobs held by all users:\n$(cut -d ":" -f 1 /etc/passwd | xargs -n1 crontab -l -u 2>/dev/null)\n"
}

F5() {
  #scan "Global infos:\n$(/sbin/ifconfig -a 2>/dev/null)\n"
  scan "Global infos:\n$(/sbin/ip a 2>/dev/null)\n"
  #scan "ARP:\n$(arp -a 2>/dev/null)\n"
  scan "ARP:\n$(ip n 2>/dev/null)\n"
  scan "DNS:\n$(grep "nameserver" /etc/resolv.conf 2>/dev/null | grep -v '#')\n"
  #scan "Default route configuration:\n$(route 2>/dev/null | grep default)\n"
  scan "Default route configuration:\n$(ip r 2>/dev/null | grep default)\n"
  scan "Listening TCP:\n$(netstat -antp 2>/dev/null)\n"
  #scan "Listening TCP:\n$(ss -t 2>/dev/null)\n"
  scan "Listening UDP:\n$(netstat -anup 2>/dev/null)\n"
  #scan "Listening UDP:\n$(ip -u 2>/dev/null)\n"
}

F6() {
  scan "Running processes:\n$(ps aux 2>/dev/null)\n"
  scan "Running process binaries paths and permissions:\n$(for f in $(ps aux | awk '{print $11}');do p=$(which $f 2>/dev/null) && ls -la "$p";done)\n"
  scan "Contents of /etc/inetd.conf:\n$(cat /etc/inetd.conf 2>/dev/null)\n"
  scan "The related inetd binary permissions:\n$(awk '{print $7}' /etc/inetd.conf 2>/dev/null |xargs -r ls -la 2>/dev/null)\n"
  scan "Contents of /etc/xinetd.conf:\n$(cat /etc/xinetd.conf 2>/dev/null)\n"
  scan "/etc/xinet.d:\n$(ls -la /etc/xinetd.d 2>/dev/null)\n"
  scan "/etc/init.d/ files not belonging to uid 0:\n$(find /etc/init.d/ \! -uid 0 -type f 2>/dev/null |xargs -r ls -la 2>/dev/null)\n"
  scan "/etc/rc.d/init.d binary permissions:\n$(ls -la /etc/rc.d/init.d 2>/dev/null)\n"
  scan "/usr/local/etc/rc.d binary permissions:\n$(ls -la /usr/local/etc/rc.d 2>/dev/null)\n"
}

F7() {
  scan "Sudo version:\n$(sudo -V 2>/dev/null| grep "Sudo version" 2>/dev/null)\n"
  scan "Mysql version:\n$(mysql --version 2>/dev/null)\n"
  scan "Postgres version:\n$(psql -V 2>/dev/null)\n"
  scan "Apache2 version:\n$(apache2 -v 2>/dev/null; httpd -v 2>/dev/null)\n"
  scan "Apache user configuration:\n$(grep -i 'user\|group' /etc/apache2/envvars 2>/dev/null |awk '{sub(/.*\export /,"")}1' 2>/dev/null)\n"
  scan "Apache modules:\n$(apache2ctl -M 2>/dev/null; httpd -M 2>/dev/null)\n"
  scan "Docker hosting:\n$(docker --version 2>/dev/null; docker ps -a 2>/dev/null)\n"
  scan "Docker container belonging:\n$(grep -i docker /proc/self/cgroup  2>/dev/null; find / -name "*dockerenv*" -exec ls -la {} \; 2>/dev/null)\n"
  scan "LXC container belonging:\n$(grep -qa container=lxc /proc/1/environ 2>/dev/null)\n"
}

E='echo -e'
trap "R;exit" 2
ESC=$($e "\e")
TPUT(){ $e "\e[${1};${2}H";}
CLEAR(){ $e "\ec";}
CIVIS(){ $e "\e[?25l";}
DRAW(){ $e "\e%\e(0";}
WRITE(){ $e "\e(B";}
MARK(){ $e "\e[7m";}
UNMARK(){ $e "\e[27m";}
i=0

R(){
  CLEAR ;stty sane;$e "\ec\e[37;0m\e[J";
}

HEAD() {
  DRAW
  for each in $(seq 1 $(($LM+5)));do
    $E "x                                          x"
  done
  WRITE ; MARK ; TPUT 1 2
  $E "Enum more                                 "; UNMARK ;
}

FOOT() {
  MARK ; TPUT $(($LM+5)) 2
  head -c 42 /dev/zero | tr '\0' ' ' ; UNMARK ;
}

ARROW() {
  read -s -n3 key 2> /dev/null >&2
  if [[ $key = $ESC[A ]];then echo up;fi
  if [[ $key = $ESC[B ]];then echo dn;fi
}

MENU() {
  for each in $(seq 0 $LM)
  do M${each}
  done
}

POS() {
  if [[ $cur == up ]];then ((i--));fi
  if [[ $cur == dn ]];then ((i++));fi
  if [[ $i -lt 0   ]];then i=$LM;fi
  if [[ $i -gt $LM ]];then i=0;fi
}

REFRESH() {
  after=$((i+1)); before=$((i-1))
  if [[ $before -lt 0 ]];then before=$LM;fi
  if [[ $after -gt $LM ]];then after=0;fi
  if [[ $j -lt $i ]];then UNMARK;M$before;else UNMARK;M$after;fi
  if [[ $after -eq 0 ]] || [ $before -eq $LM ]; then
    UNMARK
    M$before
    M$after
  fi
  j=$i;UNMARK;M$before;M$after
}

INIT() {
  R;HEAD;FOOT;MENU
}

SC() {
  REFRESH;MARK;$S;$b;cur=`ARROW`
}

ES() {
  MARK;$e "\nRETURN";$b;read -s;INIT
}

CLEAR; CIVIS;NULL=/dev/null
INIT

while [[ "$O" != " " ]]; do
  for each in $(seq 0 $LM); do
    S=M$i;SC;if [[ $cur == "" ]];then R;
    if [[ $i -eq $LM ]];then
      exit 0;
    else
      $e "\n$(F$i)\n";
    fi
    ES;fi;POS;
  done
done
