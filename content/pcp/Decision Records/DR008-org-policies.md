---
title: "DR008: Organisation Policies in PIT IaaS"
menuTitle: "DR008: Organisation Policies in PIT IaaS"
---

## Status

Proposed

## Author

Simon Miller, Cloud Infrastructure Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| << reviewer 1 >>            | DD/MM/YYYY  |

---

## Decision

We will be using a number of organisation policies within the IaaS folder.

---

## Context

By default projects get created with a number of default settings that we wish to change.

Organisation policies are a method to enforce a setting. The setting applied to a folder will filter down to any sub-folders or projects created below it. This setting cannot be changed except by blocking the inheritance which can only be carried out by an organisation administrator.

{{% notice info %}}
Organisation policies can be overridden at the folder or project but only by an Organisation Administrator.
{{% /notice %}}
---

## Implications

The policies that have been applied are:

1. Skip default network creation. This has the effect of creating projects without the default network, subnets and firewall rules. Any VPC networks should be created by Platform team members, no default network should exist. It is standard good practice to not have default network in place.

2. Deny external IPs to VMs. This setting has the effect that no VM can ever be creatd with an external IP address. Within the IaaS environment VMs should only have internal IPs, and any external internet egress should go out via VPN to zScaler service.
