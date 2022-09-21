---
title: "Cost Management"
menuTitle: "8. Cost Management"
weight: 25
---

## Page Contents

- [Cost Management Overview](#cost-management-overview)
  - [Cost Estimation](#cost-estimation)
  - [Cost Control](#cost-control)
- [Billing Overview](#billing-overview)
  - [Cost Visibility](#cost-visibility)
  - [Budget Alert Receivers](#budget-alert-receivers)
  - [How You Pay](#how-you-pay)
- [Labelling](#labelling)

## Cost Management Overview

Like any public cloud, GCP is a flexible, on-demand set of pay-as-you-go services. There are no up-front costs, and no termination fees which means you stop paying for services as soon as resources are deleted.

There are many product on GCP, and a plethora of pricing models.  Google document a [pricing model](https://cloud.google.com/pricing/list) for each of their products.

### Cost Estimation

Google offer a [pricing calculator](https://cloud.google.com/products/calculator/) that can be used to **estimate costs** for a wide variety of products.

It is advised that any prospective LZiiB tenant works with a cloud architect and the Cloud Platform Team, when performing estimates.

### Cost Control

Here are some general tips for keeping costs under control, when using Google Cloud:

- When using GCE instances, start small.
- Consider using pre-emptible instances. When using pre-emptible instances in an autoscaling managed instance group, use autohealing to regenerate your instances when they are pre-empted.
- Bear in mind that we have enterprise-level committed-use discounts for certain instance families and sizes. You should always consult with the Cloud Platform Team, to establish if you should be using one of these types, when sizing your VMs.
- Consider caching any static content, e.g. with Cloud CDN (at the edge) or with Cloud Memorystore, to reduce your CPU demand.
- Don't use SSD persistent disks on instances, unless performance of the instance is crucial.
- Keep instances close to their data, to reduce data egress costs. Thus, always try to run instances and associated storage from the same region.
- Routinely review your billing reports, to understand costs, spot trends, and detect any cost anomalies.
- Avoid running unused infrastructure, where possible.
  - Use IaC to deploy environments on-demand.
  - Tear down unused environments.
  - Turn off unused instances.
  - Use the infrastructure-on-demand DR pattern, if possible.

## Billing Overview

All deployed Google Cloud resources are attributed to a single project. Consequently, **project costs are accumulated at the project level**. All these projects are ultimately associated with a **billing account** that is the responsibility of the LZiiB Service Owner.

The day-to-day management, analysis and reporting of our billing account is managed by **AppsBroker**, who EPAM have contracted with to provide Financial Operations expertise in GCP. 

### Cost Visibility

- AppsBroker generate monthly billing reports, which are sent to all project owners. Members of your tenant `admin` group will have visibility of these reports.
- All LZiiB projects will have associated **budgets**. 
  - Budgets are set at project level, and define monthly spend threshold.  
  - Initial budgets will be agreed when your tenancy is established.  
  - Budget alarms will be set automatically, resulting in email notifications to tenants, when budget thresholds - 50%, 80% and 100%, by default - are exceeded. 
- Billing data is automatically exported to a BigQuery dataset in the centralised management `Billing` project.

### Budget Alert Receivers

In order to receive the programatic budget alerts for a project, users will need to hold the EPAM Budget Alert Receiver role on the relevant project(s). The role now works with inheritance so can either be held on the project itself or inherited from above. The role works with both individual accounts and Google groups.

A list of budget alert receivers for a project will be gathered as part of the onboarding process but can be updated at any time by contacting the Cloud Team.

### How You Pay

{{% notice warning %}}
TODO: Cloud CoE to agree model of how a tenant pays for use of LZiiB.
{{% /notice %}}

## Labelling

In Google Cloud, **labels** are **key:value** pairs that can be defined as metadata against projects and resources. These labels are extremely useful in identifying, for example, whether resources are associated with a specific tenant or with a specific environment.

These labels can be used for various types of resource analytics, such as:

- Querying for resources with a particular label or labels.
- Filtering billing reports against specific labels.
- Performing internal chargeback.

When deploying resources in your tenancy using the _project factory_ and _IaC_, certain mandatory labels will be created and added to resources automatically:

|Label Name|Description|Possible Values|
|----------|-----------|---------------|
|epam_platform|Which top level platform is in use|LZiiB / Other|
|epam_tenant|Your tenancy|Any|
|epam_service|Project or service|Any|
|responsible|EPAM Cost Centre|Any|
|layer|Whether prod, non-prod, or sandbox|prod / flex / sbox|

In addition, you can add your own custom tenant labels to your resources. Specify any labels you want to use when you request your tenancy.  For example, you might consider labels such as:

- `Component` - e.g. "application", "frontend", "backend", "DB", "ingest", "pipeline", etc.
- `Contact` - i.e. an individual who can answer questions about this resource
- `State` - e.g. "active", "pending-deletion", "archive"
