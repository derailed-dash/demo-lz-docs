---
title: "Patching and Upgrades"
menuTitle: "7. Patching and Upgrades"
weight: 20
---

## Page Contents

- [The Need for Patching and Upgrades](#the-need-for-patching-and-upgrades)
- [Google Managed Services](#google-managed-services)
- [Google Kubernetes Engine (GKE)](#google-kubernetes-engine-gke)
- [Unmanaged Services](#unmanaged-services)

## The Need for Patching and Upgrades

It is essential that we keep our platforms and software current. This is in order to:

- Keep our software patched against any known security vulnerabilites.
- Avoid falling so far behind that upgrading becomes costly and infeasible.
- Be able to leverage vendor SLAs, and to meet our own internal recovery time objectives (RTOs).
- Be able to benefit from new features.
- Limit technical debt.

Note: there is some overlap between the terms _patching_ and _upgrading_.  Typically:

- **Patching** is typically about applying a software update that addresses a specific vulnerability or vulnerabilities, or a specific defect. Patching may cause an increment in the software's minor version number. (E.g. 4.1.2 --> 4.1.3.)
- **Upgrading** is typically a more significant software update. It may result in the remediation of many vulnerabilities or defects; it may introduce significant changes in functionality; it may _roll-up_ several previous patches. It will typically increment software's major version number. (E.g. 4.1 --> 4.2.)

Regardless of whether an update is considered patching or upgrading, the underlying approach and mechanisms are typically similar. Consequently, for the rest of this content, they will always be treated as the same thing.

## Google Managed Services

Resources that are fully-managed by Google (such as Cloud Run, App Engine, Cloud Storage, Cloud SQL, Cloud BigQuery, Cloud Pub/Sub, Cloud Load Balancing, Cloud KMS, Cloud Container Registry) will be **patched and upgraded by Google**. This is typically transparent to the tenant. However, maintenance windows will sometimes need to be specified. E.g. for Cloud SQL instances.

## Google Kubernetes Engine (GKE)

- The GKE Control Plane is patched and upgraded by Google. This is completely transparent to any tenant.
- GKE nodes (i.e. the servers where workloads are hosted) are also automatically upgraded by Google.  
  - This includes upgrading the operating system, and Kubernetes itself.
  - This is typically non-disruptive to tenants, since we limit the number of nodes that can be upgraded in parallel. Standard K8s workload scheduling ensures that workloads remain available even when worker nodes are unavailable.
- We use Google [Release Channels](https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels) to determine when our GKE clusters are upgraded:
  - **Non-Production (Flex and Sandbox) clusters** are enrolled in the _Regular_ release channel. This means that these servers will typically be upgraded at least 3 months after the Kubernentes release has reached _general availability_.
  - **Production clusters are enrolled in the _Stable_ release channel.** This means that these servers will typically be upgraded **2-3 months later than the Non-Prod servers.**
  - Upgrades can be rolled back, if required.

## Unmanaged Services

This typically refers to IaaS-type products. For example, Google Compute Engine (GCE) provides virtual machine instances on Google Cloud; but the **patching and upgrading of all software on those instances - including operating systems, application servers, self-managed databases - is _our_ responsibility**.

#### Image Baking

To ensure that we always use secure, CIS-compliant, patched operating system images, we start by taking a standard [CIS-compliant](https://cloud.google.com/container-optimized-os/docs/how-to/cis-compliance) hardened [Shielded VM image](https://cloud.google.com/compute/shielded-vm/docs/shielded-vm) from Google.

We then apply some additional EPAM configuration, using Hashicorp Packer.  The result is a CIS-compliant, EPAM _gold_ image for a given OS.

{{<mermaid align="left">}}
graph LR
    GImg[Google CIS-Compliant<br /> Shielded VM Image] -- Packer --> EPAMImg[EPAM CIS-Compliant<br />Gold Image]
    EPAMImg -- Push --> GImgSt[Google Image Storage]

    classDef default fill:#2874A6,stroke:#555,color:white;    
    linkStyle default fill:none,color:black;
{{< /mermaid >}}

This process is automatic through a CI/CD pipeline, resulting in our images being refreshed on a weekly basis.

#### Deploying Instances

We are now able to build GCE instances (VMs) from our image.  On ECP, our security policy will only permit the use of _Shielded VM images_.  I.e. Google images that are already in the _Shielded_ category, or EPAM CIS-compliant gold images.

{{<mermaid align="left">}}
graph LR
    GImg[EPAM/Google CIS-Compliant<br /> Shielded VM Image] -- "Deploy<br />instance" --> GCE[GCE Instance]
    GCE -- "Apply<br/> Startup Script" --> GCE_Ans[GCE Instance<br /> registered with Ansible]
    GCE_Ans -- "Apply<br/> agents and patches" --> GCE_Go[Instance<br />Ready for Use]

    classDef default fill:#2874A6,stroke:#555,color:white;    
    linkStyle default fill:none,color:black;
{{< /mermaid >}}

#### Patching

- Ansible will push any updates to built instances on a routine schedule.  
- Non-prod instances are always patched before prod instances.

#### Image Refresh

Twice yearly, any deployed instances will be destroyed and recreated, using the latest version of the OS image.