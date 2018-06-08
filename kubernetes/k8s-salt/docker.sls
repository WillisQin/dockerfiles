
docker-rpm:
  file.recurse:
    - name: /opt/docker-rpm
    - source: salt://kubernetes/files/docker-rpm
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
docker-install:
  cmd.run:
    - name: cd /opt/docker-rpm && yum localinstall docker-engine-selinux-1.12.6-1.el7.centos.noarch.rpm -y --nogpgcheck && yum localinstall docker-engine-1.12.6-1.el7.centos.x86_64.rpm -y --nogpgcheck && mkdir -p /etc/docker
    - unless: test -d /app/docker
    - require:
      - file: docker-rpm
docker-start-file:
  file.managed:
    - name: /usr/lib/systemd/system/docker.service
    - source: salt://kubernetes/files/docker/docker.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: docker-install
docker-start-file-reload:
  cmd.run:
    - name: systemctl daemon-reload
docker-daemon-file:
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://kubernetes/files/docker/daemon.json
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: docker-install
docker-option-file:
  file.managed:
    - name: /etc/sysconfig/docker
    - source: salt://kubernetes/files/docker/docker
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: docker-install
docker-service:
  service.running:
    - name: docker.service
    - enable: True
    - watch:
      - file: docker-daemon-file
      - file: docker-option-file
