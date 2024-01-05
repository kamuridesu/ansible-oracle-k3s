from subprocess import PIPE, Popen
from base64 import b64decode


def get_argocd_initial_admin_secret() -> str:
    p = Popen(
        ["vagrant", "ssh", "master01", "-c", r'kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"'],
        stdout=PIPE,
        stderr=PIPE
    )
    out, err = p.communicate()
    if p.returncode != 0:
        raise type("VagrantCommandError", (Exception,), {"__init__": lambda self, message: super(Exception, self).__init__(message)})(err if err != b"" else out)
    return b64decode(out.decode().split('\n')[-1].encode()).decode().strip()


print("Getting argocd initial password...")
password = get_argocd_initial_admin_secret()
print(f"Done! Password: {password}")
