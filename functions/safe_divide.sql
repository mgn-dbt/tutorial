{# adaptation for postgresql #}
{% if target.type == 'postgres' %}
select case
	  when denominator = 0 then null
	  else numerator / denominator
	end;
{% else %}
case
  when denominator = 0 then null
  else numerator / denominator
end
{% endif %}