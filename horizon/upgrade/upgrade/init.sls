{%- from "horizon/map.jinja" import server with context %}

horizon_upgrade:
  test.show_notification:
    - name: "dump_message_upgrade_horizon"
    - text: "Running horizon.upgrade.upgrade"

include:
 - horizon.upgrade.upgrade.pre
 - horizon.upgrade.service_stopped
 - horizon.upgrade.pkgs_latest
 - horizon.upgrade.render_config
 - horizon.upgrade.service_running
 - horizon.upgrade.upgrade.post
