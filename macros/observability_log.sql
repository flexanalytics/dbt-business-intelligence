{% macro default__log_observability() -%}
    {% do log("dbt Invocation ID: " ~ invocation_id, true) %}
    {% do log('<a href="http://flex_nuc:3030/?specs={%22filters%22:[{%22label%22:%22Command ID%22,%22id%22:%22dim_invocation.command_invocation_id%22,%22selections%22:[{%22use%22:%22' ~ invocation_id ~ '%22}]}]}#analysis/observability-report">Observability Report</a>', true) %}
{%- endmacro %}
