[![License](https://img.shields.io/github/license/peterpramb/terraform-hcloud-floating-ips)](https://github.com/peterpramb/terraform-hcloud-floating-ips/blob/master/LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/peterpramb/terraform-hcloud-floating-ips?sort=semver)](https://github.com/peterpramb/terraform-hcloud-floating-ips/releases/latest)
[![Terraform Version](https://img.shields.io/badge/terraform-%E2%89%A5%200.13.0-623ce4)](https://www.terraform.io)


# terraform-hcloud-floating-ips

[Terraform](https://www.terraform.io) module for managing floating IPs in the [Hetzner Cloud](https://www.hetzner.com/cloud).

It implements the following [provider](#providers) resources:

- [hcloud\_floating\_ip](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip)
- [hcloud\_floating\_ip\_assignment](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip_assignment)
- [hcloud\_rdns](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/rdns)


## Usage

```terraform
module "floating_ip" {
  source       = "github.com/peterpramb/terraform-hcloud-floating-ips?ref=<release>"

  floating_ips = [
    { 
      name          = "fip4-nbg1-1"
      home_location = "nbg1"
      type          = "ipv4"
      description   = "Floating IPv4 address"
      dns_ptr       = "svc.example.net"
      dns_ptr6      = []
      server        = {
        "name" = "server-1"
        "id"   = "7569968"
      }
      labels        = {
        "managed"    = "true"
        "managed_by" = "Terraform"
      }
    },
    { 
      name          = "fip6-nbg1-1"
      home_location = "nbg1"
      type          = "ipv6"
      description   = "Floating IPv6 /64 network"
      dns_ptr       = null
      dns_ptr6      = [
        ["svc.example.net", "1:2:3:100"]
      ]
      server        = {
        "name" = "server-1"
        "id"   = "7569968"
      }
      labels        = {
        "managed"    = "true"
        "managed_by" = "Terraform"
      }
    }
  ]
}
```

See [examples](https://github.com/peterpramb/terraform-hcloud-floating-ips/blob/master/examples) for more usage details.


## Requirements

| Name | Version |
|------|---------|
| [terraform](https://www.terraform.io) | &ge; 0.13 |


## Providers

| Name | Version |
|------|---------|
| [hcloud](https://registry.terraform.io/providers/hetznercloud/hcloud) | &ge; 1.20 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| floating\_ips | List of floating IP objects to be managed. | list(map([*floating\_ip*](#floating_ip))) | See [below](#defaults) | yes |


#### *floating\_ip*

| Name | Description | Type | Required |
|------|-------------|:----:|:--------:|
| [name](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip#name) | Unique name of the floating IP. | string | yes |
| [home\_location](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip#home_location) | Location of the floating IP. | string | yes |
| [type](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip#type) | Type of the floating IP. | string | yes |
| [description](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip#description) | Description of the floating IP. | string | no |
| [dns\_ptr](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/rdns#dns_ptr) | The DNS name the IPv4 address should resolve to. | string | no |
| dns\_ptr6 | The DNS name(s) the IPv6 address(es) should resolve to. | list(tuple([*dns\_ptr6*](#dns_ptr6)) | no |
| server | Inputs for server assignment. | map([*server*](#server)) | no |
| [labels](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip#labels) | Map of user-defined labels. | map(string) | no |


#### *dns\_ptr6*

| Index | Description | Type | Required |
|:-----:|-------------|:----:|:--------:|
| \[0] | The DNS name the IPv6 address should resolve to. | string | yes |
| \[1] | The *host* part of the IPv6 address. | string | yes |


#### *server*

| Name | Description | Type | Required |
|------|-------------|:----:|:--------:|
| [name](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#name) | Name of the server to assign the floating IP to. | string | yes |
| [id](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/floating_ip_assignment#server_id) | ID of the server to assign the floating IP to. | string | yes |


### Defaults

```terraform
floating_ips = [
  {
    name          = "fip4-nbg1-1"
    home_location = "nbg1"
    type          = "ipv4"
    description   = null
    dns_ptr       = null
    dns_ptr6      = []
    server        = null
    labels        = {}
  }
]
```


## Outputs

| Name | Description |
|------|-------------|
| floating\_ips | List of all floating IP objects. |
| floating\_ip\_ids | Map of all floating IP objects indexed by ID. |
| floating\_ip\_names | Map of all floating IP objects indexed by name. |
| floating\_ip\_rdns | List of all floating IP RDNS objects. |
| floating\_ip\_rdns\_ids | Map of all floating IP RDNS objects indexed by ID. |
| floating\_ip\_rdns\_names | Map of all floating IP RDNS objects indexed by name. |
| floating\_ip\_assignments | List of all floating IP assignment objects. |
| floating\_ip\_assignment\_ids | Map of all floating IP assignment objects indexed by ID. |
| floating\_ip\_assignment\_names | Map of all floating IP assignment objects indexed by name. |


### Defaults

```terraform
floating_ips = [
  {
    "assignment" = {}
    "description" = ""
    "home_location" = "nbg1"
    "id" = "342748"
    "ip_address" = "192.0.2.1"
    "labels" = {}
    "name" = "fip4-nbg1-1"
    "rdns" = []
    "type" = "ipv4"
  },
]

floating_ip_ids = {
  "342748" = {
    "assignment" = {}
    "description" = ""
    "home_location" = "nbg1"
    "id" = "342748"
    "ip_address" = "192.0.2.1"
    "labels" = {}
    "name" = "fip4-nbg1-1"
    "rdns" = []
    "type" = "ipv4"
  }
}

floating_ip_names = {
  "fip4-nbg1-1" = {
    "assignment" = {}
    "description" = ""
    "home_location" = "nbg1"
    "id" = "342748"
    "ip_address" = "192.0.2.1"
    "labels" = {}
    "name" = "fip4-nbg1-1"
    "rdns" = []
    "type" = "ipv4"
  }
}

floating_ip_rdns = []

floating_ip_rdns_ids = {}

floating_ip_rdns_names = {}

floating_ip_assignments = []

floating_ip_assignment_ids = {}

floating_ip_assignment_names = {}
```


## License

This module is released under the [MIT](https://github.com/peterpramb/terraform-hcloud-floating-ips/blob/master/LICENSE) License.
