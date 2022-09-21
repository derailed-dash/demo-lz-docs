---
title: "DR021: Log Sinks"
menuTitle: "DR021: Log Sinks"
---

## Status

<< Proposed / Accepted / Rejected / Implemented / Superseded or Deprecated (and if so by which DR) >>

## Author

James Hoare, Cloud Engineer


{{% notice warning %}}
UNFINISHED
{{% /notice %}}


## Reviewers

| Name                        | Review Date |
| --------------------------- |-------------|
| << reviewer 1 >>            | DD/MM/YYYY  |
| << reviewer 2 >>            | DD/MM/YYYY  |
| << reviewer 3 >>            | DD/MM/YYYY  |

---

## Decision

<< description of decision taken >>

A number of log sinks will be implemented in the IaaS Platform to allow Security Operations teams to monitor platform activity. Infrastructure will be created in GCP to facilitate the export of required logs to SecOps's Splunk instance on prem where they will define monitoring & alerting rules for logs of interest.

---

## Context

Security Operations require the monitoring of certain logs/metrics from the IaaS Platform. Logging sinks are a tool in GCP that can be used to achieve this and have been used in a similar integration previously for the Legacy LZ-Demo Data Platform (PDP).

Based off requirements given to use by security, we have set up the following infrastructure in the IaaS Platform

#### One GCP Project

- **pit-iaas-secops**
  - Description: A project to house any resources related to log intergation to on prem that need to reside in a GCP Project.
  - Location: **PIT Shared IaaS** Folder

#### Two log sinks

- **unix_sink**
  - Location: **PIT Shared IaaS** Folder
  - Description: A sink to capture OS level logs from UNIX machines in the IaaS Platform.
  - Filter: resource.type:gce_instance AND (logName:projects/test-iaas-nonprod/logs/secure OR logName:projects/test-iaas-nonprod/logs/audit)
  - Applies to children: True
- **windows_sink**
  - Location: **PIT Shared IaaS** Folder
  - Description: A sink to capture OS level logs from Windows machines in the IaaS Platform.
  - Filter: resource.type:gce_instance AND logName:projects/test-iaas-nonprod/logs/winevt.raw
  - Applies to children: True

#### Two Pub/Sub topics

- **unix_sink_topic**
  - Location: **pit-iaas-secops** Project
  - Description: A Pub/Sub topic to act as the destination for the **unix_sink** logging sink
- **windows_sink_topic**
  - Location: **pit-iaas-secops** Project
  - Description: A Pub/Sub topic to act as the destination for the **windows_sink** logging sink

#### Two Pub/Sub subscriptions

- **unix_sink_subscription**
  - Location: **pit-iaas-secops** Project
  - Description: A Pub/Sub subscription to the **unix_sink_topic** pub/sub topic. This subscription is required for a service account (to be used by Splunk) to pull the logs sent through the topic.
- **windows_sink_subscription**
  - Location: **pit-iaas-secops** Project
  - Description: A Pub/Sub subscription to the **windows_sink_topic** pub/sub topic. This subscription is required for a service account (to be used by Splunk) to pull the logs sent through the topic.

#### Two service accounts

- **splunk-unix-sink@pit-iaas-secops.iam.gserviceaccount.com**
  - Location: **pit-iaas-secops** Project
  - Description: A service account to be used by Splunk to pull UNIX OS logs from the IaaS Platform using the **unix_sink_subscription**
- **splunk-windows-sink@pit-iaas-secops.iam.gserviceaccount.com**
  - Location: **pit-iaas-secops** Project
  - Description: A service account to be used by Splunk to pull windows OS logs from the IaaS Platform logs using the **windows_sink_subscription**

---

## Implications 

<< What becomes easier or harder as a result of this change? >>

<< What are the consequences of the decision - e.g. technical debt, delays, cost, later review >>
