---
title: "DR013: Jump Boxes"
menuTitle: "DR013: Jump Boxes"
---

## Status

Accepted

## Author

Adrian Edwards

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| James Hoare                 | 29/09/2019  |

---

## Decision

Four jump-boxes, 2 x Linux and 2 x Windows will be created on-premises for the GCP IaaS platform. There will be no application specific jump-boxes so all application teams will share the same four jump-boxes.

---

## Context

The applications teams may need to access their servers for a variety of operational reasons. To restrict access to application VMs in the GCP IaaS solution there will be a set of on-premises jump-boxes made available to application teams. As application teams only need these jump-boxes to hop between their laptop and application servers many partners will use the jump-boxes at the same time.

A decision is needed so that applications teams have a way to administer their application servers before go into production on the IaaS platform.

---

## Implications

Monitoring will be crucial to ensure these small servers are capable of handling the load that will increase as more and more applications are onboarded. The Windows jump-boxes allow by default for two connections if more connections are required terminal service licenses need to be purchased.

Access for all partners will be through group membership and authenticated via NETDOM accounts for both Windows and Linux. Linux will use the System Security Services Daemon (SSSD) to manage access to remote authentication mechanisms. Application team managers will have a set of groups for their application and will be responsible for managing the membership of these groups which grants access to their application servers through these jump-boxes.

Patching and security fixes will rolled-out through the normal on-premises solution. No new patching policy will be required.

Details of existing jump-boxes can be found ***[here.](../../general/jump-boxes/)***
