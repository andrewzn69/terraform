# Examples

Examples covering common use cases of the `argocd` module.

## Available Examples

| Example         | Description                                          |
| --------------- | ---------------------------------------------------- |
| `default`       | Install ArgoCD using the module's built-in values    |
| `remote-values` | Install ArgoCD with values fetched from a remote URL |

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
argocd_version                    = "<argocd-chart-version>"
kubernetes_host                   = "https://<control-plane-ip>:6443"
kubernetes_client_certificate     = "<client-certificate-pem>"
kubernetes_client_key             = "<client-key-pem>"
kubernetes_cluster_ca_certificate = "<ca-certificate-pem>"
```
