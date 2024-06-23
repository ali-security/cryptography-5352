#!/bin/bash -ex

case "${1}" in
    install)
        git clone --depth=1 https://github.com/pyca/pyopenssl
        cd pyopenssl
        git rev-parse HEAD
        pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -e ".[test]"
        ;;
    run)
        cd pyopenssl
        pytest tests
        ;;
    *)
        exit 1
        ;;
esac
