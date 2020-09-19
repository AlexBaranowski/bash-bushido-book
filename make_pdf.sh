#!/usr/bin/env bash

CHROME_TIMEOUT=180
SERVER_TIMEOUT=$CHROME_TIMEOUT
export TO_KILL_CHROME 
export TO_KILL_PYTHON 


cleanup(){
    set +euo pipefail
    kill "$TO_KILL_CHROME" "$TO_KILL_PYTHON"
}

set -euo pipefail


trap cleanup EXIT

# Cleanup old builds
rm -rf build/pdf
mkdir -p build/pdf


setup_chrome_dev_tools_env(){
    pushd chrome-print-page-python 
    virtualenv-3 -p /usr/bin/python3 venv 
    set +euo pipefail # PS1 is not setup
    . venv/bin/activate
    set -euo pipefail
    pip install -r requirements.txt 
    timeout $CHROME_TIMEOUT ./start_chrome.sh &
    TO_KILL_CHROME="$!"
    popd
}

start_tmp_http_server(){
    pushd build/html 
    timeout $SERVER_TIMEOUT python -m http.server 8080 &
    TO_KILL_PYTHON="$!"
    popd
}

print_pdf(){
    chrome-print-page-python/print_with_chrome.py --print_to build/pdf/book.pdf "http://localhost:8080/book.html"
}

main(){
#    echo "COMMENT ME to run this script - v1.1 used FireFox to generate PDF!"
#    exit 0
    echo "-> PDF gen script start!"
    setup_chrome_dev_tools_env
    echo "-> Chrome started!"
    start_tmp_http_server
    echo "-> Python temporary http server started!"
    echo "-> Printing PDF it might take some time"
    print_pdf
    echo "-> PDF gen script finished!"
    echo "-> Killing Chrome $TO_KILL_CHROME and Python http server $TO_KILL_PYTHON"
}
main
