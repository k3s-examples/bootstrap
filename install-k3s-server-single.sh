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
read -p "Do you want to replace traefik ingress controller with nginx/ambassador ingress controller? (y/n) default y ? " REPLACE_DEFAULT_INGRESS
[ -z $REPLACE_DEFAULT_INGRESS ] && REPLACE_DEFAULT_INGRESS=y

if [ ${REPLACE_DEFAULT_INGRESS} != "n" ]; then
    echo "Installing k3s server"
    curl -sfL https://get.k3s.io | K3S_NODE_NAME=${NODE_NAME} sh -s - server --disable traefik --write-kubeconfig-mode "0644"
    kubectl config view --raw
    echo "Waiting for server to become ready (120 seconds)"
    sleep 120

    read -p "Which ingress controller would you like (nginx/amabassador) ? " INGRESS_CONTROLLER
    if [ ${INGRESS_CONTROLLER} == "nginx" ]; then
        echo "Installing nginx ingress controller"
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.46.0/deploy/static/provider/cloud/deploy.yaml
        # kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.46.0/deploy/static/provider/baremetal/deploy.yaml
        echo "Wating for the ingress to install (180 seconds)..."
        sleep 180
    fi
    if [ ${INGRESS_CONTROLLER} == "ambassador" ]; then
        kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-crds.yaml
        kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-rbac.yaml
        kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-service.yaml
    fi
    
    
else
    curl -sfL https://get.k3s.io | K3S_NODE_NAME=${NODE_NAME} sh -s - server --write-kubeconfig-mode "0644"
fi



echo "This claster token:"
cat /var/lib/rancher/k3s/server/token
