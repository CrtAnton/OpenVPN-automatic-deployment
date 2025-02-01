#!/usr/bin/expect -f
set timeout -1

if { $argc < 2 } {
    send_user "Usage: $argv0 <Server_Passphrase> <Server_CommonName>\n"
    exit 1
}

set server_passphrase [lindex $argv 0]
set server_common_name [lindex $argv 1]

spawn ./easyrsa gen-req server

expect "Enter PEM pass phrase:"
send "$server_passphrase\r"

expect "Verifying - Enter PEM pass phrase:"
send "$server_passphrase\r"

expect {
    -re {Common Name.*\]:} {
        send "$server_common_name\r"
    }
}

expect eof