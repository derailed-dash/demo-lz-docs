---
title: "DR003: Networking in GCP IaaS solution"
menuTitle: "DR003: Networking in GCP IaaS solution"
---

## Status

Proposed

## Authors

Steve Tolson, Paul Todd, Vishal Vadia, Simon Miller

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| << reviewer 1 >>            | DD/MM/YYYY  |

---

## Decision

There have been a number of decisions that form the network solution for the IaaS deployments. There are:

* Use Shared VPC to have a host project acting as a hub for central control for subnet allocation and firewalls. VMs are deployed in service (spoke) projects that then attach to the host project. This attachment will be done as part of the automated project creation.
* To deploy a non-production and production Shared VPC host project.
* To use a single wide subnetwork to be shared by all service (spoke) projects.
* Use Interconnect for network connections back to on-premise infrastructure.
* Use a dedicated VPN inside the host project with a connection to EPAM zScaler service for all VM internet egress.
* Use of a single region, which will be europe-west1 based in Belgium. Subnetworks are regional resources, so this will not span to different regions. VMs can be spread around zones within the region for resiliency.
Use network tags to implement microsegmentation and control for communication between VMs in GCP.
* No external ingress of any kind will be permitted for Interim solution. Established connections that originate from IaaS deployed VM are permitted but these would be subject to controls on the zScaler service.

---

## Context

<< Why is a decision needed? >>

<< What is the problem that needs solving? >>

<< What options were considered before selecting this one? >>

<< Who has been involved? >>

---

## Implications

<< What becomes easier or harder as a result of this change? >>

<< What are the consequences of the decision - e.g. technical debt, delays, cost, later review >>

---

## Subnet allocations

These have been recorded in IPAM by Networking team.

| Non Production   | IP Range     |
| ---------------- |--------------|
| IaaS VM Subnet   | 10.3.34.0/23 |
| Infrastructure   | 10.3.32.0/24 |


| Production       | IP Range     |
| ---------------- |--------------|
| IaaS VM Subnet   | 10.4.34.0/23 |
| Infrastructure   | 10.4.32.0/24 |
