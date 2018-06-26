import os

from django.utils.translation import pgettext_lazy
from django.utils.translation import ugettext_lazy as _
from openstack_dashboard import exceptions

{%- from "horizon/map.jinja" import server with context %}

{%- if server.app is defined %}
{%- set app = salt['pillar.get']('horizon:server:app:'+app_name) %}
{%- else %}
{%- set app = salt['pillar.get']('horizon:server') %}
{%- endif %}

HORIZON_CONFIG = {
    'user_home': 'openstack_dashboard.views.get_user_home',
    'ajax_queue_limit': 10,
    'auto_fade_alerts': {
        'delay': 3000,
        'fade_duration': 1500,
        'types': ['alert-success', 'alert-info']
    },
    'help_url': "{{ app.get('help_url', 'http://docs.openstack.org') }}",
    'exceptions': {'recoverable': exceptions.RECOVERABLE,
                   'not_found': exceptions.NOT_FOUND,
                   'unauthorized': exceptions.UNAUTHORIZED},
    'modal_backdrop': 'static',
    'angular_modules': [],
    'js_files': [],
    'js_spec_files': [],
    'disable_password_reveal': True,
    'password_autocomplete': 'off'
}
{%- if app.themes is defined %}
# 'key', 'label', 'path'
{%- set theme_dir = app.themes.get('directory', 'themes') %}
AVAILABLE_THEMES = [
{%- for slug, theme in app.themes.get('available', {}).iteritems() %}
  {%- if theme.get('enabled', True) %}
    (
        "{{ slug }}",
        pgettext_lazy("{{ theme.description }}", "{{ theme.name }}"),
        "{{ theme.get('path', theme_dir + '/' + slug ) }}"
    ),
  {%- endif %}
{%- endfor %}
]

# The default theme if no cookie is present
DEFAULT_THEME = '{{ app.themes.get("default", "default") }}'

# Theme Static Directory
THEME_COLLECTION_DIR = '{{ theme_dir }}'

# Theme Cookie Name
THEME_COOKIE_NAME = '{{ app.themes.get("cookie_name", "theme") }}'
{%- endif %}

INSTALLED_APPS = (
    'openstack_dashboard',
    'django.contrib.contenttypes',
    'django.contrib.auth',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.humanize',
    'compressor',
    'horizon',
    'openstack_auth',
    {%- if app.logging is defined %}
    'raven.contrib.django.raven_compat',
    {%- endif %}
)

{% include "horizon/files/horizon_settings/_local_settings.py" %}
{% include "horizon/files/horizon_settings/_horizon_settings.py" %}
{% include "horizon/files/horizon_settings/_keystone_settings.py" %}
{% include "horizon/files/horizon_settings/_nova_settings.py" %}
{% include "horizon/files/horizon_settings/_glance_settings.py" %}
{% include "horizon/files/horizon_settings/_neutron_settings.py" %}
{% include "horizon/files/horizon_settings/_heat_settings.py" %}
{% include "horizon/files/horizon_settings/_websso_settings.py" %}
{% include "horizon/files/horizon_settings/_ssl_settings.py" %}
