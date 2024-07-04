#!/bin/bash -ex

case "${1}" in
    install)
        git clone --depth 1 https://github.com/shazow/urllib3
        cd urllib3
        git rev-parse HEAD
        pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -r ./dev-requirements.txt
        pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -e ".[socks]"
        ;;
    run)
        cd urllib3
        pytest test
        ;;
    *)
        exit 1
        ;;
esac
