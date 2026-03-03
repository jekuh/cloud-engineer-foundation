#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/terraform"
ANSIBLE_DIR="${ROOT_DIR}/ansible"

cd "${TF_DIR}"
terraform init
terraform apply -auto-approve

cd "${ANSIBLE_DIR}"
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbooks/linux-web.yml
ansible-playbook playbooks/windows-web.yml
