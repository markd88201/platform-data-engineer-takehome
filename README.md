# Platform Engineer Take-Home

## Overview

This repository implements a secure, cost-aware AWS + Databricks data platform for ingesting and curating baseball datasets.

The focus of this implementation is:

- Infrastructure as Code (Terraform)
- Least-privilege security
- Cost governance and FinOps controls
- Idempotent data ingestion
- Correct and deterministic SQL aggregation

---

## Architecture Summary

S3 Raw Landing  
→ Databricks Job Cluster (restricted policy + Spot pool)  
→ Delta Curated Storage (partitioned by yearID)  
→ Analytics SQL layer  

---

## Infrastructure Highlights

- KMS CMK encryption for all S3 data
- TLS-only bucket access
- Public access fully blocked
- Versioning enabled on curated data
- Raw lifecycle policy (IA after 30 days, delete after 90)
- Least-privilege IAM for Databricks
- Monthly AWS budget alert (80% threshold)
- Terraform CI validation via GitHub Actions

---

## Databricks Controls

- Enforced LTS runtime
- Autotermination ≤ 15 minutes
- Spot-backed instance pool with fallback
- Worker cap (max 4)
- Job clusters only (no all-purpose clusters)
- Retry + failure notification enabled

Estimated compute savings: 40–70% via Spot + policy controls.

---

## Ingestion Design

- Reads 5 CSV datasets from S3
- Writes Delta tables to curated bucket
- Batting partitioned by yearID
- Idempotent via overwrite mode
- Lightweight DQ checks (year range, non-null teamID)
- Deterministic reruns

Production improvement would use incremental MERGE instead of overwrite.

---

## SQL Aggregate

Implements team-year efficiency metric:

- Correct aggregation before join (no double counting)
- LEFT JOIN to preserve teams without salary data
- Explicit casting to prevent integer division
- Deterministic ordering

Designed for partitioned rebuild by year.

---

## FinOps Findings

Top cost drivers:
- EC2 / Databricks compute
- DBU consumption
- S3 storage

Savings actions:
- Spot-backed pools (40–70%)
- Autotermination enforcement (20–30%)
- S3 lifecycle transition (30–50%)
- Savings Plans for steady workloads (10–30%)

Controls implemented in Terraform and cluster policies.

---

## How to Run

### Terraform

cd infra  
terraform init  
terraform validate  
terraform plan  

### Ingestion

Deploy job using job.json in Databricks.

### SQL

Run `sql/team_efficiency.sql` in Databricks SQL or warehouse.

---

## Known Gaps / Next Improvements

- Add Infracost integration in CI
- Add Delta expectations or Great Expectations
- Add incremental ingestion using MERGE
- Add automated tag compliance check
- Add workspace-level Unity Catalog RBAC

---

## Design Philosophy

Small, secure, enforceable guardrails > broad but brittle architecture.

This implementation prioritizes security, cost control, and operational simplicity.

## Tradeoffs

- Used overwrite mode for deterministic idempotency instead of incremental MERGE to keep the solution simple within the timebox.
- IAM CI role is scoped broadly for demonstration; production would scope to specific ARNs.
- TLS enforcement added at bucket policy level rather than SCP for portability.
- Basic DQ checks included; production would add data quality framework (e.g., Great Expectations).