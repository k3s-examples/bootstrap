#!/bin/bash

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable traefik
k3s kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml

sleep 30

cat > ingress.yaml <<EOF 
spec:
  template:
    spec:
      hostNetwork: true
EOF

k3s kubectl patch deployment ingress-nginx-controller -n ingress-nginx --patch "$(cat ingress.yaml)"
sleep 30
rm ingress.yaml