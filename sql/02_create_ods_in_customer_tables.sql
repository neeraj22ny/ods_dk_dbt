CREATE OR REPLACE TABLE customer (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(200),
    customer_type VARCHAR(50),
    registration_date DATE,
    status VARCHAR(50),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash),
    UNIQUE (customer_id)
);

ALTER TABLE customer CLUSTER BY (customer_id, status);

CREATE OR REPLACE TABLE address (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    address_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    address_type VARCHAR(50),
    street_address VARCHAR(500),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE address CLUSTER BY (customer_id);

CREATE OR REPLACE TABLE email (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    email_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    email_address VARCHAR(255),
    email_type VARCHAR(50),
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE email CLUSTER BY (customer_id);

CREATE OR REPLACE TABLE phone (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    phone_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50),
    phone_type VARCHAR(50),
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE phone CLUSTER BY (customer_id);

CREATE OR REPLACE TABLE personal_information (
    pk_hash VARCHAR(32) NOT NULL,
    row_hash VARCHAR(32) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    national_id VARCHAR(50),
    gender VARCHAR(20),
    fl_deleted NUMBER(1,0) DEFAULT 0,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (pk_hash)
);

ALTER TABLE personal_information CLUSTER BY (customer_id);
