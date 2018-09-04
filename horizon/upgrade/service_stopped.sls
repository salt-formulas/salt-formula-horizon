{%- from "horizon/map.jinja" import server with context %}

dump_notification_service_stopped_horizon:
  test.show_notification:
    - name: "dump_message_service_stopped_horizon"
    - text: "Running horizon.upgrade.service_stopped"

{%- if server.get('enabled', false) %}

horizon_server_services_stopped:
  service.dead:
  - name: {{ server.service }}
  - enable: false

{%- endif %}
