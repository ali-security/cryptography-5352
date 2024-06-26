#!/bin/bash

set -e
set -x

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

shlib_sed() {
    # modify the shlib version to a unique one to make sure the dynamic
    # linker doesn't load the system one.
    sed -i "s/^SHLIB_MAJOR=.*/SHLIB_MAJOR=100/" Makefile
    sed -i "s/^SHLIB_MINOR=.*/SHLIB_MINOR=0.0/" Makefile
    sed -i "s/^SHLIB_VERSION_NUMBER=.*/SHLIB_VERSION_NUMBER=100.0.0/" Makefile
}

# download, compile, and install if it's not already present via travis
# cache
if [ -n "${OPENSSL}" ]; then
    . "$SCRIPT_DIR/openssl_config.sh"
    if [[ ! -f "$HOME/$OPENSSL_DIR/bin/openssl" ]]; then
        curl -O "https://www.openssl.org/source/openssl-${OPENSSL}.tar.gz"
        tar zxf "openssl-${OPENSSL}.tar.gz"
        pushd "openssl-${OPENSSL}"
        ./config $OPENSSL_CONFIG_FLAGS -fPIC --prefix="$HOME/$OPENSSL_DIR"
        shlib_sed
        make depend
        make -j"$(nproc)"
        if [[ "${OPENSSL}" =~ 1.0.1 ]]; then
            # OpenSSL 1.0.1 doesn't support installing without the docs.
            make install
        else
            # avoid installing the docs
            # https://github.com/openssl/openssl/issues/6685#issuecomment-403838728
            make install_sw install_ssldirs
        fi
        popd
    fi
elif [ -n "${LIBRESSL}" ]; then
    LIBRESSL_DIR="ossl-2/${LIBRESSL}"
    if [[ ! -f "$HOME/$LIBRESSL_DIR/bin/openssl" ]]; then
        curl -O "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL}.tar.gz"
        tar zxf "libressl-${LIBRESSL}.tar.gz"
        pushd "libressl-${LIBRESSL}"
        ./config -Wl -Wl,-Bsymbolic-functions -fPIC shared --prefix="$HOME/$LIBRESSL_DIR"
        shlib_sed
        make -j"$(nproc)" install
        popd
    fi
fi

if [ -n "${DOCKER}" ]; then
    if [ -n "${OPENSSL}" ] || [ -n "${LIBRESSL}" ]; then
        echo "OPENSSL and LIBRESSL are not allowed when DOCKER is set."
        exit 1
    fi
    docker pull "$DOCKER" || docker pull "$DOCKER" || docker pull "$DOCKER"
fi

if [ -z "${DOWNSTREAM}" ]; then
    git clone --depth=1 https://github.com/google/wycheproof "$HOME/wycheproof"
fi

pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' -U pip
pip install --index-url 'https://:2020-04-22T23:19:51.290101Z@time-machines-pypi.sealsecurity.io/' virtualenv

python -m virtualenv ~/.venv
source ~/.venv/bin/activate
# If we pin coverage it must be kept in sync with tox.ini and azure-pipelines.yml
pip install tox codecov coverage
