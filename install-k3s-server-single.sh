#!/bin/bash
if [ $(id -u) -ne 0 ]; then
    echo Must run as root
    exit 1
fi

NODE_NAME=$(hostname)
# Run this on the machine you want to install k3s server.
read -p "Enter server name ($(hostname))" NODE_NAME
if [ ! -z ${NODE_NAME} ] && [ ${NODE_NAME} != $(hostname) ]; then
    hostnamectl set-hostname ${NODE_NAME}
fi

REPLACE_DEFAULT_INGRESS=y
read -p "Do you want to replace traefik ingress controller with nginx ingress controller? (y/n) default y ? " REPLACE_DEFAULT_INGRESS
[ -z $REPLACE_DEFAULT_INGRESS ] && REPLACE_DEFAULT_INGRESS=y

if [ ${REPLACE_DEFAULT_INGRESS} != "n" ]; then
    echo "Installing k3s server"
    curl -sfL https://get.k3s.io | K3S_NODE_NAME=${NODE_NAME} sh -s - server --disable traefik
    echo "Waiting for server to become ready (120 seconds)"
    sleep 120
    echo "Installing nginx ingress controller"
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml
    echo "Wating for the ingress to install (180 seconds)..."
    sleep 180

    TMP_FILE=ingress.yaml

cat > $TMP_FILE <<EOF 
spec:
template:
    spec:
    hostNetwork: true
EOF

    kubectl patch deployment ingress-nginx-controller -n ingress-nginx --patch "$(cat ${TMP_FILE})"

    rm $TMP_FILE
else
    curl -sfL https://get.k3s.io | K3S_NODE_NAME=${NODE_NAME} sh -s - server
fi



echo "This claster token:"
cat /var/lib/rancher/k3s/server/token
