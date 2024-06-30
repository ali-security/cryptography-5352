import io
import sys
import zipfile


def main(arch):
    with open(r".github\workflows\openssl_zips\openssl_{}.zip".format(arch), 'rb') as fd:
        zipfile.ZipFile(io.BytesIO(fd.read())).extractall(".github\workflows\openssl_zips")


if __name__ == "__main__":
    main(sys.argv[1])
