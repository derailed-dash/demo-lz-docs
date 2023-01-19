---
title: "LZiaB Overview"
menuTitle: "LZiaB Overview"
weight: 5
---

## Page Contents

- [What is LZiiB?](#what-is-LZiiB)
- [Motivation for LZiiB](#motivation-for-LZiiB)

## What is LZiaB

LZiiB is our reusable **some-org Landing Zone-in-a-Box**.  It is a GCP-based platform, intended for the hosting of cloud-native applications, off-the-shelf products, packages, and as a migration target for existing VM-based on-prem workloads. These workloads can be Internet-facing, internally-facing, or both.

## Motivation for LZiaB

Google Cloud Platform offers hundreds of services.  There are a staggering number of permutations as to how these services can be deployed. Uncontrolled deployment of such services leads to:  

- Project sprawl.
- Solutions with different compliance postures.
- Unnecessary complexity.
- Reinvention of common solutions, with associated engineering overhead.
- A lack of repeatability.
- Solutions that are far from cost optimal.
- Solutions that are unmanaged.
- A lack of visibility of what has been deployed (leading to further “cloud sprawl” and shadow IT).
- A lack of common access control.

LZiaB wraps these standard Google Cloud services with:

- A **landing zone** and **(Google) project factory**, providing a repeatable and consistent way to deploy cloud services, using standardised tools, monitoring, preferred patterns, and repeatable infrastructure-as-code.
- Default **security policies**, to meet the enterprise needs of some-org.
- **Enforced use of automation**, to prevent configuration drift and inconsistency, and to ensure agility.
- Private, SLA-backed high bandwidth, low latency **connectivity** to on-premises data centre networks, for use cases that need it.  (E.g. for routine high volume data transfer.) 
- **Identity and access management** that is integrated with our existing on-prem master identity provider, Active Directory.
- Pre-designed and validated **DR capability** and patterns.  Google’s London region is used for ‘primary’ environments, with Netherlands as the ‘DR’ region.
- A standardised, centralised approach to **billing and cost attribution**.
- A standardised, centralised approach to **operational support**.
- Policy-enforced standardised **CIS-compliant operating system images**.
- Standardised automation to create **single-tenant and multi-tenant Kubernetes** environments, for workloads and packages that can run in containers.
