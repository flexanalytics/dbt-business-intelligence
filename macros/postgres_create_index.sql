{% macro postgres_create_index(relation, field) %}
{% if target.type == 'postgres' %}
create index if not exists "{{ relation.name }}__idx_on_key" on {{ relation }} ("{{ field }}")
{% endif %}
{% endmacro %}