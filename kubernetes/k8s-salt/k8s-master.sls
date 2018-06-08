command-innstall:
  file.recurse:
    - name: /usr/local/bin
    - source: salt://kubernetes/files/commond
    - file_mode: 755
config-files:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://kubernetes/files/master-file/config_file
    - template: jinja
    - defaults:
      IPADDR: {{ grains ['id'] }}

config-files-chmod:
  cmd.run:
    - name: cd /etc/kubernetes/ssl && chmod 600 *key.* && cd /etc/kubernetes && chmod 600 *.kubeconfig
    - require:
      - file: config-files
kubectl-file:
  file.managed:
    - name: /root/.kube/config
    - source: salt://kubernetes/files/master-file/config
    - template: jinja
    - defaults:
      IPADDR: {{ grains ['id'] }}
  cmd.run:
    - name: chmod 600 /root/.kube/config
    - watch:
      - file: kubectl-file
service-apiserver:
  file.managed:
    - name: /usr/lib/systemd/system/kube-apiserver.service
    - source: salt://kubernetes/files/master-file/kube-apiserver.service
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: service-apiserver
  service.running:
    - name: kube-apiserver.service
    - enable: True
    - require:
      - file: command-innstall
      - file: config-files
      - file: service-apiserver
    - watch:
      - file: service-apiserver
service-controller-manager:
  file.managed:
    - name: /usr/lib/systemd/system/kube-controller-manager.service
    - source: salt://kubernetes/files/master-file/kube-controller-manager.service
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: service-controller-manager
  service.running:
    - name: kube-controller-manager.service
    - enable: True
    - require:
      - file: command-innstall
      - file: config-files
      - file: service-controller-manager
    - watch:
      - file: service-controller-manager
service-scheduler:
  file.managed:
    - name: /usr/lib/systemd/system/kube-scheduler.service
    - source: salt://kubernetes/files/master-file/kube-scheduler.service
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: service-scheduler
  service.running:
    - name: kube-scheduler.service
    - enable: True
    - require:
      - file: command-innstall
      - file: config-files
      - file: service-scheduler
    - watch:
      - file: service-scheduler

