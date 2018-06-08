repo-zabbix:
  cmd.run:
    {% if grains['osmajorrelease'] == '5' %}
    - name: 'rpm -ivh http://mirrors.aliyun.com/zabbix/zabbix/2.4/rhel/5/x86_64/zabbix-release-2.4-1.el5.noarch.rpm'
    {% elif grains['osmajorrelease'] == '6' %}
    - name: 'rpm -ivh http://mirrors.aliyun.com/zabbix/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm'
    {% elif grains['osmajorrelease'] == '7' %}
    - name: 'rpm -ivh http://mirrors.aliyun.com/zabbix/zabbix/2.4/rhel/7/x86_64/zabbix-release-2.4-1.el7.noarch.rpm'
    {% endif %}
    - unless: test -f /etc/yum.repos.d/zabbix.repo

