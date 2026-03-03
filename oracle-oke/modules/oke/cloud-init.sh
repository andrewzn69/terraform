#!/bin/bash

# oke bootstrap - has to run first for node registration
curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode > /var/run/oke-init.sh
bash /var/run/oke-init.sh

# install nfs utils
yum install -y nfs-utils

# install and start tailscale
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up \
  --authkey=${tailscale_auth_key} \
  --advertise-routes=${pods_cidr},${services_cidr} \
  --accept-routes \
  --accept-dns=false
