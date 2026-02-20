INSERT INTO customer (pk_hash, row_hash, customer_id, customer_name, customer_type, registration_date, status, fl_deleted, loaded_at)
VALUES 
    ('a1b2c3d4e5f6789012345678901234ab', 'b2c3d4e5f678901234567890123456cd', 'CUST001', 'John Doe', 'INDIVIDUAL', '2023-01-15', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('c3d4e5f67890123456789012345678ef', 'd4e5f6789012345678901234567890gh', 'CUST002', 'Jane Smith', 'INDIVIDUAL', '2023-02-20', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('e5f678901234567890123456789012ij', 'f67890123456789012345678901234kl', 'CUST003', 'Acme Corporation', 'CORPORATE', '2023-03-10', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('g7890123456789012345678901234mn', 'h89012345678901234567890123456op', 'CUST004', 'Bob Wilson', 'INDIVIDUAL', '2023-04-05', 'INACTIVE', 0, CURRENT_TIMESTAMP()),
    ('i90123456789012345678901234567qr', 'j01234567890123456789012345678st', 'CUST005', 'Tech Solutions Ltd', 'CORPORATE', '2023-05-12', 'ACTIVE', 0, CURRENT_TIMESTAMP());

INSERT INTO address (pk_hash, row_hash, address_id, customer_id, address_type, street_address, city, postal_code, country, is_primary, is_active, fl_deleted, loaded_at)
VALUES 
    ('addr001hash00000000000000000001', 'addr001row00000000000000000001', 'ADDR001', 'CUST001', 'HOME', '123 Main Street', 'Copenhagen', '1000', 'Denmark', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('addr002hash00000000000000000002', 'addr002row00000000000000000002', 'ADDR002', 'CUST001', 'WORK', '456 Business Ave', 'Copenhagen', '1050', 'Denmark', FALSE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('addr003hash00000000000000000003', 'addr003row00000000000000000003', 'ADDR003', 'CUST002', 'HOME', '789 Oak Lane', 'Aarhus', '8000', 'Denmark', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('addr004hash00000000000000000004', 'addr004row00000000000000000004', 'ADDR004', 'CUST003', 'BILLING', '100 Corporate Plaza', 'Copenhagen', '1100', 'Denmark', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('addr005hash00000000000000000005', 'addr005row00000000000000000005', 'ADDR005', 'CUST005', 'HOME', '200 Tech Park', 'Odense', '5000', 'Denmark', TRUE, TRUE, 0, CURRENT_TIMESTAMP());

INSERT INTO email (pk_hash, row_hash, email_id, customer_id, email_address, email_type, is_primary, is_active, fl_deleted, loaded_at)
VALUES 
    ('email01hash0000000000000000001', 'email01row0000000000000000001', 'EMAIL001', 'CUST001', 'john.doe@email.com', 'PERSONAL', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('email02hash0000000000000000002', 'email02row0000000000000000002', 'EMAIL002', 'CUST001', 'john.doe@work.com', 'WORK', FALSE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('email03hash0000000000000000003', 'email03row0000000000000000003', 'EMAIL003', 'CUST002', 'jane.smith@email.com', 'PERSONAL', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('email04hash0000000000000000004', 'email04row0000000000000000004', 'EMAIL004', 'CUST003', 'contact@acme.com', 'WORK', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('email05hash0000000000000000005', 'email05row0000000000000000005', 'EMAIL005', 'CUST005', 'info@techsolutions.com', 'WORK', TRUE, TRUE, 0, CURRENT_TIMESTAMP());

INSERT INTO phone (pk_hash, row_hash, phone_id, customer_id, phone_number, phone_type, is_primary, is_active, fl_deleted, loaded_at)
VALUES 
    ('phone01hash0000000000000000001', 'phone01row0000000000000000001', 'PHONE001', 'CUST001', '+45 12 34 56 78', 'MOBILE', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('phone02hash0000000000000000002', 'phone02row0000000000000000002', 'PHONE002', 'CUST001', '+45 87 65 43 21', 'WORK', FALSE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('phone03hash0000000000000000003', 'phone03row0000000000000000003', 'PHONE003', 'CUST002', '+45 23 45 67 89', 'MOBILE', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('phone04hash0000000000000000004', 'phone04row0000000000000000004', 'PHONE004', 'CUST003', '+45 34 56 78 90', 'WORK', TRUE, TRUE, 0, CURRENT_TIMESTAMP()),
    ('phone05hash0000000000000000005', 'phone05row0000000000000000005', 'PHONE005', 'CUST005', '+45 45 67 89 01', 'WORK', TRUE, TRUE, 0, CURRENT_TIMESTAMP());

INSERT INTO personal_information (pk_hash, row_hash, customer_id, date_of_birth, national_id, gender, fl_deleted, loaded_at)
VALUES 
    ('pers001hash0000000000000000001', 'pers001row0000000000000000001', 'CUST001', '1985-06-15', 'DK1506851234', 'MALE', 0, CURRENT_TIMESTAMP()),
    ('pers002hash0000000000000000002', 'pers002row0000000000000000002', 'CUST002', '1990-03-22', 'DK2203905678', 'FEMALE', 0, CURRENT_TIMESTAMP()),
    ('pers003hash0000000000000000003', 'pers003row0000000000000000003', 'CUST004', '1978-11-30', 'DK3011789012', 'MALE', 0, CURRENT_TIMESTAMP());

INSERT INTO insurance_contract (pk_hash, row_hash, contract_id, customer_id, contract_start_date, contract_end_date, contract_value, premium_amount, coverage_type, status, fl_deleted, loaded_at)
VALUES 
    ('ins001hash0000000000000000001', 'ins001row0000000000000000001', 'INS001', 'CUST001', '2023-01-01', '2024-12-31', 50000.00, 500.00, 'LIFE', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('ins002hash0000000000000000002', 'ins002row0000000000000000002', 'INS002', 'CUST002', '2023-03-01', '2024-02-29', 25000.00, 250.00, 'HEALTH', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('ins003hash0000000000000000003', 'ins003row0000000000000000003', 'INS003', 'CUST003', '2023-06-01', '2024-05-31', 100000.00, 1000.00, 'PROPERTY', 'ACTIVE', 0, CURRENT_TIMESTAMP());

INSERT INTO vehicle_contract (pk_hash, row_hash, contract_id, customer_id, contract_start_date, contract_end_date, contract_value, monthly_payment, vehicle_type, status, fl_deleted, loaded_at)
VALUES 
    ('veh001hash0000000000000000001', 'veh001row0000000000000000001', 'VEH001', 'CUST001', '2023-02-01', '2026-01-31', 150000.00, 2500.00, 'CAR', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('veh002hash0000000000000000002', 'veh002row0000000000000000002', 'VEH002', 'CUST004', '2022-06-01', '2025-05-31', 80000.00, 1500.00, 'CAR', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('veh003hash0000000000000000003', 'veh003row0000000000000000003', 'VEH003', 'CUST005', '2023-09-01', '2026-08-31', 200000.00, 3500.00, 'TRUCK', 'ACTIVE', 0, CURRENT_TIMESTAMP());

INSERT INTO service_contract (pk_hash, row_hash, contract_id, customer_id, contract_start_date, contract_end_date, contract_value, service_fee, service_type, status, fl_deleted, loaded_at)
VALUES 
    ('svc001hash0000000000000000001', 'svc001row0000000000000000001', 'SVC001', 'CUST001', '2023-01-01', '2024-12-31', 5000.00, 100.00, 'MAINTENANCE', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('svc002hash0000000000000000002', 'svc002row0000000000000000002', 'SVC002', 'CUST003', '2023-04-01', '2024-03-31', 15000.00, 300.00, 'CONSULTING', 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('svc003hash0000000000000000003', 'svc003row0000000000000000003', 'SVC003', 'CUST005', '2023-07-01', '2024-06-30', 8000.00, 200.00, 'SUPPORT', 'ACTIVE', 0, CURRENT_TIMESTAMP());

INSERT INTO retail_finance (pk_hash, row_hash, contract_id, customer_id, contract_start_date, contract_end_date, contract_value, interest_rate, loan_term_months, status, fl_deleted, loaded_at)
VALUES 
    ('ret001hash0000000000000000001', 'ret001row0000000000000000001', 'RET001', 'CUST002', '2023-05-01', '2033-04-30', 500000.00, 4.5, 120, 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('ret002hash0000000000000000002', 'ret002row0000000000000000002', 'RET002', 'CUST004', '2023-08-01', '2028-07-31', 100000.00, 5.0, 60, 'ACTIVE', 0, CURRENT_TIMESTAMP());

INSERT INTO commercial_finance (pk_hash, row_hash, contract_id, customer_id, contract_start_date, contract_end_date, contract_value, interest_rate, facility_limit, status, fl_deleted, loaded_at)
VALUES 
    ('com001hash0000000000000000001', 'com001row0000000000000000001', 'COM001', 'CUST003', '2023-03-01', '2025-02-28', 2000000.00, 3.5, 5000000.00, 'ACTIVE', 0, CURRENT_TIMESTAMP()),
    ('com002hash0000000000000000002', 'com002row0000000000000000002', 'COM002', 'CUST005', '2023-06-01', '2025-05-31', 1000000.00, 3.75, 2000000.00, 'ACTIVE', 0, CURRENT_TIMESTAMP());

SELECT 'customer' AS table_name, COUNT(*) AS row_count FROM customer
UNION ALL
SELECT 'address', COUNT(*) FROM address
UNION ALL
SELECT 'email', COUNT(*) FROM email
UNION ALL
SELECT 'phone', COUNT(*) FROM phone
UNION ALL
SELECT 'personal_information', COUNT(*) FROM personal_information
UNION ALL
SELECT 'insurance_contract', COUNT(*) FROM insurance_contract
UNION ALL
SELECT 'vehicle_contract', COUNT(*) FROM vehicle_contract
UNION ALL
SELECT 'service_contract', COUNT(*) FROM service_contract
UNION ALL
SELECT 'retail_finance', COUNT(*) FROM retail_finance
UNION ALL
SELECT 'commercial_finance', COUNT(*) FROM commercial_finance;
