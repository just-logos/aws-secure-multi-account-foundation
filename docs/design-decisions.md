# Design Decisions

## Why a Multi-Account Architecture?
Using multiple AWS accounts reduces blast radius and enforces separation of duties
between workloads, logging, and security monitoring.

## Why Centralized Logging?
Storing logs in a dedicated logging account prevents attackers from tampering with
audit data in compromised workload accounts.

## Why Service Control Policies (SCPs)?
SCPs provide preventive guardrails that restrict risky actions across accounts and
cannot be overridden at the account level.

## Why Private Subnets Only?
Private subnets reduce the attack surface by preventing direct internet exposure
of compute resources.
