### Getting Started

```bash

mkdir -p private/gitlab

cd private/gitlab

# call your key `deploy-key`
ssh-keygen

echo "
Host gitlab.com
    User git
    IdentityFile ~/.ssh/deploy-key
"

terraform apply
```