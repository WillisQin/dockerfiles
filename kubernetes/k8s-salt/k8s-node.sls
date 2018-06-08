command-innstall:
  file.recurse:
    - name: /usr/local/bin
    - source: salt://kubernetes/files/commond
    - file_mode: 755
config-files:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://kubernetes/files/master-file/config_file
  cmd.run:
    - name: cd /etc/kubernetes && rm -f apiserver config controller-manager scheduler
config-files-chmod:
  cmd.run:
    - name: cd /etc/kubernetes/ssl && chmod 600 *key.* && cd /etc/kubernetes && chmod 600 *.kubeconfig
    - require:
      - file: config-files
flannel-install:
  pkg.installed:
    - pkgs:
      - flannel
flannel-config:
  file.managed:
    - name: /etc/sysconfig/flanneld
    - source: salt://kubernetes/files/node-file/flanneld
    - require:
      - pkg: flannel-install
flannel-service:
  file.managed:
    - name: /usr/lib/systemd/system/flanneld.service
    - source: salt://kubernetes/files/node-file/flanneld.service
    - require:
      - pkg: flannel-install
  service.running:
    - name: flanneld.service
    - enable: True
    - require:
      - pkg: flannel-install
      - file: flannel-config
      - file: flannel-service
    - watch:
      - file: flannel-config
kubelet-config:
  file.managed:
    - name: /etc/kubernetes/kubelet
    - source: salt://kubernetes/files/node-file/kubelet
    - template: jinja
    - defaults:
      IPADDR: {{ grains ['id'] }}
kubelet-service:
  cmd.run:
    - name: mkdir -p /app/kubelet
  file.managed:
    - name: /usr/lib/systemd/system/kubelet.service
    - source: salt://kubernetes/files/node-file/kubelet.service
  service.running:
    - name: kubelet.service
    - enable: True
    - require:
      - file: kubelet-config
      - file: kubelet-service
      - cmd: kubelet-service
    - watch:
      - file: kubelet-config
kube-proxy-config:
  file.managed:
    - name: /etc/kubernetes/proxy
    - source: salt://kubernetes/files/node-file/proxy
    - template: jinja
    - defaults:
      IPADDR: {{ grains ['id'] }}
kube-proxy-service:
  file.managed:
    - name: /usr/lib/systemd/system/kube-proxy.service
    - source: salt://kubernetes/files/node-file/kube-proxy.service
  service.running:
    - name: kube-proxy.service
    - enable: True
    - require:
      - file: kube-proxy-config
      - file: kube-proxy-service
    - watch:
      - file: kube-proxy-config
