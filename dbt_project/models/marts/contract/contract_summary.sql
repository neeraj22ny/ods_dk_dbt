{{ config(
    materialized='table',
    cluster_by=['customer_id'],
    tags=['mart', 'contract', 'summary']
) }}

WITH contracts AS (
    SELECT * FROM {{ ref('contract_consolidated') }}
    WHERE fl_deleted = 0
),

summary AS (
    SELECT
        customer_id,
        market_code,
        contract_type,
        status,
        COUNT(DISTINCT contract_id) AS total_contracts,
        SUM(contract_value) AS total_value,
        AVG(contract_duration_days) AS avg_duration_days,
        MIN(contract_start_date) AS earliest_contract_date,
        MAX(contract_end_date) AS latest_contract_end_date,
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_contracts,
        {{ current_timestamp() }} AS loaded_at
    FROM contracts
    GROUP BY customer_id, market_code, contract_type, status
)

SELECT * FROM summary
