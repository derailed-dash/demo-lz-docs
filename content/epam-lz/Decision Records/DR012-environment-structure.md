---
title: "DR012: Environment Structure"
menuTitle: "DR012: Environment Structure"
---

## Status

Proposed

## Author

Simon Miller
James Hoare
Steve Tolson

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| << reviewer 1 >>            | DD/MM/YYYY  |
| << reviewer 2 >>            | DD/MM/YYYY  |
| << reviewer 3 >>            | DD/MM/YYYY  |

---

## Decision

This decision is for how we structure project boundaries around multiple environment requirements.

As a group we have decided that [option 2](./#option-2-project-for-non-productions-environments-and-a-project-for-productions-environments) (detailed below) will be the default stance for any projects being onboarded to the IaaS Platform. This may change and evolve as new use cases are onboarded. The options considered for this are as described below, and were discussed by the below people before a decision was reached.

| Name                        | Role                            |
| --------------------------- |---------------------------------|
| James Hoare                 | Cloud Infrastructure Engineer   |
| Simon Miller                | Cloud Infrastructure Engineer   |
| Adrian Edwards              | Cloud Infrastructure Engineer   |
| Steve Tolson                | Infrastructure Architect        |

---

## Context

Typically any IaaS requirement will need multiple environments, so a decision is necessary on how to structure these environments in GCP. Both the multiple-project or dual-project solutions have advantages and drawbacks. Although this strategy may evolve over time we need an initial decision on a standard approach we will start with as the default layout.

The options considered and the decision made are all outlined below.

### Option 1: Project Per Environment

This option is where each environment is seperated out into its own GCP project. Each environments resources will therefore be grouped together into individual projects, so using a fictional use case requiring 4 environments (dev, tst, rel & prod); all dev resources will be in the dev project, all test resources in the test project and so on. A visual representation of this option can be seen below.

{{<mermaid align="center">}}
graph TD
subgraph Key
AA[fa:fa-folder Folder]
BB(fa:fa-project-diagram Project)
CC((fa:fa-server resource))
style AA fill:yellow,stroke:#444,stroke-width:1.5px
style BB fill:orange,stroke:#444,stroke-width:1.5px
style CC fill:pink,stroke:#444,stroke-width:1.5px
end
{{< /mermaid >}}

{{<mermaid align="center">}}
graph TD
classDef folder fill:yellow,stroke:#444,stroke-width:1.5px
classDef project fill:orange,stroke:#444,stroke-width:1.5px
A[fa:fa-folder PIT Shared IaaS] --> B[fa:fa-folder Non-Production IaaS]
A --> C[fa:fa-folder Production IaaS]
A --> D(fa:fa-project-diagram lz-iaas-operations-devops)
B --> E[fa:fa-folder Applications]
B --> F[fa:fa-folder Infrastructure]
C --> G[fa:fa-folder Applications]
C --> H[fa:fa-folder Infrastructure]
E --> I(fa:fa-project-diagram lz-some-project-dev)
E --> J(fa:fa-project-diagram lz-some-project-tst)
E --> K(fa:fa-project-diagram lz-some-project-rel)
G --> L(fa:fa-project-diagram lz-some-project-prd)
I --> M((fa:fa-server vm-dev1))
J --> N((fa:fa-server vm-tst1))
K --> O((fa:fa-server vm-rel1))
L --> P((fa:fa-server vm-prd1))
F --> Q(fa:fa-project-diagram ...)
H --> R(fa:fa-project-diagram ...)
I --> S((fa:fa-server ...))
J --> T((fa:fa-server ...))
K --> U((fa:fa-server ...))
L --> V((fa:fa-server ...))
E --> W(fa:fa-project-diagram ...)
G --> X(fa:fa-project-diagram ...)
class A,B,C,E,F,G,H folder
class D,I,J,K,L,Q,R,W,X project
class M,N,O,P,S,T,U,V tes-resource
style M fill:pink,stroke:#444,stroke-width:1.5px
style N fill:pink,stroke:#444,stroke-width:1.5px
style O fill:pink,stroke:#444,stroke-width:1.5px
style P fill:pink,stroke:#444,stroke-width:1.5px
style S fill:pink,stroke:#444,stroke-width:1.5px
style T fill:pink,stroke:#444,stroke-width:1.5px
style U fill:pink,stroke:#444,stroke-width:1.5px
style V fill:pink,stroke:#444,stroke-width:1.5px
{{< /mermaid >}}

#### Option 1: Pros

- Flexible
- Easier cost management

#### Option 1: Cons

- Lots of upfront work required to make this solution work

### Option 2: Project for Non Productions Environments and a Project for Productions Environments

This option is where each environment is seperated out into one of two GCP projects dependant on whether it is classed as Production or Non Productions. Non Productions resources will therefore be grouped together into one project and Production resources grouped together in another project. Using a fictional use case requiring 4 environments (dev, tst, rel & prod); the dev, tst and rel resources will be in the npd project and the prd resources will be in the prd project. A visual representation of this option can be seen below.

{{<mermaid align="center">}}
graph TD
subgraph Key
AA[fa:fa-folder Folder]
BB(fa:fa-project-diagram Project)
CC((fa:fa-server resource))
style AA fill:yellow,stroke:#444,stroke-width:1.5px
style BB fill:orange,stroke:#444,stroke-width:1.5px
style CC fill:pink,stroke:#444,stroke-width:1.5px
end
{{< /mermaid >}}

{{<mermaid align="center">}}
graph TD
classDef folder fill:yellow,stroke:#444,stroke-width:1.5px
classDef project fill:orange,stroke:#444,stroke-width:1.5px
A1[fa:fa-folder PIT Shared IaaS] --> B1[fa:fa-folder Non-Production IaaS]
A1 --> C1[fa:fa-folder Production IaaS]
A1 --> D1(fa:fa-project-diagram lz-iaas-operations-devops)
B1 --> E1[fa:fa-folder Applications]
B1 --> F1[fa:fa-folder Infrastructure]
C1 --> G1[fa:fa-folder Applications]
C1 --> H1[fa:fa-folder Infrastructure]
E1 --> I1(fa:fa-project-diagram lz-some-project-npd)
G1 --> L1(fa:fa-project-diagram lz-some-project-prd)
I1 --> M1((fa:fa-server vm-dev1))
I1 --> N1((fa:fa-server vm-tst1))
I1 --> O1((fa:fa-server vm-rel1))
L1 --> P1((fa:fa-server vm-prd1))
F1 --> Q1(fa:fa-project-diagram ...)
H1 --> R1(fa:fa-project-diagram ...)
I1 --> S1((fa:fa-server ...))
L1 --> V1((fa:fa-server ...))
E1 --> W1(fa:fa-project-diagram ...)
G1 --> X1(fa:fa-project-diagram ...)
class A1,B1,C1,E1,F1,G1,H1 folder
class D1,I1,L1,Q1,R1,W1,X1 project
style M1 fill:pink,stroke:#444,stroke-width:1.5px
style N1 fill:pink,stroke:#444,stroke-width:1.5px
style O1 fill:pink,stroke:#444,stroke-width:1.5px
style P1 fill:pink,stroke:#444,stroke-width:1.5px
style S1 fill:pink,stroke:#444,stroke-width:1.5px
style V1 fill:pink,stroke:#444,stroke-width:1.5px
{{< /mermaid >}}

#### Option 2: Pros

- Can be implemented as it stands today

#### Option 2: Cons

- Project level IAM grants may not be possible

---

## Implications

<< What becomes easier or harder as a result of this change? >>

<< What are the consequences of the decision - e.g. technical debt, delays, cost, later review >>
