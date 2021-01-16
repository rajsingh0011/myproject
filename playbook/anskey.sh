#!/usr/bin/expect -f
set pass [lindex $argv 0]
spawn ssh-copy-id -o "StrictHostKeyChecking=no" -i /home/ansadmin/.ssh/id_rsa.pub ansadmin@node1
expect "password: "
send "$pass\r"
expect "$ "
exit 0

