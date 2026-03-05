#!/bin/bash
# cloud-init.sh - node bootstrap script for oke worker nodes
# installs nfs-utils and tailscale, runs oke init script

set -e

# oke bootstrap - has to run first for node registration
if [ ! -f /var/run/oke-init.done ]; then
  curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode > /var/run/oke-init.sh
  bash /var/run/oke-init.sh
  touch /var/run/oke-init.done
fi

# install nfs utils
if ! rpm -q nfs-utils &>/dev/null; then
  yum install -y nfs-utils
fi

# install and start tailscale
if ! command -v tailscale &>/dev/null; then
  curl -fsSL https://pkgs.tailscale.com/stable/oracle/9/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
  yum install -y tailscale
  systemctl enable --now tailscaled
fi

# configure tailscale if not already connected
if ! tailscale status &>/dev/null; then
  tailscale up \
    --authkey=${tailscale_auth_key} \
    --advertise-routes=${pods_cidr},${services_cidr} \
    --accept-routes \
    --accept-dns=false
fi
