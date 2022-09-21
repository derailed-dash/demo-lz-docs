---
title: "Responsibilities"
menuTitle: "2. Responsibilities"
weight: 7
---

## Page Contents

- [Responsibilities](#responsibilities)
- [Skills and Resources You Need](#skills-and-resources-you-need)

## Responsibilities

The table below illustrates which activities are Cloud Platform Team responsibility, which are Tenant responsibility, and which are joint responsibility.

{{% notice warning %}}
The Cloud Platform Team will not provide ongoing management, maintenance, patching and incident response for tenant applications, or tenant cloud resources.  Consequently, **it is essential that a long term support model is established** through Service Introduction.
{{% /notice %}}

|Activity|Responsibility|More Details|
|--------|--------------|------------|
|Cost Estimation for New Services|Joint|Cloud Platform Team will support the tenant in this process|
|Provisioning and maintenance of the shared infrastructure, including Shared VPC and Shared (multitenant) GKE clusters.|Cloud Platform Team|Achieved through Landing Zone IaC and pipeline|
|Provisioning and maintenance of any non-GCP hosting, network and connectivity infrastructure (on-premises and SaaS)|Infastructure Platforms & Networking|As with existing non-GCP hosting and networking infrastructure. Includes things like: on-premises firewalls and Zscaler Internet Access proxies|
|Provisioning and maintenance of GCP Zscaler tunnels to Zscaler Internet Access (ZIA)|Cloud Platform Team|Including setting up of GCP VPN configuration and VPC routing tables|
|Provisioning and maintenance of EPAM custom gold OS images|Cloud Platform Team|Using automated Packer pipeline process. Any requests for amendments to existing images, or for new images (e.g. for new operating systems) should be issued to the Cloud Platform Team. Note that maintaining the latest version of existing images is considered BAU activity.|
|Provisioning of sandbox projects for individuals|Cloud Platform Team|Accomplished through the Tenant Factory.  Delivers a project used by individuals for familiarisation, learning, experimentation, and PoC work.|
|Requesting a tenancy|Tenant|Through tenant request process.|
|Provisioning of _default_ IAM groups for the new tenant|Cloud Platform Team|The Cloud Platform Team completes an automated request to the Google Workspace Team, which results in the creatin of groups.|
|Assigning users to the tenant IAM groups|Cloud Platform Team|// TBC|
|Provisioning the tenant folders|Cloud Platform Team|Accomplished through the Tenant Factory|
|Provisioning tenant sandbox projects|Cloud Platform Team|Accomplished through the Tenant Factory.  Delivers a project shared by members of the tenancy, for experimentation, PoCs, and IaC assembly.|
|Provisioning tenant non-prod (aka Flex) projects|Cloud Platform Team|Accomplished through the Tenant Factory|
|Provisioning tenant prod projects|Cloud Platform Team|Accomplished through the Tenant Factory|
|Assigning tenant IAM groups to tenant projects|Cloud Platform Team|Accomplished through the Tenant Factory|
|Provisioning of a VPC (network) within your project(s)|Cloud Platform Team|Accomplished through the Tenant Factory|
|Peering of your VPC (network) to the Shared VPC that provides connectivity to on-premises|Cloud Platform Team|Accomplished through the Tenant Factory|
|Provisioning of tenant IaC service account|Cloud Platform Team|Accomplished through the Tenant Factory|
|Provisioning of GitLab tenant project and access|Cloud Platform Team|See [here](/ecp/onboarding/your-tenancy/#your-gitlab-and-infrastructure-code)|
|Provisioning and management of additional tenant IAM groups|Tenant|A member of the _tenant admins_ will be able to request additional groups|
|Provisioning of custom roles|Cloud Platform Team|Accomplisehd by modification of the Landing Zone IaC. Applied at organisation level.|
|Provisioning and management of any required single-tenancy Kubernetes clusters|Cloud Platform Team|Accomplished through the Tenant Factory|
|Deployment of applications on the platform|Tenant|Using whatever approach is appropriate for the application.  There are multiple patterns a tenant might follow.  E.g. building custom images; running install scripts on top of an image; runnning Ansible scripts. The Cloud Team will support the tenant in the best choices for their applications.|
|Billing account attachment|Cloud Platform Team|Accomplished through the Tenant Factory| 
|Provision access to tenant-specific billing and cost data|Cloud Platform Team|The Cloud Team provide access to billing and cost dashboards / reporting, limited to appropriate tenant scope|
|Creation and management of IaC (e.g. Terraform) to provision tenant-specific resource deployment|Tenant|Tenant will have access to standard Terraform resources, but will also be able to create and maintain their own. // Details TBC|
|Provisioning and management of tenant-specific resources in a tenant project|Tenant|Unrestricted in sandbox; using IaC run by the service account in other environments|
|Provisioning and management of additional service accounts in a tenant project|Tenant|Unrestricted in sandbox; using IaC run by the service account in other environments|
|System logging from tenant instances|Tenant|Accomplished out-of-the-box through automatic deployment of Ops Agent using Terraform modules|
|Provisioning of monitoring and performance dashboards at LZiiB infrastructure scope|Cloud Platform Team|The Cloud Platform Team will maintain monitoring, dashboards and alerting for all shared platform resourcs, including any resources deployed to the _Hub_ VPC. Furthermore, the Cloud Platform Team is responsible for monitoring any resources deployed by the _Tenant Factory_ itself.|
|Monitoring and response of LZiiB-scoped logging and alerting|Cloud Platform Team + Sec Ops|BAU maintenance|
|Provisioning of monitoring and performance dashboards at tenant scope|Tenant|The Tenant Factory will establish some vanilla monitoring dashboard capability for the tenant. It will be up to the tenant to add to and customise this, based on the resources they have deployed. In short, the tenant is responsible for any resources they have deployed themselves.|
|Monitoring and response of tenant-scoped logging and alerting|Tenant|The tenant should establish their monitoring and response requirements and processes, supported through Service Introduction.|
|Application unit and functional testing|Tenant|-|
|Application integration testing|Tenant|-|
|Application performance testing|Tenant|-|
|Application HA and DR testing|Tenant|-|
|Penetration testing|Tenant|Tenant to work with Info Sec to establish requirements and ensure pen testing is performed|
|Security monitoring and response|Security Operations|Primarily from the Google Security Command Centre.  Ensures separation of duty from Cloud Admins.|
|Ongoing cost optimisation of tenant applications|Joint|-|
|Patching and maintenance of fully-managed cloud resources|N/A|Patching and upgrades of fully-managed services is managed by Google|
|Patching and maintenance of self-managed cloud resources (e.g. GCE instances)|Shared|The standard approach will be to use _out-of-band_ patching; i.e. instances will be deployed with agents that register themselves with our centralised Ansible patching infrastructure. Patches will be routinely pushed to instances by Ansible.  Additionally, instances will be rebuilt using the latest golden images on a twice yearly schedule. Patching and upgrade approach should always be agreed as part of Service Introduction.|
|Patching and maintenance of tenant applications|Tenant|Depends on the application|
|Maintenance of this online Cloud documentation|The Cloud Centre-of-Excellence|-|

## Skills and Resources Required

{{% notice warning %}}
Remember: the Cloud Platform Team will not deploy or manage resources within your project. As a tenant, this is your responsibility. Consequently, you need to ensure that your team has the right skills.
{{% /notice %}}

Your team will need engineers with the following skills:

- Google Cloud Platform
- Terraform, i.e. in order to create infrastructure-as-code
