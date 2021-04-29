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

curl -sfL https://get.k3s.io | sh -s - server --node-name ${NODE_NAME} --write-kubeconfig-mode 644 --disable traefik
echo
echo Token for nodes is:
cat /var/lib/rancher/k3s/server/token