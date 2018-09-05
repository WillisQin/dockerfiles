#!/bin/sh

for i in $(echo $@)
do
cat << EOF |calicoctl delete -f -
- apiVersion: v1
  kind: ipPool
  metadata:
    cidr: $i
  spec:
    ipip:
      enabled: true
      mode: cross-subnet
    nat-outgoing: true
    disabled: false
EOF

done
