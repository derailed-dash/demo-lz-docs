---
title: "DR002: Label Usage"
menuTitle: "DR002: Label Usage"
---

## Status

Proposed

## Author

James Hoare, Cloud Infrastructure Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| << reviewer 1 >>            | DD/MM/YYYY  |
| << reviewer 2 >>            | DD/MM/YYYY  |
| << reviewer 3 >>            | DD/MM/YYYY  |

---

## Decision

The decision here is how Labels will be used in the IaaS Platform.

It's been decided that labels will be used to achieve/help with

- Billing
- Identification, (who owns it, environment, department)
- Automation management

The following rules have been defined and agreed for the usage of labels in the IaaS platform

Labels will

- be used on **all** environments within the PIT IaaS Platform.
- be created as part of the infrastructure as code, not by hand.
- follow the standard defined for each label in this record.
- be as static as possible. (An example of where a label might change is if owners change roles or leave the partnership).
- use the following format due to label character restrictions: keys will use \- in place of spaces and values will use \_ in place of spaces. Any other substitutions will be defined elsewhere in this record.

{{% notice info %}}
**Label Enforcement:** Label manager as a label enforcement tool is being ruled out at this time as it is still not GA and its usage is based on Google whitelisting user accounts. It is therefore not practical to use on a wide scale and Google also reccomends only GA products be used in production workloads. Labels can therefore **only be enforced by policy at this time** and will need to be audited for compliance regularly where control/responsibility for resource creation is handed off outside of our team.
{{% /notice %}}

The current **services** that can use labels can be found [here](https://cloud.google.com/resource-manager/docs/creating-managing-labels)

Each of these **services** will then have labels available for **some** of their **resources**. This can all be found in Google's documentation. As an example, you can find the compute engine **service's** **resources** that support labels [here](https://cloud.google.com/compute/docs/labeling-resources).

We have agreed the following **services** will use labels for some or all of their available resources

- Resource Manager
- Compute Engine
- Cloud Storage

We have agreed the following **resources** will use labels as follows

Service: **Resource Manager**

- Projects
  - **business-owner**, Must be set as partners email prefix with . replaced with \_ due to label character restrictions. (e.g. james.c.hoare@waitrose.co.uk would be james_c_hoare)
  - **epam-project**, The EPAM project the GCP project belongs/relates to (e.g. partnership_data_platform, merch_ops, ...)

Service: **Compute Engine**

- Instances
  - **owner**, Must be set as an individual or Google groups email address prefix with \. replaced with \_ due to label character limitations (e.g. james.c.hoare@waitrose.co.uk would be james_c_hoare)
  - **OS-release**, Must be set as the OS release being used by the instance (e.g. RHEL_7_2, centos_6)
  - **managed-by**, Must be set as the software or team that manages the instance. Where this is set as a team it should be the teams Google group email prefix formatted similar to the **owner** label (e.g. ansible, PIT_GCP_Admins, ...)
  - **compliance** (not sure what this would be or if it's needed...)
  - **hostname**, Must be set as the hostname of the instance (This might be useful as the hostname does **not** have to be the same as the instance name in GCP)
  - **maintenance-window**, Must be set as the maintenance window for the virtual machine in the following format (HH_DD_MM-HH_DD_MM) (e.g. 01_20_07-10_20_07 would give a maintenance window of 1am on the 20th July to 10am on the 20th July)
  - **app-component** (OPTIONAL: ONLY required for VM's in the application folder), Must be set as the function of the server (e.g. web, db)
  - **app-name**(OPTIONAL: ONLY required for VM's in the application folder), Must be set as the name of the application (e.g. merchops)
- Images
  - **template-version**, Must be set as the template version of the image in the following format (TBC)
- Forwarding rules (Alpha) - **Do we want labels for these?**
- Persistent disks - **Do we want labels for these?**
- Persistent disk snapshots - **Do we want labels for these?**
- Static external IP addresses (Alpha) - **Do we want labels for these?**
- VPN tunnels (Alpha) - **Do we want labels for these?**

Service: **Cloud Storage**

- Buckets
  - **owner**, Must be set as an individual or Google groups email address prefix with \. replaced with \_ due to label character limitations (e.g. james.c.hoare@waitrose.co.uk would be james_c_hoare) (Do we need a bucket owner if we have a project owner contact already? Projects might be managed by multiple teams, so could still have value.)
  - **content**, Must be set as a short description of the buckets contents (e.g. vm_backups, website_images, ... ) (Is there value in this? I will point to the naming convention where **function** is included in resource names, so this label might be redundant.)

{{% notice tip %}}
Other **services**/**resources** not in this record can be re-considered if/when they come into usage in the IaaS platform. This decision record will be updated accordingly if/when this happens.
{{% /notice %}}

---

## Context

It was outlined that labels should be used within the IaaS Platform in GCP. At the time there was no clear design on how labels should be used or what they should be used for. Tagging is used for on prem instances for a number of different reasons. A cloud IaaS platform will need similar functionality to help with the management of the platform as a whole. As labels in the cloud can be applied to more than just instances, they may actually prove more useful in in the cloud than on prem.

This decision record outlines the conclusions we came to as a group from our discussions around usage of labels.

Discussed at 11:00, 21/05/2019 by

| Name                        | Role                           |
| --------------------------- |--------------------------------|
| James Hoare                 | Cloud Infrastructure Engineer  |
| Simon Miller                | Cloud Infrastructure Engineer  |
| Steve Tolson                | Infrastructure Architect       |
| Chris Scoffield             | Infrastructure Engineer        |
| Ian Harris                  | Cloud Infrastructure Engineer  |

Discussed again at 11:00, 10/06/2019 by

| Name                        | Role                           |
| --------------------------- |--------------------------------|
| James Hoare                 | Cloud Infrastructure Engineer  |
| Adrian Edwards              | Cloud Infrastructure Engineer  |
| Steve Tolson                | Infrastructure Architect       |

Discussed again at 14:00, 11/07/2019 by

| Name                        | Role                           |
| --------------------------- |--------------------------------|
| James Hoare                 | Cloud Infrastructure Engineer  |
| Steve Tolson                | Infrastructure Architect       |

---

## Implications

Correct usage of labels should speed up management tasks revolving around billing and identification as they will provide key pieces of information up front. Without using labels these key pieces of information might require discovery work to otherwise find, or may not be available anywhere else at all.

The downsides to this decision is there is no GCP native way to enforce label usage or standards. This means we will be **relying on other teams** to **follow policy** and apply labels correctly to any resources being created/managed outside of our team as described here. Ideally, some form of auditing will therefore need to be put in place to ensure compliance.

In terms of automation this shouldn't mean any real change to the way we do things, rather we will just need to include labels for any identified resources as we move forwards. As we made this decision before implementing the IaaS platform in anger, there is little technical debt. At the time of this decision there is however a skeleton layout for the IaaS platform in place including projects and folders. These will be altered retrospectively to match the label scheme we've come up with.
