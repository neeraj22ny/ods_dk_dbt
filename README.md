# ODS_DK_DBT - Enterprise Data Platform for Denmark Market

[![dbt](https://img.shields.io/badge/dbt-1.7+-blue.svg)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Cloud-29B5E8.svg)](https://www.snowflake.com/)
[![Market](https://img.shields.io/badge/Market-Denmark%20(DK)-green.svg)](https://en.wikipedia.org/wiki/Denmark)

## Executive Summary

This DBT project implements an enterprise-grade data transformation pipeline for the Denmark (DK) market, transforming raw operational data into business-ready analytics tables. The platform supports critical business functions including campaign management, customer onboarding, revenue analytics, and regulatory compliance.

---

## Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA FLOW ARCHITECTURE                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐                │
│  │   IDMC       │     │  ODS_DK_IN   │     │  ODS_DK_OUT  │                │
│  │   Source     │────▶│  Raw Layer   │────▶│  Transform   │                │
│  │   Systems    │     │              │     │  Layer       │                │
│  └──────────────┘     └──────────────┘     └──────────────┘                │
│                              │                      │                       │
│                              │                      ▼                       │
│                              │           ┌──────────────────┐              │
│                              │           │  Business Views  │              │
│                              │           │  (Future Layer)  │              │
│                              │           └──────────────────┘              │
│                              │                      │                       │
│                              ▼                      ▼                       │
│                    ┌─────────────────────────────────────┐                 │
│                    │        DOWNSTREAM CONSUMERS         │                 │
│                    │  ┌─────────┐ ┌─────────┐ ┌───────┐ │                 │
│                    │  │Campaign │ │Onboard- │ │Revenue│ │                 │
│                    │  │Mgmt     │ │ing      │ │Analytics│                 │
│                    │  └─────────┘ └─────────┘ └───────┘ │                 │
│                    └─────────────────────────────────────┘                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Schema Architecture

| Layer | Schema | Purpose | Data Classification |
|-------|--------|---------|---------------------|
| **ODS_DK_IN** | Source | IDMC-ingested raw data | Internal |
| **ODS_DK_OUT** | Transform | Standardized business tables | Confidential |
| **Business Views** | Reporting | Consumer-specific views | By Use Case |

---

## Data Domains

### Customer Domain

```
┌─────────────────────────────────────────────────────────────────┐
│                    CUSTOMER DOMAIN                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐            │
│  │  customer  │    │  address   │    │   email    │            │
│  │  (Driver)  │    │            │    │            │            │
│  └─────┬──────┘    └─────┬──────┘    └─────┬──────┘            │
│        │                 │                  │                    │
│        │    ┌────────────┼──────────────────┤                    │
│        │    │            │                  │                    │
│        ▼    ▼            ▼                  ▼                    │
│  ┌──────────────────────────────────────────────────┐           │
│  │           customer_consolidated                   │           │
│  │    (Customer 360 View - PII Protected)           │           │
│  └──────────────────────┬───────────────────────────┘           │
│                         │                                        │
│                         ▼                                        │
│  ┌──────────────────────────────────────────────────┐           │
│  │             customer_summary                      │           │
│  │    (Aggregated Metrics by Segment)               │           │
│  └──────────────────────────────────────────────────┘           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Contract Domain

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONTRACT DOMAIN                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐   │
│  │ insurance  │ │  vehicle   │ │  service   │ │  retail    │   │
│  │ _contract  │ │ _contract  │ │ _contract  │ │ _finance   │   │
│  └─────┬──────┘ └─────┬──────┘ └─────┬──────┘ └─────┬──────┘   │
│        │              │              │              │           │
│        └──────────────┼──────────────┼──────────────┘           │
│                       │              │                          │
│  ┌────────────┐       │              │                          │
│  │ commercial │       │              │                          │
│  │ _finance   │       │              │                          │
│  └─────┬──────┘       │              │                          │
│        │              │              │                          │
│        ▼              ▼              ▼                          │
│  ┌──────────────────────────────────────────────────┐           │
│  │           contract_consolidated                   │           │
│  │    (Unified Contract Portfolio)                  │           │
│  └──────────────────────┬───────────────────────────┘           │
│                         │                                        │
│                         ▼                                        │
│  ┌──────────────────────────────────────────────────┐           │
│  │             contract_summary                      │           │
│  │    (Aggregated Metrics by Type/Status)           │           │
│  └──────────────────────────────────────────────────┘           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Quality Framework

### Test Coverage

| Test Type | Purpose | Coverage |
|-----------|---------|----------|
| `not_null` | Ensures required fields are populated | All PK, FK, and business keys |
| `unique` | Ensures no duplicate records | All primary keys |
| `accepted_values` | Ensures valid enum values | Status, type columns |
| `relationships` | Ensures referential integrity | All foreign keys |
| `freshness` | Ensures data timeliness | All source tables |

### Data Quality Tests by Model

```
customer_consolidated:
├── PK: pk_hash (unique, not_null)
├── BK: customer_id (unique, not_null)
├── FK: customer_id → source.customer.customer_id
├── customer_type (accepted_values)
├── status (accepted_values)
├── gender (accepted_values)
├── fl_deleted (accepted_values)
└── loaded_at (not_null)

contract_consolidated:
├── PK: pk_hash (unique, not_null)
├── BK: contract_id (not_null)
├── FK: customer_id → customer_consolidated.customer_id
├── contract_type (accepted_values)
├── status (accepted_values)
├── is_active (accepted_values)
├── fl_deleted (accepted_values)
└── loaded_at (not_null)
```

---

## PII Data Classification

### Data Classification Levels

| Level | Description | Handling Requirements |
|-------|-------------|----------------------|
| **Public** | Non-sensitive, publicly available | No restrictions |
| **Internal** | Internal business data | Access limited to employees |
| **Confidential** | Sensitive business data | Need-to-know access |
| **Restricted** | Highly sensitive PII | Encryption, audit logging |

### PII Fields by Classification

```
┌─────────────────────────────────────────────────────────────────┐
│                    PII CLASSIFICATION                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  DIRECT IDENTIFIERS (Confidential)                              │
│  ├── customer_name                                               │
│  ├── street_address                                              │
│  ├── email_address                                               │
│  └── phone_number                                                │
│                                                                  │
│  SENSITIVE PII (Restricted)                                     │
│  ├── date_of_birth                                               │
│  └── national_id (CPR)                                          │
│                                                                  │
│  HANDLING REQUIREMENTS:                                          │
│  - Encryption at rest and in transit                            │
│  - Audit logging for all access                                 │
│  - Masking in non-production environments                       │
│  - GDPR data subject request support                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Lineage

### End-to-End Lineage

```
Source Tables (ODS_DK_IN)          Models (ODS_DK_OUT)         Exposures
─────────────────────────          ──────────────────          ─────────

customer ─────────────────┐
                          │
address ──────────────────┼──▶ customer_consolidated ──┬──▶ Campaign Mgmt
                          │                             │
email ────────────────────┤                             ├──▶ Onboarding
                          │                             │
phone ────────────────────┤                             └──▶ Regulatory
                          │
personal_information ─────┘
                          
                          ┌──▶ customer_summary ──────────▶ Executive Dashboard
                          │

insurance_contract ───────┐
                          │
vehicle_contract ─────────┤
                          │
service_contract ─────────┼──▶ contract_consolidated ──┬──▶ Campaign Mgmt
                          │                             │
retail_finance ───────────┤                             ├──▶ Revenue Analytics
                          │                             │
commercial_finance ───────┘                             └──▶ Regulatory
                          
                          ┌──▶ contract_summary ──────────▶ Executive Dashboard
                          │
```

---

## Governance Metadata

### Ownership Matrix

| Domain | Data Steward | Technical Owner | Business Owner |
|--------|--------------|-----------------|----------------|
| Customer | Customer Domain Team | Data Engineering | DK Market Ops |
| Contract | Contract Domain Team | Data Engineering | DK Market Ops |

### Retention Policies

| Data Type | Retention Period | Regulatory Basis |
|-----------|------------------|------------------|
| Customer PII | 7 years | Danish Financial Regulations |
| Contract Data | 10 years | Danish Financial Regulations |
| Audit Logs | 7 years | GDPR Compliance |

### Refresh Schedule

| Process | Schedule | SLA |
|---------|----------|-----|
| IDMC Data Load | Daily 20:00 CET | 2 hours |
| DBT Transformation | Daily 22:00 CET | 4 hours |
| Data Availability | Daily 06:00 CET | - |

---

## Project Structure

```
ods_dk_dbt/
├── dbt_project/
│   ├── dbt_project.yml          # Project configuration
│   ├── profiles.yml              # Connection profiles
│   ├── models/
│   │   ├── sources/              # Source definitions
│   │   │   ├── _sources.yml      # Main source config
│   │   │   ├── customer_sources.yml
│   │   │   └── contract_sources.yml
│   │   └── marts/                # Business models
│   │       ├── customer/
│   │       │   ├── _mart_customer__models.yml
│   │       │   ├── customer_consolidated.sql
│   │       │   └── customer_summary.sql
│   │       ├── contract/
│   │       │   ├── _mart_contract__models.yml
│   │       │   ├── contract_consolidated.sql
│   │       │   └── contract_summary.sql
│   │       └── exposures.yml     # Downstream consumers
│   └── macros/
│       ├── scd/                  # SCD macros
│       └── utils/                # Utility macros
├── config/
│   └── markets/
│       └── dk.yaml               # Denmark market config
├── scripts/
│   ├── run_dbt.sh                # DBT execution script
│   └── deploy.sh                 # Deployment script
├── docs/                          # GitHub Pages documentation
└── README.md
```

---

## Quick Start

### Prerequisites

- Python 3.8+
- DBT Core 1.7+
- Snowflake account with appropriate permissions

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/ods_dk_dbt.git
cd ods_dk_dbt

# Install dependencies
pip install -r requirements.txt

# Configure profiles
cp dbt_project/profiles.yml ~/.dbt/profiles.yml
# Edit with your Snowflake credentials

# Run DBT
cd dbt_project
dbt deps
dbt run
dbt test
```

### Generate Documentation

```bash
# Generate and serve documentation
dbt docs generate
dbt docs serve

# Or copy to docs folder for GitHub Pages
cp target/*.html target/*.json ../docs/
```

---

## Monitoring & Alerting

### Freshness Monitoring

| Source Table | Warn Threshold | Error Threshold |
|--------------|----------------|-----------------|
| All sources | 24 hours | 48 hours |

### Data Quality Alerts

- Test failures trigger warnings in logs
- Critical test failures halt pipeline execution
- Freshness violations trigger alerts to data team

---

## Security & Compliance

### GDPR Compliance

- **Data Subject Access**: Supported via regulatory_reporting exposure
- **Right to Erasure**: Implemented via soft delete (fl_deleted flag)
- **Data Minimization**: Only necessary PII fields collected
- **Purpose Limitation**: Data used only for documented business purposes

### Access Control

- Role-based access via Snowflake
- PII columns require elevated permissions
- Audit logging enabled for all data access

---

## Support & Contacts

| Team | Contact | Responsibility |
|------|---------|----------------|
| Data Engineering | data-engineering@company.com | Technical support |
| Customer Domain | customer-domain@company.com | Customer data questions |
| Contract Domain | contract-domain@company.com | Contract data questions |
| Compliance | compliance@company.com | GDPR/regulatory questions |

---

## License

Internal use only. © 2024 Company Name. All rights reserved.
