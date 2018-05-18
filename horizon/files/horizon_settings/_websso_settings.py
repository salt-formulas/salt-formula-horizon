{%- from "horizon/map.jinja" import server with context %}
{%- if server.websso is defined %}
{%- if server.websso.login_url is defined %}
LOGIN_URL = {{ server.websso.login_url }}
{%- endif %}

{%- if server.websso.logout_url is defined %}
LOGOUT_URL = {{ server.websso.logout_url }}
{%- endif %}

{%- if server.websso.login_redirect_url is defined %}
LOGIN_REDIRECT_URL = {{ server.websso.login_redirect_url }}
{%- endif %}

WEBSSO_ENABLED = True

WEBSSO_CHOICES = (
{%- if server.websso.websso_choices is mapping %}
  {%- for choice_name, choice in server.websso.websso_choices.iteritems() %}
    ("{{ choice_name  }}", _("{{ choice.get('description') }}")),
  {%- endfor %}
{%- else %}
    ("credentials", _("Keystone Credentials")),
  {%- for choice in server.websso.websso_choices %}
    {%- if 'oidc' in choice %}
    ("oidc", _("OpenID Connect")),
    {%- endif %}
    {%- if 'saml2' in choice %}
    ("saml2", _("Security Assertion Markup Language")),
    {%- endif %}
  {%- endfor %}
{%- endif %}
)

WEBSSO_INITIAL_CHOICE = "{{ server.websso.get('websso_initial_choice', 'credentials') }}"

{%- if server.websso.idp_mapping is defined %}
WEBSSO_IDP_MAPPING = {
{%- for idp_name, idp in server.websso.idp_mapping.iteritems() %}
    "{{ idp_name }}": ("{{ idp.get('id') }}", "{{ idp.get('protocol') }}"),
{%- endfor %}
}
{%- endif %}

{%- endif %}
