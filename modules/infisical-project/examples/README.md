# Examples

Examples covering common use cases of the `infisical-project` module.

## Available Examples

| Example                            | Description                                       |
| ---------------------------------- | ------------------------------------------------- |
| `default`                          | Create a single project with flat folders         |
| `multiple-projects-nested-folders` | Create multiple projects with nested folder paths |

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
infisical_client_id     = "<machine-identity-client-id>"
infisical_client_secret = "<machine-identity-client-secret>"
org_id                  = "<organization-id>"
```
