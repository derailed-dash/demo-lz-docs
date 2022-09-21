---
title: "DR009: DNS"
menuTitle: "DR009: DNS"
---

## Status

Proposed

## Author

Ian Harris, Cloud Engineer
Thomas Moore, Automation Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Thomas Moore                | 11/10/2019  |
| Steve Tolson                | DD/MM/YYYY  |

---

## Decision

IaaS VMs will be configured to use Cloud DNS for DNS resolution

Cloud DNS will forward requests for EPAM domains to DNS proxy VMs, which we will build in the shared VPC project

The DNS proxy VMs will, in turn, forward requests to the on-prem DNS servers

To provide resilience, there will be (at least) two DNS proxy VMs built for each environment (2x NPD, 2x PRD), divided across multiple zones.

---

## Context

IaaS VMs need to resolve both GCP-based and on-prem addresses.

By default, GCP instances come configured to use Cloud DNS, which is highly available.

Cloud DNS provides DNS forwarding as a managed service to "help bridge your on-premises and GCP DNS environments".

However, there is an issue with forwarding Cloud DNS directly to the on-prem DNS servers, as the communication
happens over the public internet, meaning that reconfiguration of the EPAM network would be required to correctly
route the traffic.

Building our own DNS proxies in the cloud enables us to forward the DNS queries to the on-prem server via an
internal address on the IaaS VPC (currently a VPN but eventually  the interconnect), which eliminates the routing
difficulties.

Because DNS is a critical service, we require multiple DNS proxies to be built.

Other options considered were:

i) reconfigure the IaaS GCP VMs to directly point to the on-prem DNS servers, without going via Cloud DNS.  
This was rejected for not being sufficiently "cloudy", aligning with our strong preference to use features present in the Google base images wherever possible.

ii) reconfigure the EPAM network to permit direct communication between Cloud DNS and the on-prem DNS servers.  
This was rejected because it would take too long to investigate and implement.  It may, however, be revisited for
the strategic IaaS solution.

Those involved in this decision were: Thomas Moore, Adrian Edwards, Ian Harris

---

## Implications

The solution is simple, fast to implement, and well contained within GCP.

We have introduced additional, business-critical VMs.  If these were to fail or be compromised, the consequences for both continuity and security would be severe.

There is an additional cost of 4 GCE instances.  It is not expected that these will need to be particularly powerful.

---

## Reverse DNS

Revervse DNS is more complex as network ranges contain a mix of prod and non prod services which span muliple dns zones.

We have decided that the non-prod VPC will direct all RFC1918 reverse lookups to the acceptance.co.uk domain, and prod VPC will direct to epam.com.

This will mean that machines on the non-prod VPC will not be able to perform a reverse DNS lookup against other than acceptance.co.uk. The prod vpc will only be able to perform a reverse lookup against epam.com It was decided that this will cover the majority of services that have a requirement for reverse lookup. Anything that requires reverse lookup up to other zones will have to be treated on a case by case basis.

Those involved in this decision were: Thomas Moore, Steve Tolson, Paul Todd