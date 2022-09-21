---
title: "DR017: Hostkey secrets vault"
menuTitle: "DR017: Hostkey secrets vault"
---

## Status

Implemented

## Author

Ian Harris

## Reviewers

| Name             |  Review Date |
| ---------------- |--------------|
| Dan Tracey       |    |

---

## Decision

* The SSH hostkey files will be stored as objects in a GCS bucket, encrypted by KMS.  
* A sidecar object containing the md5sum of the hostkey plaintext will be stored for each encrypted hostkey object.
* Object names will be prefixed with the hostname.
* Multiple hostkey files will be stored for each hostname.
* The credentials to a low privilege GCP service account will be stored as a custom credential type in Ansible Tower.
* The Ansible playbook will use the credentials from tower to raise its privilege by KMS decrypting then authenticating with the credentials for a second service account, stored in GCS.

---

## Context

It is necessary for SSH Host keys to survive across VM rebuilds.  This is a general IaaS requirement, but especially so in the
context of an AbInitio Co>Op, which relies heavily on SSH for transport.

The first time a VM is built, the automatically generated host keys need to be persisted.  On subsequent rebuilds, any automatically
generated keys need to be replaced with the originals.

The end goal is to implement Hashicorp Vault as a secret store.  In the meantime an alternative means of storing state is required.  
Mounting a separate filesystem on a persistent drive was considered, but the secrets here would not be encrypted at rest, which is
not ideal (though it should be noted that this is also true of existing filesystems).  

Storing the secrets as individual objects in a bucket and encrypting them using KMS was considered more secure.  However, with the
hostkeys stored encrypted, it is no longer possible to check whether they match the plaintext hostkeys on the VM's filesystem
(at least, not without an expensive decryption), so the decision was made to store a second object in the bucket, alongside the
hostkey, containing the md5sum of the hostkey plaintext, which Ansible can quickly download and compare against the local file.


[Ansible code](https://wtr-wscm-sourcerepo.epam.com/projects/AAN/repos/gcp-ssh/browse/roles/gcp-ssh/tasks/main.yml?until=2c3b86ab18217eb2e7c2b6c6eeb9c7961e45e25a&untilPath=roles%2Fgcp-ssh%2Ftasks%2Fmain.yml)

[Terraform code](https://gitlab.com/Lz-demo-docs/pit_platform/lz-iaas/lz-iaas-landscape/blob/master/terraform/ansible.tf)

---

## Implications

This is only an interim solution, until a strategic decision about PIT-wide secret storage is available.  (Hashicorp Vault is the
current favorite).

{{<mermaid align="center">}}
%%```mermaid
sequenceDiagram
participant T as Tower
participant P as Playbook
participant G as GCP
participant V as VM Filesystem
T-->>P: Creds for Low Priv SA
P->>G: Authenticate Low Priv SA
G->>P: Download encrypted Creds for High Priv SA
G->>P: KMS decrypt Creds for High Priv SA
P->>G: Authenticate High Priv SA
loop List of valid {hostkey}s
  G-->>P: Fetch hostkey MD5 from GCS
  alt Hostkey not found in Bucket
    V->>P: Get /etc/sshd/{hostkey}
    P->>G: KMS Encrypt hostkey
    P->>G: Store encrypted hostkey
    P->>G: Store MD5 of hostkey
  else MD5 Mismatch or local hostkey missing
    G->>P: Fetch hostkey from GCS
    G->>P: KMS decrypt hostkey
    P-->>V: Store in /etc/sshd/{hostkey}
  end
end
P->>G: Revoke authentication
%%```
{{</mermaid>}}
