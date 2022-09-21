---
title: "DR015: Automatic Stop/Start of instances"
menuTitle: "DR015: Automatic Stop/Start of instances"
---

## Status

Accepted

## Author

James Hoare, Cloud Infrastructure Engineer

## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| Adrian Edwards              | 02/09/2019  |
| << reviewer 2 >>            | DD/MM/YYYY  |
| << reviewer 3 >>            | DD/MM/YYYY  |

---

## Decision

The decision taken here is to implement automation around starting and stopping instances at set times to reduce cost.

---

## Context

By implementing automation to stop and start instances at set times we can reduce costs significantly. All IaaS use cases should have a **minimum** of two environments - this currently means potentially many duplicate instances running all the time. Not all environments need to be running 24/7 however, so by automating scheduled shut downs and startups of non critical instances we can reduce the costs of running multiple environments.

## Implementation

Each individual Service Project inside the IaaS Platform will come bootstrapped with the functionality for the auto stop/start of instances. This is done by including the following components in an "IaaS Project" (**NB: This entire implentation is done through terraform.**):

### Pub/Sub topics

Each Service Project will contain two pub/sub topics as follows. These topics are in place for the respective scheduled tasks (detailed below) to use as a trigger for the respective Cloud Functions (also detailed bewlow).

#### start_gce_instances

This topic is in place to act as the trigger for the start_gce_instances Cloud Function.

#### stop_gce_instances

This topic is in place to act as the trigger for the stop_gce_instances Cloud Function.

### Cloud Functions

Each Service Project will contain two Cloud Functions as follows. These Cloud Functions are in place to do the stopping/starting of instances based on the information passed through its trigger topic from its respective cloud scheduler task.

#### start_gce_instances

This function will start instances based on the JSON message that triggers it (detailed below). The function source code is managed in the [lz-shared-functions](https://gitlab.com/Lz-demo-docs/pit_platform/pit_platform_cloud/lz-shared-functions) GitLab repo. The [lz-shared-functions](https://gitlab.com/Lz-demo-docs/pit_platform/pit_platform_cloud/lz-shared-functions) GitLab repo uploads Cloud Function source code to buckets in the [lz-shared-functions](https://console.cloud.google.com/compute/instances?project=lz-shared-functions) GCP Project. Terraform is then able to point to the buckets for the source code when setting these functions up for the Service Projects. This also allows the source code for these shared functions to be used outside of the IaaS Platform in the future.

JSON Message format:

```
{
   "projects":[
      {
         "project_id":"example-npd",
         "zones":[
            "europe-west2-a",
            "europe-west2-b",
            "europe-west2-c"
         ],
         "labels":[
            "environment=dev",
            "environment=rel",
            "environment=tst"
         ]
      }
   ]
}
```

**project_id** : The project in which to look for instances. Must be the project ID for the project the pub/sub topics, Cloud Functions and Cloud Schedular Tasks reside in.  
**zones** : A list of zones in which to look for instances. Currently the IaaS Platform is only using the europe-west2 region, so the zones list will mirror this. However, other zones may be used in the future, so this solution caters for that eventuality.  
**labels**: A list of labels for the instance filter. The Function will only operate on instances with a label matching one or more of those in the list. To match all instances, omit this field, or provide an empty list.  

**In short, any instance matching the project, one of the zones and one or more of the labels, will be affected by this Cloud Function.**

{{% notice tip %}}
A label with a **key** of **ignore_start_vm** and a **value** of **true** will be ignored by this Cloud Function, even if it matches the project, zone and label definitions.
{{% /notice %}}

#### stop_gce_instances

This function will stop instances based on the JSON message that triggers it (detailed below). The function source code is managed in the [lz-shared-functions](https://gitlab.com/Lz-demo-docs/pit_platform/pit_platform_cloud/lz-shared-functions) GitLab repo. The [lz-shared-functions](https://gitlab.com/Lz-demo-docs/pit_platform/pit_platform_cloud/lz-shared-functions) GitLab repo uploads Cloud Function source code to buckets in the [lz-shared-functions](https://console.cloud.google.com/compute/instances?project=lz-shared-functions) GCP Project. Terraform is then able to point to the buckets for the source code when setting these functions up for the Service Projects. This also allows the source code for these shared functions to be used outside of the IaaS Platform in the future.

JSON Message format:

```
{
   "projects":[
      {
         "project_id":"example-npd",
         "zones":[
            "europe-west2-a",
            "europe-west2-b",
            "europe-west2-c"
         ],
         "labels":[
            "environment=dev",
            "environment=rel",
            "environment=tst"
         ]
      }
   ]
}
```

**project_id** : The project in which to look for instances. Must be the project ID for the project the pub/sub topics, Cloud Functions and Cloud Schedular Tasks reside in.  
**zones** : A list of zones in which to look for instances. Currently the IaaS Platform is only using the europe-west2 region, so the zones list will mirror this. However, other zones may be used in the future, so this solution caters for that eventuality.  
**labels**: A list of labels for the instance filter. The Function will only operate on instances with a label matching one or more of those in the list. To match all instances, omit this field, or provide an empty list.  

**In short, any instance matching the project, one of the zones and one or more of the labels, will be affected by this Cloud Function.**

{{% notice tip %}}
A label with a **key** of **ignore_stop_vm** and a **value** of **true** will be ignored by this Cloud Function, even if it matches the project, zone and label definitions.
{{% /notice %}}

### Cloud Scheduler Tasks

Each Service Project will contain two Cloud Scheduler Tasks as follows. These Cloud Scheduler Tasks are in place to send a JSON message through its respective pub/sub topic on a defined schedule to trigger the functions to start/stop instances as needed. At the time of writing, Cloud Scheduler requires App Engine to be enabled in the project.

#### start_gce_instances

This task will send a JSON message through its corresponding pub/sub topic at a defined interval (cron format). This will in turn trigger its corresponding Cloud Function to start up any GCE instances matched by the information in the JSON message.

The schedule for this task should be defined during the onboarding process, working with the customer to find the correct schedule. As each project has it's own set of Tasks, Functions and Topics, the schedules can be different in each project allowing us to be flexible.

Equally, the set of instances to be affected by this task should be defined during the onboarding process and the JSON message configured accordingly. Similar to above, as each project has its own set of Tasks, Functions and Topics, the JSON messages passed by tasks can be different in each project allowing us to be flexible in which instances are affected by which tasks where.

#### stop_gce_instances

This task will send a JSON message through its corresponding pub/sub topic at a defined interval (cron format). This will in turn trigger its corresponding Cloud Function to stop any GCE instances matched by the information in the JSON message.

The schedule for this task should be defined during the onboarding process, working with the customer to find the correct schedule. As each project has it's own set of Tasks, Functions and Topics, the schedules can be different in each project allowing us to be flexible.

Equally, the set of instances to be affected by this task should be defined during the onboarding process and the JSON message configured accordingly. Similar to above, as each project has its own set of Tasks, Functions and Topics, the JSON messages passed by tasks can be different in each project allowing us to be flexible in which instances are affected by which tasks where.

---

## Implications

- App Ops will need a way to self restart VM's Out of Hours for events such as emergency Changes.
- App Ops will need a way to add vm's to an ignore list incase instances need to be ignored by scheduled tasks for whatever reason.

