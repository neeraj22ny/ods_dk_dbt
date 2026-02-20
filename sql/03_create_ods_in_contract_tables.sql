CREATE OR REPLACE TABLE insurance_contract (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    contract_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contract_start_date DATE,
    contract_end_date DATE,
    contract_value NUMBER(18,2),
    premium_amount NUMBER(18,2),
    coverage_type VARCHAR(100),
    status VARCHAR(50),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE insurance_contract CLUSTER BY (customer_id, status);

CREATE OR REPLACE TABLE vehicle_contract (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    contract_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contract_start_date DATE,
    contract_end_date DATE,
    contract_value NUMBER(18,2),
    monthly_payment NUMBER(18,2),
    vehicle_type VARCHAR(100),
    status VARCHAR(50),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE vehicle_contract CLUSTER BY (customer_id, status);

CREATE OR REPLACE TABLE service_contract (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    contract_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contract_start_date DATE,
    contract_end_date DATE,
    contract_value NUMBER(18,2),
    service_fee NUMBER(18,2),
    service_type VARCHAR(100),
    status VARCHAR(50),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE service_contract CLUSTER BY (customer_id, status);

CREATE OR REPLACE TABLE retail_finance (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    contract_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contract_start_date DATE,
    contract_end_date DATE,
    contract_value NUMBER(18,2),
    interest_rate NUMBER(10,4),
    loan_term_months NUMBER(6,0),
    status VARCHAR(50),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE retail_finance CLUSTER BY (customer_id, status);

CREATE OR REPLACE TABLE commercial_finance (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    contract_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contract_start_date DATE,
    contract_end_date DATE,
    contract_value NUMBER(18,2),
    interest_rate NUMBER(10,4),
    facility_limit NUMBER(18,2),
    status VARCHAR(50),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE commercial_finance CLUSTER BY (customer_id, status);
