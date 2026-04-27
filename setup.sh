#!/bin/bash
set -e

TARGET=""
SSH_USER=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --target) TARGET="$2"; shift ;;
        --ssh-user) SSH_USER="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$TARGET" ] || [ -z "$SSH_USER" ]; then
    echo "Usage: $0 --target <ip/hostname> --ssh-user <username>"
    exit 1
fi

cat <<EOF > inventory.ini
[all]
$TARGET ansible_user=$SSH_USER
EOF

ansible-playbook -i inventory.ini deploy-mirrors.yml
