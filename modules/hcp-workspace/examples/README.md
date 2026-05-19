# Examples

Examples covering common use cases of the `hcp-workspace` module.

## Available Examples

| Example  | Description                                                  |
| -------- | ------------------------------------------------------------ |
| `agent`  | Workspace running on a self-hosted agent pool with variables |
| `remote` | Workspace running on HCP's own runners                       |

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
tfe_token                  = "<hcp-terraform-api-token>"
organization               = "<organization>"
vcs_repo_identifier        = "<org>/<repo>"
github_app_installation_id = "<installation-id>"
```
