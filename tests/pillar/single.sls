include:
 - .apache_single
horizon:
  server:
    enabled: true
    version: liberty
    secret_key: secret
    session_timeout: 43200
    ssl_no_verify: false
    bind:
      address: 127.0.0.1
      port: 80
    wsgi:
      processes: 3
      threads: 10
    mail:
      engine: dummy
    cache:
      engine: memcached
      prefix: 'CACHE_HORIZON'
      members:
      - host: 127.0.0.1
        port: 11211
    identity:
      engine: keystone
      port: 5000
      host: 127.0.0.1
      encryption: ssl
      api_version: 2
      endpoint_type: publicURL
    regions:
      - name: cluster1
        address: http://cluster1.example.com:5000/v2.0
      - name: cluster2
        address: http://cluster2.example.com:5000/v2.0
    websso:
      login_url: "WEBROOT + 'auth/login/'"
      logout_url: "WEBROOT + 'auth/logout/'"
      login_redirect_url: "WEBROOT + 'project/'"
      websso_choices:
        credentials:
          description: "Keystone Credentials"
        oidc:
          description: "OpenID Connect"
        saml2:
          description: "Security Assertion Markup Language"
      idp_mapping:
        myidp_openid:
          id: myidp
          protocol: openid
        myipd_mapped:
          id: myidp
          protocol: mapped
    horizon_config:
      password_autocomplete: off
    openstack_neutron_network:
      enable_fip_topology_check: False
    launch_instance_defaults:
      config_drive: False
      enable_scheduler_hints: True
      disable_image: False
      disable_instance_snapshot: False
      disable_volume: False
      disable_volume_snapshot: False
      create_volume: True
    default_domain: default
    multidomain: False
    themes:
      default: default
      directory: themes
      cookie_name: theme
      available:
        default:
          name: "Default"
          description: "Default style theme"
          path: "themes/default"
        material:
          name: "Material"
          description: "Google's Material Design style theme"
          path: "themes/material"
