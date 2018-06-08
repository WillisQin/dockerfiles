scripts-files:
  file.recurse:
    - name: /app/scripts
    - source: salt://kubernetes/files/node-scripts
cron-root:
  file.managed:
    - name: /var/spool/cron/root
    - source: salt://kubernetes/files/node-system/root
    - user: root
    - group: root
    - mode: 600
crond-service:
  service.running:
    - name: crond
    - enable: True
    - reload: True
    - watch:
      - file: cron-root
