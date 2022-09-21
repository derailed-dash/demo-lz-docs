---
title: "ECP Design Overview"
menuTitle: "Design Overview"
weight: 10
---

## Page Contents

- [Design Overview](#design-overview)
- [Identity and Access Management](#identity-and-access-management)
- [Networking](#networking)
  - [Regions and Zones](#regions-and-zones)
  - [Outbound Internet Connectivity](#outbound-internet-connectivity)
  - [Inbound Connectivity from the Internet](#inbound-connectivity-from-the-internet)
  - [Access to APIs and Services](#access-to-google-apis-and-services)
  - [GKE Control Plane Connectivity](#gke-control-plane-connectivity)
- [Security Overview](#security-overview)
- [Useful Links](#useful-links)

## Design Overview

![ECP Architecture Overview](/images/ECP_architecture_overview.png)

## Organisation Resource Hierarchy

The ECP organisation hierarchy looks like this:

{{<mermaid align="left">}}
graph LR
    ORG[fa:fa-sitemap epam.com] ---> MNG[fa:fa-folder org-mng] & ECP[fa:fa-folder ECP]
    ORG --> EDP[fa:fa-folder EDP]
    ECP --> PRD[fa:fa-folder Prod] & FLEX[fa:fa-folder Flex] & SBOX[fa:fa-folder SandBox]
    PRD --> PRD-PLT[fa:fa-folder Platform] & PRD-A[fa:fa-folder Tenant A] & PRD-B[fa:fa-folder Tenant B]
    PRD-PLT --> PRD-PLT-NET[fa:fa-folder Network] & PRD-SHARED-GKE[fa:fa-folder Shared GKE]
    FLEX --> NPD-PLT[fa:fa-folder Platform] & NPD-A[fa:fa-folder Tenant A] & NPD-B[fa:fa-folder Tenant B]
    NPD-PLT --> NPD-PLT-NET[fa:fa-folder Network] & NPD-SHARED-GKE[fa:fa-folder Shared GKE]
    SBOX --> SBOX-A[fa:fa-folder Tenant A] & SBOX-X[fa:fa-folder Tenant X]
    SBOX-A ---> SBOX-A-1(sbox-tenantA-prj1)
    SBOX-X ---> SBOX-X-1(sbox-tenantX-prj1)
    SBOX ----> TEN-Y(individual-prj)
    MNG -----> M(Billing) & N(Audit) & O(Infra-as-Code)
    PRD-A ---> PRD-A-1(prod-tenantA-prj1) -.- PRD-A-2(prod-tenantA-prj2)
    PRD-B ---> PRD-B-1(prod-tenantB-prj1) -.- PRD-B-2(prod-tenantB-prj2)
    NPD-A ---> NPD-A-1(flex-tenantA-prj1) -.- NPD-A-2(flex-tenantA-prj2)
    NPD-B ---> NPD-B-1(flex-tenantB-prj1) -.- NPD-B-2(flex-tenantB-prj2)
    
    classDef orange fill:#ffa500,stroke:#555;
    classDef darkblue fill:#21618C,color:white;
    classDef blue fill:#2874A6,stroke:#555,color:white;
    classDef lightblue fill:#a3cded,stroke:#555;
    classDef green fill:#276551,color:white,stroke:#555,stroke-width:2px;
    class ORG orange
    class MNG,ECP,EDP darkblue
    class PRD,FLEX,SBOX blue
    class PRD-PLT,PRD-A,PRD-B,SBOX-A,SBOX-X,PRD-PLT-NET,PRD-SHARED-GKE lightblue
    class NPD-PLT,NPD-A,NPD-B,NPD-PLT-NET,NPD-SHARED-GKE lightblue
    class M,N,O,PRD-A-1,PRD-A-2,NPD-A-1,NPD-A-2,PRD-B-1,PRD-B-2,NPD-B-1,NPD-B-2,SBOX-A-1,SBOX-X-1,TEN-Y,TEN-X green
{{< /mermaid >}}

This allows **management and security policies to be applied top down** at any level in the hierarchy.

Notes on this hierarchy:

- The standard **naming convention** for a project is `epam-ecp-{tier}-{tenant}-{project_name}`
- The `tier` can be one of `prod`, `flex` = i.e. any non-production environment, or `sbox` = sandbox
- Ultimately, all resources in GCP are deployed into Google Cloud `projects`.
  - The project is the **basic unit of organisation** of GCP resources.
  - Resources belong to one and only one project.
  - Projects provide **trust and billing boundaries**.
- The `tenant` represents a given _consumer_ of the platform.
  - A tenant is **isolated** from other tenants on the platform.
  - A tenant has significant **autonomy** to deploy their own projects, resources and applicatons, within their own tenancy folders.
  - _"With great power comes great responsibility."_ The tenant is **responsible** for the resources they deploy within their own pojects.
  - A tenant will typically have tenant folders in both `Prod` and `Flex` folders, and `Sbox` if required.

## Identity and Access Management

- ECP resources may only be managed by Google Workspace or Google Cloud Identities, which are tied to the `epam.com` domain.
- Users are mastered on-premise in Active Directory, and synchronised from AD to Google Cloud using one-way Google Cloud Directory Sync (GCDS).
- Identities may be users, groups, the entire domain, or service accounts.
  - Typically, access to resources is not granted to individual accounts, but to groups. Groups in ECP will be named using this **naming convention**: \
  `_gcp-{division}-{platform}-{tier}-{tenant}-{functional_role}`
  - **User identities** are **authenticated** to Google Cloud using **PingIdentity SSO** with multi-factor authentication.
  - **Service accounts** are associated with a given application.  They allow applications and certain GCP services (e.g. GCE instances) to access other GCP services and APIs. Organisational security policies will be enforced to restrict use of security accounts, and to - for example - prevent creation and sharing of service account keys.
  - Note that **provisioning of all resources in all tenant projects (outside of `Sbox`) may only be performed using a dedicated service account**, created by the automated project factory. This is how we enforce our [automation principle](/cloud-first/cloud-principles).
- Identities are given access to cloud resources by assigning **roles**.  A role is a collection of permissions. To ensure the _principle of least privilege_, we will mandate use of granular roles with only appropriate permissions allocated.  This is controlled through security policy.

## Networking

ECP uses a **hub-and-spoke** network architecture:

- **A _common VPC_ network acts as the _hub_**, and hosts centralised networking and security resources. This includes private IP connectivity, via the SLA-backed, high-bandwidth / low-latency _Interconnect_, to the EPAM on-premises network.
- **Tenant projects will have their own _spoke_ VPC network.** Thus, tenants have full automonmy and control over resources deployed within their own VPC.
- Tenants may be _peered_ to the hub shared VPC network. This is how tenants can:
  - Obtain private connectivity to the on-premises network (if appropriate).
  - By funnelled through centralised security tooling when accessing other networks (if appropriate).
- There is expected to be a _shared tenant VPC_ to host, for example, a shared GKE cluster, for those Tenant's who have no specific network requirements. 
- DNS peering will allow Google Cloud resources to perform DNS resolution against on-premises infrastructure, e.g. such that we can resolve hostnames in the `epam.com` domain. 

{{< expand Expand-title="A note on terminology" style="bold" >}}

The previous iteration of ECP (v1) was built around a **_Shared VPC_** which provided Subnets and Interconnect services for Tenant _service Projects_.

The **Shared VPC** name has [an explicit meaning with regards GCP](https://cloud.google.com/vpc/docs/shared-vpc), so for the avoidance of doubt:

- ECPv2's central Hub project will be referred to as the _common VPC_, and will provide (via VPC-peering) Interconnect connectivity.
- Tenant's will receive their _tenant VPC_ as part of the Tenant Factory / Onboarding process.
- The _shared tenant VPC_ will be used for tenants with no specific network requirements.

{{< /expand >}}

Conceptually, it looks like this:

![Hub and Spoke Network Architecture](/images/hub-and-spoke.png?width=800)

{{% notice info %}}
The Hub-and-Spoke design exists in Production, and is replicated in Non-Production.  Thus, there are actually two hubs, each with a common VPC, and each providing Interconnect-based connectivity to the on-premises network.
{{% /notice %}}

### Regions and Zones

{{% notice info %}}
**Regions** are independent geographic areas (typically sub-continents), made up of multiple zones. \
**Zones** are effectively data centre campuses, with each zone separated by a few km at most. A zone can be considered a single independent failure domain within a given region.
{{% /notice %}}

High-availability is achieved by deploying resources across more than one zone within a region. Consequently, production resources in ECP should generally be deployed using regional resources, rather than zonal, where possible.

However, deployment across multiple zones within a single region is insufficient to safeguard against a major geographic disaster event.  For this reason, any application that requires diaster recovery capability will need to be deployable across two separate regions.  To support this requirement, ECP has connectivity to on-premises out of two separate regions:

- Primary region: London (`europe-west2`)
- Standby region: Netherlands (`europe-west4`)

### Outbound Internet Connectivity

Outbound connectivity from Google resources to the Internet is routed through EPAM Zscaler VPN. This allows centralised application of security controls.

### Inbound Connectivity from the Internet

{{% notice info %}}
Google Compute Engine (GCE) instances will only be given private IP addresses; they will **never be given external IP addresses**. Consequently, these instances are not directly reachable from any external network; this includes from the Internet.
{{% /notice %}}

Consequently, if external access is required to a ECP-hosted service, this **must be achieved via a load balancer**.  Routing inbound traffic through a load balancer means:

- The load balancer acts as a reverse proxy; external clients only see the public IP address of the load balancer.
- Internal resources do not need external IP addresses.
- Layer 7 firewalling (WAF) can be applied at the load balancer using _Cloud Armor_. This products mitigates a number of OWASP threats out-of-the-box.
- Identity-level access control can be applied on an application basis, using the Cloud _Identity-Aware Proxy (IAP)_.

### Access to Google APIs and Services

Google Private Access is enabled on all ECP VPC networks.  This allows instances with no external IP address to connect to Google APIs and services, such as BigQuery, Container Registry, Cloud Datastore, Cloud Storage, and Cloud Pub/Sub.

### GKE Control Plane Connectivity

Connectivity between GKE cluster "worker" nodes and the cluster's control plane will be achieved using VPC network peering.

![K8S peering between workers and control plane](/images/k8s-control-plane-peering.jpg)

## Security Overview

- To adhere to the **principle of least privilege**, **Google IAM** is used to assign curated and custom roles to Google _groups_.
  - Roles are granted only to groups; not to user.
  - Basic (aka _primitive) roles are disallowed; they do not provide sufficient granularity.
  - Any changes to roles, groups or IAM policy is audited.
  - Audit logs exposed using the Security Command Centre.
- A number of **organisation security policies** are applied top down. These restrict the ability to perform some actions.  For example, some of the policies applied ensure that:
  - Public (external) IP addresses cannot be assigned to compute instances.
  - Public IP addresses cannot be assigned to Cloud SQL instances.
  - _Default_ VPC networks can not be created. Thus, tenants may only create custom networks, in specified regions.
  - Service account keys may not be created or uploaded.
  - _OS Login_ is enforced, ensuring that SSH access to instances is done using IAM-controlled Google identities, with secure Google-management of SSH keys. This circumvents the need to store and manage SSH keys independent of the instances.
- **Secure access to private resources** (such as GCE instances or Kubernetes control plane) will be done using a **_secure bastion host_ pattern**, which utilises OS Login and the Identity-Aware Proxy, such that only authorised users can connect. For example, where there is a need for a tenant to administer any instances using SSH, this is the pattern you will be used.
- **External HTTPS access** to internal resources is only possible via the HTTPS load balancer.  This ensures external clients have no visibility of internal IP addresses.
- **Connectivity to the Internet** is routed through the Zscaler Internet Access gateway. 
- Additionally, **web application firewall rules** and allow-lists can be applied at the LB, using Google Cloud Armor.
- Google Compute Engine (GCE) instances will only be built using **[shielded VMs](https://cloud.google.com/compute/shielded-vm/docs/shielded-vm)** using the [Centre for Internet Security (CIS)-compliant](https://www.cisecurity.org/) VM images. Off-the-shelf Google images that offer shielded CIS-compliant variants can be seen [here](https://cloud.google.com/compute/docs/images/os-details#security-features)
- GCE instances (including GKE nodes) are kept current through the **automatic update of underlying images**, and automatic recreation of instances to use new images.
- **Google Kubernetes Engine (GKE) clusters will always be private**, and thus will only be accessible using internal private IP addresses. Additionally, the control plane will only be exposed using a private endpoint.
- **GKE clusters are hardened:**
  - Basic (username/password) authentication is not permitted.
  - Network policies limit connectivity between namespaces in the cluster. Exceptions must be explicitly configured. This limits lateral movement within a Kubernetes cluster.
  - Workload identity ensures granular control of access to Google services and APIs.
  - Cloud IAM and Kubernetes Role Based Access Controls (RBAC) are used to control access to Kubernetes objects.
- **Google Security Command Centre (SCC)** provides a single centralised platform for aggregating and viewing security information. This includes:
  - Automatic detection of threats, vulnerabilities, misconfigurations, and drift from secure configurations.
  - Anomaly detection, e.g. for detection of behaviour that might signal malicious activity.
  - Web security scanning
  - Container threat detection
  - Reporting of potential sensitive and PII data.
  - Reporting of VPC service controls.
  - Compliance management.
  - Actionable security recommendations.
  
## Useful Links

- [ECP v1 High Level Design (HLD)](https://docs.google.com/document/d/1uUTn3oCY4JxPbjpVg0vB6iPhoWoiYa8ZeMbtpmlHHsM/edit)
- [ECP v2 Technical Design Document (TDD)](https://docs.google.com/document/d/1ARJV994vCIv20Oc6QTC6vDxA3pdNHRgFjxjggPwZYSU/edit?hl=en-GB&forcehl=1)
