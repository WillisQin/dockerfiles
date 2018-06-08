docker-start-file:
  file.managed:
    - name: /usr/local/sbin/docker-compose
    - source: salt://kubernetes/files/docker/docker-compose
    - user: root
    - group: root
    - mode: 755
