{%- from "horizon/map.jinja" import server with context %}

{%- if server.app is defined %}
  {%- set app = server.app.app_name %}
{%- else %}
  {%- set app = server %}
{%- endif %}

{%- if app.openstack_cinder_features is defined %}
# The OPENSTACK_CINDER_FEATURES settings can be used to enable optional
# services provided by cinder that is not exposed by its extension API.
OPENSTACK_CINDER_FEATURES = {
  {%- for key, value in app.openstack_cinder_features.iteritems() %}
    "{{ key }}": {{ value }}{% if not loop.last %},{% endif %}
  {%- endfor %}
}
{%- endif %}
