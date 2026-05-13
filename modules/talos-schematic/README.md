# talos-schematic

Terraform module for generating a Talos Linux image schematic and resolving image URLs from the Talos image factory.

This module can:
- create a schematic with optional extensions, kernel args and bootloader configuration
- resolve ISO, disk image and installer image URLs for any platform and architecture
- support secureboot variants

## Requirements

- Terraform ~> 1.15
- siderolabs/talos ~> 0.11.0

## Usage

```hcl
terraform {
  required_version = "~> 1.15"

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.11.0"
    }
  }
}

provider "talos" {}

module "talos_schematic" {
  source = "github.com/andrewzn69/terraform//modules/talos-schematic"

  talos_version        = "<talos-version>"
  platform             = "<platform>"
  architecture         = "<amd64 | arm64>"
  secureboot           = <true | false>
  schematic_extensions = ["siderolabs/<schematic-extension-name>"]
}
```

## Examples

See the [examples](./examples/) directory for complete working configurations.
