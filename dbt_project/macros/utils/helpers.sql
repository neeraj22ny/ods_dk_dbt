{% macro generate_surrogate_key(columns) %}
    {{ return(adapter.dispatch('generate_surrogate_key', 'ods_dk_dbt')(columns)) }}
{% endmacro %}

{% macro default__generate_surrogate_key(columns) %}
    {% set column_list = [] %}
    {% for column in columns %}
        {% set _ = column_list.append("COALESCE(CAST(" ~ column ~ " AS VARCHAR), '')") %}
    {% endfor %}
    MD5({{ column_list | join(" || '|' || ") }})
{% endmacro %}

{% macro current_timestamp() %}
    {{ return(adapter.dispatch('current_timestamp', 'ods_dk_dbt')()) }}
{% endmacro %}

{% macro default__current_timestamp() %}
    CURRENT_TIMESTAMP()
{% endmacro %}
