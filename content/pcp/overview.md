---
title: "ECP Overview"
menuTitle: "ECP Overview"
weight: 5
---

## Page Contents

- [What is ECP?](#what-is-ECP)
- [Motivation for ECP](#motivation-for-ECP)
- [Useful Links](#useful-links)

## What is ECP

ECP is our strategic enterprise **EPAM Cloud Platform**.  It is a GCP-based platform, intended for the hosting of off-the-shelf products, packages, and as a migration target for existing VM-based on-prem workloads. These workloads can be Internet-facing, internally-facing, or both. (ECP has previously been known as other names, including _PSEG_, and the _Partnership Strategic GCP Hybrid Cloud_.)

## Motivation for ECP

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

ECP wraps these standard Google Cloud services with:

- A **landing zone** and **(Google) project factory**, providing a repeatable and consistent way to deploy cloud services, using standardised tools, monitoring, preferred patterns, and repeatable infrastructure-as-code.
- Default **security policies**, to meet the enterprise needs of EPAM.
- **Enforced use of automation**, to prevent configuration drift and inconsistency, and to ensure agility.
- Private, SLA-backed high bandwidth, low latency **connectivity** to on-premises data centre networks, for use cases that need it.  (E.g. for routine high volume data transfer.) 
- **Identity and access management** that is integrated with our existing on-prem master identity provider, Active Directory.
- Pre-designed and validated **DR capability** and patterns.  Google’s London region is used for ‘primary’ environments, with Netherlands as the ‘DR’ region.
- A standardised, centralised approach to **billing and cost attribution**.
- A standardised, centralised approach to **operational support**.
- Policy-enforced standardised **CIS-compliant operating system images**.
- Standardised automation to create **single-tenant and multi-tenant Kubernetes** environments, for workloads and packages that can run in containers.

## Useful Links

- [ECP Overview](https://docs.google.com/presentation/d/1HOUBPD_6JQYMeknhn6aEf_4BhGBF8qNTw5lMlckiA8I)
- [ECP Evolution Project - Overview and Familiarisation](https://docs.google.com/presentation/d/1XZgoScNIjp_BL_j5Ku_1M0lerC_J8arsMLpNFeggPrg)