---
title: "DR016: Ansible Integration"
menuTitle: "DR016: Ansible Integration"
---

## Status

<< Proposed >>

## Authors

Tom Moore, Infrastructure Engineer, Automation Team

Simon Miller, Infrastructure Engineer, Cloud Team

James Hoare, Infrastructure Engineer, Cloud Team

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| << reviewer 1 >>            | DD/MM/YYYY  |
| << reviewer 2 >>            | DD/MM/YYYY  |
| << reviewer 3 >>            | DD/MM/YYYY  |

---

## Decision

A service account will be created that will be used to scan GCP projects for VMs, which will then build the Ansible host inventory.

The account will be created in Iaas devops project, and will be assigned the minimum permissions necessary to list VMs. There will be one Ansible Compute Reader service account that will have the permissions on IaaS Prod and Non-Prod folders.

Currently there will be one inventory to cover all of IaaS, though there has been discussion around whether there should be seperate inventories for prod & non prod environments.

---

## Context

Ansible Tower has been chosen as the automation tool to configure in-guest Operating System configuration.

Ansible Tower will maintain it's own host inventory of all IaaS VMs. VMs need to exist in this inventory in order for playbooks to be run against them. The current method of deploying a VM from GitLab CI involves a callback to Ansible Tower, to re-scan projects for VMs so they appear in inventory before playbooks are run.

A more detailed doc on [GCP Build Orchestration Options](https://docs.google.com/document/d/1wsaSno6TyAbwMAMnEzktj9UYcpAV6hR0e8aFQfbjIRA/edit) has been written by Tom Moore.

---

## Implications

Once the service account is available, then Ansible Tower will have capability to scan projects and keep the Inventory up to date without manual intervention (which would be slower, more manual and more open to human error.
)

The inventory script was unable to point at anything above the project level. In order to have one inventory this would mean updating the inventory paramters everytime a new project is spun up. To solve this, We've edited the script ourselves to allow it to be pointed at a folder. This could become problematic to maintain.
