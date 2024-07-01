#!/bin/bash -ex

case "${1}" in
    install)
        git clone --depth=1 https://github.com/certbot/josepy
        cd josepy
        git rev-parse HEAD
        pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -e ".[tests]"
        ;;
    run)
        cd josepy
        pytest src
        ;;
    *)
        exit 1
        ;;
esac
