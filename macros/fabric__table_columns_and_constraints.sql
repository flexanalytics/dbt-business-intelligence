{% macro fabric__table_columns_and_constraints(relation) -%}
    {%- do log("REDIRECT!!!: " ~ relation, info=true) -%}
    {{ fabric__build_columns_constraints(relation) }}
{% endmacro %}
