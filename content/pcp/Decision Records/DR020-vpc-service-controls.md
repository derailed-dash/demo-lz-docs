---
title: "DR020: VPC Service Controls in IaaS"
menuTitle: "DR020: VPC Service Controls in IaaS"
---

## Status

Accepted 

## Author

Steve Tolson, Cloud Infrastructure Architect

Simon Miller, Cloud Infrastructure Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Steve Tolson                | 18/12/2019  |
| Simon Miller                | 30/12/2019  |

---

## Decision

VPC Service Controls will be implemented in Strategic Iaas.

For background on initial approach see [paper](https://docs.google.com/document/d/1GnDtGHnH9O3nEJ1umFPlXddNpR6YaqTGROlNdHbB7TQ/edit?ts=5dee53a1) from JL Architecture.

---

## Context

Google VPC Service Controls provide an API security capability to reduce the risk of data exfiltration. They are a powerful tool, adding another layer to a defense in depth strategy. After a workshop to discuss, it was agreed to set up the VPC-SC perimeters for the Strategic IaaS deployments.

Without VPC Service Control perimeters any API calls to the relevant GCP project are dependent on IAM permissions alone. The VPC-SC controls place projects behind a perimeter, and API access to the projects then needs to meet an Access Level. Google API calls within the perimeter do not need any Access Levels defined. Any calls from the IaaS projects to projects outside the perimeter are blocked.

The initial approach document was agreed by Architecture, Cloud Team and Automation Team. Although many of the products listed below are not currently used in IaaS projects, and that includes Google Compute Engine which is the main reason IaaS solution exists, it was decided that it was wiser to set the VPC-SC perimeters up at the outset and address any problems as they arise.

---

## Implications

The controls mean that API calls to the projects require suitable Access Levels to be granted. Without Access Levels being defined then API calls to the IaaS projects will fail.

The [Access Levels](https://cloud.google.com/access-context-manager/docs/manage-access-levels) can be crafted on a number of criteria such as identity, public-IP range, location, etc. Access Levels can be combined to form powerful grouping of requirements.

API calls from the IaaS projects to other GCP projects will be blocked.

There are some [known limitations](https://cloud.google.com/vpc-service-controls/docs/supported-products#service-limitations) with VPC Service Controls. There are some quota limits that apply at the organisation level, and there is also a limited number of APIs that are covered. This list is growing all the time, and for initial approach all services in full support were included.

The list of all supported products is shown [here](https://cloud.google.com/vpc-service-controls/docs/supported-products) but the ones used for the IaaS initial deployment are:

* BigQuery
* BigTable
* Cloud KMS
* Container Registry
* Dataflow
* Dataproc
* Data Loss Prevention
* Natural Language
* Stackdriver Logging
* Cloud Pub/Sub
* Spanner
* Cloud Storage

---

## Deployment

VPC Service Controls are managed at an organisation level within GCP. The Access Levels and Perimeters do not get created within projects themselves. Therefore, an organisation level role is required to administer them. This means any Infrastructure-as-code that uses a service account can potentially cause issues anywhere in the GCP organisation, so extreme care must be used.

The IAC that is used to create and manage the VPC-SC configuration is maintained in a separate IaaS GitLab repository which uses service accounts that are only given temporary rights. See the relevant GitLab repo for further details.
