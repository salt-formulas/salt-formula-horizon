{%- from "horizon/map.jinja" import server with context %}

horizon_upgrade_verify_api:
  test.show_notification:
    - name: "dump_message_verify_api_horizon"
    - text: "Running horizon.upgrade.verify.api"

{%- if server.get('enabled', false) %}
{%- set horizon_server = '127.0.0.1' if server.get('bind', {}).get('address') == '0.0.0.0' else server.get('bind', {}).get('address') %}

horizon_http_listen:
  http.query:
    - name: http://{{ horizon_server }}:{{ server.get('bind', {}).get('port', 80) }}
    - status: 200

{%- endif %}
