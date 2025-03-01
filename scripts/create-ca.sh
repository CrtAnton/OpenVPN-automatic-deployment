#!/usr/bin/expect -f
set timeout -1

# if { $argc < 2 } {
#     send_user "Usage: $argv0 <CA_Passphrase> <CA_CommonName>\n"
#     exit 1
# }

# set ca_passphrase [lindex $argv 0]
# set ca_common_name [lindex $argv 1]

# spawn ./easyrsa build-ca

# expect "Enter New CA Key Passphrase:"
# send "$ca_passphrase\r"

# expect "Confirm New CA Key Passphrase:"
# send "$ca_passphrase\r"

# expect {
#     -re {Common Name.*\]:} {
#         send "$ca_common_name\r"
#     }
# }

# expect eof

#!/usr/bin/expect -f
set timeout -1
set arg_count [llength $argv]

if { $arg_count < 1 || $arg_count > 2 } {
    send_user "Usage: $argv0 <CA_CommonName> [CA_Passphrase]\n"
    exit 1
    #Might do this to a log file fr debugging purposes
}

set ca_common_name [lindex $argv 0]
if { $arg_count == 2 } {
    set ca_passphrase [lindex $argv 1]
} else {
    set ca_passphrase ""
}

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
