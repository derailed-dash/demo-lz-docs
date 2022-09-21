---
title: "DR019: authorized_keys for AbInitio application userids"
menuTitle: "DR019: authorized_keys"
---

## Status

Implemented

## Author

Ian Harris

## Reviewers

| Name             |  Review Date |
| ---------------- |--------------|
|                  |              |

---

## Decision

* The AbInitio application users' .ssh/authorized keys files will be synced to the VM from a bucket by ansible
* The bucket will be populated from a GitLab repo by a CI pipeline
* JOL Ab Initio Operations team will have write access to the repo, and the ability to run the ansible role on demand
* The ansible role will run every 30mins throughout the day

{{<mermaid align="center">}}
%%```mermaid
graph LR
U1(fa:fa-user Occasional user)  --> C
U2(fa:fa-user-graduate Power user)  --> L
C(fa:fa-globe WebIDE) --> R
L(fa:fa-edit VSCode) --> R
R(fa:fa-folder-open Git repo) -->|GitLab CI|B(fa:fa-cloud Bucket)
B --> |Ansible| V(fa:fa-server Gateway VM)
%%```
{{</mermaid>}}

---

## Context

Whereas human users (eg `iharrisa`) must SSH to the Gateway using their AD password, local application IDs (eg `t_wtr`)
must not have passwords and must use public key exchange.  This presents the question of how to maintain these users'
`.ssh/authorized keys` files on the VM, to ensure they hold the public keys of all the application IDs on the on-prem 
run hosts (eg `utaetla2:~t_wtr_bi/.ssh/id_rsa.pub`).

There is a strong desire to keep the VMs as stateless as possible.  There is also a desire to use devops principles
and require admin activities to be funnelled through a CI/CD pipeline providing security, auditing, automated backout etc. Potential solutions involving persisting the VM's /home filesystem were therefore rejected.

The ansible playbook already had the means to securely authenticate to GCP.  Therefore it was decided to store the
'master' versions of the authorized_keys file in a GCP storage bucket.  The ansible playbook also already had loops to
create the local application users and groups, so it was relatively simple to add a similar loop for the authorized_keys.
Because the files are remotely stored, md5sums are first compared, to determine whether a particular file has changed.

With the file mirroring successfully in place, a means of allowing the JOL AbInitio Support team to update them was needed.
The option of simply granting write access to the bucket was rejected.  Whilst it would have worked, there is no nice
GUI for making such edits within the console, so users would need to copy the files to their laptop, edit them, then copy
them back.  Audit trails would have been lacking and, even with versioning enabled on the bucket, backing out changes would be
troublesome.  Storing the files in a git repo, and syncing the repo to the bucket using GitLab CI seemed a much
cleaner approach.  The only niggle here is that the JOL Ab Initio Support team have little prior experience of GitLab.
(However the same is true of the GCP console, and at least the GitLab console provides a Web IDE).

[Terraform code](https://gitlab.com/Lz-demo-docs/pit_platform/lz-iaas/abinitio/blob/master/terraform/authorized_keys.tf) to create bucket

[Ansible code](https://wtr-wscm-sourcerepo.epam.com/projects/AAN/repos/lz-install-abinitio/browse/tasks/create_users.yml?at=refs%2Fheads%2Fdevel#133) for syncing bucket to VM

[GitLab CI](https://gitlab.com/Lz-demo-docs/pit_platform/lz-iaas/abinitio-ops) for syncing repo to bucket

Shell command for impatient Gateway VM users to trigger 
[Ansible Tower template](https://lz-ansible-tower.epam.com/#/templates/job_template/199)  
`eval $(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/deployment-script-1" -H "Metadata-Flavor: Google")`

---

## Implications

* There are now three versions of the truth [GitLab, Bucket, VM] and the potential for things to get out of sync
* The JOL Ab Initio Support team need GitLab accounts and additional documentation
* The solution should be easily extendable to persist files other than authorized_keys
* The files are stored unencrypted in GitLab, so this solution is not suitable for files containing secrets
