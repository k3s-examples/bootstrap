#!/bin/bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml
echo "Wating for the ingress to install (30 seconds)..."
sleep 30

TMP_FILE=ingress.yaml

cat > $TMP_FILE <<EOF 
spec:
  template:
    spec:
      hostNetwork: true
EOF

kubectl patch deployment ingress-nginx-controller -n ingress-nginx --patch "$(cat ${TMP_FILE})"

rm $TMP_FILE