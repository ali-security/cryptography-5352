#!/bin/bash -ex

case "${1}" in
    install)
        git clone --depth=1 https://github.com/paramiko/paramiko
        cd paramiko
        git rev-parse HEAD
        pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -e .
        pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -r dev-requirements.txt
        ;;
    run)
        cd paramiko
        inv test
        ;;
    *)
        exit 1
        ;;
esac
