# Examples

Examples covering common use cases of the `talos-schematic` module.

## Available Examples

| Example                                        | Description                                                         |
| ---------------------------------------------- | ------------------------------------------------------------------- |
| `proxmox-amd64`                                | Vanilla amd64 schematic for Proxmox                                 |
| `aws-amd64-with-extensions`                    | AWS amd64 schematic with ENA and ECR credential provider extensions |
| `oracle-arm64`                                 | Oracle Cloud arm64 schematic                                        |
| `metal-secureboot-arm64-extensions-kernelargs` | Bare metal ARM64 with secureboot, extensions and custom kernel args |

## Running an Example

1. Change into the example directory:
```sh
cd examples/<example-name>
```

2. Copy the example tfvars file:
```sh
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` with your value(s)

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

All examples expect this variable:

```hcl
talos_version = "<talos-version>"
```
