#!/bin/bash

#Functions
fn_instructions() {
    echo "Usage: $0 [OPTION]"
    echo "Options:"
    echo "-e for express mode"
    echo "-g for guided mode"
    echo "-d to destroy all"
    exit 1
}

fn_run_terraform() {
    cd terraform && terraform apply -auto-approve \
    -var="Root_Passphrase=$root_passphrase" \
    -var="Root_CA_Name=$root_ca_name" \
    -var="Intermediate_Passphrase=$intermediate_passphrase" \
    -var="Intermediate_CA_Name=$intermediate_ca_name"
}

fn_destroy_terraform() {
    cd terraform && terraform destroy -auto-approve
}

#Variables
root_passphrase="passphrase_12345"
root_ca_name="Root-CA"
intermediate_passphrase="passphrase_12345"
intermediate_ca_name="Intermediate-CA"

#Logic
if [[ $# -eq 0 ]]; then
  fn_instructions
fi

while getopts ":edg" option; do
  case "$option" in 
    e)
        echo "Starting in express mode"
        fn_run_terraform
        exit 0
        ;;
    g)
        echo "Starting in guided mode"    
        read -p "Enter a passphrase for root ca (min 4 chars): " root_passphrase
        read -p "Enter root ca name: " root_ca_name
        read -p "Enter a passphrase for intermediate ca (min 4 chars): " intermediate_passphrase
        read -p "Enter intermediate ca name: " intermediate_ca_name
        fn_run_terraform
        exit 0
        ;;
    d)
        echo "Destroying terraform resources"
        fn_destroy_terraform
        exit 0
        ;;
    *)
        echo "Invalid option"
        fn_instructions
        ;;        
  esac
done 

        


