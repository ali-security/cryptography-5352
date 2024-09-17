import io
import os
import sys
import time
import zipfile
import shutil
import requests

from urllib3.util.retry import Retry


def get_response(session, url):
    # Retry on non-502s
    for i in range(5):
        response = session.get(url)
        if response.status_code != 200:
            print(
                "HTTP error ({}) fetching {}, retrying".format(
                    response.status_code, url
                )
            )
            time.sleep(2)
            continue
        return response
    response = session.get(url)
    if response.status_code != 200:
        raise ValueError(
            "Got HTTP {} fetching {}: ".format(response.status_code, url)
        )
    return response


def main(platform, target):
    if platform == "windows":
        arch = "x64" if "win64" in target else "x86"
        zipfile.ZipFile(rf".github\workflows\openssl_builds\openssl_{arch}.zip").extractall(f"C:\\")
        shutil.move(f"C:\\OpenSSL", f"C:\\OpenSSL_{arch}")
        return
    elif platform == "macos":
        workflow = "build-macos-openssl.yml"
        path = os.environ["HOME"]
    else:
        raise ValueError("Invalid platform")

    session = requests.Session()
    adapter = requests.adapters.HTTPAdapter(max_retries=Retry())
    session.mount("https://", adapter)
    session.mount("http://", adapter)

    print("Looking for: {}".format(target))
    runs_url = (
        "https://api.github.com/repos/ali-security/cryptography-5352/actions/workflows/"
        "{}/runs?branch=3.4-base".format(workflow)
    )

    response = get_response(session, runs_url).json()
    artifacts_url = response["workflow_runs"][0]["artifacts_url"]
    response = get_response(session, artifacts_url).json()
    for artifact in response["artifacts"]:
        if artifact["name"] == target:
            print("Found artifact")
            response = get_response(session, artifact["archive_download_url"])
            zipfile.ZipFile(io.BytesIO(response.content)).extractall(
                os.path.join(path, artifact["name"])
            )
            return
    raise ValueError("Didn't find {} in {}".format(target, response))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])