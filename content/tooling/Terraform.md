---
title: "Terraform"
menuTitle: "Terraform"
weight: 20
---

Terraform is our standard tool for provisioning cloud infrastructure.  

- [Why Terraform](#why-terraform)
- [Running Terraform](#running-terraform)
- [Modules](#modules)
- [GCP Credentials - KMS](#gcp-credentials-and-gitlab-variables-kms)
- [Running Terraform manually](#running-terraform-manually)
- [Learning Resources](#learning-resources)

## Why Terraform

[HashiCorp Terraform](https://www.terraform.io/) is an open source package for defining
[infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_code),
then deploying and maintaining it across multiple cloud vendors.  It differs from proprietory, vendor-specific
offerings, such as
[Deployment Manager](https://cloud.google.com/deployment-manager/docs/),
[Resource Manager](https://azure.microsoft.com/en-us/features/resource-manager/) and
[Cloud Formation](https://aws.amazon.com/cloudformation/)
in that it is multi-cloud.  Also, rather than being a web service, it is a cross-platform executable.

NB although Terraform is multi-cloud, it does *not* provide an abstraction layer across the various cloud providers'
offerings.  So `google_compute_instance`, `azure_instance` and `aws_instance` are entirely separate resources which expect
different parameters.  Terraform allows you to deploy resources in multiple clouds from the same codebase;
it is not a "write-once-deploy-anywhere" solution.

## Running Terraform

The usual way of running Terraform in EPAM is within a GitLab pipeline, defined in your repo's [`.gitlab-ci.yml`](https://gitlab.com/demo-lz-docs/pit_platform/demo-data-platform/pdp-dsde/blob/master/.gitlab-ci.yml) file.

The best way to get started is to copy a similar repo's file, but here are some pointers...

- A docker image containing terraform, the gcloud SDK and various other useful commands is available at:
`registry.gitlab.com/epam/pit_platform/pit_platform_cloud/terraform/terraform-gcloud:v1.0`.  (Feel free to develop using :latest,
but be sure to replace with an appropriate version tag before releasing to production.)

- Store your state in a separate bucket per environment and restrict access using appropriate IAM roles.
Terrform is still immature in some regards, so reducing the blast radius in the event of a state file getting
corrupted is worthwhile.

- Use whatever git workflow your team prefers.  However be conscious that certain GCP resources either cannot be
deleted at all (eg KMS artifacts), or are subject to a soft deletion period (eg projects).  If for whatever reason
you revert someone else's code then it may be impossible for them to recreate their infrastructure without changing
their naming convention!  Be especially aware of this possibility if using feature branches, as you may not be aware
of their commit.  

- It is strongly suggested that you protect terraform apply stages behind `when:manual` gates in GitLab CI,
and pay very careful attention to any deleted reources in the `terraform plan` output, to ensure that it's not
planning to delete any un-deletable / soft deletion resources, even if it (naively) plans to recreate them
immediately afterwards.

- Enforce a code style by running `terraform fmt` before every commit, and having a validate stage in the
CI pipeline to halt otherwise.

## Modules

Use terraform modules wherever possible, rather than directly creating resources in your main code's .tf files.
This not only saves coding effort, but it also helps ensure that EPAM-wide standards, such as not locating data
outside of the EU, are more easily adhered to.

The PIT Cloud Team maintain a repository of useful terraform modules for doing common tasks such as creating
projects, storage buckets, service accounts, granting API / IAM access etc.  In addition, large projects will
wish to write their own module repos to extend these.

See the [PIT Cloud Team modules repo](https://gitlab.com/demo-lz-docs/pit_platform/pit_platform_cloud/terraform/modules).

All EPAM users have read access to all EPAM repos.  However to gain access to module code outside of your repo,
you will need to pass in a gitlab private key as an project variable, then add this to ssh-agent as part of
your pipeline code (see any PIT Cloud Team pipeline for
[an example](https://gitlab.com/demo-lz-docs/pit_platform/demo-data-platform/pdp-dsde/blob/master/.gitlab-ci.yml) )

## GCP credentials and GitLab Variables (KMS)

The service account credentials which Terraform uses to access GCP are stored in GitLab variables.  

A security requirement of the PDP project, and the de-facto standard for all PIT Cloud Team work since,
is that the credentials stored in GitLab variables are for a low-privilege service account which has no
role other than to perform a KMS decryption of the main service account's key (which is stored, KMS
encrypted, in a GCS bucket).  The main advantage of this approach is that it creates a choke point in the
authentication flow.  This means that it is both more easily monitored (eg KMS decryption events for PDP
are sent to Splunk for the attention of EPAM SecOps), and more easily controlled (eg the KMS keys for
pdp-landscape account, which is scary-powerful and rarely run, are disabled by default so that the
keys stored in the GitLab repo are completely impotent most of the time.)

The `tf_kms_service_account` module automatically handles the creation of KMS-enabled pairs of service
accounts.

Scripts to rotate keys and add the new ones to GitLab using the API can be found in existing repos.  At
the time of writing there is no standard PIT Cloud Team provided application for supporting this process (TODO).

## Running Terraform manually

You can [download](https://www.terraform.io/downloads.html), install and run terraform locally,
either within your Cloud Shell instance, or on your local laptop (assuming you have the necessary access
and mangerial permission to do so).  This can be a great time-saver when writing new code, as it avoids
pushing to GitLab and running a fresh pipeline for each attempt.  

If your team plan to maintain their own local terraform installations and test code before pushing it to
GitLab, it is recommended that you include copy-pasteable instructions in your repo's `README.md` file which
include the location of the shared state bucket and variable file for the development environment.
For [example](https://gitlab.com/demo-lz-docs/pit_platform/demo-data-platform/pdp-dsde):

```bash
terraform init -backend-config="bucket=pdpv-dsde-tf-state" terraform/
terraform plan -var-file=terraform/verif.tfvars terraform/
```

(Note that we've specified the `terraform/` directory in the command, rather than `cd`-ing into it and allowing
terraform to default to the current directory.  Both approaches work fine,
but working in a different directory means that your `.terraform` local cache directory will be created away from
your `terraform/` codebase.  This allows you to run `terraform fmt` from within the `terraform/` directory, where
it will run much faster as it won't traverse the thousands of .tf files in `.terraform`)

Avoid running `terraform apply` locally, as you will lose the audit trail provided by git version control and
pipeline output.  (In some cases this is unavoidable, for example `-operations` repos which need to be manually
run by accounts with OrgAdmin rights.)

{{% notice warning %}}
Be careful of version differences.
{{% /notice %}}
Later point releases will automatically upgrade the terraform state to the new version on any
`terraform apply`, even if `No changes. Infrastructure is up-to-date.`
Earlier point releases will refuse to run against newer releases' state files.  If you download the
latest version of terraform and run an apply against remote state used by a CI pipeline running an
older version of terraform, you may find yourself suddenly unpopular.

## Learning Resources

[Google Community tutorial](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform) - Simple
 GCP-based introduction to terraform.

[Hashicorp Terraform tutorial](https://learn.hashicorp.com/terraform/) - Somewhat biassed towards AWS / Azure.

[Google Provider Documentation](https://www.terraform.io/docs/providers/google/getting_started.html) - Bookmark this one as it'll be your main reference material.