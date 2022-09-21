---
title: "Customer Registry"
menuTitle: "Customer Registry"
weight: 15
---

## Customer Registry

**Author:** James Hoare
**Last Updated:** 05/12/2019

---

### Description

The Customer Registry (CuRe) will be a pan-partnership consolidated operational view of customer data built in a new Customer MDM tool from Tibco called EBX. It will link to the customer facing systems across EPAM and provide a consistent view of a customer’s contact details. These are the details a customer has provided for how they want to be known through outbound targeted marketing or through interaction with our Partners/Contact Centre. This will flow downstream to be used by analytics and marketing. It will also flow upstream for transparency with the customer inline with GDPR guidelines. More details can be found in the [High Level Design.](https://docs.google.com/document/d/13TCdzTNWOOlNvKyM6gs62jzFJ5NqQKxYZrT7AK3Fn-0/edit#)

### Environments

{{% notice warning %}}
CLOUD TEAM: Check the below table holds correct details once project progresses.
{{% /notice %}}

There are **four** environments for Customer Registry. Environments are hosted within one of two Google Cloud Platform projects, with the split being production vs non production. The environments for Customer Registry are as follows:

| Enviornment                 | GCP Project                                                                                                    |
| --------------------------- |----------------------------------------------------------------------------------------------------------------|
| Prod                        | [pit-customer-registry-prd](https://console.cloud.google.com/home/dashboard?project=pit-customer-registry-prd) |
| Pre-Prod                    | [pit-customer-registry-npd](https://console.cloud.google.com/home/dashboard?project=pit-customer-registry-npd) |
| Test                        | [pit-customer-registry-npd](https://console.cloud.google.com/home/dashboard?project=pit-customer-registry-npd) |
| Sit                         | [pit-customer-registry-npd](https://console.cloud.google.com/home/dashboard?project=pit-customer-registry-npd) |

### Resources

The Customer Registry service projects have differing infrastructure between environments (due to failover precautions in more important environments). The infrastructure components in each environment are as follows (Please note, this list excludes platform level resources present in all IaaS Projects, e.g. auto stop start functions as detailed in [DR015](../../decision-records/dr015-instance-auto-stop-start/)):

#### Sit

{{% notice warning %}}
CLOUD TEAM: Needs to be finalised
{{% /notice %}}

- Google Compute Instance
  - **Name**: TBC
  - **Description**: Application Server hosting the EBX platform
- Google Cloud SQL Instance
  - **Name**: TBC
  - **Description**: Postgres SQL DB hosting the EBX repository

#### Test

- Google Compute Instance
  - **Name**: TBC
  - **Description**: Application Server hosting the EBX platform
- Google Cloud SQL Instance
  - **Name**: TBC
  - **Description**: Postgres SQL DB hosting the EBX repository

#### Pre-Prod

- Google Compute Instance
  - **Name**: TBC
  - **Description**: Application Server hosting the EBX platform (Active Server)
- Google Compute Instance
  - **Name**: TBC
  - **Description**: Application Server hosting the EBX platform (Warm Standby Server)
- Google Cloud SQL Instance
  - **Name**: TBC
  - **Description**: Postgres SQL DB hosting the EBX repository
- Load Balancer
  - **Name**: TBC
  - **Description**: HTTP Traffic Router. Handles any HTTP requests and routes them to the currently active application server.

#### Prod

- Google Compute Instance
  - **Name**: TBC
  - **Description**: Application Server hosting the EBX platform (Active Server)
- Google Compute Instance
  - **Name**: TBC
  - **Description**: Application Server hosting the EBX platform (Warm Standby Server)
- Google Cloud SQL Instance
  - **Name**: TBC
  - **Description**: Postgres SQL DB hosting the EBX repository
- Load Balancer
  - **Name**: TBC
  - **Description**: HTTP Traffic Router. Handles any HTTP requests and routes them to the currently active application server.

### Infrastructure as code

The Customer Registry projects are created using GitLab CI with Terraform. The repo where the code is hosted and run can be found [here.](https://gitlab.com/Lz-demo-docs/pit_platform/pit-iaas/pit-iaas-customer-registry)

The repo will contain detailed information such as how to run the CI Pipeline.

### VM Stop/Starts

Automatic VM stop/start configuration for the Customer Registry projects are as follows:

| Enviornment                 | VM Stop/Start configuration |
| --------------------------- |-----------------------------|
| Sit                         | TBC                         |
| Test                        | TBC                         |
| Pre-Prod                    | TBC                         |
| Prod                        | TBC                         |

### Maintenance Windows

Maintenance windows for the Customer Registry environments are as shown below. Automated server rebuilds are conducted during **every** maintenance window and are kicked off when the maintenance window begins.

| Enviornment                 | Maintenance window |
| --------------------------- |--------------------|
| Sit                         | TBC                |
| Test                        | TBC                |
| Pre-Prod                    | TBC                |
| Prod                        | TBC                |

### Contacts

The below people have been identified as contacts for this project.

| Role                           | Name          | Email                                             |
|--------------------------------|-------------- |---------------------------------------------------|
|Cloud Infrastructure Engineer   |Adrian Edwards |[Email Adrian](mailto:adrian.edwards@johnlewis.com)|
|Cloud Infrastructure Engineer   |Ian Harris     |[Email Ian](mailto:ian.harris@johnlewis.com)       |
|Cloud Infrastructure Engineer   |James C Hoare  |[Email James](mailto:james.c.hoare@johnlewis.com)  |
|Cloud Infrastructure Engineer   |Simon Miller   |[Email Simon](mailto:simon.miller@johnlewis.com)   |
|Infrastructure Delivery Manager |Adam Meszaros  |[Email Adam](mailto:simon.miller@johnlewis.com)    |
