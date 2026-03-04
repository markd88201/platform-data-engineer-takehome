# FinOps Cost Analysis

## Overview

This analysis reviews AWS service spend, usage patterns, and tag coverage to identify cost drivers and actionable savings opportunities.

---

## Top Cost Drivers

(Insert aggregate findings here)

---

## Tag Coverage

(Insert % coverage findings here)

---

## Recommended Savings Actions

### 1. Spot-backed Databricks Pools
Estimated savings: 40–70% on compute

### 2. Enforce Autotermination via Cluster Policy
Estimated savings: 20–30% DBU reduction

### 3. S3 Lifecycle Optimization
Estimated savings: 30–50% on raw storage

### 4. EC2 Savings Plans
Estimated savings: 10–30% on steady workloads

---

## Implemented Controls in Code

- Restricted cluster policy limiting node size + workers
- S3 lifecycle rule transitioning to STANDARD_IA after 30 days
- AWS Budget alert at 80% threshold