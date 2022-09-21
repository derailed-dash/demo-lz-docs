---
title: "DR011: Virtual Machine Rebuilds"
menuTitle: "DR011: Virtual Machine Rebuilds"
---

## Status

Accepted

## Author

James Hoare, Cloud Infrastructure Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Adrian Edwards              | 19/08/2019  |

---

## Decision

We've decided as a group that the default cycle for VM rebuilds will be such that Non Production instances will be re-built on a weekly basis and Production instances will be re-built on a monthly basis.

It is recognised that this may not fit all use cases and therefore any use cases that don't fit this pattern can be considered during the onboarding of that case.

---

## Context

This decision is required as we need a standardised patching policy across the GCP IaaS estate. This decision record solves the problem of patching IaaS machines in our GCP bases IaaS Platform.

A Patching policy similar to on prem could also be adopted, however a cloud native approach should be used where possible.

This has been discussed and agreed by the following people

| Name                        | Role                            |
| --------------------------- |---------------------------------|
| James Hoare                 | Cloud Infrastructure Engineer   |
| Simon Miller                | Cloud Infrastructure Engineer   |
| Ian Harris                  | Cloud Infrastructure Engineer   |
| Adrian Edwards              | Cloud Infrastructure Engineer   |
| Adam Meszaros               | Infrastructure Delivery Manager |
| Steve Tolson                | Infrastructure Architect        |

---

## Implications

This decision should allow patching to become fully automated across all machines following this policy. By tearing the machines down and re-building them on a regular basis they will pick up any patches/updates from the image each time they're rebuilt and therefore don't need to be patched in place.

This policy does however have the potential to be insuitable for certain applications. It's expected that there may therefore eventually be a mixture of patching methods used in the IaaS platform dependant on the requirements of the application. This will make patching harder down the road as different applications may need to be treated differently. This can be addressed as and when the first use case comes along where this policy is sunsuitable.
