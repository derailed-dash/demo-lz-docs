---
title: "PDP BigQuery Projects"
menuTitle: "PDP BigQuery Projects"
weight: 3
---

PDP BigQuery projects are the simplest gateway to the data in the Partnership Data Platform


## Requesting a project

Go to ServiceNow, raise a request, 
Send it to the PIT Platform Cloud Team
Get it authorised (TODO by whom?)

## Creating a PDP BigQuery project 

### PIT Platform Cloud team

* Ensure that the RITM has been suitably approved by PDP Service Owners / User Line Management
* Create a new Standard Change:  
[`GRP-001: Create BigQuery Project(s) in Partnership Data Platform (PDP)`](https://psnw.service-now.com/std_change_processor.do?v=1&sysparm_id=50c337f21bcd77c4a8240fedee4bcb76&sysparm_action=execute_producer&sysparm_ck=314fa463db497f40cd97449e3b96195489226f0a3635ced0be06f284a43385979b54b8fc&sysparm_link_parent=556d48d9dbec5fc0d624fcb6ae961984&sysparm_catalog=742ce428d7211100f2d224837e61036d&sysparm_catalog_view=catalog_default&sysparm_view=text_search)  
Copy-paste the values from the RITM
* Update the config files for the GitLab CI pipeline  
`export CHG=CHG0xxxxxx`  
`#git clone https://gitlab.com/Lz-demo-docs/pit_platform/partnership-data-platform/pdp-bigquery-projects.git`  
`#cd pdp-bigquery-projects/terraform ; git checkout master ; git pull`  
`code blueprints.tf # Add 1x stanza to the end of the file`  
`code verify.tfvars # Add 2x overrides to the end of the file`  
`code variables.tf # Add 3x stanzas from the CHG.  No punctuation in _name`  
`terraform fmt`  
`git checkout -b ${CHG}`  
`git commit -a -m ${CHG}`  
`git push --set-upstream origin ${CHG}`  
* In the [GitLab pipeline](https://gitlab.com/Lz-demo-docs/pit_platform/partnership-data-platform/pdp-bigquery-projects/pipelines)
check the plan-verify output and release the apply-verify stage
* Raise a standard change of type `GRP-001: Create BigQuery Project(s) in Partnership Data Platform (PDP)`
Create a [merge request](https://gitlab.com/Lz-demo-docs/pit_platform/partnership-data-platform/pdp-bigquery-projects/merge_requests/new), Source branch `CHGxxxxxxx` Target branch `master`; `Compare branches and continue`; `Assign to me`; `Delete source branch when merge request is accepted`; `Submit merge request`; `Merge` .
* Run the plan-live stage, check the output, and if appropriate, run the apply-live stage.
* Go into the GCP console as an org admin and manually add budget alerts for all the projects created.
