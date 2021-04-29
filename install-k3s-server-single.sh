if [ $(id -u) -ne 0 ]; then
    echo Must run as root
    exit 1
fi

NODE_NAME=$(hostname)
# Run this on the machine you want to install k3s server.
read -p "Enter server name ($(hostname))" NODE_NAME
if [ ! -z ${NODE_NAME} && ${NODE_NAME} != $(hostname) ]; then
    hostnamectl set-hostname ${NODE_NAME}
fi

REPLACE_DEFAULT_INGRESS=y
read -p "Do you want to replace traefik ingress controller with nginx ingress controller? (y/n) default y" REPLACE_DEFAULT_INGRESS
[ -z $REPLACE_DEFAULT_INGRESS ] && REPLACE_DEFAULT_INGRESS=y
DISABLE_TRAEFIK_FLAG="--disable traefik"
[ $REPLACE_DEFAULT_INGRESS == "n" ] && DISABLE_TRAEFIK_FLAG=""

curl -sfL https://get.k3s.io | sh -s - server --node-name ${NODE_NAME} --write-kubeconfig-mode 644 ${DISABLE_TRAEFIK_FLAG}

if [ ! -z $DISABLE_TRAEFIK_FLAG ]; then
    echo "Installing nginx ingress controller"
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
fi

echo "This claster token:"
cat /var/lib/rancher/k3s/server/token