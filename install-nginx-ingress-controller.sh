#!/bin/bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml
sleep 30

cat > ingress.yaml <<EOF 
spec:
  template:
    spec:
      hostNetwork: true
EOF

kubectl patch deployment ingress-nginx-controller -n ingress-nginx --patch "$(cat ingress.yaml)"
