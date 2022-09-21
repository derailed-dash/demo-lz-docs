---
title: "GitLab"
menuTitle: "GitLab"
weight: 10
---

GitLab is both the standard source code repository and infrastructure automation pipeline.

## Why GitLab

GitLab is a cloud based SaaS offering.  It provides full git functionality, plus a web front end
providing extra features such as Merge Request functionality, integrated IDE etc.

It also provides a CI/CD pipeline.  This is not as fully-featured as eg a full Jenkins / Spinnaker
installation, but it is sufficiently powerful for most scenarios and is very easy to use.

GitHub is owned by Microsoft ;-)

## Users, Groups and Projects

### Access

Access to GitLab is currently on a self register basis. So long as you have a netdom account you are able to visit (currently) [gitlab.com](https://gitlab.com/Lz-demo-docs/pit_platform/) and register by yourself. Once registered ensure you set-up Two Factor Authentication for you login. The individual user (you) is responsible for ensuring their account is protected by two factor authentication and the GitLab admins audit this regularly. Failure to set this up in a timely manner is a breach of policy and may lead to account de-activation.

{{% notice warning %}}
**Disclaimer:** the cloud team are not GitLab admins. The above serves as a guide based on our experiences when first getting started. For GitLab support and questions join the comm-gitlab channel on slack where you can talk to GitLab admins and the JL community directly. See the comm-gitlab channel for information on what will change when the migration to gitlab.com happens.
{{% /notice %}}

- Repo hierarchy - TODO

## Gitlab Runners

The jobs defined in the .gitlab-ci.yml file run on "gitlab runners".  (This term is a little overloaded, as it can refer
either to the orchestration process which polls gitlab.com for jobs and arranges for them to be executed, or to the
executor processes which run the actual jobs, or to the whole system, so be aware of context!)

### List of available Gitlab Runners

- EPAM have purchased some time on the public runners provided by gitlab.com.
It is generally felt that using them is not to be encouraged, for security reasons,
though this is not EPAM-wide policy and is down to individual projects.
Avoiding their use where possible is also requested by the EPAM gitlab support team,
(who not only have to pay the bill, but also handle all the subsequent
cross-charging back to us!)

- The PDP / AW systems have GKE clusters for each system / environment combination
which run the pipelines for those systems.  The available AW/PDP runners are [documented here](https://docs.google.com/spreadsheets/d/1haqwO_7p2RGjL6lUz3XjeQk0_pkqnPl-hAloDouq47g/edit#gid=2037107266).

- The IaaS system has a GCE instance providing its runner.  It is [documented here](https://gitlab.com/Lz-demo-docs/pit_platform/pit_platform_cloud/lz-shared-gitlab/-/tree/master).

- The PIT Platform Cloud team have a pair of GKE clusters, lz-prd and lz-npd,
which contain the runners for: the APAS (legacy PDP) system; the terraform-gcloud
docker build, and various other pipelines in the team's gitlab group.  They are
[documented here](https://docs.google.com/spreadsheets/d/10mqzgZ7A21h0sPu7YzE4GhXcLg8utlGTu2PzUlnYQnU/edit#gid=0)

### Tagging

In order to run a job on a gitlab runner, it is usually necessary to add appropriate
tags to each .gitlab-ci.yml job definition, to specify which runner to use.  Eg the
verification stages of aw-landscape might contain `tags: [aw-verif]`, whereas the
live jobs in the same file would be tagged `tags: [aw-live]`.

The gitlab.com public runners, and the IaaS runner, can be used without tags, though
the former supports a range of tags in order to request particular features.  The
PDP / AW / APAS / PIT runners all require explicit tags to be used - see the
appropriate documentation for what's available.

## Security

- Access levels - TODO
- Project variables - TODO
- Protected branches - TODO

## Workflow

Cloud team had internally agreed to follow a trunk based development model for our GitLab repos. However, during development of the LZ-Demo Data Platform, we have worked alongside Appsbroker following a Git Flow workflow. So currently we are using different workflows in different places, this will be described below.

### Git Flow - Our implementation

As mentioned above, while working alongside Appsbroker we have been following a Git Flow workflow to develop Terraform code for the LZ-Demo Data Platform in GitLab. The exact workflow we have been following where a Git Flow workflow is being used is as follows:

- **Any** changes, no matter how small or big should be developed in a new feature branch
- Once feature branch development is believed to be ready to be merged, the developing engineer must squash all of their commits.
- The engineer should then open a merge request in such a way so that it requires approval from two colleagues before the merge button can be pressed. (For PDP this was so that a minimum of one EPAM Engineer and one Appsbroker engineer would review all changes, elsewhere one peer approval might be sufficient).
- Merge requests are to be reviewed by colleagues and discusions around the changes should take place in the merge request themselves. It is the responsibility of the reviewers to ensure to the best of their ability that the changes made work, and the code is of a good standard before granting approval.
- Any subsequent commits required to the merge request as an outcome of its review should be squashed again before the merge request is approved.
- Once all required approvals have been granted, the merge request can be merged to the master branch by a Senior engineer.

Read more about development styles (including git flow) [here](https://www.toptal.com/software/trunk-based-development-git-flow)

- Religious wars! - TODO
- Git flow - TODO
- GitLab flow - TODO
- Trunk-based development - TODO

## Local tools

- Cloud Shell (ssh keys)
- Git for Windows (Credentials Manager)
- VSCode (Extensions)
