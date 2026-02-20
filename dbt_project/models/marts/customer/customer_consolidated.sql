{{ config(
    materialized='incremental',
    unique_key='pk_hash',
    cluster_by=['customer_id'],
    tags=['mart', 'customer', 'final'],
    post_hook="{{ handle_hard_deletes(this, source('ods_in_customer', 'customer'), 'pk_hash') }}"
) }}

WITH customer_driver AS (
    SELECT 
        pk_hash,
        row_hash,
        customer_id,
        customer_name,
        customer_type,
        registration_date,
        status,
        COALESCE(fl_deleted, 0) AS fl_deleted,
        loaded_at
    FROM {{ source('ods_in_customer', 'customer') }}
),

address AS (
    SELECT 
        customer_id,
        address_type,
        street_address,
        city,
        postal_code,
        country,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY is_primary DESC) AS addr_rank
    FROM {{ source('ods_in_customer', 'address') }}
    WHERE is_active = TRUE
),

email AS (
    SELECT 
        customer_id,
        email_address,
        email_type,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY is_primary DESC) AS email_rank
    FROM {{ source('ods_in_customer', 'email') }}
    WHERE is_active = TRUE
),

phone AS (
    SELECT 
        customer_id,
        phone_number,
        phone_type,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY is_primary DESC) AS phone_rank
    FROM {{ source('ods_in_customer', 'phone') }}
    WHERE is_active = TRUE
),

personal_info AS (
    SELECT 
        customer_id,
        date_of_birth,
        national_id,
        gender
    FROM {{ source('ods_in_customer', 'personal_information') }}
),

final AS (
    SELECT
        c.pk_hash,
        {{ generate_surrogate_key([
            'c.customer_id', 'c.customer_name', 'c.customer_type',
            'c.registration_date', 'c.status', 'a.street_address',
            'a.city', 'a.postal_code', 'a.country', 'e.email_address',
            'p.phone_number', 'pi.date_of_birth', 'pi.national_id', 'pi.gender'
        ]) }} AS row_hash,
        c.customer_id,
        c.customer_name,
        c.customer_type,
        c.registration_date,
        c.status,
        a.street_address,
        a.city,
        a.postal_code,
        a.country,
        e.email_address,
        p.phone_number,
        pi.date_of_birth,
        pi.national_id,
        pi.gender,
        c.fl_deleted,
        NULL::TIMESTAMP AS deleted_at,
        {{ current_timestamp() }} AS loaded_at,
        'DK' AS market_code
    FROM customer_driver c
    LEFT JOIN address a ON c.customer_id = a.customer_id AND a.addr_rank = 1
    LEFT JOIN email e ON c.customer_id = e.customer_id AND e.email_rank = 1
    LEFT JOIN phone p ON c.customer_id = p.customer_id AND p.phone_rank = 1
    LEFT JOIN personal_info pi ON c.customer_id = pi.customer_id
    {% if is_incremental() %}
        WHERE c.row_hash NOT IN (SELECT row_hash FROM {{ this }} WHERE fl_deleted = 0)
    {% endif %}
)

SELECT * FROM final
