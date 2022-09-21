---
title: "Google Groups in GCP"
menuTitle: "Google Groups"
weight: 5
---

## OLD CONTENT; NOT YET UPDATED

Google groups can be used in Google Cloud Platform to assign permissions to a number of team members. This has several advantages as outlined below.

Identity and Access Management (IAM) policies exist on projects and certain resources, and where these need to include multiple individuals then the permissions should be granted to a group as the default method rather than to people directly.

This page describes the background to why and how groups are used, EPAM procedures on how to request them, and responsibilities for the group managers.

- [Background](#background)
- [Naming Convention](#naming-convention)
- [How to request a group](#how-to-request-a-group)
- [How groups work](#how-groups-work)
- [Responsibilities](#responsibilities)
- [Additional Notes](#additional-notes)

## Background

In Google Cloud Platform, any resource is created under an holding object called a project. Permissions are granted on a project, and on certain resources within projects, by assigning a role. Roles can be assigned to one of four identity types:

- Public Google Account email: a.person@epam.com
- Google Group: epam_gcp_myapp_admins@epam.com
- Service account: server@example.gserviceaccount.com
- G Suite domain: epam.com or waitrose.co.uk

Using user accounts has a number of issues. These include grants not being removed when they should, complexity of managing different lists of roles to people, and delays when requests have to be approved and passed to Infrastructre Cloud Team.

Google [best practice](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations#groups-and-service-accounts) is to use groups to cover sets of users.

Once a group is available then a set of permissions can be assigned to the set of people that are members of that group. Therefore one group is required for each distinct permission sets needed. So if you need some people to have admin roles and some to have lesser roles then that would need two groups. A group usually corresponds to a team of people, with one or more managers who have the authority to grant access and update membership.

The Cloud Team strongly recommends use of service accounts where appropriate, so that running services are not tied in any way to an individual user account, but these would not be managed via groups. The Google groups are specifically intended for collections of people.

## Naming convention

Google groups for use in GCP must have prefix:

- jl_gcp
- wtr_gcp
- epam_gcp
- epam_gcp_pdp   (for use on any group used in LZ-Demo Data Platform)

The rest of the group name would normally be based around the team who form the membership and their role. If different permissions are required for different people, then use team names with admin, developer, viewer or similar.

Examples:

- epam_gcp_myapplication_admins@epam.com
- wtr_gcp_myapplication_viewers@waitrose.co.uk
- epam_gcp_pdp_data_engineers@epam.com

The gcp prefix is a requirement in order to ensure the groups are set up by G-Suite team with a specific configuration that has been tailored for use in Google Cloud Platform, and to assist in security monitoring. Forseti, an open source security reporting tool, scans all projects and has a rule that will report IAM assignments to groups that do not have a name with the above prefix.

## How to request a group

Groups can be requested by anyone using a Service Now non-catalogue REQ form.

The form should instruct the REQ to be forwarded to the PIT EUC C&C (Google G Suite) - 3rd line team who will do the group creation.

It must include the following information:

- Name of the group (which must follow convention above).
- One or more group managers. The managers must have authority to grant the permission the group will confer and takes on the role of administering the membership.
- Group description. A short summary of what the group will be used for.

Once the group is set up with the correct membership then a request can be sent to the Platform Cloud team (z_PIT_Platform_Cloud@epam.com) to apply the IAM change to the project, or can be done by an owner of a project themselves if they have that privilege. When emailing the Cloud Team please supply the following information:

- Google group.
- Project name or ID.
- Role(s) to be granted.

The roles to be granted to the group should follow the usual best practice approach of minimum privilege. If you are unsure what roles are necessary then email the Cloud Team and we will help define the correct set of least privilege permissions.

## How groups work

Groups should be the default method to grant IAM permissions to GCP project, excluding personal sandboxes which should only have the relevant individual as Owner.

A manager of a group can add & remove members, and appoint members as additional managers. They cannot make themselves or others owners of the group.

A manager can only add additional members with @epam.com or @waitrose.co.uk email addresses. This is an enforced rule.

As described above, the Cloud team will grant IAM roles to the group. As people join, leave or move teams the Google group manager can then update the membership list appropriately without any additional requests to Platform teams. They should follow any internal procedure requirements on audit trails and authorisation as outlined below in the conditions of use.

If the roles assigned to the group need to be changed, this would be done via a request to the Cloud team with suitable approval.

For external third party identities that need access to a GCP project, it is recommended that a request be made on their behalf to get an @epam.com email that can then be used in the Google groups. The cloud team can put IAM grants on GCP projects directly to external email addresses but this is not recommended because they are often not revoked when any work has been completed.

Logs on group creation and membership changes are stored in the G-Suite logs. These are retained for six months.

If an account is suspended, that will block access to GCP even if the account has permissions via group membership. It is still advised to remove suspended or leaver accounts from groups though, in order to make the membership audits easier and also in case the account ever reappears and the grant becomes active again.

## Responsibilities

When a Google group is set up by EUC team they will send the following conditions of use to the manager(s).

As a manager of a group you must follow the conditions of use as laid out below.

- You must ensure only correct individuals are within a group.
- You, or the team responsible for your GCP project if that is not you, must ensure the group has the appropriate minimum set of GCP IAM privileges required for your team to perform its role.
- Must be authorised to grant the privileged access that the group membership permits, or otherwise ensure authorisation is secured prior to membership changes.
- Must ensure movers and leavers are removed from the group.
- Must perform monthly checks that the membership is up to date.
- Must ensure anyone else appointed a group manager is given these conditions of use.
- Must ensure manager duties are passed on if you leave the organisation (If this doesn’t happen then a request will be necessary to G-Suite admin team to appoint a new manager).
- Must only use gcp named groups as nested entries since other groups were not created for the purpose of assigning permissions in Google Cloud Platform. However we do not recommend nesting groups (see below).

The following are recommendations:

- The Google groups are created with a defined template of approved Settings and should not be changed without getting Cloud team and G Suite team approval.
- Do not use nested groups. The reason for avoiding nesting groups is so that it is easier to ensure the first condition of use (that only correct individuals are within a group). As a manager of group you will have to ensure that only correct individuals are in the sub groups also, and you may not be aware of changes to these groups or have control over their membership.
- If a permanent audit trail is required then the manager can choose to enforce requests coming to them via Service Now or another tracking solution before they make any membership changes. - This will be a local decision for the group manager(s) and if it is necessary will be for the group manager to enforce.
We recommend that the group manager has a system of recording their own monthly checks of membership to prove this condition of use is being followed.
- Consider appointing multiple managers so that requests can be processed by more than one person to cover for any absence of one individual. If multiple managers are appointed then they must all be aware of and comply with all the conditions of use outlined above.

## Additional Notes

It can take [up to 6 hours](https://support.google.com/a/answer/167429?hl=en) for new Google group to appear.
