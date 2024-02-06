{# default specific implementation to create a primary key #}
{%- macro default__create_primary_key(table_relation, column_names, verify_permissions, quote_columns=false, constraint_name=none, lookup_cache=none) -%}
    {#- TODO -#}
{%- endmacro -%}



{# default specific implementation to create a unique key #}
{%- macro default__create_unique_key(table_relation, column_names, verify_permissions, quote_columns=false, constraint_name=none, lookup_cache=none) -%}
    {#- TODO -#}
{%- endmacro -%}



{# default specific implementation to create a foreign key #}
{%- macro default__create_foreign_key(pk_table_relation, pk_column_names, fk_table_relation, fk_column_names, verify_permissions, quote_columns=true, constraint_name=none, lookup_cache=none) -%}
    {#- TODO -#}
{%- endmacro -%}



{#- This macro is used in create macros to avoid duplicate PK/UK constraints
    and to skip FK where no PK/UK constraint exists on the parent table -#}
{%- macro default__unique_constraint_exists(table_relation, column_names, lookup_cache=none) -%}
    {#- TODO -#}
{%- endmacro -%}



{#- This macro is used in create macros to avoid duplicate FK constraints -#}
{%- macro default__foreign_key_exists(table_relation, column_names, lookup_cache=none) -%}
    {#- TODO -#}
{%- endmacro -%}


{%- macro default__have_references_priv(table_relation, verify_permissions) -%}
    {#- TODO -#}
{%- endmacro -%}


{%- macro default__have_ownership_priv(table_relation, verify_permissions) -%}
    {#- TODO -#}
{%- endmacro -%}




{#- default will error if you try to truncate tables with FK constraints or tables with PK/UK constraints
    referenced by FK so we will drop all constraints before truncating tables -#}
{% macro default__truncate_relation(relation) -%}
    {#- TODO -#}
{% endmacro %}

{% macro default__create_not_null(table_relation, column_names, verify_permissions, quote_columns=false, lookup_cache=none) -%}
    {#- TODO -#}
{% endmacro %}
