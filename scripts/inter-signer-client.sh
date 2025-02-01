#!/usr/bin/expect -f
set timeout -1

if { $argc < 1 } {
    send_user "Usage: $argv0 <Inter_Passphrase>"
    exit 1
}

set inter_passphrase [lindex $argv 0]

spawn ./easyrsa sign-req client client1

expect {
    -re {Type the word 'yes' to continue.*:} {
        send "yes\r"
    }
}

expect "Enter pass phrase for"
send "$inter_passphrase\r"

expect eof