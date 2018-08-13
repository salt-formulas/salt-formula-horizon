{%- from "horizon/map.jinja" import server with context %}

horizon_task_pkgs_latest:
  test.show_notification:
    - name: "dump_message_pkgs_latest_horizon"
    - text: "Running horizon.upgrade.pkgs_latest"

policy-rc.d_present:
  file.managed:
    - name: /usr/sbin/policy-rc.d
    - mode: 755
    - contents: |
        #!/bin/sh
        exit 101

{%- if server.get('enabled', False) %}

horizon_packages:
  pkg.latest:
  - names: {{ server.pkgs|unique }}
  - require:
    - file: policy-rc.d_present
  - require_in:
    - file: policy-rc.d_absent

horizon_apache_package_absent:
  pkg.purged:
  - name: openstack-dashboard-apache
  - require:
    - pkg: horizon_packages

{%- endif %}

{%- if server.plugin is defined %}

{%- if server.plugin.horizon_theme is defined %}

horizon_horizon_theme_package:
  pkg.latest:
  - name: {{ server.plugin.horizon_theme.source.name }}

{%- endif %}

{%- for plugin_name, plugin in server.get('plugin', {}).iteritems() %}

{%- if plugin_name != "horizon_theme" %}

horizon_{{ plugin_name }}_package:
  pkg.latest:
  - name: {{ plugin.source.name }}
  {%- if server.get('plugin', {}).horizon_theme is defined %}
  - require:
    - pkg: horizon_horizon_theme_package
  {%- endif %}

{%- endif %}

{%- endfor %}

{%- endif %}

policy-rc.d_absent:
  file.absent:
    - name: /usr/sbin/policy-rc.d

