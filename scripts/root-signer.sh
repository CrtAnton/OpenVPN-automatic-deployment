#!/usr/bin/expect -f
set timeout -1

if { $argc < 1 } {
    send_user "Usage: $argv0 <ca_Passphrase>"
    exit 1
}

set ca_passphrase [lindex $argv 0]

cd ~/easy-rsa-root
spawn ./easyrsa sign-req ca intermediate

expect {
    -re {Type the word 'yes' to continue.*:} {
        send "yes\r"
    }
}

expect "Enter pass phrase for"
send "$ca_passphrase\r"

expect eof