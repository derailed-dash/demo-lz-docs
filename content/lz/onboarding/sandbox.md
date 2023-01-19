---
title: "Sandbox"
menuTitle: "3. Sandbox"
weight: 8
---

## Page Contents

- [Sandbox Projects Overview](#sandbox-projects-overview)
- [Types of Sandbox](#types-of-sandbox)
- [Considerations](#considerations)
- [Requesting a Sandbox Project](#requesting-a-sandbox-project)
- [Todo](#todo)

## Sandbox Projects Overview

Within Google Cloud, a _project_ is the most basic unit of resource organisation.  This means that any Google resources you deploy - such as networks, firewalls, load balancers, GCE instances, databases, Kubernetes clusters, serverless resources, and so on - **must belong to one, and only one, Google project**.  The project thus represents a **resource ownership** boundary, a **trust** boundary, and a **billing** boundary.

Within the LZiaB environment, we can provision _sandbox_ projects. These are Google projects where individuals or tenants are free to deploy resources and applications, experiment, and learn the environment. Most notably: **sandbox projects are the only projects within LZiaB where individuals or tenants are allowed to deploy resources _manually_ and _using the Google Console_.** 

All other projects in LZiaB require that resources are deployed via a special service account, using infrastructure-as-code. This is how we enforce our [Cloud Principles](/cloud-first/cloud-principles); particularly around automation and immutable infrastructure. 

## Types of Sandbox

We offer two different flavours of sandbox environment:

|Type|Purpose|Name|
|----|-------|----|
|Individual|Allows individual users to: become familiar with GCP; learn and experiment; develop; test ideas.|{org}-ecp-sandbox-{firstname-lastname} 
|Tenant|Allows tenants (typically collections of multiple users) to: conduct early PoC work with their applications; develop; experiment; to develop infrastructure-as-code; with relatively unrestricted ability to deploy resources with the Google console.|{org}-ecp-sandbox-{tenant}-{project_name}|

## Considerations

- By default, _individual sandboxes_ have a £50/month [hard spend cap](/LZiaB/cost-management#hard-cap-budgets). This can be adjusted, by request.
- No sensitive or production data should be stored or utilised by a sandbox project.

{{% notice tip %}}
You can view detailed billing information about your project in the [billing reports dashboard](https://console.cloud.google.com/billing/016BD9-AA78AE-E9E47C/reports?organizationId=1056188278627&orgonly=true)
{{% /notice %}}

## Requesting a Sandbox Project

- A **tenant sandbox** is created automatically, by the _tenant factory_, upon creation of a tenancy in LZiaB.
- For an **individual sandbox**, please raise a Catalogue Request in ServiceNow with the following template and ensure relevant line manager approval is provided.

### Request Template

**Short Description** 

```text
LZiaB Individual Sandbox Project Request 
```

**Details**

```text
Please create a LZiaB individual sandbox.

Full Name:
Email address:
Role: 
Purpose:
```

## Todo

{{% notice warning %}}
TODO: Confirm creation of tenant sandbox as part of tenant factory. \
TODO: Confirm process for individual sandbox request. \
TODO: Confirm process for individuals and tenants to view billing for their sandbox. (No access to link above.)
{{% /notice %}}