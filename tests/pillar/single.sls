horizon:
  server:
    enabled: true
    version: liberty
    secret_key: secret
    session_timeout: 43200
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
    websso:
      login_url: "WEBROOT + 'auth/login/'"
      logout_url: "WEBROOT + 'auth/logout/'"
      websso_choices:
        - saml2
        - oidc
    horizon_config:
      password_autocomplete: off
    openstack_neutron_network:
      enable_fip_topology_check: False
    default_domain: default
    multidomain: False
