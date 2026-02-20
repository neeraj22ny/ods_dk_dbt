{{ config(
    materialized='incremental',
    unique_key='pk_hash',
    cluster_by=['customer_id', 'contract_type'],
    tags=['mart', 'contract', 'final'],
    post_hook="{{ handle_contract_deletes(this) }}"
) }}

WITH contract_driver AS (
    SELECT 
        pk_hash,
        row_hash,
        contract_id,
        customer_id,
        'INSURANCE' AS contract_type,
        contract_start_date,
        contract_end_date,
        contract_value,
        premium_amount AS specific_value_1,
        coverage_type AS specific_value_2,
        NULL::NUMERIC AS specific_value_3,
        status,
        COALESCE(fl_deleted, 0) AS fl_deleted,
        loaded_at
    FROM {{ source('ods_in_contract', 'insurance_contract') }}
    
    UNION ALL
    
    SELECT 
        pk_hash,
        row_hash,
        contract_id,
        customer_id,
        'VEHICLE' AS contract_type,
        contract_start_date,
        contract_end_date,
        contract_value,
        monthly_payment AS specific_value_1,
        vehicle_type AS specific_value_2,
        NULL::NUMERIC AS specific_value_3,
        status,
        COALESCE(fl_deleted, 0) AS fl_deleted,
        loaded_at
    FROM {{ source('ods_in_contract', 'vehicle_contract') }}
    
    UNION ALL
    
    SELECT 
        pk_hash,
        row_hash,
        contract_id,
        customer_id,
        'SERVICE' AS contract_type,
        contract_start_date,
        contract_end_date,
        contract_value,
        service_fee AS specific_value_1,
        service_type AS specific_value_2,
        NULL::NUMERIC AS specific_value_3,
        status,
        COALESCE(fl_deleted, 0) AS fl_deleted,
        loaded_at
    FROM {{ source('ods_in_contract', 'service_contract') }}
    
    UNION ALL
    
    SELECT 
        pk_hash,
        row_hash,
        contract_id,
        customer_id,
        'RETAIL_FINANCE' AS contract_type,
        contract_start_date,
        contract_end_date,
        contract_value,
        interest_rate AS specific_value_1,
        NULL::VARCHAR AS specific_value_2,
        loan_term_months AS specific_value_3,
        status,
        COALESCE(fl_deleted, 0) AS fl_deleted,
        loaded_at
    FROM {{ source('ods_in_contract', 'retail_finance') }}
    
    UNION ALL
    
    SELECT 
        pk_hash,
        row_hash,
        contract_id,
        customer_id,
        'COMMERCIAL_FINANCE' AS contract_type,
        contract_start_date,
        contract_end_date,
        contract_value,
        interest_rate AS specific_value_1,
        NULL::VARCHAR AS specific_value_2,
        facility_limit AS specific_value_3,
        status,
        COALESCE(fl_deleted, 0) AS fl_deleted,
        loaded_at
    FROM {{ source('ods_in_contract', 'commercial_finance') }}
),

final AS (
    SELECT
        pk_hash,
        {{ generate_surrogate_key([
            'contract_id', 'customer_id', 'contract_type',
            'contract_start_date', 'contract_end_date', 'contract_value', 'status'
        ]) }} AS row_hash,
        contract_id,
        customer_id,
        contract_type,
        contract_start_date,
        contract_end_date,
        DATEDIFF(day, contract_start_date, contract_end_date) AS contract_duration_days,
        contract_value,
        status,
        CASE 
            WHEN contract_end_date >= CURRENT_DATE() AND status = 'ACTIVE' THEN 1 
            ELSE 0 
        END AS is_active,
        specific_value_1,
        specific_value_2,
        specific_value_3,
        fl_deleted,
        NULL::TIMESTAMP AS deleted_at,
        {{ current_timestamp() }} AS loaded_at,
        'DK' AS market_code
    FROM contract_driver
    {% if is_incremental() %}
        WHERE row_hash NOT IN (SELECT row_hash FROM {{ this }} WHERE fl_deleted = 0)
    {% endif %}
)

SELECT * FROM final
