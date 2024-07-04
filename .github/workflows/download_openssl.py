import io
import sys
import shutil
import zipfile


def main(arch, windows):
    with open(r".github\workflows\openssl_zips\openssl_{}.zip".format(arch), 'rb') as fd:
        zipfile.ZipFile(io.BytesIO(fd.read())).extractall("C:\\")
    shutil.move("C:\\OpenSSL", "C:\\OpenSSL-{}".format(windows))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
