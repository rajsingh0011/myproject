#!/usr/bin/expect -f
set pass [lindex $argv 0]
spawn ssh-copy-id -o "StrictHostKeyChecking=no" vagrant@node1
expect "password: "
send "$pass\r"
expect "$ "
exit 0