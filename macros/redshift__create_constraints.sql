{# Redshift specific implementation to create a primary key #}
{%- macro redshift__create_primary_key(table_relation, column_names, verify_permissions, quote_columns=false) -%}
    {#- TODO -#}
{%- endmacro -%}



{# Redshift specific implementation to create a unique key #}
{%- macro redshift__create_unique_key(table_relation, column_names, verify_permissions, quote_columns=false) -%}
    {#- TODO -#}
{%- endmacro -%}



{# Redshift specific implementation to create a foreign key #}
{%- macro redshift__create_foreign_key(pk_table_relation, pk_column_names, fk_table_relation, fk_column_names, verify_permissions, quote_columns=true) -%}
    {#- TODO -#}
{%- endmacro -%}



{#- This macro is used in create macros to avoid duplicate PK/UK constraints
    and to skip FK where no PK/UK constraint exists on the parent table -#}
{%- macro redshift__unique_constraint_exists(table_relation, column_names) -%}
    {#- TODO -#}
{%- endmacro -%}



{#- This macro is used in create macros to avoid duplicate FK constraints -#}
{%- macro redshift__foreign_key_exists(table_relation, column_names) -%}
    {#- TODO -#}
{%- endmacro -%}


{%- macro redshift__have_references_priv(table_relation, verify_permissions) -%}
    {#- TODO -#}
{%- endmacro -%}


{%- macro redshift__have_ownership_priv(table_relation, verify_permissions) -%}
    {#- TODO -#}
{%- endmacro -%}




{#- Redshift will error if you try to truncate tables with FK constraints or tables with PK/UK constraints
    referenced by FK so we will drop all constraints before truncating tables -#}
{% macro redshift__truncate_relation(relation) -%}
    {#- TODO -#}
{% endmacro %}
