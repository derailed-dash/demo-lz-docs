---
title: "Cloud Principles"
menuTitle: "Cloud Principles"
weight: 20
---

Whilst we have many _Technical Architecture Principles_, here are the key principles you should be aware of, when working with cloud.   

{{% notice tip %}}
Following these principles will ensure you get the benefits of cloud.
{{% /notice %}}

{{% notice warning %}}
Conversely, not following these principles will eliminate the many advantages of cloud.
{{% /notice %}}


| Principle | Statement | Rationale |
|-----------|-----------|-----------|
| **Cloud-First** | We are a cloud-first organisation.  Where solutions could equally be deployed on-premises or in public cloud, with no significant differences in cost, public cloud is preferred. |  Moves us towards PAYG, rather than paying lumps of capex. Ensures deployments are automated by default. Leverages cloud scalability and elasticity, which cannot be matched on-premises. Moves us from self-managed to provider-managed services. Reduces our reliance on data centres, helping us achieve data centre exit. Leverages cloud agility. |
| **Prefer managed platforms over DIY in cloud** | Where a fully-managed service is offered in public cloud, this should be used in preference to building and self-managing a similar capability.  For example, prefer using cloud-managed DB-as-a-service, over building IaaS instances and deploying a self-managed database. | Lower operational overhead for provisioning and managing; do not require manual patching; do not typically require specialist engineering capability; typically offer high availability, DR capability, and backup capability, using out-of-the-box configuration; cloud vendor-backed SLAs; typically 'standard' and open source technologies, under the hood. |
| **Prefer free-and-open source (FOSS) over commercial proprietary products** | Prefer an open source solution over a commercial proprietary solution, where an open source solution is established, widely adopted and has strong credentials. | Cheaper; portable; hosting-agnostic (whereas commercial solutions are often not suitable for cloud); often more secure; open standards; more attractive to internal and external talent; avoids vendor lock-in; typically better quality software with faster release cadence. |
| **Automate** | Design with automation from the start, and always build environments using Infrastructure-as-Code (IaC) | Agility; repeatable, consistent environments; avoids configuration drift; self-documenting LLD in the form of version-controlled IaC; avoids human error; can be leveraged in CI/CD pipelines. |
| **Immutable infrastructure** | Outside of sandbox environments, cloud resources should not be modified after they have been built. Instead, always make changes in the IaC and redeploy. | Same benefits as _Automate_ |
| **Prefer cloud-native** | Where a cloud-native capability exists, it should be considered first. | Easily deployed with IaC; typically highly available, elastic, and auto-scaling out of the box; benefits from the rapid evolution of the product; reduces reliance on our own data centres; avoids complex, costly and wasteful integrations, e.g. egress of data from a cloud-hosted application back to the data centre. |