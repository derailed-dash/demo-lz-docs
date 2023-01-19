---
title: "Getting Started"
menuTitle: "1. Getting Started"
weight: 5
---

## Page Contents

- [So You Want To Host a New Application on LZiaB?](#so-you-want-to-host-a-new-application-on-LZiaB)
- [Onboarding Steps](#onboarding-steps)
- [How to Raise a Tenancy Request](#how-to-raise-a-tenancy-request)

## So You Want To Host a New Application on LZiaB?

Assuming you have validated that LZiaB is the [right platform](/cloud-first/hosting/) for your new solution, the first thing you will need to do is establish a **new tenancy**.

{{% notice info %}}
You will be the **`tenant`**. I.e. an indendent _consumer_ of the platform.
The tenant could be an individual, but is more likely to be a team that is responsible for an application, or a related set of applications.
{{% /notice %}}

As a tenant:

- The Cloud Platform Team will provide you with a `Prod` folder, a `Non-Prod` folder, and a `Sandbox` folder, as illustrated in the [resource hierarchy](/LZiaB/design-overview#organisation-resource-hierarchy).
- You will be provided with projects in these folders:
  - Within your sandbox projects, you will have relatively unrestricted ability to deploy resources, in any manner you decide.
  - Within your non-prod (flex) and prod projects, deployment of resources will only be possible using a dedicated service account, which will run your own Infrastrucutre-as-Code (IaC), in the form of Terraform configurations.  You will generally not be able to deploy resources in these environments using the Google Cloud Console.

## Onboarding Steps

{{<mermaid align="center">}}
graph TB
    Candidate([Candidate Application for LZiaB]) --> TenantReq[Establish tenant project team]
    TenantReq -- Tenancy Request --> Tenant-YAML["Tenant YAML deployed<br/>by Cloud Platform Team"] --> Tenant[fa:fa-sitemap Tenancy Created in LZiaB]
    Tenant --> Support["Agree Tenant<br/> Support Model"]
    Tenant -.- Groups["Groups<br/> Created"]
    Tenant -.- GitLab["GitLab Project<br/> and Access"]
    Tenant --> Sbx("Sandbox<br/> Project Created<br/> (by Tenant Factory)")
    subgraph NPD ["<b>Non-Prod</b>"]
      Npd-Prj -.- Svc-Npd[Service Account]
      Npd-Prj --> Dep-Npd["Deploy Resources<br/> with IaC"]
      Svc-Npd -.-> Dep-Npd
      Dep-Npd --> QA["Quality Assurance"]
    end
    subgraph PRD ["<b>Prod</b>"]
      Npd-Prj --> Prd-Prj("Prod Project Created<br/> (by Tenant Factory)")
      Prd-Prj -.- Svc-Prd[Service Account]
      Prd-Prj --> Dep-Prd["Deploy Resources<br/> with IaC"]
      Svc-Prd -.-> Dep-Prd
    end
    Sbx --> Bar(["Tenant IaC Created<br/> (no more deployment without it!)"])
    Support --> Bar
    Bar --> Npd-Prj("Non-Prod Project Created<br/> (by Tenant Factory)")
    QA -.-> Dep-Prd

    classDef orange fill:#ffa500,stroke:black;
    classDef darkblue fill:#21618C,color:white,stroke:white,stroke-width:1px;
    classDef blue fill:#2874A6,stroke:#555,color:white,stroke:white,stroke-width:1px;
    classDef lightblue fill:#a3cded,stroke:#555;
    classDef green fill:#276551,color:white,stroke:#555,stroke-width:2px;
    classDef red fill:#ff1111,color:white,stroke:#ff1111,stroke-width:2px;
    classDef white-on-black fill:black,color:white,stroke:black;
    classDef default filL:white,stroke:black;

    class Candidate orange
    class TenantReq,Tenant,Tenant-YAML green
    class Support red
    class Sbx,Npd-Prj,Prd-Prj blue
    class NPD,PRD lightblue
    class Bar,Dep-Npd,Dep-Prd,QA white-on-black
{{< /mermaid >}}

## How to Raise a Tenancy Request

If you need your own tenancy, you will need to raise a tenancy request.

You will complete the tenancy request form, supplying requested information.  In response to this, the Cloud Platform Team will take your responses and create a `<tenant>.yaml` file. This file be used by the Cloud Platform Team to create your tenancy using our Gitlab Tenant Factory CI/CD pipeline.

{{% notice warning %}}
TODO: Cloud Team to provide Tenancy Request process here.\
This is expected to be a form that asks questions like:\
Tenant name.\
Tenant owner.\
Tenant admins.\
Describe your service/application.\
Which GCP services do you require?\
Contact for billing alerts.\
Preferred billing label for the tenant (in addition to the standard labels).\
Any organisation policy that need to be overridden, along with justification.\
Service Account roles desired.
{{% /notice %}}