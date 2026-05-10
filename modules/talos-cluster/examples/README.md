# Examples

Examples covering common use cases of the `talos-cluster` module.

## Available Examples

| Example                     | Description                                                        |
| --------------------------- | ------------------------------------------------------------------ |
| `single-node`               | One control plane and one worker node, minimal configuration      |
| `ha-cluster`                | Three control planes and multiple workers for high availability    |
| `custom-cni-and-extensions` | Single-node setup with schematic extensions and a custom CNI patch |

## Running an Example

1. Change into the example directory:
```sh
cd examples/<example-name>
```

2. Copy the example tfvars file:
```sh
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` with your values.

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
control_plane_ips = ["<control-plane-ip>"]
worker_ips        = ["<worker-ip>"]
talos_version     = "<talos-version>"
cluster_name      = "<cluster-name>"
cluster_endpoint  = "https://<control-plane-ip>:6443"
node_subnet       = "<subnet-cidr>"
```
