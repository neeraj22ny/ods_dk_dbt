# ODS_DK_DBT

A DBT data platform for the ODS DK (Operational Data Store Denmark) project. This project is designed specifically for the Denmark market.

## Project Overview

### Architecture

```
ODS IN (Source Tables) → DBT Transformation → ODS OUT (Mart Tables)
```

**Source Tables:**
- **Customer Domain**: customer, address, email, phone, personal_information
- **Contract Domain**: insurance_contract, vehicle_contract, service_contract, retail_finance, commercial_finance

**Output Tables:**
- `customer_consolidated` - Joined customer data with SCD Type 1
- `customer_summary` - Aggregated customer metrics
- `contract_consolidated` - Combined contracts with SCD Type 1
- `contract_summary` - Aggregated contract metrics

### Key Features

1. **SCD Type 1 with Smart Soft Delete**
   - Uses `pk_hash` as primary key for incremental updates
   - Uses `row_hash` for change detection
   - Soft delete only triggers when driver table primary key is missing

2. **Smart Delete Logic**
   - Customer: Deleted only when `pk_hash` missing from customer source
   - Contract: Deleted only when `pk_hash` missing from ALL contract sources
   - Missing enrichment data (email, phone, address) does NOT trigger deletion

## Project Structure

```
ods_dk_dbt/
├── dbt_project/
│   ├── dbt_project.yml          # DBT project configuration
│   ├── profiles.yml              # Snowflake connection profiles
│   ├── models/
│   │   ├── sources/              # Source definitions by domain
│   │   │   ├── _sources.yml
│   │   │   ├── customer_sources.yml
│   │   │   └── contract_sources.yml
│   │   └── marts/                # Final output models
│   │       ├── customer/
│   │       └── contract/
│   └── macros/
│       └── scd/                  # SCD and delete detection macros
├── config/
│   └── markets/
│       └── dk.yaml               # Denmark market configuration
├── scripts/
│   ├── setup_environment.sh
│   ├── run_dbt.sh
│   └── deploy.sh
├── plans/
│   └── architecture_plan.md
├── requirements.txt
└── README.md
```

## Quick Start

### Prerequisites

- Python 3.8+
- DBT Core with Snowflake adapter
- Snowflake account with appropriate permissions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ods_dk_dbt
   ```

2. **Set up environment**
   ```bash
   ./scripts/setup_environment.sh
   ```

3. **Configure Snowflake credentials**
   
   Update `dbt_project/profiles.yml` or set environment variables:
   ```bash
   export SNOWFLAKE_ACCOUNT="your-account"
   export SNOWFLAKE_USER="your-user"
   export SNOWFLAKE_PASSWORD="your-password"
   export SNOWFLAKE_WAREHOUSE="your-warehouse"
   export SNOWFLAKE_ROLE="your-role"
   ```

4. **Test connection**
   ```bash
   cd dbt_project
   dbt debug
   ```

### Running DBT

**Run DBT:**
```bash
./scripts/run_dbt.sh run
```

**Run tests:**
```bash
./scripts/run_dbt.sh test
```

**Generate documentation:**
```bash
./scripts/run_dbt.sh docs
```

### Deployment

**Deploy to development:**
```bash
./scripts/deploy.sh dev
```

**Deploy to production:**
```bash
./scripts/deploy.sh prod
```

## Soft Delete Logic

### Customer Model

| Scenario | Action |
|----------|--------|
| Customer `pk_hash` missing from source | `fl_deleted = 1` |
| Email data missing | Keep customer, email = NULL |
| Phone data missing | Keep customer, phone = NULL |
| Address data missing | Keep customer, address = NULL |

### Contract Model

| Scenario | Action |
|----------|--------|
| Contract `pk_hash` missing from ALL sources | `fl_deleted = 1` |
| Contract exists in any source | Keep active |

## Data Quality

The project includes comprehensive data quality tests:

- Primary key uniqueness and not-null checks
- Foreign key relationship validation
- Accepted values for status fields
- Data freshness monitoring

Run all tests:
```bash
dbt test
```

## Documentation

- [Architecture Plan](plans/architecture_plan.md) - Detailed architecture documentation
- DBT Docs: Run `dbt docs generate && dbt docs serve` to view model documentation

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests: `dbt test`
4. Submit a pull request

## License

[Specify your license here]
