{% macro handle_contract_deletes(target_table) %}
    {{ return(adapter.dispatch('handle_contract_deletes', 'ods_dk_dbt')(target_table)) }}
{% endmacro %}

{% macro default__handle_contract_deletes(target_table) %}
    UPDATE {{ target_table }}
    SET 
        fl_deleted = 1,
        deleted_at = {{ current_timestamp() }}
    WHERE pk_hash NOT IN (
        SELECT pk_hash FROM {{ source('ods_in_contract', 'insurance_contract') }}
        UNION
        SELECT pk_hash FROM {{ source('ods_in_contract', 'vehicle_contract') }}
        UNION
        SELECT pk_hash FROM {{ source('ods_in_contract', 'service_contract') }}
        UNION
        SELECT pk_hash FROM {{ source('ods_in_contract', 'retail_finance') }}
        UNION
        SELECT pk_hash FROM {{ source('ods_in_contract', 'commercial_finance') }}
    )
    AND fl_deleted = 0;
{% endmacro %}
