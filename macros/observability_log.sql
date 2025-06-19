{% macro default__log_observability() -%}
  {% do log("dbt Invocation ID: " ~ invocation_id, true) %}
  {% do log("Observability Url: " ~ 'http://flex_nuc:3030/?specs={"filters":[{"label": "Command ID", "id":"dim_invocation.command_invocation_id","selections":[{"use":"' ~ invocation_id ~ '"}]}]}#analysis/3b5c2b32-29ab-4805-b8de-f25c9261e1cc', true) %}
{%- endmacro %}
