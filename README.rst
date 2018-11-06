
=====
Usage
=====

Horizon is the canonical implementation of OpenStack Dashboard, which
provides a web-based user interface to OpenStack services including Nova,
Swift, Keystone, etc.

Sample Pillars
==============

Simplest Horizon setup:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        secret_key: secret
        host:
          name: cloud.lab.cz
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          port: 11211
          prefix: 'CACHE_HORIZON'
        api_versions:
          identity: 2
        identity:
          engine: 'keystone'
          host: '127.0.0.1'
          port: 5000
        mail:
          host: '127.0.0.1'

Multidomain setup for Horizon:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        default_domain: MYDOMAIN
        multidomain: True

Simple branded Horizon:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        branding: 'OpenStack Company Dashboard'
        default_dashboard: 'admin'
        help_url: 'http://doc.domain.com'

Horizon with policy files metadata. With source mine you can obtain real
time policy file state from targeted node (OpenStack control node),
provided you have policy file published to specified grain key. Source
file will obtain static policy definition from formula files directory.

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        policy:
          identity:
            source: mine
            host: ctl01.my-domain.local
            name: keystone_policy.json
            grain_name: keystone_policy
            enabled: true
          compute:
            source: file
            name: nova_policy.json
            enabled: true
          network:
            source: file
            name: neutron_policy.json
            enabled: true
          image:
            source: file
            name: glance_policy.json
            enabled: true
          volume:
            source: file
            name: cinder_policy.json
            enabled: true
          telemetry:
            source: file
            name: ceilometer_policy.json
            enabled: true
          orchestration:
            source: file
            name: heat_policy.json
            enabled: true

Horizon with enabled SSL security (when SSL is realised by proxy):

.. code-block:: yaml

    horizon:
      server:
        enabled: True
        secure: True


Horizon package setup with SSL:

.. important:: For the sake of backwards compatibility, the ``ssl_no_verify``
               attribute defaults to ``true`` when
               ``horizon:server:identity:encryption`` is set to ``'ssl'``.

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        secret_key: MEGASECRET
        version: juno
        ssl_no_verify: false
        ssl:
          enabled: true
          authority: CA_Authority
        host:
          name: cloud.lab.cz
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          port: 11211
          prefix: 'CACHE_HORIZON'
        api_versions:
          identity: 2
        identity:
          engine: 'keystone'
          host: '127.0.0.1'
          port: 5000
        mail:
          host: '127.0.0.1'

Horizon with custom ``SESSION_ENGINE`` (default is
``signed_cookies``, valid options are: ``signed_cookies``,
``cache``, ``file``) and ``SESSION_TIMEOUT``:

.. code-block:: yaml

    horizon:
      server:
        enabled: True
        secure: True
        session:
          engine: 'cache'
          timeout: 43200

Multi-regional Horizon setup:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        secret_key: MEGASECRET
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          port: 11211
          prefix: 'CACHE_HORIZON'
        api_versions:
          identity: 2
        identity:
          engine: 'keystone'
          host: '127.0.0.1'
          port: 5000
        mail:
          host: '127.0.0.1'
        regions:
        - name: cluster1
          address: http://cluster1.example.com:5000/v2.0
        - name: cluster2
          address: http://cluster2.example.com:5000/v2.0

Configuration of LAUNCH_INSTANCE_DEFAULTS parameter:

.. code-block:: yaml

    horizon:
      server:
        launch_instance_defaults:
          config_drive: False
          enable_scheduler_hints: True
          disable_image: False
          disable_instance_snapshot: False
          disable_volume: False
          disable_volume_snapshot: False
          create_volume: False

Horizon setup with sensu plugin:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        sensu_api:
          host: localhost
          port: 4567
        plugin:
          monitoring:
            app: horizon_monitoring
            source:
              type: git
              address: git@repo1.robotice.cz:django/horizon-monitoring.git
              rev: develop

Sensu multi API:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        sensu_api:
          dc1:
            host: localhost
            port: 4567
          dc2:
            host: anotherhost
            port: 4567

Horizon setup with jenkins plugin:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        jenkins_api:
          url: https://localhost:8080
          user: admin
          password: pwd
        plugin:
          jenkins:
            app: horizon_jenkins
            source:
              type: pkg

Horizon setup with billometer plugin:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        billometer_api:
          host: localhost
          port: 9753
          api_version: 1
        plugin:
          billing:
            app: horizon_billing
            source:
              type: git
              address: git@repo1.robotice.cz:django/horizon-billing.git
              rev: develop

Horizon setup with Contrail plugin:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: icehouse
        plugin:
          contrail:
            app: contrail_openstack_dashboard
            override: true
            source:
              type: git
              address: git@repo1.robotice.cz:django/horizon-contrail.git
              rev: develop

Horizon setup with sentry log handler:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        ...
        logging:
          engine: raven
          dsn: http://pub:private@sentry1.test.cz/2

Multisite with Git source
-------------------------

Simple Horizon setup from Git repository:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          default:
            secret_key: MEGASECRET
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              rev: stable/havana
            cache:
              engine: 'memcached'
              host: '127.0.0.1'
              port: 11211
              prefix: 'CACHE_DEFAULT'
            api_versions:
              identity: 2
            identity:
              engine: 'keystone'
              host: '127.0.0.1'
              port: 5000
            mail:
              host: '127.0.0.1'

Themed multisite setup:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          openstack1c:
            secret_key: MEGASECRET1
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              rev: stable/havana
            plugin:
              contrail:
                app: contrail_openstack_dashboard
                override: true
                source:
                  type: git
                  address: git@repo1.robotice.cz:django/horizon-contrail.git
                  rev: develop
              theme:
                app: site1_theme
                source:
                  type: git
                  address: git@repo1.domain.com:django/horizon-site1-theme.git
            cache:
              engine: 'memcached'
              host: '127.0.0.1'
              port: 11211
              prefix: 'CACHE_SITE1'
            api_versions:
              identity: 2
            identity:
              engine: 'keystone'
              host: '127.0.0.1'
              port: 5000
            mail:
              host: '127.0.0.1'
          openstack2:
            secret_key: MEGASECRET2
            source:
              engine: git
              address: https://repo1.domain.com/openstack/horizon.git
              rev: stable/icehouse
            plugin:
              contrail:
                app: contrail_openstack_dashboard
                override: true
                source:
                  type: git
                  address: git@repo1.domain.com:django/horizon-contrail.git
                  rev: develop
              monitoring:
                app: horizon_monitoring
                source:
                  type: git
                  address: git@domain.com:django/horizon-monitoring.git
                  rev: develop
              theme:
                app: bootswatch_theme
                source:
                  type: git
                  address: git@repo1.robotice.cz:django/horizon-bootswatch-theme.git
                  rev: develop
            cache:
              engine: 'memcached'
              host: '127.0.0.1'
              port: 11211
              prefix: 'CACHE_SITE2'
            api_versions:
              identity: 3
            identity:
              engine: 'keystone'
              host: '127.0.0.1'
              port: 5000
            mail:
              host: '127.0.0.1'

Set advanced theme options (for Horizon version Mitaka and newer).

Full example:

.. code-block:: yaml

  horizon:
    server:
      themes:
        default: default                           # optional, default: "default"
        directory: themes                          # optional, default: "themes"
        cookie_name: theme                         # optional, default: "theme"
        available:
          default:                                 # slug
            name: "Default"                        # display name
            description: "Default style theme"
            path: "themes/default"                 # optional, default: "<directory>/<slug>", e.g. "themes/default"
            enabled: True
          material:
            name: "Material"
            description: "Google's Material Design style theme"
            path: "themes/material"
            enabled: True

Minimal example:

.. code-block:: yaml

  horizon:
    server:
      theme:
        available:
          default:                                 # slug
            name: "Default"                        # display name
            description: "Default style theme"
          material:
            name: "Material"
            description: "Google's Material Design style theme"

API versions override:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          openstack_api_overrride:
            secret_key: MEGASECRET1
            api_versions:
              identity: 3
              volume: 2
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              rev: stable/havana

Control dashboard behavior:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          openstack_dashboard_overrride:
            secret_key: password
            dashboards:
              settings:
                enabled: true
              project:
                enabled: false
                order: 10
              admin:
                enabled: false
                order: 20
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              rev: stable/juno

Enable WebSSO feature. Define a list of choices
[supported choices: oidc, saml2], ``credentials`` choice
will be automatically appended and choice description is
predefined. DEPRECATED

WebSSO with credentials and saml2:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        websso:
          login_url: "WEBROOT + 'auth/login/'"
          logout_url: "WEBROOT + 'auth/logout/'"
          login_redirect_url: "WEBROOT + 'project/'"
          websso_choices:
            - saml2

Enable WebSSO feature. Define a map of choices in the following
format: ``{"<choice_name>": {"description": "<choice_description>"}``.

WebSSO with saml2 and credentials:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        websso:
          login_url: "WEBROOT + 'auth/login/'"
          logout_url: "WEBROOT + 'auth/logout/'"
          login_redirect_url: "WEBROOT + 'project/'"
          websso_choices:
            saml2:
              description: "Security Assertion Markup Language"
            credentials:
              description: "Keystone Credentials"

WebSSO with IDP mapping:

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        websso:
          login_url: "WEBROOT + 'auth/login/'"
          logout_url: "WEBROOT + 'auth/logout/'"
          login_redirect_url: "WEBROOT + 'project/'"
          websso_choices:
            credentials:
              description: "Keystone Credentials"
            saml2:
              description: "Security Assertion Markup Language"
            oidc:
              description: "OpenID Connect"
            myidp_oidc:
              description: "Acme Corporation - OpenID Connect"
            myidp_saml2:
              description: "Acme Corporation - SAML2"
          idp_mapping:
            myidp_oidc:
              id: myidp
              protocol: oidc
            myidp_saml2:
              id: myidp
              protocol: saml2

Images upload mode:
Horizon allows to use different strategies when uploading images to glance that are
controlled by `horizon:server:images_upload_mode` pillar, possible options are
direct, ligacy, off. When `direct` mode is used CORS have to be disabled on glance
side, and client should use modern browser.

.. code-block:: yaml

    horizon:
      server:
        images_upload_mode: "direct"

Upgrades
========

Each openstack formula provide set of phases (logical bloks) that will help to
build flexible upgrade orchestration logic for particular components. The list
of phases and theirs descriptions are listed in table below:

+-------------------------------+------------------------------------------------------+
| State                         | Description                                          |
+===============================+======================================================+
| <app>.upgrade.service_running | Ensure that all services for particular application  |
|                               | are enabled for autostart and running                |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.service_stopped | Ensure that all services for particular application  |
|                               | disabled for autostart and dead                      |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.pkgs_latest     | Ensure that packages used by particular application  |
|                               | are installed to latest available version.           |
|                               | This will not upgrade data plane packages like qemu  |
|                               | and openvswitch as usually minimal required version  |
|                               | in openstack services is really old. The data plane  |
|                               | packages should be upgraded separately by `apt-get   |
|                               | upgrade` or `apt-get dist-upgrade`                   |
|                               | Applying this state will not autostart service.      |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.render_config   | Ensure configuration is rendered actual version.     +
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.pre             | We assume this state is applied on all nodes in the  |
|                               | cloud before running upgrade.                        |
|                               | Only non destructive actions will be applied during  |
|                               | this phase. Perform service built in service check   |
|                               | like (keystone-manage doctor and nova-status upgrade)|
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.upgrade.pre     | Mostly applicable for data plane nodes. During this  |
|                               | phase resources will be gracefully removed from      |
|                               | current node if it is allowed. Services for upgraded |
|                               | application will be set to admin disabled state to   |
|                               | make sure node will not participate in resources     |
|                               | scheduling. For example on gtw nodes this will set   |
|                               | all agents to admin disable state and will move all  |
|                               | routers to other agents.                             |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.upgrade         | This state will basically upgrade application on     |
|                               | particular target. Stop services, render             |
|                               | configuration, install new packages, run offline     |
|                               | dbsync (for ctl), start services. Data plane should  |
|                               | not be affected, only OpenStack python services.     |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.upgrade.post    | Add services back to scheduling.                     |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.post            | This phase should be launched only when upgrade of   |
|                               | the cloud is completed. Cleanup temporary files,     |
|                               | perform other post upgrade tasks.                    |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.verify          | Here we will do basic health checks (API CRUD        |
|                               | operations, verify do not have dead network          |
|                               | agents/compute services)                             |
+-------------------------------+------------------------------------------------------+


Read more
=========

* https://github.com/openstack/horizon
* http://dijks.wordpress.com/2012/07/06/how-to-change-screen-resolution-of-novnc-client-in-openstack-essex-dashboard-nova-horizon/


Documentation and Bugs
======================

* http://salt-formulas.readthedocs.io/
   Learn how to install and update salt-formulas

* https://github.com/salt-formulas/salt-formula-horizon/issues
   In the unfortunate event that bugs are discovered, report the issue to the
   appropriate issue tracker. Use the Github issue tracker for a specific salt
   formula

* https://launchpad.net/salt-formulas
   For feature requests, bug reports, or blueprints affecting the entire
   ecosystem, use the Launchpad salt-formulas project

* https://launchpad.net/~salt-formulas-users
   Join the salt-formulas-users team and subscribe to mailing list if required

* https://github.com/salt-formulas/salt-formula-horizon
   Develop the salt-formulas projects in the master branch and then submit pull
   requests against a specific formula

* #salt-formulas @ irc.freenode.net
   Use this IRC channel in case of any questions or feedback which is always
   welcome
