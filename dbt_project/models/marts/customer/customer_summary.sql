{{ config(
    materialized='table',
    cluster_by=['customer_id'],
    tags=['mart', 'customer', 'summary']
) }}

WITH customers AS (
    SELECT * FROM {{ ref('customer_consolidated') }}
    WHERE fl_deleted = 0
),

summary AS (
    SELECT
        customer_id,
        market_code,
        customer_type,
        status,
        COUNT(*) OVER (PARTITION BY customer_type, status) AS customers_in_segment,
        {{ current_timestamp() }} AS loaded_at
    FROM customers
)

SELECT DISTINCT * FROM summary
