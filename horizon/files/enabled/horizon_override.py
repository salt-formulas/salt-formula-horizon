{%- from "horizon/map.jinja" import server with context %}
{%- set app = salt['pillar.get']('horizon:server:app:'+app_name) %}

ALLOWED_HOSTS = ['*']

SECRET_KEY = '{{ app.secret_key }}'

{% include "horizon/files/local_settings/_keystone_settings.py" %}

{%- if app.plugin.merlin_panels is defined %}

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/srv/horizon/sites/{{ app_name }}/database.db',
        'TEST_NAME': 'test_db:', 
    }
}

{%- endif %}
