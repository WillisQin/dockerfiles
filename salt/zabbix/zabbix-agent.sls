include:
  - zabbix.zabbix-repo
zabbix-agent-install:
  pkg.installed:
    - pkgs:
      - zabbix-agent
    - require:
      - cmd: repo-zabbix
zabbix-agent-config:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix/files/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      PORT: 10050
      HOSTNAME: {{ grains['fqdn'] }}
      IPADDR: {{ grains['fqdn_ip4'][0] }}
      ZABBIX_SERVER: 10.100.146.172
    - require:
      - pkg: zabbix-agent-install
zabbix-agent-conf.d:
  file.recurse:
    - name: /etc/zabbix/zabbix_agentd.d
    - source: salt://zabbix/files/zabbix_agentd.d
    - user: zabbix
    - group: zabbix
    - file_mode: 755
    - dir_mode: 755
    - require:
      - pkg: zabbix-agent-install
zabbix-agent-service:
  service.running:
    - name: zabbix-agent
    - enable: True
    - watch:
      - file: zabbix-agent-config
      - file: zabbix-agent-conf.d
