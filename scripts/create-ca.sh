#!/usr/bin/expect -f
set timeout -1

if { $argc < 2 } {
    send_user "Usage: $argv0 <CA_Passphrase> <CA_CommonName>\n"
    exit 1
}

set ca_passphrase [lindex $argv 0]
set ca_common_name [lindex $argv 1]

cd ~/easy-rsa-root
spawn ./easyrsa build-ca

expect "Enter New CA Key Passphrase:"
send "$ca_passphrase\r"

expect "Confirm New CA Key Passphrase:"
send "$ca_passphrase\r"

expect {
    -re {Common Name.*\]:} {
        send "$ca_common_name\r"
    }
}

expect eof
