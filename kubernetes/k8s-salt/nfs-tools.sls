nfs-tools-install:
  pkg.installed:
    - pkgs:
      - nfs-utils
      - rpcbind
nfs-service:
  service.running:
    - name: nfs
    - enable: True
