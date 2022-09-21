---
title: "DR004: User authentication within IaaS Linux VMs"
menuTitle: "DR004: User authentication within IaaS Linux VMs"
---

## Status

<< Proposed / Accepted / Rejected / Implemented / Superseded or Deprecated (and if so by which DR) >>

## Author

<< Ian Harris, Cloud Infrastructure Engineer >>

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Steve Tolson                | DD/MM/YYYY  |
| Peter Wright                | DD/MM/YYYY  |

---

## Decision

We will authenticate users against on-prem, Netdom AD DCs, using sssd via LDAP(S)

The solution will NOT use:

- Google Cloud Directory Sync'ed users
- Google Groups
- OS Login

---

## Context

This decision concerns how end users authenticate against Linux operating systems running on the
IaaS platform on GCP.  A decision is required because it is neither easy, nor advisable, for a single
VM to support multiple authentication providers.

On-prem platforms (PSIP, WSIP etc) authenticate against AD via LDAP, historically by a direct, simple
"can I bind with the user's credentials" test, or more recently with more complicated setups involving
sssd which enable use of AD groups for authorisation etc.  [PIT AD Integration Overview](https://docs.google.com/presentation/d/1hSZdEM5hKkkbtD_RxLFzFfpVEyxt7sUgC29aeLikcLo/edit#slide=id.g4e9307907b_0_211).

The default VM authentication mechanism on the Google Cloud Platform is called [OS Login](https://cloud.google.com/compute/docs/oslogin/).
This enables users to log on to VMs using their GCP credentials.  (These credentials could take the form
of an OAuth token if already authenticated against GCP, or an SSH key registered to their google account).
All google-provided linux images have a modified sshd which facilitates OS Login.

Steve Tolson and Ian Harris did a brief investigation into the options for authentication.  In the
context of an IaaS offering with network connectivity back to on-prem, neither solution had any showstoppers.
The general feeling was that LDAP was more familiar to PIT partners, whereas the cloud-native OS Login was
missing support for authorisation (google groups are not available to eg sudo, chown).

The decision was taken to develop the LDAP solution.

---

## Implications

LDAP connectivity to active directory DCs is required.

The assumption is that these will be the on-prem controllers, and therefore connectivity back to on-prem is
required for authentication.

User IAM will need to be managed in-house, using AD groups and users, not Google Groups and users.  This
breaks the currently defined "best practice" of using manager self-service Google Groups, rather than AD Groups.
(I'm unclear as to the implications of this, as I'm not sure whether IAM configuration will be handled by
[packer, terraform, startup-script, ansible, GCP console, gcloud SDK] or some combination thereof).

The Google Cloud Platform is moving fast, so it is likely that OS Login features will soon overtake the
hand-rolled ldap solution.

OS Login is a GCP proprietory feature, whereas LDAP is standard everywhere, meaning less vendor lock-in.
