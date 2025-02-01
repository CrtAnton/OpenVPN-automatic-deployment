#!/usr/bin/expect -f
set timeout -1

if { $argc < 2 } {
    send_user "Usage: $argv0 <Client_Passphrase> <Client_CommonName>\n"
    exit 1
}

set client_passphrase [lindex $argv 0]
set client_common_name [lindex $argv 1]

spawn ./easyrsa gen-req client1

expect "Enter PEM pass phrase:"
send "$client_passphrase\r"

expect "Verifying - Enter PEM pass phrase:"
send "$client_passphrase\r"

expect {
    -re {Common Name.*\]:} {
        send "$client_common_name\r"
    }
}

expect eof