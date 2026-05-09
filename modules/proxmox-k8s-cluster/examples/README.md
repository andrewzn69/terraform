# Examples

Examples covering common use cases of the `k8s-cluster` module.

## Available Examples

| Example        | Description                                                      |
| -------------- | ---------------------------------------------------------------- |
| `single-node`  | One Proxmox node running both control plane and worker VMs       |
| `multi-node`   | Control plane and workers on separate Proxmox nodes              |
| `ha-cluster`   | Control planes spread across multiple nodes for high availability |

## Running an Example

1. Change into the example directory:
```sh
cd examples/<example-name>
```

2. Copy the example tfvars file:
```sh
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` with your values

4. Initialize Terraform:
```sh
terraform init
```

5. Review the plan:
```sh
terraform plan
```

6. Apply:
```sh
terraform apply
```

## Required Variables

All examples expect these variables:

```hcl
proxmox_endpoint  = "https://PROXMOX-IP:8006"
proxmox_api_token = "USER@REALM!tokenid=TOKEN_SECRET"
proxmox_insecure  = true
```

- `proxmox_insecure` - set to false if your Proxmox API endpoint has a valid TLS certificate
- `proxmox_api_token` - create one in Proxmox under Datacenter > Permissions > API Tokens, format is `<user>@<realm>!<tokenid>=<token_secret>`
