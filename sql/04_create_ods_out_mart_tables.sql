CREATE OR REPLACE TABLE customer_consolidated (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(200),
    customer_type VARCHAR(50),
    registration_date DATE,
    status VARCHAR(50),
    street_address VARCHAR(500),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    email_address VARCHAR(255),
    phone_number VARCHAR(50),
    date_of_birth DATE,
    national_id VARCHAR(50),
    gender VARCHAR(20),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    deleted_at TIMESTAMP_NTZ,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    market_code VARCHAR(10) DEFAULT 'DK',
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE customer_consolidated CLUSTER BY (customer_id, status);

CREATE OR REPLACE TABLE customer_summary (
    customer_id VARCHAR(50) NOT NULL,
    market_code VARCHAR(10) DEFAULT 'DK',
    customer_type VARCHAR(50),
    status VARCHAR(50),
    customers_in_segment NUMBER,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

ALTER TABLE customer_summary CLUSTER BY (customer_id);

CREATE OR REPLACE TABLE contract_consolidated (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    contract_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    contract_start_date DATE,
    contract_end_date DATE,
    contract_duration_days NUMBER,
    contract_value NUMBER(18,2),
    status VARCHAR(50),
    is_active NUMBER(1,0) DEFAULT 0,
    specific_value_1 NUMBER(18,4),
    specific_value_2 VARCHAR(100),
    specific_value_3 NUMBER(18,2),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    deleted_at TIMESTAMP_NTZ,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    market_code VARCHAR(10) DEFAULT 'DK',
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE contract_consolidated CLUSTER BY (customer_id, contract_type, status);

CREATE OR REPLACE TABLE contract_summary (
    customer_id VARCHAR(50) NOT NULL,
    market_code VARCHAR(10) DEFAULT 'DK',
    contract_type VARCHAR(50),
    status VARCHAR(50),
    total_contracts NUMBER,
    total_value NUMBER(18,2),
    avg_duration_days NUMBER,
    earliest_contract_date DATE,
    latest_contract_end_date DATE,
    active_contracts NUMBER,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

ALTER TABLE contract_summary CLUSTER BY (customer_id);
