#!/bin/bash

# Function to check if a user exists
check_user_exists() {
    # Check if the user exists
    if id "$1" >/dev/null 2>&1; then
        echo "User '$1' exists"
        if groups "$1" | grep -q "admin"; then
           echo "User '$1' is a member of the Admin access"
        else
            echo "User '$1' is not a member of the Admin access"
            echo "Adding '$1' to the Admin group"
            dseditgroup -o edit -a "$1" -t user admin
        fi
    else
        echo "User '$1' does not exist"
        sysadminctl -addUser "$1" -fullName "$1" -password "$2" -admin
    fi
}

# Example usage
username="JohnDoe"
password="N9ghtm@r3"
check_user_exists "$username" "$password"
