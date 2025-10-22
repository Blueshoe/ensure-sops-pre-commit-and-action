#!/bin/sh

# Exit immediately if a command fails
set -e

# A flag to track if we find any bad files
HAS_UNENCRYPTED=0

# The pre-commit framework passes the list of staged files as arguments.
# We loop through each file provided.
for file in "$@"; do
    # Use grep to silently (-q) check if the file contains a line
    # starting with 'sops:'.
    if ! grep -q '^sops:' "$file"; then
        echo "!! ERROR: Unencrypted SOPS file found: $file"
        HAS_UNENCRYPTED=1
    fi
done

# If we found any unencrypted files, exit with a non-zero status
# code, which tells pre-commit to abort the commit.
if [ "$HAS_UNENCRYPTED" -ne 0 ]; then
    echo "!! Please encrypt the file(s) with 'sops -e -i <file>' before committing."
    exit 1
fi

# If all files are fine, exit with 0 to allow the commit.
exit 0