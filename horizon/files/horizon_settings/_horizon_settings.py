{%- from "horizon/map.jinja" import server with context %}

{%- if server.app is defined %}
{%- set app = salt['pillar.get']('horizon:server:app:'+app_name) %}
{%- else %}
{%- set app = salt['pillar.get']('horizon:server') %}
{%- endif %}

# Specify a regular expression to validate user passwords.
# HORIZON_CONFIG["password_validator"] = {
#     "regex": '.*',
#     "help_text": _("Your password does not meet the requirements.")
# }

# Turn off browser autocompletion for the login form if so desired.
# HORIZON_CONFIG["password_autocomplete"] = "off"

# The Horizon Policy Enforcement engine uses these values to load per service
# policy rule files. The content of these files should match the files the
# OpenStack services are using to determine role based access control in the
# target installation.

SESSION_TIMEOUT = {{ server.get('session', {}).get('timeout', 3600) }}
SESSION_ENGINE = "django.contrib.sessions.backends.{{ server.get('session', {}).get('engine', 'signed_cookies') }}"
DROPDOWN_MAX_ITEMS = {{ server.get('dropdown_max_items', 30) }}

# Path to directory containing policy.json files
POLICY_FILES_PATH = "{{ server.get('policy_files_path') }}"
# Map of local copy of service policy files
POLICY_FILES = {
    {%- for policy_name, policy in app.get('policy', {}).iteritems() %}
    {%- if policy.get('enabled', True) %}
    "{{ policy_name }}": "{{ policy.get('name') }}",
    {%- endif %}
    {%- endfor %}
}

LOGGING = {
    'version': 1,
    # When set to True this will disable all logging except
    # for loggers specified in this configuration dictionary. Note that
    # if nothing is specified here and disable_existing_loggers is True,
    # django.db.backends will still log unless it is disabled explicitly.
    {# NOTE(vsaienko) django.utils.log.NullHandler was removed in Django 1.9 as it natively provided by python 2.7 #}
    {%- if server.version in ['mitaka'] %}
      {%- set null_handler_class = 'django.utils.log.NullHandler' %}
    {%- else %}
      {%- set null_handler_class = 'logging.NullHandler' %}
    {%- endif %}
    'disable_existing_loggers': False,
    'handlers': {
        'null': {
            'level': 'DEBUG',
            'class': '{{ null_handler_class }}',
        },
        'console': {
            # Set the level to "DEBUG" for verbose output logging.
            'level': 'INFO',
            'class': 'logging.StreamHandler',
        },
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            {%- if app_name is defined %}
            'filename': '/var/log/horizon/{{ app_name }}_horizon.log',
            {%- else %}
            'filename': '/var/log/horizon/horizon.log',
            {%- endif %}
        },
    },
    'loggers': {
        # Logging from django.db.backends is VERY verbose, send to null
        # by default.
        'django.db.backends': {
            'handlers': ['null'],
            'propagate': False,
        },
        {%- if server.version not in ['juno', 'liberty', 'kilo', 'mitaka', 'newton', 'ocata'] %}
        # DEBUG level for django.template starting Pike has some false positive traces, set it to INFO
        # by default. Caused by bug PROD-17558.
        'django.template': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
        {%- endif %}
        'requests': {
            'handlers': ['null'],
            'propagate': False,
        },
        'horizon': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'openstack_dashboard': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'novaclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'cinderclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'keystoneclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'glanceclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'neutronclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'heatclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'ceilometerclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'troveclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'mistralclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'swiftclient': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'openstack_auth': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'scss.expression': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'nose.plugins.manager': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'django': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False,
        },
        'iso8601': {
            'handlers': ['null'],
            'propagate': False,
        },
    }
}
