{%- from "horizon/map.jinja" import server, upgrade with context %}

horizon_render_config:
  test.show_notification:
    - name: "dump_message_render_config_horizon"
    - text: "Running horizon.upgrade.render_config"

{%- if server.get('enabled', false) %}

horizon_config:
  file.managed:
  - name: {{ server.config }}
  - source: salt://horizon/files/local_settings/{{ server.version }}_settings.py
  - template: jinja
  - mode: 640
  - user: root
  - group: horizon

{%- for policy_name, policy in server.get('policy', {}).iteritems() %}

{%- if policy.get('enabled', True) %}
{%- if policy.get('source', 'file') == 'mine' %}

{%- set service_grains = salt['mine.get'](policy['host'], 'grains.items') %}
{%- set service_policy = service_grains.get(policy['host'], {}).get(policy['grain_name'], {}) %}

{%- if service_policy %}

horizon_policy_{{ policy_name }}_mine:
  file.serialize:
  - name: {{ policy.get('path', server.get('policy_files_path')) }}/{{ policy.get('name') }}
  - dataset: {{ service_policy }}
  - formatter: JSON
  - require:
    - file: horizon_config

{%- endif %}

{%- elif policy.get('source', 'file') == 'file' %}

horizon_policy_{{ policy_name }}_file:
  file.managed:
  - name: {{ policy.get('path', server.get('policy_files_path')) }}/{{ policy.get('name') }}
  - source: salt://horizon/files/policy/{{ server.version }}/{{ policy.get('name') }}
  - require:
    - file: horizon_config

{%- endif %}
{%- endif %}

{%- endfor %}

horizon_apache_config:
  file.managed:
  - name: {{ server.apache_config }}
  - source: salt://horizon/files/openstack-dashboard.conf.{{ grains.os_family }}
  - template: jinja
  - mode: 644
  - user: root
  - group: root

{%- endif %}
