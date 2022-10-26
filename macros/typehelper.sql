{% macro redshift__type_string() %}
   varchar(256)
{% endmacro %}

{% macro redshift__type_json() %}
   varchar(max)
{% endmacro %}

{% macro redshift__type_array() %}
   varchar(max)
{% endmacro %}
