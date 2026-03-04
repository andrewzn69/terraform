# Oracle Talos Kubernetes Cluster

**Terraform infrastructure for deploying Talos Kubernetes cluster on Oracle Cloud Infrastructure**

## Overview

This project deploys a complete Talos Kubernetes cluster on Oracle Cloud using Terraform. It uses only resources from Oracle Free Tier

## Architecture

```
Internet → Load Balancer → VCN → [Controlplane + Worker Nodes]
           ↓ Ports 50000/6443
           Backend Sets → Health Checks → Private IPs
```

**Resources Created**:
- 1x Network Load Balancer (Always Free: 10 Mbps)
- 1x Controlplane VM (1 OCPU, 4GB RAM)
- 1x Worker VM (3 OCPU, 20GB RAM + storage)
- Complete networking (VCN, subnet, security lists)
- Object storage for custom Talos image

## Quick Start

### Prerequisites

1. **Oracle Cloud Account** with Always Free tier
2. **OCI CLI configured** with API keys
3. **Terraform** >= 1.0
4. **talosctl**

### 1. Prepare Talos Image

Generate a custom Talos image using [Talos Image Factory](https://factory.talos.dev/):
- Choose **arm64** architecture
- Download as `.xz` file to project root

Create image metadata:
```bash
cp files/image_metadata-example.json files/image_metadata.json
# edit image_metadata.json with your image details
```

Convert image to OCI format:
```bash
chmod +x scripts/prepare-image.sh
bash scripts/prepare-image.sh
```

### 2. Configure Terraform

Copy and edit the Terraform variables:
```bash
cd envs/prod
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your Oracle Cloud details
```

**Required Variables**:
```hcl
compartment_id = "ocid1.tenancy.oc1..aaaaaaaa..."  # your compartment OCID
namespace      = "your-namespace"                  # your object storage namespace
cluster_name   = "valhalla"                       # kubernetes cluster name
```

### 3. Deploy Infrastructure

```bash
cd envs/prod

# initialize and plan
terraform init
terraform plan

# deploy (takes ~10-15 minutes)
terraform apply
```

### 4. Access the Cluster

Get cluster credentials:
```bash
# export talosconfig
terraform output -raw client_configuration > talosconfig
export TALOSCONFIG=./talosconfig

# get load balancer IP
LB_IP=$(terraform output -raw load_balancer_ip)

# verify Talos cluster
talosctl get members --nodes $LB_IP
talosctl health --nodes $LB_IP

# get Kubernetes access
talosctl kubeconfig --nodes $LB_IP
kubectl get nodes
```

## Project Structure

```
oracle-talos/
├── envs/
│   └── prod/                 # prod env
│       ├── main.tf          # module integration
│       ├── variables.tf     # env variables
│       ├── terraform.tfvars # vars
│       └── providers.tf     # OCI + Talos providers
├── modules/
│   ├── storage/             # object storage + image upload
│   ├── network/             # VCN + Load Balancer
│   └── compute/             # VMs + Talos bootstrap
├── images/                  # converted Talos images
├── files/                   # metadata and configs
└── scripts/                 # helper scripts
```

## Docs

- **Talos Documentation**: [talos.dev](https://www.talos.dev/)
- **Oracle Cloud Free Tier**: [oracle.com/cloud/free](https://www.oracle.com/cloud/free/)
