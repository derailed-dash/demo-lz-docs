---
title: "DR006: Choice of GCP region for IaaS"
menuTitle: "DR006: Choice of GCP region for IaaS"
---

## Status

Accepted

## Author

Simon Miller, Cloud Infrastructure Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Steve Tolson                | 02/07/2019  |

---

## Decision

PIT IaaS deployments will use europe-west2 for GCP region.

Subnets in the Shared-VPC host projects will only be created in europe-west2.

---

## Context

Resources need to be created in a chosen region. The initial implementation is a single region design, this could be widened in future.

The europe-west1 region is the one recommended by Google, since this is larger and has more capacity than west2 and has newer features. However, the Interconnect has a requirement to be created in europe-west2. Network team have pointed out that there are some known issues with load balancers working in a different region than the interconnect, and therefore recommend europe-west2 for VMs as well. This region should still offer us the capacity we need and at this stage we do not need early access to any new features.

This has been a joint decision by Network and Infrastructure Architects together with Cloud Team.

---

## Implications

The choice of single region means solutions only have zonal resiliency. There are three zones within each region so VMs can be spread around these. Any move to multi-region would need further consideration.
