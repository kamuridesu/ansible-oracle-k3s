import os
import pathlib
from subprocess import PIPE, Popen
import sys

TARGET_DIR = pathlib.Path.home() / ".config" / "OpenLens" / "kubeconfigs"
if sys.platform == "win32":
    TARGET_DIR = pathlib.Path.home() / "AppData" / "Roaming" / "OpenLens" / "kubeconfigs"

TARGET_FILE = TARGET_DIR / "k3s"
os.makedirs(
    TARGET_DIR,
    exist_ok=True
)


def get_k3s_kubeconfig() -> str:
    p = Popen([
        "vagrant",
        "ssh",
        "master01",
        "-c",
        r'cat /home/vagrant/.kube/config'
    ], stdin=PIPE, stdout=PIPE)
    out, err = p.communicate()
    if p.returncode != 0:
        raise type(
            "VagrantCommandError",
            (Exception,),
            {
                "__init__": lambda self, message: super(Exception, self).__init__(message)
            })(err if err != b"" else out)
    output = "\n".join(out.decode().splitlines()[1:]).replace("127.0.0.1", "10.0.1.100")
    with open(TARGET_FILE, "w") as f:
        f.write(output)
    return output


print("Getting config...")
get_k3s_kubeconfig()
print("Done!")
