---
title: "Your Tenancy"
menuTitle: "4. Your Tenancy"
weight: 10
---

## Page Contents

- [Tenant Factory Overview](#tenant-factory-overview)
- [Tenant Folders and Projects](#tenant-folders-and-projects)
- [Default Tenant Groups](#default-tenant-groups)
- [Tenant Networking](#tenant-networking)
- [Service Account](#service-account)
- [Google Kubernetes Engine (GKE) Clusters](#google-kubernetes-engine-gke-clusters)
- [Your GitLab and Infrastructure Code](#your-gitlab-and-infrastructure-code)
- [Creating More Projects](#creating-more-projects)
- [Accessing Your Internal Resources](#accessing-your-internal-resources)

## Tenant Factory Overview

Following your [tenancy request](/ECP/onboarding/getting-started#how-to-raise-a-tenancy-request), you will be established in ECP as a new **tenant**.  This approaches allows you - as a tenant - to be responsible for deploying and managing your own resources within your Google projects. Thus increases your agility, and reduces dependency on the central Cloud Platform Team.

The automated **tenant factory** will generate a set of resources for you, in the ECP environment. This includes:

- Your **tenant folder** in the Google resource hiearchy.
- Your **_Prod_, Non-Prod (_Flex_) and _Sandbox_ folders**.
- An initial **_spoke_ VPC network** in each of _Prod_ and _Flex_.
- **Peering** of your _spoke_ networks **to the appropriate _Hub_ network**.
- An optional **_bastion host_** in each _spoke_ VPC, secured with the Identity-Aware Proxy (IAP).
- An initial **monitoring dashboard**, which can be enhanced to your needs.
- **Service accounts** against each of the _Prod_ and _Flex_ folders, with required permissions to deploy resources under these folders.
- Tenant **IAM groups** with appropriate roles attached.
- A **project factory code example** - i.e. Terraform IaC - to help tenants create additional projects in their tenancy.
- **Fabric module examples** - i.e. Terraform IaC - to help tenants get started in deploying resources to their projects.

## Tenant Folders and Projects

As a new tenant, folders will be created for you in each of the _Prod_, _Flex_, and _Sandbox_ folders. Under each of these, an initial project will be created for you. You will be able to create more projects with your service account, in your tenancy.

{{<mermaid align="left">}}
graph LR
    org.com --> PRD[fa:fa-folder Prod] & FLEX[fa:fa-folder Flex] & SBOX[fa:fa-folder SandBox]
    PRD --> PRD-PLT[fa:fa-folder Platform] & PRD-A[fa:fa-folder Tenant A] & PRD-B[fa:fa-folder Tenant B]
    FLEX --> NPD-PLT[fa:fa-folder Platform] & NPD-A[fa:fa-folder Tenant A] & NPD-B[fa:fa-folder Tenant B]
    SBOX --> SBOX-A[fa:fa-folder Tenant A] & SBOX-X[fa:fa-folder Tenant X]
    subgraph TEN-PRD["."]
      PRD-A ---> PRD-A-1(prod-tenantA-prj1)
      PRD-A-1 -.- PRD-A-2(prod-tenantA-prj2)   
    end
    subgraph TEN-NPD["."]
      NPD-A ---> NPD-A-1(flex-tenantA-prj1)
      NPD-A-1 -.- NPD-A-2(flex-tenantA-prj2)
    end
    subgraph TEN-SBOX["."]
      SBOX-A ---> SBOX-A-1(sbox-tenantA-prj1)
    end   
    
    classDef grey fill:#aaaaaa,stroke:#555;
    classDef orange fill:#ffa500,stroke:#555;
    classDef darkblue fill:#21618C,color:white;
    classDef blue fill:#2874A6,stroke:#555,color:white;
    classDef lightblue fill:#a3cded,stroke:#555;
    classDef green fill:#276551,color:white,stroke:#555,stroke-width:2px;
    class ORG orange
    class MNG,ECP,EDP darkblue
    class PRD,FLEX,SBOX blue
    class PRD-PLT,PRD-A,PRD-B,SBOX-A,SBOX-X,PRD-PLT-NET lightblue
    class NPD-PLT,NPD-A,NPD-B lightblue
    class M,N,O,PRD-A-1,PRD-A-2,NPD-A-1,NPD-A-2,SBOX-A-1,TEN-Y green
    class TEN-PRD,TEN-NPD,TEN-SBOX grey
{{< /mermaid >}}

Projects will be named according to the following naming standard:

```text
epam-ecp-{tier}-{tenant}-{project_name}
```

`{tier}` is one of `prod`, `flex`, or `sbox`.

As an example, your initial project name might look like this:

```text
epam-ecp-prod-pdp-app_foo
epam-ecp-sbox-wtr_selling-app_bar
epam-ecp-flex-ordering-sterling_1
```

## Default Tenant Groups

New tenants will be given a *default set of groups*, with appropriate roles for their project(s). The tenant factory will assign these groups to your tenancy.

| Group Name | Access to |
|------------|-----------|
|_gcp-epam-ecp-&lt;tenant&gt;-admin|Admin access for all projects in your tenancy|
|_gcp-epam-ecp-prod-&lt;tenant&gt;-viewer|View access for your Prod tenant hierarchy|
|_gcp-epam-ecp-flex-&lt;tenant&gt;-viewer|View access for your Non-Prod (Flex) tenant hierarchy|
|_gcp-epam-ecp-prod-&lt;tenant&gt;-support|Support access (including logging and monitoring access) for your Prod tenant hierarchy|
|_gcp-epam-ecp-flex-&lt;tenant&gt;-support|Support access (including logging and monitoring access) for your Non-Prod (Flex) tenant hierarchy|

## Service Account

You will be provided with a _service account_ which has the authority to deploy resources within your tenancy.  Outside of your _sandbox_ projects, this is the only way you can deploy resources in your Google projects.

## Tenant Networking

With your tenancy, you can optionally have **your own VPC network** in any of your projects.  We refer to your tenant network as a _spoke_ network. This spoke network will be deployed by the _tenant factory_. Furthermore, the spoke network will be peered to the ECP _hub network_, thus providing you with the ability to connect to on-premises resources using internal (private) IP addressing, over a highly available interconnect.

You are free to:
- Deploy resources to your own VPC networks.
- Configure cloud firewall rules within your spoke networks.

If you intend to store sensitive data on your network and require perimeter controls to limit data exfiltration through Google APIs, then _VPC service controls_ can be enabled for your VPCs.

## Google Kubernetes Engine (GKE) Clusters

- ECP will host regional (highly available) **multitenant GKE clusters**, managed by the Cloud Platform Team. If you tenancy requires any container orchestration, then this shared tenancy GKE cluster is the default hosting environment. Tenants within the cluster will be deployed to their own Kubernetes namespaces, fully isolated from each other.
- You can optionally deploy your own private GKE cluster to any of your tenant VPCs. This may be necessary if your tenancy requires full administrative control over the full cluster. In this scenario, you will be responsible for managing your own cluster.

![Tenant GKE clusters](/images/gke_clusters.png)

- All GKE clusters deployed to ECP will be private.  This includes the control plane. 
- Access to the control plane will only be possible using a bastion host deployed to the same VPC nework as the GKE cluster itself, secured using IAP.

## Your GitLab and Infrastructure Code

As a new tenant, you will need to store your project's code in GitLab. This includes all the IaC you will use to deploy resources into your ECP environments.  Within **EPAM's GitLab**, the hiearchy looks like this:

{{<mermaid align="left">}}
graph TD
    Lz-demo-docs("<b>Lz-demo-docs GitLab Group</b>") --> ECP(fa:fa-folder ECP) & digital(fa:fa-folder JL Digital) & other(fa:fa-folder Other Top Levels)
    subgraph STACK[" "]
      ECP --> PLT(fa:fa-folder Platform) & TEN(fa:fa-folder Tenants)
      PLT ---> PltPrj["A Platform Team<br/>Project"]
      TEN --> YourTenancy(fa:fa-folder Your Tenancy) & SampleTenant(fa:fa-folder Sample Tenant)
      YourTenancy --> YourPrj[Some Project] & YourOtherPrj[Some Other Project]
      SampleTenant --> SamplePrj["Sample Tenant<br/>Project"]
    end
    
    classDef grey fill:#aaaaaa,stroke:#555;
    classDef orange fill:#ffa500,stroke:#555;
    classDef darkblue fill:#21618C,stroke:#555,color:white;
    classDef blue fill:#2874A6,stroke:#555,color:white;
    classDef black fill:black,stroke:#555,color:white;    
    classDef lightblue fill:#a3cded,stroke:#555;
    classDef green fill:#276551,color:white,stroke:#555,stroke-width:2px;
    
    class Lz-demo-docs orange
    class digital,other grey
    class STACK lightblue
    class ECP,PLT,TEN,SampleTenant,PltPrj,SamplePrj darkblue
    class YourTenancy,YourPrj,YourOtherPrj black
{{< /mermaid >}}

You will need to do the following:

1. Create GitLab user accounts for any users in your team/tenancy that do not yet have a GitLab user account.  (Follow guidance [here](https://epam.engineering/how/setting-up-a-gitlab-account/).)
1. Decide who will be your GitLab **tenancy subgroup owner(s)**.
1. Submit a [request](/ecp/onboarding/getting-started/#how-to-raise-a-tenancy-request) to the _ECP (GitLab) owners_ to create your tenancy subgroup.  At this time, you will need to inform the _ECP owners_ of at least one _tenancy subgroup owner_.

At this point, you will have the ability to create further subgroups and projects within your GitLab tenancy subgroup.

## Creating More Projects

{{% notice warning %}}
TODO: Cloud Platform Team to provide specific instructions on how a tenant creates new projects in their tenancy, using the project factory.
{{% /notice %}}

## Accessing Your Internal Resources

As enforced by security policy, any GCE instances or GKE clusters you deploy within ECP will **only have internal IP addresses**. Consequently, it is not possible to connect to these resources directly from any network outside of your VPC.  (Which includes from the Internet.)

Consequently, if you have a need to connect to these machines (e.g. for administrative activity), you must use the `bastion pattern`. Within ECP, you have the option to deploy a **bastion host** within your tenancy. (Some of you may be familiar with the term `jump box`). This machine provides a single fortified entrypoint, accessible from outside the VPC, but only to authorised users.

![Bastion](/images/bastion.png)

How it works:

- You connect to your bastion using the SSH button in the Google Cloud Console, or from a client with the _Google Cloud CLI_ installed:\
`gcloud compute ssh <target_instance> --tunnel-through-iap`
- Google connects to the _Identity Aware Proxy_, which will prompt for authentication if your user ID is currently unauthenticated.
- Google then checks the user against roles assigned. If the user has appropriate roles, the user is connected to the bastion host.
- From this bastion host, the user can connect to private resources in their VPC.

Useful links:

- [Using IAP for TCP Forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)
- [Remotely access a private cluster using a bastion host](https://cloud.google.com/kubernetes-engine/docs/tutorials/private-cluster-bastion)