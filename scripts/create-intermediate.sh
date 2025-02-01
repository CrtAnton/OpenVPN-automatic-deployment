#!/usr/bin/expect -f
set timeout -1

if { $argc < 2 } {
    send_user "Usage: $argv0 <Inter_Passphrase> <Inter_CommonName>\n"
    exit 1
}

set inter_passphrase [lindex $argv 0]
set inter_common_name [lindex $argv 1]

spawn ./easyrsa gen-req intermediate

expect "Enter PEM pass phrase:"
send "$inter_passphrase\r"

expect "Verifying - Enter PEM pass phrase:"
send "$inter_passphrase\r"

expect {
    -re {Common Name.*\]:} {
        send "$inter_common_name\r"
    }
}

expect eof