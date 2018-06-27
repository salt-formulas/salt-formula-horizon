{%- from "horizon/map.jinja" import server with context %}
{%- if server.enabled %}

horizon_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

horizon_apache_package_absent:
  pkg.purged:
  - name: openstack-dashboard-apache
  - require:
    - pkg: horizon_packages
  - watch_in:
    - service: horizon_services

horizon_config:
  file.managed:
  - name: {{ server.config }}
  - source: salt://horizon/files/local_settings/{{ server.version }}_settings.py
  - template: jinja
  - mode: 640
  - user: root
  - group: horizon
  - require:
    - pkg: horizon_packages

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
  - require:
    - pkg: horizon_packages

{%- if grains.os_family == 'Debian' %}
apache_enable_wsgi:
  apache_module.enabled:
    - name: wsgi

enable_horizon_apache_config:
  apache_conf.enabled:
  - name: openstack-dashboard
  - require:
    - file: horizon_apache_config
    - apache_module: apache_enable_wsgi
{%- endif %}

horizon_services:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - watch:
    - file: horizon_config
    - file: horizon_apache_config
    - file: horizon_log_file

horizon_log_dir:
  file.directory:
    - name: /var/log/horizon
    - user: horizon
    - group: adm
    - mode: 750

horizon_log_file:
  file.managed:
    - name: /var/log/horizon/horizon.log
    - user: horizon
    - group: adm
    - mode: 640
    - require:
      - file: horizon_log_dir

{%- if grains.get('virtual_subtype', None) == "Docker" %}

horizon_entrypoint:
  file.managed:
  - name: /entrypoint.sh
  - template: jinja
  - source: salt://horizon/files/entrypoint.sh
  - mode: 755

{%- endif %}

{%- endif %}
