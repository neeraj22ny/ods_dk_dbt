{% macro handle_hard_deletes(target_table, driver_source, pk_column='pk_hash') %}
    {{ return(adapter.dispatch('handle_hard_deletes', 'ods_dk_dbt')(target_table, driver_source, pk_column)) }}
{% endmacro %}

{% macro default__handle_hard_deletes(target_table, driver_source, pk_column) %}
    UPDATE {{ target_table }}
    SET 
        fl_deleted = 1,
        deleted_at = {{ current_timestamp() }}
    WHERE {{ pk_column }} NOT IN (
        SELECT {{ pk_column }} FROM {{ driver_source }}
    )
    AND fl_deleted = 0;
{% endmacro %}
