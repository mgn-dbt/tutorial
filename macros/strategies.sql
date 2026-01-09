
-- funcsign: (model, string, string, config, bool) -> struct{unique_key: list[string]|string|none, updated_at: string, row_changed: string, scd_id: string, invalidate_hard_deletes: bool, hard_deletes: string}
{% macro default__snapshot_check_strategy(node, snapshotted_rel, current_rel, model_config, target_exists) %}
    {# The model_config parameter is no longer used, but is passed in anyway for compatibility. #}
    {% set check_cols_config = config.get('check_cols') %}
    {% set primary_key = config.get('unique_key') %}
    {% set hard_deletes = adapter.get_hard_deletes_behavior(config) %}
    {% set invalidate_hard_deletes = hard_deletes == 'invalidate' %}
    {% set updated_at = config.get('updated_at') or snapshot_get_time() %}

    {% set column_added = false %}

    {% set column_added, check_cols = snapshot_check_all_get_existing_columns(node, target_exists, check_cols_config) %} -- noqa: check_cols_config is a string|list[string]|none

    {%- set row_changed_expr -%}
    (
    {%- if column_added -%}
        {{ get_true_sql() }}
    {%- else -%}
    {%- for col in check_cols -%}
        {{ snapshotted_rel }}.{{ col }} != {{ current_rel }}.{{ col }}
        or
        (
            (({{ snapshotted_rel }}.{{ col }} is null) and not ({{ current_rel }}.{{ col }} is null))
            or
            ((not {{ snapshotted_rel }}.{{ col }} is null) and ({{ current_rel }}.{{ col }} is null))
        )
        {%- if not loop.last %} or {% endif -%}
    {%- endfor -%}
    {%- endif -%}
    )
    {%- endset %}

    {% set scd_args = api.Relation.scd_args(primary_key, check_cols) %} -- noqa: primary_key is a string|list[string]|none
    {% set scd_id_expr = snapshot_hash_arguments(scd_args) %}

    {% do return({
        "unique_key": primary_key,
        "updated_at": updated_at,
        "row_changed": row_changed_expr,
        "scd_id": scd_id_expr,
        "invalidate_hard_deletes": invalidate_hard_deletes,
        "hard_deletes": hard_deletes
    }) %}
{% endmacro %}
