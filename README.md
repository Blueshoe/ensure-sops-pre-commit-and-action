# ensure-sops-pre-commit-and-action
A pre-commit hook and a GitHub action to ensure that files are SOPS encrypted.

Our main usage for SOPS is to directly encrypt Kubernetes Secrets. 
Out of this, this pre-commit hook and GitHub action have been developed. 

We SOPS-encrypt the K8s secrets with following settings: `unencrypted_regex: "^(apiVersion|metadata|kind|type)$"`.
This hook and action check, whether the file has a top-level key called `sops:`.

The pre-commit hook and the action both ignore the files with the basename `.sops.yaml`, as that contains the SOPS-configuration.

## pre-commit hook

### Example usage
Just add the following to your projects `.pre-commit-config.yaml`, to check whether all files that end in `.sops.yaml` are sops encrypted:

```yaml
# [...]
repos:
  # [...]
  - repo: https://github.com/Blueshoe/pre-commit-hook-ensure-sops
    rev: v1.0.0
    hooks:
      - id: forbid-unencrypted-sops
        # only run this hook on files with .sops.yaml extension (excluding the actual .sops.yaml file)
        files: .\.sops\.yaml$
```

Keep in mind, that the files to run it against need to be staged, i.e. run `git add .` (or something more specific) before running pre-commit.

## GitHub action

### Example usage 
```yaml
name: "Check for unencrypted SOPS files"

on: [pull_request]

jobs:
  sops-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: "Run SOPS encryption check"
        uses: blueshoe/pre-commit-hook-ensure-sops@v1.1.0
        # You can override the default file pattern like this:
        # with:
        #   files-pattern: '"**/*.secret.yaml"'
    
```