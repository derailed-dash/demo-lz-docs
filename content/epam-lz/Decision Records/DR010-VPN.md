---
title: "DR010: VPN for on-prem connectivity"
menuTitle: "DR010: VPN"
---

## Status

Accepted

## Author

Simon Miller

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Adrian Edwards              | 14/08/2019  |

---

## Decision

A VPN will be used to establish connectivity from on-premise network infrastructure to the GCP Shared VPC host projects.

---

## Context

The VPN was necessary because it was not possible to create an Interconnect due to internal JL funding processes.

Without an Interconnect, a VPN is the only method to route traffic from on-prem to the private address ranges used by VMs in GCP IaaS subnets.

---

## Implications

The largest implication is that the on-prem VPN point of connectivity is hosted on a non-production Palo Alto firewall. The production equivalent is on a Cisco ASA but this is not public facing (using NAT instead) and is not compatible with a GCP VPN. A feature request has been made to Google to allow use of Cisco ASA behind NAT, but this is unlikely to be delivered in the near future.

The GCP VPN is single region (GCP HA VPN is still in Beta) but since the IaaS solution is currently scoped for single region as well that is not an issue for the moment.

Bandwidth is fixed for VPN and does not have the capacity that an Interconnect could offer, but at this early stage that should not be a problem.

We cannot create a dynamic VPN (which uses BGP) due to limitation of on-premise VPN hosting equipment, so there will be no Cloud Router and dynamic learning of new routes.

The initial deployment was always classed as an interim solution, with a fully funded strategic IaaS platform to follow. The strategic solution will hopefully use an Interconnect instead of the VPN.
