lamp-install:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - php-pdo
      - php-mysql
      - php-common
      - php-gd
      - php-mbstring
      - php-mcrypt
      - php-devel
      - php-xml
      - php-bcmath


apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://web/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      PORT: 80
      IPADDR: {{ grains['fqdn_ip4'][0] }}
    - require:
      - pkg: lamp-install

apache-auth:
  pkg.installed:
    - name: httpd-tools
    - require_in:
      - cmd: apache-auth
  cmd.run:
    - name: htpasswd -bc /etc/httpd/conf/htpasswd_file admin admin
    - unless: test -f /etc/httpd/conf/htpasswd_file

apache-conf:
  file.recurse:
    - name: /etc/httpd/conf.d
    - source: salt://web/files/apache-conf.d

php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://web/files/php.ini
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - service: lamp-service

lamp-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - watch:
      - file: apache-conf
      - file: apache-config
