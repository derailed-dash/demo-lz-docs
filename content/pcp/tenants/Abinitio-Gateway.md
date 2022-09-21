---
title: "Abinitio Gateway"
menuTitle: "Abinitio Gateway"
weight: 10
---

## Abinitio Gateway

**Author:** James Hoare
**Last Updated:** 05/12/2019

---

### Description

AbInitio is currently the ETL tool of choice across the partnership. With Cloud adoption growing within EPAM and particularly with the development of the PDP (Partnership Data Platform) it has become a requirement to be able to use AbInitio to ingest data into current and future cloud based solutions. AbInitio Gateway environments have therefore been set up within our GCP IaaS Platform to enable this. For reference, here is a link to the [high level design.](https://docs.google.com/document/d/1sRaE0AxaL419X99sS3rtYig0jWt16YyPNy248GSbuKU/edit)

### Environments

There are two environments for AbInitio Gateway. Both environments are hosted in a seperate GCP project. The environments for the Abinitio Gateway are as follows:

| Enviornment                 | GCP Project                                                                                                  |
| --------------------------- |--------------------------------------------------------------------------------------------------------------|
| Non Prod                    | [pit-abinitio-gateway-npd](https://console.cloud.google.com/home/dashboard?project=pit-abinitio-gateway-npd) |
| Prod                        | [pit-abinitio-gateway-prd](https://console.cloud.google.com/home/dashboard?project=pit-abinitio-gateway-prd) |

### Resources

The Abinitio Gateway service projects have matching infrastructure across all environments. The infrastructure components in each environment are as follows (Please note, this list excludes platform level resources present in all IaaS Projects, e.g. auto stop start functions as detailed in [DR015](../../decision-records/dr015-instance-auto-stop-start/)):

#### Non Prod

- Google Compute Instance
  - **Name**: gcew2a-00000001
  - **Description**: Abinitio Gateway Server
- Google Storage Bucket
  - **Name**: pit-abinitio-authorized-keys-store-dev
  - **description**: A bucket to be used to store authorised keys for the non production Abinitio Gateway Environment

#### Prod

- Google Compute Instance
  - **Name**: gcew2a-00000002
  - **Description**: Abinitio Gateway Server
- Google Storage Bucket
  - **Name**: pit-abinitio-authorized-keys-store-prd
  - **description**: A bucket to be used to store authorised keys for the production Abinitio Gateway Environment

### Infrastructure as code

The Abinitio Gateway projects are created using GitLab CI with Terraform. The repo where the code is hosted and run can be found [here.](https://gitlab.com/Lz-demo-docs/pit_platform/pit-iaas/abinitio)

The repo will contain detailed information such as how to run the CI Pipeline, and specifications for the Abinitio VM.

### VM Stop/Starts

Automatic VM stop/start configuration for the Abinitio Gateway projects are as follows:

| Enviornment                 | VM Stop/Start configuration                                                                                           |
| --------------------------- |-----------------------------------------------------------------------------------------------------------------------|
| Non Prod                    | Auto Stop/Start is currently configured to not affect any machines in the Non Production Abinitio Gateway environment |
| Prod                        | Auto Stop/Start is currently configured to not affect any machines in the Non Production Abinitio Gateway environment |

### Maintenance Windows

Maintenance windows for the Abinitio Gateway environments are as shown below. Automated server rebuilds are conducted during **every** maintenance window and are kicked off when the maintenance window begins.

| Enviornment                 | Maintenance window                        |
| --------------------------- |-------------------------------------------|
| Non Prod                    | Every Wednesday 15:30-16:30               |                                |
| Prod                        | First Thursday of every Month 15:00-16:00 |

### Contacts

The below people have been identified as contacts for this project.

| Role                           | Name          | Email                                             |
|--------------------------------|-------------- |---------------------------------------------------|
|Cloud Infrastructure Engineer   |Adrian Edwards |[Email Adrian](mailto:adrian.edwards@johnlewis.com)|
|Infrastructure Delivery Manager |Adam Meszaros  |[Email Adam](mailto:simon.miller@johnlewis.com)    |
