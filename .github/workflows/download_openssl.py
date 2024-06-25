import io
import os
import sys
import zipfile

import requests


RUNS_URL = "https://www.openssl.org/source/old/1.1.1/openssl-{version}"


def get_response(url):
    response = requests.get(url)
    if response.status_code != 200:
        raise ValueError("Got HTTP {} fetching {}: ".format(
            response.code, url, response.content
        ))
    return response


def main(version):
    print("Looking for: {}".format(version))
    response = get_response(RUNS_URL.format(version=version)).json()
    zipfile.ZipFile(io.BytesIO(response.content)).extractall("C:/{}".format("OpenSSL"))


if __name__ == "__main__":
    main(sys.argv[1])
