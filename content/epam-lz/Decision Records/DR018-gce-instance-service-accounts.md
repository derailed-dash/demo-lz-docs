---
title: "DR018: GCE Instance Service Accounts"
menuTitle: "DR018: GCE Instance Service Accounts"
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

<< description of decision taken >>

All IaaS Projects will have their default compute engine service account de-elevated upon project creation to hold our custom Project Viewer role and Stackdriver logging admin. Virtual Machines require an attached service account to be able to send logs to stackdriver. The easiest solution is to use the default compute engine service account for this purpose. The default compute engine service account is created automatically when the Compute Engine API is first enabled in a project and is granted the Editor role. This is problematic as anyone with access to the command line on the virtual machine can run gcloud commands as the service account and in turn will then have Editor rights on the project. To address this IaaS projects will have the permissions de-elevated upon create.

{{% notice warning %}}
To Do - Add detail
{{% /notice %}}

---

## Context

<< Why is a decision needed? >>

IaaS Instances require a service account in order to be able to send logs to StackDriver.

<< What is the problem that needs solving? >>

<< What options were considered before selecting this one? >>

<< Who has been involved? >>

---

## Implications

<< What becomes easier or harder as a result of this change? >>

<< What are the consequences of the decision - e.g. technical debt, delays, cost, later review >>
