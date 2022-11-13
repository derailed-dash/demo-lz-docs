---
title: "Tenant Design Docs"
menuTitle: "5. Tenant Design Docs"
weight: 12
---

Traditionally, solutions require a **high level design (HLD)** document, as well as one or several **low level design (LLD)** documents. A project team will be expected to produce these artefacts.

### HLD Overview

The HLD is typically the accountability of the lead solution architect, with contributions from various architects and SMEs. 

It will typically cover:

- An overview of the solution, and how it meets a specific objective or business need.
- Alignment to strategic vision, and architecture principles.
- High level requirements, including availability, RTOs and RPOs.
- As-is versus to-be architecture, along with any interim stages.
- Technology Architecture, including:
  - Overall stack
  - Summary of components (and patterns) in use, across all of: clients, networking, application tier, backend / persistence tier, integration and messaging, backup and recovery, disaster recovery, monitoring and alerting, and automation.
  - Recommended technology choices and products.
  - Overview of expected environments, with indicative sizing.
  - Cost and license implications.
- Information / IT Security, including identity management, data classification, key security considerations for this solution.
- Support and operational impact assessment.
- Decommissioning activity.
- Technical debt incurred and repaid.

Note that the HLD will not go into low level details, such as:

- Specific versions of software and products.
- Specific sizing or quantities, for any given environment.
- Detailed implementation information, such as IaC / terraform content, IP reservations, bootstrapping steps, or configuration steps.

### LLD Overview

The LLD is typically the responsibility of lead engineers, with input from SMEs.

Traditionally, the LLD would provide implementation detail sufficient for engineers to perform repeatable build steps.

It will include such things as:

- Specific versions of software and products.
- Specific sizing or quantities, for any given environment, at a given point in time.
- Detailed implementation information, such as runbook links, IP reservations, bootstrapping steps, configuration steps.

### Differences When Operating in the Cloud

When operating in the LZiaB environment, it is recommended to keep LLD documentation to a minimum. Where possible, low level details should be self documenting in the infrastructure-as-code, e.g. in the form of yaml files and Terraform files which are checked-in to your tenant Git repo.

This is a useful agility benefit of working with cloud:

- The infrastructure-as-code is declarative and self-documenting.
- The IaC is checked into source control, so we always have a history of what has changed.
- The IaC _always_ reflects what has actually been deployed by it.  Thus, no configuration drift between LLD and the environments you've built.
- The IaC can be compared to the HLD, to ensure it's aligned to the overall design.
- There is significantly reduced need to update documentation, outside of the changes to the IaC itself.