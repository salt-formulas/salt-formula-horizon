{%- from "horizon/map.jinja" import server with context %}

horizon_task_service_running:
  test.show_notification:
    - name: "dump_message_service_running_horizon"
    - text: "Running horizon.upgrade.service_running"

{%- if server.get('enabled', false) %}

horizon_server_services:
  service.running:
  - name: {{ server.service }}
  - enable: true

{%- endif %}
