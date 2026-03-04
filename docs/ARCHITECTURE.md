# Architecture Overview

## Data Flow

S3 Landing (Raw CSV)
  ↓
Databricks Job Cluster (restricted policy)
  ↓
Delta Curated Bucket (partitioned by yearID)
  ↓
Analytics SQL layer

---

## Security Controls

- KMS CMK encryption
- TLS-only bucket policies
- Public access blocked
- Least privilege IAM roles
- No static credentials (instance profile)

---

## Cost Controls

- Spot-backed instance pools
- Autotermination (15 min)
- Worker cap (max 4)
- S3 lifecycle to IA
- AWS budget alert at 80%