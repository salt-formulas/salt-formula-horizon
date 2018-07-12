horizon:
  server:
    enabled: true
    version: liberty
    secret_key: secret
    session_timeout: 43200
    ssl_no_verify: false
    wsgi:
      processes: 3
      threads: 10
    bind:
      address: 127.0.0.1
      port: 80
    cache:
      engine: memcached
      prefix: 'CACHE_HORIZON'
      members: 
      - host: 127.0.0.1
        port: 11211
      - host: 127.0.0.1
        port: 11211
      - host: 127.0.0.1
        port: 11211
    identity:
      engine: keystone
      host: 127.0.0.1
      port: 5000
      api_version: 2
      encryption: ssl
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
        - oidc
        - saml2
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

haproxy:
  proxy:
    listens:
    - name: horizon
      type: horizon
      binds:
      - address: 127.0.0.1
        port: 80
      servers:
      - name: ctl01
        host: 127.0.0.1
        port: 80
        params: cookie ctl01 check inter 2000 fall 3
      - name: ctl02
        host: 127.0.0.1
        port: 80
        params: cookie ctl02 check inter 2000 fall 3
      - name: ctl03
        host: 127.0.0.1
        port: 80
        params: cookie ctl03 check inter 2000 fall 3
