#!/bin/bash

# Function to check if a user exists
check_user_exists() {
    # Check if the user exists
    if id "$1" >/dev/null 2>&1; then
        echo "User '$1' exists"
        if groups "$1" | grep -q "admin"; then
            echo "User '$1' is already a member of the Admin group"
        else
            echo "User '$1' does not have admin rights"
            echo "Adding '$1' to the Admin group"
            dseditgroup -o edit -a "$1" -t user admin
            log_entry "$1" "Added to Admin group"
        fi
    else
        echo "User '$1' does not exist"
        echo "Creating user '$1' and adding to the Admin group"
        sysadminctl -addUser "$1" -fullName "$1" -password "$2" -admin
        log_entry "$1" "User created and added to Admin group"
    fi
}

# Function to log entries to a remote CSV file
log_entry() {
    local username="$1"
    local action="$2"
    local hostname=$(hostname)
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    local log_file="smb://172.16.222.85/userlog/macos_user.csv"

    echo "$timestamp,$hostname,$username,$action" >> "$log_file"
}

# Example usage
username="JohnDoe"
password="change_password"
check_user_exists "$username" "$password"