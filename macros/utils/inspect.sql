{% macro inspect(obj) %}

    {{ log("TYPE: " ~ obj.__class__.__name__, info=True) }}

    {% if obj.__dict__ is defined %}
        {{ log(obj.__dict__ | pprint, info=True) }}
    {% else %}
        {{ log(obj | pprint, info=True) }}
    {% endif %}

{% endmacro %}