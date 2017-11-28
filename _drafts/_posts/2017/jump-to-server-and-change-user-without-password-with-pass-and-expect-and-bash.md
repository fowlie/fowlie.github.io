---
title: jump to server and change user without password
layout: post
date: 2017-11-28 00:00:00 +0000
comments: true
---
At work we only get access to the application servers through a jumpserver. I was getting tired of typing my password all the time, so I started thinking about how to login without typing the password at all.

## pass - the standard unix password manager
Previously I used KeePass, but as I have become more and more faithful to the unix command line, I began using [pass](https://www.passwordstore.org). It encrypts the password store with a GPG key. Now I can just type ```pass -c companyname/mypassword```, and then the password is available from the clipboard for 45 seconds. Drop the -c and it will print it out in clear text. At this point I could just use [sshpass](https://linux.die.net/man/1/sshpass), but in my case it wasn't quite that easy. After I login to the application server I have to switch to a faceless user because ops won't give me sudo access. So now what?

## expect - programmed dialogue with interactive programs
The [expect](https://linux.die.net/man/1/expect) program allows you to automate the keyboard - it will wait for certain things to appear in the terminal and then it can emulate you typing on the keyboard. The solution is based on two scripts, an expect script and a bash script. The expect script takes usernames, passwords and host as input arguments and will type in the ssh commands followed by the passwords. After that it changes to the faceless user. At last it will either start an interactive shell or run a command if provided (handy for scripting).

```bash
#!/usr/bin/expect
set jumpserver "login01"
set remote_host [lindex $argv 0]
set jumpserver_password [lindex $argv 1]
set remote_user [lindex $argv 2]
set remote_password [lindex $argv 3]
set command [lrange $argv 4 end]
set timeout -1
log_user 1

if {[llength $argv] < 4} {
    send_user "Usage: jump server password su-user su-password [command]\n"
    exit 1
}

spawn ssh -o StrictHostKeyChecking=no $jumpserver
expect {
    timeout { send_user "\nFailed to get the password prompt\n"; exit 1 }
    "*(~):" {}
    "*?assword:" {
        send "$jumpserver_password\r";
        expect "*(~):"
    }
}

send "ssh -o StrictHostKeyChecking=no $remote_host\r"
expect {
    timeout { send_user "\nFailed to get the password prompt\n"; exit 1 }
    "*:~>" {}
    "*?assword:" {
        send "$jumpserver_password\r";
        expect "*:~>"
    }
}
send "su - $remote_user\r";
expect "*?assword:"
send "$remote_password\r";

if {[llength $command] > 0} {
    expect "*:~>"
    send "$command\r";
    expect "*:~>"
} else {
    interact
}
```
On my computer, this script is saved under /usr/local/bin/jump. Now I can use this script like this 
```bash
jump appserver01 $(pass mycompany/mypassword) appuser $(pass mycompany/appuser)
```
Pretty nice right? :smirk: But we can take it even further with a litte bash script to have it interact with the pass program.

## bash - combine expect with pass
The jump script listed above works just fine, but if we follow a two simple password storage conventions we can simplify further:

1. Store the password for your login credentials under a static path, for example mycompany/me. Then, any script can get the password by running ```pass mycompany/me)
2. Passwords are stored with the username as the key.

Now with that in mind, consider the following bash script:
```bash
#!/bin/bash

# Check argument count
if [ "$#" -lt 2 ]; then
    echo "Usage: passjump server su-user [command]"
    exit 1
fi

# Define variables
host=$1
user=$2
personal_password=$(pass mycompany/me)
password=$(pass mycompany/$user)
# Get all arguments after the third one
command="${@:3}"

if [[ -z $personal_password ]] || [[ -z $password ]]; then
    exit 1
fi

jump $host $personal_password $user $password $command
```

Now when I save this as /usr/local/bin/passjump, I can do 
```bash
passjump appserver01 appuser
``` 
to get an interactive shell without typing a single password! Or, I can do 
```bash
passjump appserver01 appuser tail -f /var/log/some.log
```
:heart_eyes: :star: